from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field, validator
import numpy as np
import joblib
import os
from datetime import datetime
from typing import Dict, Any

app = FastAPI(
    title="Credit Risk ML API",
    description="Production-ready ML API for credit risk assessment",
    version="2.0.0"
)

# Pydantic Models para validação automática
class CreditRiskRequest(BaseModel):
    customer_age: int = Field(..., ge=18, le=100, description="Customer age")
    annual_income: float = Field(..., ge=0, description="Annual income in USD")
    employment_length: int = Field(..., ge=0, le=50, description="Years employed")
    loan_amount: float = Field(..., ge=1000, description="Requested loan amount")
    credit_score: int = Field(..., ge=300, le=850, description="Credit score")
    debt_to_income: float = Field(..., ge=0, le=1, description="Debt to income ratio")

class CreditRiskResponse(BaseModel):
    prediction: str = Field(..., description="Risk level: LOW, MEDIUM, HIGH")
    probability: float = Field(..., description="Default probability")
    risk_score: int = Field(..., description="Risk score 0-1000")
    recommendation: str = Field(..., description="Loan recommendation")
    model_version: str = Field(..., description="Model version")
    processing_time_ms: float = Field(..., description="Processing time")

# Mock Model Manager (para desenvolvimento local)
class MockMLModel:
    def __init__(self):
        self.version = "XGBoost-v2.1.0-Mock"
    
    def predict_proba(self, features):
        # Lógica heurística baseada em regras financeiras
        age, income, emp_len, loan_amt, credit_score, debt_ratio = features[0]
        
        risk_score = 0.1  # Base risk
        
        if credit_score < 650:
            risk_score += 0.3
        if debt_ratio > 0.4:
            risk_score += 0.25
        if income < 40000:
            risk_score += 0.2
        if emp_len < 2:
            risk_score += 0.15
        
        prob_default = min(risk_score, 0.9)
        return np.array([[1-prob_default, prob_default]])

model = MockMLModel()

@app.get("/")
def root():
    return {
        "api": "Credit Risk ML API",
        "developer": "Kaio Henrique",
        "status": "ready",
        "docs": "/docs"
    }

@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat(),
        "model_loaded": True
    }

@app.post("/predict", response_model=CreditRiskResponse)
def predict_credit_risk(request: CreditRiskRequest):
    start_time = datetime.now()
    
    try:
        # Preparar features
        features = np.array([[
            request.customer_age,
            request.annual_income,
            request.employment_length,
            request.loan_amount,
            request.credit_score,
            request.debt_to_income
        ]])
        
        # Predição
        probabilities = model.predict_proba(features)
        default_prob = probabilities[0][1]
        
        # Classificação
        if default_prob < 0.3:
            risk_level, recommendation = "LOW", "APPROVE"
        elif default_prob < 0.6:
            risk_level, recommendation = "MEDIUM", "REVIEW"
        else:
            risk_level, recommendation = "HIGH", "REJECT"
        
        processing_time = (datetime.now() - start_time).total_seconds() * 1000
        
        return CreditRiskResponse(
            prediction=risk_level,
            probability=default_prob,
            risk_score=int(default_prob * 1000),
            recommendation=recommendation,
            model_version=model.version,
            processing_time_ms=processing_time
        )
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

from fasthtml.common import *
import httpx

# App simples sem bugs
app, rt = fast_app(
    hdrs=[
        Meta(charset="utf-8"),
        Meta(name="viewport", content="width=device-width, initial-scale=1"),
        # Usar Tailwind via CDN moderno (sem conflitos)
        Script(src="https://cdn.tailwindcss.com"),
        Script(src="https://unpkg.com/htmx.org@1.9.6"),
    ]
)


@rt("/")
def home():
    return Div(
        H1(
            "🎯 Credit Risk ML API",
            cls="text-4xl font-bold text-center text-blue-600 mb-8",
        ),
        P(
            "Professional ML Engineering Portfolio",
            cls="text-center text-gray-600 mb-8",
        ),
        Div(
            A(
                "🚀 Try Demo",
                href="/demo",
                cls="bg-blue-600 text-white px-6 py-3 rounded-lg font-bold hover:bg-blue-700 mr-4",
            ),
            A(
                "📊 API Docs",
                href="http://localhost:8000/docs",
                target="_blank",
                cls="border-2 border-blue-600 text-blue-600 px-6 py-3 rounded-lg font-bold hover:bg-blue-600 hover:text-white",
            ),
            cls="text-center",
        ),
        cls="max-w-4xl mx-auto py-16 px-6",
    )


@rt("/demo")
def demo():
    return Div(
        H1("Credit Risk Assessment", cls="text-3xl font-bold mb-8 text-center"),
        Form(
            Div(
                Label("Age:", cls="block mb-2 font-medium"),
                Input(
                    type="number",
                    name="customer_age",
                    value="35",
                    cls="w-full p-3 border rounded-lg mb-4",
                ),
                Label("Annual Income ($):", cls="block mb-2 font-medium"),
                Input(
                    type="number",
                    name="annual_income",
                    value="75000",
                    cls="w-full p-3 border rounded-lg mb-4",
                ),
                Label("Credit Score:", cls="block mb-2 font-medium"),
                Input(
                    type="number",
                    name="credit_score",
                    value="720",
                    cls="w-full p-3 border rounded-lg mb-6",
                ),
                Button(
                    "Analyze Risk",
                    type="submit",
                    cls="w-full bg-blue-600 text-white py-3 rounded-lg font-bold hover:bg-blue-700",
                ),
                cls="max-w-md mx-auto",
            ),
            hx_post="/predict",
            hx_target="#results",
        ),
        Div(id="results", cls="mt-8 max-w-md mx-auto"),
        cls="max-w-4xl mx-auto px-6 py-12",
    )


@rt("/predict", methods=["POST"])
async def predict(request: Request):
    try:
        form_data = await request.form()

        # Simplificar payload
        payload = {
            "customer_age": int(form_data.get("customer_age", 35)),
            "annual_income": float(form_data.get("annual_income", 75000)),
            "employment_length": 5,  # valor fixo para simplificar
            "loan_amount": 25000,  # valor fixo para simplificar
            "credit_score": int(form_data.get("credit_score", 720)),
            "debt_to_income": 0.25,  # valor fixo para simplificar
        }

        async with httpx.AsyncClient() as client:
            response = await client.post(
                "http://backend:8000/predict", json=payload, timeout=10.0
            )

        if response.status_code == 200:
            result = response.json()
            return Div(
                H3("Assessment Results", cls="text-xl font-bold mb-4"),
                P(f"Risk Level: {result['prediction']}", cls="mb-2"),
                P(f"Probability: {result['probability']:.1%}", cls="mb-2"),
                P(f"Recommendation: {result['recommendation']}", cls="mb-2"),
                cls="bg-white p-6 rounded-lg shadow-lg border",
            )
        else:
            return Div("API Error", cls="text-red-600 p-4")

    except Exception as e:
        return Div(f"Error: {str(e)}", cls="text-red-600 p-4")


if __name__ == "__main__":
    serve(host="0.0.0.0", port=5000)

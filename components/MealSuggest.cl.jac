sv import from .backend { MealSuggest }

def:pub MealSuggestCard(userName: str) -> JsxElement {
    has suggestion: str = "",
        remaining: str = "",
        loading: bool = False;

    async def handleSuggest {
        loading = True;
        suggestion = "";
        result = root spawn MealSuggest(user_name=userName);
        if result.reports {
            data = result.reports[0];
            remaining = str(data["remaining_calories"]);
            suggestion = str(data["suggestion"]);
        }
        loading = False;
    }

    return
        <div style={{"background": "#fff", "borderRadius": "12px", "padding": "28px", "boxShadow": "0 1px 3px rgba(0,0,0,0.1)"}}>
            <h2 style={{"color": "#166534", "marginBottom": "8px"}}>AI Meal Suggestion</h2>
            <p style={{"color": "#6b7280", "fontSize": "14px", "marginBottom": "24px"}}>
                Get a personalised meal suggestion based on your remaining calories for today.
            </p>
            <button
                onClick={handleSuggest}
                style={{
                    "background": "#16a34a",
                    "color": "#fff",
                    "border": "none",
                    "padding": "12px 28px",
                    "borderRadius": "8px",
                    "fontSize": "16px",
                    "fontWeight": "600",
                    "marginBottom": "24px"
                }}
            >{(loading and "Thinking...") or "Suggest My Next Meal"}</button>
            {(suggestion and
                <div style={{"background": "#f0fdf4", "borderRadius": "10px", "padding": "20px", "borderLeft": "4px solid #16a34a"}}>
                    <p style={{"color": "#166534", "fontWeight": "600", "marginBottom": "8px"}}>Remaining: {remaining} kcal</p>
                    <p style={{"color": "#374151", "lineHeight": "1.6"}}>{suggestion}</p>
                </div>
            ) or None}
        </div>;
}

sv import from .backend { MealSuggest, ExerciseSuggest }

def:pub MealSuggestCard(userName: str) -> JsxElement {
    has mealSuggestion: str = "",
        remaining: str = "",
        mealLoading: bool = False,
        exerciseSuggestion: str = "",
        burnedToday: str = "",
        exerciseLoading: bool = False;

    async def handleMealSuggest {
        mealLoading = True;
        mealSuggestion = "";
        result = root spawn MealSuggest(user_name=userName);
        if result.reports {
            data = result.reports[0];
            remaining = str(data["remaining_calories"]);
            mealSuggestion = str(data["suggestion"]);
        }
        mealLoading = False;
    }

    async def handleExerciseSuggest {
        exerciseLoading = True;
        exerciseSuggestion = "";
        result = root spawn ExerciseSuggest(user_name=userName);
        if result.reports {
            data = result.reports[0];
            burnedToday = str(data["calories_burned_today"]);
            exerciseSuggestion = str(data["suggestion"]);
        }
        exerciseLoading = False;
    }

    cardStyle = {"background": "#fff", "borderRadius": "12px", "padding": "28px", "boxShadow": "0 1px 3px rgba(0,0,0,0.1)", "marginBottom": "20px"};
    btnStyle = {"background": "#16a34a", "color": "#fff", "border": "none", "padding": "12px 28px", "borderRadius": "8px", "fontSize": "15px", "fontWeight": "600", "marginBottom": "20px"};

    return
        <div>
            <div style={cardStyle}>
                <h2 style={{"color": "#166534", "marginBottom": "6px"}}>AI Meal Suggestion</h2>
                <p style={{"color": "#6b7280", "fontSize": "14px", "marginBottom": "20px"}}>
                    Personalised meal idea based on your remaining calories today.
                </p>
                <button onClick={handleMealSuggest} style={btnStyle}>
                    {(mealLoading and "Thinking...") or "Suggest My Next Meal"}
                </button>
                {(mealSuggestion and
                    <div style={{"background": "#f0fdf4", "borderRadius": "10px", "padding": "20px", "borderLeft": "4px solid #16a34a"}}>
                        <p style={{"color": "#166534", "fontWeight": "600", "marginBottom": "8px"}}>Remaining: {remaining} kcal</p>
                        <p style={{"color": "#374151", "lineHeight": "1.6"}}>{mealSuggestion}</p>
                    </div>
                ) or None}
            </div>

            <div style={cardStyle}>
                <h2 style={{"color": "#166534", "marginBottom": "6px"}}>AI Exercise Suggestion</h2>
                <p style={{"color": "#6b7280", "fontSize": "14px", "marginBottom": "20px"}}>
                    Personalised workout idea based on your goal and today's activity.
                </p>
                <button onClick={handleExerciseSuggest} style={btnStyle}>
                    {(exerciseLoading and "Thinking...") or "Suggest a Workout"}
                </button>
                {(exerciseSuggestion and
                    <div style={{"background": "#f0fdf4", "borderRadius": "10px", "padding": "20px", "borderLeft": "4px solid #16a34a"}}>
                        <p style={{"color": "#166534", "fontWeight": "600", "marginBottom": "8px"}}>Burned today: {burnedToday} kcal</p>
                        <p style={{"color": "#374151", "lineHeight": "1.6"}}>{exerciseSuggestion}</p>
                    </div>
                ) or None}
            </div>
        </div>;
}

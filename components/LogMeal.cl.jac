sv import from .backend { LogMeal }

def:pub LogMealForm(userName: str, onDone: Any) -> JsxElement {
    has mealName: str = "",
        mealTime: str = "",
        calories: str = "",
        protein: str = "",
        carbs: str = "",
        fat: str = "",
        status: str = "";

    async def handleSubmit {
        if not mealName or not calories {
            status = "Meal name and calories are required.";
            return;
        }
        try {
            root spawn LogMeal(
                user_name=userName,
                meal_name=mealName,
                meal_time=mealTime,
                calories=float(calories),
                protein=float(protein) if protein else 0.0,
                carbs=float(carbs) if carbs else 0.0,
                fat=float(fat) if fat else 0.0
            );
            status = "Meal logged!";
            mealName = "";
            mealTime = "";
            calories = "";
            protein = "";
            carbs = "";
            fat = "";
            onDone();
        } except Exception as e {
            status = "Error: " + str(e);
        }
    }

    inputStyle = {"width": "100%", "padding": "10px 14px", "border": "1px solid #d1fae5", "borderRadius": "8px", "fontSize": "15px"};
    labelStyle = {"display": "block", "color": "#166534", "fontWeight": "600", "marginBottom": "6px"};

    return
        <div style={{"background": "#fff", "borderRadius": "12px", "padding": "28px", "boxShadow": "0 1px 3px rgba(0,0,0,0.1)"}}>
            <h2 style={{"color": "#166534", "marginBottom": "24px"}}>Log a Meal</h2>
            <div style={{"marginBottom": "16px"}}>
                <label style={labelStyle}>Meal Name</label>
                <input type="text" value={mealName} placeholder="e.g. Breakfast"
                    onChange={lambda e: ChangeEvent {mealName = e.target.value;}}
                    style={inputStyle} />
            </div>
            <div style={{"marginBottom": "16px"}}>
                <label style={labelStyle}>Time</label>
                <input type="text" value={mealTime} placeholder="e.g. 08:00"
                    onChange={lambda e: ChangeEvent {mealTime = e.target.value;}}
                    style={inputStyle} />
            </div>
            <div style={{"marginBottom": "16px"}}>
                <label style={labelStyle}>Calories</label>
                <input type="text" value={calories} placeholder="e.g. 450"
                    onChange={lambda e: ChangeEvent {calories = e.target.value;}}
                    style={inputStyle} />
            </div>
            <div style={{"marginBottom": "16px"}}>
                <label style={labelStyle}>Protein (g)</label>
                <input type="text" value={protein} placeholder="e.g. 30"
                    onChange={lambda e: ChangeEvent {protein = e.target.value;}}
                    style={inputStyle} />
            </div>
            <div style={{"marginBottom": "16px"}}>
                <label style={labelStyle}>Carbs (g)</label>
                <input type="text" value={carbs} placeholder="e.g. 40"
                    onChange={lambda e: ChangeEvent {carbs = e.target.value;}}
                    style={inputStyle} />
            </div>
            <div style={{"marginBottom": "16px"}}>
                <label style={labelStyle}>Fat (g)</label>
                <input type="text" value={fat} placeholder="e.g. 12"
                    onChange={lambda e: ChangeEvent {fat = e.target.value;}}
                    style={inputStyle} />
            </div>
            <button
                onClick={handleSubmit}
                style={{"background": "#16a34a", "color": "#fff", "border": "none", "padding": "12px 28px", "borderRadius": "8px", "fontSize": "16px", "fontWeight": "600"}}
            >Log Meal</button>
            {(status and <p style={{"marginTop": "14px", "color": "#16a34a", "fontWeight": "600"}}>{status}</p>) or None}
        </div>;
}

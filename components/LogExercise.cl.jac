sv import from .backend { LogExercise }

def:pub LogExerciseForm(userName: str, onDone: Any) -> JsxElement {
    has exName: str = "",
        duration: str = "",
        caloriesBurned: str = "",
        exType: str = "cardio",
        status: str = "";

    async def handleSubmit {
        if not exName or not caloriesBurned {
            status = "Exercise name and calories burned are required.";
            return;
        }
        root spawn LogExercise(
            user_name=userName,
            ex_name=exName,
            duration_min=int(duration) if duration else 0,
            calories_burned=float(caloriesBurned),
            ex_type=exType
        );
        status = "Exercise logged!";
        exName = "";
        duration = "";
        caloriesBurned = "";
        exType = "cardio";
        onDone();
    }

    inputStyle = {"width": "100%", "padding": "10px 14px", "border": "1px solid #d1fae5", "borderRadius": "8px", "fontSize": "15px"};
    labelStyle = {"display": "block", "color": "#166534", "fontWeight": "600", "marginBottom": "6px"};

    return
        <div style={{"background": "#fff", "borderRadius": "12px", "padding": "28px", "boxShadow": "0 1px 3px rgba(0,0,0,0.1)"}}>
            <h2 style={{"color": "#166534", "marginBottom": "24px"}}>Log an Exercise</h2>
            <div style={{"marginBottom": "16px"}}>
                <label style={labelStyle}>Exercise Name</label>
                <input type="text" value={exName} placeholder="e.g. Morning Run"
                    onChange={lambda e: ChangeEvent { exName = e.target.value;}}
                    style={inputStyle} />
            </div>
            <div style={{"marginBottom": "16px"}}>
                <label style={labelStyle}>Duration (min)</label>
                <input type="text" value={duration} placeholder="e.g. 30"
                    onChange={lambda e: ChangeEvent { duration = e.target.value;}}
                    style={inputStyle} />
            </div>
            <div style={{"marginBottom": "16px"}}>
                <label style={labelStyle}>Calories Burned</label>
                <input type="text" value={caloriesBurned} placeholder="e.g. 300"
                    onChange={lambda e: ChangeEvent { caloriesBurned = e.target.value;}}
                    style={inputStyle} />
            </div>
            <div style={{"marginBottom": "16px"}}>
                <label style={labelStyle}>Type</label>
                <select value={exType}
                    onChange={lambda e: ChangeEvent { exType = e.target.value;}}
                    style={inputStyle}>
                    <option value="cardio">Cardio</option>
                    <option value="strength">Strength</option>
                    <option value="flexibility">Flexibility</option>
                </select>
            </div>
            <button
                onClick={handleSubmit}
                style={{"background": "#16a34a", "color": "#fff", "border": "none", "padding": "12px 28px", "borderRadius": "8px", "fontSize": "16px", "fontWeight": "600"}}
            >Log Exercise</button>
            {(status and <p style={{"marginTop": "14px", "color": "#16a34a", "fontWeight": "600"}}>{status}</p>) or None}
        </div>;
}

sv import from .backend { UpdateGoal, LogWeight }

def:pub ProfileForm(userName: str, onDone: Any) -> JsxElement {
    has weight: str = "",
        height: str = "",
        goalType: str = "maintain",
        targetWeight: str = "",
        dailyCalories: str = "2000",
        deadline: str = "",
        logWeight: str = "",
        status: str = "",
        weightStatus: str = "";

    async def handleSaveGoal {
        if not weight or not height or not targetWeight {
            status = "Weight, height and target weight are required.";
            return;
        }
        try {
            root spawn UpdateGoal(
                user_name=userName,
                weight=float(weight),
                height=float(height),
                goal_type=goalType,
                target_weight=float(targetWeight),
                daily_calorie_goal=float(dailyCalories) if dailyCalories else 2000.0,
                deadline=deadline
            );
            status = "Profile saved!";
            onDone();
        } except Exception as e {
            status = "Error: " + str(e);
        }
    }

    async def handleLogWeight {
        if not logWeight {
            weightStatus = "Enter a weight value.";
            return;
        }
        try {
            root spawn LogWeight(user_name=userName, weight=float(logWeight));
            weightStatus = "Weight logged!";
            logWeight = "";
            onDone();
        } except Exception as e {
            weightStatus = "Error: " + str(e);
        }
    }

    inputStyle = {"width": "100%", "padding": "10px 14px", "border": "1px solid #d1fae5", "borderRadius": "8px", "fontSize": "15px", "marginBottom": "4px"};
    labelStyle = {"display": "block", "color": "#166534", "fontWeight": "600", "marginBottom": "6px", "marginTop": "14px"};

    return
        <div>
            <div style={{"background": "#fff", "borderRadius": "12px", "padding": "28px", "boxShadow": "0 1px 3px rgba(0,0,0,0.1)", "marginBottom": "20px"}}>
                <h2 style={{"color": "#166534", "marginBottom": "20px"}}>My Profile & Goals</h2>

                <div style={{"display": "grid", "gridTemplateColumns": "1fr 1fr", "gap": "16px"}}>
                    <div>
                        <label style={labelStyle}>Current Weight (kg)</label>
                        <input type="number" placeholder="e.g. 75" value={weight}
                            onChange={lambda e: ChangeEvent { weight = e.target.value;}}
                            style={inputStyle} />
                    </div>
                    <div>
                        <label style={labelStyle}>Height (cm)</label>
                        <input type="number" placeholder="e.g. 175" value={height}
                            onChange={lambda e: ChangeEvent { height = e.target.value;}}
                            style={inputStyle} />
                    </div>
                    <div>
                        <label style={labelStyle}>Goal</label>
                        <select value={goalType}
                            onChange={lambda e: ChangeEvent { goalType = e.target.value;}}
                            style={inputStyle}>
                            <option value="lose">Lose Weight</option>
                            <option value="gain">Gain Weight</option>
                            <option value="maintain">Maintain Weight</option>
                        </select>
                    </div>
                    <div>
                        <label style={labelStyle}>Target Weight (kg)</label>
                        <input type="number" placeholder="e.g. 70" value={targetWeight}
                            onChange={lambda e: ChangeEvent { targetWeight = e.target.value;}}
                            style={inputStyle} />
                    </div>
                    <div>
                        <label style={labelStyle}>Daily Calorie Goal (kcal)</label>
                        <input type="number" placeholder="e.g. 2000" value={dailyCalories}
                            onChange={lambda e: ChangeEvent { dailyCalories = e.target.value;}}
                            style={inputStyle} />
                    </div>
                    <div>
                        <label style={labelStyle}>Target Deadline</label>
                        <input type="date" value={deadline}
                            onChange={lambda e: ChangeEvent { deadline = e.target.value;}}
                            style={inputStyle} />
                    </div>
                </div>

                <button onClick={handleSaveGoal}
                    style={{"background": "#16a34a", "color": "#fff", "border": "none", "padding": "12px 28px", "borderRadius": "8px", "fontSize": "16px", "fontWeight": "600", "marginTop": "20px"}}>
                    Save Profile
                </button>
                {(status and <p style={{"marginTop": "12px", "color": ("#16a34a" if status == "Profile saved!" else "#dc2626"), "fontWeight": "600"}}>{status}</p>) or None}
            </div>

            <div style={{"background": "#fff", "borderRadius": "12px", "padding": "28px", "boxShadow": "0 1px 3px rgba(0,0,0,0.1)"}}>
                <h2 style={{"color": "#166534", "marginBottom": "16px"}}>Log Today's Weight</h2>
                <div style={{"display": "flex", "gap": "12px", "alignItems": "flex-end"}}>
                    <div style={{"flex": "1"}}>
                        <label style={labelStyle}>Weight (kg)</label>
                        <input type="number" placeholder="e.g. 74.5" value={logWeight}
                            onChange={lambda e: ChangeEvent { logWeight = e.target.value;}}
                            style={inputStyle} />
                    </div>
                    <button onClick={handleLogWeight}
                        style={{"background": "#16a34a", "color": "#fff", "border": "none", "padding": "10px 24px", "borderRadius": "8px", "fontSize": "15px", "fontWeight": "600", "marginBottom": "4px"}}>
                        Log
                    </button>
                </div>
                {(weightStatus and <p style={{"marginTop": "10px", "color": ("#16a34a" if weightStatus == "Weight logged!" else "#dc2626"), "fontWeight": "600"}}>{weightStatus}</p>) or None}
            </div>
        </div>;
}

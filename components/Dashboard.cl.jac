def:pub Dashboard(daily: Any, progress: Any) -> JsxElement {

    def statCard(label: str, value: str, color: str) -> JsxElement {
        return
            <div style={{
                "background": "#fff",
                "borderRadius": "12px",
                "padding": "20px",
                "flex": "1",
                "textAlign": "center",
                "boxShadow": "0 1px 3px rgba(0,0,0,0.1)"
            }}>
                <p style={{"color": "#6b7280", "fontSize": "13px", "marginBottom": "6px"}}>{label}</p>
                <p style={{"color": color, "fontSize": "1.8rem", "fontWeight": "700"}}>{value}</p>
            </div>;
    }

    return
        <div>
            {(daily and
                <div>
                    <h2 style={{"marginBottom": "16px", "color": "#166534"}}>Today — {daily["date"]}</h2>
                    <div style={{"display": "flex", "gap": "16px", "marginBottom": "24px"}}>
                        {statCard("Calories In", str(daily["calories_in"]) + " kcal", "#16a34a")}
                        {statCard("Calories Out", str(daily["calories_out"]) + " kcal", "#dc2626")}
                        {statCard("Net", str(daily["net"]) + " kcal", ("#dc2626" if daily["net"] > 0 else "#16a34a"))}
                    </div>
                    <div style={{"display": "flex", "gap": "16px", "marginBottom": "24px"}}>
                        <div style={{"background": "#fff", "borderRadius": "12px", "padding": "20px", "flex": "1", "boxShadow": "0 1px 3px rgba(0,0,0,0.1)"}}>
                            <h3 style={{"color": "#166534", "marginBottom": "12px"}}>Meals</h3>
                            {([<p key={m} style={{"padding": "6px 0", "borderBottom": "1px solid #f0fdf4", "color": "#374151"}}>{m}</p> for m in daily["meals"]]
                              if daily["meals"] else <p style={{"color": "#9ca3af"}}>No meals logged</p>)}
                        </div>
                        <div style={{"background": "#fff", "borderRadius": "12px", "padding": "20px", "flex": "1", "boxShadow": "0 1px 3px rgba(0,0,0,0.1)"}}>
                            <h3 style={{"color": "#166534", "marginBottom": "12px"}}>Exercises</h3>
                            {([<p key={e} style={{"padding": "6px 0", "borderBottom": "1px solid #f0fdf4", "color": "#374151"}}>{e}</p> for e in daily["exercises"]]
                              if daily["exercises"] else <p style={{"color": "#9ca3af"}}>No exercises logged</p>)}
                        </div>
                    </div>
                </div>
            ) or <p style={{"color": "#9ca3af"}}>No data for today yet.</p>}

            {(progress and
                <div style={{"background": "#fff", "borderRadius": "12px", "padding": "20px", "boxShadow": "0 1px 3px rgba(0,0,0,0.1)"}}>
                    <h3 style={{"color": "#166534", "marginBottom": "12px"}}>Progress</h3>
                    <p style={{"color": "#374151", "marginBottom": "6px"}}>Current: <strong>{str(progress["current_weight"])} kg</strong></p>
                    <p style={{"color": "#374151", "marginBottom": "6px"}}>Target: <strong>{str(progress["target_weight"])} kg</strong></p>
                    <p style={{"color": "#374151", "marginBottom": "6px"}}>Goal: <strong>{progress["goal_type"]}</strong></p>
                    <p style={{"color": "#374151"}}>Est. days to goal: <strong>{str(progress["estimated_days_to_goal"])}</strong></p>
                </div>
            ) or None}
        </div>;
}

def:pub WeeklyTrendView(data: Any) -> JsxElement {
    return
        <div>
            {(data and
                <div>
                    <h2 style={{"color": "#166534", "marginBottom": "8px"}}>Weekly Trend</h2>
                    <p style={{"color": "#6b7280", "marginBottom": "24px", "fontSize": "14px"}}>{data["consistency"]}</p>
                    <div style={{"background": "#fff", "borderRadius": "12px", "overflow": "hidden", "boxShadow": "0 1px 3px rgba(0,0,0,0.1)", "marginBottom": "24px"}}>
                        <div style={{"display": "grid", "gridTemplateColumns": "1fr 1fr 1fr 1fr", "background": "#166534", "padding": "12px 16px"}}>
                            <span style={{"color": "#fff", "fontWeight": "700", "fontSize": "13px"}}>Date</span>
                            <span style={{"color": "#fff", "fontWeight": "700", "fontSize": "13px"}}>In (kcal)</span>
                            <span style={{"color": "#fff", "fontWeight": "700", "fontSize": "13px"}}>Out (kcal)</span>
                            <span style={{"color": "#fff", "fontWeight": "700", "fontSize": "13px"}}>Net</span>
                        </div>
                        {[<div
                            key={d["date"]}
                            style={{"display": "grid", "gridTemplateColumns": "1fr 1fr 1fr 1fr", "padding": "12px 16px", "borderBottom": "1px solid #f0fdf4"}}
                        >
                            <span style={{"color": "#374151", "fontSize": "14px"}}>{str(d["date"])}</span>
                            <span style={{"color": "#16a34a", "fontSize": "14px"}}>{str(d["calories_in"])}</span>
                            <span style={{"color": "#dc2626", "fontSize": "14px"}}>{str(d["calories_out"])}</span>
                            <span style={{"fontSize": "14px"}}>{str(d["net"])}</span>
                        </div> for d in data["days"]]}
                    </div>
                    <div style={{"background": "#fff", "borderRadius": "12px", "padding": "20px", "boxShadow": "0 1px 3px rgba(0,0,0,0.1)"}}>
                        <p style={{"color": "#374151"}}>Avg Daily Intake: <strong>{str(data["avg_daily_intake"])} kcal</strong></p>
                    </div>
                </div>
            ) or <p style={{"color": "#9ca3af"}}>No weekly data yet.</p>}
        </div>;
}

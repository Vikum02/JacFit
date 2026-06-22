sv import from .backend {
    CreateUser, LogMeal, LogExercise,
    DailyReport, WeeklyTrend, ProgressCheck, MealSuggest
}

import from .components.Dashboard { Dashboard }
import from .components.LogMeal { LogMealForm }
import from .components.LogExercise { LogExerciseForm }
import from .components.WeeklyTrend { WeeklyTrendView }
import from .components.MealSuggest { MealSuggestCard }

import "./global.css";

def:pub app -> JsxElement {
    has activeTab: str = "dashboard",
        userName: str = "Alex",
        dailyData: Any = None,
        weeklyData: Any = None,
        progressData: Any = None,
        loading: bool = False;

    async def loadData {
        loading = True;
        r1 = root spawn DailyReport(user_name=userName);
        dailyData = r1.reports[0] if r1.reports else None;
        r2 = root spawn WeeklyTrend(user_name=userName);
        weeklyData = r2.reports[0] if r2.reports else None;
        r3 = root spawn ProgressCheck(user_name=userName);
        progressData = r3.reports[0] if r3.reports else None;
        loading = False;
    }

    async can with entry {
        loadData();
    }

    return
        <div style={{"minHeight": "100vh", "background": "#f0fdf4"}}>
            <nav style={{
                "background": "#16a34a",
                "padding": "16px 24px",
                "display": "flex",
                "gap": "16px",
                "alignItems": "center"
            }}>
                <span style={{"color": "#fff", "fontWeight": "700", "fontSize": "1.4rem", "marginRight": "24px"}}>
                    JacFit
                </span>
                {[
                    <button onClick={lambda { activeTab = "dashboard";}} style={{"background": ("rgba(255,255,255,0.25)" if activeTab == "dashboard" else "transparent"), "color": "#fff", "border": "none", "padding": "8px 16px", "borderRadius": "8px", "fontWeight": "600", "fontSize": "14px"}}>Dashboard</button>,
                    <button onClick={lambda { activeTab = "log_meal";}} style={{"background": ("rgba(255,255,255,0.25)" if activeTab == "log_meal" else "transparent"), "color": "#fff", "border": "none", "padding": "8px 16px", "borderRadius": "8px", "fontWeight": "600", "fontSize": "14px"}}>Log Meal</button>,
                    <button onClick={lambda { activeTab = "log_exercise";}} style={{"background": ("rgba(255,255,255,0.25)" if activeTab == "log_exercise" else "transparent"), "color": "#fff", "border": "none", "padding": "8px 16px", "borderRadius": "8px", "fontWeight": "600", "fontSize": "14px"}}>Log Exercise</button>,
                    <button onClick={lambda { activeTab = "weekly";}} style={{"background": ("rgba(255,255,255,0.25)" if activeTab == "weekly" else "transparent"), "color": "#fff", "border": "none", "padding": "8px 16px", "borderRadius": "8px", "fontWeight": "600", "fontSize": "14px"}}>Weekly Trend</button>,
                    <button onClick={lambda { activeTab = "suggest";}} style={{"background": ("rgba(255,255,255,0.25)" if activeTab == "suggest" else "transparent"), "color": "#fff", "border": "none", "padding": "8px 16px", "borderRadius": "8px", "fontWeight": "600", "fontSize": "14px"}}>AI Suggest</button>
                ]}
            </nav>

            <main style={{"padding": "32px 24px", "maxWidth": "800px", "margin": "0 auto"}}>
                {(loading
                    and <p style={{"color": "#16a34a"}}>Loading...</p>)
                or (activeTab == "dashboard"
                    and <Dashboard daily={dailyData} progress={progressData} />)
                or (activeTab == "log_meal"
                    and <LogMealForm userName={userName} onDone={loadData} />)
                or (activeTab == "log_exercise"
                    and <LogExerciseForm userName={userName} onDone={loadData} />)
                or (activeTab == "weekly"
                    and <WeeklyTrendView data={weeklyData} />)
                or (activeTab == "suggest"
                    and <MealSuggestCard userName={userName} />)
                or <div/>}
            </main>
        </div>;
}

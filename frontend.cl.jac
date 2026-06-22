sv import from .backend {
    CreateUser, LogMeal, LogExercise,
    DailyReport, WeeklyTrend, ProgressCheck, MealSuggest
}

import from "@jac/runtime" { jacSignup, jacLogin, jacIsLoggedIn }
import from .components.Dashboard { Dashboard }
import from .components.LogMeal { LogMealForm }
import from .components.LogExercise { LogExerciseForm }
import from .components.WeeklyTrend { WeeklyTrendView }
import from .components.MealSuggest { MealSuggestCard }

import "./global.css";

def:pub app -> JsxElement {
    has activeTab: str = "dashboard",
        isLoggedIn: bool = False,
        authMode: str = "login",
        authUser: str = "",
        authPass: str = "",
        authError: str = "",
        userName: str = "",
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

    async def handleLogin {
        authError = "";
        if not authUser or not authPass {
            authError = "Please enter username and password.";
            return;
        }
        result: bool = await jacLogin(authUser, authPass);
        if result {
            userName = authUser;
            isLoggedIn = True;
            loadData();
        } else {
            authError = "Invalid username or password.";
        }
    }

    async def handleSignup {
        authError = "";
        if not authUser or not authPass {
            authError = "Please enter username and password.";
            return;
        }
        result: dict[str, any] = await jacSignup(authUser, authPass);
        if result["success"] {
            loginResult: bool = await jacLogin(authUser, authPass);
            if loginResult {
                userName = authUser;
                root spawn CreateUser(
                    name=authUser,
                    weight=0.0,
                    height=0.0,
                    goal_type="maintain",
                    target_weight=0.0,
                    daily_calorie_goal=2000.0,
                    deadline=""
                );
                isLoggedIn = True;
                loadData();
            }
        } else {
            authError = "Signup failed. Try a different username.";
        }
    }

    async can with entry {
        isLoggedIn = jacIsLoggedIn();
        if isLoggedIn {
            storedName = localStorage.getItem("jacfit_user") or "";
            userName = storedName;
            loadData();
        }
    }

    can with [isLoggedIn] entry {
        if isLoggedIn {
            localStorage.setItem("jacfit_user", userName);
        }
    }

    inputStyle = {"width": "100%", "padding": "10px 14px", "border": "1px solid #d1fae5", "borderRadius": "8px", "fontSize": "15px", "marginBottom": "12px"};

    if not isLoggedIn {
        return
            <div style={{"minHeight": "100vh", "background": "#f0fdf4", "display": "flex", "alignItems": "center", "justifyContent": "center"}}>
                <div style={{"background": "#fff", "borderRadius": "16px", "padding": "40px", "width": "360px", "boxShadow": "0 4px 12px rgba(0,0,0,0.1)"}}>
                    <h1 style={{"color": "#166534", "textAlign": "center", "marginBottom": "8px", "fontSize": "1.8rem"}}>JacFit</h1>
                    <p style={{"color": "#6b7280", "textAlign": "center", "marginBottom": "28px", "fontSize": "14px"}}>Diet & Fitness Tracker</p>
                    <input type="text" placeholder="Username" value={authUser}
                        onChange={lambda e: ChangeEvent { authUser = e.target.value;}}
                        style={inputStyle} />
                    <input type="password" placeholder="Password" value={authPass}
                        onChange={lambda e: ChangeEvent { authPass = e.target.value;}}
                        style={inputStyle} />
                    {(authError and <p style={{"color": "#dc2626", "fontSize": "13px", "marginBottom": "12px"}}>{authError}</p>) or None}
                    {(authMode == "login" and
                        <div>
                            <button onClick={handleLogin}
                                style={{"width": "100%", "background": "#16a34a", "color": "#fff", "border": "none", "padding": "12px", "borderRadius": "8px", "fontSize": "16px", "fontWeight": "600", "marginBottom": "12px"}}>
                                Login
                            </button>
                            <p style={{"textAlign": "center", "color": "#6b7280", "fontSize": "14px"}}>
                                No account?
                                <button onClick={lambda { authMode = "signup"; authError = "";}}
                                    style={{"background": "none", "border": "none", "color": "#16a34a", "fontWeight": "600", "cursor": "pointer", "marginLeft": "6px"}}>
                                    Sign Up
                                </button>
                            </p>
                        </div>
                    ) or
                        <div>
                            <button onClick={handleSignup}
                                style={{"width": "100%", "background": "#16a34a", "color": "#fff", "border": "none", "padding": "12px", "borderRadius": "8px", "fontSize": "16px", "fontWeight": "600", "marginBottom": "12px"}}>
                                Create Account
                            </button>
                            <p style={{"textAlign": "center", "color": "#6b7280", "fontSize": "14px"}}>
                                Have an account?
                                <button onClick={lambda { authMode = "login"; authError = "";}}
                                    style={{"background": "none", "border": "none", "color": "#16a34a", "fontWeight": "600", "cursor": "pointer", "marginLeft": "6px"}}>
                                    Login
                                </button>
                            </p>
                        </div>}
                </div>
            </div>;
    }

    return
        <div style={{"minHeight": "100vh", "background": "#f0fdf4"}}>
            <nav style={{"background": "#16a34a", "padding": "16px 24px", "display": "flex", "gap": "16px", "alignItems": "center"}}>
                <span style={{"color": "#fff", "fontWeight": "700", "fontSize": "1.4rem", "marginRight": "24px"}}>JacFit</span>
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

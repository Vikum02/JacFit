import from datetime {date}
import from byllm.lib { Model }

glob llm = Model(model_name="gpt-4o-mini");

"""Suggest a healthy meal given remaining calorie budget and the user's
fitness goal (lose/gain/maintain). Return meal name and brief description."""
def suggest_meal(remaining_calories: float, goal_type: str) -> str by llm();

node User {
    has name : str = "",
        weight: float = 0.0,
        height: float = 0.0,
        goal_type: str = "maintain";
}

node Day {
    has date: str = "",
        total_calories_in: float = 0.0,
        total_calories_out: float = 0.0,
        weight_log: float = 0.0;
}

node Meal {
    has name: str = "",
        time: str = "",
        calories: float = 0.0,
        protein: float = 0.0,
        carbs: float = 0.0,
        fat: float = 0.0;
}

node Food {
    has name: str = "",
        calories_per_serving: float = 0.0,
        protein: float = 0.0,
        carbs: float = 0.0,
        fat: float = 0.0;
}

node Exercise {
    has name: str = "",
        duration_min: int = 0,
        calories_burned: float = 0.0,
        ex_type: str = "cardio";
}

node Goal {
    has target_weight: float = 0.0,
        daily_calorie_goal: float = 2000.0,
        deadline: str = "";
}

edge Ate {
    has timestamp: str = "";
}

edge Contains {
    has servings: float = 1.0;
}

edge Did {
    has timestamp: str = "";
}

edge LoggedOn {}
edge Targets {}

walker CreateUser{
    has name: str = "",
        weight: float = 0.0,
        height: float = 0.0,
        goal_type: str = "maintain",
        target_weight: float = 0.0,
        daily_calorie_goal: float = 2000.0,
        deadline: str = "";

    can setup with Root entry{
        user = here ++> User(
            name = self.name,
            weight = self.weight,
            height = self.height,
            goal_type = self.goal_type
        );
        goal =Goal(
            target_weight = self.target_weight,
            daily_calorie_goal = self.daily_calorie_goal,
            deadline = self.deadline
        );
        user +>: Targets :+> goal;
        report user;
    }    
}

walker LogMeal {
    has user_name: str = "",
        meal_name: str = "",
        meal_time: str = "",
        calories: float = 0.0,
        protein: float = 0.0,
        carbs: float = 0.0,
        fat: float = 0.0;

    can find_user with Root entry {
        for u in [-->][?:User] {
            if u.name == self.user_name {
                visit u;
            }
        }
    }   

    can on_user with User entry{
        today = str(date.today());
        meal = Meal(
            name = self.meal_name,
            time = self.meal_time,
            calories = self.calories,
            protein = self.protein,
            carbs = self.carbs,
            fat = self.fat
        );
        here +>: Ate(timestamp=today) :+> meal;

        today_days = [d for d in [-->][?:Day] if d.date == today];
        if not today_days {
            here ++> Day(date=today);
        }
        for d in [-->][?:Day] {
            if d.date == today {
                meal +>: LoggedOn :+> d;
                d.total_calories_in += meal.calories;
            }
        }
        report meal;
    }
}

walker LogExercise {
    has user_name: str = "",
        ex_name: str = "",
        duration_min: int = 0,
        calories_burned: float = 0.0,
        ex_type: str = "cardio";

    can find_user with Root entry {
        for u in [-->][?:User] {
            if u.name == self.user_name {
                visit u;
            }
        }
    }

    can on_user with User entry {
        today = str(date.today());
        exercise = Exercise(
            name=self.ex_name,
            duration_min=self.duration_min,
            calories_burned=self.calories_burned,
            ex_type=self.ex_type
        );
        here +>: Did(timestamp=today) :+> exercise;

        today_days = [d for d in [-->][?:Day] if d.date == today];
        if not today_days {
            here ++> Day(date=today);
        }
        for d in [-->][?:Day] {
            if d.date == today {
                exercise +>: LoggedOn :+> d;
                d.total_calories_out += exercise.calories_burned;
            }
        }
        report exercise;
    }
}

walker DailyReport{
   has user_name: str = "";
       report_date: str = "";

   can find_user with Root entry {
       for u in [-->][?:User]{
        if u.name == self.user_name {
            visit u;
        }
       } 
   }

   can on_user with User entry {
       target = self.report_date if self.report_date else str(date.today());
         for d in [-->][?:Day] {
            if d.date == target {
                visit d;
            }
        }
   } 
   can on_day with Day entry {
    meals = [m for m in [<--][?:Meal]];
    exercises = [e for e in [<--][?:Exercise]];

    report{
        "date": here.date,
        "calories_in": here.total_calories_in,
        "calories_out": here.total_calories_out,
        "net": here.total_calories_in - here.total_calories_out,
        "meals": [m.name for m in meals],
        "exercises": [e.name for e in exercises]
    };

   }
}

walker WeeklyTrend {
    has user_name: str = "";
    
    can find_user with Root entry {
         for u in [-->][?:User]{
          if u.name == self.user_name {
                visit u;
          }
        }
    }

    can on_user with User entry {
        all_days: list[Day] = [d for d in [-->][?:Day]];
        all_days.reverse();
        last_7: list[Day] = all_days[:7];

        weights = [d.weight_log for d in last_7 if d.weight_log > 0.0];
        total_in = sum(d.total_calories_in for d in last_7);
        logged = len([d for d in last_7 if d.total_calories_in > 0.0]);

        report{
            "days": [{"date": d.date,
                     "calories_in": d.total_calories_in,
                     "calories_out": d.total_calories_out,
                     "net": d.total_calories_in - d.total_calories_out,
                     "weight": d.weight_log} for d in last_7],
                   
            "avg_daily_intake": total_in / len(last_7) if last_7 else 0.0,
            "weight_trend": weights,
            "consistency": f"{logged}/{len(last_7)} days logged"
         };          
        }    
    
    }

walker ProgressCheck {
    has user_name: str = "";
    has current_weight: float = 0.0;
    has goal_type: str = "";

    can find_user with Root entry {
        for u in [-->][?:User]{
            if u.name == self.user_name {
                visit u;
            }
        }
    }
    can on_user with User entry {
        self.current_weight = here.weight;
        self.goal_type = here.goal_type;
        visit [-->][?:Goal];
    }

    can on_goal with Goal entry{
        diff: float = self.current_weight - here.target_weight;
        kg_per_day: float = 500.0 / 7700.0;
        days_to_goal: float = diff / kg_per_day if diff >= 0.0 else -diff / kg_per_day;

        report{
            "current_weight": self.current_weight,
            "target_weight": here.target_weight,
            "difference_kg": diff,
            "goal_type": self.goal_type,
            "deadline": here.deadline,
            "daily_calorie_goal": here.daily_calorie_goal,
            "estimated_days_to_goal": days_to_goal
        };
    }
}  

walker MealSuggest {
    has user_name: str = "";
    has calories_so_far: float = 0.0;
    has goal_type: str = "";

    can find_user with Root entry {
        for u in [-->][?:User] {
            if u.name == self.user_name {
                visit u;
            }
        }
    }

    can on_user with User entry {
        today = str(date.today());
        self.goal_type = here.goal_type;
        for d in [-->][?:Day] {
            if d.date == today {
                self.calories_so_far = d.total_calories_in;
            }
        }
        visit [-->][?:Goal];
    }

    can on_goal with Goal entry {
        remaining: float = here.daily_calorie_goal - self.calories_so_far;
        suggestion = suggest_meal(remaining, self.goal_type);
        report {
            "remaining_calories": remaining,
            "suggestion": suggestion
        };
    }
}

with entry {
    root spawn CreateUser(
        name="Alex",
        weight=80.0,
        height=175.0,
        goal_type="lose",
        target_weight=72.0,
        daily_calorie_goal=2000.0,
        deadline="2026-12-31"
    );

    root spawn LogMeal(
        user_name="Alex",
        meal_name="Breakfast",
        meal_time="08:00",
        calories=450.0,
        protein=30.0,
        carbs=40.0,
        fat=12.0
    );

    root spawn LogExercise(
        user_name="Alex",
        ex_name="Morning Run",
        duration_min=30,
        calories_burned=300.0,
        ex_type="cardio"
    );

    root spawn DailyReport(user_name="Alex");

    root spawn WeeklyTrend(user_name="Alex");

    root spawn ProgressCheck(user_name="Alex");

    root spawn MealSuggest(user_name="Alex");
}

with entry {
    root spawn CreateUser(
        name="Alex",
        weight=80.0,
        height=175.0,
        goal_type="lose",
        target_weight=72.0,
        daily_calorie_goal=2000.0,
        deadline="2026-12-31"
    );

    root spawn LogMeal(
        user_name="Alex",
        meal_name="Breakfast",
        meal_time="08:00",
        calories=450.0,
        protein=30.0,
        carbs=40.0,
        fat=12.0
    );

    root spawn LogExercise(
        user_name="Alex",
        ex_name="Morning Run",
        duration_min=30,
        calories_burned=300.0,
        ex_type="cardio"
    );
}
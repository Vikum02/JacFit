import from datetime {date}

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
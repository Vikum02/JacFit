/* Source: /home/vikum_02/JacFit/components/LogMeal.cl.jac */
import {__jacJsx, __jacSpawn} from "@jac/runtime";
import { __jacCallFunction } from "@jac/runtime";
import { useState } from "@jac/runtime";
async function LogMeal() {
  return await __jacCallFunction("LogMeal", {});
}
function LogMealForm(props) {
  const {userName, onDone} = props;
  const [mealName, setMealName] = useState("");
  const [mealTime, setMealTime] = useState("");
  const [calories, setCalories] = useState("");
  const [protein, setProtein] = useState("");
  const [carbs, setCarbs] = useState("");
  const [fat, setFat] = useState("");
  const [status, setStatus] = useState("");
  async function handleSubmit() {
    if ((!mealName || !calories)) {
      setStatus("Meal name and calories are required.");
      return;
    }
    await __jacSpawn("LogMeal", "", {"user_name": userName, "meal_name": mealName, "meal_time": mealTime, "calories": parseFloat(calories), "protein": (protein ? parseFloat(protein) : 0.0), "carbs": (carbs ? parseFloat(carbs) : 0.0), "fat": (fat ? parseFloat(fat) : 0.0)});
    setStatus("Meal logged!");
    setMealName("");
    setMealTime("");
    setCalories("");
    setProtein("");
    setCarbs("");
    setFat("");
    onDone();
  }
  let inputStyle = {"width": "100%", "padding": "10px 14px", "border": "1px solid #d1fae5", "borderRadius": "8px", "fontSize": "15px"};
  let labelStyle = {"display": "block", "color": "#166534", "fontWeight": "600", "marginBottom": "6px"};
  return __jacJsx("div", {"style": {"background": "#fff", "borderRadius": "12px", "padding": "28px", "boxShadow": "0 1px 3px rgba(0,0,0,0.1)"}}, [__jacJsx("h2", {"style": {"color": "#166534", "marginBottom": "24px"}}, ["Log a Meal"]), __jacJsx("div", {"style": {"marginBottom": "16px"}}, [__jacJsx("label", {"style": labelStyle}, ["Meal Name"]), __jacJsx("input", {"type": "text", "value": mealName, "placeholder": "e.g. Breakfast", "onChange": e => {
    setMealName(e.target.value);
  }, "style": inputStyle}, [])]), __jacJsx("div", {"style": {"marginBottom": "16px"}}, [__jacJsx("label", {"style": labelStyle}, ["Time"]), __jacJsx("input", {"type": "text", "value": mealTime, "placeholder": "e.g. 08:00", "onChange": e => {
    setMealTime(e.target.value);
  }, "style": inputStyle}, [])]), __jacJsx("div", {"style": {"marginBottom": "16px"}}, [__jacJsx("label", {"style": labelStyle}, ["Calories"]), __jacJsx("input", {"type": "text", "value": calories, "placeholder": "e.g. 450", "onChange": e => {
    setCalories(e.target.value);
  }, "style": inputStyle}, [])]), __jacJsx("div", {"style": {"marginBottom": "16px"}}, [__jacJsx("label", {"style": labelStyle}, ["Protein (g)"]), __jacJsx("input", {"type": "text", "value": protein, "placeholder": "e.g. 30", "onChange": e => {
    setProtein(e.target.value);
  }, "style": inputStyle}, [])]), __jacJsx("div", {"style": {"marginBottom": "16px"}}, [__jacJsx("label", {"style": labelStyle}, ["Carbs (g)"]), __jacJsx("input", {"type": "text", "value": carbs, "placeholder": "e.g. 40", "onChange": e => {
    setCarbs(e.target.value);
  }, "style": inputStyle}, [])]), __jacJsx("div", {"style": {"marginBottom": "16px"}}, [__jacJsx("label", {"style": labelStyle}, ["Fat (g)"]), __jacJsx("input", {"type": "text", "value": fat, "placeholder": "e.g. 12", "onChange": e => {
    setFat(e.target.value);
  }, "style": inputStyle}, [])]), __jacJsx("button", {"onClick": handleSubmit, "style": {"background": "#16a34a", "color": "#fff", "border": "none", "padding": "12px 28px", "borderRadius": "8px", "fontSize": "16px", "fontWeight": "600"}}, ["Log Meal"]), ((status && __jacJsx("p", {"style": {"marginTop": "14px", "color": "#16a34a", "fontWeight": "600"}}, [status])) || null)]);
}
export {LogMealForm};
if (typeof globalThis !== "undefined") { if (!globalThis.__jacEndpointEffects__) globalThis.__jacEndpointEffects__ = {}; Object.assign(globalThis.__jacEndpointEffects__, {"func:LogMealForm": {"is_writer": true, "touches": ["*"]}}); };
//# sourceMappingURL=LogMeal.js.map

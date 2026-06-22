/* Source: /home/vikum_02/JacFit/components/LogExercise.cl.jac */
import {__jacJsx, __jacSpawn} from "@jac/runtime";
import { __jacCallFunction } from "@jac/runtime";
import { useState } from "@jac/runtime";
async function LogExercise() {
  return await __jacCallFunction("LogExercise", {});
}
function LogExerciseForm(props) {
  const {userName, onDone} = props;
  const [exName, setExName] = useState("");
  const [duration, setDuration] = useState("");
  const [caloriesBurned, setCaloriesBurned] = useState("");
  const [exType, setExType] = useState("cardio");
  const [status, setStatus] = useState("");
  async function handleSubmit() {
    if ((!exName || !caloriesBurned)) {
      setStatus("Exercise name and calories burned are required.");
      return;
    }
    await __jacSpawn("LogExercise", "", {"user_name": userName, "ex_name": exName, "duration_min": (duration ? Math.trunc(Number(duration)) : 0), "calories_burned": parseFloat(caloriesBurned), "ex_type": exType});
    setStatus("Exercise logged!");
    setExName("");
    setDuration("");
    setCaloriesBurned("");
    setExType("cardio");
    onDone();
  }
  let inputStyle = {"width": "100%", "padding": "10px 14px", "border": "1px solid #d1fae5", "borderRadius": "8px", "fontSize": "15px"};
  let labelStyle = {"display": "block", "color": "#166534", "fontWeight": "600", "marginBottom": "6px"};
  return __jacJsx("div", {"style": {"background": "#fff", "borderRadius": "12px", "padding": "28px", "boxShadow": "0 1px 3px rgba(0,0,0,0.1)"}}, [__jacJsx("h2", {"style": {"color": "#166534", "marginBottom": "24px"}}, ["Log an Exercise"]), __jacJsx("div", {"style": {"marginBottom": "16px"}}, [__jacJsx("label", {"style": labelStyle}, ["Exercise Name"]), __jacJsx("input", {"type": "text", "value": exName, "placeholder": "e.g. Morning Run", "onChange": e => {
    setExName(e.target.value);
  }, "style": inputStyle}, [])]), __jacJsx("div", {"style": {"marginBottom": "16px"}}, [__jacJsx("label", {"style": labelStyle}, ["Duration (min)"]), __jacJsx("input", {"type": "text", "value": duration, "placeholder": "e.g. 30", "onChange": e => {
    setDuration(e.target.value);
  }, "style": inputStyle}, [])]), __jacJsx("div", {"style": {"marginBottom": "16px"}}, [__jacJsx("label", {"style": labelStyle}, ["Calories Burned"]), __jacJsx("input", {"type": "text", "value": caloriesBurned, "placeholder": "e.g. 300", "onChange": e => {
    setCaloriesBurned(e.target.value);
  }, "style": inputStyle}, [])]), __jacJsx("div", {"style": {"marginBottom": "16px"}}, [__jacJsx("label", {"style": labelStyle}, ["Type"]), __jacJsx("select", {"value": exType, "onChange": e => {
    setExType(e.target.value);
  }, "style": inputStyle}, [__jacJsx("option", {"value": "cardio"}, ["Cardio"]), __jacJsx("option", {"value": "strength"}, ["Strength"]), __jacJsx("option", {"value": "flexibility"}, ["Flexibility"])])]), __jacJsx("button", {"onClick": handleSubmit, "style": {"background": "#16a34a", "color": "#fff", "border": "none", "padding": "12px 28px", "borderRadius": "8px", "fontSize": "16px", "fontWeight": "600"}}, ["Log Exercise"]), ((status && __jacJsx("p", {"style": {"marginTop": "14px", "color": "#16a34a", "fontWeight": "600"}}, [status])) || null)]);
}
export {LogExerciseForm};
if (typeof globalThis !== "undefined") { if (!globalThis.__jacEndpointEffects__) globalThis.__jacEndpointEffects__ = {}; Object.assign(globalThis.__jacEndpointEffects__, {"func:LogExerciseForm": {"is_writer": true, "touches": ["*"]}}); };
//# sourceMappingURL=LogExercise.js.map

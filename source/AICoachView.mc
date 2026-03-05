import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Activity;
import Toybox.Application;

class AICoachView extends WatchUi.DataField {

    // Simple state variables
    private var mWorkoutData as Dictionary or Null;
    private var mWorkoutManager as WorkoutManager or Null;
    
    // UI drawing cache
    private var mHr as Number or String = "--";
    private var mHrColor as Number = Graphics.COLOR_LT_GRAY;
    private var mSpeed as Number or String = "--:--";
    private var mTimerStr as String = "00:00";
    private var mTargetStr as String = "Ready";
    private var mPromptStr as String = "Waiting...";

    function initialize() {
        DataField.initialize();
        
        // Setup initial data if we have any cached
        var savedData = Application.Storage.getValue("workout_payload");
        if (savedData != null) {
            mWorkoutData = savedData as Dictionary;
            if (mWorkoutData.hasKey("steps")) {
                mWorkoutManager = new WorkoutManager(mWorkoutData["steps"] as Array);
            }
        }
    }

    // Connects layout XML
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called automatically every 1 second by Garmin OS
    function compute(info as Activity.Info) as Void {
        
        // 1. Process Telemetry (HR / Pace)
        if (info != null && info.currentHeartRate != null) {
            mHr = info.currentHeartRate;
            if (mHr > 160) {
                mHrColor = Graphics.COLOR_RED;
            } else if (mHr > 130) {
                mHrColor = Graphics.COLOR_ORANGE;
            } else {
                mHrColor = Graphics.COLOR_GREEN;
            }
        } else {
            mHr = "--";
            mHrColor = Graphics.COLOR_LT_GRAY;
        }

        if (info != null && info.currentSpeed != null && info.currentSpeed > 0) {
            var speedMs = info.currentSpeed as Float;
            var paceSecsKm = 1000.0 / speedMs;
            var mins = (paceSecsKm / 60.0).toNumber();
            var secs = (paceSecsKm.toNumber() % 60);
            mSpeed = mins + ":" + secs.format("%02d");
        } else {
            mSpeed = "--:--";
        }

        // 2. Process Timer / Workout logic
        if (info != null && info.timerState == Activity.TIMER_STATE_ON) {
            // User hit START on the watch!
            if (mWorkoutManager != null) {
                if (!mWorkoutManager.mIsRunning) {
                    mWorkoutManager.start();
                }
                
                // Let the manager look at the actual elapsed time if we wanted to 
                // Alternatively, we just let its internal timer tick like it was doing before.
                // The manager handles countdown and vibration.
                
                mTimerStr = mWorkoutManager.getTimeLeftString();
                mTargetStr = mWorkoutManager.getCurrentTargetString();
                mPromptStr = ""; // Hide overlay
            }
        } else if (info != null && (info.timerState == Activity.TIMER_STATE_PAUSED || info.timerState == Activity.TIMER_STATE_STOPPED)) {
            // User paused
            if (mWorkoutManager != null && mWorkoutManager.mIsRunning) {
                mWorkoutManager.stop();
            }
            mPromptStr = "Paused";
            if (mWorkoutManager != null) {
                mTimerStr = mWorkoutManager.getTimeLeftString();
                mTargetStr = mWorkoutManager.getCurrentTargetString();
            }
        } else {
            // Not started yet
            if (mWorkoutData != null) {
                var name = mWorkoutData["workoutName"] as String;
                mPromptStr = name + "\nPress Start Native";
            } else {
                mPromptStr = "Waiting for Data...";
            }
            mTimerStr = "00:00";
            mTargetStr = "READY";
        }
    }

    // Actually draws the labels 
    function onUpdate(dc as Dc) as Void {
        var promptLabel = View.findDrawableById("prompt") as WatchUi.Text;
        var targetLabel = View.findDrawableById("targetLabel") as WatchUi.Text;
        var timerLabel = View.findDrawableById("timerLabel") as WatchUi.Text;
        var hrLabel = View.findDrawableById("hrLabel") as WatchUi.Text;
        var paceLabel = View.findDrawableById("paceLabel") as WatchUi.Text;

        promptLabel.setText(mPromptStr);
        targetLabel.setText(mTargetStr);
        timerLabel.setText(mTimerStr);
        hrLabel.setText(mHr.toString());
        hrLabel.setColor(mHrColor);
        paceLabel.setText(mSpeed.toString());

        View.onUpdate(dc);
    }
}

import Toybox.Timer;
import Toybox.Attention;
import Toybox.System;
import Toybox.Lang;

class WorkoutManager {

    private var mSteps as Array;
    private var mCurrentStepIndex as Number = 0;
    private var mStepTimeLeft as Number = 0;
    private var mTimer as Timer.Timer or Null;
    public var mIsRunning as Boolean = false;

    function initialize(steps as Array) {
        mSteps = steps;
    }

    function start() as Void {
        if (!mIsRunning && mSteps.size() > 0) {
            mIsRunning = true;
            
            // Start the first interval
            if (mCurrentStepIndex >= mSteps.size()) {
                mCurrentStepIndex = 0;
            }
            
            startInterval(mCurrentStepIndex);
            
            mTimer = new Timer.Timer();
            // Call every 1000ms (1 second)
            mTimer.start(method(:onTimerTick), 1000, true);
        }
    }

    function stop() as Void {
        if (mIsRunning) {
            mIsRunning = false;
            if (mTimer != null) {
                mTimer.stop();
            }
        }
    }

    function saveAndExit() as Void {
        stop();
    }

    private function startInterval(index as Number) as Void {
        var step = mSteps[index] as Dictionary;
        mStepTimeLeft = step.get("duration") as Number;
        
        System.println("Starting Interval " + index + ": " + step.get("type"));
        
        // Vibrate to alert user of interval change
        if (Attention has :vibrate) {
            var vibeProfile = [
                new Attention.VibeProfile(100, 1000) // 100% power, 1000ms
            ];
            Attention.vibrate(vibeProfile);
        }
    }

    function onTimerTick() as Void {
        if (mStepTimeLeft > 0) {
            mStepTimeLeft -= 1;
            
            if (mStepTimeLeft <= 0) {
                // Interval finished
                mCurrentStepIndex += 1;
                
                if (mCurrentStepIndex < mSteps.size()) {
                    startInterval(mCurrentStepIndex);
                } else {
                    // Workout finished
                    saveAndExit();
                    System.println("Workout Complete!");
                    // Give a long vibration pattern for finish
                    if (Attention has :vibrate) {
                        var vibeProfile = [
                            new Attention.VibeProfile(100, 500),
                            new Attention.VibeProfile(0, 200),
                            new Attention.VibeProfile(100, 500),
                            new Attention.VibeProfile(0, 200),
                            new Attention.VibeProfile(100, 1000)
                        ];
                        Attention.vibrate(vibeProfile);
                    }
                }
            }
        }
    }

    function getStatusText() as String {
        if (!mIsRunning) {
            return "Paused";
        }
        if (mCurrentStepIndex < mSteps.size()) {
            var step = mSteps[mCurrentStepIndex] as Dictionary;
            return "Phase: " + step.get("type") + "\nTarget: " + step.get("target") + "\nTime Left: " + mStepTimeLeft + "s";
        }
        return "Done!";
    }

    function getCurrentTargetString() as String {
        if (!mIsRunning) { return "Ready"; }
        if (mCurrentStepIndex < mSteps.size()) {
             var step = mSteps[mCurrentStepIndex] as Dictionary;
             var t = step.get("type") as String;
             var tg = step.get("target") as String;
             return t.toUpper() + " • " + tg.toUpper();
        }
        return "WORKOUT COMPLETE";
    }

    function getTimeLeftString() as String {
        if (!mIsRunning) { return "00:00"; }
        var mins = mStepTimeLeft / 60;
        var secs = mStepTimeLeft % 60;
        return mins + ":" + secs.format("%02d");
    }
}

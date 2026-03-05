import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.Time;
import Toybox.System;

(:background)
class AICoachApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
        // Register the background process to run every 5 minutes
        if (Toybox.System has :ServiceDelegate) {
            var tz = new Time.Duration(5 * 60); 
            try {
                Background.registerForTemporalEvent(tz);
                System.println("Background service registered");
            } catch (e) {
                System.println("Could not register background: " + e.getErrorMessage());
            }
        }
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new AICoachView() ];
    }
    
    // Triggered when background service wakes up
    function getServiceDelegate() as [System.ServiceDelegate] {
        return [new BackgroundServiceDelegate()];
    }

    // Triggered when the background service Background.exit(data) completes
    function onBackgroundData(data as Application.PersistableType) as Void {
        if (data != null && data instanceof Dictionary) {
            var dict = data as Dictionary;
            if (dict.hasKey("steps")) {
                 Application.Storage.setValue("workout_payload", dict);
                 System.println("Saved workout payload to storage!");
            }
        }
    }
}

function getApp() as AICoachApp {
    return Application.getApp() as AICoachApp;
}

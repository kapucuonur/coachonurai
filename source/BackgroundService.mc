import Toybox.Background;
import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.Application;

(:background)
class BackgroundServiceDelegate extends System.ServiceDelegate {

    function initialize() {
        ServiceDelegate.initialize();
    }

    function onTemporalEvent() as Void {
        // Read the user's email from the Garmin Connect Settings
        var email = Application.Properties.getValue("user_email");
        
        // Use production URL. Falls back to default if no email is set.
        var baseUrl = "https://trihonor-api.onrender.com/api/garmin-app/workout";
        var url = baseUrl;
        
        if (email != null) {
            var emailStr = email.toString();
            if (emailStr.length() > 0 && !emailStr.equals("your@email.com")) {
                url = baseUrl + "?email=" + emailStr;
            }
        }
        
        System.println("Background: Fetching workout for: " + email + " from: " + url);
        
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        Communications.makeWebRequest(url, null, options, method(:onReceive));
    }

    function onReceive(responseCode as Number, data as Dictionary or Null) as Void {
        if (responseCode == 200 && data != null) {
            // Exit and pass data to the main app
            Background.exit(data);
        } else {
            Background.exit(null);
        }
    }
}

# AI-Coach Garmin Connect IQ Data Field

[View on Connect IQ Store / Developer Dashboard](https://apps-developer.garmin.com/apps/48e12168-f92a-4cc4-a15f-bd04d92a4a8d)

AI-Coach Training Target is a Connect IQ Data Field for [coachonurai.com](https://coachonurai.com) subscribers.

It overlays your AI-generated interval targets directly inside Garmin's native Run, Cycle, and Swim apps — so you keep all of Garmin's native GPS, heart rate tracking, and activity recording while getting personalized coaching intelligence on screen.

## How it Works

*   **Background Sync:** The watch syncing your daily AI training plan automatically via your phone.
*   **Target Overlays:** Displays your current interval target (Zone 2, Zone 4, Rest, etc.) plus a countdown timer during your activity.
*   **Color-Coded Metrics:** Heart Rate is color-coded: **Green** (easy), **Orange** (threshold), **Red** (max effort).
*   **Live Pace:** Real-time pace displayed in min/km.

## Setup

1.  **Subscribe:** Sign up at [coachonurai.com](https://coachonurai.com).
2.  **Configuration:** Open Garmin Connect app → My Device → Connect IQ Apps → AI-Coach Settings.
3.  **Authentication:** Enter your coachonurai.com account email address.
4.  **Activation:** Start your native Run or Cycle activity and add **AI-Coach** as a custom Data Screen.

Your personalized workout will appear automatically every time you train.

## Project Structure

*   `source/AICoachApp.mc`: Main application entry point and background service registry.
*   `source/AICoachView.mc`: The UI layer that draws metrics, timers, and current workout phases.
*   `source/WorkoutManager.mc`: Core logic for interval countdowns and phase transitions.
*   `source/BackgroundService.mc`: The service that fetches JSON workout payloads from the API.
*   `resources/`: Contains layouts, string definitions, and settings properties schema.

## Permissions Required

*   `Background`: To run fetching services behind the scenes.
*   `Communications`: To make HTTP requests to the backend API.

## Supported Devices

Fenix 7 series, Forerunner (255, 265, 955, 965, 970), Enduro 3, Epix 2, and Venu 3 series.

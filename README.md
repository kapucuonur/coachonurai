# AI-Coach Garmin Connect IQ Data Field

A Garmin Connect IQ Data Field application that connects to the AI-Coach backend to pull down dynamic, AI-generated workout intervals based on daily user telemetry and goals.

## Overview
This Garmin Data Field application displays real-time statistics (Heart Rate, Pace) and acts as an interval training coach. It fetches your daily personalized workout via the AI-Coach REST API and guides you through each step (e.g., Warm-up, Run, Recover, Cool-down) using on-device vibrations and visual cues.

## Features
*   **Real-time Workout Sync:** Runs a background service to fetch user-specific workouts from `trihonor-api.onrender.com`.
*   **Dynamic Intervals:** Supports variable duration intervals based on your training block.
*   **Haptic Feedback:** Vibrates on interval changes to keep your eyes on the road.
*   **HR and Pace Metrics:** Displays live heart rate (with color-coded zones: Green, Orange, Red) and pace.

## Project Structure
*   `source/AICoachApp.mc`: Main application entry point and background service registry.
*   `source/AICoachView.mc`: The UI layer that draws metrics, timers, and current workout phases.
*   `source/WorkoutManager.mc`: Core logic for interval countdowns and phase transitions.
*   `source/BackgroundService.mc`: The service that fetches JSON workout payloads from the API.
*   `resources/`: Contains layouts, string definitions, and settings properties schema.

## Setup Requirements
1.  **Garmin Connect IQ SDK:** Ensure the Connect IQ SDK is installed via the Garmin SDK Manager.
2.  **API Key / Email:** The application requires the user to input their email via Garmin Connect Mobile settings so it can fetch the correct customized workout.

## Permissions Required
*   `Background`: To run fetching services behind the scenes.
*   `Communications`: To make HTTP requests to the backend API.

## Supported Devices
Fenix 7 series, Forerunner (255, 265, 955, 965, 970), Enduro 3, Epix 2, and Venu 3 series.

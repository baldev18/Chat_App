# Firebase Setup Instructions

To get this app fully working with Firebase, please follow these steps carefully:

## 1. Create a Firebase Project
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Click on **Add Project** and give it a name (e.g., `WhatsApp Clone`).
3. Follow the setup wizard (Google Analytics is optional).

## 2. Enable Authentication
1. In the Firebase console, go to **Build -> Authentication**.
2. Click **Get Started**.
3. Go to the **Sign-in method** tab and enable **Email/Password**.

## 3. Enable Cloud Firestore
1. Go to **Build -> Firestore Database**.
2. Click **Create Database**.
3. Start in **Test Mode** (Note: this allows anyone to read/write for 30 days. Update your security rules before production).

## 4. Enable Firebase Storage
1. Go to **Build -> Storage**.
2. Click **Get Started**.
3. Start in **Test Mode**.

## 5. Add Android App to Firebase
1. On the Firebase project overview page, click the **Android** icon.
2. Enter the package name: `com.example.chat_app` (or check `android/app/build.gradle` `applicationId`).
3. Download the `google-services.json` file.
4. Place `google-services.json` in the `android/app/` directory of your Flutter project.
5. In `android/build.gradle`, add the google services dependency (usually done automatically by Flutter 3.x+ with new plugins).

## 6. Run the App
Once everything is set up, open your terminal in the `chat_app` directory and run:
```bash
flutter run
```

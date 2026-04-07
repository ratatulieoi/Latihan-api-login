# Flutter Assignment Login

A Flutter login application for the assignment requirement **"membuat Form Login menggunakan TOKEN dari API"**.

## Features

- Login form with real API request to `https://dummyjson.com/auth/login`
- Uses **provider + repository + service** architecture
- Parses and stores `accessToken` and `refreshToken`
- Saves login session to local storage with `shared_preferences`
- Restores login session when the app is reopened
- Shows whether the current session comes from API or local storage
- Handles loading state, validation, and login error messages
- Logout flow to clear saved session
- Clean Material 3 UI with responsive card layout

## Architecture

Project structure:

```text
lib/
├── core/
│   ├── errors/
│   │   └── auth_exception.dart
│   └── theme/
│       └── app_theme.dart
├── data/
│   ├── models/
│   │   └── auth_session.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   ├── services/
│   │   └── auth_service.dart
│   └── storage/
│       └── session_storage.dart
├── presentation/
│   ├── providers/
│   │   └── auth_provider.dart
│   └── screens/
│       ├── auth_gate_screen.dart
│       ├── home_screen.dart
│       └── login_screen.dart
└── main.dart
```

### Responsibility of each layer

- **Service**: calls the API and parses the response token.
- **Repository**: connects service and local storage.
- **Provider**: manages UI state like loading, error, authenticated session.
- **Presentation**: screens and widgets shown to the user.

## API Used

- **Endpoint**: `POST https://dummyjson.com/auth/login`
- **Request body**:

```json
{
  "username": "emilys",
  "password": "emilyspass"
}
```

- **Response fields used**:
  - `accessToken`
  - `refreshToken`
  - `username`
  - `email`
  - `firstName`
  - `lastName`

## Demo Account

Use this account to test login:

- **Username**: `emilys`
- **Password**: `emilyspass`

The login form is prefilled to make the assignment easier to demonstrate.

## How to Run

```bash
flutter pub get
flutter run
```

For web:

```bash
flutter run -d chrome
```

## Verification

This project has been verified with:

```bash
flutter analyze
flutter test
flutter build web --release
```

## Notes

- This project already matches Modul 6 in a simple way: local storage, basic caching of login session, and minimal offline behavior.
- Session data is stored locally using `shared_preferences` for assignment simplicity.
- For production apps, token storage should use a more secure approach.

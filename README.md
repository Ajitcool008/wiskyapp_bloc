# wiskyapp

A Flutter project demonstration implementation of CLEAN architecture with BLoC.

## Features

**Authentication:** Simple sign-in flow with email validation
**Collection Management:** Grid view of whisky bottles with basic information
**Bottle Details:** Comprehensive information about each bottle
**Tasting Notes:** Expert tasting notes with nose, palate, and finish descriptions
**Offline Support:** Local data persistence for offline access


## Technical Implementation

**Architecture**
The app follows a clean architecture with:

**Presentation Layer:** UI screens and BLoC state management
**Domain Layer:** Business logic and repository interfaces
**Data Layer:** Data models and repository implementations

**State Management**
BLoC (Business Logic Component) pattern is used for state management, providing:

- Clear separation of UI and business logic
- Unidirectional data flow
- Predictable state transitions
- Testable components

## Offline Support
The app implements a repository pattern that:

- Attempts to fetch data from mock JSON files (simulating an API)
- Stores fetched data locally using SharedPreferences
- Falls back to local data when offline
- Provides a refresh mechanism to update data when back online

## Dependencies
The app uses the following packages:

- flutter_bloc: State management using BLoC pattern
- equatable: Value equality for efficient rebuilds in BLoC
- connectivity_plus: Network connectivity detection
- shared_preferences: Local storage for offline support
- path_provider: Access to device file system


For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

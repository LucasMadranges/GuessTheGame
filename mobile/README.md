# GuessTheGame (Mobile)

This is a Flutter mobile/tablet application scaffold implementing the GuessTheGame concept with Clean Architecture (Domain, Data, Presentation) and MVVM. It demonstrates required technical constraints from the project brief.

## How it meets the constraints

- Flutter app, mobile-first (Android/iOS). Not configured for Web.
- Clean Architecture structure with MVVM ViewModels using Provider.
- REST API integration: uses jsonplaceholder.typicode.com as a mock backend to fetch game items and images.
- Implements at least 3 advanced features:
  - Internationalization (i18n) with English and French via Flutter gen-l10n.
  - Named route navigation with guards (onboarding gate) using go_router.
  - Robust error handling with simple automatic retry for remote calls.
- Additional features from brief:
  - 5 screens with complex navigation: Splash (guard), Home (list of daily games), Play (6-step guessing), History (CRUD over in-memory guesses), Settings (language switch).
  - CRUD over an entity (Guess) stored in-memory for simplicity (can be swapped for SQLite/Hive).
  - Search/filter can be easily added on Home (scaffold prepared); current UI focuses on browsing and play. 
  - Loading and error states included via a shared widget.
  - Responsive interface: grid/list adapts to width; play screen adapts layout portrait/landscape.

## Architecture Overview

- lib/
  - core/di: Simple dependency provider.
  - data/: Remote API with retry and repository implementation.
  - domain/: Entities and repository abstraction.
  - presentation/: Router, state, ViewModels (MVVM), screens, shared widgets.
  - l10n/: ARB files for en/fr used by Flutter's localization tool.

## Running

1. Ensure Flutter SDK is installed (3.9+), then run:

```
flutter pub get
flutter run
```

2. To change language at runtime, go to Settings screen.

## L10n

Localization is powered by Flutter gen-l10n. ARB files:
- lib/l10n/app_en.arb
- lib/l10n/app_fr.arb

## Notes

- Network data uses jsonplaceholder as a mock; Game of the Day is derived from date math over the dataset.
- Guess CRUD is in-memory to keep the scaffold minimal; replace GameRepositoryImpl storage with Hive/SQLite to enable persistence and offline mode.

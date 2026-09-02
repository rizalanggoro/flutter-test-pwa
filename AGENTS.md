# test_pwa

Flutter PWA todo list app (SDK ^3.13.2). Data stored in browser localStorage.

## Commands

- `flutter analyze` — lint/analysis (uses `flutter_lints` package, excludes `build/` and `web/`)
- `flutter test` — widget tests
- `flutter run -d chrome` — dev server with PWA support
- `flutter build web` — production build (outputs to `build/web/`)

## Architecture

- `lib/main.dart` — app entry + todo list UI
- `lib/todo.dart` — Todo model with JSON serialization
- `lib/todo_service.dart` — localStorage read/write via `package:web`
- `web/manifest.json` — PWA manifest (installable)
- `web/index.html` — service worker bootstrap

## Notes

- Uses `package:web` (not `dart:html`) for web APIs
- PWA install: run `flutter build web` then serve `build/web/` with any static server
- Service worker auto-registered by Flutter's `flutter_bootstrap.js`

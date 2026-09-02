# test_pwa

Flutter PWA project (SDK ^3.13.2). Default starter template — no custom build or deploy tooling yet.

## Commands

- `flutter analyze` — lint/analysis (uses `flutter_lints` package, excludes `build/` and `web/`)
- `flutter test` — widget tests
- `flutter run -d chrome` — dev server with PWA support (service worker via `web/`)
- `flutter build web` — production web build

## Notes

- Entry point: `lib/main.dart`
- Web config: `web/manifest.json` (PWA manifest), `web/index.html` (service worker bootstrap)
- No CI, no custom scripts, no codegen, no environment files

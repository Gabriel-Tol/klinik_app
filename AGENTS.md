# AGENTS.md

Single-package Flutter app (clinic / klinik app). No monorepo, no CI, no `opencode.json`.

## Commands

- `flutter pub get` — after any `pubspec.yaml` change
- `flutter analyze` — lint gate (config: `analysis_options.yaml`, `flutter_lints`)
- `flutter test` — all tests; `flutter test test/widget_test.dart` — one file
- `flutter run -d windows` — dev is on Windows; `-d chrome` also works

Required order for verification: `flutter analyze` → `flutter test`.

## Verify before trusting analyze

- `flutter test` passes even if unreferenced code is broken — check `flutter analyze` too.

## Architecture

- Entry point: `lib/main.dart` — `MaterialApp` (title `Klinik APP`, banner off) → `home: HomePage()`.
- `lib/ui/home_page.dart` = dashboard with 3 menus (Data Poli / Data Pegawai / Data Pasien), each pushing its list page. List → detail pages follow the same pattern: `poli_page`→`poli_detail`, `pegawai_page`→`pegawai_detail`, `pasien_page`→`pasien_detail`. Only the "Poli Anak" card in `poli_page.dart` is wired (tutorial state); Pegawai/Pasien lists wire every row.
- Data classes in `lib/model/` (`Poli`, `Pegawai`, `Pasien`) — mutable fields, camelCase names, sample data hardcoded in the list pages.
- No state management, no backend, no HTTP, no assets, no fonts. Only runtime dependency besides Flutter SDK is `cupertino_icons`.
- Android package: `com.example.klinik_app` (`android/app/src/main/kotlin/...`).

## Toolchain quirks

- `pubspec.yaml` requires Dart `^3.13.4` (Flutter 3.47.5 stable in this environment) — older SDKs will not resolve dependencies. The SDK pin matters even though current `main.dart` has no exotic syntax.
- `analysis_options.yaml` excludes `build/**`, `android/**`, `ios/**`, `web/**`, `windows/**`, `macos/**`, `linux/**`. Never expect `flutter analyze` to catch problems in platform folders.
- `test/widget_test.dart` pumps `MyApp` and walks each dashboard menu → list → detail. Change the home screen or sample data → update it in the same change. It uses a `package:` import for `main.dart` (`avoid_relative_lib_imports` must stay clean).
- Platform directories (`android/`, `ios/`, `windows/`, `linux/`, `macos/`, `web/`) are Flutter-generated scaffolding; edit them only when the change is genuinely platform-specific.

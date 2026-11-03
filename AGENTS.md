# AGENTS.md

Single-package Flutter app (clinic / klinik app). No monorepo, no CI, no `opencode.json`.

## Commands

- `flutter pub get` — after any `pubspec.yaml` change
- `flutter analyze` — lint gate (config: `analysis_options.yaml`, `flutter_lints`)
- `flutter test` — all tests; `flutter test test/widget_test.dart` — one file
- `flutter run -d windows` — dev is on Windows; `-d chrome` also works

Required order for verification: `flutter analyze` → `flutter test`.

## Git

- Always commit and push when a change is finished: verify (`flutter analyze` → `flutter test`) → `git add` → `git commit` → `git push origin main`. Never leave finished work uncommitted.

## Verify before trusting analyze

- `flutter test` passes even if unreferenced code is broken — check `flutter analyze` too.

## Architecture

- Entry point: `lib/main.dart` — `MaterialApp` (title `Klinik`, banner off) → `home: Beranda()` (`ui/beranda.dart`). The former entry point `lib/ui/home_page.dart` (dashboard with the 3 menus) is no longer the app home and is not reachable from the sidebar.
- `lib/widget/sidebar.dart` = `Drawer` used by `Beranda`, `PoliPage`, `PegawaiPage`, `PasienPage`: Beranda / Poli / Pegawai / Pasien (all pushed via `Navigator.push`) and Keluar (`pushAndRemoveUntil` to `Login`, clearing the stack).
- `lib/ui/home_page.dart` = dashboard with 3 menus (Data Poli / Data Pegawai / Data Pasien), each pushing its list page. The same pattern repeats per entity (`poli` / `pegawai` / `pasien`): `*_page` (list, sample data hardcoded in a State field) → `*_item` (row, tap → detail) → `*_detail` (shows fields + Ubah/Hapus buttons) → `*_form` (add) / `*_update_form` (edit). All three lists are fully wired; each list page's AppBar "+" adds an item.
- Deletion propagates via `Navigator.pop(context, true)` from the detail page → `onDeleted` callback on the item → `setState` remove in the list page. The Hapus button first opens a confirmation `AlertDialog` (Batal/Hapus) in all three detail pages — deletion only happens on confirm. Edits mutate the shared model object in place (`widget.poli.namaPoli = ...`), so the list reflects changes without any notification — the same instance lives in the list.
- Data classes in `lib/model/` (`Poli`, `Pegawai`, `Pasien`) — mutable fields, camelCase names, unused `id` field. Forms pop the new/edited model with no validation: `_formKey` exists but `validate()` is never called and fields have no validators. Data is in-memory only; nothing persists across restarts.
- Pegawai password is `obscureText: true` in both forms and deliberately not shown in `pegawai_detail.dart` — keep it that way.
- No state management, no backend, no HTTP, no assets, no fonts. Only runtime dependency besides Flutter SDK is `cupertino_icons`.
- Android package: `com.example.klinik_app` (`android/app/src/main/kotlin/...`).

## Toolchain quirks

- `pubspec.yaml` requires Dart `^3.13.4` (Flutter 3.47.5 stable in this environment) — older SDKs will not resolve dependencies. The SDK pin matters even though current `main.dart` has no exotic syntax.
- `analysis_options.yaml` excludes `build/**`, `android/**`, `ios/**`, `web/**`, `windows/**`, `macos/**`, `linux/**`. Never expect `flutter analyze` to catch problems in platform folders.
- `test/widget_test.dart` pumps `MyApp` and walks Beranda → sidebar drawer → each list → detail. Change the home screen, sidebar or sample data → update it in the same change. It uses a `package:` import for `main.dart` (`avoid_relative_lib_imports` must stay clean).
- Platform directories (`android/`, `ios/`, `windows/`, `linux/`, `macos/`, `web/`) are Flutter-generated scaffolding; edit them only when the change is genuinely platform-specific.

# AGENTS.md

Single-package Flutter app (clinic / klinik app). No monorepo, no CI, no `opencode.json`.

## Commands

- `flutter pub get` — after any `pubspec.yaml` change
- `flutter analyze` — lint gate (config: `analysis_options.yaml`, `flutter_lints`)
- `flutter test` — all tests; `flutter test test/widget_test.dart` — one file
- `flutter run -d windows` — dev is on Windows; `-d chrome` also works
- `npx json-server@0.17.4 db.json` — backend mock REST (port 3000, seed in `db.json`). Start it before running the app against the API; the app fails to load data while it's down. Runtime edits are written back into `db.json` (commit them or `git checkout db.json` to reset the seed).

Required order for verification: `flutter analyze` → `flutter test`.

## Git

- Always commit and push when a change is finished: verify (`flutter analyze` → `flutter test`) → `git add` → `git commit` → `git push origin main`. Never leave finished work uncommitted.

## Verify before trusting analyze

- `flutter test` passes even if unreferenced code is broken — check `flutter analyze` too.

## Architecture

- Entry point: `lib/main.dart` — async: `WidgetsFlutterBinding.ensureInitialized()` → read token from SharedPreferences → `MyApp(home: token == null ? Login() : Beranda())`. `MyApp` takes a **required `home` param** (tests pump `MyApp(home: Beranda())`); it is not const anymore. The former entry point `lib/ui/home_page.dart` (dashboard with the 3 menus) is no longer the app home and is not reachable from the sidebar.
- `lib/helpers/` = `user_info.dart` (SharedPreferences token/userID/username + logout) and `api_client.dart` (global `Dio` + `ApiClient` get/post/put/delete). `baseUrl` = `http://localhost:3000/` — local json-server (`db.json`, started with `npx json-server@0.17.4 db.json`), routes are `poli`/`pegawai`/`pasien` appended by the services. Chosen after mockapi.io's free tier (2 resources) couldn't hold all 3 tables and MockHive's beta POST was broken; json-server speaks the same REST shape the module assumes (GET list → array, POST/PUT → object with id, DELETE → empty body).
- `lib/service/` = `login_service.dart` (dummy login: `admin`/`admin` → sets token), `poli_service.dart`, `pegawai_service.dart`, `pasien_service.dart` (CRUD via `ApiClient`, snake_case JSON keys matching `db.json`). `hapus()` returns `Future<void>` (not the model) because json-server's DELETE has no response body — the module's mockapi did return one. Since pertemuan 12–13 the pages call these services: lists and details read through `StreamBuilder` (`getList()` / `getData()`), forms call `simpan`/`ubah`, detail calls `hapus`.
- `lib/widget/sidebar.dart` = `Drawer` used by `Beranda`, `PoliPage`, `PegawaiPage`, `PasienPage`: Beranda / Poli / Pegawai / Pasien (all pushed via `Navigator.push`) and Keluar (`pushAndRemoveUntil` to `Login`, clearing the stack).
- `lib/ui/home_page.dart` = dashboard with 3 menus (Data Poli / Data Pegawai / Data Pasien), each pushing its list page. The same pattern repeats per entity (`poli` / `pegawai` / `pasien`): `*_page` (list — a `StreamBuilder` over `getList()`; any `setState` on the page builds a new stream, which is how refetch happens) → `*_item` (row, tap → detail) → `*_detail` (`getData()` StreamBuilder, Ubah/Hapus buttons) → `*_form` (add) / `*_update_form` (edit, `getData()` refills the fields in `initState`). All three lists are fully wired; each list page's AppBar "+" adds an item.
- Deletion propagates via `Navigator.pop(context, true)` from the detail page → `onDetailClosed` callback on the item → `setState` on the list page, which refetches from the API (there is no local list to mutate anymore). The Hapus button first opens a confirmation `AlertDialog` (Batal/Hapus) in all three detail pages — on confirm it calls `Service().hapus()` then pops. After an edit the detail page `setState`s and refetches; the list refetches when the detail closes. Deviation from the module: it uses `pushReplacement` for these flows, which would stack a second list page — pop + refetch keeps the existing navigation contract instead.
- Data classes in `lib/model/` (`Poli`, `Pegawai`, `Pasien`) — mutable fields, camelCase names; `id` is `String?` because `fromJson` does `json["id"]?.toString()` (json-server sends numbers). Forms pop the model returned by the API with no validation: `_formKey` exists but `validate()` is never called and fields have no validators. Persistence lives in `db.json` via json-server.
- Pegawai password is `obscureText: true` in both forms and deliberately not shown in `pegawai_detail.dart` — keep it that way.
- No state management, no assets, no fonts. Runtime dependencies: `cupertino_icons`, `dio ^4.0.6` (pinned by the module; pub reports known security advisories on this version — upgrading to dio 5.x means `DioError`→`DioException` and int→`Duration` timeouts in `api_client.dart`), `shared_preferences ^2.0.15`.
- Android package: `com.example.klinik_app` (`android/app/src/main/kotlin/...`).

## Toolchain quirks

- `pubspec.yaml` requires Dart `^3.13.4` (Flutter 3.47.5 stable in this environment) — older SDKs will not resolve dependencies. The SDK pin matters even though current `main.dart` has no exotic syntax.
- `analysis_options.yaml` excludes `build/**`, `android/**`, `ios/**`, `web/**`, `windows/**`, `macos/**`, `linux/**`. Never expect `flutter analyze` to catch problems in platform folders.
- `test/widget_test.dart` mocks SharedPreferences (`setMockInitialValues({})`) and installs a fake `HttpClientAdapter` (`_MockJsonServer`, same data as `db.json`) on the global `dio` in `setUp` — tests never hit the network, so json-server does not need to run for `flutter test`. It covers login (wrong creds → dialog, `admin`/`admin` → Beranda) and pumps `MyApp(home: Beranda())` to walk Beranda → sidebar drawer → each list → detail, plus add/update/delete through the API. Change the home screen, sidebar, login or sample data → update it in the same change. It uses a `package:` import for `main.dart` (`avoid_relative_lib_imports` must stay clean).
- Platform directories (`android/`, `ios/`, `windows/`, `linux/`, `macos/`, `web/`) are Flutter-generated scaffolding; edit them only when the change is genuinely platform-specific.

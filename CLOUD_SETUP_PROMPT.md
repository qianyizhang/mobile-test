# Saved Linux cloud environment setup request

## How to use

Select `qianyizhang/mobile-test` in the saved cloud coding environment configuration UI. Use a Linux x86-64 environment. Paste the request below into the setup conversation. Have the resulting reproducible setup script saved in that environment's setup configuration, then save the environment and select it for later coding tasks.

This document is a prompt, not an already-created environment or a runnable shell script. A temporary task machine is not automatically a saved configuration. If the available UI/tools cannot create or save the configuration, the assistant must give you the prepared script and the precise remaining UI step rather than claiming the configuration exists.

## Copy this request

```text
Configure a testable saved Linux cloud coding environment for qianyizhang/mobile-test, a root-level Flutter calculator project targeting Android and iOS.

Scope and safety
- Work only in the selected cloud environment. Do not connect to, install on, or change my Mac or any other personal computer.
- Do not purchase services, enable paid GitHub Actions/hosted runners, deploy, publish a release, configure production signing, change repository/account/security settings, add credentials, or create persistent access.
- Prepare and verify the environment setup script. Do not push application or configuration changes unless I separately request it. If saving the cloud environment requires a UI action you cannot perform, tell me exactly what I need to save; never claim that a prompt alone created a saved environment.
- Reuse compatible installed tooling before downloading anything. Do not upgrade the whole OS, Flutter, Gradle or project dependencies. Do not replace the checked-in native scaffolds with a newly generated app.
- Review official SDK terms with me before any new acceptance, including terms required to download Android command-line tools. Stop for my approval when acceptance is required. Never pipe yes into sdkmanager, flutter doctor --android-licenses, or another license command; never synthesize accepted-license files. Already accepted licenses may be reused only where legitimately available in this environment.

1. Inspect before changing anything
- Confirm the repository checkout, branch, clean/dirty state, root pubspec.yaml, Linux distribution, x86-64 architecture, available disk/memory, current Flutter/Dart, JDK, Android SDK and environment variables.
- Check Flutter with flutter --version --machine; use Flutter 3.47.7 stable and bundled Dart 3.13.5. Do not run flutter upgrade.
- Keep logs and installation caches out of tracked source. Record every tool version and any blocked requirement.

2. Linux prerequisites and pinned Flutter
- On Debian/Ubuntu, install only missing prerequisites through the official distribution package repositories: ca-certificates, curl, git, unzip, xz-utils, zip, libglu1-mesa and openjdk-17-jdk-headless. Use apt-get update and apt-get install only if supported and authorized in this cloud machine. Do not run apt-get upgrade. If privileges or networking are blocked, report the exact blocker rather than bypassing it.
- Reuse an existing Flutter 3.47.7 installation if verified. Otherwise download the official Linux x64 stable archive:
  https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.47.7-stable.tar.xz
  Verify against SHA-256:
  af7455f540df951184c7953fbe3cf884766e7541dacf8571f9f582db03dd6230
- Cross-check archive identity and checksum against the official release metadata before use:
  https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json
  If the URL or hash disagrees, stop and report it; do not silently install another version.
- Extract into a writable tool directory outside the repository, for example $HOME/tools/flutter-3.47.7/flutter. Avoid overwriting another SDK. Set FLUTTER_ROOT to that directory and prepend $FLUTTER_ROOT/bin to PATH.
- Persist environment-variable declarations only in this saved cloud environment's supported setup/startup mechanism. Export them for the current process too; exports in a completed setup process alone may not survive the next task. Do not modify personal computer or account settings.
- Run flutter --version, dart --version and flutter precache --android. Preserve the project's lockfile.

3. Java and Android SDK
- Use JDK 17. Read android/gradle/wrapper/gradle-wrapper.properties, android/settings.gradle.kts and android/app/build.gradle.kts to verify the actual Gradle/AGP versions. The pinned Flutter template is Gradle 9.3.1 and AGP 9.1.0; official AGP 9.1 compatibility specifies JDK 17 and Build Tools 36.0.0. Do not mistake Java/Kotlin source target settings for the JDK that runs Gradle.
- Set JAVA_HOME to the verified JDK 17 installation and prepend $JAVA_HOME/bin to PATH. Verify which Java Flutter actually uses with flutter doctor -v and Gradle with ./gradlew --version inside android. If Flutter selects a different existing Android Studio JDK, report the mismatch and propose an environment-scoped fix rather than changing unrelated global settings.
- Reuse a compatible Android SDK if installed. Otherwise, after my review/approval of the Android SDK license at https://developer.android.com/studio, obtain the official Linux command-line tools from that page. At preparation time it lists commandlinetools-linux-15859902_latest.zip, SHA-256 4e4c464f145a7512b57d088ac6c278c03c9eea610886b35a5e0804e74eedf583. Verify the download link and checksum against the official page; pin the verified filename and hash in the setup script instead of using an unversioned moving download.
- Set ANDROID_HOME to an environment-local SDK directory, for example $HOME/Android/Sdk. If ANDROID_SDK_ROOT is already used, ensure it points to the same SDK. Arrange the unpacked tools so sdkmanager exists at $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager, without an extra nested cmdline-tools directory. Include that bin directory and $ANDROID_HOME/platform-tools on PATH.
- Resolve compileSdk and NDK values from the checked-in app and the pinned Flutter SDK's packages/flutter_tools/gradle/src/main/kotlin/FlutterExtension.kt. Expected values are compileSdk 36 and NDK 28.2.13676358. Do not pick an arbitrary NDK or change the project to match preinstalled packages.
- Inspect installed packages with sdkmanager --list_installed. After required license review/approval, install only missing packages with sdkmanager --sdk_root="$ANDROID_HOME" "platform-tools" "platforms;android-36" "build-tools;36.0.0" "ndk;28.2.13676358". Install CMake only if the actual project build requires it, and resolve its exact required version first.
- Current Android documentation marks sdkmanager deprecated in favor of Android CLI but still documents/provides it in command-line tools. Use the available documented SDK management tool; report any incompatibility rather than inventing a successful install.
- Run flutter doctor --android-licenses interactively if licenses remain outstanding. Pause on new terms for my review and approval. If this cannot be done in the setup runner, report that Android build is blocked and provide the exact command for an interactive session. Dart/widget tests can still proceed.

4. Validate from the repository root
Run and record exit codes/output:
  flutter doctor -v
  flutter pub get
  dart format --output=none --set-exit-if-changed lib test
  flutter analyze
  flutter test
  bash scripts/check.sh
  flutter build apk --debug
The formatting command checks without rewriting files. Separate actual failures from optional flutter doctor warnings about missing desktop/browser/iOS targets. Do not suppress build, lint or test failures. Diagnose failures and retry only within the authorized setup scope; report application-code fixes needed separately.
Verify build/app/outputs/flutter-apk/app-debug.apk exists and record its size and SHA-256. Call the Android build verified only after the command succeeds and that artifact is present. This is development signing only; do not add a release keystore or attempt a store build.

5. Emulator and iOS boundaries
- Tests and APK builds do not require an emulator. Inspect /dev/kvm and, if emulator tooling already exists, emulator -accel-check. Do not change virtualization/security settings or create a paid emulator service. Report whether an emulator is truly available; do not promise interactive Android testing merely because an APK builds.
- Do not download large emulator/system-image packages or launch a device unless I ask for interactive testing. If later requested and supported, pin the system image and confirm any additional license terms first.
- Linux cannot build/run iOS or host Xcode/iOS Simulator. Leave the included ios/ scaffold intact. Give the separate macOS/Xcode steps in README.md, without operating my Mac, configuring Apple credentials or signing, or claiming an iOS build was tested.

6. Completion report and saved configuration
- Return the reproducible, idempotent cloud-only setup script; exact pinned tool versions; how the saved environment restores PATH/JAVA_HOME/ANDROID_HOME for subsequent tasks; and which caches must persist or be restored.
- Ensure setup does not auto-accept licenses when rerun. If required licenses are absent, it must stop the Android setup stage with a clear message rather than pretending success or hanging forever. Keep unit/widget validation independently runnable.
- Report format/analyze/test outcomes, Android APK path/hash if built, emulator capability, iOS limitation, and all remaining blockers. Distinguish 'Flutter tests ready', 'Android build ready', and 'device run verified'.
- If supported, save this setup for the chosen repository as the saved environment. Otherwise provide the precise user-facing save step. Explain how to select that saved environment for the next coding task. Do not claim a saved configuration or successful command unless verified.
```

## Official references checked for this request

- [Flutter manual install](https://docs.flutter.dev/install/manual)
- [Flutter Android setup and license checks](https://docs.flutter.dev/platform-integration/android/setup)
- [Android command-line tools and SDK terms](https://developer.android.com/studio)
- [SDK package management](https://developer.android.com/tools/sdkmanager)
- [Java selection in Android builds](https://developer.android.com/build/jdks)
- [AGP 9.1 compatibility](https://developer.android.com/build/releases/agp-9-1-0-release-notes)
- [Gradle Java compatibility](https://docs.gradle.org/current/userguide/compatibility.html)
- [Android emulator acceleration requirements](https://developer.android.com/studio/run/emulator-acceleration)
- [Flutter iOS setup](https://docs.flutter.dev/platform-integration/ios/setup)

Tool versions are pinned for this repository, not a recommendation to install the latest release. Reverify official download metadata before installation.

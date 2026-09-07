# Recording the actual TouchTips app

The primary video shows TouchTips itself, built from commit `8ae68aeebfc2450ddd3351e109d07a4256206a88` of https://github.com/harivansh-afk/TouchTips.

No screen, layout, style, navigation, or tab-bar implementation was changed for the capture. The only app-side change is the simulator-only fixture patch here, which replaces QA labels with fictional names and familiar place names when `TOUCHTIPS_QA_DATA=showcase`. The real app's views and persistence run normally.

`TabBarRecordingUITests.swift` launches that fixture, performs actual swipes and taps, and checks the Search button's rendered width to verify minimization and restoration. It also opens a person and uses Back. The video is captured by `simctl`, not generated from a storyboard or a mock animation.

## Reproduce

Use an isolated worktree of the TouchTips source at the commit above. Apply `touchtips-showcase.patch`, copy `TabBarRecordingUITests.swift` into `Tests/TouchTipsUITests`, then regenerate the Xcode project through TouchTips' dev shell (`nix develop -c just gen`).

Build for testing on a dedicated iPhone 17 Pro simulator:

```sh
xcodebuild -project TouchTips.xcodeproj -scheme TouchTips \
  -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
  -derivedDataPath build build-for-testing CODE_SIGNING_ALLOWED=NO
```

From this component repository:

```sh
scripts/record-touchtips.sh /path/to/touchtips-recording-worktree "$SIMULATOR_ID"
scripts/export.sh
```

This produces the plain portrait recording, its still frame, and the README GIF. The main TouchTips checkout and any real contact database are left alone. The standalone Fieldnotes sample remains available to try the extracted package; it is not the app shown in the primary recording.

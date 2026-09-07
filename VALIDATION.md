# Validation

Validated September 6, 2026 (America/New_York) using Xcode 26.6 (17F113), an iOS 26.5 runtime, and a dedicated iPhone 17 Pro simulator.

- Simulator build-for-testing passed without build warnings.
- Six state tests passed: drag reversal, directional snapping and ignored deceleration, short content, near-top restoration and bounce, restoring during a drag, and content becoming short.
- The UI integration test passed: minimize, reverse to restore, tap Places while minimized, keep short content expanded, switch back, open a detail, use Back, and open/dismiss Search.
- The recording test passed and drove the gestures visible in the media.
- Both exported MP4s were decoded fully with ffmpeg without errors.
- Captured frames were inspected at the expanded, minimized, reversed, tab-switched, and detail/back stages.

The demo is self-contained and has no network dependencies. Accessibility labels, selected traits, Reduce Motion handling, and Reduce Transparency handling are implemented; physical-device VoiceOver and GPU performance were not measured. Recordings are simulator demonstrations, not performance benchmarks.

Reproduce the functional checks with `scripts/build.sh <simulator UUID>` followed by `scripts/test.sh <simulator UUID>`.

## TouchTips recording — September 7, 2026

The primary media now shows the actual TouchTips app at `8ae68aeebfc2450ddd3351e109d07a4256206a88`, with only simulator fixture names changed. No app UI or tab-bar implementation was modified.

- The isolated TouchTips simulator build-for-testing passed.
- `TabBarRecordingUITests.testRecordTouchTips` passed, including assertions that the Search button shrinks during downward scrolling and returns to its original width after reversal and tab reselect.
- The test opened Maya Kapoor's person screen and returned using Back.
- The 20.2-second portrait export was fully decoded without errors and inspected at scrolling, restoration, person-detail, and return stages.
- The original app source, fixture patch, gesture test, and capture instructions are documented under `recording/`.

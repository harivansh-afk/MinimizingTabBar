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

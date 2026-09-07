# Demo assets

| File | Use |
| --- | --- |
| `demo-x.mp4` | 7-second cut showing only scrolling, minimization, and restoration; 886 × 1926 |
| `demo-portrait.mp4` | Full 20-second TouchTips recording; 886 × 1926 |
| `poster.png` | Still frame from the recording |
| `screenshot.png` | Still app screenshot |
| `preview.gif` | 320-pixel-wide portrait README preview |

Both MP4s use H.264, 60 fps output, YUV 4:2:0 and fast-start metadata, without audio. The original simulator capture uses variable frame timestamps; export resamples these to 60 fps without speeding up the interaction. This is an encoding property, not a device performance benchmark.

Recorded in the actual TouchTips app on a dedicated iPhone 17 Pro simulator using iOS 26.5. The data is fictional; the screens, navigation, and tab bar are the app's original implementation.

The footage shows TouchTips rendering its own UI, driven by XCTest swipes and taps. It has no title card, device frame, magnified inset, or other added graphics.

Regenerate with `scripts/record-touchtips.sh <TouchTips worktree> <simulator UUID>` and `scripts/export.sh`. See [recording/README.md](../recording/README.md) for preparation. The original source capture stays in ignored `media/raw/`; exported assets are committed. See `SUBMISSION.md` for draft copy.

The short cut uses seconds 3.8–10.8 of the full recording, at original speed. It excludes the person-detail navigation and most idle time. Set `SHORT_START` and `SHORT_DURATION` when exporting a different take.

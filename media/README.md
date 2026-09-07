# Demo assets

| File | Use |
| --- | --- |
| `demo-x.mp4` | 886 × 1926 plain simulator recording; same clip as `demo-portrait.mp4` |
| `demo-portrait.mp4` | 886 × 1926 plain simulator recording |
| `poster.png` | Still frame from the recording |
| `screenshot.png` | Still app screenshot |
| `preview.gif` | 320-pixel-wide portrait README preview |

Both MP4s use H.264, 60 fps output, YUV 4:2:0 and fast-start metadata, without audio. The original simulator capture uses variable frame timestamps; export resamples these to 60 fps without speeding up the interaction. This is an encoding property, not a device performance benchmark.

Recorded on a dedicated iPhone 17 Pro simulator using iOS 26.5. Fictional demo data; no contact access, remote images, or account setup.

The footage shows real SwiftUI rendering driven by XCTest swipes and taps. It has no title card, device frame, magnified inset, or other added graphics.

Regenerate with `scripts/record.sh <simulator UUID>` and `scripts/export.sh`. The original source capture stays in ignored `media/raw/`; exported assets are committed. See `SUBMISSION.md` for draft copy.

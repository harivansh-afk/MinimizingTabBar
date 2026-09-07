#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
FFMPEG=${FFMPEG:-ffmpeg}
FFPROBE=${FFPROBE:-ffprobe}
command -v "$FFMPEG" >/dev/null || { echo 'Install ffmpeg, or set FFMPEG to its executable path.'; exit 1; }
command -v "$FFPROBE" >/dev/null || { echo 'Install ffprobe, or set FFPROBE to its executable path.'; exit 1; }
mkdir -p build media
duration=$("$FFPROBE" -v error -show_entries format=duration -of default=nw=1:nk=1 media/raw/simulator.mov)
duration=$(awk -v duration="$duration" 'BEGIN { if (duration < 2) exit 1; printf "%.3f", duration - 0.6 }')
# Plain simulator footage at its original speed. Only normalize timestamps,
# resize for sharing, and trim the final test-runner teardown margin.
"$FFMPEG" -v warning -y -i media/raw/simulator.mov -vf 'fps=60,scale=886:1926:flags=lanczos' \
  -t "$duration" -c:v libx264 -preset slow -crf 19 -pix_fmt yuv420p -movflags +faststart -an media/demo-portrait.mp4
# Preserve Hari's manually edited main clip byte-for-byte.
# Supply SHORT_VIDEO=/path/to/new-edit.mp4 to adopt a replacement.
SHORT_VIDEO=${SHORT_VIDEO:-media/demo-x.mp4}
[[ -f "$SHORT_VIDEO" ]] || { echo 'Provide SHORT_VIDEO pointing to the approved edit.'; exit 1; }
if ! [[ "$SHORT_VIDEO" -ef media/demo-x.mp4 ]]; then
  cp "$SHORT_VIDEO" media/demo-x.mp4
fi
"$FFMPEG" -v warning -y -ss 0.5 -i media/demo-portrait.mp4 -frames:v 1 -update 1 media/screenshot.png
"$FFMPEG" -v warning -y -i media/demo-x.mp4 -frames:v 1 -update 1 media/poster.png
"$FFMPEG" -v warning -y -i media/demo-x.mp4 \
  -filter_complex 'fps=15,scale=320:-1:flags=lanczos,split[a][b];[a]palettegen=stats_mode=diff[p];[b][p]paletteuse=dither=bayer:bayer_scale=3' -loop 0 media/preview.gif

#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
FFMPEG=${FFMPEG:-ffmpeg}
FFPROBE=${FFPROBE:-ffprobe}
command -v "$FFMPEG" >/dev/null || { echo 'Install ffmpeg, or set FFMPEG to its executable path.'; exit 1; }
command -v "$FFPROBE" >/dev/null || { echo 'Install ffprobe, or set FFPROBE to its executable path.'; exit 1; }
mkdir -p build media
swift scripts/render-card.swift
duration=$("$FFPROBE" -v error -show_entries format=duration -of default=nw=1:nk=1 media/raw/simulator.mov)
duration=$(awk -v duration="$duration" 'BEGIN { if (duration < 2) exit 1; printf "%.3f", duration - 0.6 }')
# Keep the capture at its real speed. Convert the simulator's variable timestamps
# to 60 fps, and trim the final test-runner teardown margin.
"$FFMPEG" -v warning -y -i media/raw/simulator.mov -vf 'fps=60,scale=886:1926:flags=lanczos' \
  -t "$duration" -c:v libx264 -preset slow -crf 19 -pix_fmt yuv420p -movflags +faststart -an media/demo-portrait.mp4
"$FFMPEG" -v warning -y -loop 1 -i build/card.png -i media/demo-portrait.mp4 -loop 1 -i build/phone-mask.png \
  -filter_complex '[1:v]split=2[full][detail];[full]scale=474:1030:flags=lanczos,format=rgba[phone];[2:v]format=gray[mask];[phone][mask]alphamerge[rounded];[0:v][rounded]overlay=980:85:shortest=1[scene];[detail]crop=886:196:0:1670,scale=745:165:flags=lanczos[close];[scene][close]overlay=119:779:shortest=1,format=yuv420p[out]' \
  -map '[out]' -r 60 -c:v libx264 -preset slow -crf 19 -movflags +faststart -an -t "$duration" media/demo-x.mp4
"$FFMPEG" -v warning -y -ss 0.5 -i media/demo-x.mp4 -frames:v 1 -update 1 media/poster.png
"$FFMPEG" -v warning -y -ss 0.5 -i media/demo-portrait.mp4 -frames:v 1 -update 1 media/screenshot.png
"$FFMPEG" -v warning -y -i media/demo-x.mp4 \
  -filter_complex 'fps=15,scale=800:-1:flags=lanczos,split[a][b];[a]palettegen=stats_mode=diff[p];[b][p]paletteuse=dither=bayer:bayer_scale=3' -loop 0 media/preview.gif

#!/bin/bash
set -euo pipefail
name='MinimizingTabBar Demo'
udid=$(xcrun simctl list devices available | awk -F '[()]' -v name="$name" 'index($1, name) { print $2; exit }')
if [[ -z "$udid" ]]; then
  runtime=$(xcrun simctl list runtimes | awk '/^iOS 26/ && !/unavailable/ {print $NF}' | tail -1)
  [[ -n "$runtime" ]] || { echo 'Install an iOS 26 simulator runtime in Xcode.' >&2; exit 1; }
  udid=$(xcrun simctl create "$name" com.apple.CoreSimulator.SimDeviceType.iPhone-17-Pro "$runtime")
fi
if ! xcrun simctl list devices booted | grep -q "$udid"; then
  xcrun simctl boot "$udid" >&2
fi
xcrun simctl bootstatus "$udid" -b >&2
printf '%s\n' "$udid"

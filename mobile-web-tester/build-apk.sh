#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo
echo "=================================="
echo " Mobile Web Tester — build APK"
echo "=================================="
echo

# Android SDK location: ANDROID_SDK_ROOT (preferred) or ANDROID_HOME
SDK_DIR="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-}}"
if [ ! -f local.properties ]; then
    if [ -z "$SDK_DIR" ]; then
        echo "error: set ANDROID_SDK_ROOT (or ANDROID_HOME) to your Android SDK" >&2
        exit 1
    fi
    printf 'sdk.dir=%s\n' "$SDK_DIR" > local.properties
fi

./gradlew clean assembleDebug

APK="app/build/outputs/apk/debug/app-debug.apk"

echo
echo "APK: $SCRIPT_DIR/$APK"
echo

# Copy to net-disk so the tablet can download it the usual way
NET_DISK_DIR="${NET_DISK_DIR:-$HOME/net-disk}"
if [ -d "$NET_DISK_DIR" ]; then
    cp "$APK" "$NET_DISK_DIR/mobile-web-tester.apk"
    echo "Installed on the tablet via:"
    echo "  https://animastor.org/net-disk/mobile-web-tester.apk"
fi

echo
echo "Done."

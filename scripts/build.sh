#!/usr/bin/env bash
set -euo pipefail

#
# Downloads android sdk, flutter sdk, and builds apk
#

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly CMD_LINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip"
readonly SDK_MANAGER=sdk-tools-linux/cmdline-tools/latest/bin/sdkmanager
readonly FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.0.5-stable.tar.xz"
readonly REPO_ROOT=$SCRIPT_DIR/../

set -x

mkdir -p $SCRIPT_DIR/build
cd $SCRIPT_DIR/build

# android sdk
readonly ANDROID_ZIP=tools.zip
if [ ! -f "$ANDROID_ZIP" ]; then
    wget --quiet ${CMD_LINE_TOOLS_URL} -O $ANDROID_ZIP
    unzip -qq $ANDROID_ZIP -d sdk-tools-linux
    mkdir -p sdk-tools-linux/cmdline-tools/latest
    mv sdk-tools-linux/cmdline-tools/* sdk-tools-linux/cmdline-tools/latest/ &> /dev/null || true

    yes | ${SDK_MANAGER} --licenses > /dev/null || true
    ${SDK_MANAGER} --install ndk-bundle > /dev/null
    yes | ${SDK_MANAGER} --licenses  > /dev/null || true
fi

export ANDROID_HOME=$PWD/sdk-tools-linux
export PATH=$PATH:$PWD/sdk-tools-linux/platform-tools/

# flutter sdk
readonly FLUTTER_ZIP="flutter.tar.xz"
if [ ! -f "$FLUTTER_ZIP" ]; then
    wget --quiet ${FLUTTER_URL} -O $FLUTTER_ZIP
    tar xf flutter.tar.xz
fi

export PATH="$PATH:`pwd`/flutter/bin"

flutter doctor
flutter pub get
flutter build apk

# apk is located at $REPO_ROOT/build/app/outputs/flutter-apk/app-release.apk

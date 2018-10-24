#!/usr/bin/env bash
# Copyright 2018 Eevee <join.aero@gmail.com>. All Rights Reserved.
# License: Apache 2.0. See LICENSE file in root directory.

# _VERBOSE_=1
# _INIT_LINTER_=1
# _FORCE_INSRALL_=1
_INSTALL_OPTIONS_=$@

BASE_DIR=$(cd "$(dirname "$0")" && pwd)
ROOT_DIR=$(realpath "$BASE_DIR/..")

source "$BASE_DIR/init_tools.sh"

## deps

_echo_s "Init deps"
# glfw: https://github.com/glfw/glfw

if [ "$HOST_OS" = "Linux" ]; then
  _install_deps "$SUDO apt-get install" pkg-config libglew-dev
  # On Trusty, please install glfw3 from source
  #   E: Unable to locate package libglfw3-dev
  _install_deps "$SUDO apt-get install" libglfw3-dev
elif [ "$HOST_OS" = "Mac" ]; then
  _install_deps "brew install" glfw3 glew
elif [ "$HOST_OS" = "Win" ]; then
  if [ "$HOST_NAME" = "MINGW" ]; then
    if [ "$HOST_ARCH" = "x64" ]; then
      _install_deps "pacman -S" mingw-w64-x86_64-glfw
    elif [ "$HOST_ARCH" = "x86" ]; then
      _install_deps "pacman -S" mingw-w64-i686-glfw
    else
      _echo_e "Unknown host arch :("
      exit 1
    fi
  fi
else  # unexpected
  _echo_e "Unknown host os :("
  exit 1
fi

## cmake version

_echo_s "Expect cmake version >= 3.0"
cmake --version | head -1
if [ "$HOST_NAME" = "Ubuntu" ]; then
  # sudo apt remove cmake
  _echo "How to upgrade cmake in Ubuntu"
  _echo "  https://askubuntu.com/questions/829310/how-to-upgrade-cmake-in-ubuntu"
fi

exit 0

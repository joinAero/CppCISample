#!/usr/bin/env bash
# Copyright 2018 Eevee <join.aero@gmail.com>. All Rights Reserved.
# License: Apache 2.0. See LICENSE file in root directory.

_INIT_BUILD_=1
# _INIT_LINTER_=1
# _FORCE_INSRALL_=1
# _INSTALL_OPTIONS_=-y

BASE_DIR=$(cd "$(dirname "$0")" && pwd)

source "$BASE_DIR/common/echo.sh"
source "$BASE_DIR/common/detect.sh"
source "$BASE_DIR/common/host.sh"

## functions

if [ "$HOST_OS" = "Linux" ]; then
  _detect_install() {
    _detect_cmd "$1" || [ $(dpkg-query -W -f='${Status}' "$1" 2> /dev/null \
        | grep -c "ok installed") -gt 0 ]
  }
elif [ "$HOST_OS" = "Mac" ]; then
  _detect_install() {
    _detect_cmd "$1" || brew ls --versions "$1" > /dev/null
  }
else
  _detect_install() {
    _detect_cmd "$1"
  }
fi

_install_deps() {
  _cmd="$1"; shift; _deps_all=($@)
  if [ -n "${_INSTALL_OPTIONS_}" ]; then
    _cmd="$_cmd $_INSTALL_OPTIONS_"
  fi
  _echo "Install cmd: $_cmd"
  _echo "Install deps: ${_deps_all[*]}"
  if [ -n "${_FORCE_INSRALL_}" ]; then
    _echo_d "$_cmd ${_deps_all[*]}"
    $_cmd ${_deps_all[@]}
    return
  fi
  _deps=()
  for _dep in "${_deps_all[@]}"; do
    _detect_install $_dep || _deps+=($_dep)
  done
  if [ ${#_deps[@]} -eq 0 ]; then
    _echo_i "All deps already exist"
  else
    _echo_d "$_cmd ${_deps[*]} (not exists)"
    $_cmd ${_deps[@]}
  fi
}

## init tools

_echo_s "Init tools"

if [ "$HOST_OS" = "Linux" ]; then
  # sudo
  SUDO="sudo"
  _detect_cmd $SUDO || SUDO=
  # detect apt-get
  _detect apt-get
  # apt-get install
  if [ -n "${_INIT_BUILD_}" ]; then
    _install_deps "$SUDO apt-get install" build-essential curl cmake git make
  fi
  if [ -n "${_INIT_LINTER_}" ]; then
    _install_deps "$SUDO apt-get install" clang-format
    if ! _detect_cmd clang-format; then
      # on Ubuntu 14.04, apt-cache search clang-format
      _install_deps "$SUDO apt-get install" clang-format-3.9
      $SUDO ln -sf clang-format-3.9 /usr/bin/clang-format
      $SUDO ln -sf clang-format-diff-3.9 /usr/bin/clang-format-diff
    fi
  fi
elif [ "$HOST_OS" = "Mac" ]; then
  # detect brew
  if ! _detect_cmd brew; then
    _echo_sn "Install brew"
    _detect curl
    _detect ruby
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  # brew install
  if [ -n "${_INIT_BUILD_}" ]; then
    _install_deps "brew install" curl cmake git make
  fi
  if [ -n "${_INIT_LINTER_}" ]; then
    _install_deps "brew install" clang-format
    # link clang-format-diff (if not compatible with Python 3, fix it by yourself)
    [ -f "/usr/local/bin/clang-format-diff" ] || \
      ln -s /usr/local/share/clang/clang-format-diff.py /usr/local/bin/clang-format-diff
  fi
elif [ "$HOST_OS" = "Win" ]; then
  # detect pacman on MSYS
  _detect pacman
  # pacman install
  if [ -n "${_INIT_BUILD_}" ]; then
    _install_deps "pacman -S" curl git make
    if [ "$HOST_NAME" = "MINGW" ]; then
      # MINGW: cmake
      _deps=()
      if [ "$HOST_ARCH" = "x64" ]; then
        _deps+=(mingw-w64-x86_64-toolchain mingw-w64-x86_64-cmake)
      elif [ "$HOST_ARCH" = "x86" ]; then
        _deps+=(mingw-w64-i686-toolchain mingw-w64-i686-cmake)
      else
        _echo_e "Unknown host arch :("
        exit 1
      fi
      if ! [ ${#_deps[@]} -eq 0 ]; then
        _install_deps "pacman -S" ${_deps[@]}
      fi
    else
      # Install CMake for Windows
      #   https://cmake.org/
      _detect cmake
    fi
  fi
  if [ -n "${_INIT_LINTER_}" ]; then
    _install_deps "pacman -S" clang-format
  fi
  # update: pacman -Syu
  # search: pacman -Ss make
  # remove unused: pacman -Rns $(pacman -Qtdq)
  # remove cache: pacman -Sc
  # https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks
else  # unexpected
  _echo_e "Unknown host os :("
  exit 1
fi

## init linter - optional

if [ -n "${_INIT_LINTER_}" ]; then

# python

PYTHON="python"
if [ "$HOST_OS" = "Win" ]; then
  if ! _detect_cmd $PYTHON; then
    PYTHON="python2"  # try python2 on MSYS
  fi
fi

_detect $PYTHON 1

PYTHON_FOUND="${PYTHON}_FOUND"
if [ -z "${!PYTHON_FOUND}" ]; then
  _echo_en "$PYTHON not found"
fi

# pip

# detect pip
if ! _detect_cmd pip; then
  if [ -n "${!PYTHON_FOUND}" ]; then
    _echo_sn "Install pip"
    [ -f "get-pip.py" ] || curl -O https://bootstrap.pypa.io/get-pip.py
    $SUDO $PYTHON get-pip.py
  else
    _echo_en "Skipped install pip, as $PYTHON not found"
  fi
fi
# pip install
if _detect_cmd pip; then
  _echo_d "pip install --upgrade autopep8 cpplint pylint requests"
  $SUDO pip install --upgrade autopep8 cpplint pylint requests
else
  _echo_en "Skipped pip install packages, as pip not found"
fi

fi  # _INIT_LINTER_

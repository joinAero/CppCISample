#!/usr/bin/env bash
# Copyright 2018 Eevee <join.aero@gmail.com>. All Rights Reserved.
# License: Apache 2.0. See LICENSE file in root directory.

[ -n "${_HOST_SH_}" ] && return || readonly _HOST_SH_=1
[ -n "${_VERBOSE_}" ] && echo "-- INCLUDE: host.sh"

_host_contains_() {
  [ `echo $1 | grep -c "$2"` -gt 0 ]
}

if _host_contains_ "$OS" "Windows_NT"; then

HOST_OS="Win"

if _host_contains_ "$PROCESSOR_ARCHITEW6432" "AMD64"; then
  HOST_ARCH="x64"
else
  if _host_contains_ "$PROCESSOR_ARCHITECTURE" "AMD64"; then
    HOST_ARCH="x64"
  elif _host_contains_ "$PROCESSOR_ARCHITECTURE" "x86"; then
    HOST_ARCH="x86"
  else
    echo >&2 "-- HOST: unknown arch :("
    exit 1
  fi
fi

else

_UNAME_S=$(uname -s)

if _host_contains_ "$_UNAME_S" "Linux"; then
  HOST_OS="Linux"
elif _host_contains_ "$_UNAME_S" "Darwin"; then
  HOST_OS="Mac"
elif _host_contains_ "$_UNAME_S" "MSYS\|MINGW"; then
  HOST_OS="Win"
else
  echo >&2 "-- HOST: unknown os :("
  exit 1
fi

_UNAME_M=$(uname -m)

if _host_contains_ "$_UNAME_M" "x86_64"; then
  HOST_ARCH="x64"
elif _host_contains_ "$_UNAME_M" "x86\|i686\|i386"; then
  HOST_ARCH="x86"
elif _host_contains_ "$_UNAME_M" "arm"; then
  HOST_ARCH="Arm"
elif _host_contains_ "$_UNAME_M" "aarch64"; then
  HOST_ARCH="AArch64"
else
  echo >&2 "-- HOST: unknown arch :("
  exit 1
fi

fi

HOST_NAME="$HOST_OS"

if [ "$HOST_OS" = "Win" ]; then
  _UNAME_S=$(uname -s)
  if [ -n "$_UNAME_S" ]; then
    if _host_contains_ "$_UNAME_S" "MINGW"; then
      HOST_NAME="MINGW"
    elif _host_contains_ "$_UNAME_S" "MSYS"; then
      HOST_NAME="MSYS"
    fi
  fi
elif [ "$HOST_OS" = "Linux" ]; then
  _UNAME_A=$(uname -a)
  if _host_contains_ "$_UNAME_A" "tegra\|jetsonbot"; then
    HOST_NAME="Tegra"
  elif _host_contains_ "$_UNAME_A" "firefly"; then
    HOST_NAME="Firefly"
  elif _host_contains_ "$_UNAME_A" "ubuntu"; then
    HOST_NAME="Ubuntu"
  fi
fi

if [ -n "${_VERBOSE_}" ]; then
  echo "-- HOST_OS: $HOST_OS"
  echo "-- HOST_ARCH: $HOST_ARCH"
  echo "-- HOST_NAME: $HOST_NAME"
fi

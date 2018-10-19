#!/usr/bin/env bash
# Copyright 2018 Eevee <join.aero@gmail.com>. All Rights Reserved.
# License: Apache 2.0. See LICENSE file in root directory.

[ -n "${_STRING_SH_}" ] && return || readonly _STRING_SH_=1
[ -n "${_VERBOSE_}" ] && echo "-- INCLUDE: string.sh"

_startswith() { [ "$1" != "${1#$2}" ]; }
_endswith() { [ "$1" != "${1%$2}" ]; }

#!/usr/bin/env bash
# Copyright 2018 Eevee <join.aero@gmail.com>. All Rights Reserved.
# License: Apache 2.0. See LICENSE file in root directory.

FIND="find"

if type where &> /dev/null; then
  for i in `where find`; do
    # find on MSYS instead of Windows
    if [ `echo $i | grep -c "msys"` -gt 0 ]; then
      FIND=`echo "${i%.exe}" | tr -d "[:space:]" | sed 's:\\\:/:g'`
    fi
  done
fi

echo "$FIND"

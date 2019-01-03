#!/usr/bin/env bash

# -------------------------------------------------------------------------------------------------------------------- #
# Backup files.
# -------------------------------------------------------------------------------------------------------------------- #
# @author Kitsune Solar <kitsune.solar@gmail.com>
# @version 1.0.0
# -------------------------------------------------------------------------------------------------------------------- #

# -------------------------------------------------------------------------------------------------------------------- #
# Timestamp generator.
# -------------------------------------------------------------------------------------------------------------------- #

function ext.timestamp() {
    timestamp="$( date -u '+%Y-%m-%d.%T' )"

    echo ${timestamp}
}
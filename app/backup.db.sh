#!/usr/bin/env bash

# -------------------------------------------------------------------------------------------------------------------- #
# Backup databases.
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

# -------------------------------------------------------------------------------------------------------------------- #
# Backup databases.
# -------------------------------------------------------------------------------------------------------------------- #

function ext.backup.db() {
    # DB user.
    db_user=""

    # DB password.
    db_password=""

    # DB host.
    db_host="127.0.0.1"

    # Timestamp.
    timestamp="$( ext.timestamp )"

    # Path.
    path="/storage/databases/.backup/${timestamp}"

    # Mail.
    mail_to=""

    # Get mysql.
    mysql="$( which mysql )"

    # Get mysqldump.
    mysql_dump="$( which mysqldump )"

    # Get databases.
    databases=`${mysql} -u "${db_user}" -p"${db_password}" -h"${db_host}" -e "show databases;" | egrep -v "^(mysql|information_schema|performance_schema)$"`

    # Create backup directories.
    mkdir -p "${path}" && cd "${path}"

    # Backup databases.
    for database in ${databases}; do
        echo ""
        echo "--- Backup database: ${database} - ["

        ${mysql_dump}       \
        -u "${db_user}"     \
        -p"${db_password}"  \
        -h"${db_host}"      \
        --opt ${database} > "${database}.${timestamp}.sql" | gzip > "${database}.${timestamp}.sql.gz"

        echo "--- Backup database: ${database} - ]"
        echo ""
    done

    # Mail report.
    echo "$( ls -1hs )" | mailx -s "SRV.01: Backup Database" "${mail_to}"
}

#!/usr/bin/env bash

# -------------------------------------------------------------------------------------------------------------------- #
# Backup databases.
# -------------------------------------------------------------------------------------------------------------------- #
# @author Kitsune Solar <kitsune.solar@gmail.com>
# @version 1.0.0
# -------------------------------------------------------------------------------------------------------------------- #

ext.backup.get.timestamp() {
    timestamp="$( date -u '+%Y-%m-%d.%T' )"

    echo "${timestamp}"
}

ext.backup.get.mysql() {
    mysql="$( which mysql )"

    echo "${mysql}"
}

ext.backup.get.mysql.dump() {
    mysql_dump="$( which mysqldump )"

    echo "${mysql_dump}"
}

# -------------------------------------------------------------------------------------------------------------------- #
# Backup databases.
# -------------------------------------------------------------------------------------------------------------------- #

run.backup.db() {
    # DB user.
    db_user=""

    # DB password.
    db_password=""

    # DB host.
    db_host="127.0.0.1"

    # Timestamp.
    timestamp="$( ext.backup.get.timestamp )"

    # Path.
    path="/home/storage/databases/.backup/${timestamp}"

    # Mail.
    mail_to="kitsune.solar@gmail.com"

    # Get mysql.
    mysql="$( ext.backup.get.mysql )"

    # Get mysqldump.
    mysql_dump="$( ext.backup.get.mysql.dump )"

    # Get databases.
    databases=`${mysql} -u "${db_user}" -p"${db_password}" -h"${db_host}" -e "show databases;" | egrep -v "^(mysql|information_schema|performance_schema)$"`

    # Create backup directories.
    mkdir -p "${path}" && cd "${path}"

    # Backup databases.
    for database in ${databases}; do
        echo ""
        echo "--- Backup database: ${database} - ["

        ${mysql_dump}                                       \
        -u "${db_user}"                                     \
        -p"${db_password}"                                  \
        -h"${db_host}"                                      \
        --opt ${database} > "${database}.${timestamp}.sql"  \
        | gzip > "${database}.${timestamp}.sql.gz"

        echo "--- Backup database: ${database} - ]"
        echo ""
    done

    # Mail report.
    echo "$( ls -1hs )" | mailx -s "SRV.01: Backup Database" "${mail_to}"
}

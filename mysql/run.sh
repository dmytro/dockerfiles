#!/bin/bash

VOLUME_HOME="/var/lib/mysql"
CONF_FILE="/etc/my.cnf"
LOG="/var/log/mysql/error.log"

mysql_root () {
    if [ -d /root_pasword_created ];then
        echo "mysql -uroot --password=${MYSQL_ROOT_PASS}"
    else
        echo "mysql -uroot"
    fi
}

mysql_shutdown () {
    if [ -d /root_pasword_created ];then
        echo "mysqladmin -uroot --password=${MYSQL_ROOT_PASS} shutdown"
    else
        echo "mysqladmin -uroot shutdown"
    fi
}
start_mysql () {
    /usr/bin/mysqld_safe > /dev/null 2>&1 &

    # Time out in 1 minute
    LOOP_LIMIT=13
    for (( i=0 ; ; i++ )); do
        if [ ${i} -eq ${LOOP_LIMIT} ]; then
            echo "Time out. Error log is shown as below:"
            tail -n 100 ${LOG}
            exit 1
        fi
        echo "=> Waiting for confirmation of MySQL service startup, trying ${i}/${LOOP_LIMIT} ..."
        sleep 5
        $(mysql_root) -e "status" > /dev/null 2>&1 && break
    done
}

create_mysql_user() {

    if [ -z "${MYSQL_ROOT_PASS}" -o -z "${MYSQL_USER}" -o -z "${MYSQL_USER_PASS}" ]; then
        echo >&2 "User name or user password is not set."
        exit 1
    fi
	start_mysql

	echo "=> Setting root password and creating MySQL user ${MYSQL_USER} "

	cat > "$tempSqlFile" <<-EOSQL
			DELETE FROM mysql.user ;

			CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
			GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;

            CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '$MYSQL_PASS';
			GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION;

			DROP DATABASE IF EXISTS test ;

            FLUSH PRIVILEGES;
	EOSQL

	mysqladmin_shutdown
}

import_sql()
{
	start_mysql

	for FILE in ${STARTUP_SQL}; do
	   echo "=> Importing SQL file ${FILE}"
	   mysql -uroot < "${FILE}"
	done

	mysqladmin_shutdown
}

# Main
if [ ${REPLICATION_MASTER} == "**False**" ]; then
    unset REPLICATION_MASTER
fi

if [ ${REPLICATION_SLAVE} == "**False**" ]; then
    unset REPLICATION_SLAVE
fi

# Initialize empty data volume and create MySQL user
if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    if [ ! -f /usr/share/mysql/my-default.cnf ] ; then
        cp /etc/mysql/my.cnf /usr/share/mysql/my-default.cnf
    fi
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"
    echo "=> Creating admin user ..."
    create_mysql_user
else
    echo "=> Using an existing volume of MySQL"
fi

# Import Startup SQL
if [ -n "${STARTUP_SQL}" ]; then
    if [ ! -f /sql_imported ]; then
        echo "=> Initializing DB with ${STARTUP_SQL}"
        import_sql
        touch /sql_imported
    fi
fi


# Set MySQL REPLICATION - MASTER
if [ -n "${REPLICATION_MASTER}" ]; then
    echo "=> Configuring MySQL replication as master ..."
    if [ ! -f /replication_configured ]; then
        RAND="$(date +%s | rev | cut -c 1-2)$(echo ${RANDOM})"
        echo "=> Writting configuration file '${CONF_FILE}' with server-id=${RAND}"
        sed -i "s/^#server-id.*/server-id = ${RAND}/" ${CONF_FILE}
        sed -i "s/^#log-bin.*/log-bin = mysql-bin/" ${CONF_FILE}
        echo "=> Starting MySQL ..."
        start_mysql
        echo "=> Creating a log user ${REPLICATION_USER}:${REPLICATION_PASS}"
        mysql -uroot -e "CREATE USER '${REPLICATION_USER}'@'%' IDENTIFIED BY '${REPLICATION_PASS}'"
        mysql -uroot -e "GRANT REPLICATION SLAVE ON *.* TO '${REPLICATION_USER}'@'%'"
        echo "=> Done!"
        mysqladmin_shutdown
        touch /replication_configured
    else
        echo "=> MySQL replication master already configured, skip"
    fi
fi

# Set MySQL REPLICATION - SLAVE
if [ -n "${REPLICATION_SLAVE}" ]; then
    echo "=> Configuring MySQL replication as slave ..."
    if [ -n "${MYSQL_PORT_3306_TCP_ADDR}" ] && [ -n "${MYSQL_PORT_3306_TCP_PORT}" ]; then
        if [ ! -f /replication_configured ]; then
            RAND="$(date +%s | rev | cut -c 1-2)$(echo ${RANDOM})"
            echo "=> Writting configuration file '${CONF_FILE}' with server-id=${RAND}"
            sed -i "s/^#server-id.*/server-id = ${RAND}/" ${CONF_FILE}
            sed -i "s/^#log-bin.*/log-bin = mysql-bin/" ${CONF_FILE}
            echo "=> Starting MySQL ..."
            start_mysql
            echo "=> Setting master connection info on slave"
            mysql -uroot -e "CHANGE MASTER TO MASTER_HOST='${MYSQL_PORT_3306_TCP_ADDR}',MASTER_USER='${MYSQL_ENV_REPLICATION_USER}',MASTER_PASSWORD='${MYSQL_ENV_REPLICATION_PASS}',MASTER_PORT=${MYSQL_PORT_3306_TCP_PORT}, MASTER_CONNECT_RETRY=30"
            echo "=> Done!"
            mysqladmin_shutdown
            touch /replication_configured
        else
            echo "=> MySQL replicaiton slave already configured, skip"
        fi
    else
        echo "=> Cannot configure slave, please link it to another MySQL container with alias as 'mysql'"
        exit 1
    fi
fi

tail -F $LOG &
exec mysqld_safe

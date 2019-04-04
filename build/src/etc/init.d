#! /bin/sh
### BEGIN INIT INFO
# Provides:          wekan-oft-0
# Required-Start:    $remote_fs $syslog mongod
# Required-Stop:     $remote_fs $syslog mongod
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Wekan Only For Testing
# Description:       This file should be used to construct scripts to be
#                    placed in /etc/init.d.
### END INIT INFO

# Author: Foo Bar <foobar@baz.org>
#
# Please remove the "Author" lines above and replace them
# with your own name if you copy and modify this script.

# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="Wekan OFT"
NAME=wekan-oft-0
DAEMON=/opt/bin/wekan/WekanServer-x86_64.AppImage
DAEMON_ARGS=""
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
USER=wekan
GROUP=wekan
WORKING_DIR=/opt/bin/wekan
LOG_DIR=/var/log/wekan
LOG_FILE=/var/log/wekan/$NAME.log

# Exit if the package is not installed
[ -x "$DAEMON" ] || exit 0

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Read user defined configuration variable file if it is present
[ -r /etc/$NAME ] && . /etc/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
# and status_of_proc is working.
. /lib/lsb/init-functions

check_log()
{
    if [ ! -d "$LOG_DIR" ] ; then
        mkdir -p "$LOG_DIR" 2>/dev/null
    fi
}

#
# Function that starts the daemon/service
#
do_start()
{
    check_log

    # Return
    #   0 if daemon has been started
    #   1 if daemon was already running
    #   2 if daemon could not be started
    start-stop-daemon --start --quiet --chuid $USER:$GROUP --pidfile $PIDFILE --make-pidfile --background --chdir /opt/bin/wekan --exec $DAEMON --test > /dev/null \
        || return 1
    start-stop-daemon --start --quiet --chuid $USER:$GROUP --pidfile $PIDFILE --make-pidfile --background --chdir /opt/bin/wekan --exec $DAEMON --no-close -- \
        $DAEMON_ARGS 1>$LOG_FILE 2>&1 \
        || return 2
    # Add code here, if necessary, that waits for the process to be ready
    # to handle requests from services started subsequently which depend
    # on this one.  As a last resort, sleep for some time.
}

#
# Function that stops the daemon/service
#
do_stop()
{
    # Return
    #   0 if daemon has been stopped
    #   1 if daemon was already stopped
    #   2 if daemon could not be stopped
    #   other if a failure occurred
    start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --pidfile $PIDFILE --remove-pidfile
    return $?
}

do_backup_data() {
    if [ "$BACKUP_DIR" != "" ] ; then
        mkdir -p "$BACKUP_DIR" 2>/dev/null
        mongodump --db wekan --out "$BACKUP_DIR"
        RETVAL="$?"
        [ "$RETVAL" = 2 ] && return 2
    else
        echo "Error : no BACKUP_DIR variable defined. Please check /etc/$NAME" >&2
        return 2
    fi
    return 1
}

do_restore_data() {
    if [ "$BACKUP_DIR" != "" ] ; then
        mongo wekan --eval "db.dropDatabase()"
        mongorestore --drop --db wekan "$BACKUP_DIR/wekan"
    else
        echo "Error : no BACKUP_DIR variable defined. Please check /etc/$NAME" >&2
        return 2
    fi
    return 1
}

do_purge_all_data() {
    mongo wekan --eval "db.dropDatabase()"
    RETVAL="$?"
    [ "$RETVAL" = 2 ] && return 2
    return 1
}

case "$1" in
start)
    [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
    do_start
    case "$?" in
        0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
        2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
    esac
    ;;
stop)
    [ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
    do_stop
    case "$?" in
        0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
        2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
    esac
    ;;
status)
    status_of_proc "$DAEMON" "$NAME" && exit 0 || exit $?
    ;;
restart|force-reload)
    #
    # If the "reload" option is implemented then remove the
    # 'force-reload' alias
    #
    log_daemon_msg "Restarting $DESC" "$NAME"
    do_stop
    case "$?" in
    0|1)
        do_start
        case "$?" in
            0) log_end_msg 0 ;;
            1) log_end_msg 1 ;; # Old process is still running
            *) log_end_msg 1 ;; # Failed to start
        esac
        ;;
    *)
        # Failed to stop
        log_end_msg 1
        ;;
    esac
    ;;
log)
    case "$2" in
    show)
        cat $LOG_FILE
        ;;
    purge)
        :> $LOG_FILE
        ;;
    rotate)
        logrotate -f /etc/logrotate.d/$NAME
        ;;
    *)
        tail -f $LOG_FILE
        ;;
    esac
    ;;
data)
    case "$2" in
    backup)
        [ "$VERBOSE" != no ] && log_daemon_msg "Backupping data $DESC" "$NAME"
        do_backup_data
        case "$?" in
            0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
            2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
        esac
        ;;
    restore)
        [ "$VERBOSE" != no ] && log_daemon_msg "Restoring data $DESC" "$NAME"
        do_stop
        do_restore_data
        case "$?" in
            0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
            2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
        esac
        do_start
        ;;
    purge-all)
        [ "$VERBOSE" != no ] && log_daemon_msg "Purge all data $DESC" "$NAME"
        do_purge_all_data
        case "$?" in
            0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
            2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
        esac
        ;;
    *)
        mongo wekan --eval "db.stats()"
        ;;
    esac
    ;;
*)
    echo "Usage: $SCRIPTNAME {start|stop|status|restart|force-reload}" >&2
    exit 3
    ;;
esac

:

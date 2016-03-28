#! /bin/bash
#
# Start the motion detection .
#


NAME=motion
PATH=/bin:/usr/bin:/sbin:/usr/sbin
DAEMON=/usr/local/bin/motion
PIDFILE=/var/run/motion/$NAME.pid

trap "" 1
export LANG=C
export PATH

test -f $DAEMON || exit 0


case "$1" in
  start)
    echo "Starting @PACKAGE_NAME@ detection : $NAME"
    sudo start-stop-daemon --start --pidfile $PIDFILE --exec $DAEMON --chuid root
    ;;

  stop)
    echo "Stopping @PACKAGE_NAME@ detection : $NAME"
    sudo start-stop-daemon --stop --pidfile $PIDFILE --oknodo --exec $DAEMON --retry$
    ;;

  status)
    echo "Status @PACKAGE_NAME@ detection : $NAME"
    if (test -f $PIDFILE); then
        echo -n "Running process for $NAME : "
        pidof $NAME
    else
        echo "Stopped"
    fi
    ;;

  reload-config)
    echo "Reloading $NAME configuration"
    start-stop-daemon --stop --pidfile $PIDFILE --signal HUP --exec $DAEMON
    ;;

  restart-motion)
    echo "Restarting $NAME"
    start-stop-daemon --stop --pidfile $PIDFILE --oknodo --exec $DAEMON  --retry 30
    start-stop-daemon --start --pidfile $PIDFILE --exec $DAEMON --chuid root
    ;;

  restart)
    $0 restart-motion
    exit $?
    ;;

  *)
    echo "Usage: /etc/init.d/$NAME {start|stop|status|reload-config|restart}"
    exit 1
    ;;
esac

if [ $? == 0 ]; then
        echo .
        exit 0
else
        echo failed
        exit 1
fi


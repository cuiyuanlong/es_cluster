#!/bin/bash
#
# Metricbeat服务管理工具

PROGNAME=$(basename "$0")

warn() {
    echo "${PROGNAME}: $*"
}

die() {
    warn "$*"
    exit 1
}

detectOS() {
    # OS specific support (must be 'true' or 'false').
    cygwin=false;
    aix=false;
    os400=false;
    darwin=false;
    case "$(uname)" in
        CYGWIN*)
            cygwin=true
            ;;
        AIX*)
            aix=true
            ;;
        OS400*)
            os400=true
            ;;
        Darwin)
            darwin=true
            ;;
    esac
    # For AIX, set an environment variable
    if ${aix}; then
         export LDR_CNTRL=MAXDATA=0xB0000000@DSA
         echo ${LDR_CNTRL}
    fi
    # In addition to those, go around the linux space and query the widely
    # adopted /etc/os-release to detect linux variants
    if [ -f /etc/os-release ]; then
        . /etc/os-release
    fi
}

init() {
    # Determine if there is special OS handling we must perform
    detectOS

    export METRICBEAT_HOME=${HOME}/software/metricbeat
    export METRICBEAT_PATH_CONF=${HOME}/conf/metricbeat
    export METRICBEAT_PATH_DATA=${HOME}/data/metricbeat
    export METRICBEAT_PATH_LOG=${HOME}/log/metricbeat
    export LOCAL_IP=$(awk -v hostname=${HOSTNAME} '{for (i=2; i<=NF; i++) if ($i == hostname) {print $1}}' /etc/hosts)
}

check_server() {
    return $(awk -v hostname=${HOSTNAME} 'BEGIN {ret=1;}
    { 
        if ( $1 == hostname ) {
            ret=0; exit; 
        }
    }
    END {
        print ret;
    }' ${HOME}/conf/metricbeat.list)
}

run() {
    if [ "$1" = "start" ]; then
        if check_server ; then
            mkdir -p ${METRICBEAT_PATH_CONF}
            mkdir -p ${METRICBEAT_PATH_DATA}
            mkdir -p ${METRICBEAT_PATH_LOG}
            exec ${METRICBEAT_HOME}/metricbeat -E LOCAL_IP=${LOCAL_IP} --path.config ${METRICBEAT_PATH_CONF} --path.data ${METRICBEAT_PATH_DATA} --path.home ${METRICBEAT_HOME} --path.logs ${METRICBEAT_PATH_LOG}
        else
            exec cat
        fi
    elif [ "$1" = "stop" ]; then
        ps -ef | awk '$8 ~ /metricbeat$/ {print $2}' | awk '{printf "kill -15 %d", $1}' | sh
    elif [ "$1" = "status" ]; then
        ps p $(ps -ef | awk '$8 ~ /metricbeat$/ {print $2}') | awk '$0 !~ /awk/ {gsub(/ -/, "\n\t-");print}'
    fi
}

main() {
    init
    run "$@"
}


case "$1" in
    start|stop|status)
        main "$@"
        ;;
    restart)
        main "stop"
        main "start"
        ;;
    *)
        die "Usage $(basename "$0") {start|stop|restart|status}"
        ;;
esac

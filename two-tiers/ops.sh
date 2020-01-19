#!/bin/bash

APP_NAME=$0
COMMAND=$1
SUBCOMMAND=$2

export CLI_IMAGE="fabric-devkit/ca-client-cli"
export CLI_NAME_VERSION=latest
export FABRIC_CA_VERSION=1.4.4

function start() {
    local CMD=$1
    echo $CMD
    case "$CMD" in
        root)
            docker-compose -f ./docker-compose.yaml up -d ca.root
            ;;
        ica)
            docker-compose -f ./docker-compose.yaml up -d ca.intermediate
            ;;
        *)
            echo "$APP_NAME start [root | ica]"
            ;;
    esac
}

function stop() {
    docker-compose -f ./docker-compose.yaml down
}

function cli() {

    if [[ "$(docker images -q ${CLI_IMAGE}:${CLI_NAME_VERSION} 2> /dev/null)" == "" ]]; then
        docker-compose -f ./docker-compose.yaml build cli
    fi
    docker-compose -f ./docker-compose.yaml run --rm cli /bin/bash
}

function clean() {
    rm -rf ./generated
    docker rmi -f ${CLI_IMAGE}:${CLI_NAME_VERSION}
    docker rm -f $(docker ps -aq)
}

case "$COMMAND" in
    start)
        start $SUBCOMMAND
        ;;
    cli)
        cli $SUBCOMMAND
        ;;
    stop)
        stop
        ;;
    clean)
        clean
        ;;
    *)
        echo "$APP_NAME [ start | stop | cli | clean]"
        ;;
esac


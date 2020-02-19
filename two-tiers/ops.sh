#!/bin/bash

APP_NAME=$0
COMMAND=$1
SUBCOMMAND=$2

export CLI_IMAGE="fabric-devkit/ca-client-cli"
export CLI_NAME_VERSION=latest
export FABRIC_CA_VERSION=1.4.4

function ca() {
    local CMD=$1
    case "$CMD" in
        start)
            docker-compose -f ./docker-compose.yaml up -d ca.root
            docker-compose -f ./docker-compose.yaml up -d ca.intermediate
            ;;
        stop)
            docker-compose -f ./docker-compose.yaml down
            ;;
        *)
            echo "$APP_NAME ca [start | stop]"
            ;;
    esac
}


function cli() {
    local CMD=$1

    case "$CMD" in
        build)
            if [[ "$(docker images -q ${CLI_IMAGE}:${CLI_NAME_VERSION} 2> /dev/null)" == "" ]]; then
                docker-compose -f ./docker-compose.yaml build cli
            fi
            ;;
        start)
            docker-compose -f ./docker-compose.yaml run --rm cli /bin/bash
            ;;
        *)
            echo "$APP_NAME cli [build | start]"
            ;;
    esac
}

function clean() {
    rm -rf ./generated
    docker rmi -f ${CLI_IMAGE}:${CLI_NAME_VERSION}
    docker rm -f $(docker ps -aq)
}

case "$COMMAND" in
    ca)
        ca $SUBCOMMAND
        ;;
    cli)
        cli $SUBCOMMAND
        ;;
    clean)
        clean
        ;;
    *)
        echo "$APP_NAME [ ca [start | stop] | cli [build | start] | clean]"
        ;;
esac


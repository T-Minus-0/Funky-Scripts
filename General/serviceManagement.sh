#!/bin/bash
finishedServices=false

while [ "$finishedServices" == false ]; do
    reset
    echo " ___ "
    echo "|   |       __    __      __    __        __   ___    ___"
    echo "|   |      |__|  |   \   |  |  |  |      |  |  \  \  /  /"
    echo "|   |       __   |    \  |  |  |  |      |  |   \  \/  /"
    echo "|   |      |  |  |  |\ \ |  |  |  |      |  |    \    /"
    echo "|   |____  |  |  |  | \ \|  |  \   \    /   |    /    \ "
    echo "|        | |  |  |  |  \    |   \   \__/    |   /  /\  \ "
    echo "|________| |__|  |__|   \___|    \______/|__|  /__/  \__\ " 
    echo Choose which Action to Run
    echo [4] Return to main
    read servicesUserChoice

    if [[ "$servicesUserChoice" == "4" ]]; then
        finishedServices=true
    fi
done
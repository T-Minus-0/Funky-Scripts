# !/bin/bash

# if [ "$EUID" -ne 0 ]
# then 
#   echo "Run as root!"
#   exit
# fi

echo Starting Script
# echo -n "Loading Modules."
# sleep 0.25
# echo -n "."
# sleep 0.25
# echo -n "."
# sleep 0.25
# echo -n "."
# sleep 0.25
# echo -n "."
# sleep 0.25
# echo -n "."
# sleep 0.25
# echo ""
# sleep 0.25
# echo Modules Loaded.
# sleep 0.25
# echo -n Starting Modules.
# sleep 0.25
# echo -n "."
# sleep 0.25
# echo -n "."
# sleep 0.25
# echo -n "."
hasFinished=false

reset

while [ "$hasFinished" = false ] ; do
    echo " ___ "
    echo "|   |       __    __      __    __        __   ___    ___"
    echo "|   |      |__|  |   \   |  |  |  |      |  |  \  \  /  /"
    echo "|   |       __   |    \  |  |  |  |      |  |   \  \/  /"
    echo "|   |      |  |  |  |\ \ |  |  |  |      |  |    \    /"
    echo "|   |____  |  |  |  | \ \|  |  \   \    /   |    /    \ "
    echo "|        | |  |  |  |  \    |   \   \__/    |   /  /\  \ "
    echo "|________| |__|  |__|   \___|    \______/|__|  /__/  \__\ " 
    echo Choose which Module to Run
    echo [0] System Updates
    echo [1] Update Management
    echo [2] User Management
    echo [3] Password Policies
    echo [4] Service Management
    echo [5] System Harden
    echo [6] Harden SSH
    echo [7] Network Harden
    echo [8] Unauthorized File Scanner
    echo [9] Run All Sequentially
    echo [10] Clean Up
    read userChoice
    if [[ "$userChoice" == 0 ]]; then
        echo Running System Updates
        sudo apt-get update -y >> "./logs/latest.log"
        sudo apt-get upgrade -y >> "./logs/latest.log"
        sudo apt-get dist-upgrade -y >> "./logs/latest.log"
        sudo apt-get install --only-upgrade ca-certificates -y
    fi

    if [[ "$userChoice" == 1 ]]; then
        # sudo nano "/etc/apt/apt.conf.d/50unattended-upgrades"
        # /etc/apt/apt.conf.d/50unattended-upgrades
        # /etc/apt/apt.conf.d/10periodic
    fi

    if [[ "$userChoice" == 2 ]]; then
        echo Running User Management >> "./logs/latest.log"
        bash ./scripts/modules/userManagement.sh
    fi

    if [[ "$userChoice" == 3 ]]; then
        echo Changing Password Policies >> "./logs/latest.log"
        sudo sed -i '/^PASS_MAX_DAYS/ c\PASS_MAX_DAYS   30' /etc/login.defs
        sudo sed -i '/^PASS_MIN_DAYS/ c\PASS_MIN_DAYS   7'  /etc/login.defs
        sudo sed -i '/^PASS_WARN_AGE/ c\PASS_WARN_AGE   7' /etc/login.defs
        sudo sed -i '/^LOGIN_RETRIES/ c\LOGIN_RETRIES   3' /etc/login.defs
        sudo sed -i '/^LOGIN_TIMEOUT/ c\LOGIN_TIMEOUT   30' /etc/login.defs
        sudo sed -i '/^ENCRYPT_METHOD/ c\ENCRYPT_METHOD   SHA512`' /etc/login.defs

        #/etc/pam.d/common-auth -- Account Management
        #/etc/audit/auditd.conf -- Audits
        #/etc/pam.d/common-password -- Password Requirements
    fi

    if [[ "$userChoice" == 4 ]]; then
        echo Running Service Manager >> "./logs/latest.log"
        bash ./scripts/modules/serviceManagement.sh
    fi
    
    if [[ "$userChoice" == 5 ]]; then
        echo Hardening Important System Files >> "./logs/latest.log"
        sudo chmod 644 /etc/passwd >> "./logs/latest.log"
        sudo chmod 640 /etc/shadow >> "./logs/latest.log"
        sudo chmod 644 /etc/group >> "./logs/latest.log"
        sudo chmod 640 /etc/gshadow >> "./logs/latest.log"

        #/etc/lightdm/lightdm.conf
        mkdir -p /etc/lightdm/lightdm.conf.d/ && echo -e "[Seat:*]\nallow-guest=false" > /etc/lightdm/lightdm.conf.d/50-no-guest.conf
    fi

    if [[ "$userChoice" == 6 ]]; then
        sshd_config="/etc/ssh/sshd_config"
        sed -i -E 's/^#?PermitRootLogin.*/PermitRootLogin no/' "$sshd_config"
        sed -i -E 's/^#?Protocol.*/Protocol 2/' "$sshd_config"
        sed -i -E 's/^#?LogLevel.*/LogLevel VERBOSE/' "$sshd_config"
    fi
    
    if [[ "$userChoice" == 7 ]]; then
        echo Hardening Network
        sudo ufw enable >> "./logs/latest.log"
        sudo ufw status >> "./logs/latest.log"
    fi
    
    if [[ "$userChoice" == 8 ]]; then
        echo Scanning for Unauthorized Files >> "./logs/latest.log"
    fi
    
    if [[ "$userChoice" == 9 ]]; then
        echo Running All >> "./logs/latest.log"
    fi
    
    if [[ "$userChoice" == 10 ]]; then
        echo Cleaning Up >> "./logs/latest.log"
        rm -rf ./config
        rm -rf ./scripts
        echo "Do you want to remove the logs? (y/n)"
        read removeLogs
        if [[ "$removeLogs" == y ]]; then
            rm -rf ./logs
            echo "Removed Logs"
        fi
        hasFinished=true
    fi
    reset
done

echo Sucessfully Cleaned Up
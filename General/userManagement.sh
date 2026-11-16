#!/bin/bash
echo Running User Management

# WORD_LIST="apple banana orange"
# SEARCH_TERM="banana"

# if echo "$WORD_LIST" | grep -qw "$SEARCH_TERM"; then
#     echo "'$SEARCH_TERM' found in the list."
# else
#     echo "'$SEARCH_TERM' not found in the list."
# fi

finishedUsers=false
permittedUsers=""
permittedAdmins=""
users=""

changePasswords() {
    userArray=($users)
    for user in "${userArray[@]}"; do
        # bash "./scripts/modules/damnit.sh" | sudo passwd "$user" >> "./logs/latest.log"
        echo "$user:Cyb$3c101" | chpasswd >> "./logs/latest.log"
        echo "changed password for $user to Cyb$3c101"
    done
    passwd -l root >> "./logs/latest.log"
}

pruneUsers() {
    userArray=($users)
    for user in "${userArray[@]}"; do
        if echo "$permittedUsers" | grep -qw "$user"; then
            echo "$user is permitted on the system" >> "./logs/latest.log"
        else
            echo "$user is not permitted on the system" >> "./logs/latest.log"
            sudo deluser "$user" >> "./logs/latest.log"
        fi
    done
    permittedArray=($permittedUsers)
    for pUser in "${permittedArray[@]}"; do
        if echo "$permittedAdmins" | grep -qw "$pUser"; then
            echo "$pUser is an admin on the system" >> "./logs/latest.log"
            sudo passwd "$pUser" sudo
        else
            echo "$pUser is not an admin on the system" >> "./logs/latest.log"
            sudo gpasswd -d "$pUser" sudo >> "./logs/latest.log"
        fi
    done
}

generateLists() {
    permittedUsers=""
    permittedAdmins=""
    users=""
    for user in $(cut -d: -f1,3 /etc/passwd | egrep ':[0-9]{4}$' | cut -d: -f1); do
        echo $user
        users="$users $user"
    done
    for user in $(cat ./config/users.list); do
        echo "permitted user: $user" >> "./logs/latest.log";
        permittedUsers="$permittedUsers $user"
    done
    for user in $(cat ./config/admins.list); do
        echo "permitted admin: $user" >> "./logs/latest.log";
        permittedAdmins="$permittedAdmins $user"
    done
    echo "$users" >> "./logs/latest.log"
}

generateLists
echo "test"
while [ "$finishedUsers" = false ]; do
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
    echo [0] Regenerate Lists
    echo [1] Change Passwords
    echo [2] Prune Users
    echo [3] Do All
    echo [4] Return to main
    read userCommand

    if [[ "$userCommand" == 0 ]]; then
        generateLists
    fi
    if [[ "$userCommand" == 1 ]]; then
        changePasswords
    fi
    if [[ "$userCommand" == 2 ]]; then
        pruneUsers
    fi
    if [[ "$userCommand" == 3 ]]; then
        generateLists
        pruneUsers
        changePasswords
    fi
    if [[ "$userCommand" == 4 ]]; then
        echo "Exitting"
        echo "This prompt may show up again and if it does select the 4th option again"
        finishedUsers=true
    fi
done
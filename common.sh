#!/bin/bash

# arg1: File that need to be backed up
# arg2: whether need to exec command as root
function backup()
{
    if [ $2 -eq 1 ] ;then
        sudo cp "$1" "$1".`date +%m_%d_%H_%M_%S`
    else
        cp "$1" "$1".`date +%m_%d_%H_%M_%S`
    fi

}

# arg1: keyword for checking
# arg2: content needs to be written
# arg3: target file
# arg4: whether need to exec command as root
function check_and_setup()
{
    grep "$1" "$3" > /dev/null
    if [ $? -ne 0 ] ;then
        echo "Adding $1 to $3" 
        if [ $4 -eq 1 ] ;then
            #sudo bash -c "echo "$2" >> "$3""
	    echo $2 | sudo tee -a $3 > /dev/null
        else
            echo "$2" >> "$3"
        fi
    else
        echo "$1 already in $3"
    fi
}

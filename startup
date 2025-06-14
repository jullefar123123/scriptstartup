#!/bin/false

# This file will be sourced in init.sh
# You can edit below here and make it do something useful

    # Calculate number of hugepages to allocate from memory (in MB)
    HUGEPAGES="$(($MEMORY/$(($(grep Hugepagesize /proc/meminfo | awk '{print $2}')/1024))))" 

    echo $(date) Allocating hugepages... >> /var/log/libvirthook.log
    echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
    ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

    TRIES=0
    while (( $ALLOC_PAGES != $HUGEPAGES && $TRIES < 1000 ))
    do
        echo 1 > /proc/sys/vm/compact_memory            ## defrag ram
        echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
        ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)
        echo $(date) Succesfully allocated $ALLOC_PAGES / $HUGEPAGES  >> /var/log/libvirthook.log
        let TRIES+=1
    done

    if [ "$ALLOC_PAGES" -ne "$HUGEPAGES" ]
    then
        echo $(date) Not able to allocate all hugepages. Reverting... >> /var/log/libvirthook.log
        echo 0 > /proc/sys/vm/nr_hugepages
        exit 1
    fi


    

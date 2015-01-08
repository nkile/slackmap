#!/bin/sh
    # scans “TARGETS” with nmap
    # compares with previous scan (if present) using ndiff
    # slacks diff results summary and uploads full scan as a fancy .html

    #variables
    TARGETS=10.22.1.*
    OPTIONS="-v -Pn -p1-65535 -T3"
    date=`date +%F`

    #where to put scans
    cd /home/nkile/nmapscans

    #scan
    nmap $OPTIONS $TARGETS -oA scan-$date > /dev/null

    #compare scans
    if [ -e scan-prev.xml ]; then
    ndiff scan-prev.xml scan-$date.xml > diff-$date
    cat diff-$date | ../slacktee.sh
    echo “*** NDIFF RESULTS ***”
    cat diff-$date
    echo
    fi
    echo “*** NMAP RESULTS ***”
    cat scan-$date.nmap
    ln -sf scan-$date.xml scan-prev.xml

    #slack results
    xsltproc scan-$date.xml -o scan-$date.html ; cat scan-$date.html | grep -v '\/\*' | ../slacktree.sh -f

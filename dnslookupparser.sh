#!/bin/bash
#
#This script will perform DNS lookups for all urls provided in a file as the first
#argument. for example dnslookupparser.sh filename. 
#
#The output  will be a file that consists of a list of the authorative sources IP 
#addresses for each url. urls that do not return a authorative source IP will not
#be in the final file


help() {
    echo 
    echo "This script will convert a list of urls to a list of ip addresses"
    echo "Usage as follows:"
    echo
    echo "dnslookupparser.sh [OPTIONS..] /path/to/inputfile path/to/outputfile"
    echo
    echo "Options"
    echo "-h show this help"
    echo "-v verbose mode"
    echo
    exit 1
}

while getopts hv SCRIPT_OPTIONS
do
    case $SCRIPT_OPTIONS in
        v)  
            echo "Verbose mode on"
            VERBOSE_MODE='true'
            ;;
        h)  help
            ;;
        ?)
            echo "Invalid option suppplied"
            echo 
            echo "dnslookupparser.sh -h for help"
            exit 1
            ;;
    esac
done

shift "$(( OPTIND -1 ))"

if [[ ! -f ${1} ]] || [[ ${#} -lt 2 ]]
then
    echo "Please provide an input file and an output file"
    echo
    echo "dnslookupparser.sh -h for help"
    exit 1
fi

if [[ -f ${2} ]]
then
   truncate -s 0 ${2} 
fi

while read URL_LINE
do
    if [[ $VERBOSE_MODE != 'true' ]]
    then
        nslookup ${URL_LINE} &>/dev/null
        if [[ ${?} -eq 0 ]]
        then 
            nslookup ${URL_LINE} | sed '6q;d' | awk -F ' ' '{print $2}' >> ${2}
        fi
    else

        nslookup ${URL_LINE} 
        if [[ ${?} -eq 0 ]]
        then 
            nslookup ${URL_LINE} | sed '6q;d' | awk -F ' ' '{print $2}' >> ${2}
        fi
    fi
done < ${1}

    

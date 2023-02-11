#!/bin/bash
#
#This script will perform DNS lookups for all urls provided in a file as the first
#argument. for example dnslookupparser.sh filename. 
#
#The output  will be a file that consists of a list of the authorative sources IP 
#addresses for each url. urls that do not return a authorative source IP will not
#be in the final file

# help Function

help() {
    echo 
    echo "This script will convert a list of urls to a list of ip addresses"
    echo "Usage as follows:"
    echo
    echo "dnslookupparser.sh [OPTIONS..] /path/to/inputfile path/to/outputfile"
    echo
    echo "Options"
    echo "-h show this help"
    echo "-v verbose mode. Will show each individual DNS lookup attempt"
    echo
    exit 1
}

# mynslookup Function

mynslookup() {
    nslookup ${URL_LINE} | sed '6q;d' | awk -F ' ' '{print $2}' >> ${1}
}

# Evalute getopts 

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
            help
            ;;
    esac
done

# Remove options from arguments

shift "$(( OPTIND -1 ))"

# Check if input file is a real file and if output file exists

if [[ ! -f ${1} ]] || [[ ${#} -lt 2 ]]
then
    echo "Please provide an input file and an output file"
    echo
    echo "dnslookupparser.sh -h for help"
    exit 1
fi

# if output file already exists empty it

if [[ -f ${2} ]]
then
   truncate -s 0 ${2} 
fi

# loop through lines in input file 

while read URL_LINE
do
    # if VERBOSE_MODE is not true then send real time output to /dev/null
    if [[ $VERBOSE_MODE != 'true' ]]
    then
        # try dns lookup in order to get exit status if 0 then execute mynslookup function 
        nslookup ${URL_LINE} &>/dev/null
        if [[ ${?} -eq 0 ]]
        then 
            mynslookup ${2}
        fi
    else
        # try dns lookup in order to get exit status if 0 then execute mynslookup function 
        nslookup ${URL_LINE} 
        if [[ ${?} -eq 0 ]]
        then 
            mynslookup ${2}
        fi
    fi
done < ${1}

    

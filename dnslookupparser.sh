#!/bin/bash
#
#This script will perform DNS lookups for all urls provided in a file as the first
#argument. for example dnslookupparser.sh filename. 
#
#The output  will be a file that consists of a list of the authorative sources IP 
#addresses for each url. urls that do not return a authorative source IP will not
#be in the final file

# Check that that a file is provided and it is a normal file.


# echo "Parameter 1: ${1}"
# echo "Parameter 2: ${2}"
# echo "Parameter 3: ${3}"
# echo "Parameter 4: ${4}"
# echo "Parameter 4: ${5}"

while getopts f:v SCRIPT_OPTIONS
do
    case $SCRIPT_OPTIONS in
        f)
            echo " will output to a file"
            FILE_OUTPUT='true'
            FILE_NAME="${OPTARG}"
            echo "${FILE_NAME}"
            ;;
        v)  
            echo " verbose mode on"
            VERBOSE_MODE='true'
            ;;
        ?)
            echo "invalid option suppplied"
            exit 1
            ;;
    esac
done

shift "$(( OPTIND -1 ))"

# echo "Parameter 1: ${1}"
# echo "Parameter 2: ${2}"
# echo "Parameter 3: ${3}"
# echo "Parameter 4: ${4}"
# echo "Parameter 4: ${5}"

if [[ ! -f ${1} ]]
then
    echo "Please provide a file containg urls"
    exit 1
fi

while read URL_LINE
do
    if [[ $VERBOSE_MODE != 'true' ]]
    then
        nslookup ${URL_LINE} &>/dev/null
        if [[ ${?} -eq 0 ]]
        then 
            nslookup ${URL_LINE} | sed '6q;d' | awk -F ' ' '{print $2}'
        fi
    else

        nslookup ${URL_LINE} 
        if [[ ${?} -eq 0 ]]
        then 
            nslookup ${URL_LINE} | sed '6q;d' | awk -F ' ' '{print $2}'
        fi
    fi
done < ${1}

    
# loop through the file, read each line

# perform DNS lookup for each line


# if lookup is successful then do the folllowing

# remove excess lines
# remove excess data from each line
# write to file


#!/bin/bash

#@${WORKSPACE}/reports/zap/${BUILD_TAG}.xml

usage()
{
    echo "usage: sysinfo_page [[[-f file ] [-t token] [-d defectdojo ip] [-s scan type ]] | [-h]]"
}

# 
while [ "$1" != "" ]; do
    case $1 in
        -f | --file )           shift
                                file=$1
                                ;;
        -t | --token )          shift
                                token=$1
                                ;;
        -d | --dojo )          shift
                                dojo=$1
                                ;;
        -s | --scan_type )          shift
                                scan_type=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

echo 'Uploading '$scan_type' Scan '$file' to '$dojo

# Curl request to defectdojo to add
curl --request POST \
  --url http://$dojo:8080/api/v2/import-scan/ \
  --header 'authorization: Token '$token \
  --form verified=true \
  --form active=true \
  --form lead=1 \
  --form tags=${BUILD_TAG} \
  --form scan_date=2019-07-17 \
  --form 'scan_type='$scan_type' Scan' \
  --form minimum_severity=Info \
  --form engagement=1 \
  --form skip_duplicates=true \
  --form file=@$file
# changed to use absolute filepath when using script
#  --form 'file=@${WORKSPACE}/reports/zap/'$filename

echo
echo $scan_type to dojo script complete


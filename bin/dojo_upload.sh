#!/bin/bash

#@${WORKSPACE}/reports/zap/${BUILD_TAG}.xml

### CHANGE THESE CONSTANTS -> SET IN JENKINS
engagement=3
lead=2
dojo=192.168.56.3
token=ace44a038703cd77f606ad2c5471ad8ab150117a
hawkeyeparser=${WORKSPACE}'/bin/hawkeyeparser.py'
#hawkeyeparser='./hawkeyeparser.py'

date=$(date '+%Y-%m-%d')

usage()
{
    echo "usage: dojo_upload.sh [[[-f file ] [-s scan type]] | [-h]]"
}

# 
while [ "$1" != "" ]; do
    case $1 in
        -f | --file )           shift
                                file=$1
                                ;;
        -s | --scan_type )      shift
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

case $scan_type in
        zap)
            scan_type_field='ZAP Scan'
            ;;
         
        hawkeye)
            scan_type_field='Generic Findings Import'
            python $hawkeyeparser $file
            new_file_name="${file%%.*}.csv"
            file=$new_file_name
            ;;
         
        snyk)
            scan_type_field='Snyk Scan'
            ;;

        trufflehog)
            scan_type_field='Trufflehog Scan'
            ;;

        checkmarx)
            scan_type_field='Checkmarx Scan'
            ;;
                           
        *)
            echo $"Usage: $0 {zap|hawkeye|snyk|trufflehog|checkmarx}"
            exit 1
esac

mkdir /tmp/reports -p
cp $file /tmp/reports/"${file##*/}"
file=/tmp/reports/"${file##*/}"

echo 'Uploading '$scan_type_field' '$file' to '$dojo

# Curl request to defectdojo to add
curl --request POST \
  --url http://$dojo:8080/api/v2/import-scan/ \
  --header 'authorization: Token '$token \
  --form verified=true \
  --form active=true \
  --form lead=$lead \
  --form tags=${BUILD_TAG} \
  --form scan_date=$date \
  --form 'scan_type='"$scan_type_field" \
  --form minimum_severity=Info \
  --form engagement=$engagement \
  --form skip_duplicates=true \
  --form file=@$file
# changed to use absolute filepath when using script

rm $file

echo
echo $scan_type to dojo script complete

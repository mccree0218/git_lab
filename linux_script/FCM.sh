#!/bin/bash
date=$(date '+%Y-%m-%d %H:%M:%S')
if [ -z "${1}" ]
then
        echo "please input apiUrl "
        exit 1
fi

apiUrl=${1}

generate_json_data()
{
  cat<<EOF
{
  "_mscale_header": {
    "_api_id": "fcmpush_01",
    "_system_id": "customer_system"
  },
  "reqHeader": {
    "apiId": "fcmpush_01",
    "reqSno": "c395e9f2-62c8-2b11-e865-ab4ec33dbf4f",
    "reqDateTime": "20220830114814",
    "locale": "TW,",
    "language": "zh-TW",
    "clientIp": "127.0.0.1",
    "browserVer": "1,0",
    "channel": "APP",
    "deviceId": "4A9FFBD66B45886E-1A2B3C4D5E6F7G8",
    "deviceOs": "Android",
    "deviceOsVer": "8.0.0",
    "deviceMfr": "LGE",
    "deviceModel": "LG-H870DS",
    "appMainVer": "1.00.0000",
    "appSubVer": "20220826_01"
  },
  "reqBody": {
  }
}
EOF
}

echo "call other-service location:$apiUrl ,reqBody:$(generate_json_data)"

HTTP_RESPONSE=$(curl -v \
-H "Content-Type: application/json" \
-w "HTTPSTATUS:%{http_code}" -X POST -d "$(generate_json_data)" "$apiUrl")

HTTP_STATUS=$(echo $HTTP_RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

# echo "result:$HTTP_RESPONSE"
# echo "status:$HTTP_STATUS"

if [ ! $HTTP_STATUS -eq 200  ]; then
  echo "Error [HTTP status: $HTTP_STATUS]"
  exit 1
fi

echo "$date call FCM finished result:$HTTP_RESPONSE">>/Users/scottliu/Desktop/waterpage/推播批次log/fcm.log
#echo "$date call FCM finished result:$HTTP_RESPONSE">>/app/mScale/fcm.log
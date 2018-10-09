#!/bin/sh

function set-config {
    local file="$1"
    while IFS="=" read -r key value; do
        case "$key" in
            '#'*) ;;
            "provisioner-ip") PROVISIONER_IP="$value" ;;
            "office-ms-name") OFFICE_MS_NAME="$value" ;;
            "office-ms-description") OFFICE_MS_DESCRIPTION="$value" ;;
            "office-ms-vendor") OFFICE_MS_VENDOR="$value";;
            "office-ip") OFFICE_IP="$value"; OFFICE_HOMEPAGE="http://$OFFICE_IP:2023/office-v1";;
            *)
                echo "Error: Unsupported key: $key"
                exit 1
                ;;
        esac
    done < "$file"
}

function login {
    TOKEN=$( curl -s -X POST -H "Content-Type: application/json" \
        'http://'"$PROVISIONER_IP"':2020/provisioner-v1/auth/token?grant_type=password&client_id=service-runner&username=wepemnefret&password=oS/0IiAME/2unkN1momDrhAdNKOhGykYFH/mJN20' \
         | jq --raw-output '.token' )
}

function add-ms-application-via-provisioner {
    local name=$1
    local description=$2
    local vendor=$3
    local homepage=$4
    curl -# -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" \
    --data '{ "name": "'"$name"'", "description": "'"$description"'", "vendor": "'"$vendor"'", "homepage": "'"$homepage"'" }' \
     http://${PROVISIONER_IP}:2020/provisioner-v1/applications
}

set-config $1
login
add-ms-application-via-provisioner $OFFICE_MS_NAME $OFFICE_MS_DESCRIPTION $OFFICE_MS_VENDOR $OFFICE_HOMEPAGE
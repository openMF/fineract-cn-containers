#!/bin/sh

function init-config {
    local file="$1"
    while IFS="=" read -r key value; do
        case "$key" in
            '#'*) ;;
            "provisioner-ip") PROVISIONER_IP="$value"; PROVISIONER_URL="http://${PROVISIONER_IP}:2020/provisioner-v1" ;;
            "office-ms-name") OFFICE_MS_NAME="$value" ;;
            "office-ms-description") OFFICE_MS_DESCRIPTION="$value" ;;
            "office-ms-vendor") OFFICE_MS_VENDOR="$value";;
            "office-ip") OFFICE_IP="$value"; OFFICE_URL="http://${OFFICE_IP}:2023/office-v1";;
            *)
                echo "Error: Unsupported key: $key"
                exit 1
                ;;
        esac
    done < "$file"
}

function login {
    TOKEN=$( curl -s -X POST -H "Content-Type: application/json" \
        "$PROVISIONER_URL"'/auth/token?grant_type=password&client_id=service-runner&username=wepemnefret&password=oS/0IiAME/2unkN1momDrhAdNKOhGykYFH/mJN20' \
         | jq --raw-output '.token' )
}

function create-microservice {
    local name="$1"
    local description="$2"
    local vendor="$3"
    local homepage="$4"
    curl -# -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" \
    --data '{ "name": "'"$name"'", "description": "'"$description"'", "vendor": "'"$vendor"'", "homepage": "'"$homepage"'" }' \
     ${PROVISIONER_URL}/applications
    echo ""
}

function list-microservices {
    echo ""
    echo "Microservices: "
    curl -s -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" ${PROVISIONER_URL}/applications | jq '.'
}

function delete-microservice {
    local service_name="$1"
    curl -X delete -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" ${PROVISIONER_URL}/applications/${service_name}
}

init-config $1
login
create-microservice $OFFICE_MS_NAME $OFFICE_MS_DESCRIPTION $OFFICE_MS_VENDOR $OFFICE_URL
list-microservices
delete-microservice $OFFICE_MS_NAME
list-microservices
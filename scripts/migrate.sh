#!/bin/sh

function init-config {
    local file="$1"

    while IFS="=" read -r key value; do
        case "$key" in
            '#'*) ;;
            "cassandra.clusterName") CASSANDRA_CLUSTER_NAME="$value" ;;
            "cassandra.contactPoints") CASSANDRA_CONTACT_POINTS="$value" ;;
            "cassandra.replicationType") CASSANDRA_REPLICATION_TYPE="$value" ;;
            "cassandra.replicas") CASSANDRA_REPLICAS="$value" ;;
            "mariadb.driverClass") MARIADB_DRIVER_CLASS="$value" ;;
            "mariadb.host") MARIADB_HOST="$value" ;;
            "mariadb.port") MARIADB_PORT="$value" ;;
            "mariadb.user") MARIADB_USER="$value" ;;
            "mariadb.password") MARIADB_PWD="$value" ;;
            "provisioner.ip") PROVISIONER_IP="$value"; PROVISIONER_URL="http://${PROVISIONER_IP}:2020/provisioner-v1" ;;
            "identity-ms.name") IDENTITY_MS_NAME="$value" ;;
            "identity-ms.description") IDENTITY_MS_DESCRIPTION="$value" ;;
            "identity-ms.vendor") IDENTITY_MS_VENDOR="$value";;
            "identity.ip") IDENTITY_IP="$value"; IDENTITY_URL="http://${IDENTITY_IP}:2021/identity-v1";;
            "rhythm-ms.name") RHYTHM_MS_NAME="$value" ;;
            "rhythm-ms.description") RHYTHM_MS_DESCRIPTION="$value" ;;
            "rhythm-ms.vendor") RHYTHM_MS_VENDOR="$value";;
            "rhythm.ip") RHYTHM_IP="$value"; RHYTHM_URL="http://${RHYTHM_IP}:2022/rhythm-v1";;
            "office-ms.name") OFFICE_MS_NAME="$value" ;;
            "office-ms.description") OFFICE_MS_DESCRIPTION="$value" ;;
            "office-ms.vendor") OFFICE_MS_VENDOR="$value";;
            "office.ip") OFFICE_IP="$value"; OFFICE_URL="http://${OFFICE_IP}:2023/office-v1";;
            "customer-ms.name") CUSTOMER_MS_NAME="$value" ;;
            "customer-ms.description") CUSTOMER_MS_DESCRIPTION="$value" ;;
            "customer-ms.vendor") CUSTOMER_MS_VENDOR="$value";;
            "customer.ip") CUSTOMER_IP="$value"; CUSTOMER_URL="http://${CUSTOMER_IP}:2024/customer-v1";;
            "ledger-ms.name") LEDGER_MS_NAME="$value" ;;
            "ledger-ms.description") LEDGER_MS_DESCRIPTION="$value" ;;
            "ledger-ms.vendor") LEDGER_MS_VENDOR="$value";;
            "ledger.ip") LEDGER_IP="$value"; LEDGER_URL="http://${LEDGER_IP}:2025/accounting-v1";;
            "portfolio-ms.name") PORTFOLIO_MS_NAME="$value" ;;
            "portfolio-ms.description") PORTFOLIO_MS_DESCRIPTION="$value" ;;
            "portfolio-ms.vendor") PORTFOLIO_MS_VENDOR="$value";;
            "portfolio.ip") PORTFOLIO_IP="$value"; PORTFOLIO_URL="http://${PORTFOLIO_IP}:2026/portfolio-v1";;
            "deposit-account-management-ms.name") DEPOSIT_MS_NAME="$value" ;;
            "deposit-account-management-ms.description") DEPOSIT_MS_DESCRIPTION="$value" ;;
            "deposit-account-management-ms.vendor") DEPOSIT_MS_VENDOR="$value";;
            "deposit-account-management.ip") DEPOSIT_IP="$value"; DEPOSIT_URL="http://${DEPOSIT_IP}:2027/deposit-v1";;
            "teller-ms.name") TELLER_MS_NAME="$value" ;;
            "teller-ms.description") TELLER_MS_DESCRIPTION="$value" ;;
            "teller-ms.vendor") TELLER_MS_VENDOR="$value";;
            "teller.ip") TELLER_IP="$value"; TELLER_URL="http://${TELLER_IP}:2028/teller-v1";;
            "report-ms.name") REPORT_MS_NAME="$value" ;;
            "report-ms.description") REPORT_MS_DESCRIPTION="$value" ;;
            "report-ms.vendor") REPORT_MS_VENDOR="$value";;
            "report.ip") REPORT_IP="$value"; REPORT_URL="http://${REPORT_IP}:2029/report-v1";;
            *)
                echo "Error: Unsupported key: $key"
                exit 1
                ;;
        esac
    done < "$file"
}

function auto-seshat {
    TOKEN=$( curl -s -X POST -H "Content-Type: application/json" \
        "$PROVISIONER_URL"'/auth/token?grant_type=password&client_id=service-runner&username=wepemnefret&password=oS/0IiAME/2unkN1momDrhAdNKOhGykYFH/mJN20' \
         | jq --raw-output '.token' )
}

function get-tenants {
    TENANTS=$( curl -s -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" ${PROVISIONER_URL}/tenants | jq '.' )
}

function get-assgined-applications {
    local tenant="$1"

    ASSIGNED_APPLICATIONS=$( curl -s -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" -H "X-Tenant-Identifier: $tenant" \
         ${PROVISIONER_URL}/tenants/$tenant/applications | jq '.' )
}

function assign-identity-ms {
    local tenant="$1"

    curl -s -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" \
	    --data '{ "name": "'"$IDENTITY_MS_NAME"'" }' \
	    ${PROVISIONER_URL}/tenants/${tenant}/identityservice
}

function provision-app {
    local tenant="$1"
    local service="$2"

    curl -s -X PUT -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" \
	--data '[{ "name": "'"$service"'" }]' \
	${PROVISIONER_URL}/tenants/${tenant}/applications | jq '.'
}

init-config $1
auto-seshat
get-tenants

for tenant in "${TENANTS[@]}"; do

    echo ""
    tenant_identifier=$(echo $tenant | jq ".[].identifier")
    tenant_identifier="${tenant_identifier%\"}"
    tenant_identifier="${tenant_identifier#\"}"
    echo "Migrating applications for tenant, ${tenant_identifier}."
    get-assgined-applications $tenant_identifier

    for application in "${ASSIGNED_APPLICATIONS[@]}"; do
        application=$(echo $application | jq ".[].name")
        application="${application%\"}"
        application="${application#\"}"
        if [ $application == $IDENTITY_MS_NAME ]; then
            assign-identity-ms $tenant_identifier
        else
            provision-app $tenant_identifier $application
        fi
    done

done
echo "COMPLETED PROCESS SUCCESSFULLY."
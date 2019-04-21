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
            "provisioner.ip") PROVISIONER_IP="$value"; PROVISIONER_URL="http://${PROVISIONER_IP}:2020/provisioner/v1" ;;
            "identity-ms.name") IDENTITY_MS_NAME="$value" ;;
            "identity-ms.description") IDENTITY_MS_DESCRIPTION="$value" ;;
            "identity-ms.vendor") IDENTITY_MS_VENDOR="$value";;
            "identity.ip") IDENTITY_IP="$value"; IDENTITY_URL="http://${IDENTITY_IP}:2021/identity/v1";;
            "rhythm-ms.name") RHYTHM_MS_NAME="$value" ;;
            "rhythm-ms.description") RHYTHM_MS_DESCRIPTION="$value" ;;
            "rhythm-ms.vendor") RHYTHM_MS_VENDOR="$value";;
            "rhythm.ip") RHYTHM_IP="$value"; RHYTHM_URL="http://${RHYTHM_IP}:2022/rhythm/v1";;
            "office-ms.name") OFFICE_MS_NAME="$value" ;;
            "office-ms.description") OFFICE_MS_DESCRIPTION="$value" ;;
            "office-ms.vendor") OFFICE_MS_VENDOR="$value";;
            "office.ip") OFFICE_IP="$value"; OFFICE_URL="http://${OFFICE_IP}:2023/office/v1";;
            "customer-ms.name") CUSTOMER_MS_NAME="$value" ;;
            "customer-ms.description") CUSTOMER_MS_DESCRIPTION="$value" ;;
            "customer-ms.vendor") CUSTOMER_MS_VENDOR="$value";;
            "customer.ip") CUSTOMER_IP="$value"; CUSTOMER_URL="http://${CUSTOMER_IP}:2024/customer/v1";;
            "ledger-ms.name") LEDGER_MS_NAME="$value" ;;
            "ledger-ms.description") LEDGER_MS_DESCRIPTION="$value" ;;
            "ledger-ms.vendor") LEDGER_MS_VENDOR="$value";;
            "ledger.ip") LEDGER_IP="$value"; LEDGER_URL="http://${LEDGER_IP}:2025/accounting/v1";;
            "portfolio-ms.name") PORTFOLIO_MS_NAME="$value" ;;
            "portfolio-ms.description") PORTFOLIO_MS_DESCRIPTION="$value" ;;
            "portfolio-ms.vendor") PORTFOLIO_MS_VENDOR="$value";;
            "portfolio.ip") PORTFOLIO_IP="$value"; PORTFOLIO_URL="http://${PORTFOLIO_IP}:2026/portfolio/v1";;
            "deposit-account-management-ms.name") DEPOSIT_MS_NAME="$value" ;;
            "deposit-account-management-ms.description") DEPOSIT_MS_DESCRIPTION="$value" ;;
            "deposit-account-management-ms.vendor") DEPOSIT_MS_VENDOR="$value";;
            "deposit-account-management.ip") DEPOSIT_IP="$value"; DEPOSIT_URL="http://${DEPOSIT_IP}:2027/deposit/v1";;
            "teller-ms.name") TELLER_MS_NAME="$value" ;;
            "teller-ms.description") TELLER_MS_DESCRIPTION="$value" ;;
            "teller-ms.vendor") TELLER_MS_VENDOR="$value";;
            "teller.ip") TELLER_IP="$value"; TELLER_URL="http://${TELLER_IP}:2028/teller/v1";;
            "report-ms.name") REPORT_MS_NAME="$value" ;;
            "report-ms.description") REPORT_MS_DESCRIPTION="$value" ;;
            "report-ms.vendor") REPORT_MS_VENDOR="$value";;
            "report.ip") REPORT_IP="$value"; REPORT_URL="http://${REPORT_IP}:2029/report/v1";;
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

function login {
    local tenant="$1"
    local username="$2"
    local password="$3"

    ACCESS_TOKEN=$( curl -s -X POST -H "Content-Type: application/json" -H "User: guest" -H "X-Tenant-Identifier: $tenant" \
       "${IDENTITY_URL}/token?grant_type=password&username=${username}&password=${password}" \
        | jq --raw-output '.accessToken' )
}

function create-application {
    local name="$1"
    local description="$2"
    local vendor="$3"
    local homepage="$4"

    curl -# -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" \
    --data '{ "name": "'"$name"'", "description": "'"$description"'", "vendor": "'"$vendor"'", "homepage": "'"$homepage"'" }' \
     ${PROVISIONER_URL}/applications
    echo "Created microservice: $name"
}

function get-application {
    echo ""
    echo "Microservices: "
    curl -s -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" ${PROVISIONER_URL}/applications | jq '.'
}

function delete-application {
    local service_name="$1"

    curl -X delete -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" ${PROVISIONER_URL}/applications/${service_name}
    echo "Deleted microservice: $name"
}

function create-tenant {
    local identifier="$1"
    local name="$2"
    local description="$3"
    local database_name="$4"

    curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" \
    --data '{
	"identifier": "'"$identifier"'",
	"name": "'"$name"'",
	"description": "'"$description"'",
	"cassandraConnectionInfo": {
		"clusterName": "'"$CASSANDRA_CLUSTER_NAME"'",
		"contactPoints": "'"$CASSANDRA_CONTACT_POINTS"'",
		"keyspace": "'"$database_name"'",
		"replicationType": "'"$CASSANDRA_REPLICATION_TYPE"'",
		"replicas": "'"$CASSANDRA_REPLICAS"'"
	},
	"databaseConnectionInfo": {
		"driverClass": "'"$MARIADB_DRIVER_CLASS"'",
		"databaseName": "'"$database_name"'",
		"host": "'"$MARIADB_HOST"'",
		"port": "'"$MARIADB_PORT"'",
		"user": "'"$MARIADB_USER"'",
		"password": "'"$MARIADB_PWD"'"
	}}' \
    ${PROVISIONER_URL}/tenants
    echo "Created tenant: $database_name"
}

function get-tenants {
    echo ""
    echo "Tenants: "
    curl -s -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" ${PROVISIONER_URL}/tenants | jq '.'
}

function assign-identity-ms {
    local tenant="$1"

    ADMIN_PASSWORD=$( curl -s -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" \
	--data '{ "name": "'"$IDENTITY_MS_NAME"'" }' \
	${PROVISIONER_URL}/tenants/${tenant}/identityservice | jq --raw-output '.adminPassword')
    echo "Assigned identity microservice for tenant $tenant"
}

function get-tenant-services {
    local tenant="$1"

    echo ""
    echo "$tenant services: "
    curl -s -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" -H "X-Tenant-Identifier: $tenant" ${PROVISIONER_URL}/tenants/$tenant/applications | jq '.'
}

function create-scheduler-role {
    local tenant="$1"

    curl -H "Content-Type: application/json" -H "User: antony" -H "Authorization: ${ACCESS_TOKEN}" -H "X-Tenant-Identifier: $tenant" \
        --data '{
                "identifier": "scheduler",
                "permissions": [
                        {
                                "permittableEndpointGroupIdentifier": "identity__v1__app_self",
                                "allowedOperations": ["CHANGE"]
                        },
                        {
                                "permittableEndpointGroupIdentifier": "portfolio__v1__khepri",
                                "allowedOperations": ["CHANGE"]
                        }
                ]
        }' \
        ${IDENTITY_URL}/roles
    echo "Created scheduler role"
}

function create-org-admin-role {
    local tenant="$1"

    curl -H "Content-Type: application/json" -H "User: antony" -H "Authorization: ${ACCESS_TOKEN}" -H "X-Tenant-Identifier: $tenant" \
        --data '{
                "identifier": "orgadmin",
                "permissions": [
                        {
                                "permittableEndpointGroupIdentifier": "office__v1__employees",
                                "allowedOperations": ["READ", "CHANGE", "DELETE"]
                        },
                        {
                                "permittableEndpointGroupIdentifier": "office__v1__offices",
                                "allowedOperations": ["READ", "CHANGE", "DELETE"]
                        },
                        {
                                "permittableEndpointGroupIdentifier": "identity__v1__users",
                                "allowedOperations": ["READ", "CHANGE", "DELETE"]
                        },
                        {
                                "permittableEndpointGroupIdentifier": "identity__v1__roles",
                                "allowedOperations": ["READ", "CHANGE", "DELETE"]
                        },
                        {
                                "permittableEndpointGroupIdentifier": "identity__v1__self",
                                "allowedOperations": ["READ", "CHANGE", "DELETE"]
                        },
                        {
                                "permittableEndpointGroupIdentifier": "accounting__v1__ledger",
                                "allowedOperations": ["READ", "CHANGE", "DELETE"]
                        },
                        {
                                "permittableEndpointGroupIdentifier": "accounting__v1__account",
                                "allowedOperations": ["READ", "CHANGE", "DELETE"]
                        }
                ]
        }' \
        ${IDENTITY_URL}/roles
    echo "Created organisation administrator role"
}

function create-user {
    local tenant="$1"
    local user="$2"
    local user_identifier="$3"
    local password="$4"
    local role="$5"

    curl -s -H "Content-Type: application/json" -H "User: $user" -H "Authorization: ${ACCESS_TOKEN}" -H "X-Tenant-Identifier: $tenant" \
        --data '{
                "identifier": "'"$user_identifier"'",
                "password": "'"$password"'",
                "role": "'"$role"'"
        }' \
        ${IDENTITY_URL}/users | jq '.'
    echo "Created user: $user_identifier"
}

function get-users {
    local tenant="$1"
    local user="$2"

    echo ""
    echo "Users: "
    curl -s -H "Content-Type: application/json" -H "User: $user" -H "Authorization: ${ACCESS_TOKEN}" -H "X-Tenant-Identifier: $tenant" ${IDENTITY_URL}/users | jq '.'
}

function update-password {
    local tenant="$1"
    local user="$2"
    local password="$3"

    curl -s -X PUT -H "Content-Type: application/json" -H "User: $user" -H "Authorization: ${ACCESS_TOKEN}" -H "X-Tenant-Identifier: $tenant" \
        --data '{
                "password": "'"$password"'"
        }' \
        ${IDENTITY_URL}/users/${user}/password | jq '.'
    echo "Updated $user password"
}

function provision-app {
    local tenant="$1"
    local service="$2"

    curl -s -X PUT -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${TOKEN}" \
	--data '[{ "name": "'"$service"'" }]' \
	${PROVISIONER_URL}/tenants/${tenant}/applications | jq '.'
    echo "Provisioned microservice, $service for tenant, $tenant"
}

function set-application-permission-enabled-for-user {
    local tenant="$1"
    local service="$2"
    local permission="$3"
    local user="$4"

    echo $tenant
    echo $service
    echo $permission
    echo $user
    echo $ACCESS_TOKEN
    curl -s -X PUT -H "Content-Type: application/json" -H "User: $user" -H "Authorization: ${ACCESS_TOKEN}" -H "X-Tenant-Identifier: $tenant" \
	--data 'true' \
	${IDENTITY_URL}/applications/${service}/permissions/${permission}/users/${user}/enabled | jq '.'
    echo "Enabled permission, $permission for service $service"
}

init-config $1
auto-seshat
create-application $IDENTITY_MS_NAME $IDENTITY_MS_DESCRIPTION $IDENTITY_MS_VENDOR $IDENTITY_URL
create-application $RHYTHM_MS_NAME $RHYTHM_MS_DESCRIPTION $RHYTHM_MS_VENDOR $RHYTHM_URL
create-application $OFFICE_MS_NAME $OFFICE_MS_DESCRIPTION $OFFICE_MS_VENDOR $OFFICE_URL
create-application $CUSTOMER_MS_NAME $CUSTOMER_MS_DESCRIPTION $CUSTOMER_MS_VENDOR $CUSTOMER_URL
create-application $LEDGER_MS_NAME $LEDGER_MS_DESCRIPTION $LEDGER_MS_VENDOR $LEDGER_URL
create-application $PORTFOLIO_MS_NAME $PORTFOLIO_MS_DESCRIPTION $PORTFOLIO_MS_VENDOR $PORTFOLIO_URL
create-application $DEPOSIT_MS_NAME $DEPOSIT_MS_DESCRIPTION $DEPOSIT_MS_VENDOR $DEPOSIT_URL
create-application $TELLER_MS_NAME $TELLER_MS_DESCRIPTION $TELLER_MS_VENDOR $TELLER_URL
create-application $REPORT_MS_NAME $REPORT_MS_DESCRIPTION $REPORT_MS_VENDOR $REPORT_URL

for TENANT in "${TENANTS[@]}"; do
    echo
    echo "Provisioning applications for tenant, ${TENANT}."
    echo
    read -p "Enter a name for the tenant, ${TENANT}: " -r name
    create-tenant ${TENANT} "${name}" "All in one Demo Server" ${TENANT}
    assign-identity-ms ${TENANT}
    login ${TENANT} "antony" $ADMIN_PASSWORD
    create-scheduler-role ${TENANT}
    create-user ${TENANT} "antony" "imhotep" "p4ssw0rd" "scheduler"
    login ${TENANT} "imhotep" "p4ssw0rd"
    update-password ${TENANT} "imhotep" "p4ssw0rd"
    provision-app ${TENANT} $RHYTHM_MS_NAME
    login ${TENANT} "imhotep" "p4ssw0rd"
    set-application-permission-enabled-for-user ${TENANT} $RHYTHM_MS_NAME "identity__v1__app_self" ${TENANT}
    provision-app ${TENANT} $OFFICE_MS_NAME

    provision-app ${TENANT} $LEDGER_MS_NAME
    provision-app ${TENANT} $PORTFOLIO_MS_NAME
    set-application-permission-enabled-for-user ${TENANT} $RHYTHM_MS_NAME "portfolio__v1__khepri" ${TENANT}
    provision-app ${TENANT} $CUSTOMER_MS_NAME
    provision-app ${TENANT} $DEPOSIT_MS_NAME
    provision-app ${TENANT} $TELLER_MS_NAME
    provision-app ${TENANT} $REPORT_MS_NAME

    login ${TENANT} "antony" $ADMIN_PASSWORD
    create-org-admin-role ${TENANT}
    create-user ${TENANT} "antony" "operator" "init1@l23" "orgadmin"
    login ${TENANT} "operator" "init1@l"
done

echo "COMPLETED PROCESS SUCCESSFULLY."
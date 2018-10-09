echo "Authenticating super user account"
token=$( curl -X POST -H "Content-Type: application/json" \
        'http://172.16.238.6:2020/provisioner-v1/auth/token?grant_type=password&client_id=service-runner&username=wepemnefret&password=oS/0IiAME/2unkN1momDrhAdNKOhGykYFH/mJN20' \
         | jq --raw-output '.token' )

echo ""
echo ""
echo "Creating Microservice application via Provision MS"
curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
    --data '{ "name": "identity-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://172.16.238.7:2021/identity-v1" }' \
     http://172.16.238.6:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "rhythm-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2022/rhythm-v1" }' \
#      http://172.16.238.6:2020/provisioner-v1/applications
# # curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "office-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2023/office-v1" }' \
#      http://172.16.238.6:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "customer-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2024/customer-v1" }' \
#      http://35.229.63.46:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "ledger-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2025/ledger-v1" }' \
#      http://35.229.63.46:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "portfolio-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2025/portfolio-v1" }' \
#      http://35.229.63.46:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "deposit-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2026/deposit-v1" }' \
#      http://35.229.63.46:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "teller-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2027/teller-v1" }' \
#      http://35.229.63.46:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "report-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2028/report-v1" }' \
#      http://35.229.63.46:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "cheque-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2020/cheque-v1" }' \
#      http://35.229.63.46:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "payroll-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2029/payroll-v1" }' \
#      http://35.229.63.46:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "group-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2020/group-v1" }' \
#      http://35.229.63.46:2020/provisioner-v1/applications

# echo ""
# echo ""
# echo "Deleting microservice"
# curl -X delete -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" http://172.16.238.6:2020/provisioner-v1/applications/identity-v1

echo "List of existing microservice applications"
curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" http://172.16.238.6:2020/provisioner-v1/applications | jq '.'

echo ""
echo ""
echo "Creating Tenants via Provision MS"
curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
    --data '{
	"identifier": "playground",
	"name": "A place to mess around and have fun",
	"description": "All in one Demo Server",
	"cassandraConnectionInfo": {
		"clusterName": "Test Cluster",
		"contactPoints": "172.16.238.5:9042",
		"keyspace": "playground",
		"replicationType": "Simple",
		"replicas": "3"
	},
	"databaseConnectionInfo": {
		"driverClass": "org.mariadb.jdbc.Driver",
		"databaseName": "playground",
		"host": "172.16.238.4",
		"port": "3306",
		"user": "root",
		"password": "mysql"
	}}' \
     http://172.16.238.6:2020/provisioner-v1/tenants

echo "List of existing tenants"
curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" http://172.16.238.6:2020/provisioner-v1/tenants | jq '.'

echo ""
echo ""
echo "Assign identity microservice for tenant"
adminPassword=$( curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
	--data '{ "name": "identity-v1" }' \
	http://172.16.238.6:2020/provisioner-v1/tenants/playground/identityservice | jq --raw-output '.adminPassword')

# Dont see the use of the below statement
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" -H "X-Tenant-Identifier: playground" http://172.16.238.6:2020/provisioner-v1/tenants/playground/applications | jq '.'

echo ""
echo ""
echo "Authenticate as an administrator"
accessToken=$( curl -X POST -H "Content-Type: application/json" -H "User: guest" -H "X-Tenant-Identifier: playground" \
       "http://172.16.238.7:2021/identity-v1/token?grant_type=password&username=antony&password=${adminPassword}" \
         | jq --raw-output '.accessToken' )

echo ""
echo "Create scheduler permission"
curl -H "Content-Type: application/json" -H "User: antony" -H "Authorization: ${accessToken}" -H "X-Tenant-Identifier: playground" \
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
        http://172.16.238.7:2021/identity-v1/roles

echo ""
echo "Create scheduler user"
curl -H "Content-Type: application/json" -H "User: antony" -H "Authorization: ${accessToken}" -H "X-Tenant-Identifier: playground" \
        --data '{
                "identifier": "imhotep",
                "password": "p4ssw0rd",
                "role": "scheduler"
        }' \
        http://172.16.238.7:2021/identity-v1/users | jq '.'

echo ""
echo ""
echo "Authenticate as the newly created scheduler user so as to enable the user's account"
tempAccessToken=$( curl -X POST -H "Content-Type: application/json" -H "User: guest" -H "X-Tenant-Identifier: playground" \
       'http://172.16.238.7:2021/identity-v1/token?grant_type=password&username=imhotep&password=p4ssw0rd' \
         | jq --raw-output '.accessToken' )

curl -X PUT -H "Content-Type: application/json" -H "User: imhotep" -H "Authorization: ${tempAccessToken}" -H "X-Tenant-Identifier: playground" \
        --data '{
                "password": "p4ssw0rd"
        }' \
        http://172.16.238.7:2021/identity-v1/users/imhotep/password | jq '.'


echo ""
curl -H "Content-Type: application/json" -H "User: antony" -H "Authorization: ${accessToken}" -H "X-Tenant-Identifier: playground" http://172.16.238.7:2021/identity-v1/users | jq '.'
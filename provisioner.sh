echo "Authenticating super user account"
token=$( curl -X POST -H "Content-Type: application/json" \
        'http://35.237.47.18:2020/provisioner-v1/auth/token?grant_type=password&client_id=service-runner&username=wepemnefret&password=oS/0IiAME/2unkN1momDrhAdNKOhGykYFH/mJN20' \
         | jq --raw-output '.token' )
# echo ""
# echo "Creating Microservice application via Provision MS"
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "identity-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2020/provisioner-v1" }' \
#      http://35.237.47.18:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "rhythm-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2020/provisioner-v1" }' \
#      http://35.237.47.18:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "office-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2020/provisioner-v1" }' \
#      http://35.237.47.18:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "customer-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2020/provisioner-v1" }' \
#      http://35.237.47.18:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "ledger-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2020/provisioner-v1" }' \
#      http://35.237.47.18:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "portfolio-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2020/provisioner-v1" }' \
#      http://35.237.47.18:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "deposit-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2020/provisioner-v1" }' \
#      http://35.237.47.18:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "teller-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2020/provisioner-v1" }' \
#      http://35.237.47.18:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "report-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2020/provisioner-v1" }' \
#      http://35.237.47.18:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "cheque-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2020/provisioner-v1" }' \
#      http://35.237.47.18:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "payroll-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2020/provisioner-v1" }' \
#      http://35.237.47.18:2020/provisioner-v1/applications
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
#     --data '{ "name": "group-v1", "description": "", "vendor": "Apache Fineract", "homepage": "http://35.231.130.203:2020/provisioner-v1" }' \
#      http://35.237.47.18:2020/provisioner-v1/applications

# echo "List of existing microservice applications"
# curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" http://35.237.47.18:2020/provisioner-v1/applications | jq '.'

echo ""
echo "Creating Tenants via Provision MS"
curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" \
    --data '{
	"identifier": "playground",
	"name": "A place to mess around and have fun",
	"description": "All in one Demo Server",
	"cassandraConnectionInfo": {
		"clusterName": "Test Cluster",
		"contactPoints": "35.237.151.82:9042",
		"keyspace": "playground",
		"replicationType": "Simple",
		"replicas": "3"
	},
	"databaseConnectionInfo": {
		"driverClass": "org.mariadb.jdbc.Driver",
		"databaseName": "playground",
		"host": "35.229.63.46",
		"port": "3306",
		"user": "root",
		"password": "mysql"
	}}' \
     http://35.237.47.18:2020/provisioner-v1/tenants

echo "List of existing tenants"
curl -H "Content-Type: application/json" -H "User: wepemnefret" -H "Authorization: ${token}" http://35.237.47.18:2020/provisioner-v1/tenants | jq '.'
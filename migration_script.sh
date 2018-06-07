declare -a domain_ms=("provisioner" "identity" "rhythm" "office" "customer" "portfolio" "deposit-account-management" "teller" "reporting" "payroll")

pwd="${PWD}/"

cd /$HOME/.m2/repository/org/apache/fineract/cn

echo "Migrating domain microservice"
for dir in "${domain_ms[@]}"
do
    cur_dir="${pwd}/$dir-ms-scripts/"
    cd "$dir/service-boot/0.1.0-BUILD-SNAPSHOT"
    cp service-boot-0.1.0-BUILD-SNAPSHOT.jar ${cur_dir}$dir-service-boot-0.1.0-BUILD-SNAPSHOT.jar
    echo "Completed migrating ${PWD} "
    echo ""
    cd ../../..
done
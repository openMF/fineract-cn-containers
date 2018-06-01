declare -a domain_ms=("provisioner" "identity" "rhythm" "office" "customer" "portfolio" "deposit-account-management" "teller" "reporting" "payroll")
declare -a core_ms=("api" "async" "cassandra" "command" "data-jpa" "lang" "mariadb" "crypto")

lib_dir="${PWD}/jar_files/"
rm -r ${lib_dir}
mkdir ${lib_dir}
cd /$HOME/.m2/repository/org/apache/fineract/cn

echo "Migrating domain microservice"
for dir in "${domain_ms[@]}"
do
    cd "$dir/service-boot/0.1.0-BUILD-SNAPSHOT"
    cp service-boot-0.1.0-BUILD-SNAPSHOT.jar ${lib_dir}$dir-service-boot-0.1.0-BUILD-SNAPSHOT.jar
    echo "Completed migrating ${PWD} "
    echo ""
    cd ../../..
done

echo "----------------------------------------------------------------------------------------"
echo "Migrating core microservice"
for dir in "${core_ms[@]}"
do
    cd "$dir/0.1.0-BUILD-SNAPSHOT"
    cp *.jar ${lib_dir}
    echo "Completed migrating ${PWD} "
    echo ""
    cd ../..
done

cd "anubis/api/0.1.0-BUILD-SNAPSHOT"
cp *.jar ${lib_dir}
echo "Completed migrating ${PWD} "
echo ""
cd ../..

#!/bin/sh

declare -a PortsArray=("61616" "8161" "8761" "3306" "9042")

echo "These ports ${PortsArray[@]} are required to continue:"
read -ep "Do you want to stop any processes using these ports? [y/N] " yesno
case $yesno in
    [Yy]* )
        for port in ${PortsArray[*]}; do
          running_process=`lsof -t -i :$port`
          if [ -n "$running_process" ]
          then
            for i in $running_process; do kill $i; done
            echo "Process on $port has been stopped"
          fi
        done
    *)
          echo "Skipping"
          break;;
esac
echo "Create service network"
docker network create --driver=bridge --subnet=172.16.238.0/24 externaltools_app_net

cd external-tools/
docker-compose up -d
echo "Cassandra is unavailable - sleeping ..."
while ! nc -z 172.16.238.5 9042; do
  sleep 1
done
echo "Cassandra is up - executing command."
cd ..

wget https://mifos.jfrog.io/mifos/libs-snapshot-local/org/apache/fineract/cn/lang/0.1.0-BUILD-SNAPSHOT/lang-0.1.0-BUILD-SNAPSHOT.jar
java -cp lang-0.1.0-BUILD-SNAPSHOT.jar org.apache.fineract.cn.lang.security.RsaKeyPairFactory UNIX > .env

docker-compose up -d
echo "Successfully started fineract services."
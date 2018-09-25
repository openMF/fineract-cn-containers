# Fineract CN container scripts

[![Join the chat at https://gitter.im/mifos-initiative/mifos.io](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/mifos-initiative/mifos.io?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Prequisite
You should have successfully built the Fineract CN microservice. 
Ensure the artifacts are located in $USER_HOME/.m2/repository/org/apache/fineract/cn/ 

## Requirements
- Docker
- Docker-compose or Kubernetes (Preferably Google Container Engine)

## Procedure
### Starting up the Fineract Microservices
  Run migration_script.sh
    `bash migration_script.sh`
    
**- Using Docker-compose**
1. Run the start-up.sh script to start the microservices
    `bash start-up.sh`
2. Run the shut-down.sh script to shut-down the microservices
    `bash shut-down.sh`
    
**- Using Kubernetes**
1. Change directory into the kubernetes-script directory
    `cd kubernetes-scripts`
2. Run the external tools first, i.e Activemq, Eureka, Cassandra, Maria DB
    `kubectl apply -f <tool file name>`
3. Now run all the fineract microservices
    `kubectl apply -f <service file name>`

### Provision the Fineract Microservices
1. Run the provision.sh script to provisiion the system.
    
    `bash provisioner.sh`
    
    *N.B:* Make sure to update the IP addresses as of the difference services as required

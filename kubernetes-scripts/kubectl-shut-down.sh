# cd kubernetes-scripts/
kubectl delete -f office.yml
kubectl delete -f customer.yml
kubectl delete -f portfolio.yml
kubectl delete -f rhythm.yml
kubectl delete -f identity.yml
kubectl delete -f provisioner.yml
kubectl delete configmaps my-config
kubectl delete configmaps secret-config
kubectl delete -f mariadb.yml
kubectl delete -f cassandra.yml
kubectl delete -f eureka.yml
kubectl delete -f activemq.yml
kubectl delete -f ledger.yml
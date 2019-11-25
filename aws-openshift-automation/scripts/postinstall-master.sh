#!/usr/bin/env bash

# Note: This script runs after the ansible install, use it to make configuration
# changes which would otherwise be overwritten by ansible.
sudo su

# Create an htpasswd file, we'll use htpasswd auth for OpenShift.
htpasswd -cb /etc/origin/master/htpasswd admin 123
echo "Password for 'admin' set to '123'"
htpasswd -b /etc/origin/master/htpasswd real-admin 123
kubectl create clusterrolebinding real-admin-binding --clusterrole=cluster-admin --user=real-admin

#kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.7/deploy/manifests/cert-manager.yaml --validate=false
#kubectl apply -f https://raw.githubusercontent.com/percona/percona-xtradb-cluster-operator/master/deploy/crd.yaml
#oc create clusterrole pxc-admin --verb="*" --resource=perconaxtradbclusters.pxc.percona.com,perconaxtradbclusters.pxc.percona.com/status,perconaxtradbclusterbackups.pxc.percona.com,perconaxtradbclusterbackups.pxc.percona.com/status,perconaxtradbclusterrestores.pxc.percona.com,perconaxtradbclusterrestores.pxc.percona.com/status,issuers.certmanager.k8s.io,certificates.certmanager.k8s.io
#oc adm policy add-cluster-role-to-user pxc-admin admin

#kubectl apply -f https://raw.githubusercontent.com/percona/percona-server-mongodb-operator/restore-controller/deploy/crd.yaml
#oc create clusterrole psmdb-admin --verb="*" --resource=perconaservermongodbs.psmdb.percona.com,perconaservermongodbs.psmdb.percona.com/status,perconaservermongodbbackups.psmdb.percona.com,perconaservermongodbbackups.psmdb.percona.com/status,perconaservermongodbrestores.psmdb.percona.com,perconaservermongodbrestores.psmdb.percona.com/status
#oc adm policy add-cluster-role-to-user psmdb-admin admin

# Update the docker config to allow OpenShift's local insecure registry. Also
# use json-file for logging, so our Splunk forwarder can eat the container logs.
# json-file for logging
sed -i '/OPTIONS=.*/c\OPTIONS="--selinux-enabled --insecure-registry 172.30.0.0/16 --log-driver=json-file --log-opt max-size=1M --log-opt max-file=3"' /etc/sysconfig/docker
echo "Docker configuration updated..."

# It seems that with OKD 3.10, systemctl restart docker will hang. So just reboot.
echo "Restarting host..."
shutdown -r now "restarting post docker configuration"

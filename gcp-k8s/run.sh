#!/bin/bash

set -o errexit
set -o xtrace

unset TILLER_NAMESPACE
PROJECT_ID=cloud-dev-112233

gcloud container clusters create --cluster-version 1.14 ${USER}-${RANDOM} --zone us-central1-a --project ${PROJECT_ID} --preemptible --machine-type n1-standard-4 --num-nodes=4 --enable-autoscaling --min-nodes=4 --max-nodes=6
kubectl create clusterrolebinding cluster-admin-binding1 --clusterrole=cluster-admin --user=$(gcloud config get-value core/account)

kubectl --namespace kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
helm repo update

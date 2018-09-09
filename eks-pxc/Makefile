all: kubeconfig aws-auth-cm storage-class spot-interrupt-handler

kubeconfig:
	terraform output kubeconfig > ~/.kube/config

aws-auth-cm:
	terraform output aws-auth-cm > /tmp/aws-auth-cm.yaml
	kubectl apply -f /tmp/aws-auth-cm.yaml

storage-class:
	kubectl delete -f gp2-storage-class.yaml || :
	kubectl create -f gp2-storage-class.yaml
	kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

spot-interrupt-handler:
	kubectl create serviceaccount --namespace kube-system tiller
	kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
	kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
	helm init
	helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
	helm repo update
	helm install incubator/kube-spot-termination-notice-handler --namespace kube-system

amazon-vpc-cni-k8s:
	kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/v1.1/aws-k8s-cni.yaml

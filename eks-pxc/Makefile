all: kubeconfig aws-auth-cm storage-class

kubeconfig:
	terraform output kubeconfig > ~/.kube/config

aws-auth-cm:
	terraform output aws-auth-cm > /tmp/aws-auth-cm.yaml
	kubectl apply -f /tmp/aws-auth-cm.yaml

storage-class:
	kubectl delete -f gp2-storage-class.yaml || :
	kubectl create -f gp2-storage-class.yaml
	kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

amazon-vpc-cni-k8s:
	kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/v1.1/aws-k8s-cni.yaml

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
	kubectl apply -f https://raw.githubusercontent.com/awslabs/ec2-spot-labs/master/ec2-spot-eks-solution/spot-termination-handler/deploy-k8-pod/spot-interrupt-handler.yaml

amazon-vpc-cni-k8s:
	kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/v1.1/aws-k8s-cni.yaml

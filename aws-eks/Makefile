all: kubeconfig aws-auth-cm storage-class spot-interrupt-handler

kubeconfig:
	terraform output kubeconfig > ~/.kube/config

aws-auth-cm:
	terraform output aws-auth-cm > /tmp/aws-auth-cm.yaml
	kubectl --context=eks apply -f /tmp/aws-auth-cm.yaml

storage-class:
	kubectl --context=eks delete -f gp2-storage-class.yaml || :
	kubectl --context=eks create -f gp2-storage-class.yaml
	kubectl --context=eks patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

spot-interrupt-handler:
	helm --kube-context=eks reset || :
	kubectl --context=eks delete -f tiller-rbac.yaml || :
	kubectl --context=eks apply -f tiller-rbac.yaml
	helm --kube-context=eks init --service-account tiller --upgrade
	helm --kube-context=eks repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
	helm --kube-context=eks repo update
	sleep 10
	helm --kube-context=eks install incubator/kube-spot-termination-notice-handler --namespace kube-system --name kube-spot-termination

amazon-vpc-cni-k8s:
	kubectl --context=eks apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/v1.2/aws-k8s-cni.yaml

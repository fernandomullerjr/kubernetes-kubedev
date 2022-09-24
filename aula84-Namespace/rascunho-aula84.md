
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# push

git status
git add .
git commit -m "aula84 - Namespace. pt1"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status


# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# 


- É possível limitar a quantidade de recursos que um Namespace pode utilizar.



- Criando manifestos de Deployments para a aula

blue

~~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deploy-blue
spec:
  selector:
    matchLabels:
      app: blue
  template:
    metadata:
      labels:
        app: blue
    spec:
      containers:
      - name: blue-app
        image: kubedevio/nginx-color:blue
~~~~

green

~~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deploy-green
spec:
  selector:
    matchLabels:
      app: green
  template:
    metadata:
      labels:
        app: green
    spec:
      containers:
      - name: green-app
        image: kubedevio/nginx-color:green
~~~~




- Aplicando os 2 deployments
kubectl apply -f /home/fernando/cursos/kubedev/aula84-Namespace/deploy-blue.yaml -f /home/fernando/cursos/kubedev/aula84-Namespace/deploy-green.yaml


fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl apply -f /home/fernando/cursos/kubedev/aula84-Namespace/deploy-blue.yaml -f /home/fernando/cursos/kubedev/aula84-Namespace/deploy-green.yaml
deployment.apps/deploy-blue created
deployment.apps/deploy-green created
fernando@debian10x64:~$ kubectl get pods -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS         AGE
default       deploy-blue-84bb56c6f9-cpjbk       1/1     Running   0                3s
default       deploy-green-796fb598c4-wz9xc      1/1     Running   0                3s
kube-system   coredns-78fcd69978-8jj6b           1/1     Running   9 (2m31s ago)    27d
kube-system   etcd-minikube                      1/1     Running   9 (2m31s ago)    27d
kube-system   kube-apiserver-minikube            1/1     Running   9 (2m31s ago)    27d
kube-system   kube-controller-manager-minikube   1/1     Running   11 (2m31s ago)   27d
kube-system   kube-proxy-p7jhs                   1/1     Running   9 (2m31s ago)    27d
kube-system   kube-scheduler-minikube            1/1     Running   9 (2m31s ago)    27d
kube-system   storage-provisioner                1/1     Running   19               27d
fernando@debian10x64:~$




# push

git status
git add .
git commit -m "aula84 - Namespace. pt2"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status

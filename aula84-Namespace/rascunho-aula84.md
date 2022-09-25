
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
# Namespace


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



- Efetuando teste via Port-forward, conseguimos acessar o Blue e o Green:

kubectl port-forward deploy-blue-84bb56c6f9-cpjbk 8080:80

fernando@debian10x64:~$ curl -s localhost:8080 | grep color
        background-color: blue;
fernando@debian10x64:~$


kubectl port-forward deploy-green-796fb598c4-wz9xc 8080:80

fernando@debian10x64:~$ curl -s localhost:8080 | grep color
        background-color: green;
fernando@debian10x64:~$



- Até o momento, os 2 estão no Namespace default, pois não foi especificado um Namespace durante a criação.




# Isolando ambientes

- Criar namespaces para separar
kubectl create namespace blue
kubectl create namespace green


- Deletando os 2 deployments
kubectl delete -f /home/fernando/cursos/kubedev/aula84-Namespace/deploy-blue.yaml -f /home/fernando/cursos/kubedev/aula84-Namespace/deploy-green.yaml

fernando@debian10x64:~$ kubectl get deployments
No resources found in default namespace.
fernando@debian10x64:~$

fernando@debian10x64:~$ kubectl get namespaces
NAME              STATUS   AGE
blue              Active   58s
default           Active   27d
green             Active   57s
kube-node-lease   Active   27d
kube-public       Active   27d
kube-system       Active   27d
fernando@debian10x64:~$




- Criando manifestos de Deployments para cada ambiente.
- Podemos usar o mesmo name nos Deployments agora, visto que estarão em Namespaces separados.

blue

~~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deploy-nginx-color
spec:
  selector:
    matchLabels:
      app: nginx-color
  template:
    metadata:
      labels:
        app: nginx-color
    spec:
      containers:
      - name: nginx-color
        image: kubedevio/nginx-color:blue
~~~~

green

~~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deploy-nginx-color
spec:
  selector:
    matchLabels:
      app: nginx-color
  template:
    metadata:
      labels:
        app: nginx-color
    spec:
      containers:
      - name: nginx-color
        image: kubedevio/nginx-color:green
~~~~



- Aplicando os 2 deployments
- Especificando o Namespace
kubectl apply -f /home/fernando/cursos/kubedev/aula84-Namespace/deploy-blue_v2.yaml -n blue
kubectl apply -f /home/fernando/cursos/kubedev/aula84-Namespace/deploy-green_v2.yaml -n green


fernando@debian10x64:~$ kubectl get deployments
No resources found in default namespace.
fernando@debian10x64:~$ kubectl get deployments -A
NAMESPACE     NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
blue          deploy-nginx-color   1/1     1            1           8s
green         deploy-nginx-color   1/1     1            1           8s
kube-system   coredns              1/1     1            1           27d
fernando@debian10x64:~$




- Setando o Namespace no manifesto


blue

~~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deploy-nginx-color
  namespace: blue
spec:
  selector:
    matchLabels:
      app: nginx-color
  template:
    metadata:
      labels:
        app: nginx-color
    spec:
      containers:
      - name: nginx-color
        image: kubedevio/nginx-color:blue
~~~~

green

~~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deploy-nginx-color
  namespace: green
spec:
  selector:
    matchLabels:
      app: nginx-color
  template:
    metadata:
      labels:
        app: nginx-color
    spec:
      containers:
      - name: nginx-color
        image: kubedevio/nginx-color:green
~~~~


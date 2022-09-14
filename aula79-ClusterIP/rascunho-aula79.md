
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# push
git status
git add .
git commit -m "aula79 - ClusterIP. pt1"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status


# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ClusterIP

- Criando um Deployment que vai ter a API de conversão de temperatura
- Usar a imagem do Kubedevio
    <https://hub.docker.com/r/kubedevio/api-conversao/tags>

~~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: api
        image: kubedevio/api-conversao:v1-machine-name
~~~~


- Aplicando:
kubectl apply -f /home/fernando/cursos/kubedev/aula79-ClusterIP/deployment.yaml


fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl apply -f /home/fernando/cursos/kubedev/aula79-ClusterIP/deployment.yaml
deployment.apps/api created
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl get deploy -A
NAMESPACE     NAME      READY   UP-TO-DATE   AVAILABLE   AGE
default       api       0/1     1            0           6s
kube-system   coredns   1/1     1            1           16d
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$

fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl get deploy -A
NAMESPACE     NAME      READY   UP-TO-DATE   AVAILABLE   AGE
default       api       1/1     1            1           18s
kube-system   coredns   1/1     1            1           16d
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$

fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl get pods -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS        AGE
default       api-864b7ff7ff-gp6zz               1/1     Running   0               28s




fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl get pods -A -o wide
NAMESPACE     NAME                               READY   STATUS    RESTARTS        AGE   IP             NODE       NOMINATED NODE   READINESS GATES
default       api-864b7ff7ff-gp6zz               1/1     Running   0               60s   172.17.0.2     minikube   <none>           <none>



kubectl run -i --tty --image kubedevio/ubuntu-curl ping-test --restart=Never --rm -- /bin/bash


fernando@debian10x64:~$ kubectl run -i --tty --image kubedevio/ubuntu-curl ping-test --restart=Never --rm -- /bin/bash
If you don't see a command prompt, try pressing enter.
root@ping-test:/#



curl http://172.17.0.2/temperatura/fahrenheitparacelsius/100


root@ping-test:/# curl http://172.17.0.2/temperatura/fahrenheitparacelsius/100
curl: (7) Failed to connect to 172.17.0.2 port 80: Connection refused
root@ping-test:/#


curl http://172.17.0.2:8080/temperatura/fahrenheitparacelsius/100


root@ping-test:/# cat | curl http://172.17.0.2:8080/temperatura/fahrenheitparacelsius/100
{"celsius":37.77777777777778,"maquina":"api-864b7ff7ff-gp6zz"}
root@ping-test:/#




- Como o endereço ip do Pod vai alternar após ser deletado, pois não tem um Service atrelado a ele, iremos criar um Service, para que a comunicação seja mais prática e não precisarmos buscar pelo novo ip do Pod toda vez que ele mudar.




# SERVICE

- Criar um manifesto para o Service
/home/fernando/cursos/kubedev/aula79-ClusterIP/service.yaml

- Por padrão/default o tipo do Service é ClusterIP, caso seja omitido.
- No meu caso estou deixando explicito:
    type: ClusterIP
- Definindo as portas:
    Porta 80 do meu Service
    Porta 8080 do meu Container como targetPort

- Manifesto do Service ficou assim:

~~~~yaml
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  selector:
    app: api
  type: ClusterIP
  ports:
    - targetPort: 8080
      port: 80
~~~~


- Recriando o Deployment e o Pod:
kubectl apply -f /home/fernando/cursos/kubedev/aula79-ClusterIP/deployment.yaml



fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl apply -f /home/fernando/cursos/kubedev/aula79-ClusterIP/deployment.yaml
deployment.apps/api created
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl get pods -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS       AGE
default       api-864b7ff7ff-mbjph               1/1     Running   0              3s
default       ping-test                          1/1     Running   0              20m
kube-system   coredns-78fcd69978-8jj6b           1/1     Running   5 (24m ago)    16d
kube-system   etcd-minikube                      1/1     Running   5 (24m ago)    16d
kube-system   kube-apiserver-minikube            1/1     Running   5 (24m ago)    16d
kube-system   kube-controller-manager-minikube   1/1     Running   6 (24m ago)    16d
kube-system   kube-proxy-p7jhs                   1/1     Running   5 (24m ago)    16d
kube-system   kube-scheduler-minikube            1/1     Running   5 (24m ago)    16d
kube-system   storage-provisioner                1/1     Running   11 (23m ago)   16d
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl get deploy -A
NAMESPACE     NAME      READY   UP-TO-DATE   AVAILABLE   AGE
default       api       1/1     1            1           8s
kube-system   coredns   1/1     1            1           16d
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$



- Criando o Service ClusterIP:
kubectl apply -f /home/fernando/cursos/kubedev/aula79-ClusterIP/service.yaml



fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl apply -f /home/fernando/cursos/kubedev/aula79-ClusterIP/service.yaml
service/api-service created
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl get svc -A
NAMESPACE     NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                  AGE
default       api-service   ClusterIP   10.100.147.231   <none>        80/TCP                   5s
default       kubernetes    ClusterIP   10.96.0.1        <none>        443/TCP                  16d
kube-system   kube-dns      ClusterIP   10.96.0.10       <none>        53/UDP,53/TCP,9153/TCP   16d
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$


- Tentando acessar a api usando o nome do Service:
curl http://api-service/temperatura/fahrenheitparacelsius/200


- FUNCIONANDO:

root@ping-test:/# cat | curl http://api-service/temperatura/fahrenheitparacelsius/200
{"celsius":93.33333333333333,"maquina":"api-864b7ff7ff-mbjph"}
root@ping-test:/#



# push
git status
git add .
git commit -m "aula79 - Service - ClusterIP. pt2"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status




- Escalando os Pods do Deployment, para validar:
kubectl scale deployment api --replicas 5


fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl get pods -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS       AGE
default       api-864b7ff7ff-5tlgl               1/1     Running   0              12s
default       api-864b7ff7ff-6sdf7               1/1     Running   0              12s
default       api-864b7ff7ff-mbjph               1/1     Running   0              3m53s
default       api-864b7ff7ff-xh9w8               1/1     Running   0              12s
default       api-864b7ff7ff-xvb6w               1/1     Running   0              12s
default       ping-test                          1/1     Running   0              24m
kube-system   coredns-78fcd69978-8jj6b           1/1     Running   5 (28m ago)    16d
kube-system   etcd-minikube                      1/1     Running   5 (28m ago)    16d
kube-system   kube-apiserver-minikube            1/1     Running   5 (28m ago)    16d
kube-system   kube-controller-manager-minikube   1/1     Running   6 (28m ago)    16d
kube-system   kube-proxy-p7jhs                   1/1     Running   5 (28m ago)    16d
kube-system   kube-scheduler-minikube            1/1     Running   5 (28m ago)    16d
kube-system   storage-provisioner                1/1     Running   11 (27m ago)   16d
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$



- Agora efetuando novo teste de curl na api, é possível verificar que o Pod que responde a requisição vai alternando, pois estamos mandando a requisição para o Service:


root@ping-test:/# cat | curl http://api-service/temperatura/fahrenheitparacelsius/200
{"celsius":93.33333333333333,"maquina":"api-864b7ff7ff-5tlgl"}
root@ping-test:/#
root@ping-test:/#
root@ping-test:/# cat | curl http://api-service/temperatura/fahrenheitparacelsius/200
{"celsius":93.33333333333333,"maquina":"api-864b7ff7ff-6sdf7"}
root@ping-test:/#
root@ping-test:/#
root@ping-test:/# cat | curl http://api-service/temperatura/fahrenheitparacelsius/200
{"celsius":93.33333333333333,"maquina":"api-864b7ff7ff-xvb6w"}
root@ping-test:/#
root@ping-test:/# date
Wed Sep 14 02:07:12 UTC 2022
root@ping-test:/#

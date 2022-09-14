
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


# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# push

git status
git add .
git commit -m "aula85 - Comunicação entre Namespaces. pt1"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status


# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# aula85 - Comunicação entre Namespaces

- Criar 1 Service para cada 1 dos Deployments

~~~~yaml
apiVersion: v1
kind: Service
metadata:
  name: service-nginx-color
spec:
  selector:
    app: nginx-color
  ports:
    - targetPort: 80
      port: 80
  type: NodePort
~~~~



- Aplicando o Service em cada Namespace
kubectl apply -f /home/fernando/cursos/kubedev/aula85-Comunicacao-entre-Namespaces/service.yaml -n blue
kubectl apply -f /home/fernando/cursos/kubedev/aula85-Comunicacao-entre-Namespaces/service.yaml -n green

- Verificando que os Services foram criados:

fernando@debian10x64:~$ kubectl get service -A
NAMESPACE     NAME                              TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                  AGE
blue          service-nginx-color               NodePort       10.107.181.119   <none>          80:31991/TCP             9s
default       api-service                       LoadBalancer   10.97.235.114    <pending>       80:30042/TCP             10d
default       fernando-service-external         ExternalName   <none>           appmax.com.br   <none>                   4d20h
default       fernando-service-external-4devs   ExternalName   <none>           4devs.com.br    <none>                   4d20h
default       kubernetes                        ClusterIP      10.96.0.1        <none>          443/TCP                  27d
green         service-nginx-color               NodePort       10.109.189.22    <none>          80:30884/TCP             9s
kube-system   kube-dns                          ClusterIP      10.96.0.10       <none>          53/UDP,53/TCP,9153/TCP   27d
fernando@debian10x64:~$


- Pegando o ip do Node, para testar o acesso como se fosse externo:

fernando@debian10x64:~$ kubectl get nodes -o wide
NAME       STATUS   ROLES                  AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION    CONTAINER-RUNTIME
minikube   Ready    control-plane,master   27d   v1.22.2   192.168.49.2   <none>        Ubuntu 20.04.2 LTS   4.19.0-17-amd64   docker://20.10.8
fernando@debian10x64:~$

- Testando os acessos aos Services:

fernando@debian10x64:~$ curl -s 192.168.49.2:31991 | grep color
        background-color: blue;
fernando@debian10x64:~$

fernando@debian10x64:~$ curl -s 192.168.49.2:30884 | grep color
        background-color: green;
fernando@debian10x64:~$





# Comunicando Pods de Namespaces diferentes

4:32

# push

git status
git add .
git commit -m "aula85 - Comunicação entre Namespaces. pt2"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



- Criando um Pod do Ubuntu no Namespace "default", para validar a comunicação:
kubectl run -i --tty --image kubedevio/ubuntu-curl ping-test --restart=Never --rm -- /bin/bash


- Pegando ip dos Pods:

fernando@debian10x64:~$ kubectl get pods -A -o wide
NAMESPACE     NAME                                  READY   STATUS    RESTARTS       AGE   IP             NODE       NOMINATED NODE   READINESS GATES
blue          deploy-nginx-color-7c587bcd8f-sgwbf   1/1     Running   0              15m   172.17.0.3     minikube   <none>           <none>
default       ping-test                             1/1     Running   0              11s   172.17.0.5     minikube   <none>           <none>
green         deploy-nginx-color-655b9bb494-4t2mh   1/1     Running   0              15m   172.17.0.4     minikube   <none>           <none>
kube-system   coredns-78fcd69978-8jj6b              1/1     Running   9 (31m ago)    27d   172.17.0.2     minikube   <none>           <none>
kube-system   etcd-minikube                         1/1     Running   9 (31m ago)    27d   192.168.49.2   minikube   <none>           <none>
kube-system   kube-apiserver-minikube               1/1     Running   9 (31m ago)    27d   192.168.49.2   minikube   <none>           <none>
kube-system   kube-controller-manager-minikube      1/1     Running   11 (31m ago)   27d   192.168.49.2   minikube   <none>           <none>
kube-system   kube-proxy-p7jhs                      1/1     Running   9 (31m ago)    27d   192.168.49.2   minikube   <none>           <none>
kube-system   kube-scheduler-minikube               1/1     Running   9 (31m ago)    27d   192.168.49.2   minikube   <none>           <none>
kube-system   storage-provisioner                   1/1     Running   19             27d   192.168.49.2   minikube   <none>           <none>
fernando@debian10x64:~$


- Testando comunicação a partir do Pod do Ubuntu CURL:

root@ping-test:/# curl 172.17.0.3 -s | grep color
        background-color: blue;
root@ping-test:/#

- Comunicação ocorre, mesmo estando em Namespaces distintos!





# Dia 25/09/2022

# ##############################################################################################################################################################
# Testando comunicação com o Service

- Necessário deletar o Pod do Ubuntu Curl e recriar ele, pois está com erro:

fernando@debian10x64:~/cursos/kubedev/aula85-Comunicacao-entre-Namespaces$  kubectl get pods -A -o wide
NAMESPACE     NAME                                  READY   STATUS    RESTARTS         AGE   IP             NODE       NOMINATED NODE   READINESS GATES
blue          deploy-nginx-color-7c587bcd8f-sgwbf   1/1     Running   1 (2m18s ago)    12h   172.17.0.3     minikube   <none>           <none>
default       ping-test                             0/1     Error     0                12h   <none>         minikube   <none>           <none>
green         deploy-nginx-color-655b9bb494-4t2mh   1/1     Running   1 (2m18s ago)    12h   172.17.0.4     minikube   <none>           <none>
fernando@debian10x64:~/cursos/kubedev/aula85-Comunicacao-entre-Namespaces$ kubectl delete pod ping-test
pod "ping-test" deleted
fernando@debian10x64:~/cursos/kubedev/aula85-Comunicacao-entre-Namespaces$

kubectl run -i --tty --image kubedevio/ubuntu-curl ping-test --restart=Never --rm -- /bin/bash




- Pegando detalhes do Node e dos Services:

kubectl get nodes -o wide
kubectl get svc -o wide -A

fernando@debian10x64:~/cursos/kubedev/aula85-Comunicacao-entre-Namespaces$ kubectl get nodes -o wide
NAME       STATUS   ROLES                  AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION    CONTAINER-RUNTIME
minikube   Ready    control-plane,master   28d   v1.22.2   192.168.49.2   <none>        Ubuntu 20.04.2 LTS   4.19.0-17-amd64   docker://20.10.8
fernando@debian10x64:~/cursos/kubedev/aula85-Comunicacao-entre-Namespaces$ kubectl get svc -o wide -A
NAMESPACE     NAME                              TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                  AGE    SELECTOR
blue          service-nginx-color               NodePort       10.107.181.119   <none>          80:31991/TCP             12h    app=nginx-color
default       api-service                       LoadBalancer   10.97.235.114    <pending>       80:30042/TCP             11d    app=api
default       fernando-service-external         ExternalName   <none>           appmax.com.br   <none>                   5d9h   <none>
default       fernando-service-external-4devs   ExternalName   <none>           4devs.com.br    <none>                   5d8h   <none>
default       kubernetes                        ClusterIP      10.96.0.1        <none>          443/TCP                  28d    <none>
green         service-nginx-color               NodePort       10.109.189.22    <none>          80:30884/TCP             12h    app=nginx-color
kube-system   kube-dns                          ClusterIP      10.96.0.10       <none>          53/UDP,53/TCP,9153/TCP   28d    k8s-app=kube-dns
fernando@debian10x64:~/cursos/kubedev/aula85-Comunicacao-entre-Namespaces$



- Testando a partir do Pod do Ubuntu-Curl, comunicação OK com o IP do Node e a porta do Service:

curl http://192.168.49.2:31991 -s | grep color

root@ping-test:/# curl http://192.168.49.2:31991 -s | grep color
        background-color: blue;
root@ping-test:/#


curl http://192.168.49.2:30884 -s | grep color

root@ping-test:/# curl http://192.168.49.2:30884 -s | grep color
        background-color: green;
root@ping-test:/#



- Testando comunicação a partir do Pod Ubuntu-Curl, para o nome do Service:

curl http://service-nginx-color | grep color

Ocorre o erro abaixo:

root@ping-test:/# curl http://service-nginx-color
curl: (6) Could not resolve host: service-nginx-color
root@ping-test:/#

Este problema acontece porque o Service está em outro Namespace, o Ubuntu-Curl está no Namespace "default", enquanto os services estão em Namespaces separados(blue, green).



- Para poder comunicar com os services, é necessário o nome completo do Service, quando não está no mesmo Namespace.
- Exemplo:
<service>.<namespace>.svc.cluster.local

curl http://service-nginx-color.blue.svc.cluster.local
curl -s http://service-nginx-color.blue.svc.cluster.local | grep color

root@ping-test:/# curl -s http://service-nginx-color.blue.svc.cluster.local | grep color
        background-color: blue;
root@ping-test:/#


curl http://service-nginx-color.green.svc.cluster.local
curl -s http://service-nginx-color.green.svc.cluster.local | grep color

root@ping-test:/# curl -s http://service-nginx-color.green.svc.cluster.local | grep color
        background-color: green;
root@ping-test:/#




# ##############################################################################################################################################################
# Usando Service ExternalName

- Uma outra maneira de comunicar a partir de um Namespace diferente com os Namespaces que desejamos, é utilizando o Service do tipo ExternalName.
- Criamos um apontamento para cada service dos Namespace especificos, usando o nome completo do Service para o apontamento do externalName.
- Assim conseguimos resolver o nome a partir do Namespace diferente!

blue

~~~~yaml
kind: Service
apiVersion: v1
metadata:
  name: service-nginx-blue
spec:
  type: ExternalName
  externalName: service-nginx-color.blue.svc.cluster.local
~~~~

green

~~~~yaml
kind: Service
apiVersion: v1
metadata:
  name: service-nginx-green
spec:
  type: ExternalName
  externalName: service-nginx-color.green.svc.cluster.local
~~~~


- Atualmente, não conseguimos resolver os nomes destes services:

root@ping-test:/# curl http://service-nginx-blue
curl: (6) Could not resolve host: service-nginx-blue
root@ping-test:/#
root@ping-test:/# curl http://service-nginx-green
curl: (6) Could not resolve host: service-nginx-green
root@ping-test:/#

- Aplicando os Service ExternalName:
kubectl apply -f /home/fernando/cursos/kubedev/aula85-Comunicacao-entre-Namespaces/service-external-blue.yaml -f /home/fernando/cursos/kubedev/aula85-Comunicacao-entre-Namespaces/service-external-green.yaml

fernando@debian10x64:~/cursos/kubedev/aula85-Comunicacao-entre-Namespaces$ kubectl get svc -o wide -A
NAMESPACE     NAME                              TYPE           CLUSTER-IP       EXTERNAL-IP                                   PORT(S)                  AGE    SELECTOR
blue          service-nginx-color               NodePort       10.107.181.119   <none>                                        80:31991/TCP             13h    app=nginx-color
default       api-service                       LoadBalancer   10.97.235.114    <pending>                                     80:30042/TCP             11d    app=api
default       fernando-service-external         ExternalName   <none>           appmax.com.br                                 <none>                   5d9h   <none>
default       fernando-service-external-4devs   ExternalName   <none>           4devs.com.br                                  <none>                   5d9h   <none>
default       kubernetes                        ClusterIP      10.96.0.1        <none>                                        443/TCP                  28d    <none>
default       service-nginx-blue                ExternalName   <none>           service-nginx-color.blue.svc.cluster.local    <none>                   3s     <none>
default       service-nginx-green               ExternalName   <none>           service-nginx-color.green.svc.cluster.local   <none>                   3s     <none>
green         service-nginx-color               NodePort       10.109.189.22    <none>                                        80:30884/TCP             13h    app=nginx-color
kube-system   kube-dns                          ClusterIP      10.96.0.10       <none>                                        53/UDP,53/TCP,9153/TCP   28d    k8s-app=kube-dns
fernando@debian10x64:~/cursos/kubedev/aula85-Comunicacao-entre-Namespaces$


- Agora está funcionando:

root@ping-test:/# curl -s http://service-nginx-blue | grep color
        background-color: blue;
root@ping-test:/#
root@ping-test:/#
root@ping-test:/#
root@ping-test:/# curl -s http://service-nginx-green | grep color
        background-color: green;
root@ping-test:/#



# push

git status
git add .
git commit -m "aula85 - Comunicação entre Namespaces. pt2"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status
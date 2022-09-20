
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# push

git status
git add .
git commit -m "aula83 - Endpoints. pt1"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status


# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# EndPoint

Sempre que criamos um service, automaticamente é criado um endpoint. O endpoint nada mais é do que o IP do pod que o service irá utilizar, por exemplo, quando criamos um service do tipo ClusterIP temos o seu IP, correto?

Agora, quando batemos nesse IP ele redireciona a conexão para o Pod através desse IP, o EndPoint.

Para listar os EndPoints criados, execute o comando:
kubectl get endpoints

~~~~bash
fernando@debian10x64:~$ kubectl get endpoints
NAME          ENDPOINTS           AGE
api-service   172.17.0.3:8080     6d1h
kubernetes    192.168.49.2:8443   23d
fernando@debian10x64:~$
~~~~



- Vamos verificar esse endpoint com mais detalhes

~~~~bash
fernando@debian10x64:~$ kubectl describe endpoints api-service
Name:         api-service
Namespace:    default
Labels:       <none>
Annotations:  endpoints.kubernetes.io/last-change-trigger-time: 2022-09-20T03:20:56Z
Subsets:
  Addresses:          172.17.0.3
  NotReadyAddresses:  <none>
  Ports:
    Name     Port  Protocol
    ----     ----  --------
    <unset>  8080  TCP

Events:  <none>
fernando@debian10x64:~$
~~~~




- Aplicando o Deployment com mais replicas:
kubectl apply -f /home/fernando/cursos/kubedev/aula83-Endpoints/deployment.yaml

- Criando 7 pods via Deployment e verificando detalhes dos endpoints:

~~~~bash
fernando@debian10x64:~$ kubectl get pods -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS       AGE
default       api-864b7ff7ff-2xwbk               1/1     Running   0              25s
default       api-864b7ff7ff-74x7r               1/1     Running   0              25s
default       api-864b7ff7ff-8gc89               1/1     Running   0              25s
default       api-864b7ff7ff-9kzbd               1/1     Running   0              25s
default       api-864b7ff7ff-fth69               1/1     Running   0              25s
default       api-864b7ff7ff-hkc2j               1/1     Running   0              25s
default       api-864b7ff7ff-wlgxs               1/1     Running   0              56m
default       ping-test                          1/1     Running   0              25m
kube-system   coredns-78fcd69978-8jj6b           1/1     Running   7 (82m ago)    23d
kube-system   etcd-minikube                      1/1     Running   7 (82m ago)    23d
kube-system   kube-apiserver-minikube            1/1     Running   7 (82m ago)    23d
kube-system   kube-controller-manager-minikube   1/1     Running   9 (81m ago)    23d
kube-system   kube-proxy-p7jhs                   1/1     Running   7 (82m ago)    23d
kube-system   kube-scheduler-minikube            1/1     Running   7 (82m ago)    23d
kube-system   storage-provisioner                1/1     Running   15 (80m ago)   23d
fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl get endpoints
NAME          ENDPOINTS                                                      AGE
api-service   172.17.0.10:8080,172.17.0.3:8080,172.17.0.5:8080 + 4 more...   6d1h
kubernetes    192.168.49.2:8443                                              23d
fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl describe endpoints api-service
Name:         api-service
Namespace:    default
Labels:       <none>
Annotations:  endpoints.kubernetes.io/last-change-trigger-time: 2022-09-20T04:17:06Z
Subsets:
  Addresses:          172.17.0.10,172.17.0.3,172.17.0.5,172.17.0.6,172.17.0.7,172.17.0.8,172.17.0.9
  NotReadyAddresses:  <none>
  Ports:
    Name     Port  Protocol
    ----     ----  --------
    <unset>  8080  TCP

Events:  <none>
fernando@debian10x64:~$
~~~~
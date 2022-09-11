
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# push
git status
git add .
git commit -m "aula78 - Deployment. pt1"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status


# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# DEPLOYMENT

 O deployment é responsável por gerenciar o ReplicaSet.






# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# Deployments
<https://kubernetes.io/docs/concepts/workloads/controllers/deployment/>
A Deployment provides declarative updates for Pods and ReplicaSets.

You describe a desired state in a Deployment, and the Deployment Controller changes the actual state to the desired state at a controlled rate. You can define Deployments to create new ReplicaSets, or to remove existing Deployments and adopt all their resources with new Deployments.

# Creating a Deployment

The following is an example of a Deployment. It creates a ReplicaSet to bring up three nginx Pods:
controllers/nginx-deployment.yaml [Copy controllers/nginx-deployment.yaml to clipboard]

~~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
~~~~





- Criando o primeiro Deployment, o manifesto é bem parecido com o do ReplicaSet.
- Intrínsecamente o Deployment tem um ReplicaSet por debaixo dos panos.
advérbio De maneira intrínseca, de modo a fazer parte da essência de algo ou de alguém: sempre me pareceu intrinsecamente feliz.De modo íntimo, particular ou próprio: comportamento intrinsecamente agressivo.De modo não convencional; estabelecido por si mesmo, fora de qualquer convenção: age.

~~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: meu-primeiro-deployment
spec:
  selector:
    matchLabels:
      app: exemplo
  template:
    metadata:
      labels:
        app: exemplo
    spec:
      containers:
      - name: meu-container-do-primeiro-deployment
        image: kubedevio/nginx-color:blue
~~~~


- Aplicando o primeiro Deployment:
kubectl apply -f /home/fernando/cursos/kubedev/aula78-Deployment/meuprimeirodeployment.yaml

~~~~bash
fernando@debian10x64:~$ kubectl apply -f /home/fernando/cursos/kubedev/aula78-Deployment/meuprimeirodeployment.yaml
deployment.apps/meu-primeiro-deployment created
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl get replicaset
NAME                                 DESIRED   CURRENT   READY   AGE
meu-primeiro-deployment-54d8cc8bdb   1         1         1       3s
fernando@debian10x64:~$ kubectl get deployment
NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
meu-primeiro-deployment   1/1     1            1           6s
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl get pods
NAME                                       READY   STATUS    RESTARTS   AGE
meu-primeiro-deployment-54d8cc8bdb-2g2js   1/1     Running   0          13s
fernando@debian10x64:~$
~~~~


- Verificando os ReplicaSet, o deployment gerou 1 ReplicaSet com o mesmo nome do Deployment:

~~~~bash
fernando@debian10x64:~$ kubectl get replicaset
NAME                                 DESIRED   CURRENT   READY   AGE
meu-primeiro-deployment-54d8cc8bdb   1         1         1       3s
~~~~





- Verificando detalhes sobre o Deployment:

~~~~bash
fernando@debian10x64:~$ kubectl describe deployment meu-primeiro-deployment
Name:                   meu-primeiro-deployment
Namespace:              default
CreationTimestamp:      Sun, 11 Sep 2022 13:27:13 -0300
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=exemplo
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=exemplo
  Containers:
   meu-container-do-primeiro-deployment:
    Image:        kubedevio/nginx-color:blue
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   meu-primeiro-deployment-54d8cc8bdb (1/1 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  4m26s  deployment-controller  Scaled up replica set meu-primeiro-deployment-54d8cc8bdb to 1
fernando@debian10x64:~$
~~~~


o comando describe traz detalhes como número de replicas, estratégia de update, eventos, detalhes,  entre outros detalhes


- Validando o Deployment:

~~~~bash
fernando@debian10x64:~$ kubectl get pods
NAME                                       READY   STATUS    RESTARTS   AGE
meu-primeiro-deployment-54d8cc8bdb-2g2js   1/1     Running   0          13s
fernando@debian10x64:~$
~~~~


- Efetuando port-forward e testando acesso a página Blue:

kubectl port-forward meu-primeiro-deployment-54d8cc8bdb-2g2js 8080:80

fernando@debian10x64:~$ curl localhost:8080
<!DOCTYPE html>
<html>
  <head>
    <title>Welcome to nginx!</title>
    <style>
      body {
        width: 35em;
        margin: 0 auto;
        background-color: blue;
        font-family: Tahoma, Verdana, Arial, sans-serif;
      }
    </style>
  </head>
  <body>
    <h1>Welcome to nginx!</h1>
    <p>
      If you see this page, the nginx web server is successfully installed and
      working. Further configuration is required.
    </p>

    <p>
      For online documentation and support please refer to
      <a href="http://nginx.org/">nginx.org</a>.<br />
      Commercial support is available at
      <a href="http://nginx.com/">nginx.com</a>.
    </p>

    <p><em>Thank you for using nginx.</em></p>
  </body>
</html>
fernando@debian10x64:~$




# Testando a resiliência

- Deletando o Pod, o comportamento esperado é que ele crie um Pod na sequência:
kubectl delete pod meu-primeiro-deployment-54d8cc8bdb-2g2js

~~~~bash
fernando@debian10x64:~$ kubectl delete pod meu-primeiro-deployment-54d8cc8bdb-2g2js
pod "meu-primeiro-deployment-54d8cc8bdb-2g2js" deleted
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl get pods
NAME                                       READY   STATUS    RESTARTS   AGE
meu-primeiro-deployment-54d8cc8bdb-nfbqd   1/1     Running   0          6s
fernando@debian10x64:~$
~~~~



# Testando escalabilidade

- Escalando 7 replicas no Deployment:
kubectl scale deployment meu-primeiro-deployment --replicas=7

~~~~bash
fernando@debian10x64:~$ kubectl scale deployment meu-primeiro-deployment --replicas=7
deployment.apps/meu-primeiro-deployment scaled
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl get pods
NAME                                       READY   STATUS              RESTARTS   AGE
meu-primeiro-deployment-54d8cc8bdb-46mkc   0/1     ContainerCreating   0          3s
meu-primeiro-deployment-54d8cc8bdb-8nb9w   0/1     ContainerCreating   0          3s
meu-primeiro-deployment-54d8cc8bdb-b587k   0/1     ContainerCreating   0          3s
meu-primeiro-deployment-54d8cc8bdb-fh62k   0/1     ContainerCreating   0          3s
meu-primeiro-deployment-54d8cc8bdb-hwj5t   0/1     ContainerCreating   0          3s
meu-primeiro-deployment-54d8cc8bdb-ndr4r   0/1     ContainerCreating   0          3s
meu-primeiro-deployment-54d8cc8bdb-nfbqd   1/1     Running             0          2m4s
fernando@debian10x64:~$
~~~~



- Comando com o -o wide traz mais detalhes sobre os Pods:

~~~~bash
fernando@debian10x64:~$ kubectl get pods -o wide
NAME                                       READY   STATUS    RESTARTS   AGE    IP           NODE       NOMINATED NODE   READINESS GATES
meu-primeiro-deployment-54d8cc8bdb-46mkc   1/1     Running   0          4m3s   172.17.0.3   minikube   <none>           <none>
meu-primeiro-deployment-54d8cc8bdb-8nb9w   1/1     Running   0          4m3s   172.17.0.7   minikube   <none>           <none>
meu-primeiro-deployment-54d8cc8bdb-b587k   1/1     Running   0          4m3s   172.17.0.9   minikube   <none>           <none>
meu-primeiro-deployment-54d8cc8bdb-fh62k   1/1     Running   0          4m3s   172.17.0.5   minikube   <none>           <none>
meu-primeiro-deployment-54d8cc8bdb-hwj5t   1/1     Running   0          4m3s   172.17.0.8   minikube   <none>           <none>
meu-primeiro-deployment-54d8cc8bdb-ndr4r   1/1     Running   0          4m3s   172.17.0.6   minikube   <none>           <none>
meu-primeiro-deployment-54d8cc8bdb-nfbqd   1/1     Running   0          6m4s   172.17.0.4   minikube   <none>           <none>
fernando@debian10x64:~$
~~~~




- Especificando as replicas no manifesto do Deployment:

~~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: meu-primeiro-deployment
spec:
  replicas: 11
  selector:
    matchLabels:
      app: exemplo
  template:
    metadata:
      labels:
        app: exemplo
    spec:
      containers:
      - name: meu-container-do-primeiro-deployment
        image: kubedevio/nginx-color:blue
~~~~


- Aplicando:
kubectl apply -f /home/fernando/cursos/kubedev/aula78-Deployment/meuprimeirodeployment.yaml

~~~~bash
fernando@debian10x64:~$ kubectl apply -f /home/fernando/cursos/kubedev/aula78-Deployment/meuprimeirodeployment.yaml
deployment.apps/meu-primeiro-deployment configured
fernando@debian10x64:~$ kubectl get pods
NAME                                       READY   STATUS              RESTARTS   AGE
meu-primeiro-deployment-54d8cc8bdb-46mkc   1/1     Running             0          5m54s
meu-primeiro-deployment-54d8cc8bdb-8nb9w   1/1     Running             0          5m54s
meu-primeiro-deployment-54d8cc8bdb-9x797   0/1     ContainerCreating   0          3s
meu-primeiro-deployment-54d8cc8bdb-b587k   1/1     Running             0          5m54s
meu-primeiro-deployment-54d8cc8bdb-fh62k   1/1     Running             0          5m54s
meu-primeiro-deployment-54d8cc8bdb-hwj5t   1/1     Running             0          5m54s
meu-primeiro-deployment-54d8cc8bdb-j5v9h   0/1     ContainerCreating   0          3s
meu-primeiro-deployment-54d8cc8bdb-l4zg2   0/1     ContainerCreating   0          3s
meu-primeiro-deployment-54d8cc8bdb-ndr4r   1/1     Running             0          5m54s
meu-primeiro-deployment-54d8cc8bdb-nfbqd   1/1     Running             0          7m55s
meu-primeiro-deployment-54d8cc8bdb-z4xsd   0/1     ContainerCreating   0          3s
fernando@debian10x64:~$
~~~~


criando mais replicas, para ficar com 11 replicas






- Ajustando a imagem do Container do Deployment para green:

~~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: meu-primeiro-deployment
spec:
  replicas: 11
  selector:
    matchLabels:
      app: exemplo
  template:
    metadata:
      labels:
        app: exemplo
    spec:
      containers:
      - name: meu-container-do-primeiro-deployment
        image: kubedevio/nginx-color:green
~~~~



- Aplicando:
kubectl apply -f /home/fernando/cursos/kubedev/aula78-Deployment/meuprimeirodeployment.yaml

neste caso ele vai criar os novos Pods atualizados e vai matando os antigos com a imagem antiga do NGINX

~~~~bash
fernando@debian10x64:~$ kubectl apply -f /home/fernando/cursos/kubedev/aula78-Deployment/meuprimeirodeployment.yaml
deployment.apps/meu-primeiro-deployment configured
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl get pods
NAME                                       READY   STATUS              RESTARTS   AGE
meu-primeiro-deployment-54d8cc8bdb-46mkc   1/1     Running             0          8m14s
meu-primeiro-deployment-54d8cc8bdb-8nb9w   1/1     Running             0          8m14s
meu-primeiro-deployment-54d8cc8bdb-b587k   1/1     Running             0          8m14s
meu-primeiro-deployment-54d8cc8bdb-fh62k   1/1     Running             0          8m14s
meu-primeiro-deployment-54d8cc8bdb-hwj5t   1/1     Running             0          8m14s
meu-primeiro-deployment-54d8cc8bdb-j5v9h   1/1     Running             0          2m23s
meu-primeiro-deployment-54d8cc8bdb-l4zg2   1/1     Terminating         0          2m23s
meu-primeiro-deployment-54d8cc8bdb-ndr4r   1/1     Running             0          8m14s
meu-primeiro-deployment-54d8cc8bdb-nfbqd   1/1     Running             0          10m
meu-primeiro-deployment-54d8cc8bdb-z4xsd   1/1     Running             0          2m23s
meu-primeiro-deployment-6cdb5444c-27ztp    0/1     ContainerCreating   0          2s
meu-primeiro-deployment-6cdb5444c-4tl82    0/1     ContainerCreating   0          2s
meu-primeiro-deployment-6cdb5444c-dq9kd    0/1     ContainerCreating   0          2s
meu-primeiro-deployment-6cdb5444c-j7vxb    0/1     ContainerCreating   0          2s
meu-primeiro-deployment-6cdb5444c-wzmxp    0/1     ContainerCreating   0          2s
fernando@debian10x64:~$

DEPOIS DE ALGUM TEMPO, TODOS OS PODS ESTÃO ATUALIZADO:


fernando@debian10x64:~$ kubectl get pods
NAME                                      READY   STATUS    RESTARTS   AGE
meu-primeiro-deployment-6cdb5444c-27ztp   1/1     Running   0          43s
meu-primeiro-deployment-6cdb5444c-4tl82   1/1     Running   0          43s
meu-primeiro-deployment-6cdb5444c-7z28s   1/1     Running   0          35s
meu-primeiro-deployment-6cdb5444c-cr8dw   1/1     Running   0          35s
meu-primeiro-deployment-6cdb5444c-dq9kd   1/1     Running   0          43s
meu-primeiro-deployment-6cdb5444c-fr7w6   1/1     Running   0          35s
meu-primeiro-deployment-6cdb5444c-j7vxb   1/1     Running   0          43s
meu-primeiro-deployment-6cdb5444c-nm2n7   1/1     Running   0          35s
meu-primeiro-deployment-6cdb5444c-wzmxp   1/1     Running   0          43s
meu-primeiro-deployment-6cdb5444c-zksb2   1/1     Running   0          35s
meu-primeiro-deployment-6cdb5444c-zpqn9   1/1     Running   0          20s
fernando@debian10x64:~$
~~~~




- Efetuando port-forward e testando acesso a página green:

kubectl port-forward meu-primeiro-deployment-6cdb5444c-27ztp 8080:80


^Cfernando@debian10x64:~$ kubectl port-forward meu-primeiro-deployment-6cdb5444c-27ztp 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80


fernando@debian10x64:~$
fernando@debian10x64:~$ curl localhost:8080
<!DOCTYPE html>
<html>
  <head>
    <title>Welcome to nginx!</title>
    <style>
      body {
        width: 35em;
        margin: 0 auto;
        background-color: green;
        font-family: Tahoma, Verdana, Arial, sans-serif;
      }
    </style>
  </head>
  <body>
    <h1>Welcome to nginx!</h1>
    <p>
      If you see this page, the nginx web server is successfully installed and
      working. Further configuration is required.
    </p>

    <p>
      For online documentation and support please refer to
      <a href="http://nginx.org/">nginx.org</a>.<br />
      Commercial support is available at
      <a href="http://nginx.com/">nginx.com</a>.
    </p>

    <p><em>Thank you for using nginx.</em></p>
  </body>
</html>
fernando@debian10x64:~$



- Acessando a página green corretamente.





- Verificando os ReplicaSet, temos 2 replicaset, 1 mais antigo e um novo com o número de 11 replicas, conforme o nosso Deployment atual:

~~~~bash
fernando@debian10x64:~$ kubectl get replicaset
NAME                                 DESIRED   CURRENT   READY   AGE
meu-primeiro-deployment-54d8cc8bdb   0         0         0       25m
meu-primeiro-deployment-6cdb5444c    11        11        11      2m31s
fernando@debian10x64:~$
~~~~



- O ReplicaSet vazio usa a imagem antiga blue, já o ReplicaSet com várias réplicas, usa a imagem green, que é a atual:

~~~~bash
fernando@debian10x64:~$ kubectl describe replicaset meu-primeiro-deployment-54d8cc8bdb | grep Image
    Image:        kubedevio/nginx-color:blue
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl describe replicaset meu-primeiro-deployment-6cdb5444c | grep Image
    Image:        kubedevio/nginx-color:green
fernando@debian10x64:~$
fernando@debian10x64:~$
~~~~




- O Deployment tem esse histórico dos ReplicaSet, para controlar as versões.
- É possível realizar rollback, por exemplo, aproveitando este histórico.
- No nosso caso temos 2 versões da aplicação, 1 blue e 1 green.

kubectl rollout history deployment meu-primeiro-deployment

~~~~bash
fernando@debian10x64:~$ kubectl rollout history deployment meu-primeiro-deployment
deployment.apps/meu-primeiro-deployment
REVISION  CHANGE-CAUSE
1         <none>
2         <none>

fernando@debian10x64:~$
~~~~



- Efetuando rollback:
kubectl rollout undo deployment meu-primeiro-deployment

- O Kubernetes começa a matar os pods antigos e criar novos Pods, com a versão antiga do ReplicaSet:

~~~~bash
fernando@debian10x64:~$ kubectl get pods
NAME                                       READY   STATUS              RESTARTS   AGE
meu-primeiro-deployment-54d8cc8bdb-8rg66   1/1     Running             0          10s
meu-primeiro-deployment-54d8cc8bdb-ccq52   0/1     ContainerCreating   0          4s
meu-primeiro-deployment-54d8cc8bdb-hfqf8   0/1     Pending             0          5s
meu-primeiro-deployment-54d8cc8bdb-hpjwk   1/1     Running             0          10s
meu-primeiro-deployment-54d8cc8bdb-nhrpg   1/1     Running             0          7s
meu-primeiro-deployment-54d8cc8bdb-rbxrh   1/1     Running             0          10s
meu-primeiro-deployment-54d8cc8bdb-w9pgm   1/1     Running             0          10s
meu-primeiro-deployment-54d8cc8bdb-wc2wl   0/1     Pending             0          6s
meu-primeiro-deployment-54d8cc8bdb-z77v2   0/1     Pending             0          4s
meu-primeiro-deployment-54d8cc8bdb-ztksp   1/1     Running             0          10s
meu-primeiro-deployment-6cdb5444c-27ztp    1/1     Running             0          19m
meu-primeiro-deployment-6cdb5444c-dq9kd    1/1     Terminating         0          19m
meu-primeiro-deployment-6cdb5444c-fr7w6    1/1     Running             0          19m
meu-primeiro-deployment-6cdb5444c-j7vxb    1/1     Terminating         0          19m
meu-primeiro-deployment-6cdb5444c-wzmxp    1/1     Terminating         0          19m
meu-primeiro-deployment-6cdb5444c-zpqn9    1/1     Running             0          19m
fernando@debian10x64:~$
~~~~


- Verificando os ReplicaSet, o replicaset antigo agora assumiu o controle dos Pods, aproveitando o antigo mesmo:

~~~~bash
fernando@debian10x64:~$ kubectl get replicaset
NAME                                 DESIRED   CURRENT   READY   AGE
meu-primeiro-deployment-54d8cc8bdb   11        11        11      42m
meu-primeiro-deployment-6cdb5444c    0         0         0       19m
fernando@debian10x64:~$
~~~~




- Efetuando validação.
- Pegando um novo Pod do rollback e fazendo port-forward.

kubectl port-forward meu-primeiro-deployment-54d8cc8bdb-8rg66 8080:80

~~~~bash
fernando@debian10x64:~$ kubectl get pods
NAME                                       READY   STATUS    RESTARTS   AGE
meu-primeiro-deployment-54d8cc8bdb-8rg66   1/1     Running   0          2m21s
meu-primeiro-deployment-54d8cc8bdb-ccq52   1/1     Running   0          2m15s
meu-primeiro-deployment-54d8cc8bdb-drzcp   1/1     Running   0          2m11s
meu-primeiro-deployment-54d8cc8bdb-hfqf8   1/1     Running   0          2m16s
meu-primeiro-deployment-54d8cc8bdb-hpjwk   1/1     Running   0          2m21s
meu-primeiro-deployment-54d8cc8bdb-nhrpg   1/1     Running   0          2m18s
meu-primeiro-deployment-54d8cc8bdb-rbxrh   1/1     Running   0          2m21s
meu-primeiro-deployment-54d8cc8bdb-w9pgm   1/1     Running   0          2m21s
meu-primeiro-deployment-54d8cc8bdb-wc2wl   1/1     Running   0          2m17s
meu-primeiro-deployment-54d8cc8bdb-z77v2   1/1     Running   0          2m15s
meu-primeiro-deployment-54d8cc8bdb-ztksp   1/1     Running   0          2m21s
fernando@debian10x64:~$

fernando@debian10x64:~$ kubectl port-forward meu-primeiro-deployment-54d8cc8bdb-8rg66 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
~~~~


- Voltou para a imagem Blue:

fernando@debian10x64:~$ curl localhost:8080
<!DOCTYPE html>
<html>
  <head>
    <title>Welcome to nginx!</title>
    <style>
      body {
        width: 35em;
        margin: 0 auto;
        background-color: blue;
        font-family: Tahoma, Verdana, Arial, sans-serif;
      }
    </style>
  </head>
  <body>
    <h1>Welcome to nginx!</h1>
    <p>
      If you see this page, the nginx web server is successfully installed and
      working. Further configuration is required.
    </p>

    <p>
      For online documentation and support please refer to
      <a href="http://nginx.org/">nginx.org</a>.<br />
      Commercial support is available at
      <a href="http://nginx.com/">nginx.com</a>.
    </p>

    <p><em>Thank you for using nginx.</em></p>
  </body>
</html>
fernando@debian10x64:~$









- Setando a imagem manualmente no Deployment, via linha de comando:
kubectl set image deployment <nome-do-deployment> <nome-do-container>=<tag-nome-da-imagem-versão>
kubectl set image deployment meu-primeiro-deployment meu-container-do-primeiro-deployment=kubedevio/nginx-color:green


~~~~bash
fernando@debian10x64:~$ kubectl set image deployment meu-primeiro-deployment meu-container-do-primeiro-deployment=kubedevio/nginx-color:green
deployment.apps/meu-primeiro-deployment image updated
fernando@debian10x64:~$ ku^C
fernando@debian10x64:~$ ^C
fernando@debian10x64:~$ ^C
fernando@debian10x64:~$ ^C


verificando via "kubectl rollout history", o Kubernetes gerou nova versão, com base no rollback:

fernando@debian10x64:~$ kubectl rollout history deployment meu-primeiro-deployment
deployment.apps/meu-primeiro-deployment
REVISION  CHANGE-CAUSE
3         <none>
4         <none>

de forma dinâmica, o Kubernetes entendeu que precisa voltar para o ReplicaSet que carrega a imagem green:
começou a terminar os pods antigos e criar novos
e voltou para o replicaset mais novo, que carrega a image green

fernando@debian10x64:~$ kubectl get pods
NAME                                       READY   STATUS              RESTARTS   AGE
meu-primeiro-deployment-54d8cc8bdb-hfqf8   1/1     Terminating         0          10m
meu-primeiro-deployment-54d8cc8bdb-rbxrh   1/1     Terminating         0          10m
meu-primeiro-deployment-54d8cc8bdb-wc2wl   1/1     Terminating         0          10m
meu-primeiro-deployment-54d8cc8bdb-z77v2   1/1     Running             0          10m
meu-primeiro-deployment-6cdb5444c-8fnvp    1/1     Running             0          8s
meu-primeiro-deployment-6cdb5444c-8h5lz    1/1     Running             0          13s
meu-primeiro-deployment-6cdb5444c-97xg5    1/1     Running             0          7s
meu-primeiro-deployment-6cdb5444c-cnn28    1/1     Running             0          9s
meu-primeiro-deployment-6cdb5444c-hm9c9    0/1     ContainerCreating   0          9s
meu-primeiro-deployment-6cdb5444c-mpt5t    0/1     ContainerCreating   0          8s
meu-primeiro-deployment-6cdb5444c-n7mhm    0/1     Pending             0          2s
meu-primeiro-deployment-6cdb5444c-rlpjl    1/1     Running             0          13s
meu-primeiro-deployment-6cdb5444c-v4r87    1/1     Running             0          13s
meu-primeiro-deployment-6cdb5444c-vfk9c    1/1     Running             0          13s
meu-primeiro-deployment-6cdb5444c-wh7jj    1/1     Running             0          13s
fernando@debian10x64:~$


fernando@debian10x64:~$ kubectl get replicaset
NAME                                 DESIRED   CURRENT   READY   AGE
meu-primeiro-deployment-54d8cc8bdb   0         0         0       54m
meu-primeiro-deployment-6cdb5444c    11        11        11      32m
fernando@debian10x64:~$
~~~~



Na próxima aula veremos sobre Services.
Pois o Service é mais dinamico para expor os nossos Pods, para não precisarmos usar o port-forwarding.
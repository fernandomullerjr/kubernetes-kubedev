
# push
git add .
git commit -m "aula77 - ReplicaSet"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push


# ReplicaSet

Garante que as replicas dos Pods sejam executadas.

- Exemplo de ReplicaSet:

~~~~yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: frontend
  labels:
    app: guestbook
    tier: frontend
spec:
  # modify replicas according to your case
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: gcr.io/google_samples/gb-frontend:v3
~~~~



- Validando o Kind e API Version:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl api-resources | grep replica
replicationcontrollers            rc           v1                                     true         ReplicationController
replicasets                       rs           apps/v1                                true         ReplicaSet
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
~~~~



- No "Template" iremos especificar metadados do Pod
- Iremos usar a imagem do NGINX Blue.
- Arquivo do ReplicaSet editado:

~~~~yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: meuprimeiroreplicaset
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
      - name: meucontainer
        image: kubedevio/nginx-color:blue
~~~~


- Efetuando o apply:
kubectl apply -f /home/fernando/cursos/kubedev/aula77-ReplicaSet/meureplicaset.yaml

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl apply -f /home/fernando/cursos/kubedev/aula77-ReplicaSet/meureplicaset.yaml
replicaset.apps/meuprimeiroreplicaset created
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl get replicaset
NAME                    DESIRED   CURRENT   READY   AGE
meuprimeiroreplicaset   1         1         1       4s
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl get pods
NAME                          READY   STATUS    RESTARTS      AGE
meuprimeiropod                1/1     Running   2 (28m ago)   45h
meuprimeiroreplicaset-xpw44   1/1     Running   0             3m11s
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
~~~~

- OBSERVAÇÃO:
Quando não são especificas as quantidades de replicas, o Kubernetes cria 1 replica por padrão.






- Efetuando Port-forward para o pod:
kubectl port-forward meuprimeiroreplicaset-xpw44 8080:80

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl port-forward meuprimeiroreplicaset-xpw44 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
~~~~


fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ curl localhost:8080
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
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$




# push
git add .
git commit -m "aula77 - ReplicaSet"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push




fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl get replicaset
NAME                    DESIRED   CURRENT   READY   AGE
meuprimeiroreplicaset   1         1         1       16m
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$



- Verificando os detalhes de um ReplicaSet:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl describe replicaset meuprimeiroreplicaset
Name:         meuprimeiroreplicaset
Namespace:    default
Selector:     app=exemplo
Labels:       <none>
Annotations:  <none>
Replicas:     1 current / 1 desired
Pods Status:  1 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app=exemplo
  Containers:
   meucontainer:
    Image:        kubedevio/nginx-color:blue
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:
  Type    Reason            Age   From                   Message
  ----    ------            ----  ----                   -------
  Normal  SuccessfulCreate  17m   replicaset-controller  Created pod: meuprimeiroreplicaset-xpw44
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
~~~~




- Testando o delete do Pod e verificando se o ReplicaSet vai recriar o Pod:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl get pods
NAME                          READY   STATUS    RESTARTS      AGE
meuprimeiropod                1/1     Running   2 (43m ago)   46h
meuprimeiroreplicaset-xpw44   1/1     Running   0             18m
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl delete pod meuprimeiroreplicaset-xpw44
pod "meuprimeiroreplicaset-xpw44" deleted
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl get pods
NAME                          READY   STATUS    RESTARTS      AGE
meuprimeiropod                1/1     Running   2 (43m ago)   46h
meuprimeiroreplicaset-44kqf   1/1     Running   0             3s
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
~~~~



- Efetuando describe no Pod, é possível verificar qual ReplicaSet está controlando ele:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl describe pod meuprimeiroreplicaset-44kqf
Name:         meuprimeiroreplicaset-44kqf
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Mon, 29 Aug 2022 22:40:51 -0300
Labels:       app=exemplo
Annotations:  <none>
Status:       Running
IP:           172.17.0.4
IPs:
  IP:           172.17.0.4
Controlled By:  ReplicaSet/meuprimeiroreplicaset
Containers:
  meucontainer:
    Container ID:   docker://6bfdbc2dc9b6d3d99bd8acf9d6ad5b934fa0cc63e90c3adfd99e326bf3fc2c5f
    Image:          kubedevio/nginx-color:blue
    Image ID:       docker-pullable://kubedevio/nginx-color@sha256:fde5b9a15847ff0156721b6ec6d68a9af8ad9f081d2192421605bb9b41297dad
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Mon, 29 Aug 2022 22:40:53 -0300
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-fp59c (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-fp59c:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  57s   default-scheduler  Successfully assigned default/meuprimeiroreplicaset-44kqf to minikube
  Normal  Pulled     55s   kubelet            Container image "kubedevio/nginx-color:blue" already present on machine
  Normal  Created    55s   kubelet            Created container meucontainer
  Normal  Started    55s   kubelet            Started container meucontainer
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
~~~~




# Replicas
- Aumentando o número de replicas:
kubectl scale replicaset meuprimeiroreplicaset --replicas=6

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl scale replicaset meuprimeiroreplicaset --replicas=6
replicaset.apps/meuprimeiroreplicaset scaled
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl get replicaset
NAME                    DESIRED   CURRENT   READY   AGE
meuprimeiroreplicaset   6         6         1       22m
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl get pods
NAME                          READY   STATUS              RESTARTS      AGE
meuprimeiropod                1/1     Running             2 (47m ago)   46h
meuprimeiroreplicaset-44kqf   1/1     Running             0             4m20s
meuprimeiroreplicaset-5kb9r   0/1     ContainerCreating   0             5s
meuprimeiroreplicaset-cqsp2   0/1     ContainerCreating   0             5s
meuprimeiroreplicaset-dlq6j   0/1     ContainerCreating   0             5s
meuprimeiroreplicaset-hrtwg   0/1     ContainerCreating   0             5s
meuprimeiroreplicaset-mkbqq   0/1     ContainerCreating   0             5s
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$


fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl get pods
NAME                          READY   STATUS    RESTARTS      AGE
meuprimeiropod                1/1     Running   2 (47m ago)   46h
meuprimeiroreplicaset-44kqf   1/1     Running   0             4m35s
meuprimeiroreplicaset-5kb9r   1/1     Running   0             20s
meuprimeiroreplicaset-cqsp2   1/1     Running   0             20s
meuprimeiroreplicaset-dlq6j   1/1     Running   0             20s
meuprimeiroreplicaset-hrtwg   1/1     Running   0             20s
meuprimeiroreplicaset-mkbqq   1/1     Running   0             20s
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
~~~~



- Especificando a quantidade de replicas no manifesto:

~~~~yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: meu-replica-set-com-replicas-especificadas
spec:
  replicas: 7
  selector:
    matchLabels:
      app: exemplo
  template:
    metadata:
      labels:
        app: exemplo
    spec:
      containers:
      - name: meucontainerreplicado
        image: kubedevio/nginx-color:blue
~~~~


- Aplicando:
kubectl apply -f /home/fernando/cursos/kubedev/aula77-ReplicaSet/meu-replica-set-com-replicas-especificadas.yaml

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl get pods
NAME                                               READY   STATUS              RESTARTS      AGE
meu-replica-set-com-replicas-especificadas-76qfk   0/1     ContainerCreating   0             14s
meu-replica-set-com-replicas-especificadas-8gckx   0/1     ContainerCreating   0             14s
meu-replica-set-com-replicas-especificadas-mcdzs   1/1     Running             0             14s
meu-replica-set-com-replicas-especificadas-mpxhj   0/1     ContainerCreating   0             14s
meu-replica-set-com-replicas-especificadas-p2vvm   0/1     ContainerCreating   0             14s
meu-replica-set-com-replicas-especificadas-qxswh   0/1     ContainerCreating   0             14s
meu-replica-set-com-replicas-especificadas-rs2qh   0/1     ContainerCreating   0             14s
meuprimeiropod                                     1/1     Running             2 (51m ago)   46h
meuprimeiroreplicaset-44kqf                        1/1     Running             0             8m3s
meuprimeiroreplicaset-5kb9r                        1/1     Running             0             3m48s
meuprimeiroreplicaset-cqsp2                        1/1     Running             0             3m48s
meuprimeiroreplicaset-dlq6j                        1/1     Running             0             3m48s
meuprimeiroreplicaset-ff7rh                        1/1     Running             0             53s
meuprimeiroreplicaset-hrtwg                        1/1     Running             0             3m48s
meuprimeiroreplicaset-mkbqq                        1/1     Running             0             3m48s
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
~~~~






- Editando o NGINX de "blue" para "green" no ReplicaSet inicial chamado "meuprimeiroreplicaset":

~~~~yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: meuprimeiroreplicaset
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
      - name: meucontainer
        image: kubedevio/nginx-color:green
~~~~

- Efetuando apply:
kubectl apply -f /home/fernando/cursos/kubedev/aula77-ReplicaSet/meureplicaset.yaml


- Mesmo após atualizar o ReplicaSet, os Pods não são atualizados automaticamente:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl describe pod meuprimeiroreplicaset-44kqf | grep nginx-color
    Image:          kubedevio/nginx-color:blue
    Image ID:       docker-pullable://kubedevio/nginx-color@sha256:fde5b9a15847ff0156721b6ec6d68a9af8ad9f081d2192421605bb9b41297dad
  Normal  Pulled     15m   kubelet            Container image "kubedevio/nginx-color:blue" already present on machine
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
~~~~


- Foi necessário deletar o Pod e deixar o ReplicaSet criar ele novamente, para que atualizasse a imagem:

~~~~bash

fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl delete pod meuprimeiroreplicaset-44kqf

fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl get pods
NAME                                               READY   STATUS    RESTARTS   AGE
meu-replica-set-com-replicas-especificadas-76qfk   1/1     Running   0          8m34s
meu-replica-set-com-replicas-especificadas-8gckx   1/1     Running   0          8m34s
meu-replica-set-com-replicas-especificadas-mcdzs   1/1     Running   0          8m34s
meu-replica-set-com-replicas-especificadas-mpxhj   1/1     Running   0          8m34s
meu-replica-set-com-replicas-especificadas-p2vvm   1/1     Running   0          8m34s
meu-replica-set-com-replicas-especificadas-qxswh   1/1     Running   0          8m34s
meu-replica-set-com-replicas-especificadas-rs2qh   1/1     Running   0          8m34s
meuprimeiroreplicaset-5h4t6                        1/1     Running   0          6s
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$

fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl describe pod meuprimeiroreplicaset-5h4t6 | grep nginx-color
    Image:          kubedevio/nginx-color:green
    Image ID:       docker-pullable://kubedevio/nginx-color@sha256:338e528f98a5ae1225f6f70b6c3a12471246a68e153554423e5ad16399775dc3
  Normal  Pulled     16s   kubelet            Container image "kubedevio/nginx-color:green" already present on machine
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$

kubectl port-forward meuprimeiroreplicaset-5h4t6 8080:80

fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ curl -s localhost:8080 | grep color | tail -n 1
        background-color: green;
fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$

~~~~



- Para atualizar cada Pod, teria que deletar cada Pod.
- O ReplicaSet não consegue atualizar dinamicamente!

# push
git add .
git commit -m "aula77 - ReplicaSet - final"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push

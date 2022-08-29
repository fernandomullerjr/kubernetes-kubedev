

# Labels

As labels são importantes para o gerenciamento do cluster, pois com elas é possível buscar ou selecionar recursos em seu cluster, fazendo com que você consiga organizar em pequenas categorias, facilitando assim a sua busca e organizando seus pods e seus recursos do cluster. As labels não são recursos do API server, elas são armazenadas no metadata em formato chave-valor.

Labels

Labels are key-value pairs which are attached to pods, replication controller and services. They are used as identifying attributes for objects such as pods and replication controller. They can be added to an object at creation time and can be added or modified at the run time.



- Iremos usar o meuprimeiropod como base para entender sobre Labels.
- Criar arquivo chamado "meupodazul.yaml":
/home/fernando/cursos/kubedev/aula76-Labels-e-Selectors/meupodazul.yaml

~~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: meupodazul
  labels:
    app: nginx
    versao: azul
spec:
  containers:
  - name: meucontainer
    image: kubedevio/nginx-color:blue
~~~~



- Criar também um arquivo chamado "meupodverde.yaml":
/home/fernando/cursos/kubedev/aula76-Labels-e-Selectors/meupodverde.yaml

~~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: meupodverde
  labels:
    app: nginx
    versao: verde
spec:
  containers:
  - name: meucontainer
    image: kubedevio/nginx-color:green
~~~~



- Efetuando apply dos Pods
kubectl apply -f /home/fernando/cursos/kubedev/aula76-Labels-e-Selectors/meupodazul.yaml
kubectl apply -f /home/fernando/cursos/kubedev/aula76-Labels-e-Selectors/meupodverde.yaml

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$ kubectl get pods
NAME             READY   STATUS    RESTARTS     AGE
meupodazul       1/1     Running   0            14s
meupodverde      1/1     Running   0            12s
meuprimeiropod   1/1     Running   1 (3m ago)   21h
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$ date
Sun 28 Aug 2022 10:06:53 PM -03
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$
~~~~


- Verificando detalhes dos Pods, validando os Labels:
kubectl describe pod meupodazul
kubectl describe pod meupodverde

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$ kubectl describe pod meupodazul
Name:         meupodazul
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Sun, 28 Aug 2022 22:06:39 -0300
Labels:       app=nginx
              versao=azul
Annotations:  <none>
Status:       Running
IP:           172.17.0.4
IPs:
  IP:  172.17.0.4
Containers:
  meucontainer:
    Container ID:   docker://f1c51897d830942780870c0c16ca1d3e235f829e78d78470442e3867e1d3b42d
    Image:          kubedevio/nginx-color:blue
    Image ID:       docker-pullable://kubedevio/nginx-color@sha256:fde5b9a15847ff0156721b6ec6d68a9af8ad9f081d2192421605bb9b41297dad
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Sun, 28 Aug 2022 22:06:41 -0300
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-qw8nl (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-qw8nl:
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
  Normal  Scheduled  70s   default-scheduler  Successfully assigned default/meupodazul to minikube
  Normal  Pulled     68s   kubelet            Container image "kubedevio/nginx-color:blue" already present on machine
  Normal  Created    68s   kubelet            Created container meucontainer
  Normal  Started    68s   kubelet            Started container meucontainer
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$
~~~~



- Verificando um Pod especifico com base na sua tag:
kubectl get pods -l versao=verde
kubectl get pods -l versao=azul
kubectl get pods -l app=nginx

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$ kubectl get pods -l versao=verde
NAME          READY   STATUS    RESTARTS   AGE
meupodverde   1/1     Running   0          2m7s
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$ kubectl get pods -l versao=azul
NAME         READY   STATUS    RESTARTS   AGE
meupodazul   1/1     Running   0          10m
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$ kubectl get pods -l app=nginx
NAME          READY   STATUS    RESTARTS   AGE
meupodazul    1/1     Running   0          10m
meupodverde   1/1     Running   0          10m
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$
~~~~



- Também é possível usar os Labels na hora de deletar:
kubectl delete pod -l versao=azul

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$ kubectl get pods -l app=nginx
NAME          READY   STATUS    RESTARTS   AGE
meupodazul    1/1     Running   0          18m
meupodverde   1/1     Running   0          18m
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$ kubectl delete pod -l versao=azul
pod "meupodazul" deleted
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$ kubectl get pods -l app=nginx
NAME          READY   STATUS    RESTARTS   AGE
meupodverde   1/1     Running   0          18m
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$ date
Sun 28 Aug 2022 10:24:58 PM -03
fernando@debian10x64:~/cursos/kubedev/aula76-Labels-e-Selectors$
~~~~




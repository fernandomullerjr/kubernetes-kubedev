
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

fernando@debian10x64:~/cursos/kubedev/aula77-ReplicaSet$ kubectl port-forward meuprimeiroreplicaset-xpw44 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80


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

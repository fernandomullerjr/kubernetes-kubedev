
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# push

git status
git add .
git commit -m "aula81 - Service - LoadBalancer. pt1"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status


# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# Service - LoadBalancer

- O Service do tipo LoadBalancer


# Optar por um Load Balancer
<https://www.ovhcloud.com/pt/public-cloud/kubernetes/kubernetes-load-balancer/>
Consiste em declarar um serviço enquanto Load Balancer para o seu cluster. Assim, estará exposto ao tráfego externo. Este método requer a utilização da solução de load balancing de um fornecedor cloud, como o nosso Load Balancer, que irá aprovisionar o serviço para o seu cluster, atribuindo-lhe automaticamente o seu NodePort.

Se dispõe de um ambiente de produção, o Load Balancer é a solução que recomendamos. No entanto, é necessário ter em conta dois aspetos importantes:

    cada serviço que define e implementa como Load Balancer dispõe do seu próprio endereço IP;
    a utilização do Load Balancer da OVHcloud está reservada aos utilizadores do serviço Managed Kubernetes.

Assim, funciona como um filtro entre o tráfego externo de entrada e o seu cluster Kubernetes.





- Iremos aproveitar os manifestos da aula anterior.

- Deployment

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

- Service, iremos altera apenas o type:

~~~~yaml
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  selector:
    app: api
  type: LoadBalancer
  ports:
    - targetPort: 8080
      port: 80
~~~~



- Comando kubectl que aplica todos os manifestos da pasta atual:
kubectl apply -f .



- Verificando todos os recursos:
kubectl get all

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula81-LoadBalancer$ kubectl get all
NAME                       READY   STATUS    RESTARTS   AGE
pod/api-864b7ff7ff-wlgxs   1/1     Running   0          52s

NAME                  TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/api-service   LoadBalancer   10.97.235.114   <pending>     80:30042/TCP   6d1h
service/kubernetes    ClusterIP      10.96.0.1       <none>        443/TCP        23d

NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/api   1/1     1            1           52s

NAME                             DESIRED   CURRENT   READY   AGE
replicaset.apps/api-864b7ff7ff   1         1         1       52s
fernando@debian10x64:~/cursos/kubedev/aula81-LoadBalancer$ ^C
~~~~


- Verificando os services apenas:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula81-LoadBalancer$ kubectl get services
NAME          TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
api-service   LoadBalancer   10.97.235.114   <pending>     80:30042/TCP   6d1h
kubernetes    ClusterIP      10.96.0.1       <none>        443/TCP        23d
fernando@debian10x64:~/cursos/kubedev/aula81-LoadBalancer$
~~~~


- Verificando o service LoadBalancer, ele está com o status de <pending>, pois não estamos conectados numa nuvem, estamos usando o Minikube.
- Se usarmos um serviço de nuvem, ao aplicar estes recursos, temos um endereço ip no campo "EXTERNAL-IP".
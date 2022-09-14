
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# push
git status
git add .
git commit -m "aula80 - Service - Nodeport. pt1"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status


# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# Service - Nodeport

NodePort - Expõe o serviço sob a mesma porta em cada nó selecionado no cluster usando NAT. Faz o serviço acessível externamente ao cluster usando <NodeIP>:<NodePort>. Superconjunto de ClusterIP.



- Iremos usar a mesma estrutura da aula 79, Deployment, Pod, etc
efetuada a cópia



- Deletando a infra da aula anterior


fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl delete deploy api
deployment.apps "api" deleted
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl delete svc api-service
service "api-service" deleted
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$



- Criando do zero
kubectl apply -f /home/fernando/cursos/kubedev/aula80-Nodeport/deployment.yaml


- Criando o service:

~~~~yaml
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  selector:
    app: api
  type: NodePort
  ports:
    - targetPort: 8080
      port: 80
~~~~


- Aplicando
kubectl apply -f /home/fernando/cursos/kubedev/aula80-Nodeport/service.yaml

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl apply -f /home/fernando/cursos/kubedev/aula80-Nodeport/service.yaml
service/api-service created
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl get svc -A
NAMESPACE     NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
default       api-service   NodePort    10.97.235.114   <none>        80:30042/TCP             3s
default       kubernetes    ClusterIP   10.96.0.1       <none>        443/TCP                  16d
kube-system   kube-dns      ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP,9153/TCP   16d
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl get pods -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS       AGE
default       api-864b7ff7ff-c4wvv               1/1     Running   0              4m26s
default       ping-test                          1/1     Running   0              40m
~~~~


- Validando a partir do Pod no mesmo namespace, usando o nome do Service:

~~~~bash
root@ping-test:/# date
Wed Sep 14 02:22:25 UTC 2022
root@ping-test:/# cat | curl http://api-service/temperatura/fahrenheitparacelsius/200
{"celsius":93.33333333333333,"maquina":"api-864b7ff7ff-c4wvv"}
root@ping-test:/#
~~~~

- Comunicação OK



# Efetuando teste externo

- Verificando o ip do nosso Node do Kubernetes:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ kubectl get nodes -A -o wide
NAME       STATUS   ROLES                  AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION    CONTAINER-RUNTIME
minikube   Ready    control-plane,master   16d   v1.22.2   192.168.49.2   <none>        Ubuntu 20.04.2 LTS   4.19.0-17-amd64   docker://20.10.8
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$

~~~~


- Efetuando curl passando a porta do Service NodePort e o ip do Node do Kubernetes:

cat | curl http://192.168.49.2:30042/temperatura/fahrenheitparacelsius/200

FUNCIONANDO!

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$ cat | curl http://192.168.49.2:30042/temperatura/fahrenheitparacelsius/200
{"celsius":93.33333333333333,"maquina":"api-864b7ff7ff-c4wvv"}
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$
fernando@debian10x64:~/cursos/kubedev/aula79-ClusterIP$
~~~~



# push
git status
git add .
git commit -m "aula80 - Service - Nodeport. pt2"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status

# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# push

git status
git add .
git commit -m "aula82 - Service - ExternalName. pt1"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status


# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# Service ExternalName

Você pode criar um serviço "ExternalName" no Kubernetes para ter um serviço estático que redireciona o tráfego ao serviço externo. Esse serviço faz um redirecionamento de CNAME simples no nível do kernel, por isso o impacto no desempenho é mínimo.

– ExternalName: Mapeia o serviço para o conteúdo do campo externalName (por exemplo, foo.bar.example.com), retornando um registro CNAME com seu valor. Nenhum proxy de qualquer tipo é criado. Isso requer a versão 1.7 ou superior do kube-dns.

- O manifesto do ExternalName é um pouco diferente. Vamos criar um arquivo chamado:
service-external.yaml

~~~~yaml
kind: Service
apiVersion: v1
metadata:
  name: fernando-service-external
spec:
  type: ExternalName
  externalName: appmax.com.br
~~~~

- Aplicando:
kubectl apply -f /home/fernando/cursos/kubedev/aula82-ExternalName/service-external.yaml

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula81-LoadBalancer$ kubectl get services
NAME                        TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
api-service                 LoadBalancer   10.97.235.114   <pending>       80:30042/TCP   6d1h
fernando-service-external   ExternalName   <none>          appmax.com.br   <none>         13s
kubernetes                  ClusterIP      10.96.0.1       <none>          443/TCP        23d
fernando@debian10x64:~/cursos/kubedev/aula81-LoadBalancer$
~~~~


- Entra no modo interativo no Pod da api:
kubectl exec --stdin --tty pod/api-864b7ff7ff-wlgxs -- sh

- Não funciona o curl nela

~~~~bash
/app #
/app # cat | curl fernando-service-external
error code: 1003^C/app # ^C
/app # ^C
~~~~





- Executar um container em modo interativo, com a imagem do Kubedev com Ubuntu:
kubectl run -i --tty --image kubedevio/ubuntu-curl ping-test --restart=Never --rm -- /bin/bash	

- Testes via curl no Pod do Ubuntu curl, também dá erro 1003:

~~~~bash
root@ping-test:/# curl fernando-service-external
error code: 1003
root@ping-test:/#
root@ping-test:/#
~~~~


- Acredito que seja um problema relacionado a um bloqueio do Cloudflare, em relação ao origin:

~~~~bash
root@ping-test:/# curl -v fernando-service-external
*   Trying 172.67.68.96:80...
* TCP_NODELAY set
* Connected to fernando-service-external (172.67.68.96) port 80 (#0)
> GET / HTTP/1.1
> Host: fernando-service-external
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 403 Forbidden
< Date: Tue, 20 Sep 2022 03:53:54 GMT
< Content-Type: text/plain; charset=UTF-8
< Content-Length: 16
< Connection: close
< X-Frame-Options: SAMEORIGIN
< Referrer-Policy: same-origin
< Cache-Control: private, max-age=0, no-store, no-cache, must-revalidate, post-check=0, pre-check=0
< Expires: Thu, 01 Jan 1970 00:00:01 GMT
< Server: cloudflare
< CF-RAY: 74d79de61b639ab9-MIA
<
* Closing connection 0
error code: 1003root@ping-test:/#
root@ping-test:/#
~~~~




- Criado um manifesto diferente, com um Service ExternalName apontando para o site do 4Devs.com.br:

~~~~yaml
kind: Service
apiVersion: v1
metadata:
  name: fernando-service-external-4devs
spec:
  type: ExternalName
  externalName: 4devs.com.br
~~~~


- Aplicando:
kubectl apply -f /home/fernando/cursos/kubedev/aula82-ExternalName/service-external-2.yaml

- Ficou ok, bate o 301 esperado do site via curl:

~~~~bash
fernando@debian10x64:~$ kubectl get services
NAME                              TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
api-service                       LoadBalancer   10.97.235.114   <pending>       80:30042/TCP   6d1h
fernando-service-external         ExternalName   <none>          appmax.com.br   <none>         22m
fernando-service-external-4devs   ExternalName   <none>          4devs.com.br    <none>         8m13s
kubernetes                        ClusterIP      10.96.0.1       <none>          443/TCP        23d
fernando@debian10x64:~$
root@ping-test:/# curl -v fernando-service-external-4devs
*   Trying 51.222.153.35:80...
* TCP_NODELAY set
* Connected to fernando-service-external-4devs (51.222.153.35) port 80 (#0)
> GET / HTTP/1.1
> Host: fernando-service-external-4devs
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 301 Moved Permanently
< Server: nginx
< Date: Tue, 20 Sep 2022 03:57:48 GMT
< Content-Type: text/html
< Content-Length: 162
< Connection: keep-alive
< Location: https://fernando-service-external-4devs/
< Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
< X-Frame-Options: DENY
<
<html>
<head><title>301 Moved Permanently</title></head>
<body>
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx</center>
</body>
</html>
* Connection #0 to host fernando-service-external-4devs left intact
root@ping-test:/# ^C
~~~~



# push

git status
git add .
git commit -m "aula82 - Service - ExternalName. pt2"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status




#  Conclusão
Mapear serviços externos como internos dá a você a flexibilidade de agregar esses serviços ao cluster no futuro e ainda minimizar os trabalhos de refatoração. Mesmo que você não planeje agregá-los hoje, nunca se sabe o dia de amanhã, não é? Além disso, desse jeito fica bem mais fácil gerenciar e entender que serviços externos sua organização usa. Se o serviço externo tem um nome de domínio válido e não precisa de remapeamento de portas, usar o tipo de serviço "ExternalName" é um jeito rápido e fácil de mapear o serviço externo como interno. Caso você não tenha um nome de domínio ou precise fazer remapeamento de portas, é só adicionar os endereços IP a um ponto de extremidade e usá-lo.
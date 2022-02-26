


# aula 51 - Docker Registry

Docker Hub é o principal.
Harbor é uma tecnologia CNCF que é usada como Registry.



#########################################################################################################################################################
#########################################################################################################################################################
#########################################################################################################################################################
#########################################################################################################################################################
#########################################################################################################################################################
#########################################################################################################################################################
#########################################################################################################################################################
# 20/02/2022
# Subindo imagem para o Docker Hub

- Verificando as imagens disponíveis via "docker image ls":

fernando@debian10x64:~$ docker image ls
REPOSITORY                                 TAG       IMAGE ID       CREATED         SIZE
fernandomj90/go-app-multistage             v1        0ec27ef5a11e   15 hours ago    7.22MB
fernandomj90/go-app-simples                v1        41b88ed002d2   16 hours ago    674MB
fernandomj90/ubuntu-imagem-com-argumento   v1        9d5153a2fe69   17 hours ago    117MB
fernandomj90/entrypoint-teste              v4entry   47e925aa74c3   3 days ago      72.8MB
fernandomj90/entrypoint-teste              v3entry   b1ae61b30efd   3 days ago      72.8MB
fernandomj90/entrypoint-teste              v2entry   e9c9a4715e30   3 days ago      72.8MB
fernandomj90/entrypoint-teste              v1        343f5dfa0148   3 days ago      72.8MB
<none>                                     <none>    178dbbe5679e   6 days ago      944MB
fernandomj90/conversao-temperatura         v1        d37d18112918   6 days ago      973MB
<none>                                     <none>    da8668e020c8   6 days ago      995MB
<none>                                     <none>    d8f8773d1605   6 days ago      1.05GB
conversao-temperatura                      latest    51dd5e18e6bc   6 days ago      1.02GB
<none>                                     <none>    068eaf99248e   6 days ago      1.02GB
<none>                                     <none>    5cbc67dc6874   6 days ago      1.05GB
ubuntu-curl-file                           latest    790e2f2efabb   6 days ago      184MB
node                                       latest    f8c8d04432c3   9 days ago      994MB
ubuntu                                     18.04     dcf4d4bef137   2 weeks ago     63.2MB
fernandomj90/alura-sistema-teste2          latest    1fd3d9db06b2   3 weeks ago     557MB
fernandomj90/alura-sistema-teste2          <none>    565a5794bf74   3 weeks ago     557MB
fernandomj90/alura-sistema-teste2          <none>    88a2e4df224b   3 weeks ago     510MB
fernandomj90/alura-sistema-teste2          <none>    60e2169e8e86   3 weeks ago     510MB
fernandomj90/alura-sistema-teste2          <none>    3460dbcc3d6c   3 weeks ago     510MB
fernandomj90/alura-sistema-teste2          <none>    6007dc8f6a3e   3 weeks ago     510MB
fernandomj90/alura-sistema-teste2          <none>    09da88553b7b   3 weeks ago     510MB
fernandomj90/alura-sistema-teste2          <none>    90a2be5aff06   3 weeks ago     510MB
fernandomj90/webserver                     latest    f3f8c630427c   3 weeks ago     510MB
alura-sistema-teste2                       latest    f3f8c630427c   3 weeks ago     510MB
fernandomj90/alura-sistema-teste2          <none>    f3f8c630427c   3 weeks ago     510MB
ubuntu-curl-commit                         latest    b399d106a0d1   7 weeks ago     121MB
nginx                                      latest    f6987c8d6ed5   2 months ago    141MB
mongo                                      latest    dfda7a2cf273   2 months ago    693MB
alpine                                     latest    c059bfaa849c   2 months ago    5.59MB
ubuntu                                     latest    ba6acccedd29   4 months ago    72.8MB
gcr.io/k8s-minikube/kicbase                v0.0.27   9fa1cc16ad6d   5 months ago    1.08GB
node                                       14.17.5   256d6360f157   6 months ago    944MB
aluracursos/sistema-noticias               1         78acece58827   19 months ago   510MB
golang                                     1.7.3     ef15416724f6   5 years ago     672MB
fernando@debian10x64:~$


- O primeiro passo é autenticar usando o comando "docker login"

docker login
fernandomj90


- Fazer o push usando o comando "docker push":

docker push fernandomj90/conversao-temperatura:v1

fernando@debian10x64:~$ docker push fernandomj90/conversao-temperatura:v1
The push refers to repository [docker.io/fernandomj90/conversao-temperatura]
33c5c7978847: Pushed
85a630672ee1: Pushed
cd517ba4e84c: Pushed
1b12f8aa2e70: Pushed
658f254fc704: Mounted from library/node
8a464d09b5c6: Mounted from library/node
1cc9513e3494: Mounted from library/node
5cb0af444f72: Mounted from library/node
dea274feff1a: Mounted from library/node
953b9481bddb: Mounted from library/node
afce7e9043bf: Mounted from library/node
deeb988a5ea8: Mounted from library/node
1bf665ea9709: Mounted from library/node
v1: digest: sha256:f2cb3ae349979eeae87da050ce2ece5af2e738fc6459faf9fdbdebc0e27d2c13 size: 3051
fernando@debian10x64:~$




# Taggeando as imagens

- Taggeando as imagens:

docker tag fernandomj90/conversao-temperatura:v1 fernandomj90/conversao-temperatura:latest

fernando@debian10x64:~$ docker image ls | grep temperatura
fernandomj90/conversao-temperatura         latest    d37d18112918   6 days ago      973MB
fernandomj90/conversao-temperatura         v1        d37d18112918   6 days ago      973MB


- Fazendo o push usando o comando "docker push", agora da imagem com a tag latest, que é baseada na v1:

docker push fernandomj90/conversao-temperatura:latest

fernando@debian10x64:~$ docker push fernandomj90/conversao-temperatura:latest
The push refers to repository [docker.io/fernandomj90/conversao-temperatura]
33c5c7978847: Layer already exists
85a630672ee1: Layer already exists
cd517ba4e84c: Layer already exists
1b12f8aa2e70: Layer already exists
658f254fc704: Layer already exists
8a464d09b5c6: Layer already exists
1cc9513e3494: Layer already exists
5cb0af444f72: Layer already exists
dea274feff1a: Layer already exists
953b9481bddb: Layer already exists
afce7e9043bf: Layer already exists
deeb988a5ea8: Layer already exists
1bf665ea9709: Layer already exists
latest: digest: sha256:f2cb3ae349979eeae87da050ce2ece5af2e738fc6459faf9fdbdebc0e27d2c13 size: 3051
fernando@debian10x64:~$

É possível verificar a ocorrência da mensagem "Layer already exists" para todas as camadas, devido a imagem ser igual a v1, as camadas foram aproveitadas.




- Removendo a imagem:

docker image rm fernandomj90/conversao-temperatura:latest

fernando@debian10x64:~$ docker image rm fernandomj90/conversao-temperatura:latest
Untagged: fernandomj90/conversao-temperatura:latest
fernando@debian10x64:~$
fernando@debian10x64:~$ docker image ls | grep temperatura
fernandomj90/conversao-temperatura         v1        d37d18112918   6 days ago      973MB
conversao-temperatura                      latest    51dd5e18e6bc   6 days ago      1.02GB
fernando@debian10x64:~$


- Efetuar a limpeza de imagens usando o comando "docker image prune":

fernando@debian10x64:~$ docker image prune
WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N] y
Deleted Images:
untagged: fernandomj90/alura-sistema-teste2@sha256:1aa6e2c7deef4da1804b0980e3cbc35372ce3a0e7782d70bdb0833cb706f207c
deleted: sha256:88a2e4df224bc855416dfda53fbf21daf240f48f62306c4068f91aac6064abc8
Total reclaimed space: 123.6MB
fernando@debian10x64:~$


- Executando o Container usando o comando "docker container run", ele irá baixar a imagem do nosso repositório, já que não temos ela localmente agora:

docker container run -d -p 8080:8080 fernandomj90/conversao-temperatura:latest

fernando@debian10x64:~$ docker container run -d -p 8080:8080 fernandomj90/conversao-temperatura:latest
Unable to find image 'fernandomj90/conversao-temperatura:latest' locally
latest: Pulling from fernandomj90/conversao-temperatura
Digest: sha256:f2cb3ae349979eeae87da050ce2ece5af2e738fc6459faf9fdbdebc0e27d2c13
Status: Downloaded newer image for fernandomj90/conversao-temperatura:latest
6fb115d3feb693eb521d640968f7a0525c901133425ebba78aefab3e6e4d9f38
fernando@debian10x64:~$

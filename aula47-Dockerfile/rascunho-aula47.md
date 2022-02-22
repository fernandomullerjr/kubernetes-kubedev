

# 47 -  Imagem - Criando imagem com Dockerfile

-Criando o Dockerfile:
vi /home/fernando/cursos/kubedev/aula47-Dockerfile/Dockerfile

FROM ubuntu:latest

RUN apt-get update
RUN apt-get install curl --yes



- Comando para a criação da imagem:
obs:
considerando que você esteja no mesmo diretório que o arquivo Dockerfile.

--tag , -t 		Name and optionally a tag in the 'name:tag' format

cd /home/fernando/cursos/kubedev/aula47-Dockerfile
docker image build -t ubuntu-curl-file .


fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$ docker image build -t ubuntu-curl-file .
Sending build context to Docker daemon  3.072kB
Step 1/3 : FROM ubuntu:latest
 ---> ba6acccedd29
Step 2/3 : RUN apt-get update
 ---> Running in c9e55751212e
[...]
Running hooks in /etc/ca-certificates/update.d...
done.
Removing intermediate container c9d7839d9739
 ---> dc56096b71f4
Successfully built dc56096b71f4
Successfully tagged ubuntu-curl-file:latest
fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$




- Verificando as imagens:

fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$ docker image ls
REPOSITORY                          TAG       IMAGE ID       CREATED          SIZE
ubuntu-curl-file                    latest    dc56096b71f4   50 seconds ago   123MB



- Rodando o mesmo comando novamente:

fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$ docker image build -t ubuntu-curl-file .
Sending build context to Docker daemon  3.584kB
Step 1/3 : FROM ubuntu:latest
 ---> ba6acccedd29
Step 2/3 : RUN apt-get update
 ---> Using cache
 ---> e1cd62741f47
Step 3/3 : RUN apt-get install curl --yes
 ---> Using cache
 ---> dc56096b71f4
Successfully built dc56096b71f4
Successfully tagged ubuntu-curl-file:latest
fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$

Como é possível verificar, ele usa um Cache, com base nas camadas que ele já executou.




# Importante
- Como o nosso arquivo Dockerfile tem 1 instrução por linha, ao adicionarmos um novo comando apenas, ao buildar a imagem os demais comandos como estão em Cache não
serão atualizados.
Apenas o novo comando será executado de forma atualizada.

FROM ubuntu:latest

RUN apt-get update
RUN apt-get install curl --yes
RUN apt-get install vim --yes


- O ideal é formatar todos os comandos numa única linha, para que a execução de todos os comandos seja atualizada e a gente tenha uma
aplicação sempre atualizada.
Adicionando ao Dockerfile a instação do vim.

FROM ubuntu:latest

RUN apt-get update && apt-get install curl --yes && apt-get install vim --yes





-Buildando novamente:

docker image build -t ubuntu-curl-file .

fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$ docker image build -t ubuntu-curl-file .
Sending build context to Docker daemon  5.632kB
Step 1/2 : FROM ubuntu:latest
 ---> ba6acccedd29
Step 2/2 : RUN apt-get update && RUN apt-get install curl --yes && RUN apt-get install vim --yes
 ---> Running in 3ad6de0ab921
[...]
Processing triggers for libc-bin (2.31-0ubuntu9.2) ...
Removing intermediate container 07bbd095ceaf
 ---> 790e2f2efabb
Successfully built 790e2f2efabb
Successfully tagged ubuntu-curl-file:latest
fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$


- Devido a adição do vim, é possível verificar que a imagem ficou mais pesada:

fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$ docker image ls
REPOSITORY                          TAG       IMAGE ID       CREATED          SIZE
ubuntu-curl-file                    latest    790e2f2efabb   47 seconds ago   184MB




# Efetuando limpeza de imagens com o prune

- Usar o comando "docker image prune" para limpar imagens que estão sem referência

fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$ docker image ls
REPOSITORY                          TAG       IMAGE ID       CREATED          SIZE
ubuntu-curl-file                    latest    790e2f2efabb   47 seconds ago   184MB
<none>                              <none>    dc56096b71f4   13 minutes ago   123MB
fernandomj90/alura-sistema-teste2   latest    1fd3d9db06b2   2 weeks ago      557MB
fernandomj90/alura-sistema-teste2   <none>    565a5794bf74   2 weeks ago      557MB
<none>                              <none>    f4d14f7edea1   2 weeks ago      557MB
fernandomj90/alura-sistema-teste2   <none>    88a2e4df224b   2 weeks ago      510MB
fernandomj90/alura-sistema-teste2   <none>    60e2169e8e86   2 weeks ago      510MB
fernandomj90/alura-sistema-teste2   <none>    3460dbcc3d6c   2 weeks ago      510MB
fernandomj90/alura-sistema-teste2   <none>    6007dc8f6a3e   2 weeks ago      510MB
fernandomj90/alura-sistema-teste2   <none>    09da88553b7b   2 weeks ago      510MB
fernandomj90/alura-sistema-teste2   <none>    90a2be5aff06   2 weeks ago      510MB
fernandomj90/webserver              latest    f3f8c630427c   2 weeks ago      510MB
alura-sistema-teste2                latest    f3f8c630427c   2 weeks ago      510MB
fernandomj90/alura-sistema-teste2   <none>    f3f8c630427c   2 weeks ago      510MB
ubuntu-curl-commit                  latest    b399d106a0d1   6 weeks ago      121MB
nginx                               latest    f6987c8d6ed5   7 weeks ago      141MB
mongo                               latest    dfda7a2cf273   2 months ago     693MB
ubuntu                              latest    ba6acccedd29   4 months ago     72.8MB
hello-world                         latest    feb5d9fea6a5   4 months ago     13.3kB
gcr.io/k8s-minikube/kicbase         v0.0.27   9fa1cc16ad6d   4 months ago     1.08GB
aluracursos/sistema-noticias        1         78acece58827   19 months ago    510MB
fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$
fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$
fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$
fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$
fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$ docker image prune
WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N] y
Deleted Images:
deleted: sha256:f4d14f7edea10b66b97b14a1430e42df05c807b98373ee6c02c4cf293875d341
deleted: sha256:305d9278417dd0aba5e85fdf2a0c984b5f9f6fb1a6054c8d33112bbc1361292a
deleted: sha256:dc56096b71f47092530ca47f40db0db3ab5005a6d6969d01767ac4a8554c2ff0
deleted: sha256:ae0e2027e97cde5ff0f8ad60c813a4c6fbfce6ac957a971cd42130b0bcb126f6
deleted: sha256:e1cd62741f47e70f627d4ccdf991ed1e4ceaa8d60bf6b5ace4e3fa8e81264372
deleted: sha256:ff2f729a8953b1f0bd8290f6df7b9e3ffae00f272a495908c7cbc9070e943b5c

Total reclaimed space: 97.26MB
fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$




- Deletando imagens individualmente usando o docker image rm:

fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$ docker image rm feb5d9fea6a5
Error response from daemon: conflict: unable to delete feb5d9fea6a5 (must be forced) - image is being used by stopped container c2b5824bd4ae

- Como a imagem  estava em uso por um Container parado, é necessário usar o parametro "-f" no comando:

fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$ docker image rm -f feb5d9fea6a5
Untagged: hello-world:latest
Untagged: hello-world@sha256:2498fce14358aa50ead0cc6c19990fc6ff866ce72aeb5546e1d59caac3d0d60f
Deleted: sha256:feb5d9fea6a5e9606aa995e879d862b825965ba48de054caab5ef356dc6b3412
fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$



- Verificando o histórico de alterações na imagem e nas camadas:

fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$ docker image history ubuntu-curl-file
IMAGE          CREATED          CREATED BY                                      SIZE      COMMENT
790e2f2efabb   13 minutes ago   /bin/sh -c apt-get update && apt-get install…   112MB
ba6acccedd29   4 months ago     /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>      4 months ago     /bin/sh -c #(nop) ADD file:5d68d27cc15a80653…   72.8MB
fernando@debian10x64:~/cursos/kubedev/aula47-Dockerfile$

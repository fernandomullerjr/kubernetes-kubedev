

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
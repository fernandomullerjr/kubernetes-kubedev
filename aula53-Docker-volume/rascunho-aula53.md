


# aula 53 - Docker Volumes


Bind – é um mapeamento entre a máquina local e o Container, gerenciado pelo Analista.

Volume – é gerenciado pelo Docker, que nem o Bind, é armazenado na máquina, mas o Docker cuida de tudo.

Tmpfs – acessado apenas pelo Container, não consegue comunicar com a máquina local.



# Bind

- Criando um mapeamento do tipo bind:

docker container run -it -v "<diretorio-local>:<diretorio-dentro-do-container>" ubuntu /bin/bash
docker container run -it -v "$(pwd)/vol:/app" ubuntu /bin/bash


- Criando um arquivo de teste no diretório "vol", que é o mapeamento local:

fernando@debian10x64:~/cursos/kubedev/vol$ sudo touch teste.txt
[sudo] password for fernando:
fernando@debian10x64:~/cursos/kubedev/vol$ pwd
/home/fernando/cursos/kubedev/vol
fernando@debian10x64:~/cursos/kubedev/vol$


- Validando de dentro do Container:

root@f4be580bbace:/# ls app/
root@f4be580bbace:/# ls app/
teste.txt
root@f4be580bbace:/#




# Volume

docker volume create aula_docker

fernando@debian10x64:~/cursos/kubedev$ docker volume create aula_docker
aula_docker
fernando@debian10x64:~/cursos/kubedev$ docker volume ls
DRIVER    VOLUME NAME
local     0af5a162301dd1bfbc1637098ae8de833be4f8b86a8b8163943c187374631c3f
local     8857428ef7d7cf825004bc6ae84bb48b4f19936cc679cf872ea816156cc3ab12
local     aula_docker
local     minikube
fernando@debian10x64:~/cursos/kubedev$


- Criando um Container e mapeando o volume do tipo "Volume" com a pasta "/app" do Container:

docker container run -it -v "aula_docker:/app" ubuntu /bin/bash


- Verificando o diretório onde está o Volume atrelado ao Container:

docker volume inspect aula_docker

fernando@debian10x64:~/cursos/kubedev/vol$ docker volume inspect aula_docker
[
    {
        "CreatedAt": "2022-02-21T21:22:15-03:00",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/aula_docker/_data",
        "Name": "aula_docker",
        "Options": {},
        "Scope": "local"
    }
]
fernando@debian10x64:~/cursos/kubedev/vol$



- Validando:

Criado um arquivo dentro do Container na pasta app:

root@536c67bc067f:/app# touch teste-no-volume.txt
root@536c67bc067f:/app# ls
teste-no-volume.txt
root@536c67bc067f:/app#

Verificando que o arquivo foi criado na pasta referente ao volume "aula_docker" no diretório do docker para este volume:

fernando@debian10x64:~/cursos/kubedev/vol$ sudo ls -lhasp /var/lib/docker/volumes/aula_docker/_data
total 8.0K
4.0K drwxr-xr-x 2 root root 4.0K Feb 21 21:26 ./
4.0K drwx-----x 3 root root 4.0K Feb 21 21:22 ../
   0 -rw-r--r-- 1 root root    0 Feb 21 21:26 teste-no-volume.txt
fernando@debian10x64:~/cursos/kubedev/vol$









# Criando os volumes de outra maneira

- Criando um volume do tipo Bind, usando outro método:

mkdir volbind2
docker container run -it --mount type=bind,src="$(pwd)/volbind2",dst=/app ubuntu /bin/bash

fernando@debian10x64:~/cursos/kubedev$ mkdir volbind2
fernando@debian10x64:~/cursos/kubedev$ docker container run -it --mount type=bind,src="$(pwd)/volbind2",dst=/app ubuntu /bin/bash
root@0dbf848eea5c:/#


- Testando: 

Criando arquivo no Container na pasta app:

root@0dbf848eea5c:/# ls app/
root@0dbf848eea5c:/# touch app/teste-bind2.txt
root@0dbf848eea5c:/# ls app/
teste-bind2.txt
root@0dbf848eea5c:/#

Validando localmente:

fernando@debian10x64:~/cursos/kubedev$ ls volbind2/
teste-bind2.txt
fernando@debian10x64:~/cursos/kubedev$



- Criando um volume do tipo Volume, usando outro método:

docker container run -it --mount type=volume,src="aula_docker",dst=/app ubuntu /bin/bash

- Validando:

Dentro do Container na pasta app já tinha um arquivo, pois o volume do tipo volume preserva os arquivos:

root@4c31517699ca:/# ls app/
teste-no-volume.txt
root@4c31517699ca:/#

- Validando o volume:

fernando@debian10x64:~/cursos/kubedev$ docker volume inspect aula_docker
[
    {
        "CreatedAt": "2022-02-21T21:26:14-03:00",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/aula_docker/_data",
        "Name": "aula_docker",
        "Options": {},
        "Scope": "local"
    }
]
fernando@debian10x64:~/cursos/kubedev$ sudo ls -lhasp "/var/lib/docker/volumes/aula_docker/_data"
[sudo] password for fernando:
total 8.0K
4.0K drwxr-xr-x 2 root root 4.0K Feb 21 21:26 ./
4.0K drwx-----x 3 root root 4.0K Feb 21 21:22 ../
   0 -rw-r--r-- 1 root root    0 Feb 21 21:26 teste-no-volume.txt
fernando@debian10x64:~/cursos/kubedev$

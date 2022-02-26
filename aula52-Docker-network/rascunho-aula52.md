



# aula 52 - Docker network

- Para os Containers comunicarem entre si, o Docker utiliza as Networks.

# Tipos de Networks
- Bridge é o mais utilizado.
- O host remove as fronteiras entre o Container e o host local.
- Rede Overlay é usada quando há vários hosts, ex: Docker Swarm.


- Verificando as network existentes e criando uma network chamada "aula_docker", para testes:

fernando@debian10x64:~$ docker network ls
NETWORK ID     NAME       DRIVER    SCOPE
a27448f53fe7   bridge     bridge    local
4ea8eec63a81   host       host      local
3da551b080c1   minikube   bridge    local
cc85819ababc   none       null      local
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ docker network create aula_docker
cec278fb810afee75de50078adb7f11afd4145f3f0c02a0cc57a1fe86598e234
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ docker network ls
NETWORK ID     NAME          DRIVER    SCOPE
cec278fb810a   aula_docker   bridge    local
a27448f53fe7   bridge        bridge    local
4ea8eec63a81   host          host      local
3da551b080c1   minikube      bridge    local
cc85819ababc   none          null      local
fernando@debian10x64:~$



- Criando um Container do NGINX sem conectar a rede alguma:

docker container run -d --name nginx nginx

fernando@debian10x64:~$ docker container ls
CONTAINER ID   IMAGE                                       COMMAND                  CREATED          STATUS          PORTS                                       NAMES
3a587017de54   nginx                                       "/docker-entrypoint.…"   6 seconds ago    Up 3 seconds    80/tcp                                      nginx
6fb115d3feb6   fernandomj90/conversao-temperatura:latest   "docker-entrypoint.s…"   36 minutes ago   Up 36 minutes   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   youthful_sammet
fernando@debian10x64:~$



- Criar outro Container, usando a imagem do curl que foi criada na aula 47, que tem como base o Ubuntu e tem instalado o vim e o curl:

fernando@debian10x64:~$ docker image ls | grep curl
ubuntu-curl-file                           latest    790e2f2efabb   6 days ago      184MB
ubuntu-curl-commit                         latest    b399d106a0d1   7 weeks ago     121MB
fernando@debian10x64:~$

docker container run -it ubuntu-curl-file:latest /bin/bash

fernando@debian10x64:~$ docker container ls
CONTAINER ID   IMAGE                                       COMMAND                  CREATED          STATUS          PORTS                                       NAMES
b1b833b2c9aa   ubuntu-curl-file:latest                     "/bin/bash"              18 seconds ago   Up 17 seconds                                               strange_noyce
3a587017de54   nginx                                       "/docker-entrypoint.…"   11 minutes ago   Up 11 minutes   80/tcp                                      nginx
6fb115d3feb6   fernandomj90/conversao-temperatura:latest   "docker-entrypoint.s…"   47 minutes ago   Up 47 minutes   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   youthful_sammet
fernando@debian10x64:~$


- Testando a conectividade.
- Dentro do Container Ubuntu-curl-file:

root@b1b833b2c9aa:/# curl http://nginx
curl: (6) Could not resolve host: nginx
root@b1b833b2c9aa:/#

- Da máquina local:

fernando@debian10x64:~$ curl http://nginx
curl: (6) Could not resolve host: nginx
fernando@debian10x64:~$

Como o NGINX não está na mesma rede que o Ubuntu-curl-file, ele não vai alcançar o outro Container.



- Verificando os detalhes do container NGINX via "docker inspect", é possível verificar ao final que ele não está numa Network:

fernando@debian10x64:~$ docker container inspect nginx
[

 "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "a27448f53fe79d58ea36367e857e0b0b8662ac5ab055662a09ef0bac06c6c48d",
                    "EndpointID": "5543850dac28c0801ab4ec0043745347abdbf6bbe3d8dc71f7720b4c15340d08",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:03",
                    "DriverOpts": null
                }




- Conectando o Container a Network "aula_docker":

docker network connect aula_docker <id-do-container-ubuntu-curl-file>
docker network connect aula_docker b1b833b2c9aa
docker network connect aula_docker <id-do-container-nginx>
docker network connect aula_docker 3a587017de54

fernando@debian10x64:~$ ^C
fernando@debian10x64:~$ docker network connect aula_docker b1b833b2c9aa
fernando@debian10x64:~$ ^C
fernando@debian10x64:~$ ^C
fernando@debian10x64:~$ docker network connect aula_docker 3a587017de54
fernando@debian10x64:~$



- Verificando novamente o Container via "docker container inspect nginx" , agora ele está conectado a Network "aula_docker"

fernando@debian10x64:~$ docker container inspect nginx 
           "Networks": {
                "aula_docker": {
                    "IPAMConfig": {},
                    "Links": null,
                    "Aliases": [
                        "3a587017de54"
                    ],
                    "NetworkID": "cec278fb810afee75de50078adb7f11afd4145f3f0c02a0cc57a1fe86598e234",
                    "EndpointID": "9d296a348261f061dcd2d6b2f3b8a7b5ee14630dad5b125560e3111e4cc31c19",
                    "Gateway": "172.18.0.1",
                    "IPAddress": "172.18.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:12:00:03",
                    "DriverOpts": {}
                },
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "a27448f53fe79d58ea36367e857e0b0b8662ac5ab055662a09ef0bac06c6c48d",
                    "EndpointID": "5543850dac28c0801ab4ec0043745347abdbf6bbe3d8dc71f7720b4c15340d08",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:03",
                    "DriverOpts": null
                }
            }
        }
    }
]
fernando@debian10x64:~$




- Executando o curl de dentro do Container do Ubuntu-curl-file, agora ele alcança o container do NGINX:

root@b1b833b2c9aa:/# curl http://nginx
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
root@b1b833b2c9aa:/#




- Usando o comando "docker network disconnect", o Curl para de funcionar:

docker network disconnect aula_docker 3a587017de54

root@b1b833b2c9aa:/# curl http://nginx
curl: (6) Could not resolve host: nginx
root@b1b833b2c9aa:/#



- Deletando o Container do NGINX:

docker container rm -f 3a587017de54

- Criando um novo Container para o NGINX, apontando para a Network pré-existente:

docker container run -d --network aula_docker --name nginx nginx

fernando@debian10x64:~$ docker container run -d --network aula_docker --name nginx nginx
b12c8292b4e1bd090a0ce8446157c68cfc8f906b8d43bc17616960ba59a9002c
fernando@debian10x64:~$


- Então o CURL volta a funcionar, a partir do Container do Ubuntu-CURL:

root@b1b833b2c9aa:/# ^C
root@b1b833b2c9aa:/# curl http://nginx
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
root@b1b833b2c9aa:/#




- Removidos os Containers.




# Network Host
- Criando um Container usando uma Network do tipo "Host":
docker container run -d --name nginx --network host nginx 

fernando@debian10x64:~$ docker container run -d --name nginx --network host nginx
66327d5c7b2a5f879caf2ac3c1e154400f4979b2e2e9aa7c073690ea8f9f9ac9
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ docker container ls
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS        PORTS     NAMES
66327d5c7b2a   nginx     "/docker-entrypoint.…"   2 seconds ago   Up 1 second             nginx
fernando@debian10x64:~$


- Abrindo o endereço no navegador na porta 80, vai abrir a página do NGINX:
http://192.168.0.113/



- VER CONFLITOS DO REPO
- BRANCH teste
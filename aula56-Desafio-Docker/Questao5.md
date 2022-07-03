
# Questão 05 - Desafio Wordpress

Chegou um cliente pra você que possui todas as suas aplicações em data centers e a gestão dessas aplicações está cada vez mais complexa então pra iniciar um plano de
gestão unificada e migração pra um ambiente cloud, as aplicações serão migradas pra containers. E hoje você precisa iniciar esse processo com um projeto piloto, o portal de
conteúdos da empresa construido em Wordpress. Então hoje sua missão é criar esse ambiente wordpress pronto para a equipe de publicidade começar a popular.


git remote add origin git@github.com:fernandomullerjr/desafio-docker-questao5-wordpress.git
git branch -M main
git push -u origin main




eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github





# #################################################################################################################################################################
# #################################################################################################################################################################
# #################################################################################################################################################################
# ERRO

ERROR: for db  Cannot start service db: driver failed programming external connectivity on endpoint wordpress-mariadb (3bb89ffbbc782c23f55b1c40a3f73ea6dfa9da6d0a4408e6bc5cb0b4ee407b5d): Error starting userland proxy: listen tcp4 0.0.0. use
ERROR: Encountered errors while bringing up the project.

- ERRO DURANTE A SUBIDA DO CONTAINER DO BANCO DE DADOS:

~~~~bash
271be7ae0cc8: Pull complete
Digest: sha256:70246a8dc8282bbe4f9d53d3e88f4b0a2287cdb84b8da356d8bf44542ae14f2d
Status: Downloaded newer image for wordpress:5.8.3
Creating wordpress-mariadb ...
Creating wordpress-mariadb ... error

ERROR: for wordpress-mariadb  Cannot start service db: driver failed programming external connectivity on endpoint wordpress-mariadb (3bb89ffbbc782c23f55b1c40a3f73ea6dfa9da6d0a4408e6bc5cb0b4ee407b5d): Error starting userland proxy: lisress already in use

ERROR: for db  Cannot start service db: driver failed programming external connectivity on endpoint wordpress-mariadb (3bb89ffbbc782c23f55b1c40a3f73ea6dfa9da6d0a4408e6bc5cb0b4ee407b5d): Error starting userland proxy: listen tcp4 0.0.0. use
ERROR: Encountered errors while bringing up the project.


fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$ docker ps -a
CONTAINER ID   IMAGE                 COMMAND                  CREATED          STATUS                    PORTS                                       NAMES
5983200be397   mariadb:10.7.1        "docker-entrypoint.s…"   19 minutes ago   Created                                                               wordpress-mariadb
1643d6b458ad   c31214732282          "/bin/sh -c 'pip3 in…"   37 hours ago     Exited (1) 37 hours ago                                               vibrant_borg
5b6a8d375126   7be1693d4a75          "/bin/sh -c 'pip3 in…"   4 days ago       Exited (1) 4 days ago                                                 loving_heisenberg
8035ad23d47a   7be1693d4a75          "/bin/sh -c 'pip3 in…"   4 days ago       Exited (1) 4 days ago                                                 recursing_agnesi
4e0cc1b8a495   portainer/portainer   "/portainer"             5 days ago       Up 2 hours                0.0.0.0:9000->9000/tcp, :::9000->9000/tcp   frosty_easley
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$
~~~~



- ERRO DURANTE A SUBIDA DO CONTAINER DO BANCO DE DADOS:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$ docker-compose up -d
Creating network "desafio-docker-questao5-wordpress_wordpress_network" with driver "bridge"
Creating wordpress-mariadb ...
Creating wordpress-mariadb ... error

ERROR: for wordpress-mariadb  Cannot start service db: driver failed programming external connectivity on endpoint wordpress-mariadb (bb227807f3a40f00651e3fbdb4e7ba1778d03d41b90f2f0d3fde7ee81238e47f): Error starting userland proxy: listen tcp4 0.0.0.0:3306: bind: address already in use

ERROR: for db  Cannot start service db: driver failed programming external connectivity on endpoint wordpress-mariadb (bb227807f3a40f00651e3fbdb4e7ba1778d03d41b90f2f0d3fde7ee81238e47f): Error starting userland proxy: listen tcp4 0.0.0.0:3306: bind: address already in use
ERROR: Encountered errors while bringing up the project.
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$
~~~~




# #################################################################################################################################################################
# #################################################################################################################################################################
# #################################################################################################################################################################
# SOLUÇÃO

- Havia um serviço do MYSQL iniciado na maquina hospedeira, impedindo que a porta 3306 fosse utilizada em algum Container.
- Foi necessário efetuar o stop do MYSQL na VM do Debian 10.

https://stackoverflow.com/questions/37896369/error-starting-userland-proxy-listen-tcp-0-0-0-03306-bind-address-already-in
https://stackoverflow.com/questions/37971961/docker-error-bind-address-already-in-use
https://github.com/eko/docker-symfony/issues/85
https://linuxhint.com/install-netstat-debian-11/
sudo apt install net-tools


- Verificando o processo que está usando a porta 3306:

sudo netstat -laputen | grep ':3306 *LISTEN'
sudo systemctl stop PROGRAM_NAM
sudo netstat -pna | grep 3306

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$ sudo netstat -pna | grep 3306
tcp6       0      0 :::33060                :::*                    LISTEN      834/mysqld
tcp6       0      0 :::3306                 :::*                    LISTEN      834/mysqld
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$
~~~~


- Verificando qual processo está usando o PID 834:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$ ps -ef | grep 834
mysql       834      1  0 09:55 ?        00:00:19 /usr/sbin/mysqld
fernando   9060   7071  0 12:06 pts/3    00:00:00 grep 834
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$
~~~~

- Verificando se existe um service com o nome MYSQL:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$ systemctl | grep mysql
  mysql.service                                                                                         loaded active running   MySQL Community Server
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$
~~~~

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$ systemctl status mysql
● mysql.service - MySQL Community Server
   Loaded: loaded (/lib/systemd/system/mysql.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2022-06-16 09:55:50 -03; 2h 10min ago
     Docs: man:mysqld(8)
           http://dev.mysql.com/doc/refman/en/using-systemd.html
  Process: 747 ExecStartPre=/usr/share/mysql-8.0/mysql-systemd-start pre (code=exited, status=0/SUCCESS)
 Main PID: 834 (mysqld)
   Status: "Server is operational"
    Tasks: 37 (limit: 10191)
   Memory: 454.2M
   CGroup: /system.slice/mysql.service
           └─834 /usr/sbin/mysqld
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$
~~~~


- COMANDOS AUXILIARES:
systemctl status mysql
sudo systemctl stop mysql
sudo systemctl disable mysql
systemctl status mysql


- Efetuado o stop e disable do serviço MYSQL.
- Subidos os containers via Docker-compose com sucesso.

~~~~bash
fernando@debian10x64:~$ systemctl status mysql
● mysql.service - MySQL Community Server
   Loaded: loaded (/lib/systemd/system/mysql.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:mysqld(8)
           http://dev.mysql.com/doc/refman/en/using-systemd.html
fernando@debian10x64:~$

fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$ docker-compose up -d
Starting wordpress-mariadb ... done
Creating wordpress-app     ... done
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$ docker ps
CONTAINER ID   IMAGE                 COMMAND                  CREATED         STATUS         PORTS                                       NAMES
c45c076c36d7   wordpress:5.8.3       "docker-entrypoint.s…"   2 seconds ago   Up 1 second    0.0.0.0:8080->80/tcp, :::8080->80/tcp       wordpress-app
eddf86294f5f   mariadb:10.7.1        "docker-entrypoint.s…"   5 minutes ago   Up 2 seconds   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp   wordpress-mariadb
4e0cc1b8a495   portainer/portainer   "/portainer"             5 days ago      Up 2 hours     0.0.0.0:9000->9000/tcp, :::9000->9000/tcp   frosty_easley
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$ date
Thu 16 Jun 2022 12:07:42 PM -03
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$
~~~~







192.168.0.113:8080/
http://192.168.0.113:8080/wp-admin/install.php


- Imagens pesadas:

~~~~bash

fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$ docker image ls | grep wordpress
wordpress                                                                       5.8.3                d4f1eb34e2f5   5 months ago    616MB
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$ docker image ls | grep maria
mariadb                                                                         latest               100166b773f8   2 months ago    414MB
mariadb                                                                         10.7.1               67a24127bba8   4 months ago    411MB
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$ date
Thu 16 Jun 2022 12:27:08 PM -03
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/desafio-docker-questao5-wordpress$

~~~~

# Pendente
- Fazer KB sobre o erro do MYSQL na porta 3306
- Criar estrutura de Dockerfile para o Wordpress e MariaDB usando Alpine.
- Usar boas práticas.



# Dia 18/06/2022

- Criado KB sobre o erro do MYSQL na porta 3306.
- Necessário separar os Containers do NGINX, PHP, no Wordpress do Alpine, no exemplo contido na pasta:
  /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2
- Necessário aplicar boas práticas.
- Avaliar se as imagens ficaram compactas.

- Diretório de trabalho:

cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2
docker-compose up -d
docker image ls | head

~~~~bash

fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$ docker ps
CONTAINER ID   IMAGE                                  COMMAND                  CREATED          STATUS                             PORTS                                       NAMES
4d0081069069   docker-wordpress-editado-2_wordpress   "/entrypoint.sh /usr…"   12 seconds ago   Up 10 seconds (health: starting)   0.0.0.0:80->80/tcp, :::80->80/tcp           docker-wordpress-editado-2_wordpress_1
888263913e4a   mariadb:10.3                           "docker-entrypoint.s…"   13 seconds ago   Up 12 seconds                      3306/tcp                                    docker-wordpress-editado-2_db_1
4e0cc1b8a495   portainer/portainer                    "/portainer"             7 days ago       Up 2 hours                         0.0.0.0:9000->9000/tcp, :::9000->9000/tcp   frosty_easley
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$

fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$ docker image ls | head
REPOSITORY                                                                      TAG                  IMAGE ID       CREATED          SIZE
docker-wordpress-editado-2_wordpress                                            latest               fff8bdef5c10   43 minutes ago   329MB
desafio-docker-questao5-wordpress_wordpress                                     latest               fff8bdef5c10   43 minutes ago   329MB
fernandomj90/nginx-alpine-desafio-docker                                        3.15.4               22f808d87c38   3 days ago       7.01MB
fernandomj90/app-rotten-potatoes                                                v1                   7e729279e4f1   3 days ago       188MB
fernandomj90/nginx-alpine-desafio-docker                                        v2                   ac9b80151cac   3 days ago       7.01MB
fernandomj90/rotten-potatoes                                                    v2                   cdc4d9423369   3 days ago       188MB
mariadb                                                                         10.3                 e7211b4227b5   11 days ago      387MB
fernandomj90/desafio-docker-questao3-csharp-asp-net                             v3                   ed71f64133f8   2 weeks ago      210MB
mcr.microsoft.com/dotnet/sdk                                                    5.0                  9fec788bd1f9   3 weeks ago      632MB
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$

~~~~



- Criando novo Dockerfile para separar o NGINX:
    /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2/Dockerfile-nginx.dockerfile
- Avaliar questão do Upstream Server no arquivo de conf do NGINX.


- Criado um arquivo nginx.conf personalizado, fazendo uso do Upstream Server:

~~~~conf
worker_processes  1;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

upstream app_server {
    server wordpress:80;
}

server {
    listen 8080;
    server_name _;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    client_max_body_size 64M;

    location / {
        try_files $uri @proxy_to_app;
    }

    location @proxy_to_app {
        gzip_static on;

        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;
        proxy_buffering off;
        proxy_redirect off;
        proxy_pass http://app_server;
    }
}
~~~~


- Adicionando ao Docker-compose etapa de criação do Container do NGINX.
- Copiando exemplo do diretório:
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes/docker-compose.yml

~~~~YAML

  webserver:
    build:
      context: nginx
      dockerfile: Dockerfile
    image: fernandomj90/nginx-alpine-desafio-docker:3.15.4
    container_name: webserver
    restart: unless-stopped
    tty: true
    environment:
      APP_ENV: "prod"
      APP_NAME: "webserver"
      APP_DEBUG: "true"
      SERVICE_NAME: "webserver"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - nginxdata:/var/log/nginx
    depends_on:
      - flask
    networks:
      - frontend

~~~~


- Editado o Docker-compose, colocado o NGINX personalizado e declarado o volume do nginx:

~~~~yaml

  webserver:
    build:
      context: .
      dockerfile: Dockerfile-nginx.dockerfile
    image: fernandomj90/nginx-alpine-desafio-wordpress:3.15.4
    container_name: webserver
    restart: unless-stopped
    ports:
      - "8080:8080"
      - "443:443"
    volumes:
      - nginxdata:/var/log/nginx
    depends_on:
      - wordpress

volumes:
  db-data:
  site-data:
  nginxdata:
~~~~




- Apresentou erro no NGINX

~~~~bash

fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$ docker ps
CONTAINER ID   IMAGE                                                COMMAND                  CREATED          STATUS                             PORTS                                       NAMES
a31e5f6a67be   fernandomj90/nginx-alpine-desafio-wordpress:3.15.4   "nginx -g 'daemon of…"   14 seconds ago   Restarting (1) 1 second ago                                                    webserver
7a21387ccbf5   docker-wordpress-editado-2_wordpress                 "/entrypoint.sh /usr…"   15 seconds ago   Up 13 seconds (health: starting)   0.0.0.0:80->80/tcp, :::80->80/tcp           docker-wordpress-editado-2_wordpress_1
04b4844c9092   mariadb:10.3                                         "docker-entrypoint.s…"   16 seconds ago   Up 15 seconds                      3306/tcp                                    docker-wordpress-editado-2_db_1
4e0cc1b8a495   portainer/portainer                                  "/portainer"             7 days ago       Up 2 hours                         0.0.0.0:9000->9000/tcp, :::9000->9000/tcp   frosty_easley
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$

~~~~



- Adicionando nome aos Containers no arquivo Docker-compose:

~~~~yaml
    container_name: db
    container_name: wordpress
~~~~



- Segue com erro:

~~~~bash

fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$ docker ps
CONTAINER ID   IMAGE                                                COMMAND                  CREATED         STATUS                                  PORTS                                       NAMES
1262eb2f92d3   fernandomj90/nginx-alpine-desafio-wordpress:3.15.4   "nginx -g 'daemon of…"   6 seconds ago   Restarting (1) Less than a second ago                                               webserver
a30f20c9af27   docker-wordpress-editado-2_wordpress                 "/entrypoint.sh /usr…"   6 seconds ago   Up 6 seconds (health: starting)         0.0.0.0:80->80/tcp, :::80->80/tcp           wordpress
2f9af04e9ae1   mariadb:10.3                                         "docker-entrypoint.s…"   7 seconds ago   Up 6 seconds                            3306/tcp                                    db
4e0cc1b8a495   portainer/portainer                                  "/portainer"             7 days ago      Up 3 hours                              0.0.0.0:9000->9000/tcp, :::9000->9000/tcp   frosty_easley
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$ docker logs webserver
2022/06/18 16:32:53 [emerg] 1#1: "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
nginx: [emerg] "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
2022/06/18 16:32:54 [emerg] 1#1: "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
nginx: [emerg] "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
2022/06/18 16:32:55 [emerg] 1#1: "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
nginx: [emerg] "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
2022/06/18 16:32:56 [emerg] 1#1: "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
nginx: [emerg] "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
2022/06/18 16:32:57 [emerg] 1#1: "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
nginx: [emerg] "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
2022/06/18 16:32:59 [emerg] 1#1: "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
nginx: [emerg] "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
2022/06/18 16:33:03 [emerg] 1#1: "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
nginx: [emerg] "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$

~~~~



- Editando o conf
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2/config/nginx.conf
- Criado app.conf
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2/config/app.conf

- Subindo de novo o docker-compose.
- Continuou com erro:
~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$ docker logs webserver
2022/06/18 16:37:55 [emerg] 1#1: "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
nginx: [emerg] "upstream" directive is not allowed here in /etc/nginx/nginx.conf:8
~~~~

- Provável problema de cache da imagem Docker.




- Usar o --no-cache
docker ps
docker-compose build --no-cache
docker-compose up -d
docker ps



- Containers sem erros:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$ docker ps
CONTAINER ID   IMAGE                                                COMMAND                  CREATED          STATUS                            PORTS                                                                              NAMES
70c95624bd09   fernandomj90/nginx-alpine-desafio-wordpress:3.15.4   "nginx -g 'daemon of…"   10 seconds ago   Up 8 seconds                      0.0.0.0:443->443/tcp, :::443->443/tcp, 0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   webserver
f79d90a5d491   docker-wordpress-editado-2_wordpress                 "/entrypoint.sh /usr…"   11 seconds ago   Up 9 seconds (health: starting)   0.0.0.0:80->80/tcp, :::80->80/tcp                                                  wordpress
7d0f979f73c3   mariadb:10.3                                         "docker-entrypoint.s…"   11 seconds ago   Up 10 seconds                     3306/tcp                                                                           db
4e0cc1b8a495   portainer/portainer                                  "/portainer"             7 days ago       Up 3 hours                        0.0.0.0:9000->9000/tcp, :::9000->9000/tcp                                          frosty_easley
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$
~~~~


- Porém a página do Wordpress não abre, usando a porta do NGINX:
http://192.168.0.113:8080/

Não foi possível conectar

O Firefox não conseguiu estabelecer uma conexão com o servidor 192.168.0.113:8080.
    Este site pode estar temporariamente fora do ar ou sobrecarregado. Tente de novo em alguns instantes.
    Se você não conseguir carregar nenhuma página, verifique a conexão de rede do computador.
    Se a rede ou o computador estiver protegido por um firewall ou proxy, verifique se o Firefox está autorizado a acessar a web.



# PENDENTE
- Seguir material do site abaixo, para configurar o NGINX de outra maneira, para comunicar com o PHP e o Wordpress:
    https://medium.com/swlh/wordpress-deployment-with-nginx-php-fpm-and-mariadb-using-docker-compose-55f59e5c1a
- Criado KB sobre o erro do MYSQL na porta 3306.
- Necessário separar os Containers do NGINX, PHP, no Wordpress do Alpine, no exemplo contido na pasta:
  /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2
- Necessário aplicar boas práticas.
- Avaliar se as imagens ficaram compactas.

- Diretório de trabalho:

cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2
docker-compose up -d
docker image ls | head

- Seguir material do site abaixo, para configurar o NGINX de outra maneira, para comunicar com o PHP e o Wordpress:
    https://medium.com/swlh/wordpress-deployment-with-nginx-php-fpm-and-mariadb-using-docker-compose-55f59e5c1a
- Tentar remover o ports "80:80" do container do Wordpress e usar a porta 9000 do FPM mesmo, usar o "8080:80" para o NGINX daí e testar.








# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# Dia 02/07/2022

- Subindo projeto:

cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2
docker-compose up -d
docker image ls | head
docker ps

- Comando para ver as portas:
netstat -plntu | grep 80

~~~~bash
fernando@debian10x64:~$ netstat -plntu | grep 80
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      -
tcp6       0      0 :::80                   :::*                    LISTEN      -
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ netstat -plntu | grep 3306
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
fernando@debian10x64:~$


netstat -plntu | grep 9000
fernando@debian10x64:~$ netstat -plntu | grep 9000
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp        0      0 0.0.0.0:9000            0.0.0.0:*               LISTEN      -
tcp6       0      0 :::9000                 :::*                    LISTEN      -
fernando@debian10x64:~$
~~~~


    ports:
      - "3306:3306"


- Subindo projeto:

cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2
docker-compose up -d
docker image ls | head
docker ps


- Seguiu expondo a 80 no Container do WORDPRESS e a 8080 no do NGINX:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$ docker ps
CONTAINER ID   IMAGE                                                COMMAND                  CREATED          STATUS                             PORTS                                                                                NAMES
bfcdad2c8c81   fernandomj90/nginx-alpine-desafio-wordpress:3.15.4   "nginx -g 'daemon of…"   50 seconds ago   Up 49 seconds                      0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp, 8080/tcp   webserver
6d8bc4e6896c   docker-wordpress-editado-2_wordpress                 "/entrypoint.sh /usr…"   51 seconds ago   Up 50 seconds (health: starting)   80/tcp, 0.0.0.0:9000->9000/tcp, :::9000->9000/tcp                                    wordpress
717d0db5cc2b   mariadb:10.3                                         "docker-entrypoint.s…"   51 seconds ago   Up 50 seconds                      0.0.0.0:3306->3306/tcp, :::3306->3306/tcp                                            db
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$
~~~~



- Ajustado EXPOSE no DOCKERFILE do Wordpress:
EXPOSE 9000
- Ajustado EXPOSE no DOCKERFILE do Nginx:
EXPOSE 80 443

- Mesmo com as portas ajustadas, seguiu com problema no acesso ao site:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$ docker ps
CONTAINER ID   IMAGE                                                COMMAND                  CREATED          STATUS                             PORTS                                                                      NAMES
d1146bb8aaed   fernandomj90/nginx-alpine-desafio-wordpress:3.15.4   "nginx -g 'daemon of…"   43 seconds ago   Up 42 seconds                      0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp   webserver
d9b541604f7a   docker-wordpress-editado-2_wordpress                 "/entrypoint.sh /usr…"   44 seconds ago   Up 42 seconds (health: starting)   0.0.0.0:9000->9000/tcp, :::9000->9000/tcp                                  wordpress
73f06c2b2fe9   mariadb:10.3                                         "docker-entrypoint.s…"   44 seconds ago   Up 43 seconds                      0.0.0.0:3306->3306/tcp, :::3306->3306/tcp                                  db
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$
~~~~




- Projeto da pasta: 
~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2

- Mesmo com os Expose ajustados e NGINX desacoplado do Dockerfile e Docker-compose original, não funcionou.
- É como se o Wordpress não funcionasse no Container do wordpress.

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/docker-wordpress-editado-2$ docker container exec -ti wordpress bash
bash-5.1# ls
index.php  plugins    themes
bash-5.1# curl localhost
curl: (7) Failed to connect to localhost port 80 after 0 ms: Connection refused
bash-5.1# curl localhost:9000
curl: (56) Recv failure: Connection reset by peer
bash-5.1#
~~~~





# NOVO PROJETO

- Efetuando o clone:
<https://github.com/krepysh-spec/lamp-docker-php-skeleton.git>

- Copiado para a pasta 2, para trabalhar nela:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5$ ls
alpine-php-wordpress  desafio-docker-questao5-wordpress  docker-wordpress  docker-wordpress-editado-2  lamp-docker-php-skeleton  wordpress-nginx-docker
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5$ cp -R lamp-docker-php-skeleton lamp-docker-php-skeleton-2
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5$
~~~~

- Subindo este projeto
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2
docker-compose up -d
docker image ls | head
docker ps


- DEU ERRO

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$ cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$ docker-compose up -d

ERROR: The Compose file './docker-compose.yml' is invalid because:
services.mysql.ports contains an invalid type, it should be a number, or an object
services.redis.ports contains an invalid type, it should be a number, or an object
services.nginx.ports contains an invalid type, it should be a number, or an object
services.redis-commander.ports contains an invalid type, it should be a number, or an object
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$
~~~~




    ports:
      - "${NGINX_PORT}:80"



- Faltava:
cp .env_example .env



- Subindo este projeto
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2
docker-compose up -d
docker image ls | head
docker ps



- Usar como base este projeto:

- Blog do Projeto:
<https://bestofphp.com/repo/krepysh-spec-lamp-docker-php-skeleton>

- Github do Projeto:
<https://github.com/krepysh-spec/lamp-docker-php-skeleton>

- Simplificar ao estilo deste:
<https://marcit.eu/en/2021/04/28/dockerize-webserver-nginx-php8/>

E DESTE, DO FIDELIS:
<https://www.nanoshots.com.br/2017/01/docker-containerizado-php7-fpm-nginx-e.html>
<https://github.com/msfidelis/CintoDeUtilidadesDocker/tree/master/Nginx-PHP7-FPM/Nginx>

- Depois criar Dockerfiles para o NGINX e PHP-FPM.
- Ver sobre instalar o Wordpress ou usar uma imagem pronta do Wordpress-PHP-FPM.

~~~~bash
2022-07-02 15:31:32+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server latest started.
2022-07-02 15:31:32+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
2022-07-02 15:31:32+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server latest started.
2022-07-02 15:31:32+00:00 [ERROR] [Entrypoint]: Database is uninitialized and password option is not specified
    You need to specify one of the following:
    - MYSQL_ROOT_PASSWORD
    - MYSQL_ALLOW_EMPTY_PASSWORD
    - MYSQL_RANDOM_ROOT_PASSWORD
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$
~~~~


- Ajustado .env

# MySQL
MYSQL_VERSION=latest
MYSQL_PORT=3306
MYSQL_DATABASE=skeleton_db
MYSQL_ROOT_USER=admin
MYSQL_ROOT_PASSWORD=teste
MYSQL_USER=usuario
MYSQL_PASSWORD=nemsei90



- Efetuado docker-compose up -d novamente:
docker-compose up -d

Recreating skeleton-mysql   ... done
Recreating skeleton-backend ... done


~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$ docker ps
CONTAINER ID   IMAGE                                    COMMAND                  CREATED         STATUS                   PORTS                                                  NAMES
f091c97ed0df   lamp-docker-php-skeleton-2_php           "docker-php-entrypoi…"   5 seconds ago   Up 4 seconds             9000/tcp                                               skeleton-backend
2be36c9579fd   mysql:latest                             "docker-entrypoint.s…"   5 seconds ago   Up 4 seconds             0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   skeleton-mysql
70c706d0ab53   nginx:latest                             "/docker-entrypoint.…"   3 minutes ago   Up 3 minutes             0.0.0.0:80->80/tcp, :::80->80/tcp                      skeleton-nginx
cba763a324af   lamp-docker-php-skeleton-2_supervisord   "docker-php-entrypoi…"   3 minutes ago   Up 3 minutes             0.0.0.0:9001->9001/tcp, :::9001->9001/tcp              skeleton-supervisord
85e631c26b05   rediscommander/redis-commander:latest    "/usr/bin/dumb-init …"   3 minutes ago   Up 3 minutes (healthy)   0.0.0.0:8081->8081/tcp, :::8081->8081/tcp              skeleton-redis-commander
fee666d8acc3   redis:latest                             "docker-entrypoint.s…"   3 minutes ago   Up 3 minutes             0.0.0.0:6379->6379/tcp, :::6379->6379/tcp              skeleton-redis
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$
~~~~


- Recriou o MYSQL e o BACKEND.


- Erro ao tentar abrir a página:
http://192.168.0.113/

~~~~bash
Warning: require_once(/var/www/html/public/../vendor/autoload.php): Failed to open stream: No such file or directory in /var/www/html/public/index.php on line 5

Fatal error: Uncaught Error: Failed opening required '/var/www/html/public/../vendor/autoload.php' (include_path='.:/usr/local/lib/php') in /var/www/html/public/index.php:5 Stack trace: #0 {main} thrown in /var/www/html/public/index.php on line 5
~~~~



- Faltava executar o make install
make install

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$ make install
SERVICES=$(command -v getent > /dev/null && echo "getent ahostsv4" || echo "dscacheutil -q host -a name"); \
if [ ! "$($SERVICES localhost | grep 127.0.0.1 > /dev/null; echo $?)" -eq 0 ]; then sudo bash -c 'echo "127.0.0.1 localhost" >> /etc/hosts; echo "Entry was added"'; else echo 'Entry already exists'; fi;
Entry already exists
nginx uses an image, skipping
redis uses an image, skipping
redis-commander uses an image, skipping
mysql uses an image, skipping
Building php
Sending build context to Docker daemon  4.608kB
Step 1/10 : FROM php:8.1-fpm
 ---> a8bdb3e99213
Step 2/10 : COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
[....]

Installing dependencies from lock file (including require-dev)
Verifying lock file contents can be installed on current platform.
Warning: The lock file is not up to date with the latest changes in composer.json. You may be getting outdated dependencies. It is recommended that you run `composer update` or `composer update <package name>`.
Nothing to install, update or remove
Generating autoload files
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$


fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$ docker ps
CONTAINER ID   IMAGE                                    COMMAND                  CREATED         STATUS                   PORTS                                                  NAMES
f091c97ed0df   lamp-docker-php-skeleton-2_php           "docker-php-entrypoi…"   5 minutes ago   Up 5 minutes             9000/tcp                                               skeleton-backend
2be36c9579fd   mysql:latest                             "docker-entrypoint.s…"   5 minutes ago   Up 5 minutes             0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   skeleton-mysql
70c706d0ab53   nginx:latest                             "/docker-entrypoint.…"   9 minutes ago   Up 9 minutes             0.0.0.0:80->80/tcp, :::80->80/tcp                      skeleton-nginx
cba763a324af   lamp-docker-php-skeleton-2_supervisord   "docker-php-entrypoi…"   9 minutes ago   Up 9 minutes             0.0.0.0:9001->9001/tcp, :::9001->9001/tcp              skeleton-supervisord
85e631c26b05   rediscommander/redis-commander:latest    "/usr/bin/dumb-init …"   9 minutes ago   Up 9 minutes (healthy)   0.0.0.0:8081->8081/tcp, :::8081->8081/tcp              skeleton-redis-commander
fee666d8acc3   redis:latest                             "docker-entrypoint.s…"   9 minutes ago   Up 9 minutes             0.0.0.0:6379->6379/tcp, :::6379->6379/tcp              skeleton-redis
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$ curl localhost:80 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Lamp Docker PHP skeleton</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
</head>
100 69534    0 69534    0     0  6790k      0 --:--:-- --:--:-- --:--:-- 6790k
curl: (23) Failed writing body (98 != 8192)
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$ curl localhost:80 | tail
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  118k    0  118k    0     0  16.5M      0 --:--:-- --:--:-- --:--:-- 14.4M
                    </ol>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
</body>
</html>
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2$

~~~~






# #############################################################################################
# PENDENTE

- Usar como base este projeto:
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2

- Blog do Projeto:
<https://bestofphp.com/repo/krepysh-spec-lamp-docker-php-skeleton>

- Github do Projeto:
<https://github.com/krepysh-spec/lamp-docker-php-skeleton>

- Simplificar ao estilo deste:
<https://marcit.eu/en/2021/04/28/dockerize-webserver-nginx-php8/>

E DESTE, DO FIDELIS:
<https://www.nanoshots.com.br/2017/01/docker-containerizado-php7-fpm-nginx-e.html>
<https://github.com/msfidelis/CintoDeUtilidadesDocker/tree/master/Nginx-PHP7-FPM/Nginx>

- Site com boas dicas para TSHOOT, análise e Dockerizar o Wordpress:
<https://www.howtoforge.com/tutorial/dockerizing-wordpress-with-nginx-and-php-fpm/>

- Depois criar Dockerfiles para o NGINX e PHP-FPM.
- Ver sobre instalar o Wordpress ou usar uma imagem pronta do Wordpress-PHP-FPM.
- Desacoplar REDIS e outras coisas extras que tem nesse projeto /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/lamp-docker-php-skeleton-2, que não são necessárias.
- Ou subir um projeto do Zero, simplista ao estilo deste(<https://marcit.eu/en/2021/04/28/dockerize-webserver-nginx-php8/>), ir criando o Dockerfile separado. Depois ver como instalar o Wordpress ou usar imagem pronta do Wordpress.
- Usar containers desacoplados.
- Aplicar boas práticas.
- Avaliar se as imagens ficaram compactas.
- Fazer boilerplates dos que funcionarem OK.

- Avaliar imagens do Wordpress com PHP-FPM:

Original, pesada:
wordpress:php8.1-fpm 
<https://hub.docker.com/layers/wordpress/library/wordpress/php8.1-fpm/images/sha256-f2472abf469e4bf2040ea245caf704cc8db1a1c0bc570e4ee2d98df137a8a46e?context=explore>
202.89 MB

Alpine mais leve
wordpress:php8.1-fpm-alpine
<https://hub.docker.com/layers/wordpress/library/wordpress/php8.1-fpm-alpine/images/sha256-650b02165fc8b38d2c773ba34694ac8e29957dfa0c8120a9d9f1df41c2e7cd77?context=explore>
96.97 MB

- Manual da Digital Ocean, que usa um Wordpress-FPM-Alpine de exemplo:
<https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-docker-compose-pt>








# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# Dia 03/07/2022

- Funcionou o projeto simples da pasta:
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/php-fpm-nginx-simples
Esse projeto usa um NGINX, com um arquivo index.php simples e um container separado para o PHP-FPM. Não tem banco de dados nesse projeto.

- Criado novo projeto, com base no simples:
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-3




# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# Digital Ocean - Como instalar o WordPress com o Docker Compose

- Manual da Digital Ocean, que usa um Wordpress-FPM-Alpine de exemplo:
<https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-docker-compose-pt>

- Diretório do projeto
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-3

- Passo 1 — Definindo as configurações do servidor Web
mkdir nginx-conf
touch nginx-conf/nginx.conf

- Passo 2 — Definindo as variáveis de ambiente
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-3
touch .env
vi .env

- Como seu arquivo .env contém informações confidenciais, você irá querer garantir que ele seja incluído nos arquivos .gitignore e .dockerignore, os quais dizem ao Git e ao Docker quais arquivos **não **copiar para os seus repositórios Git e imagens do Docker, respectivamente.
touch .gitignore
Adicione o .env ao arquivo:
vi .gitignore
.env

- De igual modo, como boa medida de precaução, adicione .env em um arquivo .dockerignore, para que ele não acabe nos seus contêineres quando estiver usando esse diretório como seu contexto de compilação.
Abra o arquivo:
touch .dockerignore
vi .dockerignore

Adicione o .env ao arquivo:
.env

Opcionalmente, abaixo disso você pode adicionar arquivos e diretórios associados ao desenvolvimento do seu aplicativo:
~/wordpress/.dockerignore

.env
.git
docker-compose.yml
.dockerignore


- Passo 3— Definindo serviços com o Docker Compose

Para começar, abra o arquivo docker-compose.yml:
touch docker-compose.yml

Adicione o seguinte código para definir sua versão do arquivo Compose e o serviço de banco de dados db:
~/wordpress/docker-compose.yml

~~~~yaml
version: '3'

services:
  db:
    image: mysql:8.0
    container_name: db
    restart: unless-stopped
    env_file: .env
    environment:
      - MYSQL_DATABASE=wordpress
    volumes:
      - dbdata:/var/lib/mysql
    command: '--default-authentication-plugin=mysql_native_password'
    networks:
      - app-network
~~~~



- Em seguida, abaixo de sua definição de serviço db, adicione a definição para seu serviço de aplicativo do wordpress:
~/wordpress/docker-compose.yml

~~~~yaml
...
  wordpress:
    depends_on:
      - db
    image: wordpress:5.1.1-fpm-alpine
    container_name: wordpress
    restart: unless-stopped
    env_file: .env
    environment:
      - WORDPRESS_DB_HOST=db:3306
      - WORDPRESS_DB_USER=$MYSQL_USER
      - WORDPRESS_DB_PASSWORD=$MYSQL_PASSWORD
      - WORDPRESS_DB_NAME=wordpress
    volumes:
      - wordpress:/var/www/html
    networks:
      - app-network
~~~~


Em seguida, abaixo da definição do serviço de aplicativo do wordpress, adicione a seguinte definição para seu serviço do Nginx webserver:
~/wordpress/docker-compose.yml

~~~~yaml
...
  webserver:
    depends_on:
      - wordpress
    image: nginx:1.15.12-alpine
    container_name: webserver
    restart: unless-stopped
    ports:
      - "80:80"
    volumes:
      - wordpress:/var/www/html
      - ./nginx-conf:/etc/nginx/conf.d
      - certbot-etc:/etc/letsencrypt
    networks:
      - app-network
~~~~


- Por fim, abaixo da definição de seu webserver, adicione sua última definição de serviço para o serviço do certbot. Certifique-se de substituir o endereço de e-mail e os nomes de domínio listados aqui por suas próprias informações:
~/wordpress/docker-compose.yml

~~~~yaml
  certbot:
    depends_on:
      - webserver
    image: certbot/certbot
    container_name: certbot
    volumes:
      - certbot-etc:/etc/letsencrypt
      - wordpress:/var/www/html
    command: certonly --webroot --webroot-path=/var/www/html --email sammy@example.com --agree-tos --no-eff-email --staging -d example.com -d www.example.com
~~~~

Essa definição diz ao Compose para obter a imagem certbot/certbot do Docker Hub. Ela também usa volumes nomeados para compartilhar recursos com o contêiner do Nginx, incluindo certificados de domínio e chave no certbot-etc e o código do aplicativo no wordpress.



- Abaixo da definição do serviço do certbot, adicione sua rede e definições de volume:
~/wordpress/docker-compose.yml

~~~~yaml
...
volumes:
  certbot-etc:
  wordpress:
  dbdata:

networks:
  app-network:
    driver: bridge  
~~~~



- Ajustado dominios para:
fernandomullerjr.site




- O arquivo final docker-compose.yml ficará parecido com o seguinte:
~/wordpress/docker-compose.yml

~~~~yaml
version: '3'

services:
  db:
    image: mysql:8.0
    container_name: db
    restart: unless-stopped
    env_file: .env
    environment:
      - MYSQL_DATABASE=wordpress
    volumes:
      - dbdata:/var/lib/mysql
    command: '--default-authentication-plugin=mysql_native_password'
    networks:
      - app-network

  wordpress:
    depends_on:
      - db
    image: wordpress:5.1.1-fpm-alpine
    container_name: wordpress
    restart: unless-stopped
    env_file: .env
    environment:
      - WORDPRESS_DB_HOST=db:3306
      - WORDPRESS_DB_USER=$MYSQL_USER
      - WORDPRESS_DB_PASSWORD=$MYSQL_PASSWORD
      - WORDPRESS_DB_NAME=wordpress
    volumes:
      - wordpress:/var/www/html
    networks:
      - app-network

  webserver:
    depends_on:
      - wordpress
    image: nginx:1.15.12-alpine
    container_name: webserver
    restart: unless-stopped
    ports:
      - "80:80"
    volumes:
      - wordpress:/var/www/html
      - ./nginx-conf:/etc/nginx/conf.d
      - certbot-etc:/etc/letsencrypt
    networks:
      - app-network

  certbot:
    depends_on:
      - webserver
    image: certbot/certbot
    container_name: certbot
    volumes:
      - certbot-etc:/etc/letsencrypt
      - wordpress:/var/www/html
    command: certonly --webroot --webroot-path=/var/www/html --email sammy@example.com --agree-tos --no-eff-email --staging -d example.com -d www.example.com

volumes:
  certbot-etc:
  wordpress:
  dbdata:

networks:
  app-network:
    driver: bridge  
~~~~

Salve e feche o arquivo quando você terminar a edição.



- Passo 4 — Obtendo certificados e credenciais SSL

Podemos iniciar nossos contêineres com o comando docker-compose up, que criará e executará nossos contêineres na ordem que especificamos. Se nossos pedidos de domínio forem bem sucedidos, veremos o status correto da saída no nosso resultado e os certificados corretos montados na pasta /etc/letsencrypt/live no contêiner do webserver.

Crie os contêineres com o docker-compose up e o sinalizador -d, os quais executarão os contêineres db, wordpress e webserver em segundo plano:
    docker-compose up -d

Com o uso do docker-compose ps, verifique o status dos seus serviços:
    docker-compose ps

Se tudo ocorreu bem, seus serviços db, wordpress e webserver devem estar Up e o contêiner certbot terá fechado com uma mensagem de status 0:

~~~bash
Output
  Name                 Command               State           Ports       
-------------------------------------------------------------------------
certbot     certbot certonly --webroot ...   Exit 0                      
db          docker-entrypoint.sh --def ...   Up       3306/tcp, 33060/tcp
webserver   nginx -g daemon off;             Up       0.0.0.0:80->80/tcp
wordpress   docker-entrypoint.sh php-fpm     Up       9000/tcp           
~~~



- Se você ver qualquer outra coisa além de Up na coluna State em relação aos serviços db, wordpress ou webserver ou um status de fechamento que não seja 0 em relação ao contêiner certbot, certifique-se de verificar os registros de serviço com o comando docker-compose logs:
    docker-compose logs service_name

Agora, é possível verificar se seus certificados foram instalados no contêiner webserver com o docker-compose exec:
    docker-compose exec webserver ls -la /etc/letsencrypt/live

Se os seus pedidos de certificado tiverem sido bem-sucedidos, verá um resultado como este:

~~~bash
Output
total 16
drwx------    3 root     root          4096 May 10 15:45 .
drwxr-xr-x    9 root     root          4096 May 10 15:45 ..
-rw-r--r--    1 root     root           740 May 10 15:45 README
drwxr-xr-x    2 root     root          4096 May 10 15:45 example.com
~~~




- PROBLEMAS

- Containers subiram.
- Apenas o container do certbot tá com o status de "Exit 1" ao invés de "Exit 0".

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-3$  docker-compose ps
  Name                 Command               State                 Ports
--------------------------------------------------------------------------------------
certbot     certbot certonly --webroot ...   Exit 1
db          docker-entrypoint.sh --def ...   Up       3306/tcp, 33060/tcp
webserver   nginx -g daemon off;             Up       0.0.0.0:80->80/tcp,:::80->80/tcp
wordpress   docker-entrypoint.sh php-fpm     Up       9000/tcp
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-3$ ^C
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-3$
~~~


- Não foram criados os certificados conforme o esperado:

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-3$ docker-compose exec webserver ls -la /etc/letsencrypt/live
ls: /etc/letsencrypt/live: No such file or directory
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-3$
~~~


docker-compose logs service_name
docker-compose logs certbot

- ERROS NO CERTBOT

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-3$ docker-compose logs certbot
Attaching to certbot
certbot      | Account registered.
certbot      | Requesting a certificate for fernandomullerjr.site and www.fernandomullerjr.site
certbot      |
certbot      | Certbot failed to authenticate some domains (authenticator: webroot). The Certificate Authority reported these problems:
certbot      |   Domain: fernandomullerjr.site
certbot      |   Type:   dns
certbot      |   Detail: DNS problem: SERVFAIL looking up A for fernandomullerjr.site - the domain's nameservers may be malfunctioning; DNS problem: SERVFAIL looking up AAAA for fernandomullerjr.site - the domain's nameservers may be malfunctioning
certbot      |
certbot      |   Domain: www.fernandomullerjr.site
certbot      |   Type:   dns
certbot      |   Detail: DNS problem: SERVFAIL looking up A for www.fernandomullerjr.site - the domain's nameservers may be malfunctioning; DNS problem: SERVFAIL looking up AAAA for www.fernandomullerjr.site - the domain's nameservers may be malfunctioning
certbot      |
certbot      | Hint: The Certificate Authority failed to download the temporary challenge files created by Certbot. Ensure that the listed domains serve their content from the provided --webroot-path/-w and that files created there can be downloaded from the internet.
certbot      |
certbot      | Saving debug log to /var/log/letsencrypt/letsencrypt.log
certbot      | Some challenges have failed.
certbot      | Ask for help or search for solutions at https://community.letsencrypt.org. See the logfile /var/log/letsencrypt/letsencrypt.log or re-run Certbot with -v for more details.
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-3$
~~~



- Comentadas as configurações sobre certbot no arquivo do docker-compose:
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-3/docker-compose.yml


- Efetuado down e up no projeto
docker-compose down
docker ps
docker-compose up -d


- Containers OK

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-3$ docker ps
CONTAINER ID   IMAGE                        COMMAND                  CREATED         STATUS         PORTS                               NAMES
1e707c178d65   nginx:1.15.12-alpine         "nginx -g 'daemon of…"   7 minutes ago   Up 7 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp   webserver
21430f62a145   wordpress:5.1.1-fpm-alpine   "docker-entrypoint.s…"   7 minutes ago   Up 7 minutes   9000/tcp                            wordpress
3e57b70ca6a9   mysql:8.0                    "docker-entrypoint.s…"   7 minutes ago   Up 7 minutes   3306/tcp, 33060/tcp                 db
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-3$
~~~

- Usuario e senha:
teste
Htd&ZUfVDGD@PGaMAk
- Página acessível
- Criado boilerplate:
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/boilerplates/wordpress-php-fpm-alpine-nginx-OK





# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# UPGRADE DE VERSÕES DO NGINX E WORDPRESS - Digital Ocean

- Testar upgrade de versoes, primeiro.
DE:
wordpress:5.1.1-fpm-alpine
PARA
wordpress:php8.1-fpm-alpine

- Subindo:
docker-compose up -d

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker ps
CONTAINER ID   IMAGE                         COMMAND                  CREATED          STATUS          PORTS                               NAMES
2c0e38beec11   nginx:1.15.12-alpine          "nginx -g 'daemon of…"   12 seconds ago   Up 4 seconds    0.0.0.0:80->80/tcp, :::80->80/tcp   webserver
c8bcb03595f4   wordpress:php8.1-fpm-alpine   "docker-entrypoint.s…"   13 seconds ago   Up 12 seconds   9000/tcp                            wordpress
bdaefbe437ed   mysql:8.0                     "docker-entrypoint.s…"   14 seconds ago   Up 13 seconds   3306/tcp, 33060/tcp                 db
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$
~~~

- Acessível:
http://192.168.0.113:80/
teste
T7GS*OZpg$k1Jrb#Ql
http://192.168.0.113/


- Efetuando desligamento dos containers:
docker-compose down


- Atualizando NGINX
DE:
nginx:1.15.12-alpine
PARA:
nginx:1.23.0-alpine


~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker-compose up -d
Creating network "wordpress-php-fpm-alpine-nginx-4_app-network" with driver "bridge"
Pulling webserver (nginx:1.23.0-alpine)...
1.23.0-alpine: Pulling from library/nginx
2408cc74d12b: Already exists
dd61fcc63eac: Pull complete
f9686e628075: Pull complete
ceb5504faee7: Pull complete
ce5d272a5b4f: Pull complete
136e07b65aca: Pull complete
Digest: sha256:8e38930f0390cbd79b2d1528405fb17edcda5f4a30875ecf338ebaa598dc994e
Status: Downloaded newer image for nginx:1.23.0-alpine
Creating db ... done
Creating wordpress ... done
Creating webserver ... done
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker ps
CONTAINER ID   IMAGE                         COMMAND                  CREATED          STATUS         PORTS                               NAMES
de73c699c230   nginx:1.23.0-alpine           "/docker-entrypoint.…"   9 seconds ago    Up 7 seconds   0.0.0.0:80->80/tcp, :::80->80/tcp   webserver
c5015b89e32b   wordpress:php8.1-fpm-alpine   "docker-entrypoint.s…"   10 seconds ago   Up 8 seconds   9000/tcp                            wordpress
f1069f7c3350   mysql:8.0                     "docker-entrypoint.s…"   10 seconds ago   Up 9 seconds   3306/tcp, 33060/tcp                 db
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$
~~~

- Acessível
http://192.168.0.113/
Não precisou instalar wordpress, devido o volume, acredito.


- Imagens atuais

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker image ls | grep "1.23.0-alpine"
nginx                                                                           1.23.0-alpine        f246e6f9d0b2   10 days ago     23.5MB
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$

fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker image ls | grep "php8.1-fpm-alpine"
wordpress                                                                       php8.1-fpm-alpine    ee48600d8b6c   3 weeks ago     305MB
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$

~~~

- TUDO FUNCIONANDO OK ATÉ AQUI!
- TUDO FUNCIONANDO OK ATÉ AQUI!
- TUDO FUNCIONANDO OK ATÉ AQUI!
- TUDO FUNCIONANDO OK ATÉ AQUI!
- TUDO FUNCIONANDO OK ATÉ AQUI!








# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# ####################################################################################################################################################################
# IMAGENS - Melhoria do tamanho

- Melhorar tamanho da imagem do WORDPRESS.
Original é:
96.97 MB
Atual está com:
305MB


- Exemplo do Rotten

  webserver:
    build:
      context: nginx
      dockerfile: Dockerfile
    image: fernandomj90/nginx-alpine-desafio-docker:3.15.4
    container_name: webserver



- Editando o docker-compose do WORDPRESS:
    build:
      context: ./setup/wordpress-php-fpm
      dockerfile: Dockerfile-wordpress-php-fpm-alpine
    image: fernandomj90/wordpress-php8.1-fpm-alpine:v1


- Editando o Dockerfile:

~~~~Dockerfile
FROM wordpress:php8.1-fpm-alpine

RUN echo "teste"

CMD ["php-fpm"]
~~~~

- Parando e subindo projeto:
docker-compose down
docker-compose up -d

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker ps
CONTAINER ID   IMAGE                                         COMMAND                  CREATED          STATUS          PORTS                               NAMES
910c0416d719   nginx:1.23.0-alpine                           "/docker-entrypoint.…"   17 seconds ago   Up 16 seconds   0.0.0.0:80->80/tcp, :::80->80/tcp   webserver
9ac3554b258e   fernandomj90/wordpress-php8.1-fpm-alpine:v1   "docker-entrypoint.s…"   18 seconds ago   Up 17 seconds   9000/tcp                            wordpress-php-fpm-alpine
16b599e89150   mysql:8.0                                     "docker-entrypoint.s…"   18 seconds ago   Up 18 seconds   3306/tcp, 33060/tcp                 db
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker image ls | head
REPOSITORY                                                                      TAG                  IMAGE ID       CREATED          SIZE
fernandomj90/wordpress-php8.1-fpm-alpine                                        v1                   6922c94c8ea4   24 seconds ago   305MB
~~~

- Imagem do Wordpress seguiu um pouco pesada.





- Criado Dockerfile.

- Buildando
docker-compose build --no-cache
docker-compose up -d


~~~bash
Removing intermediate container b5473fe37479
 ---> 5d1eb9b0e02b
Step 11/18 : RUN apk add php8-common php8-session php8-iconv php8-json php8-gd php8-curl php8-xml php8-mysqli php8-imap php8-cgi fcgi php8-pdo php8-pdo_mysql php8-soap php8-xmlrpc php8-posix php8-mcrypt php8-gettext php8-ldap php8-ctype php8-dom php8-simplexml
 ---> Running in d70d195b9f7c
  php8-mcrypt (no such package):
ERROR: unable to select packages:
    required by: world[php8-mcrypt]
  php8-xmlrpc (no such package):
    required by: world[php8-xmlrpc]
The command '/bin/sh -c apk add php8-common php8-session php8-iconv php8-json php8-gd php8-curl php8-xml php8-mysqli php8-imap php8-cgi fcgi php8-pdo php8-pdo_mysql php8-soap php8-xmlrpc php8-posix php8-mcrypt php8-gettext php8-ldap php8-ctype php8-dom php8-simplexml' returned a non-zero code: 2
ERROR: Service 'wordpress' failed to build : Build failed
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker-compose up -d
~~~


Mcrypt has been deprecated in PHP 7.2, so it's not available by default. You can still install the mcrypt extension using pecl.

Removendo:
php8-mcrypt

DE:
php8-xmlrpc
PARA:
php8-pecl-xmlrpc



- Buildando
docker-compose build --no-cache
docker-compose up -d


~~~bash
Step 11/18 : RUN apk add php8-common php8-session php8-iconv php8-json php8-gd php8-curl php8-xml php8-mysqli php8-imap php8-cgi fcgi php8-pdo php8-pdo_mysql php8-soap php8-pecl-xmlrpc php8-posix php8-gettext php8-ldap php8-ctype php8-dom php8-simplexml
 ---> Running in c2689cb18522
ERROR: unable to select packages:
  php8-pecl-xmlrpc (no such package):
    required by: world[php8-pecl-xmlrpc]
The command '/bin/sh -c apk add php8-common php8-session php8-iconv php8-json php8-gd php8-curl php8-xml php8-mysqli php8-imap php8-cgi fcgi php8-pdo php8-pdo_mysql php8-soap php8-pecl-xmlrpc php8-posix php8-gettext php8-ldap php8-ctype php8-dom php8-simplexml' returned a non-zero code: 1
ERROR: Service 'wordpress' failed to build : Build failed
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$
~~~


Removendo:
php8-pecl-xmlrpc



Step 12/18 : RUN mkdir /var/www/html
 ---> Running in 1cdf14511526
mkdir: can't create directory '/var/www/html': No such file or directory
The command '/bin/sh -c mkdir /var/www/html' returned a non-zero code: 1
ERROR: Service 'wordpress' failed to build : Build failed
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$



RUN mkdir -p /var/www/html
RUN mkdir -p /usr/src/wordpress/


- Buildando
docker-compose build --no-cache
docker-compose up -d



Step 17/18 : COPY --from=base /var/www/html /var/www/html
 ---> 69cff46834a0
Step 18/18 : CMD ["php-fpm"]
 ---> Running in 7942d4bf7c13
Removing intermediate container 7942d4bf7c13
 ---> de0baf24cf9c
Successfully built de0baf24cf9c
Successfully tagged fernandomj90/wordpress-php8.1-fpm-alpine:v1
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$



fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker image ls | head
REPOSITORY                                                                      TAG                  IMAGE ID       CREATED              SIZE
fernandomj90/wordpress-php8.1-fpm-alpine                                        v1                   de0baf24cf9c   21 seconds ago       198MB



CMD ["php-fpm"]
CMD ["php8-fpm"]


fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker-compose up -d
db is up-to-date
Recreating wordpress-php-fpm-alpine ... error

ERROR: for wordpress-php-fpm-alpine  Cannot start service wordpress: OCI runtime create failed: container_linux.go:380: starting container process caused: exec: "php8-fpm": executable file not found in $PATH: unknown

ERROR: for wordpress  Cannot start service wordpress: OCI runtime create failed: container_linux.go:380: starting container process caused: exec: "php8-fpm": executable file not found in $PATH: unknown
ERROR: Encountered errors while bringing up the project.
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$




CMD ["php8-fpm"]
CMD ["php-fpm8"]


- Buildando
docker-compose build --no-cache
docker-compose up -d

- ERRO
- Container do wordpress reiniciando:


fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker ps
CONTAINER ID   IMAGE                                         COMMAND                  CREATED         STATUS                          PORTS                               NAMES
30150766879a   nginx:1.23.0-alpine                           "/docker-entrypoint.…"   3 minutes ago   Up 3 minutes                    0.0.0.0:80->80/tcp, :::80->80/tcp   webserver
c9cccf4b7050   fernandomj90/wordpress-php8.1-fpm-alpine:v1   "php-fpm8"               3 minutes ago   Restarting (0) 12 seconds ago                                       wordpress-php-fpm-alpine
21a3a7ef0961   mysql:8.0                                     "docker-entrypoint.s…"   3 minutes ago   Up 3 minutes                    3306/tcp, 33060/tcp                 db
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker logs wordpress-php-fpm-alpine
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$

- Sem logs de erros.


- Alterando DOCKERFILE.
- Trocado Alpine por uma imagem do PHP baseada em Alpine.

DE:
alpine:3.16.0
PARA:
php:8.1-fpm-alpine3.16


- Buildando
docker-compose build --no-cache
docker-compose up -d


fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker-compose up -d
Creating network "wordpress-php-fpm-alpine-nginx-4_app-network" with driver "bridge"
Creating db ... done
Creating wordpress-php-fpm-alpine ... done
Creating webserver                ... done
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker ps
CONTAINER ID   IMAGE                                         COMMAND                  CREATED         STATUS         PORTS                               NAMES
902838de3ab5   nginx:1.23.0-alpine                           "/docker-entrypoint.…"   6 seconds ago   Up 2 seconds   0.0.0.0:80->80/tcp, :::80->80/tcp   webserver
801cd9530bb0   fernandomj90/wordpress-php8.1-fpm-alpine:v1   "docker-php-entrypoi…"   6 seconds ago   Up 5 seconds   9000/tcp                            wordpress-php-fpm-alpine
af53224bdcc1   mysql:8.0                                     "docker-entrypoint.s…"   7 seconds ago   Up 6 seconds   3306/tcp, 33060/tcp                 db
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ ^C
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ ^C



fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$ docker image ls | head
REPOSITORY                                                                      TAG                  IMAGE ID       CREATED              SIZE
fernandomj90/wordpress-php8.1-fpm-alpine                                        v1                   38d6d2387546   About a minute ago   245MB



- ERRO

Fatal error: Uncaught Error: Call to undefined function mysql_connect() in /var/www/html/wp-includes/wp-db.php:1788 Stack trace: #0 /var/www/html/wp-includes/wp-db.php(724): wpdb->db_connect() #1 /var/www/html/wp-includes/load.php(561): wpdb->__construct('fernandomuller', 'senhafraca123', 'wordpress', 'db:3306') #2 /var/www/html/wp-settings.php(124): require_wp_db() #3 /var/www/html/wp-config.php(133): require_once('/var/www/html/w...') #4 /var/www/html/wp-load.php(50): require_once('/var/www/html/w...') #5 /var/www/html/wp-blog-header.php(13): require_once('/var/www/html/w...') #6 /var/www/html/index.php(17): require('/var/www/html/w...') #7 {main} thrown in /var/www/html/wp-includes/wp-db.php on line 1788



Francesco
(@fcolombo)
3 years, 7 months ago
For what is worth, I encountered the same error and the issue was solved by enabling the nd_mysqli extension in the PHP 7 configuration, and disabling the mysqli one.


DE:
RUN apk add php8-common php8-session php8-iconv php8-json php8-gd php8-curl php8-xml php8-mysqli php8-imap php8-cgi fcgi php8-pdo php8-pdo_mysql php8-soap php8-posix php8-gettext php8-ldap php8-ctype php8-dom php8-simplexml

PARA:
RUN apk add php8-common php8-session php8-iconv php8-json php8-gd php8-curl php8-xml php8-mysqlnd php8-imap php8-cgi fcgi php8-pdo php8-pdo_mysql php8-soap php8-posix php8-gettext php8-ldap php8-ctype php8-dom php8-simplexml


- Buildando
docker-compose down
docker-compose build --no-cache
docker-compose up -d

- Entrando no container do Wordpress
docker container exec -ti wordpress-php-fpm-alpine  bash


/usr/src/wordpress/




Fatal error: Uncaught Error: Call to undefined function mysql_connect() in /var/www/html/wp-includes/wp-db.php:1788 Stack trace: #0 /var/www/html/wp-includes/wp-db.php(724): wpdb->db_connect() #1 /var/www/html/wp-includes/load.php(561): wpdb->__construct('fernandomuller', 'senhafraca123', 'wordpress', 'db:3306') #2 /var/www/html/wp-settings.php(124): require_wp_db() #3 /var/www/html/wp-config.php(133): require_once('/var/www/html/w...') #4 /var/www/html/wp-load.php(50): require_once('/var/www/html/w...') #5 /var/www/html/wp-blog-header.php(13): require_once('/var/www/html/w...') #6 /var/www/html/index.php(17): require('/var/www/html/w...') #7 {main} thrown in /var/www/html/wp-includes/wp-db.php on line 1788



DE:
RUN apk add php8-common php8-session php8-iconv php8-json php8-gd php8-curl php8-xml php8-mysqlnd php8-imap php8-cgi fcgi php8-pdo php8-pdo_mysql php8-soap php8-posix php8-gettext php8-ldap php8-ctype php8-dom php8-simplexml
PARA:
RUN apk add php8-common php8-session php8-iconv php8-json php8-gd php8-curl php8-xml php8-mysqlnd php8-mysqli php8-imap php8-cgi fcgi php8-pdo php8-pdo_mysql php8-soap php8-posix php8-gettext php8-ldap php8-ctype php8-dom php8-simplexml




    Please find my php.dockerfile here-with. I have already enabled mysqli and nd_mysql

    FROM php:7.2-fpm-alpine
      
    RUN docker-php-ext-install nd_mysqli pdo pdo_mysql && docker-php-ext-enable nd_mysqli

Viewing 2 replies - 1 through 2 (of 2 total)

    The topic ‘[Docker] Uncaught Error: Call to undefined function mysql_connect()’ is closed to new replies.


- Buildando
docker-compose down
docker-compose build --no-cache
docker-compose up -d




Step 10/18 : RUN docker-php-ext-install nd_mysqli pdo pdo_mysql && docker-php-ext-enable nd_mysqli
 ---> Running in 9a242ad9ac3c
error: /usr/src/php/ext/nd_mysqli does not exist

usage: /usr/local/bin/docker-php-ext-install [-jN] [--ini-name file.ini] ext-name [ext-name ...]
   ie: /usr/local/bin/docker-php-ext-install gd mysqli
       /usr/local/bin/docker-php-ext-install pdo pdo_mysql
       /usr/local/bin/docker-php-ext-install -j5 gd mbstring mysqli pdo pdo_mysql shmop

if custom ./configure arguments are necessary, see docker-php-ext-configure

Possible values for ext-name:
bcmath bz2 calendar ctype curl dba dl_test dom enchant exif ffi fileinfo filter ftp gd gettext gmp hash iconv imap intl json ldap mbstring mysqli oci8 odbc opcache pcntl pdo pdo_dblib pdo_firebird pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell readline reflection session shmop simplexml snmp soap sockets sodium spl standard sysvmsg sysvsem sysvshm tidy tokenizer xml xmlreader xmlwriter xsl zend_test zip

Some of the above modules are already compiled into PHP; please check
the output of "php -i" to see which modules are already loaded.
The command '/bin/sh -c docker-php-ext-install nd_mysqli pdo pdo_mysql && docker-php-ext-enable nd_mysqli' returned a non-zero code: 1
ERROR: Service 'wordpress' failed to build : Build failed
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/wordpress-php-fpm-alpine-nginx-4$



DE:
RUN docker-php-ext-install nd_mysqli pdo pdo_mysql && docker-php-ext-enable nd_mysqli
PARA:



- Buildando
docker-compose down
docker-compose build --no-cache
docker-compose up -d


Fatal error: Uncaught Error: Call to undefined function mysql_connect() in /var/www/html/wp-includes/wp-db.php:1788 Stack trace: #0 /var/www/html/wp-includes/wp-db.php(724): wpdb->db_connect() #1 /var/www/html/wp-includes/load.php(561): wpdb->__construct('fernandomuller', 'senhafraca123', 'wordpress', 'db:3306') #2 /var/www/html/wp-settings.php(124): require_wp_db() #3 /var/www/html/wp-config.php(133): require_once('/var/www/html/w...') #4 /var/www/html/wp-load.php(50): require_once('/var/www/html/w...') #5 /var/www/html/wp-blog-header.php(13): require_once('/var/www/html/w...') #6 /var/www/html/index.php(17): require('/var/www/html/w...') #7 {main} thrown in /var/www/html/wp-includes/wp-db.php on line 1788




- Entrando no container do Wordpress
docker container exec -ti wordpress-php-fpm-alpine  bash


bash-5.1# cat wp-config.php | grep -i sql
define( 'DB_HOST', getenv_docker('WORDPRESS_DB_HOST', 'mysql') );
bash-5.1#



bash-5.1# pwd
/var/www/html
bash-5.1# cat /etc/php8/php.ini | grep -i sql
;   extension=mysqli
;   extension=/path/to/extension/mysqli.so
;extension=mysqli
;extension=pdo_mysql
;extension=pdo_pgsql
;extension=pdo_sqlite
;extension=pgsql
;extension=sqlite3
[sqlite3]
; Directory pointing to SQLite3 extensions
; http://php.net/sqlite3.extension-dir
;sqlite3.extension_dir =
; SQLite defensive mode flag (only available from SQLite 3.26+)
; SQL to deliberately corrupt the database file are disabled. This forbids
; the sqlite_dbpage virtual table.
; https://www.sqlite.org/c3ref/c_dbconfig_defensive.html
; (for older SQLite versions, this flag has no use)
;sqlite3.defensive = 1
[Pdo_mysql]
; Default socket name for local MySQL connects.  If empty, uses the built-in
; MySQL defaults.
pdo_mysql.default_socket=
; Default: SQL_CURSOR_STATIC (default).
[MySQLi]
; http://php.net/mysqli.max-persistent
mysqli.max_persistent = -1
; http://php.net/mysqli.allow_local_infile
;mysqli.allow_local_infile = On
; http://php.net/mysqli.allow-persistent
mysqli.allow_persistent = On
; http://php.net/mysqli.max-links
mysqli.max_links = -1
; Default port number for mysqli_connect().  If unset, mysqli_connect() will use
; the $MYSQL_TCP_PORT or the mysql-tcp entry in /etc/services or the
; compile-time value defined MYSQL_PORT (in that order).  Win32 will only look
; at MYSQL_PORT.
; http://php.net/mysqli.default-port
mysqli.default_port = 3306
; Default socket name for local MySQL connects.  If empty, uses the built-in
; MySQL defaults.
; http://php.net/mysqli.default-socket
mysqli.default_socket =
; Default host for mysqli_connect() (doesn't apply in safe mode).
; http://php.net/mysqli.default-host
mysqli.default_host =
; Default user for mysqli_connect() (doesn't apply in safe mode).
; http://php.net/mysqli.default-user
mysqli.default_user =
; Default password for mysqli_connect() (doesn't apply in safe mode).
; *Any* user with PHP access can run 'echo get_cfg_var("mysqli.default_pw")
; http://php.net/mysqli.default-pw
mysqli.default_pw =
mysqli.reconnect = Off
[mysqlnd]
; Enable / Disable collection of general statistics by mysqlnd which can be
; used to tune and monitor MySQL operations.
mysqlnd.collect_statistics = On
; Enable / Disable collection of memory usage statistics by mysqlnd which can be
; used to tune and monitor MySQL operations.
mysqlnd.collect_memory_statistics = Off
; Records communication from all extensions using mysqlnd to the specified log
; http://php.net/mysqlnd.debug
;mysqlnd.debug =
;mysqlnd.log_mask = 0
; Default size of the mysqlnd memory pool, which is used by result sets.
;mysqlnd.mempool_default_size = 16000
; Size of a pre-allocated buffer used when sending commands to MySQL in bytes.
;mysqlnd.net_cmd_buffer_size = 2048
;mysqlnd.net_read_buffer_size = 32768
;mysqlnd.net_read_timeout = 31536000
; SHA-256 Authentication Plugin related. File with the MySQL server public RSA
;mysqlnd.sha256_server_public_key =
[PostgreSQL]
; http://php.net/pgsql.allow-persistent
pgsql.allow_persistent = On
; http://php.net/pgsql.auto-reset-persistent
pgsql.auto_reset_persistent = Off
; http://php.net/pgsql.max-persistent
pgsql.max_persistent = -1
; http://php.net/pgsql.max-links
pgsql.max_links = -1
; Ignore PostgreSQL backends Notice message or not.
; http://php.net/pgsql.ignore-notice
pgsql.ignore_notice = 0
; Log PostgreSQL backends Notice message or not.
; Unless pgsql.ignore_notice=0, module cannot log notice message.
; http://php.net/pgsql.log-notice
pgsql.log_notice = 0
bash-5.1#





- 

RUN docker-php-ext-install pdo pdo_mysql && docker-php-ext-enable pdo_mysql
COPY ./php.ini /etc/php8/php.ini


- Buildando
docker-compose down
docker-compose build --no-cache
docker-compose up -d


- Entrando no container do Wordpress
docker container exec -ti wordpress-php-fpm-alpine bash

- Efetuado ajuste no php.ini, ativando algumas extensões.
- Segue com errro:

~~~~bash
Fatal error: Uncaught Error: Call to undefined function mysql_connect() in /var/www/html/wp-includes/wp-db.php:1788 Stack trace: #0 /var/www/html/wp-includes/wp-db.php(724): wpdb->db_connect() #1 /var/www/html/wp-includes/load.php(561): wpdb->__construct('fernandomuller', 'senhafraca123', 'wordpress', 'db:3306') #2 /var/www/html/wp-settings.php(124): require_wp_db() #3 /var/www/html/wp-config.php(133): require_once('/var/www/html/w...') #4 /var/www/html/wp-load.php(50): require_once('/var/www/html/w...') #5 /var/www/html/wp-blog-header.php(13): require_once('/var/www/html/w...') #6 /var/www/html/index.php(17): require('/var/www/html/w...') #7 {main} thrown in /var/www/html/wp-includes/wp-db.php on line 1788
~~~~



- No upgrade do Dockerfile, para usar Multistage, é obtido pouco ganho no tamanho da imagem:
DE:
PARA:
245MB
- E também ocorre o erro do mysql_connect() na página.
- Pode ser averiguado o motivo, talvez seja no código do WP ou no PHP(arquivos ini, conf, etc)


- Boilerplate OK do WORDPRESS+NGINX+MYSQL com versões atualizadas:
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/boilerplates/wordpress-php-fpm-alpine-nginx-OK-atualizadas


- Buildando
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/boilerplates/wordpress-php-fpm-alpine-nginx-OK-atualizadas
docker-compose down
docker-compose build --no-cache
docker-compose up -d


- IMAGEM FICOU EM 305MB
~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao5/boilerplates/wordpress-php-fpm-alpine-nginx-OK-atualizadas$ docker image ls | grep "php8.1-fpm-alpine"
fernandomj90/wordpress-php8.1-fpm-alpine                                        v1                   8658095aa795   15 minutes ago   245MB
wordpress                                                                       php8.1-fpm-alpine    ee48600d8b6c   3 weeks ago      305MB
~~~~



# RESPOSTA
- Entregar o boilerplate
- Boilerplate OK do WORDPRESS+NGINX+MYSQL com versões atualizadas:
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao5/boilerplates/wordpress-php-fpm-alpine-nginx-OK-atualizadas
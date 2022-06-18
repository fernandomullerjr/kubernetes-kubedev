
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
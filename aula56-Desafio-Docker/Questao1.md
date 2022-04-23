


# #########################################################################################################################################
#  Questão 01

Execute os comandos para criar os 4 bancos de dados listados com containers, e use como se tivesse instalado eles localmente na sua máquina (Não esquece de garantir
que não vai perder os dados caso o container seja excluido).
    MongoDB
    MariaDB
    PostgreSQL
    Redis




# #########################################################################################################################################
#  MongoDB

- Criar Container passando variaveis, atrelando volume e atrelando uma network.

docker container run -d -e MONGO_INITDB_ROOT_USERNAME=mongouser -e MONGO_INITDB_ROOT_PASSWORD=mongopwd -v mongo_vol:/data/db -p 27017:27017 --network produto_network --name mongodb mongo:4.4.3

- Detalhes sobre as variaveis e exemplos, obter no Docker Hub do Mongo Express:
<https://hub.docker.com/_/mongo-express>

- Criar uma network
docker network create network_desafio_docker

- Resposta da questão 1 para o MongoDB:
~~~bash
docker container run -d -e MONGO_INITDB_ROOT_USERNAME=mongouser -e MONGO_INITDB_ROOT_PASSWORD=mongopwd -v volume_desafio_docker_mongodb:/data/db -p 27017:27017 --network network_desafio_docker --name mongodb mongo:4.4.3
~~~




# #########################################################################################################################################
#  MariaDB

- Docker Hub do MariaDB:
<https://hub.docker.com/_/mariadb>

- Exemplo de comando:
docker run --detach --network some-network --name some-mariadb --env MARIADB_USER=example-user --env MARIADB_PASSWORD=my_cool_secret --env MARIADB_ROOT_PASSWORD=my-secret-pw  mariadb:latest

 The -d flag enables detached mode

- Criando comando para o MariaDB:
~~~bash
docker container run --detach --network network_desafio_docker --name desafio-docker-mariadb --env MARIADB_USER=example-user --env MARIADB_PASSWORD=my_cool_secret --env MARIADB_ROOT_PASSWORD=my-secret-pw  mariadb:latest
~~~

- Funcionou
~~~bash
fernando@debian10x64:~/cursos/kubedev$ docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED         STATUS         PORTS      NAMES
8a0f9e81f23a   mariadb:latest   "docker-entrypoint.s…"   6 minutes ago   Up 6 minutes   3306/tcp   desafio-docker-mariadb
fernando@debian10x64:~/cursos/kubedev$ ^C
~~~

- Resposta da questão 1 para o MariaDB, com volume e portas especificados:
-v volume_desafio_docker_mongodb:/data/db
~~~bash
docker container run --detach --network network_desafio_docker --name desafio-docker-mariadb --env MARIADB_USER=example-user --env MARIADB_PASSWORD=my_cool_secret --env MARIADB_ROOT_PASSWORD=my-secret-pw -p 3560:3306 -v volume_desafio_docker_mariadb:/data/db mariadb:latest
~~~

- Testes
validando se a persistencia de dados no Volume está ocorrendo conforme o esperado
docker container exec -ti desafio-docker-mariadb bash

root@00cc7b89a38c:/# cd /data/db/
root@00cc7b89a38c:/data/db# ls
teste1.txt
root@00cc7b89a38c:/data/db# date
Sat Apr 23 14:31:43 UTC 2022
root@00cc7b89a38c:/data/db#





# #########################################################################################################################################
#  PostgreSQL

- Exemplo:
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres

- Comando editado:
~~~bash
docker container run --detach --network network_desafio_docker --name desafio-docker-postgres POSTGRES_PASSWORD=mysecretpassword postgres
~~~

- Variáveis de ambiente:
<https://towardsdatascience.com/getting-started-with-postgres-in-docker-616127e2e46d>
POSTGRES_HOST=my_db
POSTGRES_USER=fernando
POSTGRES_PASSWORD=mysecretpassword
POSTGRES_DB=my_project_db

- Comando editado, resposta da questão 1 para o PostgreSQL:
~~~bash
docker container run --detach --network network_desafio_docker --name desafio-docker-postgres --env POSTGRES_HOST=my_db --env POSTGRES_USER=fernando --env POSTGRES_PASSWORD=mysecretpassword --env POSTGRES_DB=my_project_db -p 54321:5432 -v volume_desafio_docker_postgres:/data/db postgres
~~~




# #########################################################################################################################################
#  Redis

- Exemplo:
<https://hub.docker.com/_/redis>

start a redis instance
$ docker run --name some-redis -d redis

start with persistent storage
$ docker run --name some-redis -d redis redis-server --save 60 1 --loglevel warning


- Site do Redis
<https://redis.io/docs/stack/get-started/install/docker/>

redis/redis-stack-server
To start Redis Stack server using the redis-stack-server image, run the following command in your terminal:
    docker run -d --name redis-stack-server -p 6379:6379 redis/redis-stack-server:latest

redis/redis-stack
To start Redis Stack developer container using the redis-stack image, run the following command in your terminal:
    docker run -d --name redis-stack -p 6379:6379 -p 8001:8001 redis/redis-stack:latest



- Comando editado, resposta da questão 1 Redis:
~~~bash
docker container run --detach --network network_desafio_docker --name desafio-docker-redis -p 6379:6379 -v volume_desafio_docker_redis:/data/db redis
~~~
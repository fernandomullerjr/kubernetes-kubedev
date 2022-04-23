
# #########################################################################################################################################
# Questão 02

Certo, você conseguiu criar 4 bancos na sua máquina utilizando containers. Mas tem uma coisa, não adianta só conectar a aplicação no banco quando se está
desenvolvendo, é preciso também acessar o banco, executar comandos e consultar a base. Então vamos fazer isso da forma KubeDev de ser, com containers !!! Cada banco
de dados tem uma ferramenta administrativa com interface web que você pode usar.
    
    MongoDB ⇒ Mongo Express
    <https://github.com/mongo-express/mongo-express>
    MariaDB ⇒ phpmyadmin
    PostgreSQL ⇒ PgAdmin
    Redis ⇒ redis-commander



# #########################################################################################################################################
# MongoDB ⇒ Mongo Express

-Exemplo:
    $ docker run -it --rm -p 8081:8081 --network some-network mongo-express
    docker run -it --rm -p 8081:8081 --network network_desafio_docker mongo-express

- ERROS
~~~bash
fernando@debian10x64:~/cursos/kubedev$ docker run -it --rm -p 8081:8081 --network network_desafio_docker mongo-express
Unable to find image 'mongo-express:latest' locally
latest: Pulling from library/mongo-express
6a428f9f83b0: Pull complete
f2b1fb32259e: Pull complete
40888f2a0a1f: Pull complete
Digest: sha256:2a25aafdf23296823b06bc9a0a2af2656971262041b8dbf11b40444804fdc104
Status: Downloaded newer image for mongo-express:latest
Welcome to mongo-express
------------------------
(node:7) [MONGODB DRIVER] Warning: Current Server Discovery and Monitoring engine is deprecated, and will be removed in a future version. To use the new Server Discover and Monitoring engine, pass option { useUnifiedTopology: true }
Could not connect to database using connectionString: mongodb://mongo:27017"
(node:7) UnhandledPromiseRejectionWarning: MongoNetworkError: failed to connect to server [mongo:27017] on first connect [Error: getaddrinfo ENOTFOUND mongo
    at GetAddrInfoReqWrap.onlookup [as oncomplete] (dns.js:66:26) {
  name: 'MongoNetworkError'
}]
    at Pool.<anonymous> (/node_modules/mongodb/lib/core/topologies/server.js:441:11)
    at Pool.emit (events.js:314:20)
    at /node_modules/mongodb/lib/core/connection/pool.js:564:14
    at /node_modules/mongodb/lib/core/connection/pool.js:1000:11
    at /node_modules/mongodb/lib/core/connection/connect.js:32:7
    at callback (/node_modules/mongodb/lib/core/connection/connect.js:300:5)
    at Socket.<anonymous> (/node_modules/mongodb/lib/core/connection/connect.js:330:7)
    at Object.onceWrapper (events.js:421:26)
    at Socket.emit (events.js:314:20)
    at emitErrorNT (internal/streams/destroy.js:92:8)
    at emitErrorAndCloseNT (internal/streams/destroy.js:60:3)
    at processTicksAndRejections (internal/process/task_queues.js:84:21)
(node:7) UnhandledPromiseRejectionWarning: Unhandled promise rejection. This error originated either by throwing inside of an async function without a catch block, or by rejecting a promise which was not handled with .catch(). To tered promise rejection, use the CLI flag `--unhandled-rejections=strict` (see https://nodejs.org/api/cli.html#cli_unhandled_rejections_mode). (rejection id: 1)
(node:7) [DEP0018] DeprecationWarning: Unhandled promise rejections are deprecated. In the future, promise rejections that are not handled will terminate the Node.js process with a non-zero exit code.
fernando@debian10x64:~/cursos/kubedev$ 
~~~


How to use this image
~~~bash
$ docker run --network some-network -e ME_CONFIG_MONGODB_SERVER=some-mongo -p 8081:8081 mongo-express
~~~
Then you can hit http://localhost:8081 or http://host-ip:8081 in your browser.

~~~bash
docker run --network network_desafio_docker -e ME_CONFIG_MONGODB_SERVER=mongodb -p 8081:8081 mongo-express
~~~

~~~bash
fernando@debian10x64:~/cursos/kubedev$ docker run --network network_desafio_docker -e ME_CONFIG_MONGODB_SERVER=mongodb -p 8081:8081 mongo-express
Welcome to mongo-express
------------------------
(node:7) [MONGODB DRIVER] Warning: Current Server Discovery and Monitoring engine is deprecated, and will be removed in a future version. To use the new Server Discover and Monitoring engine, pass option { useUnifiedTopology: true } to the MongoClient constructor.
(node:7) UnhandledPromiseRejectionWarning: MongoError: command listDatabases requires authentication
    at Connection.<anonymous> (/node_modules/mongodb/lib/core/connection/pool.js:453:61)
    at Connection.emit (events.js:314:20)
    at processMessage (/node_modules/mongodb/lib/core/connection/connection.js:456:10)
    at Socket.<anonymous> (/node_modules/mongodb/lib/core/connection/connection.js:625:15)
    at Socket.emit (events.js:314:20)
    at addChunk (_stream_readable.js:297:12)
    at readableAddChunk (_stream_readable.js:272:9)
    at Socket.Readable.push (_stream_readable.js:213:10)
    at TCP.onStreamRead (internal/stream_base_commons.js:188:23)
(node:7) UnhandledPromiseRejectionWarning: Unhandled promise rejection. This error originated either by throwing inside of an async function without a catch block, or by rejecting a promise which was not handled with .catch(). To terminate the node process on unhandled promise rejection, use the CLI flag `--unhandled-rejections=strict` (see https://nodejs.org/api/cli.html#cli_unhandled_rejections_mode). (rejection id: 1)
(node:7) [DEP0018] DeprecationWarning: Unhandled promise rejections are deprecated. In the future, promise rejections that are not handled will terminate the Node.js process with a non-zero exit code.
~~~


~~~bash
docker run -it --rm 
    --name mongo-express 
    --network web_default 
    -p 8081:8081 
    -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" 
    -e ME_CONFIG_BASICAUTH_USERNAME="" 
    -e ME_CONFIG_MONGODB_URL="mongodb://mongo:27017" 
    mongo-express
~~~

- Exemplos de variáveis
obtidas no blog:
<https://renatogroffe.medium.com/mongodb-mongo-express-docker-compose-montando-rapidamente-um-ambiente-para-uso-824f25ca6957>
ME_CONFIG_BASICAUTH_USERNAME: renatogroffe
      ME_CONFIG_BASICAUTH_PASSWORD: MongoExpress2019!
      ME_CONFIG_MONGODB_PORT: 27017
      ME_CONFIG_MONGODB_ADMINUSERNAME: root
      ME_CONFIG_MONGODB_ADMINPASSWORD: MongoDB2019!

- Testando
~~~bash
docker container run -d --network network_desafio_docker -e ME_CONFIG_MONGODB_SERVER=mongodb -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" -e ME_CONFIG_BASICAUTH_USERNAME="fernando" -e ME_CONFIG_BASICAUTH_PASSWORD=N4nduhelts$$$ -e ME_CONFIG_MONGODB_URL="mongodb://mongo:27017" -e ME_CONFIG_MONGODB_PORT=27017 -e ME_CONFIG_MONGODB_ADMINUSERNAME=mongouser -e ME_CONFIG_MONGODB_ADMINPASSWORD=mongopwd -p 8081:8081 mongo-express
~~~

- Mongo Express apresentando erro ao tentar autenticar via browser ou via curl:
~~~bash
fernando@debian10x64:~/cursos/kubedev$ curl localhost:8081
Unauthorized
fernando@debian10x64:~/cursos/kubedev$
~~~

- Mongo Express apresentando erro ao tentar autenticar via browser ou via curl:
~~~bash
fernando@debian10x64:~/cursos/kubedev$ docker logs -f objective_ptolemy
Welcome to mongo-express
------------------------
(node:7) [MONGODB DRIVER] Warning: Current Server Discovery and Monitoring engine is deprecated, and will be removed in a future version. To use the new Server Discover and Monitoring engine, pass option { useUnifiedTopology: true } to the MongoClient constructor.
Mongo Express server listening at http://0.0.0.0:8081
Server is open to allow connections from anyone (0.0.0.0)
~~~


- Validando quais variáveis de ambiente eu já tinha configurado no comando:
     - ME_CONFIG_MONGODB_ENABLE_ADMIN=true
     - ME_CONFIG_MONGODB_AUTH_DATABASE=admin
     - ME_CONFIG_MONGODB_ADMINUSERNAME=mongouser
     - ME_CONFIG_MONGODB_ADMINPASSWORD=mongopwd

- Faltava a variável ME_CONFIG_MONGODB_ENABLE_ADMIN e botei uma senha mais simples, sem uso dos caracteres especiais de cifrão.


- Resposta da questão 2 para o painel web usando Mongo Express para o MongoDB:
~~~bash
docker container run -d --network network_desafio_docker -e ME_CONFIG_MONGODB_SERVER=mongodb -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" -e ME_CONFIG_BASICAUTH_USERNAME="fernando" -e ME_CONFIG_MONGODB_AUTH_DATABASE=admin -e ME_CONFIG_BASICAUTH_PASSWORD=senhaparaodesafio -e ME_CONFIG_MONGODB_URL="mongodb://mongo:27017" -e ME_CONFIG_MONGODB_PORT=27017 -e ME_CONFIG_MONGODB_ADMINUSERNAME=mongouser -e ME_CONFIG_MONGODB_ADMINPASSWORD=mongopwd -p 8081:8081 mongo-express
~~~

- Abrindo o painel do Mongo Express no Browser:
<http://192.168.0.113:8081/>



# #########################################################################################################################################
#    MariaDB ⇒ phpmyadmin

- Docker Hub do phpmyadmin:
<https://hub.docker.com/_/phpmyadmin>

- Exemplo:
 docker run --name myadmin -d --link mysql_db_server:db -p 8080:80 phpmyadmin

- Resposta da questão 2 para o painel web usando phpmyadmin para o MariaDB:
~~~bash
docker container run -d --network network_desafio_docker --name phpmyadmin-desafio-docker --link desafio-docker-mariadb:db -p 8080:80 phpmyadmin
~~~

- Abrindo o painel do phpmyadmin no Browser:
<http://192.168.0.113:8080/>

- Acessar utilizando as credenciais do MariaDB:
--env MARIADB_USER=example-user
--env MARIADB_PASSWORD=my_cool_secret

- Containers criados com sucesso:
~~~bash
fernando@debian10x64:~/cursos/kubedev$ docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS                                   NAMES
ed7de91d1f48   phpmyadmin       "/docker-entrypoint.…"   22 seconds ago   Up 17 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   phpmyadmin-desafio-docker
8a0f9e81f23a   mariadb:latest   "docker-entrypoint.s…"   13 minutes ago   Up 13 minutes   3306/tcp                                desafio-docker-mariadb
fernando@debian10x64:~/cursos/kubedev$ ^C
~~~





# #########################################################################################################################################
# PostgreSQL ⇒ PgAdmin

- Docker Hub
<https://hub.docker.com/r/dpage/pgadmin4>

- Comando Docker de Exemplo
<https://www.pgadmin.org/docs/pgadmin4/latest/container_deployment.html>
docker pull dpage/pgadmin4
docker run -p 80:80 \
    -e 'PGADMIN_DEFAULT_EMAIL=user@domain.com' \
    -e 'PGADMIN_DEFAULT_PASSWORD=SuperSecret' \
    -d dpage/pgadmin4


- Comando editado, resposta da questão 2 para o PostgreSQL/PgAdmin:
~~~bash
docker container run -d --network network_desafio_docker --name pgadmin4-desafio-docker --link desafio-docker-postgres -e 'PGADMIN_DEFAULT_EMAIL=fernandomj90@gmail.com' -e 'PGADMIN_DEFAULT_PASSWORD=SuperSecret' -p 8282:80 dpage/pgadmin4
~~~


- Acessível via:
<http://192.168.0.113:8282/browser/>




# #########################################################################################################################################
# Redis ⇒ redis-commander

- Docker Hub - redis-commander:
<https://hub.docker.com/r/rediscommander/redis-commander>

- Exemplos:
<https://migueldoctor.medium.com/run-redis-redis-commander-in-3-steps-using-docker-195fc6fa7076>
~~~bash
$ $ docker run --name my-redis-commander -p 8081:8081 --env REDIS_HOSTS=local:172.17.0.2:6379 --restart always -d rediscommander/redis-commander:latest
~~~

    The parameter --env allows to provide environment variables. In this case we need to pass the REDIS_HOSTS value so the current redis-commander container will be able to connect to the Redis server configured in the previous step. As indicated, the value is local:172.17.0.2:6379 which follows the pattern <label>:<redis_server_host>:<redis_server_port>. The label can be any identifier you want to assign the server. The redis_server_port is the one you used when running the Redis server (if you followed the tutorial the port is 6379). Finally, in order to obtain the redis_server_host, you need to use the docker inspect command on the Redis server container as indicated below. Then use the value IPAddress which in our case is 172.17.0.2.
~~~bash
$ docker inspect my-redis -f "{{json .NetworkSettings.Networks}}"
{"bridge":{"IPAMConfig":null,"Links":null,"Aliases":null,
"NetworkID":"f6dad119aeed209f3f9b0e31d783874dcb6922ee71a220c06ff8fe3ab4272422",
"EndpointID":"cb5cbb92758d472fdd52218715ec882e040db2a0bf5162838859a1c8b4e133a3",
"Gateway":"172.17.0.1","IPAddress":"172.17.0.2","IPPrefixLen":16,"IPv6Gateway":"","GlobalIPv6Address":"","GlobalIPv6PrefixLen":0,"MacAddress":"02:42:ac:11:00:02","DriverOpts":null}}
~~~

- Exemplo de comando Docker Inspect, para verificar detalhes de rede do Container:
~~~bash
docker inspect desafio-docker-redis -f "{{json .NetworkSettings.Networks}}"

fernando@debian10x64:~$ docker inspect desafio-docker-redis -f "{{json .NetworkSettings.Networks}}"
{"network_desafio_docker":{"IPAMConfig":null,"Links":null,"Aliases":["b6633e58c38a"],"NetworkID":"c282a992876531c1a0ac9e400c0dba3fd2716717f4b53a759993d92acb3db9a2","EndpointID":"bbabd7248b7eaf42624c96803e3477ed20207a6abc4f1bb5ad9e5f7f9839e595","Gateway":"172.18.0.1","IPAddress":"172.18.0.2","IPPrefixLen":16,"IPv6Gateway":"","GlobalIPv6Address":"","GlobalIPv6PrefixLen":0,"MacAddress":"02:42:ac:12:00:02","DriverOpts":null}}
fernando@debian10x64:~$
~~~

- Comando editado, resposta da questão 2 Redis ⇒ redis-commander:
~~~bash
docker container run --detach --network network_desafio_docker --name desafio-docker-redis-commander --env REDIS_HOSTS=local:desafio-docker-redis:6379 --restart always -p 8081:8081 -v volume_desafio_docker_redis:/data/db rediscommander/redis-commander
~~~

- Acessível via:
<http://127.0.0.1:8081>
<http://192.168.0.113:8081>

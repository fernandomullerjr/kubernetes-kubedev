# Desafio de Docker 1

# Desafio de Docker
Um dos primeiros ganhos que temos com o uso do Docker é em ambiente de desenvolvimento. Criar um ambiente com banco de dados, mensageria é tão simples
quanto executar alguns comandos. Então agora tá na hora de você ganhar com isso também 



# Questão 01

Execute os comandos para criar os 4 bancos de dados listados com containers, e use como se tivesse instalado eles localmente na sua máquina (Não esquece de garantir
que não vai perder os dados caso o container seja excluido).
    MongoDB
    MariaDB
    PostgreSQL
    Redis


- Criar Container passando variaveis, atrelando volume e atrelando uma network.

docker container run -d -e MONGO_INITDB_ROOT_USERNAME=mongouser -e MONGO_INITDB_ROOT_PASSWORD=mongopwd -v mongo_vol:/data/db -p 27017:27017 --network produto_network --name mongodb mongo:4.4.3


- Criar uma network
docker network create network_desafio_docker

- Resposta da questão 1 para o MongoDB:
docker container run -d -e MONGO_INITDB_ROOT_USERNAME=mongouser -e MONGO_INITDB_ROOT_PASSWORD=mongopwd -v volume_desafio_docker:/data/db -p 27017:27017 --network network_desafio_docker --name mongodb mongo:4.4.3





# Questão 02

Certo, você conseguiu criar 4 bancos na sua máquina utilizando containers. Mas tem uma coisa, não adianta só conectar a aplicação no banco quando se está
desenvolvendo, é preciso também acessar o banco, executar comandos e consultar a base. Então vamos fazer isso da forma KubeDev de ser, com containers !!! Cada banco
de dados tem uma ferramenta administrativa com interface web que você pode usar.
    
    MongoDB ⇒ Mongo Express
    <https://github.com/mongo-express/mongo-express>

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

docker container run -d --network network_desafio_docker -e ME_CONFIG_MONGODB_SERVER=mongodb -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" -e ME_CONFIG_BASICAUTH_USERNAME="fernando" -e ME_CONFIG_MONGODB_AUTH_DATABASE=admin -e ME_CONFIG_BASICAUTH_PASSWORD=senhaparaodesafio -e ME_CONFIG_MONGODB_URL="mongodb://mongo:27017" -e ME_CONFIG_MONGODB_PORT=27017 -e ME_CONFIG_MONGODB_ADMINUSERNAME=mongouser -e ME_CONFIG_MONGODB_ADMINPASSWORD=mongopwd -p 8081:8081 mongo-express




    MariaDB ⇒ phpmyadmin
    PostgreSQL ⇒ PgAdmin
    Redis ⇒ redis-commander



# Questão 03

Um dos fundamentos chave pra se trabalhar com container é a criação de imagens
Docker. E criar uma imagem Docker pra cada aplicação sempre muda dependendo de
Desafio de Docker 2
como ela foi desenvolvida. Um cliente entrou em contato e expos o principal problema
para a migração pra ambiente baseado em containers.
Então agora eu tenho aqui algumas aplicações que precisam ser executadas em
containers mas eu só tenho o código fonte delas, chegou a hora de você mostrar seu
talento e executar essas aplicações em containers Docker e deixar acessível na sua
máquina local.(Pesquise e entenda como cada plataforma é utilizada antes de começar
a criar a imagem)
Aplicação escrita em NodeJS
Aplicação escrita em Python utilizando Flask
Aplicação escrita em C# utilizando ASP.NET Core
Faça um fork de cada projeto para o seu GitHub e depois me envia aqui embaixo cada
um deles com a solução. (Não esquece de documentar no Readme).


# Questão 04

Agora que você já afiou o seu conhecimento sobre criação de imagens Docker, tá na
hora de fazer o deploy de uma aplicação 100% em containers Docker. A aplicação está
no GitHub do KubeDev e um detalhe MUITO importante, a aplicação precisa ser toda
criada com apenas uma linha de comando.

# Questão 05

Chegou um cliente pra você que possui todas as suas aplicações em data centers e a
gestão dessas aplicações está cada vez mais complexa então pra iniciar um plano de
gestão unificada e migração pra um ambiente cloud, as aplicações serão migradas pra
containers. E hoje você precisa iniciar esse processo com um projeto piloto, o portal de
conteúdos da empresa construido em Wordpress. Então hoje sua missão é criar esse
ambiente wordpress pronto para a equipe de publicidade começar a popular.


# Questão 06

Agora vamos aumentar mais a complexidade das coisas, chegou a hora de executar
uma aplicação baseada em arquitetura de microsserviços.
Essa aplicação é formada por 3 repositórios:
Desafio de Docker 3
Aplicação Web
Microsserviço de Filmes
Microsserviço de Avaliação
Montar o ambiente com Docker compose baseado em arquivos de enviroment


# Questão 07

Agora que você concluiu, tão importante quanto executar, é documentar. Então crie
anotações sobre cada questão, detalhe as tomadas de decisão e processo de
construção.
E pra ficar melhor ainda, crie posts no Linkedin sobre o processo e não se esquece de
me marcar e colocar a nossa #rumoaelite !!!!


# aula 54 - Segunda aplicação em Docker

- Para esta aula será usada a seguinte aplicação:

https://github.com/KubeDev/api-produto


git clone https://github.com/KubeDev/api-produto.git

fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao$ git clone https://github.com/KubeDev/api-produto.git
Cloning into 'api-produto'...
remote: Enumerating objects: 154, done.
remote: Counting objects: 100% (8/8), done.
remote: Compressing objects: 100% (6/6), done.
remote: Total 154 (delta 3), reused 7 (delta 2), pack-reused 146
Receiving objects: 100% (154/154), 60.49 KiB | 282.00 KiB/s, done.
Resolving deltas: 100% (66/66), done.
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao$ ls
api-produto  rascunho-aula54.md
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao$


- Criando um Container do MongoDB, mapeando uma porta e definindo algumas variáveis de ambiente:

docker container run -d -e MONGO_INITDB_ROOT_USERNAME=mongouser -e MONGO_INITDB_ROOT_PASSWORD=mongopwd -p 27017:27017 mongo:4.4.3

Nesse caso o banco do Mongo é criado, porém os dados não são persistidos.




# Persistindo dados no MongoDB

Para persistir os dados é necessário criar um Volume primeiro.


- Criando volume para o Mongo

docker volume create mongo_vol

fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao$ docker volume ls
DRIVER    VOLUME NAME
local     0af5a162301dd1bfbc1637098ae8de833be4f8b86a8b8163943c187374631c3f
local     2aa60bd65919c0f3d165c9e98e324d989dc2b4d1af6bedc7aa3ba8cf386f022f
local     9b3e67c75e7f5f9832b3b1a83e9fabd065f7eb8b8c441f78da9c7f9f17c0c4fe
local     9b336c0c8017be417ec93d2dc0f377d0ebc1a4b813ec7bca993d8c6c356cf9d1
local     399fa54fa29534c8b2a1f0dff0cb0e335810eadb1c87b256a2aefa62cd6fe16b
local     8857428ef7d7cf825004bc6ae84bb48b4f19936cc679cf872ea816156cc3ab12
local     a90b82b9f51018dfc3d605d47a3680240f42f123da3eb3f47e7eda81888fea3a
local     aula_docker
local     b08e9016620ed8376384d72cf7d2da310c1ec1cff74721f4dc1862165f5a116c
local     minikube
local     mongo_vol
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao$


- Criando um Container e mapeando ao Volume "mongo_vol"

docker container run -d -e MONGO_INITDB_ROOT_USERNAME=mongouser -e MONGO_INITDB_ROOT_PASSWORD=mongopwd -v mongo_vol:/data/db -p 27017:27017 mongo:4.4.3

fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao$ docker container ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                                           NAMES
fd7f9e0db320   mongo:4.4.3   "docker-entrypoint.s…"   3 seconds ago   Up 2 seconds   0.0.0.0:27017->27017/tcp, :::27017->27017/tcp   frosty_lamport
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao$


Criando o Container do Mongo e mapeando um volume, os dados são persistidos.
Mesmo deletando o container do Mongo e criando novamente, as collections que haviam sido criadas seguem intactas.




# Criando a aplicação

- Acessar o diretório onde está encontrado o fonte da aplicação:

cd /home/fernando/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src


- Executar o npm install:

npm install

fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ npm install
npm WARN npm npm does not support Node.js v10.24.0
npm WARN npm You should probably upgrade to a newer version of node as we
npm WARN npm can't make any promises that npm will work with this version.
npm WARN npm Supported releases of Node.js are the latest release of 4, 6, 7, 8, 9.
npm WARN npm You can find the latest version at https://nodejs.org/
npm WARN read-shrinkwrap This version of npm is compatible with lockfileVersion@1, but package-lock.json was generated for lockfileVersion@2. I'll try to do my best with it!
npm WARN jornadakubernetes@1.0.0 No description
npm WARN jornadakubernetes@1.0.0 No repository field.

added 125 packages from 194 contributors in 4.237s
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$


- Executar a aplicação com o comando "node app.js":

node app.js

fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ node app.js
(node:5323) DeprecationWarning: current URL string parser is deprecated, and will be removed in a future version. To use the new parser, pass option { useNewUrlParser: true } to MongoClient.connect.
(node:5323) [MONGODB DRIVER] Warning: Current Server Discovery and Monitoring engine is deprecated, and will be removed in a future version. To use the new Server Discover and Monitoring engine, pass option { useUnifiedTopology: true } to the MongoClient constructor.
Servidor rodando na porta 8080


- Acessível via:

http://192.168.0.113:8080/api-docs/




fernando@debian10x64:~/cursos/kubedev$ curl http://192.168.0.113:8080/api-docs/ | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3102  100  3102    0     0  1009k      0 --:--:-- --:--:-- --:--:-- 1009k

<!-- HTML for static distribution bundle build -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Swagger UI</title>
  <link rel="stylesheet" type="text/css" href="./swagger-ui.css" >
  <link rel="icon" type="image/png" href="./favicon-32x32.png" sizes="32x32" /><link rel="icon" type="image/png" href="./favicon-16x16.png" sizes="16x16" />
  <style>
fernando@debian10x64:~/cursos/kubedev$

fernando@debian10x64:~/cursos/kubedev$ curl http://192.168.0.113:8080/api-docs/ | tail
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3102  100  3102    0     0  1514k      0 --:--:-- --:--:-- --:--:-- 1514k
<script src="./swagger-ui-standalone-preset.js"> </script>
<script src="./swagger-ui-init.js"> </script>


<style>
  .swagger-ui .topbar .download-url-wrapper { display: none } undefined
</style>
</body>

</html>
fernando@debian10x64:~/cursos/kubedev$





# Passando a aplicação para Container

- Primeiro passo é criar o Dockerfile

cd /home/fernando/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src
vi /home/fernando/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src/Dockerfile




# Dia 23/02/2022
Continuando

### Criando o Dockerfile

# Boas práticas, importantes:

- Utilizar a imagem oficial do node.
- Fixar uma versão do node no Dockerfile, para garantir a nossa idempotencia. É uma boa prática fixar a versão da imagem usada!
- Fazer a cópia usando o COPY em fases, aproveitando o uso das camadas, evitando copiar coisas desnecessárias no inicio do processo do Build.
    vi /home/fernando/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src/Dockerfile


- Criar também um arquivo .dockerignore
- No arquivo do .dockerignore, ignorar a pasta node_modules do node.js
    vi /home/fernando/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src/.dockerignore
    node_modules/

- Buildar a imagem
cd /home/fernando/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src
docker image build -t fernandomj90/api-produto:v1 .


fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ ^C
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker image build -t fernandomj90/api-produto:v1 .
Sending build context to Docker daemon  60.93kB
Step 1/7 : FROM node:14.15.4
14.15.4: Pulling from library/node
1e987daa2432: Pull complete
Digest: sha256:cb01e9d98a50cab46bf75357fe4843cbfd3acca5d99c5f72794acf16c5db4f5f
Status: Downloaded newer image for node:14.15.4
 ---> 924763541c0c
Step 2/7 : WORKDIR /app
 ---> Running in dcefd1c4b8bb
Removing intermediate container dcefd1c4b8bb
 ---> 8a5b8622b79c
Step 3/7 : COPY package*.json ./
 ---> 33e102d90e1e
Step 4/7 : RUN npm install
 ---> Running in 1b99aeb5ebbb
Removing intermediate container 1b99aeb5ebbb
 ---> 993b95bb211d
Step 5/7 : COPY . .
 ---> 5185a95f9f93
Step 6/7 : EXPOSE 8080
 ---> Running in e68e4a943368
Removing intermediate container e68e4a943368
 ---> 50080be4d420
Step 7/7 : CMD ["node", "app.js"]
 ---> Running in f7ad84ed757f
Removing intermediate container f7ad84ed757f
 ---> 4139b3731eaa
Successfully built 4139b3731eaa
Successfully tagged fernandomj90/api-produto:v1
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$



- Validando a imagem criada:

fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker image ls
REPOSITORY                                 TAG       IMAGE ID       CREATED         SIZE
fernandomj90/api-produto                   v1        4139b3731eaa   2 minutes ago   985MB


- Efetuando login no Docker:

fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker login
Authenticating with existing credentials...
WARNING! Your password will be stored unencrypted in /home/fernando/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$


- Efetuando o push da imagem que foi criada da api-produto:

docker push fernandomj90/api-produto:v1

fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker push fernandomj90/api-produto:v1
The push refers to repository [docker.io/fernandomj90/api-produto]
8378098be9cb: Pushed
c87a4dd2c775: Pushed
7d02cf813186: Pushed
57601bd41b6e: Pushed
572cede76299: Mounted from library/node
3c36055144ee: Mounted from library/node
34dbcd3def83: Mounted from library/node
9b88fe065b35: Mounted from library/node
4ca605ea46de: Mounted from library/node
601f04850201: Mounted from library/node
846bd2f3b216: Mounted from library/node
2b3e667f5e92: Mounted from library/node
e891be0c59b2: Mounted from library/node
v1: digest: sha256:16a579d5ec1a5a9887d058ef3fd10c44a0e46f43645a50b6e8e23c9e7fb2405b size: 3052
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$




- Efetuando o taggeamento da imagem que foi criada da api-produto, com a versão latest:

docker tag fernandomj90/api-produto:v1 fernandomj90/api-produto:latest


- Efetuar o push desta versão latest:

docker push fernandomj90/api-produto:latest

fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker push fernandomj90/api-produto:latest
The push refers to repository [docker.io/fernandomj90/api-produto]
8378098be9cb: Layer already exists
c87a4dd2c775: Layer already exists
7d02cf813186: Layer already exists
57601bd41b6e: Layer already exists
572cede76299: Layer already exists
3c36055144ee: Layer already exists
34dbcd3def83: Layer already exists
9b88fe065b35: Layer already exists
4ca605ea46de: Layer already exists
601f04850201: Layer already exists
846bd2f3b216: Layer already exists
2b3e667f5e92: Layer already exists
e891be0c59b2: Layer already exists
latest: digest: sha256:16a579d5ec1a5a9887d058ef3fd10c44a0e46f43645a50b6e8e23c9e7fb2405b size: 3052
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$

Ele identificou que a camada já existe, visto que a imagem latest é igual a v1, não tiveram alterações!!!!





fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker container run -d -e MONGO_INITDB_ROOT_USERNAME=mongouser -e MONGO_INITDB_ROOT_PASSWORD=mongopwd -v mongo_vol:/data/db -p 27017:27017 mongo:4.4.3
a860ad788bd5a655e390d8a51dd2ed1c81f3f05f273ccfc0ff5b1f7d1ea7f722
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker container ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                                           NAMES
a860ad788bd5   mongo:4.4.3   "docker-entrypoint.s…"   4 seconds ago   Up 2 seconds   0.0.0.0:27017->27017/tcp, :::27017->27017/tcp   confident_elion
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$


fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker network create produto_network
d782c4e366d821a23d294b95228c3c50261c47a10fa2de9cab78a8630b710e9c
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$

fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker network ls
NETWORK ID     NAME              DRIVER    SCOPE
cec278fb810a   aula_docker       bridge    local
25d847547d53   bridge            bridge    local
4ea8eec63a81   host              host      local
3da551b080c1   minikube          bridge    local
cc85819ababc   none              null      local
d782c4e366d8   produto_network   bridge    local
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$



fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker network connect produto_network a860ad788bd5
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$



fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker inspect a860ad788bd5
[...]
 "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "25d847547d537dfbf81cda63492fae311377aff94f493c0646997df0568f14f6",
                    "EndpointID": "f4875891426082d7d552a4a8332d79dec79d449150c98ad76460d81191ca0f41",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                },
                "produto_network": {
                    "IPAMConfig": {},
                    "Links": null,
                    "Aliases": [
                        "a860ad788bd5"
                    ],
                    "NetworkID": "d782c4e366d821a23d294b95228c3c50261c47a10fa2de9cab78a8630b710e9c",
                    "EndpointID": "7a4f76f7828372c6e54b68fa1f81fcba895fc1ea8c9115d176a885450dce43ab",
                    "Gateway": "172.19.0.1",
                    "IPAddress": "172.19.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:13:00:02",
                    "DriverOpts": {}
                }
            }
        }
    }
]
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$



fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker container ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                                           NAMES
a860ad788bd5   mongo:4.4.3   "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   0.0.0.0:27017->27017/tcp, :::27017->27017/tcp   confident_elion
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$



- Criar o Container que vai se conectar ao Mongo pela network que foi criada:

exemplo:
docker container run -d -p 8080:8080 --network produto_network -e MONGODB_URI=mongodb://mongouser:mongopwd@localhost:27017/admin fabricioveronez/api-produto:v1

editado:
docker container run -d -p 8080:8080 --network produto_network -e MONGODB_URI=mongodb://mongouser:mongopwd@confident_elion:27017/admin fernandomj90/api-produto:v1


fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker container run -d -p 8080:8080 --network produto_network -e MONGODB_URI=mongodb://mongouser:mongopwd@confident_elion:27017/admin fernandomj90/api-produto:v1
229bbb39a99cac56662651b46d103dc04be69f254dce6dd2d633da2a97ae24a3
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$



fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker container ps
CONTAINER ID   IMAGE                         COMMAND                  CREATED          STATUS          PORTS                                           NAMES
229bbb39a99c   fernandomj90/api-produto:v1   "docker-entrypoint.s…"   15 seconds ago   Up 13 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp       happy_rhodes
a860ad788bd5   mongo:4.4.3                   "docker-entrypoint.s…"   6 minutes ago    Up 5 minutes    0.0.0.0:27017->27017/tcp, :::27017->27017/tcp   confident_elion
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$


Acessar
http://192.168.0.113:8080/
Cannot GET /



- Acessar:
http://192.168.0.113:8080/api-docs/


- Falha na API.
- Identificados erros de conexão com o banco do MongoDB, nos logs do container da API.

fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker logs 229bbb39a99c

Failed to connect to mongo on startup - retrying in 5 sec MongoNetworkError: failed to connect to server [confident_elion:27017] on first connect [Error: getaddrinfo ENOTFOUND confident_elion
    at GetAddrInfoReqWrap.onlookup [as oncomplete] (dns.js:67:26) {
  name: 'MongoNetworkError'
}]
    at Pool.<anonymous> (/app/node_modules/mongodb/lib/core/topologies/server.js:441:11)
    at Pool.emit (events.js:315:20)
    at /app/node_modules/mongodb/lib/core/connection/pool.js:564:14
    at /app/node_modules/mongodb/lib/core/connection/pool.js:1000:11
    at /app/node_modules/mongodb/lib/core/connection/connect.js:32:7
    at callback (/app/node_modules/mongodb/lib/core/connection/connect.js:300:5)
    at Socket.<anonymous> (/app/node_modules/mongodb/lib/core/connection/connect.js:330:7)
    at Object.onceWrapper (events.js:422:26)
    at Socket.emit (events.js:315:20)
    at emitErrorNT (internal/streams/destroy.js:106:8)
    at emitErrorCloseNT (internal/streams/destroy.js:74:3)
    at processTicksAndRejections (internal/process/task_queues.js:80:21)
Failed to connect to mongo on startup - retrying in 5 sec MongoNetworkError: failed to connect to server [confident_elion:27017] on first connect [Error: getaddrinfo ENOTFOUND confident_elion
    at GetAddrInfoReqWrap.onlookup [as oncomplete] (dns.js:67:26) {
  name: 'MongoNetworkError'
}]
    at Pool.<anonymous> (/app/node_modules/mongodb/lib/core/topologies/server.js:441:11)
    at Pool.emit (events.js:315:20)
    at /app/node_modules/mongodb/lib/core/connection/pool.js:564:14
    at /app/node_modules/mongodb/lib/core/connection/pool.js:1000:11
    at /app/node_modules/mongodb/lib/core/connection/connect.js:32:7
    at callback (/app/node_modules/mongodb/lib/core/connection/connect.js:300:5)
    at Socket.<anonymous> (/app/node_modules/mongodb/lib/core/connection/connect.js:330:7)
    at Object.onceWrapper (events.js:422:26)
    at Socket.emit (events.js:315:20)
    at emitErrorNT (internal/streams/destroy.js:106:8)
    at emitErrorCloseNT (internal/streams/destroy.js:74:3)
    at processTicksAndRejections (internal/process/task_queues.js:80:21)
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$




fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker container ls
CONTAINER ID   IMAGE                         COMMAND                  CREATED          STATUS          PORTS                                           NAMES
229bbb39a99c   fernandomj90/api-produto:v1   "docker-entrypoint.s…"   31 minutes ago   Up 31 minutes   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp       happy_rhodes
a860ad788bd5   mongo:4.4.3                   "docker-entrypoint.s…"   37 minutes ago   Up 37 minutes   0.0.0.0:27017->27017/tcp, :::27017->27017/tcp   confident_elion
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$


docker container rm -f 229bbb39a99c
docker container rm -f a860ad788bd5


fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker container ls
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$


-Comandos para subir os 2 Containers, com o MongoDB e a API-PRODUTO:

docker container run -d -e MONGO_INITDB_ROOT_USERNAME=mongouser -e MONGO_INITDB_ROOT_PASSWORD=mongopwd -v mongo_vol:/data/db -p 27017:27017 --network produto_network --name mongodb mongo:4.4.3

docker container run -d -p 8080:8080 --network produto_network -e MONGODB_URI=mongodb://mongouser:mongopwd@mongodb:27017/admin fernandomj90/api-produto:v1


MongoDB criado

fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker container run -d -e MONGO_INITDB_ROOT_USERNAME=mongouser -e MONGO_INITDB_ROOT_PASSWORD=mongopwd -v mongo_vol:/data/db -p 27017:27017 --network produto_network --name mongodb mongo:4.4.3
657a7bb489afca5c11a7bde53f64bdbdddbf0a6561d7fb1f9a1ca46e63af055f
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$


fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker container ls
CONTAINER ID   IMAGE                         COMMAND                  CREATED              STATUS                  PORTS                                           NAMES
4848b4c09d0b   fernandomj90/api-produto:v1   "docker-entrypoint.s…"   1 second ago         Up Less than a second   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp       brave_bohr
657a7bb489af   mongo:4.4.3                   "docker-entrypoint.s…"   About a minute ago   Up About a minute       0.0.0.0:27017->27017/tcp, :::27017->27017/tcp   mongodb
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$


http://192.168.0.113:8080/
http://192.168.0.113:8080/api-docs/

# 
Foram criadas as networks
atreladas aos containers do Mongo e da Aplicação

pendente:
ver como usar a API do api-produto para fazer Post, Get, etc




#
#
###
### 26/02/2022

-Comandos para subir os 2 Containers, com o MongoDB e a API-PRODUTO:

docker container run -d -e MONGO_INITDB_ROOT_USERNAME=mongouser -e MONGO_INITDB_ROOT_PASSWORD=mongopwd -v mongo_vol:/data/db -p 27017:27017 --network produto_network --name mongodb mongo:4.4.3

docker container run -d -p 8080:8080 --network produto_network -e MONGODB_URI=mongodb://mongouser:mongopwd@mongodb:27017/admin fernandomj90/api-produto:v1

fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto$ docker container ls
CONTAINER ID   IMAGE                         COMMAND                  CREATED              STATUS              PORTS                                           NAMES
3988accdad73   fernandomj90/api-produto:v1   "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp       friendly_newton
2b44b43fa012   mongo:4.4.3                   "docker-entrypoint.s…"   2 minutes ago        Up 2 minutes        0.0.0.0:27017->27017/tcp, :::27017->27017/tcp   mongodb
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto$


A maneira certa de validar é indo na página:

http://192.168.0.113:8080/api-docs/

E ir em GET /api/produto
http://192.168.0.113:8080/api-docs/#/default/get_api_produto

O resultado esperado é este acima, com um “Response body”, após ter clicado no “Try out” > “Execute”.





# Questão 03

Um dos fundamentos chave pra se trabalhar com container é a criação de imagens Docker. E criar uma imagem Docker pra cada aplicação sempre muda dependendo de
como ela foi desenvolvida. Um cliente entrou em contato e expos o principal problema para a migração pra ambiente baseado em containers.
Então agora eu tenho aqui algumas aplicações que precisam ser executadas em containers mas eu só tenho o código fonte delas, chegou a hora de você mostrar seu
talento e executar essas aplicações em containers Docker e deixar acessível na sua máquina local.(Pesquise e entenda como cada plataforma é utilizada antes de começar
a criar a imagem)

* Aplicação escrita em NodeJS
* Aplicação escrita em Python utilizando Flask
* Aplicação escrita em C# utilizando ASP.NET Core

Faça um fork de cada projeto para o seu GitHub e depois me envia aqui embaixo cada um deles com a solução. (Não esquece de documentar no Readme).




# ########################################################################################################################################
# Aplicação escrita em NodeJS

- Criando Dockerfile seguindo boas práticas:

FROM node:14.17.5
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD ["node", "server.js"]

- Criar arquivo dockerignore com o conteúdo abaixo:
node_modules/



- Com MultiStage:
~~~Dockerfile
#
# ---- Base Node ----
FROM alpine:3.5 AS base
# install node
RUN apk add --no-cache nodejs-current tini
# set working directory
WORKDIR /root/chat
# Set tini as entrypoint
ENTRYPOINT ["/sbin/tini", "--"]
# copy project file
COPY package.json .

#
# ---- Dependencies ----
FROM base AS dependencies
# install node packages
RUN npm set progress=false && npm config set depth 0
RUN npm install --only=production 
# copy production node_modules aside
RUN cp -R node_modules prod_node_modules
# install ALL node_modules, including 'devDependencies'
RUN npm install

#
# ---- Test ----
# run linters, setup and tests
FROM dependencies AS test
COPY . .
RUN  npm run lint && npm run setup && npm run test

#
# ---- Release ----
FROM base AS release
# copy production node_modules
COPY --from=dependencies /root/chat/prod_node_modules ./node_modules
# copy app sources
COPY . .
# expose port and define CMD
EXPOSE 5000
CMD npm run start
~~~




- Buildando
docker image build -t fernandomj90/desafio-docker-questao3-nodejs:v1 .



- Erro:

~~~bash
 ---> 6b589c428b8a
Step 13/18 : RUN  npm run lint && npm run setup && npm run test
 ---> Running in 66c80a528499
npm ERR! Linux 4.19.0-17-amd64
npm ERR! argv "/usr/bin/node" "/usr/bin/npm" "run" "lint"
npm ERR! node v7.2.1
npm ERR! npm  v3.10.10

npm ERR! missing script: lint
npm ERR!
npm ERR! If you need help, you may report this error at:
npm ERR!     <https://github.com/npm/npm/issues>

npm ERR! Please include the following file with any support request:
npm ERR!     /app/npm-debug.log
The command '/bin/sh -c npm run lint && npm run setup && npm run test' returned a non-zero code: 1
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$
~~~



- Buildando
docker image build -t fernandomj90/desafio-docker-questao3-nodejs:v1 .


- Adicionado
"lint": "eslint . --ext js,jsx,ts,tsx --fix"


-ANTES:

  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "lint": "eslint . --ext js,jsx,ts,tsx --fix"
  },


- DEPOIS:

  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "lint": "eslint . --ext js,jsx,ts,tsx --fix"
  },



- Novo erro:
~~~bash

Step 13/18 : RUN  npm run lint && npm run setup && npm run test
 ---> Running in 3ca1cd6b2ec6

> conversao-temperatura@1.0.0 lint /app
> eslint . --ext js,jsx,ts,tsx --fix

sh: eslint: not found

npm ERR! Linux 4.19.0-17-amd64
npm ERR! argv "/usr/bin/node" "/usr/bin/npm" "run" "lint"
npm ERR! node v7.2.1
npm ERR! npm  v3.10.10
npm ERR! file sh
npm ERR! code ELIFECYCLE
npm ERR! errno ENOENT
npm ERR! syscall spawn
npm ERR! conversao-temperatura@1.0.0 lint: `eslint . --ext js,jsx,ts,tsx --fix`
npm ERR! spawn ENOENT
npm ERR!
npm ERR! Failed at the conversao-temperatura@1.0.0 lint script 'eslint . --ext js,jsx,ts,tsx --fix'.
npm ERR! Make sure you have the latest version of node.js and npm installed.
npm ERR! If you do, this is most likely a problem with the conversao-temperatura package,
npm ERR! not with npm itself.
npm ERR! Tell the author that this fails on your system:
npm ERR!     eslint . --ext js,jsx,ts,tsx --fix
npm ERR! You can get information on how to open an issue for this project with:
npm ERR!     npm bugs conversao-temperatura
npm ERR! Or if that isn't available, you can get their info via:
npm ERR!     npm owner ls conversao-temperatura
npm ERR! There is likely additional logging output above.

npm ERR! Please include the following file with any support request:
npm ERR!     /app/npm-debug.log
The command '/bin/sh -c npm run lint && npm run setup && npm run test' returned a non-zero code: 1
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$
~~~



- Adicionando ao Dockerfile:
    npm install eslint --save-dev
    eslint --init


- Buildando
docker image build -t fernandomj90/desafio-docker-questao3-nodejs:v1 .


- Novo erro:
~~~bash
Step 13/20 : RUN npm install eslint --save-dev
 ---> Running in 2fa353b02069
conversao-temperatura@1.0.0 /app
`-- eslint@8.14.0

npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@~2.3.2 (node_modules/chokidar/node_modules/fsevents):
npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@2.3.2: wanted {"os":"darwin","arch":"any"} (current: {"os":"linux","arch":"x64"})
npm WARN conversao-temperatura@1.0.0 No description
Removing intermediate container 2fa353b02069
 ---> 924a0560f41a
Step 14/20 : RUN eslint --init
 ---> Running in d362f4cc173d
/bin/sh: eslint: not found
The command '/bin/sh -c eslint --init' returned a non-zero code: 127
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$
~~~




#install globally
npm i -g eslint

#install in project
npm install eslint --save-dev


- Buildando
docker image build -t fernandomj90/desafio-docker-questao3-nodejs:v1 .



- Aplicar boas práticas:
<https://medium.com/@nodepractices/docker-best-practices-with-node-js-e044b78d8f67>
<https://www.docker.com/blog/keep-nodejs-rockin-in-docker/>






-Novo teste:

# ---- Test ----
# run linters, setup and tests
FROM dependencies AS test
COPY . .
#install globally
RUN npm i -g eslint
#install in project
RUN npm install eslint --save-dev
RUN eslint --fix
RUN npm run setup && npm run test


- Erro:
 ---> 430ea5b57f45
Step 15/21 : RUN eslint --fix
 ---> Running in 2068c1216b96
/usr/lib/node_modules/eslint/bin/eslint.js:83
        } catch {
                ^
SyntaxError: Unexpected token {
    at Object.exports.runInThisContext (vm.js:78:16)
    at Module._compile (module.js:543:28)
    at Object.Module._extensions..js (module.js:580:10)
    at Module.load (module.js:488:32)
    at tryModuleLoad (module.js:447:12)
    at Function.Module._load (module.js:439:3)
    at Module.runMain (module.js:605:10)
    at run (bootstrap_node.js:420:7)
    at startup (bootstrap_node.js:139:9)
    at bootstrap_node.js:535:3
The command '/bin/sh -c eslint --fix' returned a non-zero code: 1
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$




- Novo ajuste:
#
# ---- Test ----
# run linters, setup and tests
FROM dependencies AS test
COPY . .
RUN npm install eslint --save-dev
RUN npm init @eslint/config
RUN ./node_modules/.bin/eslint server.js
RUN npm run setup && npm run test


- 

- Buildando
docker image build -t fernandomj90/desafio-docker-questao3-nodejs:v1 .


-Novo erro:
 ---> 6231c1f61b48
Step 14/21 : RUN npm init @eslint/config
 ---> Running in 4002f3b5600d
This utility will walk you through creating a package.json file.
It only covers the most common items, and tries to guess sensible defaults.

See `npm help json` for definitive documentation on these fields
and exactly what they do.

Use `npm install <pkg> --save` afterwards to install a package and
save it as a dependency in the package.json file.

Press ^C at any time to quit.
name: (conversao-temperatura) The command '/bin/sh -c npm init @eslint/config' returned a non-zero code: 1




- Comentando os passos do Step de Test, o build ocorre com sucesso:
 ---> Running in 4157fe09b7c3
Removing intermediate container 4157fe09b7c3
 ---> 002e310a392b
Step 16/16 : CMD ["node", "server.js"]
 ---> Running in 8d80b4fc2d9b
Removing intermediate container 8d80b4fc2d9b
 ---> 808d3269fd30
Successfully built 808d3269fd30
Successfully tagged fernandomj90/desafio-docker-questao3-nodejs:v1
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$




- Ultimo erro, com edições efetuadas no package.json(colocadas dependencias, etc), ajustado Dockerfile, colocados os testes e novos install(baseados no <https://www.educative.io/collection/page/10370001/6588114816466944/4724689366679552>):
~~~bash
Step 21/26 : RUN npm run lint && npm run setup && npm run test
 ---> Running in 00e882657e0c

> conversao-temperatura@1.0.0 lint /app
> eslint . --ext js,jsx,ts,tsx --fix

/app/node_modules/eslint/lib/cli-engine/cli-engine.js:256
        ...calculateStatsPerFile(messages)
        ^^^
SyntaxError: Unexpected token ...
    at NativeCompileCache._moduleCompile (/app/node_modules/v8-compile-cache/v8-compile-cache.js:240:18)
    at Module._compile (/app/node_modules/v8-compile-cache/v8-compile-cache.js:184:36)
    at Object.Module._extensions..js (module.js:580:10)
    at Module.load (module.js:488:32)
    at tryModuleLoad (module.js:447:12)
    at Function.Module._load (module.js:439:3)
    at Module.require (module.js:498:17)
    at require (/app/node_modules/v8-compile-cache/v8-compile-cache.js:159:20)
    at Object.<anonymous> (/app/node_modules/eslint/lib/cli-engine/index.js:3:23)
    at Module._compile (/app/node_modules/v8-compile-cache/v8-compile-cache.js:192:30)

npm ERR! Linux 4.19.0-17-amd64
npm ERR! argv "/usr/bin/node" "/usr/bin/npm" "run" "lint"
npm ERR! node v7.2.1
npm ERR! npm  v3.10.10
npm ERR! code ELIFECYCLE
npm ERR! conversao-temperatura@1.0.0 lint: `eslint . --ext js,jsx,ts,tsx --fix`
npm ERR! Exit status 1
npm ERR!
npm ERR! Failed at the conversao-temperatura@1.0.0 lint script 'eslint . --ext js,jsx,ts,tsx --fix'.
npm ERR! Make sure you have the latest version of node.js and npm installed.
npm ERR! If you do, this is most likely a problem with the conversao-temperatura package,
npm ERR! not with npm itself.
npm ERR! Tell the author that this fails on your system:
npm ERR!     eslint . --ext js,jsx,ts,tsx --fix
npm ERR! You can get information on how to open an issue for this project with:
npm ERR!     npm bugs conversao-temperatura
npm ERR! Or if that isn't available, you can get their info via:
npm ERR!     npm owner ls conversao-temperatura
npm ERR! There is likely additional logging output above.

npm ERR! Please include the following file with any support request:
npm ERR!     /app/npm-debug.log
The command '/bin/sh -c npm run lint && npm run setup && npm run test' returned a non-zero code: 1
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$
~~~



----- Resumo dos testes que foram realizadas
- Testar instalação do eslint usando o Yarn.
- Testar o uso do eslint com o comando inteiro, passando o node_modules.
- Remover o "--only=production" do npm install.



# PENDENTE
- Resolver erros ao tentar usar eslint no step de Test do Build em MultiStage.
- Ficar atento nas diferenças do package.json original, Dockerfile de Exemplo, etc
- Criar imagem do NodeJS usando MultiStage. <https://codefresh.io/docker-tutorial/node_docker_multistage/>
- Aplicar boas práticas:
<https://medium.com/@nodepractices/docker-best-practices-with-node-js-e044b78d8f67>
<https://www.docker.com/blog/keep-nodejs-rockin-in-docker/>




npm install --save-dev eslint

  "devDependencies": {
    "chai": "^4.3.4",
    "concurrently": "^6.3.0",
    "eslint": "^8.1.0",
    "http-server": "^14.0.0",
    "jest": "^27.3.1",
    "mocha": "^9.1.3",
    "nyc": "^15.1.0"
  }
}

},
  "devDependencies": {
    "eslint": "^8.1.0"
  }



- Buildando
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src
docker image build -t fernandomj90/desafio-docker-questao3-nodejs:v1 .


npm i --save-dev eslint @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-config-airbnb-base eslint-plugin-import eslint-config-prettier eslint-plugin-prettier prettier


~~~bash
Step 15/20 : RUN npm run lint && npm run setup && npm run test
 ---> Running in e849f2265986

> conversao-temperatura@1.0.0 lint /app
> eslint . --ext js,jsx,ts,tsx --fix

/app/node_modules/eslint/bin/eslint.js:83
        } catch {
                ^
SyntaxError: Unexpected token {
    at Object.exports.runInThisContext (vm.js:78:16)
    at Module._compile (module.js:543:28)
    at Object.Module._extensions..js (module.js:580:10)
    at Module.load (module.js:488:32)
    at tryModuleLoad (module.js:447:12)
    at Function.Module._load (module.js:439:3)
    at Module.runMain (module.js:605:10)
    at run (bootstrap_node.js:420:7)
    at startup (bootstrap_node.js:139:9)
    at bootstrap_node.js:535:3

npm ERR! Linux 4.19.0-17-amd64
npm ERR! argv "/usr/bin/node" "/usr/bin/npm" "run" "lint"
npm ERR! node v7.2.1
npm ERR! npm  v3.10.10
npm ERR! code ELIFECYCLE
npm ERR! conversao-temperatura@1.0.0 lint: `eslint . --ext js,jsx,ts,tsx --fix`
npm ERR! Exit status 1
npm ERR!
npm ERR! Failed at the conversao-temperatura@1.0.0 lint script 'eslint . --ext js,jsx,ts,tsx --fix'.
npm ERR! Make sure you have the latest version of node.js and npm installed.
npm ERR! If you do, this is most likely a problem with the conversao-temperatura package,
npm ERR! not with npm itself.
npm ERR! Tell the author that this fails on your system:
npm ERR!     eslint . --ext js,jsx,ts,tsx --fix
npm ERR! You can get information on how to open an issue for this project with:
npm ERR!     npm bugs conversao-temperatura
npm ERR! Or if that isn't available, you can get their info via:
npm ERR!     npm owner ls conversao-temperatura
npm ERR! There is likely additional logging output above.

npm ERR! Please include the following file with any support request:
npm ERR!     /app/npm-debug.log
The command '/bin/sh -c npm run lint && npm run setup && npm run test' returned a non-zero code: 1
~~~


- Comentadas as linhas dos Tests.

- Buildando
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src
docker image build -t fernandomj90/desafio-docker-questao3-nodejs:v1 .



fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ docker image ls | head
REPOSITORY                                    TAG       IMAGE ID       CREATED          SIZE
fernandomj90/desafio-docker-questao3-nodejs   v1        f4a2f490f54d   6 seconds ago    69.5MB



- Criado Dockerfile sem uso de MultiStage.
- Buildando
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src
docker image build -f Dockerfile-normal -t fernandomj90/desafio-docker-questao3-nodejs-pesado:v1 .

fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ docker image ls | head
REPOSITORY                                           TAG       IMAGE ID       CREATED          SIZE
fernandomj90/desafio-docker-questao3-nodejs-pesado   v1        65263568c847   22 seconds ago   995MB




- Ajustado o Dockerfile com MultiStage, removidas sujeiras.

- Buildando
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src
docker image build -t fernandomj90/desafio-docker-questao3-nodejs:v1 .

fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ docker image ls | head
REPOSITORY                                           TAG       IMAGE ID       CREATED          SIZE
fernandomj90/desafio-docker-questao3-nodejs          v1        cab231c0023c   9 seconds ago    69.5MB


docker container run -d fernandomj90/desafio-docker-questao3-nodejs:v1


docker container run -d fernandomj90/desafio-docker-questao3-nodejs-pesado:v1




- Não funcionou essa do MultiStage:
~~~Dockerfile
FROM alpine:3.5 AS base
RUN apk add --no-cache nodejs-current tini
WORKDIR /app
ENTRYPOINT ["/sbin/tini", "--"]
COPY package*.json ./

FROM base AS dependencies
RUN npm set progress=false && npm config set depth 0
RUN npm install
RUN cp -R node_modules prod_node_modules
RUN npm install

FROM base AS release
COPY --from=dependencies /app/prod_node_modules ./node_modules
COPY . .
EXPOSE 8080
CMD ["node", "server.js"]
~~~


~~~bash

fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ ^C
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ docker container run -d fernandomj90/desafio-docker-questao3-nodejs:v1
0bff197efa4ae102d0277e4659613613e02d2196f6795292f3fecb34d82d06db
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ docker ps -a
CONTAINER ID   IMAGE                                            COMMAND                  CREATED          STATUS                      PORTS     NAMES
0bff197efa4a   fernandomj90/desafio-docker-questao3-nodejs:v1   "/sbin/tini -- node …"   6 seconds ago    Exited (1) 4 seconds ago              boring_tharp
e849f2265986   a4db9b26bb0a                                     "/bin/sh -c 'npm run…"   32 minutes ago   Exited (1) 32 minutes ago             gracious_zhukovsky
00e882657e0c   87206131edb9                                     "/bin/sh -c 'npm run…"   20 hours ago     Exited (1) 20 hours ago               admiring_bose
9a98406c9ac3   cda7a6a017fe                                     "/bin/sh -c 'npm ins…"   20 hours ago     Exited (1) 20 hours ago               pensive_goldwasser
570a0ba558aa   a6f9c32f40e0                                     "/bin/sh -c 'npm run…"   20 hours ago     Exited (1) 20 hours ago               optimistic_easley
07a58d40fc77   6e3d4d39c585                                     "/bin/sh -c 'npm ini…"   20 hours ago     Exited (1) 20 hours ago               tender_swanson
4002f3b5600d   6231c1f61b48                                     "/bin/sh -c 'npm ini…"   21 hours ago     Exited (1) 21 hours ago               distracted_wing
2068c1216b96   430ea5b57f45                                     "/bin/sh -c 'eslint …"   21 hours ago     Exited (1) 21 hours ago               musing_ellis
268717a8486c   caf3f45d11f5                                     "/bin/sh -c 'eslint …"   21 hours ago     Exited (127) 21 hours ago             clever_margulis
d12529539f2b   16b037551271                                     "/bin/sh -c 'npm ins…"   21 hours ago     Exited (1) 21 hours ago               pedantic_faraday
0b7d628b3f81   f6a332cb2f99                                     "/bin/sh -c 'npm ins…"   21 hours ago     Exited (1) 21 hours ago               keen_dhawan
013552f80d02   e5ad90a9d3f9                                     "/bin/sh -c 'yarn ad…"   21 hours ago     Exited (127) 21 hours ago             musing_mahavira
0f137ce7ab1a   8a85ddb1b257                                     "/bin/sh -c 'npm run…"   21 hours ago     Exited (1) 21 hours ago               ecstatic_shaw
2ad55949d538   dfb770a265bd                                     "/bin/sh -c 'eslint …"   21 hours ago     Exited (1) 21 hours ago               tender_khorana
1e03be876a68   a370751b8913                                     "/bin/sh -c 'npm run…"   23 hours ago     Exited (1) 23 hours ago               objective_merkle
3ca1cd6b2ec6   a370751b8913                                     "/bin/sh -c 'npm run…"   23 hours ago     Exited (1) 23 hours ago               silly_wescoff
66c80a528499   6b589c428b8a                                     "/bin/sh -c 'npm run…"   23 hours ago     Exited (1) 23 hours ago               keen_golick
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ docker logs boring_tharp
/app/node_modules/nodehog/lib/nodehog.js:32
  async start() {
        ^^^^^
SyntaxError: Unexpected identifier
    at Object.exports.runInThisContext (vm.js:78:16)
    at Module._compile (module.js:543:28)
    at Object.Module._extensions..js (module.js:580:10)
    at Module.load (module.js:488:32)
    at tryModuleLoad (module.js:447:12)
    at Function.Module._load (module.js:439:3)
    at Module.require (module.js:498:17)
    at require (internal/module.js:20:19)
    at Object.<anonymous> (/app/node_modules/nodehog/index.js:1:80)
    at Module._compile (module.js:571:32)
~~~






- Ajustado o Dockerfile com MultiStage, ALTERADA a imagem do Alpine pela do Node.
- Removidas outras sujeiras.

- Buildando
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src
docker image build -t fernandomj90/desafio-docker-questao3-nodejs:v1 .

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ docker image ls | head
REPOSITORY                                           TAG       IMAGE ID       CREATED          SIZE
fernandomj90/desafio-docker-questao3-nodejs          v1        cab231c0023c   9 seconds ago    69.5MB
~~~


docker container run -d fernandomj90/desafio-docker-questao3-nodejs:v1

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ ^C
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ docker container run -d fernandomj90/desafio-docker-questao3-nodejs:v1
8299c474f786ad3dd8200c7db5d0f177e55cc99038638c9d050b5d3c370fc13b
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ docker ps
CONTAINER ID   IMAGE                                            COMMAND                  CREATED         STATUS         PORTS      NAMES
8299c474f786   fernandomj90/desafio-docker-questao3-nodejs:v1   "docker-entrypoint.s…"   3 seconds ago   Up 2 seconds   8080/tcp   hungry_morse
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ ^C
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ ^C
~~~


- Apresenta erro:

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ curl localhost:8080 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0curl: (7) Failed to connect to localhost port 8080: Connection refused
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ ^C
~~~



- Adicionando a porta no comando do run.
-p 8080:8080
docker container run -d -p 8080:8080 fernandomj90/desafio-docker-questao3-nodejs:v1

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ ^C
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ docker container run -d -p 8080:8080 fernandomj90/desafio-docker-questao3-nodejs:v1
305de87131b7a70ca80f81bd00e9bfe786101b213e1985213d9e63d5cced85c2
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ docker ps
CONTAINER ID   IMAGE                                            COMMAND                  CREATED        STATUS        PORTS                                       NAMES
305de87131b7   fernandomj90/desafio-docker-questao3-nodejs:v1   "docker-entrypoint.s…"   1 second ago   Up 1 second   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   funny_wiles
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$ curl localhost:8080 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3921  100  3921    0     0   273k      0 --:--:-- --:--:-- --:--:--  273k
<!doctype html>
<html lang="en" class="h-100">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
    <meta name="generator" content="Hugo 0.87.0">
    <title>Sticky Footer Navbar Template · Bootstrap v5.1</title>
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src$
~~~






- Ajustado o Dockerfile com MultiStage, ALTERADA a imagem do Node pela do Node-alpine.
  node:current-alpine3.15

- Buildando e executando
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/nodeJS/conversao-temperatura-desafio-docker/src
docker image build -t fernandomj90/desafio-docker-questao3-nodejs:v1 .
docker container run -d -p 8080:8080 fernandomj90/desafio-docker-questao3-nodejs:v1




- Resposta da questão 3, sobre aplicação em NodeJS:
<https://github.com/fernandomullerjr/conversao-temperatura-desafio-docker>










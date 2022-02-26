

# Aula 55 - Docker-compose

- Copiar o api-produto da aula54, para fazer o projeto para esta aula.

- Criar um arquivo docker-compose dentro da pasta do projeto da API:
vi /home/fernando/cursos/kubedev/aula55-Docker-compose/api-produto/docker-compose.yaml


- Verificando o nome do volume e da network, para criação do docker-compose:

fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto$ docker volume ls
DRIVER    VOLUME NAME
local     aula_docker
local     b08e9016620ed8376384d72cf7d2da310c1ec1cff74721f4dc1862165f5a116c
local     minikube
local     mongo_vol
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto$ docker network ls
NETWORK ID     NAME              DRIVER    SCOPE
cec278fb810a   aula_docker       bridge    local
823b5f3d49a9   bridge            bridge    local
4ea8eec63a81   host              host      local
3da551b080c1   minikube          bridge    local
cc85819ababc   none              null      local
d782c4e366d8   produto_network   bridge    local
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto$


- É possível conectar mais de 1 rede, caso necessário.

-Comandos para subir os 2 Containers, com o MongoDB e a API-PRODUTO:
docker container run -d -p 8080:8080 --network produto_network -e MONGODB_URI=mongodb://mongouser:mongopwd@mongodb:27017/admin fernandomj90/api-produto:v1
docker container run -d -e MONGO_INITDB_ROOT_USERNAME=mongouser -e MONGO_INITDB_ROOT_PASSWORD=mongopwd -v mongo_vol:/data/db -p 27017:27017 --network produto_network --name mongodb mongo:4.4.3


- Usando os valores acima, foram preenchidos:
declarados os volumes e networks ao inicio
volumes
networks
variáveis de ambiente
ports
adicionado depends_on, para o serviço de API tentar subir apenas depois que o banco tiver subido


# Dockerfile ficou assim:

version: '3.8'

volumes:
  mongodb_vol:

networks:
  produto_network:
    driver: bridge

services:
  api:
    image: fernandomj90/api-produto:v1
    ports:
      - "8080:8080"
    networks:
      - produto_network
    depends_on:
      - mongodb
    environment:
      - MONGODB_URI=mongodb://mongouser:mongopwd@mongodb:27017/admin
  
  mongodb:
    image: mongodb:4.4.3
    ports:
      - "27017:27017"
    networks:
      - produto_network
    volumes:
      - mongo_vol:/data/db
    environment:
      - MONGO_INITDB_ROOT_USERNAME=mongouser
      - MONGO_INITDB_ROOT_PASSWORD=mongopwd



docker-compose up
docker-compose up -d

# ERROS

fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ docker-compose up
ERROR: Named volume "mongo_vol:/data/db:rw" is used in service "mongodb" but no declaration was found in the volumes section.
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$

fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ docker-compose up
Creating network "api-produto_produto_network" with driver "bridge"
Creating volume "api-produto_mongo_vol" with default driver
Pulling mongodb (mongodb:4.4.3)...
ERROR: The image for the service you're trying to recreate has been removed. If you continue, volume data could be lost. Consider backing up your data before continuing.

Erros ocorriam devido:
nome errado do volume declarado no inicio
nome da imagem errada



# Novo docker-compose, ajustado:

version: '3.8'

volumes:
  mongo_vol:

networks:
  produto_network:
    driver: bridge

services:
  api:
    image: fernandomj90/api-produto:v1
    ports:
      - "8080:8080"
    networks:
      - produto_network
    depends_on:
      - mongodb
    environment:
      - MONGODB_URI=mongodb://mongouser:mongopwd@mongodb:27017/admin
  
  mongodb:
    image: mongo:4.4.3
    ports:
      - "27017:27017"
    networks:
      - produto_network
    volumes:
      - mongo_vol:/data/db
    environment:
      - MONGO_INITDB_ROOT_USERNAME=mongouser
      - MONGO_INITDB_ROOT_PASSWORD=mongopwd



- Subindo o projeto do docker-compose usando o -d, para subir em segundo plano:
docker-compose up -d

fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ docker volume ls | grep produto
local     api-produto_mongo_vol
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ docker network ls | grep produto
64c349a38023   api-produto_produto_network   bridge    local
d782c4e366d8   produto_network               bridge    local
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$

fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ docker container ls
CONTAINER ID   IMAGE                         COMMAND                  CREATED         STATUS          PORTS                                           NAMES
e8e5610fe1bc   fernandomj90/api-produto:v1   "docker-entrypoint.s…"   8 minutes ago   Up 45 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp       api-produto_api_1
e0985ae732bf   mongo:4.4.3                   "docker-entrypoint.s…"   8 minutes ago   Up 45 seconds   0.0.0.0:27017->27017/tcp, :::27017->27017/tcp   api-produto_mongodb_1
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$


# Testes/Validação
- Testes via página do Swagger OK.
http://192.168.0.113:8080/api-docs/#/default/get_api_produto
- Testes, validando o cadastro no banco do Mongo, OK.





###
###
# Ajustando o Docker-compose - Comentando linhas das portas
  
  mongodb:
    image: mongo:4.4.3
    #ports:
    #  - "27017:27017"

- Criando novamente os Containers, agora sem associação de portas para o Mongo:

fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ docker-compose up -d
Creating network "api-produto_produto_network" with driver "bridge"
Creating api-produto_mongodb_1 ... done
Creating api-produto_api_1     ... done
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ docker container ls
CONTAINER ID   IMAGE                         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
75f37ddb2252   fernandomj90/api-produto:v1   "docker-entrypoint.s…"   22 seconds ago   Up 21 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   api-produto_api_1
e978b47c0ca2   mongo:4.4.3                   "docker-entrypoint.s…"   22 seconds ago   Up 21 seconds   27017/tcp                                   api-produto_mongodb_1
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$


Mesmo sem associação de portas, API segue funcionando:

fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ curl -X 'GET' \
>   'http://192.168.0.113:8080/api/produto' \
>   -H 'accept: application/json'
{"product":[{"_id":"621a59699300c1b2741021da","nome":"Geladeira2","preco":5100,"categoria":"Usados","__v":0}],"machine":"75f37ddb2252"}
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$



curl -X 'POST' \
  'http://192.168.0.113:8080/api/produto' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "id": "d290f1ee-6c54-4b01-90e6-d701748f0851",
  "nome": "Maverick",
  "preco": 229800,
  "categoria": "Carros"
}'

curl -X 'POST' \
  'http://192.168.0.113:8080/api/produto' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "id": "d290f1ee-6c54-4b01-90e6-d701748f0851",
  "nome": "Fusion",
  "preco": 113200,
  "categoria": "Carros"
}'


fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ curl -X 'GET'   'http://192.168.0.113:8080/api/produto'   -H 'accept: application/json'
{"product":[{"_id":"621a59699300c1b2741021da","nome":"Geladeira2","preco":5100,"categoria":"Usados","__v":0},{"_id":"621a5c5cdd38bd902b9f4bb4","nome":"Maverick","preco":229800,"categoria":"Carros","__v":0}],"machine":"75f37ddb2252"}
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$
curl -X 'POST' \
>   'http://192.168.0.113:8080/api/produto' \
>   -H 'accept: application/json' \
>   -d '{
>   "id": "d290f1ee-6c54-4b01-90e6-d701748f0851",
>   "nome": "Fusion",
>   "preco": 113200,
>   "categoria": "Carros"
> }'
{"_id":"621a5c87dd38bd3adf9f4bb7","nome":"Fusion","preco":113200,"categoria":"Carros","__v":0}
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ curl -X 'GET'   'http://192.168.0.113:8080/api/produto'   -H 'accept: application/json'
{"product":[{"_id":"621a59699300c1b2741021da","nome":"Geladeira2","preco":5100,"categoria":"Usados","__v":0},{"_id":"621a5c5cdd38bd902b9f4bb4","nome":"Maverick","preco":229800,"categoria":"Carros","__v":0},{"_id":"621a5c87dd38bd3adf9f4bb7","nome":"Fusion","preco":113200,"categoria":"Carros","__v":0}],"machine":"75f37ddb2252"}fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$


- Porém, sem associação de portas, não é possível o acesso via client do Robo3T ao banco do Mongo:

Error: error doing query: failed: network error while attempting to run command 'find' on host '192.168.0.113:27017' 



# Removendo os comentários das portas

    ports:
      - "27017:27017"

- Criando o container novamente usado o docker-compose, aplicando o up -d novamente, ele vai criar somente o container do Mongo:

fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ docker-compose up -d
Recreating api-produto_mongodb_1 ... done
api-produto_api_1 is up-to-date
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$

Banco do Mongo voltou a ficar acessível via Robo3T.




###
###
###
# Usando variáveis no Docker-compose

- Criar um arquivo .env na raíz do projeto.

- Ajustar o docker-compose, trocando a versão da image para uma variável:

DE:
image: fernandomj90/api-produto:v1

PARA:
image: fernandomj90/api-produto:${TAG}


docker-compose --env-file ./.env up -d

fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ docker-compose --env-file ./.env up -d
Starting api-produto_mongodb_1 ... done
Starting api-produto_api_1     ... done
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$


- Forçando um erro, trocando no arquivo .env a versão da TAG para v2:
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ docker-compose --env-file ./.env up -d
Creating network "api-produto_produto_network" with driver "bridge"
Pulling api (fernandomj90/api-produto:v2)...
ERROR: manifest for fernandomj90/api-produto:v2 not found: manifest unknown: manifest unknown
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$




###
###
###
# Efetuando build via docker-compose

- Necessário criar o bloco de configuração referente ao build no YAML do docker-compose:
- Exemplo:
    build:
      context: contextPath
      dockerfile: Dockerfile

- Editado:
    build:
      context: ./src
      dockerfile: ./Dockerfile

- Efetuar o build
docker-compose --env-file ./.env up -d

- ATENÇÃO
Devido o uso do context, não é necessário passar todo o path para indicar onde está o Dockerfile, já que ele está dentro daquele context.
sem o context, seria necessário informar ao docker-compose o caminho "./src/Dockerfile".

- Buildando:

fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ docker-compose --env-file ./.env up -d
Creating network "api-produto_produto_network" with driver "bridge"
Building api
Sending build context to Docker daemon  60.93kB
Step 1/7 : FROM node:14.15.4
 ---> 924763541c0c
Step 2/7 : WORKDIR /app
 ---> Using cache
 ---> 8a5b8622b79c
Step 3/7 : COPY package*.json ./
 ---> Using cache
 ---> 33e102d90e1e
Step 4/7 : RUN npm install
 ---> Using cache
 ---> 993b95bb211d
Step 5/7 : COPY . .
 ---> ba6db2ab0a0d
Step 6/7 : EXPOSE 8080
 ---> Running in 1dd08fd7664a
Removing intermediate container 1dd08fd7664a
 ---> 9dc514fc3f4d
Step 7/7 : CMD ["node", "app.js"]
 ---> Running in 1a7c01d1245c
Removing intermediate container 1a7c01d1245c
 ---> 6c578714ae69
Successfully built 6c578714ae69
Successfully tagged fernandomj90/api-produto:v3
WARNING: Image for service api was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating api-produto_mongodb_1 ... done
Creating api-produto_api_1     ... done
fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$


- Imagem criada, versão v3, conforme nosso arquivo .env:

fernando@debian10x64:~/cursos/kubedev/aula55-Docker-compose/api-produto$ docker image ls
REPOSITORY                                 TAG       IMAGE ID       CREATED              SIZE
fernandomj90/api-produto                   v3        6c578714ae69   About a minute ago   985MB



####
####
#### Simulando ajuste no projeto - Versão do Swagger

- Editar o arquivo YAML do Swagger:
vi /home/fernando/cursos/kubedev/aula55-Docker-compose/api-produto/src/swagger.yaml

Trocar a versão de 1.0.0 para 2.0.0

- Neste caso, vai ser necessário forçar o build novamente, senão o Docker-compose vai aproveitar o cache local.
- Use a opção --build para forçar novo build.
docker-compose --env-file ./.env up -d --build
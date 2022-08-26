
# ########################################################################################################################################
# Questão 06 - Desafio Docker

Agora vamos aumentar mais a complexidade das coisas, chegou a hora de executar
uma aplicação baseada em arquitetura de microsserviços.
Essa aplicação é formada por 3 repositórios:

Aplicação Web
<https://github.com/KubeDev/rotten-potatoes-ms>

Microsserviço de Filmes
<https://github.com/KubeDev/movie>

Microsserviço de Avaliação
<https://github.com/KubeDev/review>

Montar o ambiente com Docker compose baseado em arquivos de enviroment



# DIA 31/07/2022
- Criada estrutura e copiados os repos.


# PENDENTE
- Criar Dockerfile e docker-compose para subir os projetos.
- Começar pelo backend, "Aplicação Web", "rotten-potatoes-ms". Criar o Dockerfile, subir a aplicação em Python e o BD. Arquivo env.
- Usar env num arquivo, usar o [env_file] dentro do docker-compose.yml.


- Exemplo de uso do [env_file] dentro do docker-compose.yml:
<https://stackoverflow.com/questions/65484277/access-env-file-variables-in-docker-compose-file>

~~~~yaml
Or you can also specify the env file in docker-compose.yml:
database:
  ...
  env_file:
    - your-env-file.env
~~~~


- Pegar como base o docker-compose do Rotten Potatoes da questão4 como base:

~~~~yaml
version: '3'
services:

  flask:
    build:
      context: app
      dockerfile: Dockerfile
    container_name: flask
    image: fernandomj90/app-rotten-potatoes:v1
    ports:
      - 5000:5000
    environment:
      APP_PORT: 5000
      MONGODB_DB: admin
      MONGODB_DATABASE: admin
      MONGODB_USERNAME: mongouser
      MONGODB_PASSWORD: mongopwd
      MONGODB_HOSTNAME: mongodb
      MONGODB_HOST: mongodb
      MONGODB_PORT: 27017
#    volumes:
#      - appvolume:/app
    depends_on:
      - mongodb
    networks:
      - frontend
      - backend

  mongodb:
    image: mongo:4.0.8
    container_name: mongodb
    restart: unless-stopped
    command: mongod --auth
    environment:
      MONGO_INITDB_ROOT_USERNAME: mongouser
      MONGO_INITDB_ROOT_PASSWORD: mongopwd
      MONGO_INITDB_DATABASE: admin
      MONGODB_DATABASE: admin
      MONGODB_USER: mongouser
      MONGODB_PASS: mongopwd
      MONGODB_DATA_DIR: /data/db
      MONDODB_LOG_DIR: /dev/null
    ports:
      - "27017:27017"
    volumes:
      - mongodbdata:/data/db
    networks:
      - backend

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

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge

volumes:
  mongodbdata:
#  appvolume:
  nginxdata:
~~~~






- Criando Dockerfile para o Python.
- Ajustando diretório src.

~~~~Dockerfile
FROM python:3.6.1-alpine
RUN pip install --upgrade pip
RUN pip install -U pip setuptools wheel
RUN pip install markupsafe
RUN pip install flask
COPY ./src/app.py /app.py
COPY ./src/requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r /app/requirements.txt
COPY ./src .
CMD ["python","app.py"]
~~~~




- Editado o docker-compose, atual:

~~~~yaml
version: '3'
services:

  flask:
    build:
      context: ./rotten-potatoes-ms
      dockerfile: ./rotten-potatoes-ms/Dockerfile-Python.dockerfile
    container_name: flask
    image: fernandomj90/app-rotten-potatoes:v1
    ports:
      - 5000:5000
    environment:
      APP_PORT: 5000
      MONGODB_DB: admin
      MONGODB_DATABASE: admin
      MONGODB_USERNAME: mongouser
      MONGODB_PASSWORD: mongopwd
      MONGODB_HOSTNAME: mongodb
      MONGODB_HOST: mongodb
      MONGODB_PORT: 27017
#    env_file:
#    - your-env-file.env
#    volumes:
#      - appvolume:/app
    depends_on:
      - mongodb
    networks:
      - frontend
      - backend

  mongodb:
    image: mongo:4.0.8
    container_name: mongodb
    restart: unless-stopped
    command: mongod --auth
    environment:
      MONGO_INITDB_ROOT_USERNAME: mongouser
      MONGO_INITDB_ROOT_PASSWORD: mongopwd
      MONGO_INITDB_DATABASE: admin
      MONGODB_DATABASE: admin
      MONGODB_USER: mongouser
      MONGODB_PASS: mongopwd
      MONGODB_DATA_DIR: /data/db
      MONDODB_LOG_DIR: /dev/null
#    env_file:
#    - your-env-file.env
    ports:
      - "27017:27017"
    volumes:
      - mongodbdata:/data/db
    networks:
      - backend

#  webserver:
#    build:
#      context: nginx
#      dockerfile: Dockerfile
#    image: fernandomj90/nginx-alpine-desafio-docker:3.15.4
#    container_name: webserver
#    restart: unless-stopped
#    tty: true
#    environment:
#      APP_ENV: "prod"
#      APP_NAME: "webserver"
#      APP_DEBUG: "true"
#      SERVICE_NAME: "webserver"
#    ports:
#      - "80:80"
#      - "443:443"
#    volumes:
#      - nginxdata:/var/log/nginx
#    depends_on:
#      - flask
#    networks:
#      - frontend

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge

volumes:
  mongodbdata:
#  appvolume:
#  nginxdata:
~~~~


- Ajustando contexto e Dockerfile no docker-compose:
      context: ./rotten-potatoes-ms
      dockerfile: ./rotten-potatoes-ms/Dockerfile-Python.dockerfile

- Comando para executar o Container:
docker container run -p 8080:5000 -d fernandomj90/desafio-docker-questao6-microservicos:v1

- Usar docker-compose para subir os containers!
- Usar docker-compose para subir os containers!
- Usar docker-compose para subir os containers!
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao6
docker-compose up -d

- Acessível via:
<http://192.168.0.113:5000/>


- Trocado o nome da imagem no docker-compose
de:
    image: fernandomj90/app-rotten-potatoes:v1
para:
    image: fernandomj90/app-rotten-potatoes-microservicos:v1


- Ocorrendo erro durante subida:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$ docker-compose up -d
Building flask
unable to prepare context: unable to evaluate symlinks in Dockerfile path: lstat /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao6/rott-potatoes-ms/rotten-potatoes-ms: no such file or directory
ERROR: Service 'flask' failed to build : Build failed
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$
~~~~






- Segue ocorrendo erro durante subida:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$ docker-compose up -d
Building flask
unable to prepare context: unable to evaluate symlinks in Dockerfile path: lstat /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao6/rotten-potatoes-ms/rotten-potatoes-ms: no such file or directory
ERROR: Service 'flask' failed to build : Build failed
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$
~~~~

- Resolvido.
- Ajustado o caminho do Dockerfile, como o contexto esta para a pasta onde está o Dockerfile, não precisa ser passado para o Docker-compose o caminho relativo ou completo, e sim o simples.

DE:
      context: ./rotten-potatoes-ms
      dockerfile: ./rotten-potatoes-ms/Dockerfile-Python.dockerfile

PARA:
      context: ./rotten-potatoes-ms
      dockerfile: Dockerfile-Python.dockerfile







- ERRO:

~~~~bash
 Building wheel for Pillow (setup.py): finished with status 'error'
  ERROR: Command errored out with exit status 1:
   command: /usr/local/bin/python -u -c 'import io, os, sys, setuptools, tokenize; sys.argv[0] = '"'"'/tmp/pip-install-q4zeiurw/pillow_733878f1d2f34da6934aace81ce0be9f/setup.py'"'"'; __file__='"'"'/tmp/pip-install-q4zeiurw/pillow_733878f1d2f34da6934aace81ce0be9f/setup.py'"'"';f = getattr(tokenize, '"'"'open'"'"', open)(__file__) if os.path.exists(__file__) else io.StringIO('"'"'from setuptools import setup; setup()'"'"');code = f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' bdist_wheel -d /tmp/pip-wheel-abtyyqg3
       cwd: /tmp/pip-install-q4zeiurw/pillow_733878f1d2f34da6934aace81ce0be9f/
  Complete output (174 lines):
  ----------------------------------------
  ERROR: Failed building wheel for Pillow
~~~~




RUN pip install --upgrade pip
RUN pip install --upgrade Pillow

- Segue com erro.


- Tentando:

RUN apk add --no-cache jpeg-dev zlib-dev
RUN apk add --no-cache --virtual .build-deps build-base linux-headers \
    && pip install Pillow



- Agora resolveu!
- Containers subiram:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$ docker ps
CONTAINER ID   IMAGE                                               COMMAND                  CREATED         STATUS         PORTS                                           NAMES
6cc8292e11d3   fernandomj90/app-rotten-potatoes-microservicos:v1   "python app.py"          4 minutes ago   Up 4 minutes   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp       flask
d9a488e26d13   mongo:4.0.8                                         "docker-entrypoint.s…"   4 minutes ago   Up 4 minutes   0.0.0.0:27017->27017/tcp, :::27017->27017/tcp   mongodb
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$
~~~~



- Dentro do container:

/app #
/app # curl localhost:5000
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<title>500 Internal Server Error</title>
<h1>Internal Server Error</h1>
<p>The server encountered an internal error and was unable to complete your request. Either the server is overloaded or there is an error in the application.</p>
/app #




- Exemplo da questão3:
no arquivo aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso/ConversaoPeso.Web/Properties/launchSettings.json
      "applicationUrl": "https://localhost:5001;http://localhost:5000",





- Erros no container do flask:

~~~~bash
ConnectionRefusedError: [Errno 111] Connection refused

During handling of the above exception, another exception occurred:
 self, "Failed to establish a new connection: %s" % e
urllib3.exceptions.NewConnectionError: <urllib3.connection.HTTPConnection object at 0x7fe82ba73208>: Failed to establish a new connection: [Errno 111] Connection refused

During handling of the above exception, another exception occurred:
 raise MaxRetryError(_pool, url, error or ResponseError(cause))
urllib3.exceptions.MaxRetryError: HTTPConnectionPool(host='localhost', port=8181): Max retries exceeded with url: /api/movie (Caused by NewConnectionError('<urllib3.connection.HTTPConnection object at 0x7fe82ba73208>: Failed to establish a new connection: [Errno 111] Connection refused',))
requests.exceptions.ConnectionError: HTTPConnectionPool(host='localhost', port=8181): Max retries exceeded with url: /api/movie (Caused by NewConnectionError('<urllib3.connection.HTTPConnection object at 0x7fe82ba73208>: Failed to establish a new connection: [Errno 111] Connection refused',))
127.0.0.1 - - [06/Aug/2022 19:35:09] "GET / HTTP/1.1" 500 -
[2022-08-06 19:45:07,250] ERROR in app: Exception on / [GET]

ConnectionRefusedError: [Errno 111] Connection refused
  self, "Failed to establish a new connection: %s" % e
urllib3.exceptions.NewConnectionError: <urllib3.connection.HTTPConnection object at 0x7fe82b93f2b0>: Failed to establish a new connection: [Errno 111] Connection refused

  raise MaxRetryError(_pool, url, error or ResponseError(cause))
urllib3.exceptions.MaxRetryError: HTTPConnectionPool(host='localhost', port=8181): Max retries exceeded with url: /api/movie (Caused by NewConnectionError('<urllib3.connection.HTTPConnection object at 0x7fe82b93f2b0>: Failed to establish a new connection: [Errno 111] Connection refused',))

 raise ConnectionError(e, request=request)
requests.exceptions.ConnectionError: HTTPConnectionPool(host='localhost', port=8181): Max retries exceeded with url: /api/movie (Caused by NewConnectionError('<urllib3.connection.HTTPConnection object at 0x7fe82b93f2b0>: Failed to establish a new connection: [Errno 111] Connection refused',))
127.0.0.1 - - [06/Aug/2022 19:45:07] "GET / HTTP/1.1" 500 -
~~~~









- Necessário subir o container com o "movie" na porta 8181.
- Movie é em NodeJS.
- Importante, necessário definir a variável:
    environment:
      - MONGODB_URI=mongodb://mongouser:mongopwd@mongodb:27017/admin




- Criando Dockerfile.
- Usando exemplo da aula 54:

~~~~bash
fernando@debian10x64:~$ cd /home/fernando/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ ls
app.js  config  controllers  Dockerfile  models  node_modules  package.json  package-lock.json  routes  swagger.yaml
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ cat Dockerfile
FROM node:14.15.4
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD ["node", "app.js"]
~~~~



- Ajustando o Docker-compose.

~~~~yaml
  movies:
    image: fernandomj90/app-rotten-potatoes-movies:v1
    build:
      context: ./movie/src
      dockerfile: Dockerfile-NodeJS.dockerfile
    ports:
      - "8181:8181"
    networks:
      - backend
    depends_on:
      - mongodb
    environment:
      - MONGODB_URI=mongodb://mongouser:mongopwd@mongodb:27017/admin
~~~~




- Testando:

docker-compose up -d


- Buildou e subiu o container do Movies:

~~~~bash
Successfully built 19dd0aaad7ef
Successfully tagged fernandomj90/app-rotten-potatoes-movies:v1
WARNING: Image for service movies was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
mongodb is up-to-date
flask is up-to-date
Creating questao6_movies_1 ... done
~~~~



- Entrando no Container do Flask e testando:
docker exec -ti flask sh



/app # netstat -plant
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.11:41757        0.0.0.0:*               LISTEN      -
tcp        0      0 127.0.0.1:5000          0.0.0.0:*               LISTEN      1/python
/app #



- Segue com erros no Container do Flask/Python:

requests.exceptions.ConnectionError: HTTPConnectionPool(host='localhost', port=8181): Max retries exceeded with url: /api/movie (Caused by NewConnectionError('<urllib3.connection.HTTPConnection object at 0x7fe82b94d470>: Failed to establish a new connection: [Errno 111] Connection refused',))
127.0.0.1 - - [06/Aug/2022 20:49:45] "GET / HTTP/1.1" 500 -




- Container do Movies subiu corretamente.
- Curl na porta 8181 não funciona, mas os logs informam que subiu:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ curl localhost:8181
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Error</title>
</head>
<body>
<pre>Cannot GET /</pre>
</body>
</html>
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker ps
CONTAINER ID   IMAGE                                               COMMAND                  CREATED             STATUS             PORTS                                           NAMES
15b80ab1a4eb   fernandomj90/app-rotten-potatoes-movies:v1          "docker-entrypoint.s…"   3 minutes ago       Up 3 minutes       0.0.0.0:8181->8181/tcp, :::8181->8181/tcp       questao6_movies_1
6cc8292e11d3   fernandomj90/app-rotten-potatoes-microservicos:v1   "python app.py"          About an hour ago   Up About an hour   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp       flask
d9a488e26d13   mongo:4.0.8                                         "docker-entrypoint.s…"   About an hour ago   Up About an hour   0.0.0.0:27017->27017/tcp, :::27017->27017/tcp   mongodb
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker logs 15b80ab1a4eb
Servidor rodando na porta 8181
MongoDB populado com sucesso.
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$
~~~~



- Curl na porta 8181 informando o path /api/movie de fora dos Containers, a partir do Host Debian funciona corretamente:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ curl localhost:8181/api/movie | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
[{"_id":"62eed38ec377837c095d4151","title":"STAR WARS: O DESPERTAR DA FORÇA","summary":"Décadas após a queda de Darth Vader e do Império, surge uma nova ameaça: a Primeira Ordem, uma organização sombria que busca minar o poder da República e que tem Kylo Ren (Adam Driver), o General Hux (Domhnall Gleeson) e o Líder Supremo Snoke (Andy Serkis) como principais expoentes. Eles conseguem capturar Poe Dameron (Oscar Isaac), um dos principais pilotos da Resistência, que antes de ser preso envia através do pequeno robô BB-8 o mapa de onde vive o mitológico Luke Skywalker (Mark Hamill). Ao fugir pelo deserto, BB-8 encontra a jovem Rey (Daisy Ridley),
~~~~



- Testando dentro do Container do Flask/Python usando o nome do Service/Container ao invés de localhost, o curl funciona:

~~~~bash
/app #
/app # curl movies:8181/api/movie
[{"_id":"62eed38ec377837c095d4151","title":"STAR WARS: O DESPERTAR DA FORÇA","summary":"Décadas após a queda de Darth Vader e do Império, surge uma nova ameaça: a Primeira Ordem, uma organização sombria que busca minar o poder da República e que tem Kylo Ren (Adam Driver), o General Hux (Domhnall Gleeson) e o Líder Supremo Snoke (Andy Serkis) como principais expoentes. Eles conseguem capturar Poe Dameron (Oscar Isaac), um dos principais pilotos da Resistência, que antes de ser preso envia através do pequeno robô BB-8 o mapa de onde vive o mitológico Luke Skywalker (Mark Hamill). Ao fugir pe
~~~~



- Efetuando ajustado no caminho usado pelo Python para alcançar o Movies:
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao6/rotten-potatoes-ms/src/services/movie.py

DE:

~~~~python
class MovieService:

    def __init__(self):
        self.base_url = os.getenv("MOVIE_SERVICE_URI", "http://localhost:8181")
~~~~

PARA:

~~~~python
class MovieService:

    def __init__(self):
        self.base_url = os.getenv("MOVIE_SERVICE_URI", "http://movies:8181")
~~~~



- Removendo containers e criando novamente.




- Entrando no Container do Flask e testando:
docker exec -ti flask sh
curl localhost:5000


- Resolvido:

~~~~bash
/app #
/app # curl localhost:5000 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 11339<!DOCTYPE html>  100 0      0      0 --:--:-- --:--:-- --:--:--     0
 1<html lang="en">
1
3<head>
3       <meta charset="UTF-8">
9       <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1">

0       <title>Rotten Potatoes</title>

    0   692k      0 --:--:-- --:--:-- --:--:--  692k
/app #
/app #
/app #
/app #
/app # curl localhost:5000 | tail
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 11339  100 11339    0     0   692k      0 --:--:-- --:--:-- --:--:--  692k



        <script src="/js/jquery-1.11.1.min.js"></script>
        <script src="/js/plugins.js"></script>
        <script src="/js/app.js"></script>

</body>

</html>/app #
~~~~





- Logs trazendo 200 ao invés de 500 agora:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$ docker logs flask
 * Serving Flask app "app" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
127.0.0.1 - - [06/Aug/2022 21:08:22] "GET / HTTP/1.1" 200 -
127.0.0.1 - - [06/Aug/2022 21:08:28] "GET / HTTP/1.1" 200 -
127.0.0.1 - - [06/Aug/2022 21:08:32] "GET / HTTP/1.1" 200 -
fernando@debian10x64:~/cursos/kubedev/aula54-Segunda-aplicacao/api-produto/src$
~~~~







- Status atual:
1 - Python acessivel via curl na localhost:5000
2 - Python não está acessível via browser na 192.168.0.113:5000
3 - Movies acessível via curl movies:8181/api/movie 
4 - Movies acessível via Browser na http://192.168.0.113:8181/api/movie


# PENDENTE
- Subir aplicação dos Reviews.
- Necessário subir um bd em Postgres junto.



- Exemplo:

 db:
    image: postgres:14.1-alpine
    restart: always
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    ports:
      - '5432:5432'
    volumes: 
      - db:/var/lib/postgresql/data



- Editado:

 postgres:
    image: postgres:14.1-alpine
    restart: always
    environment:
      - POSTGRES_USER=pguser
      - POSTGRES_PASSWORD=Pg@123
    ports:
      - '5432:5432'
    volumes: 
      - db:/var/lib/postgresql/data
    networks:
      - backend





- Adicionado ao docker-compose.

- Editando o appsettings:
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao6/review/src/Review.Web/appsettings.json
DE:
    "MyConnection": "Host=localhost;Database=pguser;Username=pguser;Password=Pg@123;"
PARA:
    "MyConnection": "Host=postgres;Database=pguser;Username=pguser;Password=Pg@123;"



- Para subir os Reviews, irei usar Dockerfile de base:

~~~~Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /app
COPY . ./
RUN dotnet restore
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll"]
~~~~




- Criado o Dockerfile


- Ajustando Docker-compose, para criar o service do app de Reviews em C#:

  review:
    build:
      context: ./review/src/Review.Web/
      dockerfile: Dockerfile-C-Sharp.dockerfile
    container_name: review
    image: fernandomj90/app-rotten-potatoes-review:v1
    ports:
      - 8282:8282
    depends_on:
      - postgres
    networks:
      - frontend
      - backend




- Editados
aula56-Desafio-Docker/questao6/review/src/Review.Web/Dockerfile-C-Sharp.dockerfile
aula56-Desafio-Docker/questao6/docker-compose.yml
aula56-Desafio-Docker/questao6/review/src/Review.Web/appsettings.json


- Efetuar teste:
docker-compose up -d
docker exec -ti flask sh
curl localhost:5000



- Fazendo push
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git add .
git commit -m "Questão 6 - Desafio Docker - Microserviços"
git push



- Containers subiram, necessário validar tudo:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$ docker ps
CONTAINER ID   IMAGE                                               COMMAND                  CREATED          STATUS          PORTS                                           NAMES
3f1866148baa   postgres:14.1-alpine                                "docker-entrypoint.s…"   8 seconds ago    Up 7 seconds    0.0.0.0:5432->5432/tcp, :::5432->5432/tcp       postgres
82aee1457a6b   fernandomj90/app-rotten-potatoes-movies:v1          "docker-entrypoint.s…"   42 seconds ago   Up 39 seconds   0.0.0.0:8181->8181/tcp, :::8181->8181/tcp       movies
aae305403b56   fernandomj90/app-rotten-potatoes-review:v1          "dotnet Review.Web.d…"   53 seconds ago   Up 52 seconds   0.0.0.0:8282->8282/tcp, :::8282->8282/tcp       review
85890ad6685c   fernandomj90/app-rotten-potatoes-microservicos:v1   "python app.py"          45 minutes ago   Up 45 minutes   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp       flask
3ad60f9d1885   mongo:4.0.8                                         "docker-entrypoint.s…"   45 minutes ago   Up 45 minutes   0.0.0.0:27017->27017/tcp, :::27017->27017/tcp   mongodb
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$
~~~~




- Entrando no Container do Flask e testando:
docker exec -ti flask sh



- Sem comunicação com o Review

~~~~bash
/app #
/app # curl review:8182 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0curl: (7) Failed to connect to review port 8182: Connection refused
/app # curl review:8282 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0curl: (7) Failed to connect to review port 8282: Connection refused
/app # curl review:8282
curl: (7) Failed to connect to review port 8282: Connection refused
/app # curl review:8282/app
curl: (7) Failed to connect to review port 8282: Connection refused
/app # fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$
~~~~




- Adicionando no docker-compose o nome do banco de dados do Postgres
  - POSTGRES_DB=pguser




# PENDENTE
- Gunicorn para expor o Flask.
- Variáveis de ambiente no Flask.
- Seguir exemplo:
<https://github.com/nossadiretiva/rotten-potatoes-ms>


- Adicionando variáveis no Flask:
    environment:
      MOVIE_SERVICE_URI: http://movies:8181
      REVIEW_SERVICE_URI: http://review:8282


- Backup do Dockerfile do Flask atual:

~~~~Dockerfile
FROM python:3.6.1-alpine
RUN pip install --upgrade pip
RUN apk add --no-cache jpeg-dev zlib-dev
RUN apk add --no-cache --virtual .build-deps build-base linux-headers \
    && pip install Pillow
RUN pip install -U pip setuptools wheel
RUN pip install markupsafe
RUN pip install flask
COPY ./src/app.py /app.py
COPY ./src/requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r /app/requirements.txt
COPY ./src .
EXPOSE 5000
CMD ["python","app.py"]
~~~~


- Novo Dockerfile, contendo o Gunicorn como servidor Web:

~~~~Dockerfile
FROM python:3.6.1-alpine
RUN pip install --upgrade pip
RUN apk add --no-cache jpeg-dev zlib-dev
RUN apk add --no-cache --virtual .build-deps build-base linux-headers \
    && pip install Pillow
RUN pip install -U pip setuptools wheel
RUN pip install markupsafe
RUN pip install flask
RUN pip install gunicorn
COPY ./src/app.py /app.py
COPY ./src/requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r /app/requirements.txt
COPY ./src .

ENV FLASK_APP=./app.py
ENV FLASK_ENV=development

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
~~~~








- Testando
docker-compose up -d



- Deletado o container e a imagem do flask para recriar.
- Recriando.
- Subiram:

~~~~bash
Successfully built 87ea98742aea
Successfully tagged fernandomj90/app-rotten-potatoes-microservicos:v1
WARNING: Image for service flask was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
postgres is up-to-date
mongodb is up-to-date
review is up-to-date
movies is up-to-date
Creating flask ... done
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$ docker ps
CONTAINER ID   IMAGE                                               COMMAND                  CREATED          STATUS          PORTS                                           NAMES
e0aaeacd5d39   fernandomj90/app-rotten-potatoes-microservicos:v1   "gunicorn --bind 0.0…"   22 seconds ago   Up 21 seconds   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp       flask
e74ad33db2bb   fernandomj90/app-rotten-potatoes-movies:v1          "docker-entrypoint.s…"   2 minutes ago    Up 2 minutes    0.0.0.0:8181->8181/tcp, :::8181->8181/tcp       movies
f20c248a6b40   fernandomj90/app-rotten-potatoes-review:v1          "dotnet Review.Web.d…"   2 minutes ago    Up 2 minutes    0.0.0.0:8282->80/tcp, :::8282->80/tcp           review
928fa96728a8   mongo:4.0.8                                         "docker-entrypoint.s…"   2 minutes ago    Up 2 minutes    0.0.0.0:27017->27017/tcp, :::27017->27017/tcp   mongodb
9d155f0e2ae2   postgres:14.1-alpine                                "docker-entrypoint.s…"   2 minutes ago    Up 2 minutes    0.0.0.0:5432->5432/tcp, :::5432->5432/tcp       postgres
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$
~~~~

- Acessível via:
<http://192.168.0.113:5000/>




- Apresentando falha ao tentar acessar um Review especifico:
- Via navegador:
<http://192.168.0.113:5000/single/62eed38ec377837c095d415a>

- No container do Flask tem erros:

requests.exceptions.ConnectionError: HTTPConnectionPool(host='review', port=8282): Max retries exceeded with url: /api/review/62eed38ec377837c095d415a (Caused by NewConnectionError('<urllib3.connection.HTTPConnection object at 0x7f1ffb50eda0>: Failed to establish a new connection: [Errno 111] Connection refused',))





- No arquivo review.py o host está como localhost:
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao6/rotten-potatoes-ms/src/services/review.py
- Necessário ajustar para o nome do container do Review.

DE:

~~~~python
class ReviewService:

    def __init__(self):
        self.base_url = os.getenv("REVIEW_SERVICE_URI", "http://localhost:8282")
~~~~

PARA:

~~~~python
class ReviewService:

    def __init__(self):
        self.base_url = os.getenv("REVIEW_SERVICE_URI", "http://review:8282")
~~~~





- Segue com erro:

- Apresentando falha ao tentar acessar um Review especifico:
- Via navegador:
<http://192.168.0.113:5000/single/62eed38ec377837c095d415a>

- No container do Flask tem erros:
requests.exceptions.ConnectionError: HTTPConnectionPool(host='review', port=8282): Max retries exceeded with url: /api/review/62eed38ec377837c095d4152 (Caused by NewConnectionError('<urllib3.connection.HTTPConnection object at 0x7f17311e1908>: Failed to establish a new connection: [Errno 111] Connection refused',))





- Fazendo push
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git add .
git commit -m "Questão 6 - Desafio Docker - Microserviços"
git push



- Status atual:
1 - Python acessivel via  curl localhost:5000
2 - Python não está acessível via browser na 192.168.0.113:5000
3 - Movies acessível via  curl movies:8181/api/movie 
4 - Movies acessível via Browser na http://192.168.0.113:8181/api/movie



# PENDENTE
- Analisar a causa dos erros nos Reviews
- Testar usando telnet do Container do Flask para porta 8282 do review.
- Revisar código, listen, port, etc
- Seguir exemplo:
<https://github.com/nossadiretiva/rotten-potatoes-ms>
- Ajustar arquivos env, para não utilizar o env de dentro do Docker-compose, e sim em arquivos de Env.




# DIA 25/08/2022

- Logs de erro no container do Flask

  File "/usr/local/lib/python3.6/site-packages/requests/api.py", line 61, in request
    return session.request(method=method, url=url, **kwargs)
  File "/usr/local/lib/python3.6/site-packages/requests/sessions.py", line 542, in request
    resp = self.send(prep, **send_kwargs)
  File "/usr/local/lib/python3.6/site-packages/requests/sessions.py", line 655, in send
    r = adapter.send(request, **kwargs)
  File "/usr/local/lib/python3.6/site-packages/requests/adapters.py", line 516, in send
    raise ConnectionError(e, request=request)
requests.exceptions.ConnectionError: HTTPConnectionPool(host='review', port=8282): Max retries exceeded with url: /api/review/62eed38ec377837c095d4153 (Caused by NewConnectionError('<urllib3.connection.HTTPConnection object at 0x7fdf44420a20>: Failed to establish a new connection: [Errno 111] Connection refused',))
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$ pwd
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao6
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao6$


- Entrando no container do Flask
docker container exec -ti flask sh


/app # curl review:8282
curl: (7) Failed to connect to review port 8282: Connection refused
/app # curl review:8282/api/review/62eed38ec377837c095d4152
]curl: (7) Failed to connect to review port 8282: Connection refused
/app # ]





# PENDENTE
- Analisar a causa dos erros nos Reviews
- Testar usando telnet do Container do Flask para porta 8282 do review.
- Revisar código, listen, port, etc
- Seguir exemplo:
<https://github.com/nossadiretiva/rotten-potatoes-ms>
- Ajustar arquivos env, para não utilizar o env de dentro do Docker-compose, e sim em arquivos de Env.



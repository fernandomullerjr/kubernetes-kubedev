

# aula49-Primeira aplicacao em container

- Aplicação em Javascript que será usada na aula está no repositório:
https://github.com/KubeDev/conversao-temperatura


git clone https://github.com/KubeDev/conversao-temperatura.git

fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container$ git clone https://github.com/KubeDev/conversao-temperatura.git
Cloning into 'conversao-temperatura'...
remote: Enumerating objects: 29, done.
remote: Counting objects: 100% (16/16), done.
remote: Compressing objects: 100% (10/10), done.
remote: Total 29 (delta 7), reused 6 (delta 6), pack-reused 13
Unpacking objects: 100% (29/29), done.
fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container$



- Trata-se de uma aplicação que faz a conversão de temperatura Celsius para Fahrenheit e vice-versa.
- Iremos rodar a aplicação localmente, como ela tem um backend em Javascript, iremos precisar do Node e do NPM previamente instalados.

-Instalando o Node e o NPM:
/home/fernando/cursos/kubedev/aula49-Primeira-aplicacao-em-container/node-instalacao.sh


- Acessar o diretório src do projeto de Conversão de temperatura:

cd /home/fernando/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src

fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$ ls
config  convert.js  package.json  package-lock.json  server.js  swagger.yaml  views
fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$ pwd
/home/fernando/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src
fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$


- No arquivo "package.json" tem todos os arquivos, dependências e bibliotecas do projeto:
cat /home/fernando/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src/package.json


- Executar o comando "npm install" para fazer a instalação dos pacotes:

npm install

fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$ npm install
npm WARN npm npm does not support Node.js v10.24.0
npm WARN npm You should probably upgrade to a newer version of node as we
npm WARN npm can t make any promises that npm will work with this version.
npm WARN npm Supported releases of Node.js are the latest release of 4, 6, 7, 8, 9.
npm WARN npm You can find the latest version at https://nodejs.org/
npm WARN notice [SECURITY] swagger-ui-dist has the following vulnerability: 1 moderate. Go here for more details: https://www.npmjs.com/advisories?search=swagger-ui-dist&version=3.34.0 - Run `npm i npm@latest -g` to upgrade your npm version, and then `npm audit` to get more info.
npm WARN conversao-temperatura@1.0.0 No description

added 77 packages from 57 contributors in 2.795s
fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$



- Depois de concluída a instalação, o Node cria uma pasta chamada "node_modules" contendo todos os pacotes necessários para a aplicação rodar corretamente:

fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$ ls
config  convert.js  node_modules  package.json  package-lock.json  server.js  swagger.yaml  views
fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$



- Rodando o comando, a aplicação começa a rodar na porta 8080, conforme o esperado:

node server.js

fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$ node server.js
Servidor rodando na porta 8080



- Validando o acesso a aplicação:

fernando@debian10x64:~$ curl localhost:8080 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3921  100  3921    0     0   191k      0 --:--:-- --:--:-- --:--:--  191k
<!doctype html>
<html lang="en" class="h-100">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
    <meta name="generator" content="Hugo 0.87.0">
    <title>Sticky Footer Navbar Template · Bootstrap v5.1</title>
fernando@debian10x64:~$ curl localhost:8080 | tail
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3921  100  3921    0     0   319k      0 --:--:-- --:--:-- --:--:--  319k
        </div>
    </main>
    <footer class="footer mt-auto py-3 bg-light">
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-U1DAWAznBHeqEIlVSCgzq+c9gqGAJn5c/t99JyeKa9xxaYpSvHU5awsuZVVFIhvj"
        crossorigin="anonymous"></script>
</body>

</html>fernando@debian10x64:~$



- Utilizar a imagem base oficial do node. https://hub.docker.com/_/node
- Definir um WORKDIR desejado
- Copyar todos os arquivos que comecem com package.
- Efetuar o npm install.
- Usar as camadas para ganhar desempenho.
- Deixar para usar o COPY e copiar todos os arquivos, somente depois de executado o npm install.

- Dockerfile criado:
vi /home/fernando/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src/Dockerfile

FROM node
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD ["node", "server.js"]


- Buildar a imagem da aplicação:

docker image build -t conversao-temperatura .

fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$ docker image build -t conversao-temperatura .
Sending build context to Docker daemon  22.59MB
Step 1/7 : FROM node
latest: Pulling from library/node
0c6b8ff8c37e: Pull complete
[...]
Removing intermediate container f061c993a8f9
 ---> ae4f73757edf
Step 5/7 : COPY . .
 ---> 8794bc9a7943
Step 6/7 : EXPOSE 8080
 ---> Running in 49544fa4b7e9
Removing intermediate container 49544fa4b7e9
 ---> dad13c36ce38
Step 7/7 : CMD ["node", "server.js"]
 ---> Running in 5032a538ce65
Removing intermediate container 5032a538ce65
 ---> 5cbc67dc6874
Successfully built 5cbc67dc6874
Successfully tagged conversao-temperatura:latest
fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$ ^C
fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$


- Verificando a imagem criada:

fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$ docker image ls
REPOSITORY                          TAG       IMAGE ID       CREATED             SIZE
conversao-temperatura               latest    5cbc67dc6874   9 minutes ago       1.05GB


docker container run -d -p 8080:8080 <nome-da-image>
docker container run -d -p 8080:8080 conversao-temperatura

fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$ ^C
fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$ docker container run -d -p 8080:8080 conversao-temperatura
e1e03b26d80cb6732625015cf2c7aad1f8f8e08921de68fbfc772a1d122864ba
fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$ docker container ps
CONTAINER ID   IMAGE                   COMMAND                  CREATED         STATUS         PORTS                                       NAMES
e1e03b26d80c   conversao-temperatura   "docker-entrypoint.s…"   5 seconds ago   Up 2 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   musing_allen
fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$


- Testando a aplicação rodando no Container:

curl localhost:8080 | head

fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$ ^C
fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$ curl localhost:8080 | head
[...]]
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
    <meta name="generator" content="Hugo 0.87.0">
    <title>Sticky Footer Navbar Template · Bootstrap v5.1</title>
fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$


- Testando a exclusão do Container e o acesso a página de conversão de temperatura:

fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$ docker container rm -f e1e03b26d80c
e1e03b26d80c
fernando@debian10x64:~/cursos/kubedev/aula49-Primeira-aplicacao-em-container/conversao-temperatura/src$

Não foi possível conectar
O Firefox não conseguiu estabelecer uma conexão com o servidor 192.168.0.113:8080.



- Criando o Container novamente:

docker container run -d -p 8080:8080 conversao-temperatura





- Efetuando teste trazendo o COPY dos arquivos para antes no Dockerfile:

FROM node
WORKDIR /app
COPY . .
# COPY package*.json ./
RUN npm install
EXPOSE 8080
CMD ["node", "server.js"]


-
- Buildar a imagem da aplicação novamente:

docker image build -t conversao-temperatura .
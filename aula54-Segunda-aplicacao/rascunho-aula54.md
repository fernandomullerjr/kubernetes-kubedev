

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
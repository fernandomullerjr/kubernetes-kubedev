

# aula 50 -  Boas práticas pra construção de imagem



# Nomeando sua imagem Docker
- Nomeando sua imagem Docker.

namespace/repositorio:versão-da-imagem



- Buildar a imagem da aplicação novamente, agora com o Namespace e a versão da imagem:
cd /home/fernando/cursos/kubedev/aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src
docker image build -t fernandomj90/conversao-temperatura:v1 .

fernando@debian10x64:~/cursos/kubedev/aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src$ docker image build -t fernandomj90/conversao-temperatura:v1 .
Sending build context to Docker daemon  22.59MB
Step 1/7 : FROM node
 ---> f8c8d04432c3
Step 2/7 : WORKDIR /app
 ---> Using cache
 ---> 1232a7e56835
Step 3/7 : COPY package*.json ./
 ---> Using cache
 ---> 18bedc4cfac5
Step 4/7 : RUN npm install
 ---> Using cache
 ---> ae4f73757edf
Step 5/7 : COPY . .
 ---> 5e0d3052cff5
Step 6/7 : EXPOSE 8080
 ---> Running in b46b5b273a29
Removing intermediate container b46b5b273a29
 ---> 5e497bb5ae24
Step 7/7 : CMD ["node", "server.js"]
 ---> Running in b41725182a75
Removing intermediate container b41725182a75
 ---> d8f8773d1605
Successfully built d8f8773d1605
Successfully tagged fernandomj90/conversao-temperatura:v1
fernando@debian10x64:~/cursos/kubedev/aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src$


- Verificando a lista de imagens, agora está correto:

fernando@debian10x64:~/cursos/kubedev/aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src$ docker image ls
REPOSITORY                           TAG       IMAGE ID       CREATED             SIZE
fernandomj90/conversao-temperatura   v1        d8f8773d1605   26 seconds ago      1.05GB
conversao-temperatura                latest    51dd5e18e6bc   About an hour ago   1.02GB





# Preferência a imagens oficiais
- Evitar usar imagens não-oficiais de origem duvidosa.


# Sempre especifique a tag nas imagens
- Fazendo a fixação da versão da imagem nós conseguimos garantir o funcionamento do Container de forma igual.
- Isto preserva a idempotência, que é a garantia que a operação se manterá igual a aplicação inicial.
" a idempotência é a propriedade que algumas operações têm de poderem ser aplicadas várias vezes sem que o valor do resultado se altere após a aplicação inicial."
"idempotência, termo muito utilizado na matemática ou em ciência da computação para indicar a propriedade que algumas operações têm de poderem ser aplicadas várias 
vezes sem que o valor do resultado se altere após a aplicação inicial. Ou seja, uma vez aplicado o seu código terraform, você poderá aplicá-lo quantas vezes 
desejar e nenhuma alteração será feita em sua infraestrutura, a menos que você tenha de fato alterado algo em seu código."

- Fixando a versão "14.17.5" do Node no Dockerfile:

FROM node:14.17.5
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD ["node", "server.js"]


- Buildar a imagem da aplicação novamente, agora com a versão do Node fixada:
cd /home/fernando/cursos/kubedev/aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src
docker image build -t fernandomj90/conversao-temperatura:v1 .

fernando@debian10x64:~/cursos/kubedev/aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src$ docker image build -t fernandomj90/conversao-temperatura:v1 .
Sending build context to Docker daemon  22.59MB
Step 1/7 : FROM node:14.17.5
[...]
Digest: sha256:c1fa7759eeff3f33ba08ff600ffaca4558954722a4345653ed1a0d87dffed9aa
Status: Downloaded newer image for node:14.17.5
 ---> 256d6360f157
Step 2/7 : WORKDIR /app
 ---> Running in 403a883f3e3d
Removing intermediate container 403a883f3e3d
 ---> b608d4d17065
Step 3/7 : COPY package*.json ./
 ---> c408f0a661f7
Step 4/7 : RUN npm install
 ---> 1234cc279a21
Step 5/7 : COPY . .
 ---> 7fc4b291da5b
Step 6/7 : EXPOSE 8080
 ---> Running in f62e7e02f4c2
Removing intermediate container f62e7e02f4c2
 ---> cd070a34c531
Step 7/7 : CMD ["node", "server.js"]
 ---> Running in b18fe8cb91cd
Removing intermediate container b18fe8cb91cd
 ---> da8668e020c8
Successfully built da8668e020c8
Successfully tagged fernandomj90/conversao-temperatura:v1
fernando@debian10x64:~/cursos/kubedev/aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src$


- Verificando a nova imagem:

fernando@debian10x64:~/cursos/kubedev/aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src$ docker image ls
REPOSITORY                           TAG       IMAGE ID       CREATED             SIZE
fernandomj90/conversao-temperatura   v1        da8668e020c8   25 seconds ago      995MB
node                                 14.17.5   256d6360f157   5 months ago        944MB
node                                 latest    f8c8d04432c3   2 days ago          994MB





# Um processo por Container
-Não deixar um container com mais de um microserviço nele, procurar deixar tudo separado.

# Aproveitamento das camadas de imagem
- Otimizar o uso das camadas, para evitar desperdicio de tempo e retrabalho desnecessário.


# Use o .dockerignore
- Usar o dockerignore para ignorar pastas que não devem ser copiadas no processo do Build da imagem, por exemplo a "node_modules".

- Criar arquivo .dockerignore:
vi /home/fernando/cursos/kubedev/aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src/.dockerignore

dentro do arquivo, adicionar o nome da pasta que deve ser ignorada, seguida de uma barra:
node_modules/


- Buildar a imagem da aplicação novamente, agora com o .dockerignore ignorando a pasta node_modules:
cd /home/fernando/cursos/kubedev/aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src
docker image build -t fernandomj90/conversao-temperatura:v1 .

fernando@debian10x64:~/cursos/kubedev/aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src$ docker image build -t fernandomj90/conversao-temperatura:v1 .
Sending build context to Docker daemon  43.01kB
Step 1/7 : FROM node:14.17.5
 ---> 256d6360f157
Step 2/7 : WORKDIR /app
 ---> Using cache
 ---> b608d4d17065
Step 3/7 : COPY package*.json ./
 ---> Using cache
 ---> c408f0a661f7
Step 4/7 : RUN npm install
 ---> Using cache
 ---> 1234cc279a21
Step 5/7 : COPY . .
 ---> 367f071045e0
Step 6/7 : EXPOSE 8080
 ---> Running in 65a3f5196de3
Removing intermediate container 65a3f5196de3
 ---> cc88a57b5c5a
Step 7/7 : CMD ["node", "server.js"]
 ---> Running in 4d9d2be59aba
Removing intermediate container 4d9d2be59aba
 ---> d37d18112918
Successfully built d37d18112918
Successfully tagged fernandomj90/conversao-temperatura:v1
fernando@debian10x64:~/cursos/kubedev/aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src$



- Buildar a imagem da aplicação novamente, adicionando o "package.json" no dockerignore, fazendo com que o Build apresente erro:

vi aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src/.dockerignore

node_modules/
package.json

cd /home/fernando/cursos/kubedev/aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src
docker image build -t fernandomj90/conversao-temperatura:v1 .

fernando@debian10x64:~/cursos/kubedev/aula50-Boas-praticas-pra-construcao-de-imagem/conversao-temperatura/src$ docker image build -t fernandomj90/conversao-temperatura:v1 .
Sending build context to Docker daemon  41.47kB
[...]]
Step 4/7 : RUN npm install
 ---> Running in f45cb35b5d3f
npm WARN saveError ENOENT: no such file or directory, open '/app/package.json'
npm WARN enoent ENOENT: no such file or directory, open '/app/package.json'
npm WARN app No description
npm WARN app No repository field.
npm WARN app No README data
npm WARN app No license field.

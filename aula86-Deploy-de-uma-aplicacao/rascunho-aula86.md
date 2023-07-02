
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# push

git status
git add .
git commit -m "aula86 - Subindo a aplicação. pt1"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status


# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# Subindo a aplicação


# Imagem Docker para o projeto

- Projeto que será usado na aula:
<https://github.com/KubeDev/pedelogo-catalogo>

- É uma aplicação DotNet Core.

- Clonando o projeto:
cd /home/fernando/cursos/kubedev/aula86-Deploy-de-uma-aplicacao
git clone https://github.com/KubeDev/pedelogo-catalogo.git



- É necessário criar um Dockerfile
- Usaremos Multistage, pois não é necessário fazer o restore toda vez que formos executar o Container. Este processo de restore baixa todos os pacotes do repositório no Get.


~~~~Dockerfile
#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["src/PedeLogo.Catalogo.Api/PedeLogo.Catalogo.Api.csproj", "src/PedeLogo.Catalogo.Api/"]
RUN dotnet restore "src/PedeLogo.Catalogo.Api/PedeLogo.Catalogo.Api.csproj"
COPY . .
WORKDIR "/src/src/PedeLogo.Catalogo.Api"
RUN dotnet build "PedeLogo.Catalogo.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PedeLogo.Catalogo.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PedeLogo.Catalogo.Api.dll"]
~~~~



- Atenção ao contexto!
- Cuidar que o Dockerfile tá alguns níveis abaixo.

docker build -t fernandomj90/pedelogo-catalogo:v1.0.0 -f /home/fernando/cursos/kubedev/aula86-Deploy-de-uma-aplicacao/pedelogo-catalogo/src/PedeLogo.Catalogo.Api/Dockerfile /home/fernando/cursos/kubedev/aula86-Deploy-de-uma-aplicacao/pedelogo-catalogo/

fernando@debian10x64:~/cursos/kubedev/aula86-Deploy-de-uma-aplicacao/pedelogo-catalogo/src/PedeLogo.Catalogo.Api$ docker image ls
REPOSITORY                                       TAG               IMAGE ID       CREATED         SIZE
fernandomj90/pedelogo-catalogo                   v1.0.0            99b6b0738966   2 minutes ago   218MB


- Efetuar o push da imagem Docker para o Docker Hub
docker login


fernando@debian10x64:~/cursos/kubedev/aula86-Deploy-de-uma-aplicacao/pedelogo-catalogo/src/PedeLogo.Catalogo.Api$ docker login
Authenticating with existing credentials...
WARNING! Your password will be stored unencrypted in /home/fernando/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
fernando@debian10x64:~/cursos/kubedev/aula86-Deploy-de-uma-aplicacao/pedelogo-catalogo/src/PedeLogo.Catalogo.Api$


docker push fernandomj90/pedelogo-catalogo:v1.0.0
docker push fernandomj90/pedelogo-catalogo:v1.0.0
docker push fernandomj90/pedelogo-catalogo:v1.0.0

- Push concluído:

fernando@debian10x64:~/cursos/kubedev/aula86-Deploy-de-uma-aplicacao/pedelogo-catalogo/src/PedeLogo.Catalogo.Api$ docker push fernandomj90/pedelogo-catalogo:v1.0.0
The push refers to repository [docker.io/fernandomj90/pedelogo-catalogo]
5a92149b9cfe: Pushed
cab61a26b4c5: Pushed
b8fab273dc5c: Pushed
9a5a448cff0d: Pushed
1d913fbe86d4: Pushed
7643c9c4cffe: Pushed
e06e631d87d6: Pushed
v1.0.0: digest: sha256:b3fd9e14a4663ba637a3d37596afe9534d57447f5d2245eb578947c3fbcad656 size: 1793
fernando@debian10x64:~/cursos/kubedev/aula86-Deploy-de-uma-aplicacao/pedelogo-catalogo/src/PedeLogo.Catalogo.Api$

<https://hub.docker.com/repository/docker/fernandomj90/pedelogo-catalogo>




# Estrutura Kubernetes

- Criar pasta k8s, para armazenar os manifestos.
mkdir k8s

continua em 16:00min

# push

git status
git add .
git commit -m "aula86 - Subindo a aplicação. pt2"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



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
# Aplicação escrita em C# utilizando ASP.NET Core

- Projeto no meu Github pessoal, forkeado do KubeDev:
<https://github.com/fernandomullerjr/conversao-peso>


- Dockerfile obtido na página da Microsoft:
<https://docs.microsoft.com/pt-br/dotnet/core/docker/build-container?tabs=windows>

~~~~Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "DotNet.Docker.dll"]
~~~~



- Buildando
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso/ConversaoPeso.Web
docker image build -t fernandomj90/desafio-docker-questao3-csharp-asp-net:v1 .


~~~~bash

fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso/ConversaoPeso.Web$ cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso/ConversaoPeso.Web
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso/ConversaoPeso.Web$ docker image build -t fernandomj90/desafio-docker-questao3-csharp-asp-net:v1 .
Sending build context to Docker daemon  4.372MB
Step 1/9 : FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
6.0: Pulling from dotnet/sdk
214ca5fb9032: Pull complete
4813ba3ff249: Pull complete
8bb0bf4915d9: Pull complete
9d96205985fb: Pull complete
371dd5e166f2: Pull complete
9e9210de422f: Pull complete
fe5e96c6f5fd: Pull complete
b9a60488eb85: Pull complete
Digest: sha256:59d5f3cfa61923f035d160c3452f45b8bbbb79222ec3433476b58dfa2553a80f
Status: Downloaded newer image for mcr.microsoft.com/dotnet/sdk:6.0
 ---> d3863aa157b5
Step 2/9 : WORKDIR /app
 ---> Running in 0f62e5014e3b
Removing intermediate container 0f62e5014e3b
 ---> 109e75a1b2da
Step 3/9 : COPY . ./
 ---> a25ad4d7a8ac
Step 4/9 : RUN dotnet restore
 ---> Running in 919205eaaf03
  Determining projects to restore...
  Restored /app/ConversaoPeso.Web.csproj (in 26.42 sec).
Removing intermediate container 919205eaaf03
 ---> e25dfcfb63b8
Step 5/9 : RUN dotnet publish -c Release -o out
 ---> Running in e5900ed4e04e
Microsoft (R) Build Engine version 17.2.0+41abc5629 for .NET
Copyright (C) Microsoft Corporation. All rights reserved.

  Determining projects to restore...
  All projects are up-to-date for restore.
  ConversaoPeso.Web -> /app/bin/Release/net5.0/ConversaoPeso.Web.dll
  ConversaoPeso.Web -> /app/bin/Release/net5.0/ConversaoPeso.Web.Views.dll
  ConversaoPeso.Web -> /app/out/
Removing intermediate container e5900ed4e04e
 ---> 281ceb849ae8
Step 6/9 : FROM mcr.microsoft.com/dotnet/aspnet:6.0
6.0: Pulling from dotnet/aspnet
214ca5fb9032: Already exists
4813ba3ff249: Already exists
8bb0bf4915d9: Already exists
9d96205985fb: Already exists
371dd5e166f2: Already exists
Digest: sha256:e0189fa2887805b5344d28deb397ce4cdda24a12e1690a4aaa24ee98c9930891
Status: Downloaded newer image for mcr.microsoft.com/dotnet/aspnet:6.0
 ---> 70f39e2150e1
Step 7/9 : WORKDIR /app
 ---> Running in 6a90561b5b6b
Removing intermediate container 6a90561b5b6b
 ---> 996451d54d3a
Step 8/9 : COPY --from=build-env /app/out .
 ---> 90f13b218166
Step 9/9 : ENTRYPOINT ["dotnet", "DotNet.Docker.dll"]
 ---> Running in 365b3ea76afa
Removing intermediate container 365b3ea76afa
 ---> cf3817d11889
Successfully built cf3817d11889
Successfully tagged fernandomj90/desafio-docker-questao3-csharp-asp-net:v1
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso/ConversaoPeso.Web$ ^C
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso/ConversaoPeso.Web$


fernando@debian10x64:~$ docker image ls | head
REPOSITORY                                                                      TAG                  IMAGE ID       CREATED          SIZE
fernandomj90/desafio-docker-questao3-csharp-asp-net                             v1                   cf3817d11889   19 seconds ago   217MB
<none>                                                                          <none>               281ceb849ae8   23 seconds ago   798MB

~~~~




- Criando o Container e rodando:
docker container run -p 7755:80 -d fernandomj90/desafio-docker-questao3-csharp-asp-net:v1




- Container morreu.
- Verificando os detalhes, no Dockerfile que foi criado ele tenta executar um arquivo chamado [DotNet.Docker.dll] via ENTRYPOINT, que não existe.
~~~~bash
fernando@debian10x64:~$ ^C
fernando@debian10x64:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
fernando@debian10x64:~$ docker container run -p 7755:80 -d fernandomj90/desafio-docker-questao3-csharp-asp-net:v1
6e67a9d2e4b42398a47ee4c8f07bc5eafb5466dfa1eeaec94053391c25ddbd87
fernando@debian10x64:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
fernando@debian10x64:~$ docker ps -a
CONTAINER ID   IMAGE                                                    COMMAND                  CREATED         STATUS                        PORTS                                       NAMES
6e67a9d2e4b4   fernandomj90/desafio-docker-questao3-csharp-asp-net:v1   "dotnet DotNet.Docke…"   8 seconds ago   Exited (145) 7 seconds ago                                                clever_bassi
d3aa5687378d   fernandomj90/desafio-docker-questao3-python-flask:v2     "python app.py"          4 days ago      Exited (255) 34 minutes ago   0.0.0.0:8080->5000/tcp, :::8080->5000/tcp   optimistic_cori
e4d4b7cf96a2   ddd6300d05a3                                             "/bin/sh -c 'pip ins…"   2 weeks ago     Exited (1) 2 weeks ago                                                    trusting_jang
0784ec3f7ae6   ddd6300d05a3                                             "/bin/sh -c 'pip ins…"   2 weeks ago     Exited (1) 2 weeks ago                                                    nice_euler
3de76aefdde6   ddd6300d05a3                                             "/bin/sh -c 'pip ins…"   2 weeks ago     Exited (1) 2 weeks ago                                                    jovial_raman
fernando@debian10x64:~$ docker logs clever_bassi
Could not execute because the application was not found or a compatible .NET SDK is not installed.
Possible reasons for this include:
  * You intended to execute a .NET program:
      The application 'DotNet.Docker.dll' does not exist.
  * You intended to execute a .NET SDK command:
      It was not possible to find any installed .NET SDKs.
      Install a .NET SDK from:
        https://aka.ms/dotnet-download
fernando@debian10x64:~$
~~~~




- Verificando um script Dockerfile da página do Docker:
<https://docs.docker.com/samples/dotnetcore/>
~~~~~Dockerfile
# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY ../engine/examples ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
~~~~~



- Site
<https://github.com/dotnet/dotnet-docker/blob/main/samples/aspnetapp/Dockerfile>

~~~~~Dockerfile
# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY aspnetapp/*.csproj ./aspnetapp/
RUN dotnet restore

# copy everything else and build app
COPY aspnetapp/. ./aspnetapp/
WORKDIR /source/aspnetapp
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
~~~~~



- Buildando
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso/ConversaoPeso.Web
docker image build -t fernandomj90/desafio-docker-questao3-csharp-asp-net:v2 .

- Criando o Container e rodando:
docker container run -p 7755:80 -d fernandomj90/desafio-docker-questao3-csharp-asp-net:v2

~~~~bash
fernando@debian10x64:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
fernando@debian10x64:~$
fernando@debian10x64:~$ cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso/ConversaoPeso.Web
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso/ConversaoPeso.Web$ docker image build -t fernandomj90/desafio-docker-questao3-csharp-asp-net:v2 .
Sending build context to Docker daemon  4.374MB
Step 1/11 : FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
 ---> d3863aa157b5
Step 2/11 : WORKDIR /source
 ---> Running in 7e0f1ffff4cc
Removing intermediate container 7e0f1ffff4cc
 ---> 986e108171a3
Step 3/11 : COPY *.csproj ./aspnetapp/
 ---> e09b00b83aa8
Step 4/11 : RUN dotnet restore
 ---> Running in 7605f7fdc423
MSBUILD : error MSB1003: Specify a project or solution file. The current working directory does not contain a project or solution file.
The command '/bin/sh -c dotnet restore' returned a non-zero code: 1
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso/ConversaoPeso.Web$
~~~~





~~~~~Dockerfile
# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY ConversaoPeso.Web/*.csproj ./aspnetapp/
RUN dotnet restore

# copy everything else and build app
COPY . ./aspnetapp/
WORKDIR /source/aspnetapp
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
~~~~~


- Buildando
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso
docker image build -t fernandomj90/desafio-docker-questao3-csharp-asp-net:v2 .

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso$ docker image build -t fernandomj90/desafio-docker-questao3-csharp-asp-net:v2 .
Sending build context to Docker daemon  5.189MB
Step 1/12 : FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
 ---> d3863aa157b5
Step 2/12 : WORKDIR /source
 ---> Using cache
 ---> 986e108171a3
Step 3/12 : COPY *.sln .
 ---> 7f419961e624
Step 4/12 : COPY ConversaoPeso.Web/*.csproj ./aspnetapp/
 ---> ed735732506c
Step 5/12 : RUN dotnet restore
 ---> Running in fe6850d04dd6
/usr/share/dotnet/sdk/6.0.300/NuGet.targets(289,5): error MSB3202: The project file "/source/ConversaoPeso.Web/ConversaoPeso.Web.csproj" was not found. [/source/ConversaoPeso.sln]
The command '/bin/sh -c dotnet restore' returned a non-zero code: 1
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso$
~~~~







/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso/Dockerfile-NOK-1
~~~~~Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "DotNet.Docker.dll"]
~~~~~

- Buildando
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso
docker image build -f Dockerfile-NOK-1 -t fernandomj90/desafio-docker-questao3-csharp-asp-net:v2 .

- Criando o Container e rodando:
docker container run -p 7755:80 -d fernandomj90/desafio-docker-questao3-csharp-asp-net:v2
~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso$ docker logs keen_bhaskara
Could not execute because the application was not found or a compatible .NET SDK is not installed.
Possible reasons for this include:
  * You intended to execute a .NET program:
      The application 'DotNet.Docker.dll' does not exist.
  * You intended to execute a .NET SDK command:
      It was not possible to find any installed .NET SDKs.
      Install a .NET SDK from:
        https://aka.ms/dotnet-download
~~~~





- Editando o ENTRYPOINT.
- Efetuando novo teste.

~~~~~Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
~~~~~

- Buildando
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso
docker image build -f Dockerfile-NOK-1 -t fernandomj90/desafio-docker-questao3-csharp-asp-net:v2 .

- Criando o Container e rodando:
docker container run -p 7755:80 -d fernandomj90/desafio-docker-questao3-csharp-asp-net:v2


~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso$ docker logs sad_roentgen
Could not execute because the application was not found or a compatible .NET SDK is not installed.
Possible reasons for this include:
  * You intended to execute a .NET program:
      The application 'aspnetapp.dll' does not exist.
  * You intended to execute a .NET SDK command:
      It was not possible to find any installed .NET SDKs.
      Install a .NET SDK from:
        https://aka.ms/dotnet-download
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/csharp-asp-net/conversao-peso$
~~~~




# PENDENTE
- Verificar motivo da falha ao subir container com ASP NET CORE.
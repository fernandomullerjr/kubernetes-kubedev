
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

- Projeto que será usado na aula:
<https://github.com/KubeDev/pedelogo-catalogo>

- É uma aplicação DotNet Core.

- Clonando o projeto:
cd /home/fernando/cursos/kubedev/aula86-Deploy-de-uma-aplicacao
git clone https://github.com/KubeDev/pedelogo-catalogo.git



- É necessário criar um Dockerfile
- Usaremos Multistage, pois não é necessário fazer o restore toda vez que formos executar o Container.


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
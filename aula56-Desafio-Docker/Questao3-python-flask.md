


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
# Aplicação escrita em Python utilizando Flask

- Projeto em Python que será usado na Questão 3 com Python e Flask:
<https://github.com/KubeDev/conversao-distancia>



- Dockerfile de exemplo obtido de uma aplicação que usa Python e uma imagem Ubuntu de base:
<https://runnable.com/docker/python/dockerize-your-flask-application>

~~~Dockerfile
FROM ubuntu:16.04

MAINTANER Your Name "youremail@domain.tld"

RUN apt-get update -y && \
    apt-get install -y python-pip python-dev

# We copy just the requirements.txt first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install -r requirements.txt

COPY . /app

ENTRYPOINT [ "python" ]

CMD [ "app.py" ]
~~~




- Dockerfile de exemplo obtido de uma aplicação que usa Python e uma imagem Python-alpine de base:
<https://ebasso.net/wiki/index.php?title=Docker:_Criando_a_Docker_Image_com_o_Python_e_Flask>

~~~Dockerfile
FROM python:3.6.1-alpine
RUN pip install flask
COPY app.py /app.py
CMD ["python","app.py"]
~~~





- Dockerfile personalizado, criado para o desafio:

~~~Dockerfile
FROM python:3.6.1-alpine
RUN pip install flask
COPY app.py /app.py
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python","app.py"]
~~~





- Buildando
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask
docker image build -t fernandomj90/desafio-docker-questao3-python-flask:v1 .


- Apresentou erro durante o build:

~~~bash
  ModuleNotFoundError: No module named 'markupsafe'

    ----------------------------------------
Command "python setup.py egg_info" failed with error code 1 in /tmp/pip-build-ae80uzoa/MarkupSafe/
You are using pip version 9.0.1, however version 22.0.4 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
The command '/bin/sh -c pip install flask' returned a non-zero code: 1
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$
~~~




- Adicionado ao Dockerfile:
RUN pip install markupsafe


- Segue com erro no build:

~~~bash
 ModuleNotFoundError: No module named 'markupsafe'

    ----------------------------------------
Command "python setup.py egg_info" failed with error code 1 in /tmp/pip-build-v9sg6ax3/MarkupSafe/
You are using pip version 9.0.1, however version 22.0.4 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
The command '/bin/sh -c pip install flask' returned a non-zero code: 1
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$
~~~



- Ajustada a linha onde é feita a instalação do [markupsafe], trazendo a instalação dele para o inicio do Dockerfile, porém seguiu com erro no build:

~~~Dockerfile
FROM python:3.6.1-alpine
RUN pip install flask
COPY app.py /app.py
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r /app/requirements.txt
RUN pip install markupsafe
COPY . .
CMD ["python","app.py"]
~~~

~~~Dockerfile
FROM python:3.6.1-alpine
RUN pip install markupsafe
RUN pip install flask
COPY app.py /app.py
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r /app/requirements.txt
COPY . .
CMD ["python","app.py"]
~~~


- Erros:
~~~bash
 ModuleNotFoundError: No module named 'markupsafe'

    ----------------------------------------
Command "python setup.py egg_info" failed with error code 1 in /tmp/pip-build-3uan2n0l/markupsafe/
You are using pip version 9.0.1, however version 22.0.4 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
The command '/bin/sh -c pip install markupsafe' returned a non-zero code: 1
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ ^C
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ ^C
~~~




- Nova versão do Dockerfile para o Python, ajustada e funcionando o build:

~~~Dockerfile
FROM python:3.6.1-alpine
RUN pip install --upgrade pip
RUN pip install -U pip setuptools wheel
RUN pip install markupsafe
RUN pip install flask
COPY app.py /app.py
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r /app/requirements.txt
COPY . .
CMD ["python","app.py"]
~~~

- Build efetuado com sucesso:

~~~bash
Successfully built cbff91b65842
Successfully tagged fernandomj90/desafio-docker-questao3-python-flask:v1
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$
~~~


- KB
- Foram utilizados os comandos informados no Git, sobre esta falha:
<https://github.com/pallets/markupsafe/issues/289>
- Comando indicado pelo Git:
    RUN pip install -U pip setuptools wheel
- Comando indicado pelo erro do pip mesmo:
    RUN pip install --upgrade pip



- Imagem que foi criada:

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ docker image ls | head
REPOSITORY                                          TAG                  IMAGE ID       CREATED         SIZE
fernandomj90/desafio-docker-questao3-python-flask   v1                   cbff91b65842   5 minutes ago   118MB
~~~



- Criando o Container e rodando:
docker container run -p 5001:5000 -d fernandomj90/desafio-docker-questao3-python-flask:v1


- Testando novamente, porém a página não ficou acessível:

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ docker container run -p 5001:5000 -d fernandomj90/desafio-docker-questao3-python-flask:v1
0765eb8eaead76cd7838e5e667e545a5c688ac20d2d9345b76b4b1df4835bf7b
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ docker ps
CONTAINER ID   IMAGE                                                  COMMAND           CREATED         STATUS        PORTS                                       NAMES
0765eb8eaead   fernandomj90/desafio-docker-questao3-python-flask:v1   "python app.py"   3 seconds ago   Up 1 second   0.0.0.0:5001->5000/tcp, :::5001->5000/tcp   admiring_jang
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$


fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ docker logs condescending_bouman
 * Serving Flask app 'app' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ curl http://127.0.0.1:5000/
curl: (7) Failed to connect to 127.0.0.1 port 5000: Connection refused
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ curl http://127.0.0.1:5001
curl: (56) Recv failure: Connection reset by peer
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$
~~~


- Ajustado o Dockerfile.
- Colocado o parametro host, com o ip 0.0.0.0

- DE:
if __name__ == '__main__':
    app.run()

- PARA:
if __name__ == "__main__":
    app.run(host="0.0.0.0")




- Buildando novamente:
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask
docker image build -t fernandomj90/desafio-docker-questao3-python-flask:v1 .


- Imagem criada:

docker image ls | head

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ docker image ls | head
REPOSITORY                                          TAG                  IMAGE ID       CREATED          SIZE
fernandomj90/desafio-docker-questao3-python-flask   v1                   5de3f6d0d9bd   7 seconds ago    118MB
<none>                                              <none>               cbff91b65842   15 minutes ago   118MB
~~~



- Rodando o Container novamente:

docker container run -p 8080:80 -d fernandomj90/desafio-docker-questao3-python-flask:v1

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ docker ps
CONTAINER ID   IMAGE                                                  COMMAND           CREATED         STATUS         PORTS                                   NAMES
64a8844a54a1   fernandomj90/desafio-docker-questao3-python-flask:v1   "python app.py"   4 seconds ago   Up 3 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   zen_brahmagupta
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ docker^C
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ curl localhost:8080
curl: (56) Recv failure: Connection reset by peer
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ curl localhost:80
curl: (7) Failed to connect to localhost port 80: Connection refused
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$
~~~


- Página não ficou acessível pelas portas 8080 ou pela porta 80.

- Apesar disto, a página estava acessível pelo ip especifico do container:

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ curl http://172.17.0.2:5000 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2701  100  2701    0     0  1318k      0 --:--:-- --:--:-- --:--:-- 1318k
<!doctype html>
<html lang="en" class="h-100">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
    <meta name="generator" content="Hugo 0.87.0">
    <title>Conversão de Distância</title>
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$
~~~

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ docker ps
CONTAINER ID   IMAGE                                                  COMMAND           CREATED              STATUS              PORTS                                   NAMES
64a8844a54a1   fernandomj90/desafio-docker-questao3-python-flask:v1   "python app.py"   About a minute ago   Up About a minute   0.0.0.0:8080->80/tcp, :::8080->80/tcp   zen_brahmagupta
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ docker logs zen_brahmagupta
 * Serving Flask app 'app' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on all addresses.
   WARNING: This is a development server. Do not use it in a production deployment.
 * Running on http://172.17.0.2:5000/ (Press CTRL+C to quit)
172.17.0.1 - - [08/May/2022 14:55:40] "GET / HTTP/1.1" 200 -
172.17.0.1 - - [08/May/2022 14:55:45] "GET / HTTP/1.1" 200 -
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ curl localhost:8080
curl: (56) Recv failure: Connection reset by peer
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ curl localhost:80
curl: (7) Failed to connect to localhost port 80: Connection refused
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$
~~~





# ###########################################################################################################################################################
# SOLUÇÃO

<https://forums.docker.com/t/docker-curl-56-recv-failure/54172>

- Como o Python Flask tem por default a porta 5000, foi necessário buildar a imagem com aquele parametro host, normalmente, mas ao lançar o Container é necessário mapear a porta externa desejada(8080, 80, etc), para a porta 5000 do Container, pois a porta default do Python Flask não foi alterada.

- Comandos:
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask
docker container run -p 8080:5000 -d fernandomj90/desafio-docker-questao3-python-flask:v1

~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ curl localhost:8080 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2701  100  2701    0     0   659k      0 --:--:-- --:--:-- --:--:--  659k
<!doctype html>
<html lang="en" class="h-100">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
    <meta name="generator" content="Hugo 0.87.0">
    <title>Conversão de Distância</title>
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$
~~~







# PENDENTE
- Efetuar o Multistage na Dockerfile do Python e Flask.
<https://www.rockyourcode.com/create-a-multi-stage-docker-build-for-python-flask-and-postgres/>
- Avaliar boas práticas.
- Testar e validar.
- Alimentar o README.





# Dia 19/05/2022

- Buildando novamente, com MultiStage:
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask
docker image build -f Dockerfile-multistage -t fernandomj90/desafio-docker-questao3-python-flask-com-multistage:v1 .


- Resultou numa imagem grande ainda:

fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ docker image ls | head
REPOSITORY                                                         TAG                  IMAGE ID       CREATED              SIZE
fernandomj90/desafio-docker-questao3-python-flask-com-multistage   v1                   b5e7572b441a   About a minute ago   118MB
fernandomj90/desafio-docker-questao3-python-flask                  v1                   5de3f6d0d9bd   11 days ago          118MB



- Buildando novamente, com MultiStage e VENV:
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask
docker image build -f Dockerfile-teste2 -t fernandomj90/desafio-docker-questao3-python-flask-com-multistage-venv:v1 .

- Foi usada técnica dos sites:
<https://www.rockyourcode.com/create-a-multi-stage-docker-build-for-python-flask-and-postgres/>
<https://pythonspeed.com/articles/smaller-python-docker-images/>
<https://pythonspeed.com/articles/multi-stage-docker-python/>

- Primeira tentativa com VENV, ficou meio pesado:

fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ docker image ls | head
REPOSITORY                                                              TAG                  IMAGE ID       CREATED          SIZE
fernandomj90/desafio-docker-questao3-python-flask-com-multistage-venv   v1                   3eebf09c18b9   9 minutes ago    214MB
<none>                                                                  <none>               132450dc091c   9 minutes ago    317MB
fernandomj90/desafio-docker-questao3-python-flask-com-multistage        v1                   b5e7572b441a   58 minutes ago   118MB
fernandomj90/desafio-docker-questao3-python-flask                       v1                   5de3f6d0d9bd   11 days ago      118MB





- Buildando novamente, com MultiStage e VENV, método 2:
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask
docker image build -f Dockerfile-teste4 -t fernandomj90/desafio-docker-questao3-python-flask-com-multistage-venv-metodo2:v1 .

- Foi usada técnica do site:
<https://gabnotes.org/lighten-your-python-image-docker-multi-stage-builds/>

- Este método 2(que usa a imagem [python:3.8.6-slim-buster]) ficou mediano, ficou leve, mas não ficou tão leve quanto o Dockerfile original, que usa a imagem de base [python:3.6.1-alpine]:

fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask$ docker image ls | head
REPOSITORY                                                                      TAG                  IMAGE ID       CREATED             SIZE
fernandomj90/desafio-docker-questao3-python-flask-com-multistage-venv-metodo2   v1                   3602ad3260de   7 seconds ago       125MB
<none>                                                                          <none>               e81d3c804586   21 seconds ago      929MB



# PENDENTE
- Avaliar se vai ser usado Multistage ou não, visto que não houve ganho neste caso.
- Avaliar boas práticas.
- Testar e validar.
- Alimentar o README.
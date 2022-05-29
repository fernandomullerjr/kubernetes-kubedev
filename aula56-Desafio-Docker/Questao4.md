

# Questão 04
Agora que você já afiou o seu conhecimento sobre criação de imagens Docker, tá na
hora de fazer o deploy de uma aplicação 100% em containers Docker. A aplicação está
no GitHub do KubeDev e um detalhe MUITO importante, a aplicação precisa ser toda
criada com apenas uma linha de comando.

<https://github.com/KubeDev/rotten-potatoes>





# Dia 28/05/2022


- buildando
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask
docker image build -t fernandomj90/desafio-docker-questao3-python-flask:v2 .


- Rodando o Container novamente:
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao3/python/conversao-distancia-python-flask
docker container run -p 8080:5000 -d fernandomj90/desafio-docker-questao3-python-flask:v2



- Subir um banco MongoDB.
- Vai ser necessário usar docker-compose, para deixar tudo em 1 comando/click.




- Seguir os steps do site:
<https://www.digitalocean.com/community/tutorials/how-to-set-up-flask-with-mongodb-and-docker-pt>
Continuar em:
Passo 2 — Escrevendo os Dokerfiles para o Flask e para o Servidor Web



- Avaliar se os diretórios acima do diretório do Dockerfile e do Setup estão ok
    COPY ../../src/app.py /app.py
    COPY ../../src/requirements.txt /app/requirements.txt
    WORKDIR /app
    RUN pip install --no-cache-dir -r /app/requirements.txt
    COPY ../../ .





# Dia 29/05/2022

- Criados os arquivos Dockerfile para o Python/Flask e para o NGINX.
- O MongoDB não vai ter Dockerfile, vamos usar a imagem oficial.
- Ajustado o arquivo docker-compose.yml


- Arquivo Dockerfile para a aplicação, usando Python e Flask:
~~~~Dockerfile
FROM python:3.6.1-alpine

LABEL MAINTAINER="Fernando Muller <fernandomj90@gmail.com>"

ENV GROUP_ID=1000 \
    USER_ID=1000

RUN pip install --upgrade pip
RUN pip install -U pip setuptools wheel
RUN pip install markupsafe
RUN pip install flask
RUN pip install gunicorn
COPY ../../src/app.py /app.py
COPY ../../src/requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r /app/requirements.txt
COPY ../../ .
#CMD ["python","app.py"]

RUN addgroup -g $GROUP_ID www
RUN adduser -D -u $USER_ID -G www www -s /bin/sh

USER www

EXPOSE 5000

CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "wsgi"]
~~~~


- Arquivo Dockerfile para o NGINX:
~~~~Dockerfile
FROM alpine:3.15.4

LABEL MAINTAINER="Fernando Muller <fernandomj90@gmail.com>"

RUN apk --update add nginx && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    mkdir /etc/nginx/sites-enabled/ && \
    mkdir -p /run/nginx && \
    rm -rf /etc/nginx/conf.d/default.conf && \
    rm -rf /var/cache/apk/*

COPY conf.d/app.conf /etc/nginx/conf.d/app.conf

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
~~~~



- Arquivo de Conf para o NGINX:
~~~~bash
upstream app_server {
    server flask:5000;
}

server {
    listen 80;
    server_name _;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    client_max_body_size 64M;

    location / {
        try_files $uri @proxy_to_app;
    }

    location @proxy_to_app {
        gzip_static on;

        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;
        proxy_buffering off;
        proxy_redirect off;
        proxy_pass http://app_server;
    }
}
~~~~


- Fonte:
<http://nginx.org/en/docs/http/server_names.html>

# ####################################################################################################################################################################
# ENGLISH
 If someone makes a request using an IP address instead of a server name, the “Host” request header field will contain the IP address and the request can be handled using the IP address as the server name:

    server {
        listen       80;
        server_name  example.org
                     www.example.org
                     ""
                     192.168.1.1
                     ;
        ...
    }

In catch-all server examples the strange name “_” can be seen:

    server {
        listen       80  default_server;
        server_name  _;
        return       444;
    }

There is nothing special about this name, it is just one of a myriad of invalid domain names which never intersect with any real name. Other invalid names like “--” and “!@#” may equally be used. 





# ####################################################################################################################################################################
#  TRADUÇÃO
meu cachorro pediu o link da música.



  Se alguém fizer uma solicitação usando um endereço IP em vez de um nome de servidor, o campo de cabeçalho da solicitação “Host” conterá o endereço IP e a solicitação poderá ser tratada usando o endereço IP como nome do servidor:

     servidor {
         ouça 80;
         nome_do_servidor exemplo.org
                      www.exemplo.org
                      ""
                      192.168.1.1
                      ;
         ...
     }

Em exemplos de servidor catch-all, o nome estranho “_” pode ser visto:

     servidor {
         escute 80 default_server;
         nome do servidor  _;
         retornar 444;
     }

Não há nada de especial nesse nome, é apenas um dentre uma infinidade de nomes de domínio inválidos que nunca se cruzam com nenhum nome real. Outros nomes inválidos como “--” e “!@#” também podem ser usados.




# ####################################################################################################################################################################
# EXEMPLO DE CONF
~~~~bash
upstream app_server {
    server flask:5000;
}

server {
    listen 80;
    server_name _;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    client_max_body_size 64M;

    location / {
        try_files $uri @proxy_to_app;
    }

    location @proxy_to_app {
        gzip_static on;

        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;
        proxy_buffering off;
        proxy_redirect off;
        proxy_pass http://app_server;
    }
}
~~~~




- Testar a subida do ambiente usando o docker-compose:
docker-compose up -d

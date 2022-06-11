

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
/home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes/setup/nginx/conf.d/app.conf
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



-ERRO
~~~~bash
Successfully installed gunicorn-20.1.0
Removing intermediate container 0bdac0c82f20
 ---> 5ae0c23902ee
Step 9/18 : COPY ../../src/app.py /app.py
COPY failed: forbidden path outside the build context: ../../src/app.py ()
ERROR: Service 'flask' failed to build : Build failed
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
~~~~









- NOVO ERRO:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker-compose up -d
Building flask
Sending build context to Docker daemon  28.47MB
Step 1/18 : FROM python:3.6.1-alpine
 ---> ddd6300d05a3
Step 2/18 : LABEL MAINTAINER="Fernando Muller <fernandomj90@gmail.com>"
 ---> Using cache
 ---> 106e3fad7576
Step 3/18 : ENV GROUP_ID=1000     USER_ID=1000
 ---> Using cache
 ---> 26387b03069f
Step 4/18 : RUN pip install --upgrade pip
 ---> Using cache
 ---> 765e26402d09
Step 5/18 : RUN pip install -U pip setuptools wheel
 ---> Using cache
 ---> a8a386d5d7c0
Step 6/18 : RUN pip install markupsafe
 ---> Using cache
 ---> be6a7b685c80
  Downloading WTForms-3.0.0-py3-none-any.whl (136 kB)
Requirement already satisfied: setuptools>=3.0 in /usr/local/lib/python3.6/site-packages (from gunicorn==20.0.4->-r /app/requirements.txt (line 7)) (59.6.0)
Building wheels for collected packages: MarkupSafe, Pillow, prometheus-flask-exporter, pymongo, PyYAML
  Building wheel for MarkupSafe (setup.py): started
  Building wheel for MarkupSafe (setup.py): finished with status 'done'
  Created wheel for MarkupSafe: filename=MarkupSafe-1.1.1-py3-none-any.whl size=12638 sha256=0d860b92af48d342008902c2d360e8019e3c7b9e29ef80307926b0a02c62931a
  Stored in directory: /tmp/pip-ephem-wheel-cache-n0vi7c1k/wheels/ca/85/2f/4c3a8ca6fb5eec7b43ec1e5666c7274dcdb86d6c32231aaa9d
  Building wheel for Pillow (setup.py): started
  Building wheel for Pillow (setup.py): finished with status 'error'
  ERROR: Command errored out with exit status 1:
   command: /usr/local/bin/python -u -c 'import io, os, sys, setuptools, tokenize; sys.argv[0] = '"'"'/tmp/pip-install-0120_pen/pillow_908f319068df42b5a51d81959d3b8d99/setup.py'"'"'; __file__='"'"'/tmp/pip-install-0120_pen/pillow_908f319068df42b5a51d81959d3b8d99/setup.py'"'"';f = getattr(tokenize, '"'"'open'"'"', open)(__file__) if os.path.exists(__file__) else io.StringIO('"'"'from setuptools import setup; setup()'"'"');code = f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' bdist_wheel -d /tmp/pip-wheel-d0kk4_sa
       cwd: /tmp/pip-install-0120_pen/pillow_908f319068df42b5a51d81959d3b8d99/
  Complete output (174 lines):
  running bdist_wheel
  running build
  running build_py
  creating build
  creating build/lib.linux-x86_64-3.6
  creating build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/DdsImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/PngImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/GribStubImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImagePalette.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/EpsImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageMode.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/McIdasImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageChops.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/PcfFontFile.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/FontFile.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/TarIO.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/PpmImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/DcxImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/PcdImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/PdfImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/FpxImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/Hdf5StubImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageStat.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/XbmImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/_util.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageColor.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/PixarImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/_tkinter_finder.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageQt.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/Jpeg2KImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/FtexImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/BufrStubImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/PyAccess.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/BdfFontFile.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/SgiImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/_binary.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ContainerIO.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/GimpGradientFile.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageWin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageEnhance.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/FitsStubImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/BmpImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/PSDraw.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/MspImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/GbrImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/PsdImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/GimpPaletteFile.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageDraw2.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/WalImageFile.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/PalmImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/WmfImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageDraw.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/WebPImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/GifImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/XVThumbImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageMorph.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/PaletteFile.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/__main__.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/Image.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/MpoImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/PdfParser.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/IcoImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/TiffImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/PcxImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/XpmImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/FliImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/IcnsImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImagePath.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/IptcImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageSequence.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/__init__.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/MicImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/CurImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageMath.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/TgaImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageFile.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/MpegImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImtImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/_version.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/JpegPresets.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/GdImageFile.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageTk.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageTransform.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/BlpImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/SunImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/JpegImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageShow.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageGrab.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageFont.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageOps.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageFilter.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ExifTags.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/TiffTags.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/SpiderImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/features.py -> build/lib.linux-x86_64-3.6/PIL
  copying src/PIL/ImageCms.py -> build/lib.linux-x86_64-3.6/PIL
  running egg_info
  writing src/Pillow.egg-info/PKG-INFO
  writing dependency_links to src/Pillow.egg-info/dependency_links.txt
  writing top-level names to src/Pillow.egg-info/top_level.txt
  reading manifest file 'src/Pillow.egg-info/SOURCES.txt'
  reading manifest template 'MANIFEST.in'
  warning: no files found matching '*.c'
  warning: no files found matching '*.h'
  warning: no files found matching '*.sh'
  warning: no previously-included files found matching '.appveyor.yml'
  warning: no previously-included files found matching '.clang-format'
  warning: no previously-included files found matching '.coveragerc'
  warning: no previously-included files found matching '.editorconfig'
  warning: no previously-included files found matching '.readthedocs.yml'
  warning: no previously-included files found matching 'codecov.yml'
  warning: no previously-included files matching '.git*' found anywhere in distribution
  warning: no previously-included files matching '*.pyc' found anywhere in distribution
  warning: no previously-included files matching '*.so' found anywhere in distribution
  no previously-included directories found matching '.ci'
  adding license file 'LICENSE'
  writing manifest file 'src/Pillow.egg-info/SOURCES.txt'
  running build_ext


  The headers or library files could not be found for zlib,
  a required dependency when compiling Pillow from source.

  Please see the install instructions at:
     https://pillow.readthedocs.io/en/latest/installation.html

  Traceback (most recent call last):
    File "/tmp/pip-install-0120_pen/pillow_908f319068df42b5a51d81959d3b8d99/setup.py", line 1020, in <module>
      zip_safe=not (debug_build() or PLATFORM_MINGW),
    File "/usr/local/lib/python3.6/site-packages/setuptools/__init__.py", line 153, in setup
      return distutils.core.setup(**attrs)
    File "/usr/local/lib/python3.6/distutils/core.py", line 148, in setup
      dist.run_commands()
    File "/usr/local/lib/python3.6/distutils/dist.py", line 955, in run_commands
      self.run_command(cmd)
    File "/usr/local/lib/python3.6/distutils/dist.py", line 974, in run_command
      cmd_obj.run()
    File "/usr/local/lib/python3.6/site-packages/wheel/bdist_wheel.py", line 299, in run
      self.run_command('build')
    File "/usr/local/lib/python3.6/distutils/cmd.py", line 313, in run_command
      self.distribution.run_command(command)
    File "/usr/local/lib/python3.6/distutils/dist.py", line 974, in run_command
      cmd_obj.run()
    File "/usr/local/lib/python3.6/distutils/command/build.py", line 135, in run
      self.run_command(cmd_name)
    File "/usr/local/lib/python3.6/distutils/cmd.py", line 313, in run_command
      self.distribution.run_command(command)
    File "/usr/local/lib/python3.6/distutils/dist.py", line 974, in run_command
      cmd_obj.run()
    File "/usr/local/lib/python3.6/site-packages/setuptools/command/build_ext.py", line 79, in run
      _build_ext.run(self)
    File "/usr/local/lib/python3.6/distutils/command/build_ext.py", line 339, in run
      self.build_extensions()
    File "/tmp/pip-install-0120_pen/pillow_908f319068df42b5a51d81959d3b8d99/setup.py", line 788, in build_extensions
      raise RequiredDependencyException(f)
  __main__.RequiredDependencyException: zlib

  During handling of the above exception, another exception occurred:

  Traceback (most recent call last):
    File "<string>", line 1, in <module>
    File "/tmp/pip-install-0120_pen/pillow_908f319068df42b5a51d81959d3b8d99/setup.py", line 1033, in <module>
      raise RequiredDependencyException(msg)
  __main__.RequiredDependencyException:

  The headers or library files could not be found for zlib,
  a required dependency when compiling Pillow from source.

  Please see the install instructions at:
     https://pillow.readthedocs.io/en/latest/installation.html


  ----------------------------------------
  ERROR: Failed building wheel for Pillow
  Running setup.py clean for Pillow
  Building wheel for prometheus-flask-exporter (setup.py): started
  Building wheel for prometheus-flask-exporter (setup.py): finished with status 'done'
  Created wheel for prometheus-flask-exporter: filename=prometheus_flask_exporter-0.18.2-py3-none-any.whl size=17416 sha256=277fe09433e472de9809fed46a045c8347dc9e8d01b25777ddc9f393a883569c
  Stored in directory: /tmp/pip-ephem-wheel-cache-n0vi7c1k/wheels/15/77/e8/3ca90b66243b0b58d5a5323a3da02cc8c5daf1de7a65141701
  Building wheel for pymongo (setup.py): started
  Building wheel for pymongo (setup.py): finished with status 'done'
  Created wheel for pymongo: filename=pymongo-3.11.4-cp36-cp36m-linux_x86_64.whl size=345484 sha256=0b2134e1d4ed1143234212518d6efa283dff0dd7218cf01f747472d49d2ba787
  Stored in directory: /tmp/pip-ephem-wheel-cache-n0vi7c1k/wheels/c8/c9/80/8a2bef5ab2bf6bc55c4cd6557e0601b43bbbf902d225354baf
  Building wheel for PyYAML (setup.py): started
  Building wheel for PyYAML (setup.py): finished with status 'done'
  Created wheel for PyYAML: filename=PyYAML-5.3.1-cp36-cp36m-linux_x86_64.whl size=44635 sha256=82bcdf8995b0d132f1c5b0b2168972eb166439533541414ab605e042803639a0
  Stored in directory: /tmp/pip-ephem-wheel-cache-n0vi7c1k/wheels/e5/9d/ad/2ee53cf262cba1ffd8afe1487eef788ea3f260b7e6232a80fc
Successfully built MarkupSafe prometheus-flask-exporter pymongo PyYAML
Failed to build Pillow
Installing collected packages: MarkupSafe, Werkzeug, Jinja2, itsdangerous, idna, dnspython, click, WTForms, pymongo, Flask, email-validator, prometheus-client, mongoengine, Flask-WTF, PyYAML, prometheus-flask-exporter, Pillow, gunicorn, flask-prometheus-metrics, flask-mongoengine
  Attempting uninstall: MarkupSafe
    Found existing installation: MarkupSafe 2.0.1
    Uninstalling MarkupSafe-2.0.1:
      Successfully uninstalled MarkupSafe-2.0.1
  Attempting uninstall: Werkzeug
    Found existing installation: Werkzeug 2.0.3
    Uninstalling Werkzeug-2.0.3:
      Successfully uninstalled Werkzeug-2.0.3
  Attempting uninstall: Jinja2
    Found existing installation: Jinja2 3.0.3
    Uninstalling Jinja2-3.0.3:
      Successfully uninstalled Jinja2-3.0.3
  Attempting uninstall: itsdangerous
    Found existing installation: itsdangerous 2.0.1
    Uninstalling itsdangerous-2.0.1:
      Successfully uninstalled itsdangerous-2.0.1
  Attempting uninstall: click
    Found existing installation: click 8.0.4
    Uninstalling click-8.0.4:
      Successfully uninstalled click-8.0.4
  Attempting uninstall: Flask
    Found existing installation: Flask 2.0.3
    Uninstalling Flask-2.0.3:
      Successfully uninstalled Flask-2.0.3
    Running setup.py install for Pillow: started
    Running setup.py install for Pillow: finished with status 'error'
    ERROR: Command errored out with exit status 1:
     command: /usr/local/bin/python -u -c 'import io, os, sys, setuptools, tokenize; sys.argv[0] = '"'"'/tmp/pip-install-0120_pen/pillow_908f319068df42b5a51d81959d3b8d99/setup.py'"'"'; __file__='"'"'/tmp/pip-install-0120_pen/pillow_908f319068df42b5a51d81959d3b8d99/setup.py'"'"';f = getattr(tokenize, '"'"'open'"'"', open)(__file__) if os.path.exists(__file__) else io.StringIO('"'"'from setuptools import setup; setup()'"'"');code = f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' install --record /tmp/pip-record-xuo058_q/install-record.txt --single-version-externally-managed --compile --install-headers /usr/local/include/python3.6m/Pillow
         cwd: /tmp/pip-install-0120_pen/pillow_908f319068df42b5a51d81959d3b8d99/
    Complete output (178 lines):
    running install
    /usr/local/lib/python3.6/site-packages/setuptools/command/install.py:37: SetuptoolsDeprecationWarning: setup.py install is deprecated. Use build and pip and other standards-based tools.
      setuptools.SetuptoolsDeprecationWarning,
    running build
    running build_py
    creating build
    creating build/lib.linux-x86_64-3.6
    creating build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/DdsImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/PngImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/GribStubImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImagePalette.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/EpsImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageMode.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/McIdasImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageChops.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/PcfFontFile.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/FontFile.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/TarIO.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/PpmImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/DcxImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/PcdImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/PdfImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/FpxImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/Hdf5StubImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageStat.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/XbmImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/_util.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageColor.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/PixarImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/_tkinter_finder.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageQt.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/Jpeg2KImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/FtexImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/BufrStubImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/PyAccess.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/BdfFontFile.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/SgiImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/_binary.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ContainerIO.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/GimpGradientFile.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageWin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageEnhance.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/FitsStubImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/BmpImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/PSDraw.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/MspImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/GbrImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/PsdImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/GimpPaletteFile.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageDraw2.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/WalImageFile.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/PalmImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/WmfImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageDraw.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/WebPImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/GifImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/XVThumbImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageMorph.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/PaletteFile.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/__main__.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/Image.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/MpoImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/PdfParser.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/IcoImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/TiffImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/PcxImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/XpmImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/FliImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/IcnsImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImagePath.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/IptcImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageSequence.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/__init__.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/MicImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/CurImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageMath.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/TgaImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageFile.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/MpegImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImtImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/_version.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/JpegPresets.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/GdImageFile.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageTk.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageTransform.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/BlpImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/SunImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/JpegImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageShow.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageGrab.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageFont.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageOps.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageFilter.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ExifTags.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/TiffTags.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/SpiderImagePlugin.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/features.py -> build/lib.linux-x86_64-3.6/PIL
    copying src/PIL/ImageCms.py -> build/lib.linux-x86_64-3.6/PIL
    running egg_info
    writing src/Pillow.egg-info/PKG-INFO
    writing dependency_links to src/Pillow.egg-info/dependency_links.txt
    writing top-level names to src/Pillow.egg-info/top_level.txt
    reading manifest file 'src/Pillow.egg-info/SOURCES.txt'
    reading manifest template 'MANIFEST.in'
    warning: no files found matching '*.c'
    warning: no files found matching '*.h'
    warning: no files found matching '*.sh'
    warning: no previously-included files found matching '.appveyor.yml'
    warning: no previously-included files found matching '.clang-format'
    warning: no previously-included files found matching '.coveragerc'
    warning: no previously-included files found matching '.editorconfig'
    warning: no previously-included files found matching '.readthedocs.yml'
    warning: no previously-included files found matching 'codecov.yml'
    warning: no previously-included files matching '.git*' found anywhere in distribution
    warning: no previously-included files matching '*.pyc' found anywhere in distribution
    warning: no previously-included files matching '*.so' found anywhere in distribution
    no previously-included directories found matching '.ci'
    adding license file 'LICENSE'
    writing manifest file 'src/Pillow.egg-info/SOURCES.txt'
    running build_ext


    The headers or library files could not be found for zlib,
    a required dependency when compiling Pillow from source.

    Please see the install instructions at:
       https://pillow.readthedocs.io/en/latest/installation.html

    Traceback (most recent call last):
      File "/tmp/pip-install-0120_pen/pillow_908f319068df42b5a51d81959d3b8d99/setup.py", line 1020, in <module>
        zip_safe=not (debug_build() or PLATFORM_MINGW),
      File "/usr/local/lib/python3.6/site-packages/setuptools/__init__.py", line 153, in setup
        return distutils.core.setup(**attrs)
      File "/usr/local/lib/python3.6/distutils/core.py", line 148, in setup
        dist.run_commands()
      File "/usr/local/lib/python3.6/distutils/dist.py", line 955, in run_commands
        self.run_command(cmd)
      File "/usr/local/lib/python3.6/distutils/dist.py", line 974, in run_command
        cmd_obj.run()
      File "/usr/local/lib/python3.6/site-packages/setuptools/command/install.py", line 68, in run
        return orig.install.run(self)
      File "/usr/local/lib/python3.6/distutils/command/install.py", line 545, in run
        self.run_command('build')
      File "/usr/local/lib/python3.6/distutils/cmd.py", line 313, in run_command
        self.distribution.run_command(command)
      File "/usr/local/lib/python3.6/distutils/dist.py", line 974, in run_command
        cmd_obj.run()
      File "/usr/local/lib/python3.6/distutils/command/build.py", line 135, in run
        self.run_command(cmd_name)
      File "/usr/local/lib/python3.6/distutils/cmd.py", line 313, in run_command
        self.distribution.run_command(command)
      File "/usr/local/lib/python3.6/distutils/dist.py", line 974, in run_command
        cmd_obj.run()
      File "/usr/local/lib/python3.6/site-packages/setuptools/command/build_ext.py", line 79, in run
        _build_ext.run(self)
      File "/usr/local/lib/python3.6/distutils/command/build_ext.py", line 339, in run
        self.build_extensions()
      File "/tmp/pip-install-0120_pen/pillow_908f319068df42b5a51d81959d3b8d99/setup.py", line 788, in build_extensions
        raise RequiredDependencyException(f)
    __main__.RequiredDependencyException: zlib

    During handling of the above exception, another exception occurred:

    Traceback (most recent call last):
      File "<string>", line 1, in <module>
      File "/tmp/pip-install-0120_pen/pillow_908f319068df42b5a51d81959d3b8d99/setup.py", line 1033, in <module>
        raise RequiredDependencyException(msg)
    __main__.RequiredDependencyException:

    The headers or library files could not be found for zlib,
    a required dependency when compiling Pillow from source.

    Please see the install instructions at:
       https://pillow.readthedocs.io/en/latest/installation.html


    ----------------------------------------
ERROR: Command errored out with exit status 1: /usr/local/bin/python -u -c 'import io, os, sys, setuptools, tokenize; sys.argv[0] = '"'"'/tmp/pip-install-0120_pen/pillow_908f319068df42b5a51d81959d3b8d99/setup.py'"'"'; __file__='"'"'/tmp/pip-install-0120_pen/pillow_908f319068df42b5a51d81959d3b8d99/setup.py'"'"';f = getattr(tokenize, '"'"'open'"'"', open)(__file__) if os.path.exists(__file__) else io.StringIO('"'"'from setuptools import setup; setup()'"'"');code = f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' install --record /tmp/pip-record-xuo058_q/install-record.txt --single-version-externally-managed --compile --install-headers /usr/local/include/python3.6m/Pillow Check the logs for full command output.
The command '/bin/sh -c pip install --no-cache-dir -r /app/requirements.txt' returned a non-zero code: 1
ERROR: Service 'flask' failed to build : Build failed
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$


~~~~






- Não cheguei a testar esta solução
RUN pip install --upgrade pip
RUN pip install --upgrade Pillow


- Usei esta solução:
<https://stackoverflow.com/questions/57787424/django-docker-python-unable-to-install-pillow-on-python-alpine>
~~~~Dockerfile
RUN apk add --no-cache jpeg-dev zlib-dev
RUN apk add --no-cache --virtual .build-deps build-base linux-headers \
    && pip install Pillow
~~~~



- Efetuando novo build
docker-compose up -d
docker-compose up -d
docker-compose up -d
~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker-compose up -d
Building flask
Sending build context to Docker daemon  28.47MB
Step 1/20 : FROM python:3.6.1-alpine
 ---> ddd6300d05a3
Step 2/20 : LABEL MAINTAINER="Fernando Muller <fernandomj90@gmail.com>"
 ---> Using cache
 ---> 106e3fad7576
Step 3/20 : ENV GROUP_ID=1000     USER_ID=1000
 ---> Using cache
 ---> 26387b03069f
Step 4/20 : RUN pip install --upgrade pip
 ---> Using cache
 ---> 765e26402d09
Step 5/20 : RUN pip install -U pip setuptools wheel
 ---> Using cache
 ---> a8a386d5d7c0
Step 6/20 : RUN pip install markupsafe
 ---> Using cache
 ---> be6a7b685c80
Step 7/20 : RUN pip install flask
 ---> Using cache
 ---> 5436f4d4bada
Step 8/20 : RUN pip install gunicorn
 ---> Using cache
 ---> 5ae0c23902ee
Step 9/20 : RUN apk add --no-cache jpeg-dev zlib-dev
 ---> Running in 2bbf971a1c5f
fetch http://dl-cdn.alpinelinux.org/alpine/v3.4/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.4/community/x86_64/APKINDEX.tar.gz
(1/6) Installing libjpeg-turbo (1.4.2-r0)
(2/6) Installing libjpeg-turbo-dev (1.4.2-r0)
(3/6) Installing jpeg-dev (8-r6)
(4/6) Installing pkgconf (0.9.12-r0)
(5/6) Installing pkgconfig (0.25-r1)
(6/6) Installing zlib-dev (1.2.11-r0)
Executing busybox-1.24.2-r13.trigger
OK: 33 MiB in 40 packages
Removing intermediate container 2bbf971a1c5f
 ---> 4d130bcd7069
Step 10/20 : RUN apk add --no-cache --virtual .build-deps build-base linux-headers     && pip install Pillow
 ---> Running in e21289626c6f
fetch http://dl-cdn.alpinelinux.org/alpine/v3.4/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.4/community/x86_64/APKINDEX.tar.gz
(1/21) Upgrading musl (1.1.14-r15 -> 1.1.14-r16)
(2/21) Installing binutils-libs (2.26-r1)
(3/21) Installing binutils (2.26-r1)
(4/21) Installing gmp (6.1.0-r0)
(5/21) Installing isl (0.14.1-r0)
(6/21) Installing libgomp (5.3.0-r0)
(7/21) Installing libatomic (5.3.0-r0)
(8/21) Installing libgcc (5.3.0-r0)
(9/21) Installing mpfr3 (3.1.2-r0)
(10/21) Installing mpc1 (1.0.3-r0)
(11/21) Installing libstdc++ (5.3.0-r0)
(12/21) Installing gcc (5.3.0-r0)
(13/21) Installing make (4.1-r1)
(14/21) Installing musl-dev (1.1.14-r16)
(15/21) Installing libc-dev (0.7-r0)
(16/21) Installing fortify-headers (0.8-r0)
(17/21) Installing g++ (5.3.0-r0)
(18/21) Installing build-base (0.4-r1)
(19/21) Installing linux-headers (4.4.6-r1)
(20/21) Installing .build-deps (0)
(21/21) Upgrading musl-utils (1.1.14-r15 -> 1.1.14-r16)
Executing busybox-1.24.2-r13.trigger
OK: 190 MiB in 59 packages
Collecting Pillow
  Downloading Pillow-8.4.0.tar.gz (49.4 MB)
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Building wheels for collected packages: Pillow
  Building wheel for Pillow (setup.py): started
  Building wheel for Pillow (setup.py): finished with status 'done'
  Created wheel for Pillow: filename=Pillow-8.4.0-cp36-cp36m-linux_x86_64.whl size=1014884 sha256=dc63df48132010ab929ee3684b2d87b8750c0c59f9d85f8b6dd580dc7a6ad707
  Stored in directory: /root/.cache/pip/wheels/a9/ae/b0/d98758d9401a31bbaa3fe46a37144b3e1a130dcc6ae80c21b6
Successfully built Pillow
Installing collected packages: Pillow
Successfully installed Pillow-8.4.0
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Removing intermediate container e21289626c6f
 ---> 04b6fdf759bc
Step 11/20 : COPY ./src/app.py /app.py
 ---> 1c061a018009
Step 12/20 : COPY ./src/requirements.txt /app/requirements.txt
 ---> f057ceadb31e
Step 13/20 : WORKDIR /app
 ---> Running in 066bd6c163a4
Removing intermediate container 066bd6c163a4
 ---> dcb3711f02c2
Step 14/20 : RUN pip install --no-cache-dir -r /app/requirements.txt
 ---> Running in b10f9e4ba727
Collecting click==7.1.2
  Downloading click-7.1.2-py2.py3-none-any.whl (82 kB)
Collecting dnspython==2.1.0
  Downloading dnspython-2.1.0-py3-none-any.whl (241 kB)
Collecting email-validator==1.1.2
  Downloading email_validator-1.1.2-py2.py3-none-any.whl (17 kB)
Collecting Flask==1.1.2
  Downloading Flask-1.1.2-py2.py3-none-any.whl (94 kB)
Collecting flask-mongoengine==1.0.0
  Downloading flask_mongoengine-1.0.0-py3-none-any.whl (25 kB)
Collecting Flask-WTF==0.14.3
  Downloading Flask_WTF-0.14.3-py2.py3-none-any.whl (13 kB)
Collecting gunicorn==20.0.4
  Downloading gunicorn-20.0.4-py2.py3-none-any.whl (77 kB)
Collecting idna==3.1
  Downloading idna-3.1-py3-none-any.whl (58 kB)
Collecting itsdangerous==1.1.0
  Downloading itsdangerous-1.1.0-py2.py3-none-any.whl (16 kB)
Collecting Jinja2==2.11.2
  Downloading Jinja2-2.11.2-py2.py3-none-any.whl (125 kB)
Collecting MarkupSafe==1.1.1
  Downloading MarkupSafe-1.1.1.tar.gz (19 kB)
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting mongoengine==0.23.1
  Downloading mongoengine-0.23.1-py3-none-any.whl (107 kB)
Collecting Pillow==8.2.0
  Downloading Pillow-8.2.0.tar.gz (47.9 MB)
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting prometheus-client==0.10.1
  Downloading prometheus_client-0.10.1-py2.py3-none-any.whl (55 kB)
Collecting prometheus-flask-exporter==0.18.2
  Downloading prometheus_flask_exporter-0.18.2.tar.gz (22 kB)
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting pymongo==3.11.4
  Downloading pymongo-3.11.4.tar.gz (783 kB)
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting PyYAML==5.3.1
  Downloading PyYAML-5.3.1.tar.gz (269 kB)
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting Werkzeug==1.0.1
  Downloading Werkzeug-1.0.1-py2.py3-none-any.whl (298 kB)
Collecting WTForms==2.3.3
  Downloading WTForms-2.3.3-py2.py3-none-any.whl (169 kB)
Collecting flask-prometheus-metrics==1.0.0
  Downloading flask_prometheus_metrics-1.0.0-py3-none-any.whl (6.2 kB)
Collecting WTForms[email]>=2.3.1
  Downloading WTForms-3.0.0-py3-none-any.whl (136 kB)
Requirement already satisfied: setuptools>=3.0 in /usr/local/lib/python3.6/site-packages (from gunicorn==20.0.4->-r /app/requirements.txt (line 7)) (59.6.0)
Building wheels for collected packages: MarkupSafe, Pillow, prometheus-flask-exporter, pymongo, PyYAML
  Building wheel for MarkupSafe (setup.py): started
  Building wheel for MarkupSafe (setup.py): finished with status 'done'
  Created wheel for MarkupSafe: filename=MarkupSafe-1.1.1-cp36-cp36m-linux_x86_64.whl size=27834 sha256=6b7ef9ac33ac3bc013c5033445144ac373501b78982f4d47b7cf6973a8e482cd
  Stored in directory: /tmp/pip-ephem-wheel-cache-_nlxutyi/wheels/ca/85/2f/4c3a8ca6fb5eec7b43ec1e5666c7274dcdb86d6c32231aaa9d
  Building wheel for Pillow (setup.py): started
  Building wheel for Pillow (setup.py): finished with status 'done'
  Created wheel for Pillow: filename=Pillow-8.2.0-cp36-cp36m-linux_x86_64.whl size=1012736 sha256=7e54585f7c68cc0a2abd44253c76ba4921aefce834aa9c862db7bcdca7212ecd
  Stored in directory: /tmp/pip-ephem-wheel-cache-_nlxutyi/wheels/35/67/ed/4b51d13d10751c51d04374e562e53cb92ca3758c9f95637c4b
  Building wheel for prometheus-flask-exporter (setup.py): started
  Building wheel for prometheus-flask-exporter (setup.py): finished with status 'done'
  Created wheel for prometheus-flask-exporter: filename=prometheus_flask_exporter-0.18.2-py3-none-any.whl size=17416 sha256=6b55a5a64474ea5dacef5340a7515561e03ebe29347c7e490d7885cf5c74e752
  Stored in directory: /tmp/pip-ephem-wheel-cache-_nlxutyi/wheels/15/77/e8/3ca90b66243b0b58d5a5323a3da02cc8c5daf1de7a65141701
  Building wheel for pymongo (setup.py): started
  Building wheel for pymongo (setup.py): finished with status 'done'
  Created wheel for pymongo: filename=pymongo-3.11.4-cp36-cp36m-linux_x86_64.whl size=486478 sha256=31b8c98f135b96f270061620296372957f5ffb7e9029080650b6e0b02f183ff2
  Stored in directory: /tmp/pip-ephem-wheel-cache-_nlxutyi/wheels/c8/c9/80/8a2bef5ab2bf6bc55c4cd6557e0601b43bbbf902d225354baf
  Building wheel for PyYAML (setup.py): started
  Building wheel for PyYAML (setup.py): finished with status 'done'
  Created wheel for PyYAML: filename=PyYAML-5.3.1-cp36-cp36m-linux_x86_64.whl size=44635 sha256=13a964ba743e71e76aa19badc1e065273172872f33135267b0e701211e2df39b
  Stored in directory: /tmp/pip-ephem-wheel-cache-_nlxutyi/wheels/e5/9d/ad/2ee53cf262cba1ffd8afe1487eef788ea3f260b7e6232a80fc
Successfully built MarkupSafe Pillow prometheus-flask-exporter pymongo PyYAML
Installing collected packages: MarkupSafe, Werkzeug, Jinja2, itsdangerous, idna, dnspython, click, WTForms, pymongo, Flask, email-validator, prometheus-client, mongoengine, Flask-WTF, PyYAML, prometheus-flask-exporter, Pillow, gunicorn, flask-prometheus-metrics, flask-mongoengine
  Attempting uninstall: MarkupSafe
    Found existing installation: MarkupSafe 2.0.1
    Uninstalling MarkupSafe-2.0.1:
      Successfully uninstalled MarkupSafe-2.0.1
  Attempting uninstall: Werkzeug
    Found existing installation: Werkzeug 2.0.3
    Uninstalling Werkzeug-2.0.3:
      Successfully uninstalled Werkzeug-2.0.3
  Attempting uninstall: Jinja2
    Found existing installation: Jinja2 3.0.3
    Uninstalling Jinja2-3.0.3:
      Successfully uninstalled Jinja2-3.0.3
  Attempting uninstall: itsdangerous
    Found existing installation: itsdangerous 2.0.1
    Uninstalling itsdangerous-2.0.1:
      Successfully uninstalled itsdangerous-2.0.1
  Attempting uninstall: click
    Found existing installation: click 8.0.4
    Uninstalling click-8.0.4:
      Successfully uninstalled click-8.0.4
  Attempting uninstall: Flask
    Found existing installation: Flask 2.0.3
    Uninstalling Flask-2.0.3:
      Successfully uninstalled Flask-2.0.3
  Attempting uninstall: Pillow
    Found existing installation: Pillow 8.4.0
    Uninstalling Pillow-8.4.0:
      Successfully uninstalled Pillow-8.4.0
  Attempting uninstall: gunicorn
    Found existing installation: gunicorn 20.1.0
    Uninstalling gunicorn-20.1.0:
      Successfully uninstalled gunicorn-20.1.0
Successfully installed Flask-1.1.2 Flask-WTF-0.14.3 Jinja2-2.11.2 MarkupSafe-1.1.1 Pillow-8.2.0 PyYAML-5.3.1 WTForms-2.3.3 Werkzeug-1.0.1 click-7.1.2 dnspython-2.1.0 email-validator-1.1.2 flask-mongoengine-1.0.0 flask-prometheus-metrics-1.0.0 gunicorn-20.0.4 idna-3.1 itsdangerous-1.1.0 mongoengine-0.23.1 prometheus-client-0.10.1 prometheus-flask-exporter-0.18.2 pymongo-3.11.4
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Removing intermediate container b10f9e4ba727
 ---> a13671e64f67
Step 15/20 : COPY ./ .
 ---> acb0c5fb5644
Step 16/20 : RUN addgroup -g $GROUP_ID www
 ---> Running in ed4b0cb69622
Removing intermediate container ed4b0cb69622
 ---> 88222c2cb13b
Step 17/20 : RUN adduser -D -u $USER_ID -G www www -s /bin/sh
 ---> Running in cf0a98f10e56
Removing intermediate container cf0a98f10e56
 ---> edc3769ebe91
Step 18/20 : USER www
 ---> Running in 80d8d2dbd9cb
Removing intermediate container 80d8d2dbd9cb
 ---> e504cb7bc108
Step 19/20 : EXPOSE 5000
 ---> Running in f61fce05114f
Removing intermediate container f61fce05114f
 ---> 3695e304721c
Step 20/20 : CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "wsgi"]
 ---> Running in 36e51864c4c4
Removing intermediate container 36e51864c4c4
 ---> 29de32765a13
Successfully built 29de32765a13
Successfully tagged fernandomj90/flask-python:3.6.1
WARNING: Image for service flask was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Building webserver
Sending build context to Docker daemon  28.47MB
Step 1/6 : FROM alpine:3.15.4
3.15.4: Pulling from library/alpine
df9b9388f04a: Already exists
Digest: sha256:4edbd2beb5f78b1014028f4fbb99f3237d9561100b6881aabbf5acce2c4f9454
Status: Downloaded newer image for alpine:3.15.4
 ---> 0ac33e5f5afa
Step 2/6 : LABEL MAINTAINER="Fernando Muller <fernandomj90@gmail.com>"
 ---> Running in 3c271d763349
Removing intermediate container 3c271d763349
 ---> 6fc79d8371fd
Step 3/6 : RUN apk --update add nginx &&     ln -sf /dev/stdout /var/log/nginx/access.log &&     ln -sf /dev/stderr /var/log/nginx/error.log &&     mkdir /etc/nginx/sites-enabled/ &&     mkdir -p /run/nginx &&     rm -rf /etc/nginx/conf.d/default.conf &&     rm -rf /var/cache/apk/*
 ---> Running in 79b10d5b213d
fetch https://dl-cdn.alpinelinux.org/alpine/v3.15/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.15/community/x86_64/APKINDEX.tar.gz
(1/2) Installing pcre (8.45-r1)
(2/2) Installing nginx (1.20.2-r1)
Executing nginx-1.20.2-r1.pre-install
Executing nginx-1.20.2-r1.post-install
Executing busybox-1.34.1-r5.trigger
OK: 7 MiB in 16 packages
Removing intermediate container 79b10d5b213d
 ---> 02d7a42eb932
Step 4/6 : COPY ./setup/nginx/conf.d/app.conf /etc/nginx/conf.d/app.conf
 ---> 187667514561
Step 5/6 : EXPOSE 80 443
 ---> Running in cffee949b0be
Removing intermediate container cffee949b0be
 ---> e2278c03ef03
Step 6/6 : CMD ["nginx", "-g", "daemon off;"]
 ---> Running in e0f1a6d2f929
Removing intermediate container e0f1a6d2f929
 ---> 123c9e84ef76
Successfully built 123c9e84ef76
Successfully tagged fernandomj90/nginx-alpine-desafio-docker:3.15.4
WARNING: Image for service webserver was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating mongodb ... done
Creating flask   ... done
Creating webserver ... done
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ ^C
~~~~









- Imagens do NGINX e Python OK.
- Imagem do Python ficou pesada.

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker image ls | head
REPOSITORY                                                                      TAG                  IMAGE ID       CREATED          SIZE
fernandomj90/nginx-alpine-desafio-docker                                        3.15.4               123c9e84ef76   23 seconds ago   7.01MB
fernandomj90/flask-python                                                       3.6.1                29de32765a13   30 seconds ago   367MB
<none>                                                                          <none>               0ca6a440f6d8   26 minutes ago   115MB
fernandomj90/desafio-docker-questao3-csharp-asp-net                             v3                   ed71f64133f8   28 hours ago     210MB
<none>                                                                          <none>               8ac693e30e3d   28 hours ago     648MB
<none>                                                                          <none>               d1a96be54200   28 hours ago     217MB
<none>                                                                          <none>               041c765b1b8c   28 hours ago     798MB
mcr.microsoft.com/dotnet/sdk                                                    5.0                  9fec788bd1f9   37 hours ago     632MB
mcr.microsoft.com/dotnet/aspnet                                                 5.0                  29de1b9e96c0   37 hours ago     205MB
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ ^C
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ ^C
~~~~




- Container do NGINX e MongoDB ficaram OK.
- Container do Python/Flask está reiniciando, verificar os logs.

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker ps
CONTAINER ID   IMAGE                                             COMMAND                  CREATED         STATUS                          PORTS                                                                      NAMES
d9702b518cee   fernandomj90/nginx-alpine-desafio-docker:3.15.4   "nginx -g 'daemon of…"   5 minutes ago   Up 5 minutes                    0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp   webserver
d7acf1449621   fernandomj90/flask-python:3.6.1                   "gunicorn -w 4 --bin…"   5 minutes ago   Restarting (1) 22 seconds ago                                                                              flask
d146c456ccef   mongo:4.0.8                                       "docker-entrypoint.s…"   5 minutes ago   Up 5 minutes                    0.0.0.0:27017->27017/tcp, :::27017->27017/tcp                              mongodb
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
~~~~




- Erros no Container do flask:
~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker logs flask
[2022-05-29 21:07:31 +0000] [1] [INFO] Starting gunicorn 20.0.4
[2022-05-29 21:07:31 +0000] [1] [INFO] Listening at: http://0.0.0.0:5000 (1)
[2022-05-29 21:07:31 +0000] [1] [INFO] Using worker: sync
[2022-05-29 21:07:31 +0000] [10] [INFO] Booting worker with pid: 10
[2022-05-29 21:07:31 +0000] [10] [ERROR] Exception in worker process
Traceback (most recent call last):
  File "/usr/local/lib/python3.6/site-packages/gunicorn/arbiter.py", line 583, in spawn_worker
    worker.init_process()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/workers/base.py", line 119, in init_process
    self.load_wsgi()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/workers/base.py", line 144, in load_wsgi
    self.wsgi = self.app.wsgi()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/base.py", line 67, in wsgi
    self.callable = self.load()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/wsgiapp.py", line 49, in load
    return self.load_wsgiapp()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/wsgiapp.py", line 39, in load_wsgiapp
    return util.import_app(self.app_uri)
  File "/usr/local/lib/python3.6/site-packages/gunicorn/util.py", line 358, in import_app
    mod = importlib.import_module(module)
  File "/usr/local/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 978, in _gcd_import
  File "<frozen importlib._bootstrap>", line 961, in _find_and_load
  File "<frozen importlib._bootstrap>", line 948, in _find_and_load_unlocked
ModuleNotFoundError: No module named 'wsgi'
~~~~



- A principio o erro tem relação com o Dockerfile, na parte do CMD
CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "wsgi"]



- Ajustando
DE:
CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "wsgi"]
PARA
CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "app"]


- Seguindo idéias do site:
<https://www.digitalocean.com/community/tutorials/how-to-set-up-flask-with-mongodb-and-docker-pt>


~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker-compose down
Stopping webserver ... done
Stopping flask     ... done
Stopping mongodb   ... done
Removing webserver ... done
Removing flask     ... done
Removing mongodb   ... done
Removing network rotten-potatoes_backend
Removing network rotten-potatoes_frontend
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
~~~~


~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker-compose up -d
Creating network "rotten-potatoes_backend" with driver "bridge"
Creating network "rotten-potatoes_frontend" with driver "bridge"
Creating mongodb ... done
Creating flask   ... done
Creating webserver ... done
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ ^C
~~~~



~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker ps
CONTAINER ID   IMAGE                                             COMMAND                  CREATED          STATUS                         PORTS                                                                      NAMES
95135119c261   fernandomj90/nginx-alpine-desafio-docker:3.15.4   "nginx -g 'daemon of…"   44 seconds ago   Up 42 seconds                  0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp   webserver
6f26bf1f4497   fernandomj90/flask-python:3.6.1                   "gunicorn -w 4 --bin…"   45 seconds ago   Restarting (3) 8 seconds ago                                                                              flask
7341dc09131f   mongo:4.0.8                                       "docker-entrypoint.s…"   45 seconds ago   Up 44 seconds                  0.0.0.0:27017->27017/tcp, :::27017->27017/tcp                              mongodb
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
~~~~




- SEGUE O ERRO
~~~~bash
[2022-05-29 21:23:25 +0000] [10] [INFO] Worker exiting (pid: 10)
[2022-05-29 21:23:25 +0000] [1] [INFO] Shutting down: Master
[2022-05-29 21:23:25 +0000] [1] [INFO] Reason: Worker failed to boot.
[2022-05-29 21:23:39 +0000] [1] [INFO] Starting gunicorn 20.0.4
[2022-05-29 21:23:39 +0000] [1] [INFO] Listening at: http://0.0.0.0:5000 (1)
[2022-05-29 21:23:39 +0000] [1] [INFO] Using worker: sync
[2022-05-29 21:23:39 +0000] [9] [INFO] Booting worker with pid: 9
[2022-05-29 21:23:39 +0000] [9] [ERROR] Exception in worker process
Traceback (most recent call last):
  File "/usr/local/lib/python3.6/site-packages/gunicorn/arbiter.py", line 583, in spawn_worker
    worker.init_process()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/workers/base.py", line 119, in init_process
    self.load_wsgi()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/workers/base.py", line 144, in load_wsgi
    self.wsgi = self.app.wsgi()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/base.py", line 67, in wsgi
    self.callable = self.load()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/wsgiapp.py", line 49, in load
    return self.load_wsgiapp()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/wsgiapp.py", line 39, in load_wsgiapp
    return util.import_app(self.app_uri)
  File "/usr/local/lib/python3.6/site-packages/gunicorn/util.py", line 358, in import_app
    mod = importlib.import_module(module)
  File "/usr/local/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 978, in _gcd_import
  File "<frozen importlib._bootstrap>", line 961, in _find_and_load
  File "<frozen importlib._bootstrap>", line 948, in _find_and_load_unlocked
ModuleNotFoundError: No module named 'wsgi'
[2022-05-29 21:23:39 +0000] [9] [INFO] Worker exiting (pid: 9)
[2022-05-29 21:23:39 +0000] [1] [INFO] Shutting down: Master
[2022-05-29 21:23:39 +0000] [1] [INFO] Reason: Worker failed to boot.
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
~~~~





- acredito que seja cache
~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker image ls | head
REPOSITORY                                                                      TAG                  IMAGE ID       CREATED          SIZE
fernandomj90/nginx-alpine-desafio-docker                                        3.15.4               123c9e84ef76   17 minutes ago   7.01MB
fernandomj90/flask-python                                                       3.6.1                29de32765a13   17 minutes ago   367MB
~~~~




- Usar o --no-cache
docker-compose up -d --no-cache
docker-compose build --no-cache

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ ^C
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker-compose build --no-cache
mongodb uses an image, skipping
Building flask
Sending build context to Docker daemon  28.47MB
Step 1/20 : FROM python:3.6.1-alpine
 ---> ddd6300d05a3
Step 2/20 : LABEL MAINTAINER="Fernando Muller <fernandomj90@gmail.com>"
 ---> Running in 78b5f257908e
Removing intermediate container 78b5f257908e
 ---> 2621934fbe29
Step 3/20 : ENV GROUP_ID=1000     USER_ID=1000
 ---> Running in d507be9ae353
Removing intermediate container d507be9ae353
 ---> 08075ee8b897
Step 4/20 : RUN pip install --upgrade pip
 ---> Running in c81547a19cbc
Collecting pip
  Downloading https://files.pythonhosted.org/packages/a4/6d/6463d49a933f547439d6b5b98b46af8742cc03ae83543e4d7688c2420f8b/pip-21.3.1-py3-none-any.whl (1.7MB)
Installing collected packages: pip
  Found existing installation: pip 9.0.1
    Uninstalling pip-9.0.1:
      Successfully uninstalled pip-9.0.1
Successfully installed pip-21.3.1
Removing intermediate container c81547a19cbc
 ---> c63c4c445d23
Step 5/20 : RUN pip install -U pip setuptools wheel
 ---> Running in 7acfe58cea86
Requirement already satisfied: pip in /usr/local/lib/python3.6/site-packages (21.3.1)
Requirement already satisfied: setuptools in /usr/local/lib/python3.6/site-packages (36.0.1)
Collecting setuptools
  Downloading setuptools-59.6.0-py3-none-any.whl (952 kB)
Requirement already satisfied: wheel in /usr/local/lib/python3.6/site-packages (0.29.0)
Collecting wheel
  Downloading wheel-0.37.1-py2.py3-none-any.whl (35 kB)
Installing collected packages: wheel, setuptools
  Attempting uninstall: wheel
    Found existing installation: wheel 0.29.0
    Uninstalling wheel-0.29.0:
      Successfully uninstalled wheel-0.29.0
  Attempting uninstall: setuptools
    Found existing installation: setuptools 36.0.1
    Uninstalling setuptools-36.0.1:
      Successfully uninstalled setuptools-36.0.1
Successfully installed setuptools-59.6.0 wheel-0.37.1
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Removing intermediate container 7acfe58cea86
 ---> c3f8ae2d4b08
Step 6/20 : RUN pip install markupsafe
 ---> Running in 23e5288f7530
Collecting markupsafe
  Downloading MarkupSafe-2.0.1-cp36-cp36m-musllinux_1_1_x86_64.whl (29 kB)
Installing collected packages: markupsafe
Successfully installed markupsafe-2.0.1
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Removing intermediate container 23e5288f7530
 ---> 2c91497d3c16
Step 7/20 : RUN pip install flask
 ---> Running in 17de8d892975
Collecting flask
  Downloading Flask-2.0.3-py3-none-any.whl (95 kB)
Collecting click>=7.1.2
  Downloading click-8.0.4-py3-none-any.whl (97 kB)
Collecting Jinja2>=3.0
  Downloading Jinja2-3.0.3-py3-none-any.whl (133 kB)
Collecting Werkzeug>=2.0
  Downloading Werkzeug-2.0.3-py3-none-any.whl (289 kB)
Collecting itsdangerous>=2.0
  Downloading itsdangerous-2.0.1-py3-none-any.whl (18 kB)
Collecting importlib-metadata
  Downloading importlib_metadata-4.8.3-py3-none-any.whl (17 kB)
Requirement already satisfied: MarkupSafe>=2.0 in /usr/local/lib/python3.6/site-packages (from Jinja2>=3.0->flask) (2.0.1)
Collecting dataclasses
  Downloading dataclasses-0.8-py3-none-any.whl (19 kB)
Collecting zipp>=0.5
  Downloading zipp-3.6.0-py3-none-any.whl (5.3 kB)
Collecting typing-extensions>=3.6.4
  Downloading typing_extensions-4.1.1-py3-none-any.whl (26 kB)
Installing collected packages: zipp, typing-extensions, importlib-metadata, dataclasses, Werkzeug, Jinja2, itsdangerous, click, flask
Successfully installed Jinja2-3.0.3 Werkzeug-2.0.3 click-8.0.4 dataclasses-0.8 flask-2.0.3 importlib-metadata-4.8.3 itsdangerous-2.0.1 typing-extensions-4.1.1 zipp-3.6.0
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Removing intermediate container 17de8d892975
 ---> 016044bffb98
Step 8/20 : RUN pip install gunicorn
 ---> Running in f7c39042c4e2
Collecting gunicorn
  Downloading gunicorn-20.1.0-py3-none-any.whl (79 kB)
Requirement already satisfied: setuptools>=3.0 in /usr/local/lib/python3.6/site-packages (from gunicorn) (59.6.0)
Installing collected packages: gunicorn
Successfully installed gunicorn-20.1.0
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Removing intermediate container f7c39042c4e2
 ---> 2880225bbbb4
Step 9/20 : RUN apk add --no-cache jpeg-dev zlib-dev
 ---> Running in 9bef49748c22
fetch http://dl-cdn.alpinelinux.org/alpine/v3.4/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.4/community/x86_64/APKINDEX.tar.gz
(1/6) Installing libjpeg-turbo (1.4.2-r0)
(2/6) Installing libjpeg-turbo-dev (1.4.2-r0)
(3/6) Installing jpeg-dev (8-r6)
(4/6) Installing pkgconf (0.9.12-r0)
(5/6) Installing pkgconfig (0.25-r1)
(6/6) Installing zlib-dev (1.2.11-r0)
Executing busybox-1.24.2-r13.trigger
OK: 33 MiB in 40 packages
Removing intermediate container 9bef49748c22
 ---> f82602d93dc3
Step 10/20 : RUN apk add --no-cache --virtual .build-deps build-base linux-headers     && pip install Pillow
 ---> Running in 628927719b52
fetch http://dl-cdn.alpinelinux.org/alpine/v3.4/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.4/community/x86_64/APKINDEX.tar.gz
(1/21) Upgrading musl (1.1.14-r15 -> 1.1.14-r16)
(2/21) Installing binutils-libs (2.26-r1)
(3/21) Installing binutils (2.26-r1)
(4/21) Installing gmp (6.1.0-r0)
(5/21) Installing isl (0.14.1-r0)
(6/21) Installing libgomp (5.3.0-r0)
(7/21) Installing libatomic (5.3.0-r0)
(8/21) Installing libgcc (5.3.0-r0)
(9/21) Installing mpfr3 (3.1.2-r0)
(10/21) Installing mpc1 (1.0.3-r0)
(11/21) Installing libstdc++ (5.3.0-r0)
(12/21) Installing gcc (5.3.0-r0)
(13/21) Installing make (4.1-r1)
(14/21) Installing musl-dev (1.1.14-r16)
(15/21) Installing libc-dev (0.7-r0)
(16/21) Installing fortify-headers (0.8-r0)
(17/21) Installing g++ (5.3.0-r0)
(18/21) Installing build-base (0.4-r1)
(19/21) Installing linux-headers (4.4.6-r1)
(20/21) Installing .build-deps (0)
(21/21) Upgrading musl-utils (1.1.14-r15 -> 1.1.14-r16)
Executing busybox-1.24.2-r13.trigger
OK: 190 MiB in 59 packages
Collecting Pillow
  Downloading Pillow-8.4.0.tar.gz (49.4 MB)
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Building wheels for collected packages: Pillow
  Building wheel for Pillow (setup.py): started
  Building wheel for Pillow (setup.py): finished with status 'done'
  Created wheel for Pillow: filename=Pillow-8.4.0-cp36-cp36m-linux_x86_64.whl size=1014865 sha256=a5b05ad5e5eaf16586f16b260a8b1308a3ea93818510aa3e4020adf69fa5b928
  Stored in directory: /root/.cache/pip/wheels/a9/ae/b0/d98758d9401a31bbaa3fe46a37144b3e1a130dcc6ae80c21b6
Successfully built Pillow
Installing collected packages: Pillow
Successfully installed Pillow-8.4.0
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Removing intermediate container 628927719b52
 ---> 2de2271b1b34
Step 11/20 : COPY ./src/app.py /app.py
 ---> 1f7a6b2bd3ec
Step 12/20 : COPY ./src/requirements.txt /app/requirements.txt
 ---> 12719c5a369a
Step 13/20 : WORKDIR /app
 ---> Running in 69a296d6f46b
Removing intermediate container 69a296d6f46b
 ---> 4c3e24133884
Step 14/20 : RUN pip install --no-cache-dir -r /app/requirements.txt
 ---> Running in d920083de05d
Collecting click==7.1.2
  Downloading click-7.1.2-py2.py3-none-any.whl (82 kB)
Collecting dnspython==2.1.0
  Downloading dnspython-2.1.0-py3-none-any.whl (241 kB)
Collecting email-validator==1.1.2
  Downloading email_validator-1.1.2-py2.py3-none-any.whl (17 kB)
Collecting Flask==1.1.2
  Downloading Flask-1.1.2-py2.py3-none-any.whl (94 kB)
Collecting flask-mongoengine==1.0.0
  Downloading flask_mongoengine-1.0.0-py3-none-any.whl (25 kB)
Collecting Flask-WTF==0.14.3
  Downloading Flask_WTF-0.14.3-py2.py3-none-any.whl (13 kB)
Collecting gunicorn==20.0.4
  Downloading gunicorn-20.0.4-py2.py3-none-any.whl (77 kB)
Collecting idna==3.1
  Downloading idna-3.1-py3-none-any.whl (58 kB)
Collecting itsdangerous==1.1.0
  Downloading itsdangerous-1.1.0-py2.py3-none-any.whl (16 kB)
Collecting Jinja2==2.11.2
  Downloading Jinja2-2.11.2-py2.py3-none-any.whl (125 kB)
Collecting MarkupSafe==1.1.1
  Downloading MarkupSafe-1.1.1.tar.gz (19 kB)
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting mongoengine==0.23.1
  Downloading mongoengine-0.23.1-py3-none-any.whl (107 kB)
Collecting Pillow==8.2.0
  Downloading Pillow-8.2.0.tar.gz (47.9 MB)
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting prometheus-client==0.10.1
  Downloading prometheus_client-0.10.1-py2.py3-none-any.whl (55 kB)
Collecting prometheus-flask-exporter==0.18.2
  Downloading prometheus_flask_exporter-0.18.2.tar.gz (22 kB)
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting pymongo==3.11.4
  Downloading pymongo-3.11.4.tar.gz (783 kB)
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting PyYAML==5.3.1
  Downloading PyYAML-5.3.1.tar.gz (269 kB)
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting Werkzeug==1.0.1
  Downloading Werkzeug-1.0.1-py2.py3-none-any.whl (298 kB)
Collecting WTForms==2.3.3
  Downloading WTForms-2.3.3-py2.py3-none-any.whl (169 kB)
Collecting flask-prometheus-metrics==1.0.0
  Downloading flask_prometheus_metrics-1.0.0-py3-none-any.whl (6.2 kB)
Collecting WTForms[email]>=2.3.1
  Downloading WTForms-3.0.0-py3-none-any.whl (136 kB)
Requirement already satisfied: setuptools>=3.0 in /usr/local/lib/python3.6/site-packages (from gunicorn==20.0.4->-r /app/requirements.txt (line 7)) (59.6.0)
Building wheels for collected packages: MarkupSafe, Pillow, prometheus-flask-exporter, pymongo, PyYAML
  Building wheel for MarkupSafe (setup.py): started
  Building wheel for MarkupSafe (setup.py): finished with status 'done'
  Created wheel for MarkupSafe: filename=MarkupSafe-1.1.1-cp36-cp36m-linux_x86_64.whl size=27839 sha256=21f165c53184efe8ad65494b4280f4564ab9c2f6a27773489adcc0794679ec0a
  Stored in directory: /tmp/pip-ephem-wheel-cache-x61gzl4f/wheels/ca/85/2f/4c3a8ca6fb5eec7b43ec1e5666c7274dcdb86d6c32231aaa9d
  Building wheel for Pillow (setup.py): started
  Building wheel for Pillow (setup.py): finished with status 'done'
  Created wheel for Pillow: filename=Pillow-8.2.0-cp36-cp36m-linux_x86_64.whl size=1012752 sha256=5d702b485c777baebafbad6ff2486bc2a30a23f53ea6e438b4b11b7aed848c25
  Stored in directory: /tmp/pip-ephem-wheel-cache-x61gzl4f/wheels/35/67/ed/4b51d13d10751c51d04374e562e53cb92ca3758c9f95637c4b
  Building wheel for prometheus-flask-exporter (setup.py): started
  Building wheel for prometheus-flask-exporter (setup.py): finished with status 'done'
  Created wheel for prometheus-flask-exporter: filename=prometheus_flask_exporter-0.18.2-py3-none-any.whl size=17416 sha256=72b741ae2d5d828324d9ad096b21d15bd54bba2c351a022f5d017d14afa905af
  Stored in directory: /tmp/pip-ephem-wheel-cache-x61gzl4f/wheels/15/77/e8/3ca90b66243b0b58d5a5323a3da02cc8c5daf1de7a65141701
  Building wheel for pymongo (setup.py): started
  Building wheel for pymongo (setup.py): finished with status 'done'
  Created wheel for pymongo: filename=pymongo-3.11.4-cp36-cp36m-linux_x86_64.whl size=486486 sha256=20123534b25d80fa92f1655aa17e42f71d4a0cb2d6e0683b108756be89b526cc
  Stored in directory: /tmp/pip-ephem-wheel-cache-x61gzl4f/wheels/c8/c9/80/8a2bef5ab2bf6bc55c4cd6557e0601b43bbbf902d225354baf
  Building wheel for PyYAML (setup.py): started
  Building wheel for PyYAML (setup.py): finished with status 'done'
  Created wheel for PyYAML: filename=PyYAML-5.3.1-cp36-cp36m-linux_x86_64.whl size=44635 sha256=34e00de8c58f38ad08fd8a6a301b921bd13c95a5e1f871a0c5224e034a28fc50
  Stored in directory: /tmp/pip-ephem-wheel-cache-x61gzl4f/wheels/e5/9d/ad/2ee53cf262cba1ffd8afe1487eef788ea3f260b7e6232a80fc
Successfully built MarkupSafe Pillow prometheus-flask-exporter pymongo PyYAML
Installing collected packages: MarkupSafe, Werkzeug, Jinja2, itsdangerous, idna, dnspython, click, WTForms, pymongo, Flask, email-validator, prometheus-client, mongoengine, Flask-WTF, PyYAML, prometheus-flask-exporter, Pillow, gunicorn, flask-prometheus-metrics, flask-mongoengine
  Attempting uninstall: MarkupSafe
    Found existing installation: MarkupSafe 2.0.1
    Uninstalling MarkupSafe-2.0.1:
      Successfully uninstalled MarkupSafe-2.0.1
  Attempting uninstall: Werkzeug
    Found existing installation: Werkzeug 2.0.3
    Uninstalling Werkzeug-2.0.3:
      Successfully uninstalled Werkzeug-2.0.3
  Attempting uninstall: Jinja2
    Found existing installation: Jinja2 3.0.3
    Uninstalling Jinja2-3.0.3:
      Successfully uninstalled Jinja2-3.0.3
  Attempting uninstall: itsdangerous
    Found existing installation: itsdangerous 2.0.1
    Uninstalling itsdangerous-2.0.1:
      Successfully uninstalled itsdangerous-2.0.1
  Attempting uninstall: click
    Found existing installation: click 8.0.4
    Uninstalling click-8.0.4:
      Successfully uninstalled click-8.0.4
  Attempting uninstall: Flask
    Found existing installation: Flask 2.0.3
    Uninstalling Flask-2.0.3:
      Successfully uninstalled Flask-2.0.3
  Attempting uninstall: Pillow
    Found existing installation: Pillow 8.4.0
    Uninstalling Pillow-8.4.0:
      Successfully uninstalled Pillow-8.4.0
  Attempting uninstall: gunicorn
    Found existing installation: gunicorn 20.1.0
    Uninstalling gunicorn-20.1.0:
      Successfully uninstalled gunicorn-20.1.0
Successfully installed Flask-1.1.2 Flask-WTF-0.14.3 Jinja2-2.11.2 MarkupSafe-1.1.1 Pillow-8.2.0 PyYAML-5.3.1 WTForms-2.3.3 Werkzeug-1.0.1 click-7.1.2 dnspython-2.1.0 email-validator-1.1.2 flask-mongoengine-1.0.0 flask-prometheus-metrics-1.0.0 gunicorn-20.0.4 idna-3.1 itsdangerous-1.1.0 mongoengine-0.23.1 prometheus-client-0.10.1 prometheus-flask-exporter-0.18.2 pymongo-3.11.4
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Removing intermediate container d920083de05d
 ---> 85f6dd8bd44d
Step 15/20 : COPY ./ .
 ---> bc3ad8b68421
Step 16/20 : RUN addgroup -g $GROUP_ID www
 ---> Running in c95df27e91be
Removing intermediate container c95df27e91be
 ---> 80f58998621a
Step 17/20 : RUN adduser -D -u $USER_ID -G www www -s /bin/sh
 ---> Running in bb71395b6e2f
Removing intermediate container bb71395b6e2f
 ---> 0fe7d909efcb
Step 18/20 : USER www
 ---> Running in 8f577e1a88a0
Removing intermediate container 8f577e1a88a0
 ---> e40253e8c8e4
Step 19/20 : EXPOSE 5000
 ---> Running in c20847c210c4
Removing intermediate container c20847c210c4
 ---> eabf2ff9c75a
Step 20/20 : CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "app"]
 ---> Running in 16174ec630b8
Removing intermediate container 16174ec630b8
 ---> 379ee9031720
Successfully built 379ee9031720
Successfully tagged fernandomj90/flask-python:3.6.1
Building webserver
Sending build context to Docker daemon  28.47MB
Step 1/6 : FROM alpine:3.15.4
 ---> 0ac33e5f5afa
Step 2/6 : LABEL MAINTAINER="Fernando Muller <fernandomj90@gmail.com>"
 ---> Running in aa7d16f2b060
Removing intermediate container aa7d16f2b060
 ---> eb434723c407
Step 3/6 : RUN apk --update add nginx &&     ln -sf /dev/stdout /var/log/nginx/access.log &&     ln -sf /dev/stderr /var/log/nginx/error.log &&     mkdir /etc/nginx/sites-enabled/ &&     mkdir -p /run/nginx &&     rm -rf /etc/nginx/conf.d/default.conf &&     rm -rf /var/cache/apk/*
 ---> Running in fdd837909013
fetch https://dl-cdn.alpinelinux.org/alpine/v3.15/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.15/community/x86_64/APKINDEX.tar.gz
(1/2) Installing pcre (8.45-r1)
(2/2) Installing nginx (1.20.2-r1)
Executing nginx-1.20.2-r1.pre-install
Executing nginx-1.20.2-r1.post-install
Executing busybox-1.34.1-r5.trigger
OK: 7 MiB in 16 packages
Removing intermediate container fdd837909013
 ---> 6aabfd8f7063
Step 4/6 : COPY ./setup/nginx/conf.d/app.conf /etc/nginx/conf.d/app.conf
 ---> 6ce256d7ea7f
Step 5/6 : EXPOSE 80 443
 ---> Running in 4f372fcf5cc6
Removing intermediate container 4f372fcf5cc6
 ---> 015dcbf62278
Step 6/6 : CMD ["nginx", "-g", "daemon off;"]
 ---> Running in ab5708246262
Removing intermediate container ab5708246262
 ---> 4972dd3ea954
Successfully built 4972dd3ea954
Successfully tagged fernandomj90/nginx-alpine-desafio-docker:3.15.4
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
~~~~






- Novas imagens:
~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker image ls | head
REPOSITORY                                                                      TAG                  IMAGE ID       CREATED          SIZE
fernandomj90/nginx-alpine-desafio-docker                                        3.15.4               4972dd3ea954   44 seconds ago   7.01MB
fernandomj90/flask-python                                                       3.6.1                379ee9031720   48 seconds ago   367MB
~~~~




- Usar o force recreate
docker-compose up --force-recreate
docker-compose up -d --force-recreate

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker-compose up -d --force-recreate
Creating network "rotten-potatoes_backend" with driver "bridge"
Creating network "rotten-potatoes_frontend" with driver "bridge"
Creating mongodb ... done
Creating flask   ... done
Creating webserver ... done
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker ps
CONTAINER ID   IMAGE                                             COMMAND                  CREATED         STATUS                                  PORTS                                                                      NAMES
d095e0eb893c   fernandomj90/nginx-alpine-desafio-docker:3.15.4   "nginx -g 'daemon of…"   4 seconds ago   Up 3 seconds                            0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp   webserver
28ef62db8708   fernandomj90/flask-python:3.6.1                   "gunicorn -w 4 --bin…"   5 seconds ago   Restarting (3) Less than a second ago                                                                              flask
b81394c6e158   mongo:4.0.8                                       "docker-entrypoint.s…"   5 seconds ago   Up 4 seconds                            0.0.0.0:27017->27017/tcp, :::27017->27017/tcp                              mongodb
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
~~~~






- Segue com erro, mesmo após ajustar o nome de wsgi para app no Dockerfile do Python:
~~~~bash
[2022-05-29 21:29:52 +0000] [10] [INFO] Worker exiting (pid: 10)
[2022-05-29 21:29:52 +0000] [11] [INFO] Booting worker with pid: 11
[2022-05-29 21:29:52 +0000] [11] [ERROR] Exception in worker process
Traceback (most recent call last):
  File "/usr/local/lib/python3.6/site-packages/gunicorn/arbiter.py", line 583, in spawn_worker
    worker.init_process()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/workers/base.py", line 119, in init_process
    self.load_wsgi()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/workers/base.py", line 144, in load_wsgi
    self.wsgi = self.app.wsgi()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/base.py", line 67, in wsgi
    self.callable = self.load()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/wsgiapp.py", line 49, in load
    return self.load_wsgiapp()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/wsgiapp.py", line 39, in load_wsgiapp
    return util.import_app(self.app_uri)
  File "/usr/local/lib/python3.6/site-packages/gunicorn/util.py", line 358, in import_app
    mod = importlib.import_module(module)
  File "/usr/local/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 978, in _gcd_import
  File "<frozen importlib._bootstrap>", line 961, in _find_and_load
  File "<frozen importlib._bootstrap>", line 948, in _find_and_load_unlocked
ModuleNotFoundError: No module named 'app'
[2022-05-29 21:29:52 +0000] [11] [INFO] Worker exiting (pid: 11)
[2022-05-29 21:29:52 +0000] [1] [INFO] Shutting down: Master
[2022-05-29 21:29:52 +0000] [1] [INFO] Reason: Worker failed to boot.
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
~~~~




# PENDENTE
- Ajustar o problema no container do Flask.
- Otimizar a imagem do Python/Flask.




# Dia 05/06/2022

- Derrubando containers:
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes
docker-compose down


- Ajustado o Dockerfile do Flask
DE:
CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "app"]
PARA:
CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "./src/app.py"]

- Usar o --no-cache
docker-compose build --no-cache
docker-compose up -d

- ERRO no container do flask:
~~~~bash
[2022-06-05 21:32:38 +0000] [10] [INFO] Worker exiting (pid: 10)
[2022-06-05 21:32:38 +0000] [11] [INFO] Booting worker with pid: 11
[2022-06-05 21:32:38 +0000] [11] [ERROR] Exception in worker process
Traceback (most recent call last):
  File "/usr/local/lib/python3.6/site-packages/gunicorn/arbiter.py", line 583, in spawn_worker
    worker.init_process()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/workers/base.py", line 119, in init_process
    self.load_wsgi()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/workers/base.py", line 144, in load_wsgi
    self.wsgi = self.app.wsgi()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/base.py", line 67, in wsgi
    self.callable = self.load()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/wsgiapp.py", line 49, in load
    return self.load_wsgiapp()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/wsgiapp.py", line 39, in load_wsgiapp
    return util.import_app(self.app_uri)
  File "/usr/local/lib/python3.6/site-packages/gunicorn/util.py", line 358, in import_app
    mod = importlib.import_module(module)
  File "/usr/local/lib/python3.6/importlib/__init__.py", line 121, in import_module
    raise TypeError(msg.format(name))
TypeError: the 'package' argument is required to perform a relative import for './src/app.py'
[2022-06-05 21:32:38 +0000] [11] [INFO] Worker exiting (pid: 11)
[2022-06-05 21:32:38 +0000] [1] [INFO] Shutting down: Master
[2022-06-05 21:32:38 +0000] [1] [INFO] Reason: Worker failed to boot.
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
~~~~





- Ajustado o Dockerfile do Flask
DE:
CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "./src/app.py"]
PARA:
CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "app:app"]


- Usar o --no-cache
docker-compose build --no-cache
docker-compose up -d


~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker inspect flask
[
    {
        "Id": "bd063cd3f8f887e9adbb29bd7c08053d6cb1cdf7974a42c0c0199d0019a6879a",
        "Created": "2022-06-05T21:42:29.324041373Z",
        "Path": "gunicorn",
        "Args": [
            "-w",
            "4",
            "--bind",
            "0.0.0.0:5000",
            "./src/app.py"
~~~~



~~~~bash
[2022-06-05 21:48:12 +0000] [10] [INFO] Worker exiting (pid: 10)
[2022-06-05 21:48:12 +0000] [1] [INFO] Shutting down: Master
[2022-06-05 21:48:12 +0000] [1] [INFO] Reason: Worker failed to boot.
[2022-06-05 21:48:16 +0000] [1] [INFO] Starting gunicorn 20.0.4
[2022-06-05 21:48:16 +0000] [1] [INFO] Listening at: http://0.0.0.0:5000 (1)
[2022-06-05 21:48:16 +0000] [1] [INFO] Using worker: sync
[2022-06-05 21:48:16 +0000] [10] [INFO] Booting worker with pid: 10
[2022-06-05 21:48:16 +0000] [10] [ERROR] Exception in worker process
Traceback (most recent call last):
  File "/usr/local/lib/python3.6/site-packages/gunicorn/arbiter.py", line 583, in spawn_worker
    worker.init_process()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/workers/base.py", line 119, in init_process
    self.load_wsgi()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/workers/base.py", line 144, in load_wsgi
    self.wsgi = self.app.wsgi()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/base.py", line 67, in wsgi
    self.callable = self.load()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/wsgiapp.py", line 49, in load
    return self.load_wsgiapp()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/wsgiapp.py", line 39, in load_wsgiapp
    return util.import_app(self.app_uri)
  File "/usr/local/lib/python3.6/site-packages/gunicorn/util.py", line 358, in import_app
    mod = importlib.import_module(module)
  File "/usr/local/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 978, in _gcd_import
  File "<frozen importlib._bootstrap>", line 961, in _find_and_load
  File "<frozen importlib._bootstrap>", line 948, in _find_and_load_unlocked
ModuleNotFoundError: No module named 'app'
[2022-06-05 21:48:16 +0000] [10] [INFO] Worker exiting (pid: 10)
[2022-06-05 21:48:16 +0000] [1] [INFO] Shutting down: Master
[2022-06-05 21:48:16 +0000] [1] [INFO] Reason: Worker failed to boot.
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
~~~~







To change to the project folder you can use the command --chdir.
Example:
gunicorn -w 2 -b 0.0.0.0:8000 --chdir /code/myproject myproject.wsgi


- AJUSTANDO O DOCKERFILE:
DE:
CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "app:app"]
PARA:
CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "--chdir /app" , "app:app"]


- Derrubando containers:
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes
docker-compose down

- Usar o --no-cache
docker-compose build --no-cache
docker-compose up -d


- CONTINUA O ERRO:
~~~~bash
ModuleNotFoundError: No module named 'app'
[2022-06-05 21:48:16 +0000] [10] [INFO] Worker exiting (pid: 10)
[2022-06-05 21:48:16 +0000] [1] [INFO] Shutting down: Master
[2022-06-05 21:48:16 +0000] [1] [INFO] Reason: Worker failed to boot.
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
~~~~




- AJUSTANDO O DOCKERFILE:
DE:
COPY ./ .
PARA:
COPY ./src .


- Derrubando containers:
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes
docker-compose down

- Usar o --no-cache
docker-compose build --no-cache
docker-compose up -d
docker ps

- CONTINUA O ERRO:
~~~~bash
ModuleNotFoundError: No module named 'app'
[2022-06-05 22:18:14 +0000] [10] [INFO] Worker exiting (pid: 10)
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
~~~~





- AJUSTANDO O DOCKERFILE:
DE:
COPY ./src/app.py /app.py
PARA:
COPY ./src/app.py /app/app.py

- Derrubando containers:
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes
docker-compose down

- Usar o --no-cache
docker-compose build --no-cache
docker-compose up -d
docker ps

- CONTINUA O ERRO:
~~~~bash
ModuleNotFoundError: No module named 'app'
[2022-06-05 22:24:35 +0000] [9] [INFO] Worker exiting (pid: 9)
[2022-06-05 22:24:35 +0000] [1] [INFO] Shutting down: Master
[2022-06-05 22:24:35 +0000] [1] [INFO] Reason: Worker failed to boot.
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
~~~~




- AJUSTANDO O DOCKERFILE:
DE:
CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "app:app"]
PARA:
CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "app.wsgi_app"]

- Derrubando containers:
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes
docker-compose down

- Usar o --no-cache
docker-compose build --no-cache
docker-compose up -d
docker ps

- CONTINUA O ERRO:
~~~~bash
ModuleNotFoundError: No module named 'app'
[2022-06-05 22:34:57 +0000] [9] [INFO] Worker exiting (pid: 9)
[2022-06-05 22:34:57 +0000] [1] [INFO] Shutting down: Master
[2022-06-05 22:34:57 +0000] [1] [INFO] Reason: Worker failed to boot.
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
~~~~




- Detalhes como é nomeado o module do Gunicorn
<https://stackoverflow.com/questions/62334493/getting-modulenotfounderror-no-module-named-app-when-deploying-flask-app-to>
From the gunicorn docs, it should be:
    $ gunicorn [OPTIONS] APP_MODULE
    Where APP_MODULE is of the pattern $(MODULE_NAME):$(VARIABLE_NAME). The module name can be a full dotted path. The variable name refers to a WSGI callable that should be found in the specified module.
Since you defined your Flask app instance (app = Flask(__name__)) inside main.py then your module name is main (not app), so your Procfile should contain:
    web: gunicorn -b :$PORT main:app


# PENDENTE
- Ajustar o problema no container do Flask.
- Avaliar se o problema pode estar ocorrendo devido o COPY dos arquivos e o container não ter o arquivo app.py.
- Avaliar contexto do Docker-compose e Dockerfile, cópia dos arquivos, etc
- Efetuar teste sem Docker-compose, buildando só via Dockerfile no braço, para avaliar se o contexto está atrapalhando.
- Otimizar a imagem do Python/Flask.
# Tentar isto:

https://stackoverflow.com/questions/22711087/flask-importerror-no-module-named-app
Ensure to set your PYTHONPATH to the src/ directory as well. Example export PYTHONPATH="$PYTHONPATH:/path/to/your/src"
    Thanks, yes, I'm using flask boilerplate and this what actually helped 
        export PYTHONPATH="$PYTHONPATH:/var/gx/app"

- Também tentar seguir orientações da DOC do Gunicorn:
<https://docs.gunicorn.org/en/stable/run.html#gunicorn>

- Outra opção:
<https://stackoverflow.com/questions/43728431/relative-imports-modulenotfounderror-no-module-named-x>
You have to append your project's path to PYTHONPATH and make sure to use absolute imports.
For UNIX (Linux, OSX, ...)
    export PYTHONPATH="${PYTHONPATH}:/path/to/your/project/"






# Dia 11/06/2022


- Derrubando containers:
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes
docker-compose down

- Ajustados os Dockerfiles do NGINX e do FLASK.
- Ajustado o docker-compose.yml
- Seguindo projeto do Faizan Bashir.
<https://github.com/faizanbashir/flask-gunicorn-nginx-docker>


- Usar o --no-cache
docker-compose build --no-cache
docker-compose up -d
docker ps


192.168.0.113:9000


- Segue com erro, mesmo com os ajustes efetuados em relação a contexto, docker-compose, Dockerfile, etc:

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker ps
CONTAINER ID   IMAGE                                             COMMAND                  CREATED          STATUS                         PORTS                                                                      NAMES
1558d9860bd1   fernandomj90/nginx-alpine-desafio-docker:3.15.4   "nginx -g 'daemon of…"   26 seconds ago   Up 24 seconds                  0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp   webserver
af24e5406414   fernandomj90/flask-python:3.6.1                   "gunicorn -w 4 --bin…"   27 seconds ago   Restarting (3) 5 seconds ago                                                                              flask
3e5174af78b7   mongo:4.0.8                                       "docker-entrypoint.s…"   28 seconds ago   Up 27 seconds                  0.0.0.0:27017->27017/tcp, :::27017->27017/tcp                              mongodb
4e0cc1b8a495   portainer/portainer                               "/portainer"             5 minutes ago    Up 5 minutes                   0.0.0.0:9000->9000/tcp, :::9000->9000/tcp                                  frosty_easley
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ date
Sat 11 Jun 2022 12:03:32 PM -03
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$


[2022-06-11 15:32:15 +0000] [8] [INFO] Worker exiting (pid: 8)
[2022-06-11 15:32:15 +0000] [1] [INFO] Shutting down: Master
[2022-06-11 15:32:15 +0000] [1] [INFO] Reason: Worker failed to boot.
[2022-06-11 15:32:17 +0000] [1] [INFO] Starting gunicorn 20.0.4
[2022-06-11 15:32:17 +0000] [1] [INFO] Listening at: http://0.0.0.0:5000 (1)
[2022-06-11 15:32:17 +0000] [1] [INFO] Using worker: sync
[2022-06-11 15:32:17 +0000] [9] [INFO] Booting worker with pid: 9
[2022-06-11 15:32:17 +0000] [9] [ERROR] Exception in worker process
Traceback (most recent call last):
  File "/usr/local/lib/python3.6/site-packages/gunicorn/arbiter.py", line 583, in spawn_worker
    worker.init_process()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/workers/base.py", line 119, in init_process
    self.load_wsgi()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/workers/base.py", line 144, in load_wsgi
    self.wsgi = self.app.wsgi()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/base.py", line 67, in wsgi
    self.callable = self.load()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/wsgiapp.py", line 49, in load
    return self.load_wsgiapp()
  File "/usr/local/lib/python3.6/site-packages/gunicorn/app/wsgiapp.py", line 39, in load_wsgiapp
    return util.import_app(self.app_uri)
  File "/usr/local/lib/python3.6/site-packages/gunicorn/util.py", line 358, in import_app
    mod = importlib.import_module(module)
  File "/usr/local/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 994, in _gcd_import
  File "<frozen importlib._bootstrap>", line 971, in _find_and_load
  File "<frozen importlib._bootstrap>", line 953, in _find_and_load_unlocked
ModuleNotFoundError: No module named 'wsgi'
[2022-06-11 15:32:17 +0000] [9] [INFO] Worker exiting (pid: 9)
[2022-06-11 15:32:17 +0000] [1] [INFO] Shutting down: Master
[2022-06-11 15:32:17 +0000] [1] [INFO] Reason: Worker failed to boot.

~~~~







-Novos ajustes.
- Ajustado arquivo app.py.
- Criado arquivo wsgi.py
- Ajustado o Dockerfile do flask.


- Testando a seguinte configuração no appy.py:
~~~~python
# Nova configuração
if __name__ == "__main__":
    ENVIRONMENT_DEBUG = os.environ.get("APP_DEBUG", True)
    ENVIRONMENT_PORT = os.environ.get("APP_PORT", 5000)
    app.run(host='0.0.0.0', port=ENVIRONMENT_PORT, debug=ENVIRONMENT_DEBUG)
~~~~


- Testando a seguinte configuração no wsgi.py:

~~~~python
from app import app

if __name__ == "__main__":
	app.run()
~~~~

- Derrubando containers:
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes
docker-compose down


- Usar o --no-cache
docker-compose build --no-cache
docker-compose up -d
docker ps






- Adicionado ao Dockerfile:
  RUN export PYTHONPATH="$PYTHONPATH:/app"

- Derrubando containers:
cd /home/fernando/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes
docker-compose down


- Usar o --no-cache
docker-compose build --no-cache
docker-compose up -d
docker ps


- NÃO RESOLVEU.









- Assim também não funcionou:

~~~~Dockerfile
FROM python:3.6.12-alpine

COPY requirements.txt /
RUN pip3 install -r /requirements.txt

COPY . /app
WORKDIR /app

ENTRYPOINT ["./gunicorn.sh"]
~~~~







- Assim também não funcionou:

~~~~Dockerfile
FROM python:3.6.12-alpine

RUN apk add --no-cache jpeg-dev zlib-dev
RUN apk add --no-cache --virtual .build-deps build-base linux-headers \
    && pip install Pillow

RUN pip install --upgrade pip
RUN pip install -U pip setuptools wheel
RUN pip install markupsafe
RUN pip install flask
RUN pip install gunicorn

COPY requirements.txt /
RUN pip3 install -r /requirements.txt

COPY . /app
WORKDIR /app

ENTRYPOINT ["./gunicorn.sh"]
~~~~



- ERRO

~~~~bash
Successfully built 080e2de5a872
Successfully tagged fernandomj90/nginx-alpine-desafio-docker:3.15.4
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker-compose up -d
Creating mongodb ... done
Creating flask   ... error

ERROR: for flask  Cannot start service flask: OCI runtime create failed: container_linux.go:380: starting container process caused: exec: "./gunicorn.sh": stat ./gunicorn.sh: no such file or directory: unknown

ERROR: for flask  Cannot start service flask: OCI runtime create failed: container_linux.go:380: starting container process caused: exec: "./gunicorn.sh": stat ./gunicorn.sh: no such file or directory: unknown
ERROR: Encountered errors while bringing up the project.
fernando@debian10x64:~/cursos/kubedev/aula56-Desafio-Docker/questao4/rotten-potatoes$ docker ps

~~~~
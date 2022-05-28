

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



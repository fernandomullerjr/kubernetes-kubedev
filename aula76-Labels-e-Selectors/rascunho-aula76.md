

# Labels

As labels são importantes para o gerenciamento do cluster, pois com elas é possível buscar ou selecionar recursos em seu cluster, fazendo com que você consiga organizar em pequenas categorias, facilitando assim a sua busca e organizando seus pods e seus recursos do cluster. As labels não são recursos do API server, elas são armazenadas no metadata em formato chave-valor.

Labels

Labels are key-value pairs which are attached to pods, replication controller and services. They are used as identifying attributes for objects such as pods and replication controller. They can be added to an object at creation time and can be added or modified at the run time.



- Iremos usar o meuprimeiropod como base para entender sobre Labels.
- Criar arquivo chamado "meupodazul.yaml":
/home/fernando/cursos/kubedev/aula76-Labels-e-Selectors/meupodazul.yaml

~~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: meupodazul
  labels:
    app: nginx
    versao: azul
spec:
  containers:
  - name: meucontainer
    image: kubedevio/nginx-color:blue
~~~~



- Criar também um arquivo chamado "meupodverde.yaml":
/home/fernando/cursos/kubedev/aula76-Labels-e-Selectors/meupodverde.yaml

~~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: meupodverde
  labels:
    app: nginx
    versao: verde
spec:
  containers:
  - name: meucontainer
    image: kubedevio/nginx-color:blue
~~~~
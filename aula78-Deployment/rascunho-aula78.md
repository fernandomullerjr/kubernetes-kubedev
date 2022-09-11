
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# push
git add .
git commit -m "aula78 - Deployment"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push


# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# DEPLOYMENT

 O deployment é responsável por gerenciar o ReplicaSet.






# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# Deployments
<https://kubernetes.io/docs/concepts/workloads/controllers/deployment/>
A Deployment provides declarative updates for Pods and ReplicaSets.

You describe a desired state in a Deployment, and the Deployment Controller changes the actual state to the desired state at a controlled rate. You can define Deployments to create new ReplicaSets, or to remove existing Deployments and adopt all their resources with new Deployments.

# Creating a Deployment

The following is an example of a Deployment. It creates a ReplicaSet to bring up three nginx Pods:
controllers/nginx-deployment.yaml [Copy controllers/nginx-deployment.yaml to clipboard]

~~~~bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
~~~~





- Criando o primeiro Deployment, o manifesto é bem parecido com o do ReplicaSet.
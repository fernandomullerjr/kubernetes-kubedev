
# Pod

Pod pode ter 1 ou + containers.

Não é uma boa prática usar vários containers num mesmo Pod.

1 Container adicional no Pod é interessante ao usar Sidecar, como coleta de logs, Service Mesh.

Não é interessante subir o Pod sozinho, sem ser via Deployment, ReplicaSet, entre outros, pois não garante escalabilidade, resiliência, etc. Um Pod iniciado desta forma é chamado de “Naked Pod”.



# Manifesto do Pod

- A estrutura básica do manifesto do Pod é composta por:
apiVersion: 
kind: 
metadata:
spec:


- O apiVersion pode variar.
- Podemos checar a versão da API usando o comando:
kubectl api-resources

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula75-Pod$ kubectl api-resources
NAME                              SHORTNAMES   APIVERSION                             NAMESPACED   KIND
bindings                                       v1                                     true         Binding
componentstatuses                 cs           v1                                     false        ComponentStatus
configmaps                        cm           v1                                     true         ConfigMap
endpoints                         ep           v1                                     true         Endpoints
events                            ev           v1                                     true         Event
limitranges                       limits       v1                                     true         LimitRange
namespaces                        ns           v1                                     false        Namespace
nodes                             no           v1                                     false        Node
persistentvolumeclaims            pvc          v1                                     true         PersistentVolumeClaim
persistentvolumes                 pv           v1                                     false        PersistentVolume
pods                              po           v1                                     true         Pod
podtemplates                                   v1                                     true         PodTemplate
replicationcontrollers            rc           v1                                     true         ReplicationController
resourcequotas                    quota        v1                                     true         ResourceQuota
secrets                                        v1                                     true         Secret
serviceaccounts                   sa           v1                                     true         ServiceAccount
services                          svc          v1                                     true         Service
mutatingwebhookconfigurations                  admissionregistration.k8s.io/v1        false        MutatingWebhookConfiguration
validatingwebhookconfigurations                admissionregistration.k8s.io/v1        false        ValidatingWebhookConfiguration
customresourcedefinitions         crd,crds     apiextensions.k8s.io/v1                false        CustomResourceDefinition
apiservices                                    apiregistration.k8s.io/v1              false        APIService
controllerrevisions                            apps/v1                                true         ControllerRevision
daemonsets                        ds           apps/v1                                true         DaemonSet
deployments                       deploy       apps/v1                                true         Deployment
replicasets                       rs           apps/v1                                true         ReplicaSet
statefulsets                      sts          apps/v1                                true         StatefulSet
tokenreviews                                   authentication.k8s.io/v1               false        TokenReview
localsubjectaccessreviews                      authorization.k8s.io/v1                true         LocalSubjectAccessReview
selfsubjectaccessreviews                       authorization.k8s.io/v1                false        SelfSubjectAccessReview
selfsubjectrulesreviews                        authorization.k8s.io/v1                false        SelfSubjectRulesReview
subjectaccessreviews                           authorization.k8s.io/v1                false        SubjectAccessReview
horizontalpodautoscalers          hpa          autoscaling/v1                         true         HorizontalPodAutoscaler
cronjobs                          cj           batch/v1                               true         CronJob
jobs                                           batch/v1                               true         Job
certificatesigningrequests        csr          certificates.k8s.io/v1                 false        CertificateSigningRequest
leases                                         coordination.k8s.io/v1                 true         Lease
endpointslices                                 discovery.k8s.io/v1                    true         EndpointSlice
events                            ev           events.k8s.io/v1                       true         Event
flowschemas                                    flowcontrol.apiserver.k8s.io/v1beta1   false        FlowSchema
prioritylevelconfigurations                    flowcontrol.apiserver.k8s.io/v1beta1   false        PriorityLevelConfiguration
ingressclasses                                 networking.k8s.io/v1                   false        IngressClass
ingresses                         ing          networking.k8s.io/v1                   true         Ingress
networkpolicies                   netpol       networking.k8s.io/v1                   true         NetworkPolicy
runtimeclasses                                 node.k8s.io/v1                         false        RuntimeClass
poddisruptionbudgets              pdb          policy/v1                              true         PodDisruptionBudget
podsecuritypolicies               psp          policy/v1beta1                         false        PodSecurityPolicy
clusterrolebindings                            rbac.authorization.k8s.io/v1           false        ClusterRoleBinding
clusterroles                                   rbac.authorization.k8s.io/v1           false        ClusterRole
rolebindings                                   rbac.authorization.k8s.io/v1           true         RoleBinding
roles                                          rbac.authorization.k8s.io/v1           true         Role
priorityclasses                   pc           scheduling.k8s.io/v1                   false        PriorityClass
csidrivers                                     storage.k8s.io/v1                      false        CSIDriver
csinodes                                       storage.k8s.io/v1                      false        CSINode
csistoragecapacities                           storage.k8s.io/v1beta1                 true         CSIStorageCapacity
storageclasses                    sc           storage.k8s.io/v1                      false        StorageClass
volumeattachments                              storage.k8s.io/v1                      false        VolumeAttachment
fernando@debian10x64:~/cursos/kubedev/aula75-Pod$

~~~~



- Filtrando pela versão da API para os Pods apenas:
kubectl api-resources | grep pod

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula75-Pod$ kubectl api-resources | grep pod
pods                              po           v1                                     true         Pod
podtemplates                                   v1                                     true         PodTemplate
horizontalpodautoscalers          hpa          autoscaling/v1                         true         HorizontalPodAutoscaler
poddisruptionbudgets              pdb          policy/v1                              true         PodDisruptionBudget
podsecuritypolicies               psp          policy/v1beta1                         false        PodSecurityPolicy
fernando@debian10x64:~/cursos/kubedev/aula75-Pod$
~~~~



- No campo "kind" preenchemos com o tipo de recurso que iremos criar, nosso caso é:
Pod

- No "metadata" colocamos metadata que iremos usar.
- Inicialmente iremos usar somente o "metadata" do tipo "name"
    name: meuprimeiropod


- Também precisamos especificar o "spec".
- Na parte de "spec" devemos colocar os detalhes do recurso, no nosso caso vai ser um Container, onde iremos usar a imagem do nginx personalizada da kubedev.

~~~~yaml
spec:
  containers:
  - name: meucontainer
    image: kubedevio/nginx-color:blue
~~~~



- Ao final o manifesto do Pod ficará assim:

~~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: meuprimeiropod
spec:
  containers:
  - name: meucontainer
    image: kubedevio/nginx-color:blue
~~~~


- Aplicando o primeiro Pod:
kubectl apply -f /home/fernando/cursos/kubedev/aula75-Pod/meuprimeiropod.yaml

~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula75-Pod$ kubectl apply -f /home/fernando/cursos/kubedev/aula75-Pod/meuprimeiropod.yaml
pod/meuprimeiropod created
fernando@debian10x64:~/cursos/kubedev/aula75-Pod$


fernando@debian10x64:~/cursos/kubedev/aula75-Pod$ kubectl get pods -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS      AGE
default       meuprimeiropod                     1/1     Running   0             16s
~~~~




~~~~bash
fernando@debian10x64:~/cursos/kubedev/aula75-Pod$
fernando@debian10x64:~/cursos/kubedev/aula75-Pod$ kubectl describe pod meuprimeiropod
Name:         meuprimeiropod
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Sun, 28 Aug 2022 00:26:17 -0300
Labels:       <none>
Annotations:  <none>
Status:       Running
IP:           172.17.0.3
IPs:
  IP:  172.17.0.3
Containers:
  meucontainer:
    Container ID:   docker://3d3ac3e82869a0854a9e0b1af07b20e35a58d700805961dfc01ca3212ab196c7
    Image:          kubedevio/nginx-color:blue
    Image ID:       docker-pullable://kubedevio/nginx-color@sha256:fde5b9a15847ff0156721b6ec6d68a9af8ad9f081d2192421605bb9b41297dad
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Sun, 28 Aug 2022 00:26:27 -0300
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-psnwq (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-psnwq:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  3m31s  default-scheduler  Successfully assigned default/meuprimeiropod to minikube
  Normal  Pulling    3m30s  kubelet            Pulling image "kubedevio/nginx-color:blue"
  Normal  Pulled     3m22s  kubelet            Successfully pulled image "kubedevio/nginx-color:blue" in 8.350632927s
  Normal  Created    3m22s  kubelet            Created container meucontainer
  Normal  Started    3m21s  kubelet            Started container meucontainer
fernando@debian10x64:~/cursos/kubedev/aula75-Pod$
~~~~




- Para poder verificar a página do NGINX rodando, usaremos o comando kubectl port-forward.
<https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/>
kubectl port-forward
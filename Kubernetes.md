# Kubernetes (K8s - Kate's)


Nacido como Google's BORG y publicado en el 2015, fue el **secreto** de Google para la ejecución de Workloads contenerizados, servicios como GMAIL, DRIVE, MAPS, DOCS,etc. usaban BORG.
Capacidades de K8S


- Escalamiento Horizontal.
- Balanceo de carga.
- Auto **Healing**.
- Auto rollout y rollbacks.
- Orquestación del Almacenamiento.
- Ejecución Batch.
- Administración de **Secrets**. 

	Dos principales componentes.

	- Nodo Control Plane (Master) 
	- Nodo Worker

## Control Plane

Recibe peticiones por linea de comandos, dashboard, interfaz web o directamente al API. Contiene varios agentes que son los responsables de administrar el estado del Cluster.   

	Se recomienda usar replicas de este nodo ya que podria causar un falla en el cluster si deja de ejecutarse.

Para poder guardar el estado del cluster se utiliza un almacen de datos de tipo **Key-Value** el cual aplila los datos relacionados con el estado del cluster.

### Agentes del Control Plane

Un Nodo de este tipo ejecuta escencialmente los siguientes agentes y componentes:

- **API Server.** 
	- Todas las tareas administrativas son coordinadas por este agente.
	- Intercepta todas la peticiones de usuarios o agentes hacia el cluster.
	- Es altamente escalable, pudiendo agregar API servers secundarios, trasformando al API server principal en una especie de Proxy para los secundarios.
- **Scheduler.**
	- Se encarga de la asignacion de nuevos worload objects hacia los nodos worker.
	- Verifica el estado del cluster atravez del API Server.
	- Es altamente configurable, usando plugins, politicas o perfiles.
	- Muy importantes y complexos en los clusters Multi Nodos de Kubernetes.
- **Control Manager.**
	- Se encarga de regular el estado del cluster.
	- Verifica el estado del cluster constantemente y verifica el estado deseado (definido en la configuración del cluster) y el estado actual (consultado atraves del API Server hacia el Data Store).
	- Existen dos tipos de Administrador de controladores, kube (local) y el Cloud (Conector con el proveedor de servicio de la nube).
- **Key-Value data store.**
	- Uno de los mas usado es **[etcd](https://etcd.io/)**, altamente consistente, apila la nueva información del cluster, compacta la información vieja para su posterior desacho, esto periodicamente para minimizar el tamaño del Data Store.
	- Alta disponibilidad, uso de roles como lider y seguidores, si el nodo lider falla, cualquier otro lo puede reemplazar.
	- Adicional a almacenar el estado del cluster, puede almacenar la configuración de subnets, ConfigMaps, Scecrets, etc.

Adicionalmente, puede ejecutar lo siguiente (Definido en los nodos [Worker](#worker-node)):

- **Container Runtime.**
- **Node Agent.**
- **Proxy.**
- **Addons adicionales para monitoreo y loggin del cluster.**

## Worker Node

- Provee un entorno de ejecución para las aplicaciones del cliente.
- Por medio de microservicios contenerizados, estas aplicaciones son encapsuladas en **Pods** y controladas por el cluster mediante los agentes del Nodo [Control Plane](#control-plane).
- Se asignan recursos que el **Pod** necesita como, Almacenaciento, memoria y red para la comunicación interna y externa.

Contiene los siguentes componentes:

- **Container Runtime.**
	- Descrito como el **motor de orquestación de contenedores**, es requerido en ambos nodos (Worker y Control Plane). 
	- Kubernetes soporta varios container runtimes:
		- [CRI-O](https://cri-o.io/).
		- [containerd](https://containerd.io/).
		- **[Docker](https://www.docker.com/)**
		- [Mirantis Container Runtime](https://www.mirantis.com/software/container-runtime/) (Docker Enterprise).
- **Node Agent - kublet.**
	- Es el agente que ejecuta en cualquier nodo (WK o CP).
	- Recibe las definiciones de los Pods, directo del [API Server](#agentes-del-control-plane) e interactua con el Container Runtime mediante una interfaz (CRI) 
- **Proxy - kube-proxy.**
	- Responsable de todas las operaciones de red del nodo.
	- TCP/UDP o SCTP, ademas de todo el mapeo de tráfico. 
- **Addons adicionales para monitoreo y loggin del cluster.**
	- Existen 4 tipos principales de Complementos:
		- DNS.
		- Dashboard.
		- Monitoreo.
		- Logging.
## Comunicación de Red 
- **Contenedor a contenedor:** Se ubican sobre el mismo pod y comparten namespace.
- **Pod a Pod:** Ip por pod, se manejan los pods como VM y cada una tiene su dirección.
- **Exposición de Pod:** Se accede atraves de un Servicio, el enrutamiento mediante reglas almacenadas en **[iptables](https://linux.die.net/man/8/iptables)** implementado por el agente kube-proxy

Para mayor información, checar el apartado de [Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/) con Kubernetes.

## Configuración e Instalación de Kubernetes.

- **All-in-One Single-Node:** Todos los componentes esta instalados en un solo nodo, Control plane y Worker con sus componentes.
- **Single-Control Plane y Multi-Worker:** Un solo nodo [Control plane](#control-plane) administrando los nodos [Worker](#worker-node).
- **Multi-Control Plane y Multi-Worker:** Multiples Nodos Control Plane para Alta disponibilidad administrados por una instancia de etcd.
- **Multi-Control Plane, con Multi-Nodo etcd y Multi-Worker:** Multiples Nodos Control Plane para Alta disponibilidad administrados por varias instancias de etcd externas.

### Herramientas de Instalación.

- [Minikube](https://minikube.sigs.k8s.io/docs/): Entorno local.
- [Kind](https://kind.sigs.k8s.io/docs/): Entorno local.
- [Docker Desktop](https://www.docker.com/products/docker-desktop): Entorno local.
- [MicroK8s](https://microk8s.io/): Entorno local y cloud.
- [K3S](https://k3s.io/): Entorno local, cloud, edge, IoT.

### Herramientas para despliegues productivos.

- [kubeadmin](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/): Herramienta de primera para despliegues productivos on-premise y on-cloud, basado en bloques, altamente extensible.
- [kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/): Tambien conocido como **kargo**, permite la instalación en entornos de alta dispònibilidad listos para producción como AWS, GC, Azure, OpenStack, Vsphere; basado en [Ansible](https://www.ansible.com/).
- [kops](https://kubernetes.io/docs/setup/production-environment/tools/kops/): Proveé de la creación, mejora y mantenimiento a nivel productivo de los clusters de Kubernetes de alta disponibilidad por medio de la linea de comandos (CLI).

### Soluciones actualmente disponibles.

- [Alibaba Cloud Container Service for Kubernetes (ACK)](https://www.alibabacloud.com/product/kubernetes).
- [Amazon Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/).
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/services/kubernetes-service/).
- [DigitalOcean Kubernetes](https://www.digitalocean.com/products/kubernetes/).
- [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine/).
- [IBM Cloud Kubernetes Service](https://www.ibm.com/cloud/kubernetes-service/).
- [Oracle Cloud Container Engine for Kubernetes (OKE)](https://www.oracle.com/cloud-native/container-engine-kubernetes/).
- [Platform9 Managed Kubernetes (PMK)](https://platform9.com/managed-kubernetes/).
- [Red Hat OpenShift](https://www.redhat.com/en/technologies/cloud-computing/openshift).
- [VMware Tanzu Kubernetes](https://tanzu.vmware.com/kubernetes-grid).
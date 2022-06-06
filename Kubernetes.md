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
	- Uno de los mas usado es **etcd**, altamente consistente, apila la nueva información del cluster, compacta la información vieja para su posterior desacho, esto periodicamente para minimizar el tamaño del Data Store.
	- Alta disponibilidad, uso de roles como lider y seguidores, si el nodo lider falla, cualquier otro lo puede reemplazar.
	- Adicional a almacenar el estado del cluster, puede almacenar la configuración de subnets, ConfigMaps, Scecrets, etc.

Adicionalmente, puede ejecutar lo siguiente:

- **Container Runtime.**
- **Node Agent.**
- **Proxy.**
- **Addons adicionales para monitoreo y loggin del cluster.**

## Worker Node

- Provee un entorno de ejecución para las aplicaciones del cliente.
- Por medio de microservicios contenerizados, estas aplicaciones son encapsuladas en **Pods** y controladas por el cluster mediante los agentes del Nodo [Control Plane](#control-plane)
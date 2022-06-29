# Demo Tanzu Workload

Una demostración del despliegue de un Workload con el seguimiento de la [documentación](https://tanzucommunityedition.io/docs/v0.12/) oficial del Tanzu Community Edition.


- Creación del cluster con kind y exposición de los puertos HTTP y HTTP/SSL:
```shell
tanzu unmanaged-cluster create app-demo-own -p 80:80 -p 443:443 --provider=kind
```

- Instalación de dependencia en el namespace *tkg-system*:
```shell
tanzu package install secretgen-controller --package-name secretgen-controller.community.tanzu.vmware.com --version 0.7.1 -n tkg-system
```

- Generación del Secret de con las Crendenciales del DockerHUB:
```shell
tanzu secret registry add registry-credentials --server https://index.docker.io/v1/ --username [USER] --password [PASS] --export-to-all-namespaces
```

- Generar el archivo **app-toolkit.yaml** con el siguiente contenido reemplazando las variables **$USER** y **$PASS**:
``` shell
contour:
  envoy:
    service:
      type: ClusterIP
    hostPorts:
      enable: true

knative_serving:
  domain:
    type: real
    name: 127-0-0-1.sslip.io

kpack:
  kp_default_repository: index.docker.io/$USER/app-toolkit-install
  kp_default_repository_username: $USER
  kp_default_repository_password: $PASS

cartographer_catalog:
  registry:
    server: index.docker.io
    repository: $USER
```

- Realizar la instalación del App-Toolkit con el YAML Generado (`app-toolkit.yaml`):
```sh
tanzu package install app-toolkit --package-name app-toolkit.community.tanzu.vmware.com --version 0.2.0 -f app-toolkit.yaml -n tanzu-package-repo-global
```

- Generación del Workload Demo con un repositorio al que tengamos acceso para su modificación:
```sh
tanzu apps workload create hola-mundo \
            --git-repo  https://github.com/rufo913/apptookit-demo \
            --git-branch main \
            --type web \
            --label app.kubernetes.io/part-of=hello-world \
            --yes \
            --tail \
            --namespace default
```

- Verificar el estatus del workload:
```sh
tanzu apps workload get hola-mundo
```

- Realizar algun cambio en el codigo y validar el rebuild y el deploy sin la interrupción del servicio:
```sh
tanzu apps workload tail hola-mundo 
```
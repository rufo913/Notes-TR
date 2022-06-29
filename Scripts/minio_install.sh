#!/bin/bash
# Minio S3 object storage like
# check URL https://min.io/
# velero and helm are requiered
# Velero on arch:
# | yay -S velero-bin
# HELM on arch:
# | pacman -Syy helm
# K8s cluster should be up

# MINIO INIT CONFIG
export MINIO_ROOT_USER=minioadmin
export MINIO_ROOT_PASSWORD=minioadmin
#export IP="172.31.7.109"
export IP=$(hostname --ip-address|cut -d ' ' -f1)
export BUCKET="backups-velero"
export NSP="demo-velero"
export BKPNAME="velero-backup-test"

# Descargar minio server
mkdir -p $HOME/Minio/data
cd $HOME/Minio 
wget https://dl.min.io/server/minio/release/linux-amd64/minio
chmod 755 minio
./minio server /data &

# Descarga minio client
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
./mc alias set minio http://$IP:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD 
# Crear un bucket
./mc mb $BUCKET

# Genera el archivo don las credenciales
touch $HOME/credentials-velero
echo "[default]" >> $HOME/credentials-velero
echo " aws_access_key_id = minioadmin" >> $HOME/credentials-velero
echo " aws_secret_access_key = minioadmin" >> $HOME/credentials-velero

# instala el deployment de velero en el cluster de K8s
velero install --provider aws --plugins velero/velero-plugin-for-aws:v1.2.1 --bucket $BUCKET --secret-file $HOME/credentials-velero --use-volume-snapshots=false --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://$IP:9000

# Instalar un deployment de prueba **Puede ser cualquiera sin volumenes persistentes ya que hay que configurar RESTIC para eso en las instalación de velero usando el flag --use-restic=true**
helm repo add cloudecho https://cloudecho.github.io/charts/
helm repo update
kubectl create namespace $NSP
helm install my-hello cloudecho/hello -n $NSP --version=0.1.2
read -t 5 -p "espera un momento..."

# Genera el BKP
velero create backup $BKPNAME --include-namespaces $NSP
velero backup describe $BKPNAME
read -t 5 -p "espera un momento..."

# Elimina el Namspace de prueba
kubectl delete namespace $NSP

# Restaura el BKP
velero restore create --from-backup $BKPNAME
read -t 5 -p "espera un momento..."
kubectl get all -n $NSP

## ***Laboratorio Análisis de Datos en Tiempo Real***


### Para MAC:
https://ubuntu.com/tutorials/install-microk8s-on-mac-os#1-overview

### ***Practica 0: Instalar dependencias.*** ###

Antes de comenzar el laboratorio, es imprescindible tener instalado el software que se va a emplear.
Para ello, se proporciona el script de la carpeta _scripts/instalardependencias.sh_, el cual se encarga de instalar Docker, docker-compose, microk8s y las dependencias necesarias de python:
- kafka-python
- confluent-kafka
- argparse (normalmente debería estar instalado)
    
Podemos comprobar la instalación con:
```bash
command -v docker-compose  # para docker-compose, docker para Docker y
                           # microk8s para probar la instalación de k8s 
```

Para entender y poder utilizar el proyecto, es necesario entender la jerarquia de las carpetas que lo componen:
```bash
analisisdedatosentiemporeal
├── README.md
├── capitulos (Aqui se encuentran los capitulos de la exposicion)
├── .gitignore
└── apache-kafka 
  ├── docker-compose-deployment
  │ ├── multiple-broker     (carpeta que contiene el docker-compose que despliega una instancia de kafka con 4 brokers)
  │ └── single-broker       (carpeta que contiene el docker-compose que despliega una instancia de kafka con 1 broker)
  ├── k8-deployment         (carpeta que contiene los despliegues necesarios de una instancia de kafka con 4 brokers)
  └── scripts
    ├── ETL practical example (carpeta que contiene los ejercicios de extracción y publicación de eventos en kafka)
    └── kafka-producers-and-consumers (carpeta que contiene las primeras publicaciones/consumiciones de eventos con kafka)
    └── instalardependencias.sh (script que instala las dependencias del laboratorio)
```

### ***Practica 1: Despliegue de kafka con un broker utilizando docker-compose.*** ###

```````bash
#Desde la raiz de nuestro proyecto Git
cd apache-kafka/docker-compose-deployment/single-broker
sudo docker-compose up 


 ✔ Container zookeeper  Started          
 ✔ Container kafka      Started                
 ✔ Container kafka-ui   Started

#Para comprobar que todos esta bien:

sudo docker ps

#Si abrimos nuestro explorador en: http://localhost:8080 deberiamos ver nuestra instancia de kafka
```````

### ***Practica 2: Despliegue de kafka con cuatro brokers utilizando docker-compose*** ###

Antes de nada, asegurarnos que el contenedor del despligue anterior no continua ejecutandose:
```````bash
sudo docker rm -f $(sudo docker ps -a -q)

#Una vez lo hemos eliminado, levantamos el nuevo cluster la misma manera que antes:

sudo docker-compose up
```````
La terminal se va a quedar ocupada por el contenedor de la UI.

Abrimos una nueva terminal y nos volvemos a dirigir a la carpeta de scripts para realizar la siguiente practica.

### ***Practica 3: Interaccion con kafka a través de un productor con Python***

Para hacer esta práctica, debemos antes consultar el archivo **kafka-producers.py**, el cual está en la carpeta: 
```````bash
cd apache-kafka/scripts/kafka-producers-and-consumers
```````
Como se ve en el código del programa, este resuelve los nombres de dominio de nuestros contenedores utilizando DNS (_Domain Name Server_), por lo que debemos actualizar nuestro archivo _/etc/hosts_.
Para ello, ejecutamos:

```````bash
sudo ./update_docker_IP.sh

#Deberiamos obtener un output como:
Updating /etc/hosts file...
172.18.0.6 kafka1
172.18.0.4 kafka2
172.18.0.5 kafka3
172.18.0.3 kafka4
Updated /etc/hosts with Kafka container IP addresses.
```````

Ahora si, podemos ejecutar nuestro programa.
Este **productor** recibe como parámetros el topic donde queremos publicar y el mensaje. Dado que es un entorno de laboratorio, no haría falta crear un topic ya que si este no existe se crea automaticamente. 

Un ejemplo de ejecución es:
```````bash
python3 kafka-producers.py  etsisi "Myfirstmessage"
                            #topic #mensaje

Message delivered to etsisi [0]
                     #topic #partition assigned
```````
Podemos comprobar en nuestra UI (o a través de comandos) el estado de kafka (y publicar nuevos mensajes a modo de test).


### ***Practica 3: Interaccion con kafka a través de un consumidor con Python*** ###

Ahora vamos a crear un **consumidor** que apunte al mismo topic que hemos creado previamente.
```bash
python3 kafka-consumer.py etsisi
````

### ***Practica 3.5 (opcional): Producir mensajes con Java*** ###

En caso de que sobre tiempo, se demostrará la creación de un productor utilizando el cliente Java.
Si se quiere ejecutar por libre, _simplemente_:
```````bash
cd apache-kafka-scripts/kafka-producers-and-consumers/java

sudo ./install-java.sh    # Para instalar java y demás dependencias y además crea el proyecto Maven
                          # es recomendable consultar para luego ejecutar el código

# Ejecutar el programa pasando el mensaje como argumento
#Mirar el archivo KafkaProducerExample.java
mvn exec:java -Dexec.mainClass="com.example.KafkaProducerExample" -Dexec.args="$MESSAGE"

```````

### ***Practica 4: Desplegar kafka utilizando microk8s:*** ###

```````bash
cd apache-kafka/k8s-deployment
```````

En esa carpeta tenemos todos los .yaml que definen la arquitectura a desplegar, junto con dos scripts:
 - **startcluster.sh**: se encarga de levantar en orden los pods
 - **cleanup_kafka.sh**: elimina todos los pods corriendo (**ojo, TODOS**, cuidado si teneis otros pods corriendo).
   
Para levantarlo, _únicamente_ tenemos que ejecutar el codigo:
```bash
sudo ./startcluster.sh

#Una vez levantado, debemos obtener la IP en la cual se ha desplegado kubernetes con:
sudo microk8s kubectl get node -o wide

#Posteriormente, podemos acceder a: http://{k8_ip}:30082 y ver que la UI se encuentra desplegada
```

### ***Practica 5: Producir mensajes en K8*** ###

Ahora, nos dirigimos a: 
```````bash
apache-kafka/scripts/kafka-producers-and-consumers.
```````
Antes de ejecutar el productor sobre el cluster de Kubernetes, debemos actualizar la IP en el encabezado del programa, siendo la siguiente variable: **k8-kafka-producers.py**.
```````python
kubernetes_worker_node_IP = "XXXX.XX.XX.XX"
```````
Lo importante es apreciar las diferencias del despliegue subyacente **(k8s/docker-kubernetes)**.

```bash
python3 k8-kafka-producers.py etsisi_kubernetes "Mi primer mensaje a Kubernetes"
Message delivered to etsisi_kubernetes [0]
```

### ***Practica 6: Extraer datos historicos de un archivo csv y publicarlos en kafka*** ###

Nos dirigimos a: 

```bash
apache-kafka/scripts/ETL_practical_example
```

El primer caso de uso es el programa **tenerife.py**.
Este programa extrae la siguiente informacion del _archivo data/afluencia-de-areas-recreativas-2024.csv_ con el siguiente formato:

| Zona   | Toponimia             | Latitud          | Longitud           | Tipo de Actividad         | Fecha de Inicio       | Fecha de Fin         | Cantidad | Unidad   |
|--------|-----------------------|------------------|--------------------|--------------------------|-----------------------|----------------------|----------|----------|
| Arafo  | ORTICOSA (Camp.)      | 28.38251660028622| -16.446995416088964| Campamento, Aula, Centro | 2024-01-20T11:00:00   | 2024-01-21T16:00:00  | 20       | PERSONA  |


Esta información se procesa en el programa de Python, se agrupa por variables y se publica en Kafka en el topic _TenerifeAreasRecreativas_.
```bash
python3 tenerife.py
```

### ***Practica 7: Producir un stream de mensajes utilizando un historico de movielens*** ###

Para esta practica se va a utilizar un dataset mucho mas grande que el anterior de Tenerife. 
Este dataset se va a ir leyendo poco a poco (dada la magnitud: 100.836 lineas tiene el archivo _apache-kafka/scripts/ETL_practical_example/data/movielensratings.csv_ ) y a su vez paralelamente se van a ir _stremeando_ los mensajes en kafka.
```bash
python3 movies_stream_producer.py
```
Podemos ir viendo como en kafka se van publicando poco a poco más mensajes en un topic recién creado llamado 'ratings'.

### ***Practica 8: Consumir un stream de mensajes y procesar los datos en tiempo real*** ###

Por último, vamos a crear un consumidor del topic recientemente creado (ratings), que procesa el contenido publicado en él y genera nuevos datos:
- low_ratings
- medium_ratings
- high_ratings

Para ejecutarlo _unicamente_ es necesario abrir una consola nueva y:
```bash
cd apache-kafka/scripts/ETL_practical_example
python3 movies_stream_producer.py
```

Ahora podemos comprobar en el frontal web como se van procesando los datos de las valoraciones de las peliculas.

### ***Practica 9: Realizar la practica 7 con el dataset de libros de amazon*** ###

En la carpeta data está el archivo amazon_books.csv con el que, si sobra tiempo, construiremos lo mismo que previamente hemos hecho con movielens.





## ***Docker y MicroK8s Cheatsheet***

### Comandos Básicos de Docker

#### Listar Contenedores
- **Listar contenedores en ejecución:**
  ```bash
  docker ps
  ```

- **Listar todos los contenedores (en ejecución y detenidos):**
  ```bash
  docker ps -a
  ```

#### Inspeccionar Contenedores
- **Obtener información detallada de un contenedor:**
  ```bash
  docker inspect <ID_CONTAINEDOR>
  ```

#### Logs de Contenedores
- **Ver logs de un contenedor:**
  ```bash
  docker logs <ID_CONTAINEDOR>
  ```

#### Ejecutar comandos en Contenedores
- **Ejecutar un comando en un contenedor en ejecución:**
  ```bash
  docker exec -it <ID_CONTAINEDOR> <COMANDO>
  ```

#### Estado del Sistema Docker
- **Mostrar el estado del sistema Docker:**
  ```bash
  docker info
  ```

### ***Comandos Básicos de MicroK8s***

#### Listar Recursos
- **Listar todos los pods:**
  ```bash
  microk8s kubectl get pods
  ```

- **Listar todos los servicios:**
  ```bash
  microk8s kubectl get services
  ```

- **Listar todos los namespaces:**
  ```bash
  microk8s kubectl get namespaces
  ```

### Inspeccionar Recursos
- **Obtener información detallada de un pod:**
  ```bash
  microk8s kubectl describe pod <NOMBRE_POD>
  ```

#### Logs de Pods
- **Ver logs de un pod:**
  ```bash
  microk8s kubectl logs <NOMBRE_POD>
  ```

#### Ejecutar comandos en Pods
- **Ejecutar un comando en un pod en ejecución:**
  ```bash
  microk8s kubectl exec -it <NOMBRE_POD> -- <COMANDO>
  ```

#### Estado del Sistema MicroK8s
- **Mostrar el estado del clúster MicroK8s:**
  ```bash
  microk8s status
  ```

#### Notas Adicionales

- Reemplaza `<ID_CONTAINEDOR>` con el ID o nombre del contenedor correspondiente.
- Reemplaza `<NOMBRE_POD>` con el nombre del pod correspondiente.
- Reemplaza `<COMANDO>` con el comando que deseas ejecutar dentro del contenedor o pod.




## ***Laboratorio Análisis de Datos en Tiempo Real***


Antes de comenzar el laboratorio, es imprescindible tener instalado las tecnologías que se utilizan.
Para ello, se proporciona el script de la carpeta scripts/instalardependencias.sh, el cual se encarga de lo siguiente:

Instalar Docker, docker-compose, microk8s y las dependencias de python:
- kafka-python
- confluent-kafka
- argparse (normalmente debería estar instalado)
    
Podemos comprobar la instalación con:
```
command -v docker-compose  #Por ejemplo
```

La jerarquia de las carpetas es:
```
analisisdedatosentiemporeal
├── README.md
├── capitulos (Aqui se encuentra el texto de la exposicion)
├── .gitignore
├── apache-kafka 
│ ├── docker-compose-deployment
│ │ ├── multiple-broker (carpeta que contiene el docker-compose que despliega una instancia de kafka con 4 brokers)
│ │ └── single-broker (carpeta que contiene el docker-compose que despliega una instancia de kafka con 1 broker)
│ ├── k8-deployment (carpeta que contiene los despliegues necesarios de una instancia de kafka con 4 brokers)
│ ├── scripts
│ │ ├── ETL practical example (carpeta que contiene los ejercicios de extracción y publicación de eventos en kafka)
│ │ └── kafka-producers-and-consumers (carpeta que contiene las primeras publicaciones/consumiciones de eventos con kafka)
│ │ ├── instalardependencias.sh (script que instala las dependencias del laboratorio)

```
### ***Practica 1: Despliegue de kafka con un broker utilizando docker-compose.*** ###

```````
#Desde la raiz de nuestro proyecto Git
cd apache-kafka/docker-compose-deployment/single-broker
sudo docker-compose up 


 ✔ Container zookeeper  Started                                                                                                                                                                                       0.0s 
 ✔ Container kafka      Started                                                                                                                                                                                       0.0s 
 ✔ Container kafka-ui   Started                                                                                                                                                                                       0.0s 

#Para comprobar que todos esta bien:
sudo docker ps

#Si abrimos nuestro explorador en: http://localhost:8080 deberiamos ver nuestra instancia de kafka
```````

### ***Practica 2: Despliegue de kafka con cuatro brokers utilizando docker-compose*** ###

Antes de nada, asegurarnos que el contenedor del despligue anterior no continua ejecutandose:
```````
sudo docker rm -f $(sudo docker ps -a -q)

#Una vez lo hemos eliminado, levantamos el nuevo cluster la misma manera que antes:

sudo docker-compose up
```````
La terminal se va a quedar ocupada por el contenedor de la UI.

Abrimos una nueva terminal y nos volvemos a dirigir a la carpeta de scripts para realizar la siguiente practica.

Practica 3: Interaccion con kafka a través de un productor con Python

Para hacer esta práctica, debemos antes consultar el archivo kafka-producers.py, el cual está en la carpeta: 
cd apache-kafka/scripts/kafka-producers-and-consumers

Este script resuelve los nombres de dominio de nuestros contenedores utilizando DNS, por lo que debemos actualizar nuestro archivo /etc/hosts
Para ello, ejecutamos:

Updating /etc/hosts file...
```````
sudo ./update_docker_IP.sh

#Deberiamos obtener un output como:
172.18.0.6 kafka1
172.18.0.4 kafka2
172.18.0.5 kafka3
172.18.0.3 kafka4
Updated /etc/hosts with Kafka container IP addresses.
```````

Ahora si, podemos ejecutar nuestro programa.
Este productor recibe como parámetros el topic donde queremos publicar y el mensaje. Dado que es un entorno de laboratorio, no haría falta crear un topic ya que si este no existe se crea automaticamente. Un ejemplo de ejecución es:

```````
python3 kafka-producers.py  etsisi "Myfirstmessage"
Message delivered to etsisi [0]
```````
Podemos comprobar en nuestra UI (o a través de comandos) el estado de kafka (y publicar nuevos mensajes a modo de test).


### ***Practica 3: Interaccion con kafka a través de un consumidor con Python*** ###

Ahora vamos a crear un consumidor que apunte al mismo topic que hemos creado previamente.
```````
python3 kafka-consumer.py etsisi
```````

Practica 3.5 (opcional): Producir mensajes con Java
Esta practica se deja a decisión del alumno. El codigo está preparado y automatizado.

### ***Practica 4: Desplegar kafka utilizando microk8s:***###

cd apache-kafka/k8s-deployment

En esa carpeta tenemos todos los .yaml que definen la arquitectura a desplegar, junto con dos scripts:
    1- startcluster.sh: se encarga de levantar en orden los pods
    2- cleanup_kafka.sh: elimina todos los pods corriendo (ojo, TODOS, cuidado si teneis otros pods vuestros corriendo)
Para levantarlo, unicamente tenemos que ejecutar el codigo:
```
sudo ./startcluster.sh

#Una vez levantado, debemos obtener la IP en la cual se ha desplegado kubernetes con:
sudo microk8s kubectl get node -o wide

#Posteriormente, podemos acceder a: http://{k8_ip}:30082 y ver que la UI se encuentra desplegada
```

### ***Practica 5: Producir mensajes en K8***###

Ahora, nos dirigimos a: apache-kafka/scripts/kafka-producers-and-consumers.

Antes de ejecutar el productor sobre el cluster de Kubernetes, debemos actualizar la IP en el encabezado del programa: k8-kafka-producers.py.

Lo importante es apreciar las diferencias del despliegue subyacente (docker-kubernetes).

```
python3 k8-kafka-producers.py etsisi_kubernetes "Mi primer mensaje a Kubernetes"
Message delivered to etsisi_kubernetes [0]
```

Practica 6: Extraer datos historicos de un archivo csv y publicarlos en kafka

Nos dirigimos a: apache-kafka/scripts/ETL_practical_example

El primer caso de uso es el programa tenerife.py.

Este programa extrae la siguiente informacion del archivo data/afluencia-de-areas-recreativas-2024.csv con el siguiente formato:

| Zona   | Toponimia             | Latitud          | Longitud           | Tipo de Actividad         | Fecha de Inicio       | Fecha de Fin         | Cantidad | Unidad   |
|--------|-----------------------|------------------|--------------------|--------------------------|-----------------------|----------------------|----------|----------|
| Arafo  | ORTICOSA (Camp.)      | 28.38251660028622| -16.446995416088964| Campamento, Aula, Centro | 2024-01-20T11:00:00   | 2024-01-21T16:00:00  | 20       | PERSONA  |


Esta información se procesa en Python y se publica en Kafka en el topic 'TenerifeAreasRecreativas'.
```
python3 tenerife.py
```

### ***Practica 6: Producir un stream de mensajes utilizando un historico de movielens***###

Para esta practica se va a utilizar un dataset mucho mas grande que el anterior de Tenerife. Este dataset se va a ir leyendo poco a poco y a su vez paralelamente se van a ir publicando los mensajes en kafka.
```
python3 movies_stream_producer.py
```
Podemos ir viendo como en kafka se van publicando poco a poco más mensajes en un topic recién creado llamado 'ratings'.

### ***Practica 7: Consumir un stream de mensajes y transformarlo con Kafka-Streams***###

Por último, vamos a crear un consumidor del topic recientemente creado (ratings), que analiza el contenido publicado y categoriza cada pelicula como:
- low_ratings
- medium_ratings
- high_ratings

Para ejecutarlo unicamente en una consola nueva:
```
python3 movies_stream_producer.py
```

Ahora podemos comprobar en la UI como se van procesando los datos de las valoraciones de las peliculas.

### ***Practica 8: Realizar la practica 7 con el dataset de libros de amazon***###

En la carpeta data está el archivo amazon_books.csv con el que, si sobra tiempo, construiremos lo mismo que previamente.




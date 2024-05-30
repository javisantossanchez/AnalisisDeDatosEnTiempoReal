El contenido del script de la carpeta scripts/instalardependencias.sh se encarga de lo siguiente:

Instalar Docker, docker-compose, microk8s y las dependencias de python:
    - kafka-python
    - confluent-kafka
    - argparse (normalmente debería estar instalado)

```````

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
│ │ └── utils.py
│ └── module2
│ ├── init.py
│ └── helpers.py
├── tests
│ ├── init.py
│ ├── test_main.py
│ └── module1
│ ├── init.py
```
Practica 1: Despliegue de kafka con un broker utilizando docker-compose

```````
#Desde la raiz de nuestro proyecto Git
cd apache-kafka/docker-compose-deployment/single-broker
sudo docker-compose up 


 ✔ Container zookeeper  Started                                                                                                                                                                                       0.0s 
 ✔ Container kafka      Started                                                                                                                                                                                       0.0s 
 ✔ Container kafka-ui   Started                                                                                                                                                                                       0.0s 

#Para comprobar que todos esta bien:
sudo docker ps

#Si abrimos nuestro explorador en: http://localhost:8080 deberiamos ver nuestro cluster de kafka
```````

Practica 1: Despliegue de kafka con un broker utilizando docker-compose

Antes de nada, asegurarnos que el contenedor del despligue anterior no continua ejecutandose:
```````
sudo docker rm -f $(sudo docker ps -a -q)

#Una vez lo hemos eliminado, levantamos el nuevo cluster la misma manera que antes:

sudo docker-compose up
```````
La terminal se va a quedar ocupada por el contenedor de la UI
Abrimos una nueva terminal y nos volvemos a dirigir a la carpeta de scripts para realizar la siguiente practica




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


Practica 3: Interaccion con kafka a través de un consumidor con Python
Ahora vamos a crear un consumidor que apunte al mismo topic que hemos creado previamente.
```````
python3 kafka-consumer.py etsisi
```````

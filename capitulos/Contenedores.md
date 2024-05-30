## ***Virtualización y Contenedores***

La virtualización se puede definir como: "La simulación de un entorno informático cuyo comportamiento sea idéntico al de una máquina física". 
Gracias a esta tecnología es posible poder alojar un diverso número de máquinas virtuales que comparten un mismo alojamiento físico (es decir, ram, procesador, gpu,etc).

Antes de la _contenerización_, o incluso antes de la virtualización, sólo existía un tipo de máquina, que suele denominarse **sistema baremetal**.
En un sistema baremetal, solemos tener una máquina anfitriona en la que tenemos que instalar el sistema operativo, los binarios, las bibliotecas y las dependencias, y luego ejecutar las aplicaciones encima.
Entre 2000 y 2005, surgió un nuevo concepto de máquinas virtuales para resolver algunos de estos problemas.
En un sistema de **máquina virtual**, el sistema intenta dividir los recursos del sistema en varias partes y utilizarlas para ejecutar cualquier aplicación de forma independiente.
Para llevar el concepto de máquinas virtuales al siguiente nivel, surgió el concepto de contenedores.
La principal diferencia entre una máquina virtual y un contenedor es que una máquina virtual tiene su propio **kernel** (núcleo), mientras que un contenedor comparte el núcleo de la máquina anfitriona.

Éstas máquinas permiten ejecutar diferentes sistemas operativos a la vez gracias a la existencia de un hipervisor.
En la siguiente imagen se puede apreciar la diferencia existente entre los hipervisores tipo 1 y tipo 2:
- **Tipo 1:** se instalan directamente encima del hardware (_en el propio hierro, también conocido como baremetal_) siendo éste el _Sistema Operativo_ que interactua directamente con los dispositivos hardware. VMWare utiliza está técnica con ESXI.
- **Tipo 2:** se instala un Sistema Operativo tradicional (normalmente sistemas Linux RHEL, aunque hay de todo) y en él se instala el software capaz de crear la capa de hipervisor que permite la virtualización de sistemas.

<p align="center">
  <img src="https://github.com/javisantossanchez/GrandesVolumenesDeDatos/assets/47392657/5f795e11-0a98-4f83-b6e5-5d3b84b81635)" style="width:75%" \>
</p>

### ***Docker***
Como una evolución de este concepto encontramos **Docker**: una plataforma de código abierto cuyo objetivo es el desarrollo y producción de aplicaciones de manera rápida e independiente de la infraestructura subyacente. Esta última cualidad se obtiene mediante el uso de máquinas virtuales ligeras llamadas _contenedores_.

Los contenedores poseen las siguientes características clave:
- Aislamiento: Pueden operar como entornos aislados del resto de conten dores y de la propia máquina anfitrión que los aloja.
- Portabilidad: A la hora de ejecutarse, cada contenedor carga una imagen la cual que contiene toda la información necesaria para su ejecución: sistema operativo, variables de entorno, sistema de archivos, aplicaciones, etc.Esta implementación permite empaquetar aplicaciones en estas imágenes, hablitando un despliegue rápido, distribuido y centrado en microservicios, diferenciándose frente a aplicaciones más tradicionales donde todos los servicios son ejecutados dentro de una misma máquina.

### ***Docker-compose***
Junto a Docker, encontramos también el proyecto complementario "docker-compose", una herramienta que permite definir y desplegar multitud de estoscontenedores a través de un (o varios) fichero .yam de configuración que poseatodos los parámetros necesarios para desplegar una serie de servicios que se ajusten a una definición previa sin necesidad de hacer uso de numerosas máquinas físicas.
Los contenedores de Docker permiten el aislamiento de los miembros y la creación de una red propia dedicando poca memoria y utilizando el menor almacenamiento posible gracias a la ligereza de las imágenes utilizadas, facilitandoel aprovisionamiento de máquinas y la simulación de un entorno real.

<p align="center">
![docker-compose](https://github.com/javisantossanchez/GrandesVolumenesDeDatos/assets/47392657/8d9ccd6b-37aa-4ae5-88bc-e065eef5dee7)
<p align="center">

Este archivo nos permite definir de qué manera queremos inicializar nuestro contenedor:
- Nombre la maquina
- Imagen a utilizar
- Puertos físicos del host que emparejar con el contenedor
- Variables de entorno
- Preinstalación de software necesario para la aplicación
- Definición de volúmenes persistentes de almacenamiento compartidos con el host
- Definir una red de comunicación entre los contenedores y el host


*Ejemplo de simple Dockerfile para comentar rapidito
*Ejemplo de un docker-compose para comentar rapidito

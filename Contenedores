La virtualización se puede definir como: "La simulación de un entorno infor-
mático cuyo comportamiento sea idéntico al de una máquina física". Gracias a
esta tecnología es posible poder alojar un diverso número de máquinas virtua-
les que comparten un mismo alojamiento físico (es decir, ram, procesador, gpu,
etc).

Antes de la contenerización, o incluso antes de la virtualización, sólo existía un tipo de máquina, que suele denominarse sistema bare-metal.
En un sistema bare-metal, solemos tener una máquina anfitriona en la que tenemos que instalar el sistema operativo, los binarios, las bibliotecas y las dependencias, y luego ejecutar las aplicaciones encima.
Entre 2000 y 2005, surgió un nuevo concepto de máquinas virtuales para resolver algunos de estos problemas.
En un sistema de máquina virtual, el sistema intenta dividir los recursos del sistema en varias partes y utilizarlas para ejecutar cualquier aplicación de forma independiente.
Para llevar el concepto de máquinas virtuales al siguiente nivel, surgió el concepto de contenedores.
La principal diferencia entre una máquina virtual y un contenedor es que una máquina virtual tiene su propio núcleo, mientras que un contenedor comparte el núcleo de la máquina anfitriona.

Traducción realizada con la versión gratuita del traductor DeepL.com

Éstas máquinas permiten ejecutar diferentes sistemas operativos gracias a la
existencia de un hipervisor.

*IMAGEN DE UN HIPERVISOR*


Como una evolución de este concepto encontramos Docker: una plataforma
de código abierto cuyo objetivo es el desarrollo y producción de aplicaciones
de manera rápida e independiente de la infraestructura subyacente. Esta últi-
ma cualidad se obtiene mediante el uso de máquinas virtuales ligeras llamadas
contenedores.

Los contenedores poseen las siguientes características clave:
- Aislamiento: Pueden operar como entornos aislados del resto de conten-
dores y de la propia máquina anfitrión que los aloja.
- Portabilidad: A la hora de ejecutarse, cada contenedor carga una imagen la
cual que contiene toda la información necesaria para su ejecución: sistema
operativo, variables de entorno, sistema de archivos, aplicaciones, etc.
Esta implementación permite empaquetar aplicaciones en estas imágenes, ha-
blitando un despliegue rápido, distribuido y centrado en microservicios, diferen-
ciándose frente a aplicaciones más tradicionales donde todos los servicios son
ejecutados dentro de una misma máquina.

Junto a Docker, encontramos también el proyecto complementario "docker-
compose", una herramienta que permite definir y desplegar multitud de estos
contenedores a través de un (o varios) fichero .yam de configuración que posea
todos los parámetros necesarios para desplegar una serie de servicios que se ajus-
ten a una definición previa sin necesidad de hacer uso de numerosas máquinas
físicas.
Los contenedores de Docker permiten el aislamiento de los miembros y la
creación de una red propia dedicando poca memoria y utilizando el menor al-
macenamiento posible gracias a la ligereza de las imágenes utilizadas, facilitando
el aprovisionamiento de máquinas y la simulación de un entorno real.
*Imagen de Docker-compose*

*Ejemplo de simple Dockerfile para comentar rapidito
*Ejemplo de un docker-compose para comentar rapidito

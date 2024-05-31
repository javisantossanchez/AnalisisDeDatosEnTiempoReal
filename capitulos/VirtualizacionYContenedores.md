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
  <img src="https://github.com/javisantossanchez/GrandesVolumenesDeDatos/assets/47392657/5f795e11-0a98-4f83-b6e5-5d3b84b81635" style="width:75%" \>
</p>
<p align="center">
  <em><strong>Hipervisores:</strong></em> Diferencias entre Hipervisores tipo 1 y tipo 2.
</p>


### ***Docker***

Como una evolución de este concepto encontramos **Docker**: una plataforma de código abierto cuyo objetivo es el desarrollo y producción de aplicaciones de manera rápida e independiente de la infraestructura subyacente. Esta última cualidad se obtiene mediante el uso de máquinas virtuales ligeras llamadas _contenedores_.

Los contenedores poseen las siguientes características clave:
- Aislamiento: Pueden operar como entornos aislados del resto de conten dores y de la propia máquina anfitrión que los aloja.
- Portabilidad: A la hora de ejecutarse, cada contenedor carga una imagen la cual que contiene toda la información necesaria para su ejecución: sistema operativo, variables de entorno, sistema de archivos, aplicaciones, etc.Esta implementación permite empaquetar aplicaciones en estas imágenes, hablitando un despliegue rápido, distribuido y centrado en microservicios, diferenciándose frente a aplicaciones más tradicionales donde todos los servicios son ejecutados dentro de una misma máquina.

### ***Docker-compose***
Junto a Docker, encontramos también el proyecto complementario **docker-compose**, una herramienta que permite definir y desplegar multitud de estoscontenedores a través de un (o varios) fichero .yam de configuración que poseatodos los parámetros necesarios para desplegar una serie de servicios que se ajusten a una definición previa sin necesidad de hacer uso de numerosas máquinas físicas.
Los contenedores de Docker permiten el aislamiento de los miembros y la creación de una red propia dedicando poca memoria y utilizando el menor almacenamiento posible gracias a la ligereza de las imágenes utilizadas, facilitandoel aprovisionamiento de máquinas y la simulación de un entorno real.

<p align="center">
<img src="https://github.com/javisantossanchez/GrandesVolumenesDeDatos/assets/47392657/8d9ccd6b-37aa-4ae5-88bc-e065eef5dee7" \>
<p align="center">
<p align="center">
  <em><strong>docker-compose:</strong></em> Representación visual funcionamiento docker-compose.
</p>

Este archivo nos permite definir de qué manera queremos inicializar nuestro contenedor:
- Nombre la maquina
- Imagen a utilizar
- Puertos físicos del host que emparejar con el contenedor
- Variables de entorno
- Preinstalación de software necesario para la aplicación
- Definición de volúmenes persistentes de almacenamiento compartidos con el host
- Definir una red de comunicación entre los contenedores y el host


### Kubernetes y gestión de contenedores

Los contenedores son similares a las máquinas virtuales (VM), pero tienen propiedades de aislamiento relajadas para compartir el Sistema Operativo (OS) entre las aplicaciones. Por lo tanto, los contenedores se consideran ligeros. Al igual que una VM, un contenedor tiene su propio sistema de archivos, comparte CPU, memoria, espacio de procesos, y más. Al estar desacoplados de la infraestructura subyacente, son portátiles a través de nubes y distribuciones de OS.

Los contenedores se han vuelto populares porque proporcionan beneficios adicionales, tales como:

- **Creación y despliegue ágil de aplicaciones:** mayor facilidad y eficiencia en la creación de imágenes de contenedores en comparación con el uso de imágenes de VM.
- **Desarrollo, integración y despliegue continuo:** permite una construcción y despliegue de imágenes de contenedores fiable y frecuente con retrocesos rápidos y eficientes (debido a la inmutabilidad de las imágenes).
- **Separación de preocupaciones entre desarrollo y operaciones:** creación de imágenes de contenedores de aplicaciones en el momento de la construcción/lanzamiento en lugar del momento del despliegue, desacoplando así las aplicaciones de la infraestructura.
- **Observabilidad:** no solo presenta información y métricas a nivel de OS, sino también el estado de la aplicación y otras señales.
- **Consistencia ambiental en desarrollo, pruebas y producción:** funciona igual en una laptop que en la nube.
- **Portabilidad entre nubes y distribuciones de OS:** funciona en Ubuntu, RHEL, CoreOS, en instalaciones locales, en las principales nubes públicas y en cualquier otro lugar.
- **Gestión centrada en la aplicación:** eleva el nivel de abstracción desde ejecutar un OS en hardware virtual a ejecutar una aplicación en un OS usando recursos lógicos.
- **Microservicios desacoplados, distribuidos, elásticos y liberados:** las aplicaciones se dividen en piezas más pequeñas e independientes que pueden desplegarse y gestionarse dinámicamente, no una pila monolítica ejecutándose en una gran máquina de un solo propósito.
- **Aislamiento de recursos:** rendimiento de la aplicación predecible.
- **Utilización de recursos:** alta eficiencia y densidad.

### Por qué necesitas Kubernetes

Kubernetes proporciona un marco para ejecutar sistemas distribuidos de manera resiliente. Se encarga de la escalabilidad y la tolerancia a fallos de tu aplicación, proporciona patrones de despliegue y más.

Kubernetes ofrece:

- **Descubrimiento de servicios y balanceo de carga:** Kubernetes puede exponer un contenedor utilizando el nombre DNS o su propia dirección IP. Si el tráfico hacia un contenedor es alto, Kubernetes puede balancear y distribuir el tráfico de red para que el despliegue sea estable.
- **Orquestación de almacenamiento:** Kubernetes te permite montar automáticamente un sistema de almacenamiento de tu elección, como almacenamientos locales, proveedores de nube pública, y más.
- **Despliegues y retrocesos automatizados:** puedes describir el estado deseado para tus contenedores desplegados usando Kubernetes, y este puede cambiar el estado actual al estado deseado a una tasa controlada. Por ejemplo, puedes automatizar Kubernetes para crear nuevos contenedores para tu despliegue, eliminar contenedores existentes y adoptar todos sus recursos al nuevo contenedor.
- **Empaquetado automático:** proporcionas a Kubernetes un clúster de nodos que puede usar para ejecutar tareas contenedorizadas. Le indicas a Kubernetes cuánta CPU y memoria (RAM) necesita cada contenedor. Kubernetes puede acomodar contenedores en tus nodos para hacer el mejor uso de tus recursos.
- **Autocuración:** Kubernetes reinicia contenedores que fallan, reemplaza contenedores, elimina contenedores que no responden a tu chequeo de salud definido por el usuario, y no los anuncia a los clientes hasta que estén listos para servir.
- **Gestión de secretos y configuraciones:** Kubernetes te permite almacenar y gestionar información sensible, como contraseñas, tokens OAuth y claves SSH. Puedes desplegar y actualizar secretos y configuraciones de aplicaciones sin reconstruir tus imágenes de contenedor, y sin exponer secretos en tu configuración de pila.
- **Ejecución por lotes:** además de servicios, Kubernetes puede gestionar tus cargas de trabajo por lotes y CI, reemplazando contenedores que fallen, si así lo deseas.
- **Escalado horizontal:** escala tu aplicación hacia arriba y hacia abajo con un simple comando, con una interfaz de usuario, o automáticamente basado en el uso de CPU.
- **IPv4/IPv6 dual-stack:** asignación de direcciones IPv4 e IPv6 a Pods y Servicios.
- **Diseñado para la extensibilidad:** añade características a tu clúster de Kubernetes sin cambiar el código fuente upstream.

<p align="center">
<img src="https://github.com/javisantossanchez/AnalisisDeDatosEnTiempoReal/assets/47392657/db2e8cf4-91d3-4638-8e6f-119e2efd19ca" \>
<p align="center">
<p align="center">
  <em><strong>Kubernetes:</strong></em> Representación visual arquitectura de K8s.
</p>

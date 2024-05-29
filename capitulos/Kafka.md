Kafka combina tres capacidades clave para que puedas implementar tus casos de uso de transmisión de eventos de extremo a extremo con una única solución probada en batalla:

1. Publicar (escribir) y suscribirse a (leer) flujos de eventos, incluyendo la importación/exportación continua de tus datos desde otros sistemas.
2. Almacenar flujos de eventos de manera duradera y confiable durante el tiempo que desees.
3. Procesar flujos de eventos a medida que ocurren o de manera retrospectiva.

Y toda esta funcionalidad se proporciona de manera distribuida, altamente escalable, elástica, tolerante a fallos y segura. Kafka se puede desplegar en hardware físico, máquinas virtuales y contenedores, tanto en instalaciones locales como en la nube. Puedes elegir entre gestionar tus entornos Kafka por ti mismo o utilizar servicios totalmente gestionados ofrecidos por una variedad de proveedores.

## ¿Cómo funciona Kafka en pocas palabras?

Kafka es un sistema distribuido compuesto por servidores y clientes que se comunican a través de un protocolo de red TCP de alto rendimiento. Puede desplegarse en hardware físico, máquinas virtuales y contenedores en entornos locales y en la nube.

### Servidores:

Kafka se ejecuta como un clúster de uno o más servidores que pueden abarcar múltiples centros de datos o regiones de la nube. Algunos de estos servidores forman la capa de almacenamiento, llamados brokers. Otros servidores ejecutan Kafka Connect para importar y exportar datos continuamente como flujos de eventos para integrar Kafka con tus sistemas existentes, como bases de datos relacionales y otros clústeres de Kafka. Para permitirte implementar casos de uso críticos, un clúster de Kafka es altamente escalable y tolerante a fallos: si alguno de sus servidores falla, los otros servidores asumirán su trabajo para garantizar operaciones continuas sin pérdida de datos.

### Clientes:

Permiten escribir aplicaciones distribuidas y microservicios que leen, escriben y procesan flujos de eventos en paralelo, a escala y de manera tolerante a fallos, incluso en caso de problemas de red o fallos de máquinas. Kafka incluye algunos de estos clientes, que se complementan con docenas de clientes proporcionados por la comunidad de Kafka: hay clientes disponibles para Java y Scala, incluyendo la biblioteca de alto nivel Kafka Streams, para Go, Python, C/C++ y muchos otros lenguajes de programación, así como APIs REST.

## Conceptos y Terminología Principales

Un evento registra el hecho de que "algo sucedió" en el mundo o en tu negocio. También se llama registro o mensaje en la documentación. Cuando lees o escribes datos en Kafka, lo haces en forma de eventos. Conceptualmente, un evento tiene una clave, un valor, una marca de tiempo y metadatos opcionales. Aquí hay un ejemplo de evento:

- Clave del evento: "Alice"
- Valor del evento: "Hizo un pago de $200 a Bob"
- Marca de tiempo del evento: "25 de junio de 2020 a las 2:06 p.m."

Los productores son aquellas aplicaciones cliente que publican (escriben) eventos en Kafka, y los consumidores son aquellos que se suscriben a (leen y procesan) estos eventos. En Kafka, los productores y consumidores están completamente desacoplados y son agnósticos entre sí, lo cual es un elemento clave de diseño para lograr la alta escalabilidad por la que Kafka es conocido. Por ejemplo, los productores nunca necesitan esperar a los consumidores. Kafka ofrece varias garantías, como la capacidad de procesar eventos exactamente una vez.

Los eventos se organizan y almacenan de manera duradera en topics. De manera muy simplificada, un tema es similar a una carpeta en un sistema de archivos, y los eventos son los archivos en esa carpeta. Un nombre de tema de ejemplo podría ser "pagos". Los topics en Kafka son siempre de múltiples productores y múltiples suscriptores: un tema puede tener cero, uno o muchos productores que escriben eventos en él, así como cero, uno o muchos consumidores que se suscriben a estos eventos. Los eventos en un tema pueden leerse tantas veces como sea necesario: a diferencia de los sistemas de mensajería tradicionales, los eventos no se eliminan después del consumo. En su lugar, defines cuánto tiempo Kafka debe retener tus eventos a través de una configuración por tema, después de lo cual los eventos antiguos serán descartados. El rendimiento de Kafka es efectivamente constante con respecto al tamaño de los datos, por lo que almacenar datos durante mucho tiempo es perfectamente aceptable.

Los topics están particionados, lo que significa que un tema se distribuye en varios "cubos" ubicados en diferentes brokers de Kafka. Esta distribución de tus datos es muy importante para la escalabilidad porque permite que las aplicaciones cliente lean y escriban datos desde/hacia muchos brokers al mismo tiempo. Cuando se publica un nuevo evento en un tema, en realidad se agrega a una de las particiones del tema. Los eventos con la misma clave de evento (por ejemplo, un ID de cliente o de vehículo) se escriben en la misma partición, y Kafka garantiza que cualquier consumidor de una partición de tema dada siempre leerá los eventos de esa partición en exactamente el mismo orden en que fueron escritos.


![topic_partitioned](https://github.com/javisantossanchez/BigDataEnTiempoReal/assets/47392657/c0fa3739-ee55-42c1-ad14-9c16fbfcf7ad)

Para hacer que tus datos sean tolerantes a fallos y altamente disponibles, cada tema puede replicarse, incluso a través de regiones geográficas o centros de datos, de modo que siempre haya múltiples brokers que tengan una copia de los datos en caso de que algo salga mal, necesites hacer mantenimiento en los brokers, etc. Una configuración común en producción es un factor de replicación de 3, es decir, siempre habrá tres copias de tus datos. Esta replicación se realiza a nivel de particiones de tema.

A continuación se presenta una arquitectura Lambda basada en Kafka para la ingestión de datos en al capa de velocidad implementada con Flink mientras soporta streaming de datos e integrando la capa histórica con Spark.
![KappaArchitectureWithKafka](https://github.com/javisantossanchez/BigDataEnTiempoReal/assets/47392657/86380f8f-e2ed-4dd8-aec3-40d21c20c63b)


## Casos de Uso

### Mensajería

Kafka funciona bien como un reemplazo para un broker de mensajes más tradicional. Los brokers de mensajes se utilizan por diversas razones (para desacoplar el procesamiento de los productores de datos, para amortiguar los mensajes no procesados, etc.). En comparación con la mayoría de los sistemas de mensajería, Kafka tiene un mejor rendimiento, particionamiento incorporado, replicación y tolerancia a fallos, lo que lo convierte en una buena solución para aplicaciones de procesamiento de mensajes a gran escala. Actualmente, los usos de mensajería suelen tener un rendimiento relativamente bajo, pero pueden requerir baja latencia de extremo a extremo y a menudo dependen de las sólidas garantías de durabilidad que proporciona Kafka.

En este dominio, Kafka es comparable a sistemas de mensajería tradicionales como ActiveMQ o RabbitMQ.

### Seguimiento de Actividad en Sitios Web

El caso de uso original para Kafka era poder reconstruir un pipeline de seguimiento de actividad de usuarios como un conjunto de feeds de publicación-suscripción en tiempo real. Esto significa que la actividad del sitio (vistas de página, búsquedas u otras acciones que los usuarios puedan realizar) se publica en topics centrales con un tema por tipo de actividad. Estos feeds están disponibles para suscripción para una variedad de casos de uso, incluyendo procesamiento en tiempo real, monitoreo en tiempo real y carga en Hadoop o sistemas de almacenamiento de datos offline para procesamiento y generación de informes offline. El seguimiento de actividad suele tener un volumen muy alto, ya que se generan muchos mensajes de actividad por cada vista de página del usuario.

### Métricas

Kafka se utiliza a menudo para datos de monitoreo operativo. Esto implica la agregación de estadísticas de aplicaciones distribuidas para producir feeds centralizados de datos operativos.

### Agregación de Logs

Muchas personas utilizan Kafka como un reemplazo para una solución de agregación de logs. La agregación de logs normalmente recopila archivos de log físicos de los servidores y los coloca en un lugar central (un servidor de archivos o HDFS quizás) para su procesamiento. Kafka abstrae los detalles de los archivos y ofrece una abstracción más limpia de datos de logs o eventos como un flujo de mensajes. Esto permite un procesamiento de menor latencia y un soporte más fácil para múltiples fuentes de datos y consumo de datos distribuidos. En comparación con sistemas centrados en logs como Scribe o Flume, Kafka ofrece un rendimiento igualmente bueno, garantías de durabilidad más fuertes debido a la replicación y una latencia de extremo a extremo mucho menor.

### Procesamiento de Flujos

Muchos usuarios de Kafka procesan datos en pipelines de procesamiento que consisten en múltiples etapas, donde los datos de entrada en bruto se consumen de los topics de Kafka y luego se agregan, enriquecen o transforman de alguna otra manera en nuevos topics para su posterior consumo o procesamiento posterior. Por ejemplo, un pipeline de procesamiento para recomendar artículos de noticias podría rastrear el contenido de artículos de feeds RSS y publicarlo en un tema de "artículos"; un procesamiento adicional podría normalizar o eliminar duplicados de este contenido y publicar el contenido de artículos depurado en un nuevo tema; una etapa final de procesamiento podría intentar recomendar este contenido a los usuarios. Tales pipelines de procesamiento crean gráficos de flujos de datos en tiempo real basados en los topics individuales. A partir de la versión 0.10.0.0, una biblioteca de procesamiento de flujos liviana pero poderosa llamada Kafka Streams está disponible en Apache Kafka para realizar dicho procesamiento de datos como se describe arriba. Aparte de Kafka Streams, otras herramientas de procesamiento de flujos de código abierto incluyen Apache Storm y Apache Samza.

<p align="center">
    <img src="https://github.com/javisantossanchez/BigDataEnTiempoReal/assets/47392657/014508da-e8a5-4365-b38a-d9a1123d40cb" alt="Datos de un Broker"/>
</p>

### Kafka Streams

  
La capa de mensajería de Kafka particiona los datos para almacenarlos y transportarlos. Kafka Streams particiona los datos para procesarlos. En ambos casos, esta partición es lo que permite la localización de datos, elasticidad, escalabilidad, alto rendimiento y tolerancia a fallos. Kafka Streams utiliza los conceptos de particiones y tareas como unidades lógicas de su modelo de paralelismo basado en particiones de topics de Kafka. Existen vínculos estrechos entre Kafka Streams y Kafka en el contexto del paralelismo:

- Cada partición de flujo es una secuencia totalmente ordenada de registros de datos y se mapea a una partición de tema de Kafka.
- Un registro de datos en el flujo se mapea a un mensaje de Kafka de ese tema.
- Las claves de los registros de datos determinan la partición de datos tanto en Kafka como en Kafka Streams, es decir, cómo se enrutan los datos a particiones específicas dentro de los topics.

<p align="center">
    <img src="https://github.com/javisantossanchez/GrandesVolumenesDeDatos/assets/47392657/e7e03b7f-1a0b-4a52-affe-2273d0ea19e9" alt="Kafka Streams"/>
</p>

La topología del procesador de una aplicación se escala dividiéndola en múltiples tareas. Más específicamente, Kafka Streams crea un número fijo de tareas basado en las particiones del flujo de entrada para la aplicación, con cada tarea asignada a una lista de particiones de los flujos de entrada (es decir, topics de Kafka). La asignación de particiones a tareas nunca cambia, de modo que cada tarea es una unidad fija de paralelismo de la aplicación. Las tareas pueden entonces instanciar su propia topología de procesador basada en las particiones asignadas; también mantienen un búfer para cada una de sus particiones asignadas y procesan mensajes uno a la vez desde estos búferes de registros. Como resultado, las tareas de flujo pueden procesarse de manera independiente y en paralelo sin intervención manual.

De manera ligeramente simplificada, el paralelismo máximo al que tu aplicación puede ejecutarse está limitado por el número máximo de tareas de flujo, que a su vez está determinado por el número máximo de particiones de los topics de entrada de los que la aplicación está leyendo. Por ejemplo, si tu tema de entrada tiene 5 particiones, entonces puedes ejecutar hasta 5 instancias de la aplicación. Estas instancias procesarán de manera colaborativa los datos del tema. Si ejecutas un número mayor de instancias de la aplicación que particiones del tema de entrada, las instancias "excedentes" se iniciarán pero permanecerán inactivas; sin embargo, si una de las instancias ocupadas falla, una de las instancias inactivas retomará el trabajo de la anterior.

Es importante entender que Kafka Streams no es un gestor de recursos, sino una biblioteca que "se ejecuta" en cualquier lugar donde se ejecute su aplicación de procesamiento de flujos. Múltiples instancias de la aplicación se ejecutan ya sea en la misma máquina o distribuidas en múltiples máquinas y las tareas pueden distribuirse automáticamente por la biblioteca a esas instancias de la aplicación en ejecución. La asignación de particiones a tareas nunca cambia; si una instancia de la aplicación falla, todas sus tareas asignadas se reiniciarán automáticamente en otras instancias y continuarán consumiendo de las mismas particiones de flujo.


### Kafka Connect



## ***Apache Kafka***

### ***¿Cómo funciona Kafka en pocas palabras?***

Kafka es un sistema distribuido compuesto por servidores y clientes que se comunican a través de un protocolo de red TCP de alto rendimiento. Puede desplegarse en hardware físico, máquinas virtuales y contenedores en entornos locales y en la nube.

- #### Servidores:
Kafka se ejecuta como un clúster de uno o más servidores que pueden abarcar múltiples centros de datos o regiones de la nube. Algunos de estos servidores forman la capa de almacenamiento, llamados **brokers**. Otros servidores ejecutan _Kafka Connect_ para importar y exportar datos continuamente como flujos de eventos para integrar Kafka con los sistemas existentes, como bases de datos relacionales u otros clústeres de Kafka.
- #### Clientes:
Permiten escribir aplicaciones distribuidas y microservicios que leen, escriben y procesan flujos de eventos en paralelo (gracias que kafka está programado en Scala, lenguaje dedicado al paralelismo), a escala y de manera tolerante a fallos, incluso en caso de problemas de red o fallos de máquinas. Kafka incluye algunos de estos clientes, que se complementan con docenas de clientes proporcionados por la comunidad de Kafka: clientes disponibles para Java y Scala, incluyendo la biblioteca de alto nivel Kafka Streams, para Go, Python, C/C++ y muchos otros lenguajes de programación, así como APIs REST.
Kafka combina tres capacidades clave los casos de uso de transmisión de eventos de extremo a extremo:

- Publicar (escribir) y suscribirse a (leer) flujos de eventos, incluyendo la importación/exportación continua de los datos desde otros sistemas.
- Almacena flujos de eventos de manera duradera y confiable durante el tiempo que se desee.
- Procesa flujos de eventos a medida que ocurren o de manera retrospectiva.

Y toda esta funcionalidad se proporciona de manera distribuida, altamente escalable, elástica, tolerante a fallos y segura. Kafka se puede desplegar en hardware físico, máquinas virtuales y contenedores, tanto en instalaciones locales como en la nube. Puedes elegir entre gestionar tus entornos Kafka por ti mismo o utilizar servicios totalmente gestionados ofrecidos por una variedad de proveedores.

### ***Conceptos y Terminología Principales***

Un evento registra el hecho de que "algo sucedió" en el mundo o en tu negocio. También se llama registro o mensaje en la documentación. Cuando se lee o se escribe datos en Kafka, se hace en forma de eventos. Conceptualmente, un evento tiene una clave, un valor, una marca de tiempo y metadatos opcionales. Un ejemplo de evento:

- Clave del evento: "Javier"
- Valor del evento: "Hizo un pago de $200 a Daniel"
- Marca de tiempo del evento: "25 de junio de 2020 a las 2:06 p.m."

Los productores son aquellas aplicaciones cliente que publican (escriben) eventos en Kafka, y los consumidores son aquellos que se suscriben a (leen y procesan) estos eventos. En Kafka, los productores y consumidores están completamente desacoplados y son agnósticos entre sí, lo cual es un elemento clave de diseño para lograr la alta escalabilidad por la que Kafka es conocido. Los productores nunca necesitan esperar a los consumidores. Kafka ofrece varias garantías, como la capacidad de procesar todos los eventos exactamente una vez.

Los eventos se organizan y almacenan de manera duradera en **topics**. De manera muy simplificada, un **tema** (o topic) es similar a una carpeta en un sistema de archivos, y los eventos son los archivos en esa carpeta. Un nombre de tema de ejemplo podría ser "pagos". Los topics en Kafka son siempre de múltiples productores y múltiples suscriptores: un tema puede tener cero, uno o muchos productores que escriben eventos en él, así como cero, uno o muchos consumidores que se suscriben a estos eventos. Los eventos en un tema pueden leerse tantas veces como sea necesario: a diferencia de los sistemas de mensajería tradicionales, los eventos no se eliminan después del consumo. En su lugar, defines cuánto tiempo Kafka debe retener tus eventos a través de una configuración por tema, después de lo cual los eventos antiguos serán descartados. El rendimiento de Kafka es efectivamente constante con respecto al tamaño de los datos, por lo que almacenar datos durante mucho tiempo es perfectamente aceptable.

Los topics están particionados, lo que significa que un tema se distribuye en varios "cubos" ubicados en diferentes brokers de Kafka. Esta distribución de tus datos es muy importante para la escalabilidad porque permite que las aplicaciones cliente lean y escriban datos desde/hacia muchos brokers al mismo tiempo. Cuando se publica un nuevo evento en un tema, en realidad se agrega a una de las particiones del tema. Los eventos con la misma clave de evento (por ejemplo, un ID de cliente o de vehículo) se escriben en la misma partición, y Kafka garantiza que cualquier consumidor de una partición de tema dada siempre leerá los eventos de esa partición en exactamente el mismo orden en que fueron escritos.

<p align="center">
  <img src="https://github.com/javisantossanchez/BigDataEnTiempoReal/assets/47392657/c0fa3739-ee55-42c1-ad14-9c16fbfcf7ad" style="width:65%" \>
</p>
<p align="center">
  <em><strong>Topic particionado</strong></em> 
</p>


Para hacer que tus datos sean tolerantes a fallos y altamente disponibles, cada tema puede replicarse, incluso a través de regiones geográficas o centros de datos, de modo que siempre haya múltiples brokers que tengan una copia de los datos en caso de que algo salga mal, necesites hacer mantenimiento en los brokers, etc. Una configuración común en producción es un factor de replicación de 3, es decir, siempre habrá tres copias de tus datos. Esta replicación se realiza a nivel de particiones de tema.




### ***Broker en Kafka***

Un broker en Kafka es un servidor que almacena datos y sirve a los clientes. Es una parte fundamental de la arquitectura de Kafka. Los brokers reciben datos de los productores, los almacenan de manera confiable en el disco y los sirven a los consumidores. Cada broker puede gestionar cientos de miles de particiones y millones de mensajes por segundo, garantizando la alta disponibilidad y la durabilidad de los datos.

#### Funcionamiento

1. **Recepción de datos:** Los productores envían mensajes a un broker, que los almacena en la partición correspondiente del topic. Cada mensaje se asigna a una partición específica basada en una clave de partición o mediante un algoritmo de round-robin.
2. **Almacenamiento:** Los brokers persisten los mensajes en disco y replican los datos en otros brokers para asegurar la durabilidad y tolerancia a fallos. Cada mensaje se guarda con un offset único que lo identifica dentro de su partición.
3. **Servir a los consumidores:** Los consumidores leen los mensajes de las particiones de los topics desde los brokers. Kafka garantiza que los consumidores puedan leer los mensajes de manera eficiente y en orden, permitiendo a los consumidores mantener su posición (offset) en el flujo de datos.

#### Acoplamiento en la arquitectura Kafka

- **Cluster:** Un clúster de Kafka consiste en múltiples brokers trabajando juntos. Cada topic se divide en varias particiones distribuidas entre los brokers, permitiendo la escalabilidad horizontal.
- **Particiones:** Las particiones permiten la paralelización del procesamiento de datos. Cada partición es una secuencia ordenada de mensajes que los consumidores pueden leer de manera independiente. Esto permite que múltiples consumidores puedan leer de diferentes particiones en paralelo, aumentando la eficiencia y la capacidad de procesamiento.
- **Replicación:** Para garantizar la durabilidad y alta disponibilidad, los datos de cada partición se replican en múltiples brokers. Cada partición tiene una réplica líder y varias réplicas seguidoras. Las réplicas seguidoras replican los datos del líder y pueden tomar el control en caso de fallo del líder.
- **Liderazgo de particiones:** Cada partición tiene un líder broker que maneja todas las lecturas y escrituras para esa partición, mientras que los seguidores replican los datos del líder. Este liderazgo se gestiona mediante el protocolo de consenso de Kafka, asegurando que siempre haya un líder disponible para cada partición.
- **Coordinación de Zookeeper:** Kafka utiliza Zookeeper para la gestión de la configuración del clúster, la selección de líderes de particiones y la gestión de la metadata. Zookeeper ayuda a mantener la coherencia y coordinación entre los brokers del clúster.

#### Detalles adicionales

- **Retención de mensajes:** Los brokers pueden configurarse para retener mensajes por un período de tiempo específico o hasta que se alcance un tamaño de almacenamiento determinado. Esto permite a los consumidores recuperar mensajes históricos, facilitando la re-procesamiento de datos si es necesario.
- **Compresión y compactación:** Kafka soporta la compresión de mensajes para reducir el uso de espacio de almacenamiento y el tráfico de red. También soporta la compactación de logs, que permite mantener solo la última versión de un mensaje basado en su clave, útil para casos de uso como los registros de cambios.
- **Monitoreo y métricas:** Los brokers emiten una amplia variedad de métricas sobre su desempeño y estado, incluyendo tasas de mensajes, latencias, y utilización de recursos. Estas métricas son esenciales para la monitorización y gestión proactiva del clúster.

El broker en Kafka es esencial para garantizar la entrega de mensajes de alta disponibilidad, durabilidad y rendimiento dentro del clúster, permitiendo una infraestructura robusta para el procesamiento y transmisión de datos en tiempo real. La arquitectura distribuida y las capacidades de replicación y paralelización hacen de Kafka una plataforma poderosa para aplicaciones de streaming de datos y sistemas de mensajería escalables.

<p align="center">
    <img src="https://github.com/javisantossanchez/BigDataEnTiempoReal/assets/47392657/014508da-e8a5-4365-b38a-d9a1123d40cb" alt="Datos de un Broker"/>
</p>
<p align="center">
  <em><strong>Broker de kafka:</strong></em> representación visual funcionamiento de brokers en Kafka.
</p>

### ***Casos de Uso***

#### Mensajería

Kafka funciona bien como un reemplazo para un broker de mensajes más tradicional. Los brokers de mensajes se utilizan por diversas razones (para desacoplar el procesamiento de los productores de datos, para amortiguar los mensajes no procesados, etc.). En comparación con la mayoría de los sistemas de mensajería, Kafka tiene un mejor rendimiento, particionamiento incorporado, replicación y tolerancia a fallos, lo que lo convierte en una buena solución para aplicaciones de procesamiento de mensajes a gran escala. Actualmente, los usos de mensajería suelen tener un rendimiento relativamente bajo, pero pueden requerir baja latencia de extremo a extremo y a menudo dependen de las sólidas garantías de durabilidad que proporciona Kafka.

En este dominio, Kafka es comparable a sistemas de mensajería tradicionales como ActiveMQ o RabbitMQ.

#### Seguimiento de Actividad en Sitios Web

El caso de uso original para Kafka era poder reconstruir un pipeline de seguimiento de actividad de usuarios como un conjunto de feeds de publicación-suscripción en tiempo real. Esto significa que la actividad del sitio (vistas de página, búsquedas u otras acciones que los usuarios puedan realizar) se publica en topics centrales con un tema por tipo de actividad. Estos feeds están disponibles para suscripción para una variedad de casos de uso, incluyendo procesamiento en tiempo real, monitoreo en tiempo real y carga en Hadoop o sistemas de almacenamiento de datos offline para procesamiento y generación de informes offline. El seguimiento de actividad suele tener un volumen muy alto, ya que se generan muchos mensajes de actividad por cada vista de página del usuario.

#### Métricas

Kafka se utiliza a menudo para datos de monitoreo operativo. Esto implica la agregación de estadísticas de aplicaciones distribuidas para producir feeds centralizados de datos operativos.

#### Agregación de Logs

Muchas personas utilizan Kafka como un reemplazo para una solución de agregación de logs. La agregación de logs normalmente recopila archivos de log físicos de los servidores y los coloca en un lugar central (un servidor de archivos o HDFS quizás) para su procesamiento. Kafka abstrae los detalles de los archivos y ofrece una abstracción más limpia de datos de logs o eventos como un flujo de mensajes. Esto permite un procesamiento de menor latencia y un soporte más fácil para múltiples fuentes de datos y consumo de datos distribuidos. En comparación con sistemas centrados en logs como Scribe o Flume, Kafka ofrece un rendimiento igualmente bueno, garantías de durabilidad más fuertes debido a la replicación y una latencia de extremo a extremo mucho menor.

#### Procesamiento de Flujos

Muchos usuarios de Kafka procesan datos en pipelines de procesamiento que consisten en múltiples etapas, donde los datos de entrada en bruto se consumen de los topics de Kafka y luego se agregan, enriquecen o transforman de alguna otra manera en nuevos topics para su posterior consumo o procesamiento posterior. Por ejemplo, un pipeline de procesamiento para recomendar artículos de noticias podría rastrear el contenido de artículos de feeds RSS y publicarlo en un tema de "artículos"; un procesamiento adicional podría normalizar o eliminar duplicados de este contenido y publicar el contenido de artículos depurado en un nuevo tema; una etapa final de procesamiento podría intentar recomendar este contenido a los usuarios. Tales pipelines de procesamiento crean gráficos de flujos de datos en tiempo real basados en los topics individuales. A partir de la versión 0.10.0.0, una biblioteca de procesamiento de flujos liviana pero poderosa llamada Kafka Streams está disponible en Apache Kafka para realizar dicho procesamiento de datos como se describe arriba. Aparte de Kafka Streams, otras herramientas de procesamiento de flujos de código abierto incluyen Apache Storm y Apache Samza.

<p align="center">
  <img src="https://github.com/javisantossanchez/BigDataEnTiempoReal/assets/47392657/86380f8f-e2ed-4dd8-aec3-40d21c20c63b" style="width:75%" \>
</p>
<p align="center">
  <em><strong>Kafka architecture:</strong></em> representación visual arquitectura Lambda implementada con Kafka para la ingestión de datos en la capa de velocidad utilizando Apache Flink mientras soporta streaming de datos e integra la capa histórica con Spark.
</p>



### ***Kafka Streams***

  
La capa de mensajería de Kafka particiona los datos para almacenarlos y transportarlos. Kafka Streams particiona los datos para procesarlos. En ambos casos, esta partición es lo que permite la localización de datos, elasticidad, escalabilidad, alto rendimiento y tolerancia a fallos. 

Kafka Streams utiliza los conceptos de particiones y tareas como unidades lógicas de su modelo de paralelismo basado en particiones de topics de Kafka. Existen vínculos estrechos entre Kafka Streams y Kafka en el contexto del paralelismo:

- Cada partición de flujo es una secuencia totalmente ordenada de registros de datos y se mapea a una partición de tema de Kafka.
- Un registro de datos en el flujo se mapea a un mensaje de Kafka de ese topic.
- Las claves de los registros de datos determinan la partición de datos tanto en Kafka como en Kafka Streams, es decir, cómo se enrutan los datos a particiones específicas dentro de los topics.

<p align="center">
    <img src="https://github.com/javisantossanchez/GrandesVolumenesDeDatos/assets/47392657/e7e03b7f-1a0b-4a52-affe-2273d0ea19e9" style="width:55%;" alt="Kafka Streams"/>
</p>
<p align="center">
  <em><strong>Kafka Streams:</strong></em> representación visual tratamiento de flujos de datos con Kafka Streams.
    
</p>
La topología del procesador de una aplicación se escala dividiéndola en múltiples tareas. Más específicamente, Kafka Streams crea un número fijo de tareas basado en las particiones del flujo de entrada para la aplicación, con cada tarea asignada a una lista de particiones de los flujos de entrada (es decir, topics de Kafka). La asignación de particiones a tareas nunca cambia, de modo que cada tarea es una unidad fija de paralelismo de la aplicación. Las tareas pueden entonces instanciar su propia topología de procesador basada en las particiones asignadas; también mantienen un búfer para cada una de sus particiones asignadas y procesan mensajes uno a la vez desde estos búferes de registros. Como resultado, las tareas de flujo pueden procesarse de manera independiente y en paralelo sin intervención manual.

De manera ligeramente simplificada, el paralelismo máximo al que tu aplicación puede ejecutarse está limitado por el número máximo de tareas de flujo, que a su vez está determinado por el número máximo de particiones de los topics de entrada de los que la aplicación está leyendo. 

Por ejemplo, si tu topic de entrada tiene 5 particiones, entonces puedes ejecutar hasta 5 instancias de la aplicación. Estas instancias procesarán de manera colaborativa los datos del topic. Si ejecutas un número mayor de instancias de la aplicación que particiones del tema de entrada, las instancias "excedentes" se iniciarán pero permanecerán inactivas; sin embargo, si una de las instancias ocupadas falla, una de las instancias inactivas retomará el trabajo de la anterior.

Es importante entender que Kafka Streams no es un gestor de recursos, sino una biblioteca que "se ejecuta" en cualquier lugar donde se ejecute su aplicación de procesamiento de flujos. Múltiples instancias de la aplicación se ejecutan ya sea en la misma máquina o distribuidas en múltiples máquinas y las tareas pueden distribuirse automáticamente por la biblioteca a esas instancias de la aplicación en ejecución. La asignación de particiones a tareas nunca cambia; si una instancia de la aplicación falla, todas sus tareas asignadas se reiniciarán automáticamente en otras instancias y continuarán consumiendo de las mismas particiones de flujo.


### ***Kafka Connect***

Kafka Connect es un componente de Apache Kafka que facilita la integración de Kafka con otros sistemas mediante conectores reutilizables. Permite la ingesta y exportación de datos entre Kafka y diversas fuentes y sumideros de datos sin necesidad de escribir código personalizado.

#### Funcionamiento

1. **Conectores:** Kafka Connect utiliza conectores para transferir datos hacia y desde Kafka. Existen dos tipos principales de conectores:
   - **Source Connectors:** Estos conectores leen datos de una fuente de datos externa (como una base de datos, un archivo o una API) y los escriben en un topic de Kafka.
   - **Sink Connectors:** Estos conectores leen datos de un topic de Kafka y los escriben en un sistema de destino (como una base de datos, un sistema de almacenamiento en la nube o una aplicación).
2. **Workers:** Los conectores se ejecutan dentro de procesos llamados workers, que pueden desplegarse en modo autónomo o en modo distribuido. En modo distribuido, múltiples workers pueden formar un clúster de Connect para mayor escalabilidad y tolerancia a fallos.
3. **Configuración:** Los conectores y los workers se configuran mediante archivos JSON o propiedades, donde se especifican detalles como la ubicación de la fuente/destino, el formato de los datos y las opciones de transformación.
4. **Transformaciones:** Kafka Connect permite aplicar transformaciones a los datos en tránsito mediante Single Message Transforms (SMTs). Estas transformaciones pueden modificar, filtrar o enriquecer los datos antes de que se escriban en el destino.

#### Acoplamiento en la arquitectura Kafka

- **Ingesta de Datos:** Kafka Connect facilita la ingesta de datos de diversas fuentes externas en Kafka. Esto es útil para consolidar datos de diferentes sistemas en un único clúster de Kafka, donde pueden ser procesados, analizados o re-distribuidos.
- **Exportación de Datos:** Permite la exportación de datos desde Kafka a otros sistemas, facilitando la integración con herramientas de análisis, almacenamiento en la nube, sistemas de bases de datos y más.
- **Escalabilidad:** Kafka Connect puede escalar horizontalmente agregando más workers al clúster. Cada worker puede manejar múltiples tareas de conectores, distribuyendo la carga de trabajo y asegurando un alto rendimiento y disponibilidad.
- **Tolerancia a Fallos:** En un clúster distribuido, los workers de Kafka Connect gestionan automáticamente la redistribución de tareas en caso de fallo de un worker, garantizando que los datos sigan fluyendo sin interrupciones.
- **Monitorización y Gestión:** Kafka Connect expone métricas detalladas sobre el estado y el rendimiento de los conectores y workers, permitiendo una gestión proactiva y resolución de problemas. Además, la configuración y el estado de los conectores pueden gestionarse mediante REST API, facilitando la automatización y la integración con sistemas de orquestación.

#### Detalles adicionales

- **Integración con Schema Registry:** Kafka Connect puede integrarse con Confluent Schema Registry para gestionar esquemas de datos, garantizando la compatibilidad y la evolución de los datos entre productores y consumidores.
- **Conectores Prediseñados:** Existe una amplia variedad de conectores prediseñados para Kafka Connect, cubriendo una multitud de sistemas de bases de datos, almacenes de datos, sistemas de archivos y servicios en la nube. Estos conectores facilitan la implementación rápida y reducen la necesidad de desarrollo personalizado.
- **Plugins y Extensibilidad:** Kafka Connect es extensible mediante plugins, permitiendo a los desarrolladores crear conectores personalizados para sistemas específicos o implementar transformaciones personalizadas según las necesidades de negocio.

Kafka Connect es una herramienta poderosa y flexible para la integración de datos, simplificando la transferencia de datos entre Kafka y otros sistemas. Su capacidad de escalar y su enfoque en la facilidad de uso hacen que sea una elección ideal para arquitecturas de datos modernas que requieren ingesta y exportación de datos eficientes y fiables.


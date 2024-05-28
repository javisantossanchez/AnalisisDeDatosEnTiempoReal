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

Los eventos se organizan y almacenan de manera duradera en temas. De manera muy simplificada, un tema es similar a una carpeta en un sistema de archivos, y los eventos son los archivos en esa carpeta. Un nombre de tema de ejemplo podría ser "pagos". Los temas en Kafka son siempre de múltiples productores y múltiples suscriptores: un tema puede tener cero, uno o muchos productores que escriben eventos en él, así como cero, uno o muchos consumidores que se suscriben a estos eventos. Los eventos en un tema pueden leerse tantas veces como sea necesario: a diferencia de los sistemas de mensajería tradicionales, los eventos no se eliminan después del consumo. En su lugar, defines cuánto tiempo Kafka debe retener tus eventos a través de una configuración por tema, después de lo cual los eventos antiguos serán descartados. El rendimiento de Kafka es efectivamente constante con respecto al tamaño de los datos, por lo que almacenar datos durante mucho tiempo es perfectamente aceptable.

Los temas están particionados, lo que significa que un tema se distribuye en varios "cubos" ubicados en diferentes brokers de Kafka. Esta distribución de tus datos es muy importante para la escalabilidad porque permite que las aplicaciones cliente lean y escriban datos desde/hacia muchos brokers al mismo tiempo. Cuando se publica un nuevo evento en un tema, en realidad se agrega a una de las particiones del tema. Los eventos con la misma clave de evento (por ejemplo, un ID de cliente o de vehículo) se escriben en la misma partición, y Kafka garantiza que cualquier consumidor de una partición de tema dada siempre leerá los eventos de esa partición en exactamente el mismo orden en que fueron escritos.

Para hacer que tus datos sean tolerantes a fallos y altamente disponibles, cada tema puede replicarse, incluso a través de regiones geográficas o centros de datos, de modo que siempre haya múltiples brokers que tengan una copia de los datos en caso de que algo salga mal, necesites hacer mantenimiento en los brokers, etc. Una configuración común en producción es un factor de replicación de 3, es decir, siempre habrá tres copias de tus datos. Esta replicación se realiza a nivel de particiones de tema.


## ***Patrones de Diseño: Colas de Mensajes, Modelo Publicación-Subscripción y Arquitectura Basada en Eventos***

Para poder hablar sobre los patrones de diseño de sistemas de comunicación, principalmente de aquellos que están basados en el envío de mensajes/eventos, es necesario entender de qué manera se produce la comunicación entre los actores que intervienen en la generación y comunicación de los datos.
### ***Comunicación Asíncrona y Síncrona***

En el contexto de patrones de diseño, la comunicación entre componentes puede ser asíncrona o síncrona. 

- **Asíncrona**: Los componentes se comunican sin esperar una respuesta inmediata. Esto es común en sistemas donde los componentes necesitan operar de manera independiente para mejorar el rendimiento y la escalabilidad.
- **Síncrona**: Los componentes esperan una respuesta inmediata antes de continuar. Esto es útil en situaciones donde se necesita una confirmación instantánea de que una operación se ha completado.

Otra manera de poder referirse a este tipo de comunicaciones es **comunicación agnóstica**. Esto significa que cada miembro en la cadena de la comunicación solo es conocedor de los sistemas con los que intrínsecamente le es necesario para emplear su función.

### ***Colas de Mensajes***

Las colas de mensajes permiten a las aplicaciones comunicarse de manera asincrónica y desacoplada. Este patrón se utiliza comúnmente en sistemas distribuidos para garantizar que los mensajes se entreguen de manera confiable.

#### *Funcionamiento*

1. **Productores y Consumidores**: Los productores envían mensajes a la cola, mientras que los consumidores los reciben y procesan.
2. **Encolado y Desencolado**: Los mensajes se encolan en el orden recibido y se desencolan por los consumidores para su procesamiento.
3. **Asincronía**: Los productores pueden enviar mensajes sin esperar una respuesta inmediata, y los consumidores procesan los mensajes cuando estén listos.

### ***Modelo Publicación-Subscripción***

El modelo pub-sub permite la comunicación uno-a-muchos y muchos-a-muchos, donde los publicadores emiten mensajes y los suscriptores los reciben sin conocimiento directo entre ellos.

#### *Funcionamiento*

1. **Publicadores y Suscriptores**: Los publicadores envían mensajes a un "broker" o "bus de mensajes", y los suscriptores se registran para recibir mensajes de interés.
2. **Broker**: Gestiona la distribución de mensajes a los suscriptores interesados.
3. **Asincronía y Sincronía**: Generalmente asincrónico, pero puede soportar interacciones síncronas cuando se necesita una respuesta inmediata.

### ***Características Comunes***

Ambos patrones de diseño, Colas de Mensajes y Publicación-Subscripción, comparten varias características clave:

- **Desacoplamiento**: Facilitan el desarrollo y mantenimiento de sistemas complejos al reducir las dependencias directas entre componentes.
- **Escalabilidad**: Permiten distribuir la carga de trabajo y manejar un gran número de mensajes y suscriptores.
- **Fiabilidad**: Implementan mecanismos para asegurar que los mensajes no se pierdan, como almacenamiento persistente y confirmaciones de recepción.
- **Flexibilidad**: Facilitan la adición de nuevos componentes sin cambiar la lógica existente.

### ***Casos de Uso***

- **Colas de Mensajes**: 
  - Procesamiento de tareas en segundo plano
  - Integración de sistemas heterogéneos
  - Gestión de transacciones y eventos en aplicaciones empresariales

- **Publicación-Subscripción**:
  - Sistemas de notificaciones push en aplicaciones móviles y web
  - Transmisión de actualizaciones de datos en tiempo real, como precios de acciones
  - Comunicación entre microservicios en arquitecturas de software modernas



### ***Comparación entre Colas de Mensajes y Publicación-Subscripción***

| Aspecto                | Colas de Mensajes                                         | Publicación-Subscripción                                   |
|------------------------|-----------------------------------------------------------|------------------------------------------------------------|
| Tipo de Comunicación   | Punto a punto (uno a uno)                                 | Uno a muchos o muchos a muchos                             |
| Entrega de Mensajes    | Mensajes se entregan a un solo consumidor                 | Mensajes se entregan a todos los suscriptores interesados   |
| Uso Común              | Procesamiento de tareas, integración de sistemas          | Notificaciones en tiempo real, actualización de datos en tiempo real |
| Sincronía              | Asíncrono                                                 | Asíncrono, pero puede soportar sincronía                   |

<p align="center">
<img src="https://github.com/javisantossanchez/BigDataEnTiempoReal/assets/47392657/05393391-066d-4c70-8949-7d65672e3c04" style="align:center;" \>
</p>
<p align="center">
  <em><strong>Cola de Mensajes y Publish/Subscriber:</strong></em> Diferencias entre ambos patrones de diseño.
</p>

### ***Funcionamiento de la Arquitectura Basada en Eventos***

La arquitectura basada en eventos (**Event Driven Architecture** o **EDA**, por sus siglas en inglés) es un patrón de diseño de software que permite la construcción de sistemas escalables y acoplados de forma flexible. Esta arquitectura está basada en _los eventos_, que representan ocurrencias o cambios en el sistema, impulsan el flujo de los datos. Son generados por diversas fuentes, publicados en un bus de eventos o en un intermediario de mensajes, y consumidos de manera asincrónica por componentes interesados. Este enfoque promueve flexibilidad, escalabilidad y resiliencia.

Al adoptar la arquitectura basada en eventos, los sistemas ganan la capacidad de reaccionar de manera independiente a los eventos, haciéndolos escalables y adaptables a más necesidades de negocio. La arquitectura también maneja desafíos de consistencia de datos usando técnicas como versionado de eventos, idempotencia y acciones de compensación.

Un ejemplo común es una aplicación basada en interacción gráfica, un videojuego: la aplicación trabaja en respuesta a los clics del ratón del usuario o las selecciones del menú. Esta analogía puede extenderse a funciones a nivel de sistema para implementar lógica empresarial y flujos de trabajo, mucho más allá de lo que un usuario final podría ver. La programación basada en eventos es a menudo el medio por el cual un componente determinado soporta su rol en una arquitectura basada en microservicios.

Los componentes individuales que interactúan con el sistema envían eventos, que representan actividad o solicitudes a nivel de sistema o negocio; esos eventos son recopilados por la plataforma de procesamiento de eventos, para su filtrado, aumento y distribución a otros componentes dependientes o interesados. La comunicación entre estos componentes se maneja a través de microservicios anunciados por cada componente. Dentro de los componentes, los microservicios se implementan utilizando un modelo de programación basado en eventos.

EDA tiene ventajas como la mejora de la capacidad de respuesta, el manejode flujos de trabajo complejos, cuenta con integraciones basadas en eventos y procesamiento de eventos en tiempo real. Además aporta flexibilidad y extensibilidad, pero introduce complejidades como la sobrecarga operativa, los desafíos de ordenación de eventos y la necesidad de un modelado y gestión efectivos de eventos.



#### Beneficios

Los beneficios de la arquitectura basada en eventos derivan de cómo los sistemas y componentes están acoplados de forma flexible, lo que puede facilitar el desarrollo y despliegue independiente de sistemas, la mejora de la escalabilidad y la tolerancia a fallos, y la integración con sistemas externos, especialmente en comparación con las arquitecturas monolíticas.

La arquitectura basada en eventos, como un enfoque para soportar sistemas complejos y distribuidos, a menudo se implementa mediante el uso de otros patrones de software importantes, como microservicios y programación basada en eventos (EDP), junto con tecnologías de procesamiento de eventos como Apache Kafka.

La programación basada en eventos es un paradigma a nivel de código de software donde las funciones clave o la lógica de negocio de un programa se invocan en respuesta a eventos entrantes; el programa responde a los eventos a medida que ocurren.

### ***Ejemplos del Mundo Real***

| **E-commerce Order Processing** | **Internet of Things (IoT) Data Collection** | **User Registration & Authentication** | **Notification System** | **Stock Market Trading** |
|-----------------------------|-------------------------------------------|------------------------------------|---------------------|----------------------|
| Cuando un cliente realiza un pedido, se dispara un evento para iniciar la gestión de inventario, procesamiento de pagos y coordinación de envíos. | Los dispositivos IoT generan eventos cuando los datos del sensor superan un cierto umbral, habilitando el monitoreo en tiempo real y el análisis para varias aplicaciones. | Cuando un usuario se registra o inicia sesión, se activan eventos para verificar credenciales, actualizar perfiles de usuario y otorgar acceso a diferentes recursos del sistema. | Los eventos se activan cuando se cumplen condiciones específicas, como recibir nuevos mensajes o asignar tareas, notificando a los usuarios relevantes por correo electrónico, SMS o notificaciones push. | Cuando cambian las condiciones del mercado, se generan eventos para activar estrategias de trading automatizadas, habilitando la ejecución en tiempo real de órdenes de compra/venta. |
| **Real-Time Analytics** | **Workflow Management** | **Sensor Integration in Smart Homes** | **Event-Driven Microservices** | **Online Gaming** |
| Los eventos se activan cuando se reciben flujos de datos, permitiendo análisis continuo y generación de insights, como monitorear el tráfico web o detectar actividades fraudulentas. | Cuando se completa una tarea o se alcanza un hito, se activan eventos para avanzar el flujo de trabajo, asegurando colaboración fluida y automatización de procesos. | Se generan eventos cuando los sensores detectan movimiento, cambios de temperatura o aperturas de puertas, activando luces u otros dispositivos. | Los eventos se utilizan para comunicar entre diferentes microservicios, permitiendo sistemas escalables y de acoplamiento suelto. | Los eventos se activan cuando los jugadores realizan acciones, como mover personajes o completar misiones, permitiendo interacción en tiempo real y sincronización del juego. |

Aprovechando la mensajería asincrónica y los flujos de trabajo basados en eventos, EDA permite que los servicios reaccionen de forma autónoma a los eventos, promoviendo un acoplamiento flexible, escalabilidad y extensibilidad. Por otro lado, los microservicios son un paradigma de desarrollo de software que estructura las aplicaciones como un conjunto de pequeños servicios autónomos, cada uno responsable de funcionalidades empresariales específicas. 

Estos servicios, típicamente desplegados en contenedores o máquinas virtuales ligeras, se comunican entre sí utilizando protocolos ligeros como HTTP, colas de mensajes o flujos de eventos. La combinación de EDA con microservicios permite la comunicación basada en eventos entre servicios, habilitando la propagación de eventos, el almacenamiento de estos y flujos de trabajo coreografiados u orquestados que responden a los determinados contextos. Este enfoque mejora la modularidad del sistema, la tolerancia a fallos y la escalabilidad, facilitando el desarrollo de sistemas complejos y distribuidos que pueden adaptarse y evolucionar de manera eficiente en entornos dinámicos.


<p align="center">
  <img src="https://github.com/javisantossanchez/BigDataEnTiempoReal/assets/47392657/a9d9dd0b-c442-4dc6-845c-ecad7ccfb5d0" style="width:75%" \>
</p>
<p align="center">
  <em><strong>Event Driven Architecture:</strong></em> representación visual del patrón EDA.
</p>


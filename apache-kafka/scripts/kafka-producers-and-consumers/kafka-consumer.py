from confluent_kafka import Consumer, KafkaException, KafkaError

def kafka_consumer_example(brokers, group_id, topics):
    # Configuración del consumidor
    conf = {
        'bootstrap.servers': brokers,
        'group.id': group_id,
        'auto.offset.reset': 'earliest'
    }

    # Crear un consumidor
    consumer = Consumer(conf)

    # Suscribirse a los topics
    consumer.subscribe(topics)

    try:
        while True:
            # Leer mensajes
            msg = consumer.poll(timeout=1.0)
            if msg is None:
                continue
            if msg.error():
                if msg.error().code() == KafkaError._PARTITION_EOF:
                    # Fin de la partición
                    print(f'End of partition reached {msg.topic()} [{msg.partition()}] at offset {msg.offset()}')
                elif msg.error():
                    raise KafkaException(msg.error())
            else:
                # Procesar mensaje
                print(f'Received message: {msg.value().decode("utf-8")} from topic {msg.topic()} partition {msg.partition()} offset {msg.offset()}')

    except KeyboardInterrupt:
        pass
    finally:
        # Cerrar el consumidor
        consumer.close()

if __name__ == "__main__":
    brokers = "172.31.216.72:30083"
    group_id = "ETL_group"
    topics = ["ETL"]

    kafka_consumer_example(brokers, group_id, topics)

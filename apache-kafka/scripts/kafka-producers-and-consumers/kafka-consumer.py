from confluent_kafka import Consumer, KafkaException, KafkaError
import argparse


def kafka_consumer(brokers, group_id, topics):
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
    parser = argparse.ArgumentParser(description='Consume messages to a Kafka topic.')

    brokers = "kafka1:9092,kafka2:9092,kafka3:9092,kafka4:9092"
    group_id = "ETSISI_CONSUMER"
    parser.add_argument('topic', type=str, help='The name of the topic')
    args = parser.parse_args()

    print(args.topic)
    topics=[args.topic]
    kafka_consumer(brokers, group_id, topics)

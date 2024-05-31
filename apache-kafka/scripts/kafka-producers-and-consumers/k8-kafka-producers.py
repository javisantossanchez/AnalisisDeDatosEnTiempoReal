from confluent_kafka import Producer
import argparse


kubernetes_worker_node_IP = "172.31.216.72"

class KafkaProducer:
    def __init__(self, brokers):
        self.producer = Producer({'bootstrap.servers': brokers})

    def delivery_report(self, err, msg):
        """ Callback called once for each message produced to indicate delivery result.
            Triggered by poll() or flush(). """
        if err is not None:
            print(f'Message delivery failed: {err}')
        else:
            print(f'Message delivered to {msg.topic()} [{msg.partition()}]')

    def publish(self, topic, message):
        try:
            self.producer.produce(topic, message.encode('utf-8'), callback=self.delivery_report)
            self.producer.poll(0)
        except BufferError:
            print('Local producer queue is full (%d messages awaiting delivery): try again' % len(self.producer))

        # Wait up to 1 second for events. Callbacks will be invoked during
        # this method call if the message is successfully delivered.
        self.producer.flush()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Send a message to a Kafka topic.')
    parser.add_argument('topic', type=str, help='The name of the topic')

    parser.add_argument('message', type=str, help='The message to send')
    args = parser.parse_args()

    
    brokers = f"{kubernetes_worker_node_IP}:30083,{kubernetes_worker_node_IP}:30084,{kubernetes_worker_node_IP}:30085,{kubernetes_worker_node_IP}:30086"
    topic = args.topic

    kafka_producer = KafkaProducer(brokers)

    
    kafka_producer.publish(topic, args.message)

from kafka import KafkaConsumer, KafkaProducer
import json

kubernetes_worker_node_IP = "172.31.216.72"

def process_stream():
    consumer = KafkaConsumer(
        'ratings',
        bootstrap_servers=[
                    f"{kubernetes_worker_node_IP}:30083",
                    f"{kubernetes_worker_node_IP}:30084",
                    f"{kubernetes_worker_node_IP}:30084",
                    f"{kubernetes_worker_node_IP}:30086"            
                            ],                    
        value_serializer=lambda v: json.dumps(v).encode('utf-8')
    )
    producer = KafkaProducer(
        bootstrap_servers=[
                    f"{kubernetes_worker_node_IP}:30083",
                    f"{kubernetes_worker_node_IP}:30084",
                    f"{kubernetes_worker_node_IP}:30084",
                    f"{kubernetes_worker_node_IP}:30086"            
                            ],                    
        value_serializer=lambda v: json.dumps(v).encode('utf-8')
    )

    for message in consumer:
        data = message.value
        rating = float(data['rating'])

        if rating >= 4.0:
            category = 'high_ratings'
        elif 2.0 <= rating < 4.0:
            category = 'medium_ratings'
        else:
            category = 'low_ratings'
        
        producer.send(category, data)
        producer.flush()

if __name__ == "__main__":
    process_stream()

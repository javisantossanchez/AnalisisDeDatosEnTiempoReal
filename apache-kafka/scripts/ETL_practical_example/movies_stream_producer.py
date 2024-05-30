import csv
from kafka import KafkaProducer
import json

DATA_RATINGS = "data/movielensratings.csv"
DATA_MOVIES = "data/movieslensinfo.csv"
kubernetes_worker_node_IP = "172.31.216.72"
movies_dict = {}

def generate():
    while True:
        with open(DATA_RATINGS) as file:
            csvReader = csv.DictReader(file)
            for rows in csvReader:
                data = {
                    'userId': rows['userId'],
                    'movie': movies_dict[rows['movieId']],
                    'rating': rows['rating'],
                    'timestamp': rows['timestamp'],
                }
                yield data

def send_to_kafka(producer, topic, data):
    producer.send(topic, value=data)
    producer.flush()

def main():
    # Initialize movies dictionary
    with open(DATA_MOVIES) as file:
        csvReader = csv.DictReader(file)
        for rows in csvReader:
            movieId = rows['movieId']
            movies_dict[movieId] = {
                'movieId': movieId,
                'title': rows['title'],
                'genres': rows['genres'].split('|')
            }

    # Set up Kafka producer
    producer = KafkaProducer(
        bootstrap_servers=[
                    f"{kubernetes_worker_node_IP}:30083",
                    f"{kubernetes_worker_node_IP}:30084",
                    f"{kubernetes_worker_node_IP}:30084",
                    f"{kubernetes_worker_node_IP}:30086"            
                            ],                    
        value_serializer=lambda v: json.dumps(v).encode('utf-8')
    )

    topic = 'ratings'  

    # Send data to Kafka
    for data in generate():
        send_to_kafka(producer, topic, data)

if __name__ == "__main__":
    main()

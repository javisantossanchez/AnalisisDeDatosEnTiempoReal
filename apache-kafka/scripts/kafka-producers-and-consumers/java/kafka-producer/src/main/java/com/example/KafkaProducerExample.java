package com.example;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.clients.producer.Callback;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;

import java.util.Properties;

public class KafkaProducerExample {

    public static void main(String[] args) {
        if (args.length < 1) {
            System.err.println("Please provide the message to send as the first argument.");
            System.exit(1);
        }

        // Kafka broker addresses
        String brokers = "kafka1:9092,kafka2:9092,kafka3:9092,kafka4:9092";
        // Topic name
        String topic = "temperatura";
        // Message to send
        String message = args[0];

        // Configure the Producer
        Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, brokers);
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

        KafkaProducer<String, String> producer = new KafkaProducer<>(props);

        try {
            // Send the message
            ProducerRecord<String, String> record = new ProducerRecord<>(topic, message);
            producer.send(record, new Callback() {
                public void onCompletion(RecordMetadata metadata, Exception e) {
                    if (e != null) {
                        e.printStackTrace();
                    } else {
                        System.out.printf("Sent message to topic:%s partition:%s offset:%s%n", 
                                metadata.topic(), metadata.partition(), metadata.offset());
                    }
                }
            });
        } finally {
            producer.close();
        }
    }
}

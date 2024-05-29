import csv
from confluent_kafka import Producer
import json

def leer_csv(ruta_archivo):
    """Lee un archivo CSV y devuelve los datos en una lista de diccionarios."""
    datos = []
    with open(ruta_archivo, mode='r', encoding='utf-8-sig') as archivo:
        lector_csv = csv.DictReader(archivo)
        for fila in lector_csv:
            datos.append(fila)
    return datos

def mostrar_datos(datos):
    """Muestra los datos en pantalla."""
    for fila in datos:
        print(fila)
        print(f"Zona: {fila['zona']}")
        print(f"Toponimia: {fila['toponimia']}")
        print(f"Latitud: {fila['latitud']}")
        print(f"Longitud: {fila['longitud']}")
        print(f"Tipo de Actividad: {fila['tipo_actividad']}")
        print(f"Fecha de Inicio: {fila['fecha_inicio']}")
        print(f"Fecha de Fin: {fila['fecha_fin']}")
        print(f"Cantidad: {fila['cantidad']}")
        print(f"Unidad: {fila['unidad']}")
        print("-" * 40)

# Ruta del archivo CSV (asegúrate de ajustar la ruta según la ubicación de tu archivo)
ruta_archivo = 'data/afluencia-de-areas-recreativas-2024.csv'

# Leer los datos del CSV
datos = leer_csv(ruta_archivo)

# Mostrar los datos
mostrar_datos(datos)

# Configuración del productor de Kafka
conf = {
    'bootstrap.servers': '172.31.216.72:30083',  # Cambia esto por la dirección de tu servidor Kafka
}

# Crear una instancia del productor
producer = Producer(conf)

# Definir una función de callback para manejar la entrega de mensajes
def delivery_report(err, msg):
    if err is not None:
        print(f"Error al entregar el mensaje: {err}")
    else:
        print(f"Mensaje entregado a {msg.topic()} [{msg.partition()}]")

# Publicar cada fila de datos en el topic
topic = 'ETL'  # Cambia esto por el nombre de tu topic

for fila in datos:
    # Convertir la fila a formato JSON
    fila_json = json.dumps(fila)
    # Publicar la fila en el topic
    producer.produce(topic, value=fila_json, callback=delivery_report)

# Esperar a que todos los mensajes sean entregados
producer.flush()

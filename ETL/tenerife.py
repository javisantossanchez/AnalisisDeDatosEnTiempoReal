import csv

def leer_csv(ruta_archivo):
    """Lee un archivo CSV y devuelve los datos en una lista de diccionarios."""
    datos = []
    with open(ruta_archivo, mode='r', encoding='utf-8') as archivo:
        lector_csv = csv.DictReader(archivo)
        for fila in lector_csv:
            datos.append(fila)
    return datos

def mostrar_datos(datos):
    """Muestra los datos en pantalla."""
    for fila in datos:
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
ruta_archivo = '/mnt/data/data.csv'

# Leer los datos del CSV
datos = leer_csv(ruta_archivo)

# Mostrar los datos
mostrar_datos(datos)

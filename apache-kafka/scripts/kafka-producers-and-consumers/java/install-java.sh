#!/bin/bash

# Nombre del proyecto
PROJECT_NAME="kafka-producer"

# Verificar que se proporciona un mensaje como argumento
if [ $# -lt 1 ]; then
  echo "Uso: $0 \"mensaje\""
  exit 1
fi

# Mensaje a enviar
MESSAGE="$1"

# Actualizar la lista de paquetes e instalar Java
sudo apt update
sudo apt install -y openjdk-11-jdk

# Verificar la instalación de Java
java -version

# Instalar Maven
sudo apt install -y maven

# Eliminar el directorio del proyecto si ya existe
if [ -d "$PROJECT_NAME" ]; then
  rm -rf "$PROJECT_NAME"
fi

# Crear un nuevo proyecto Maven
mvn archetype:generate -DgroupId=com.example -DartifactId=$PROJECT_NAME -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

# Mover al directorio del proyecto
cd $PROJECT_NAME

# Crear y escribir el archivo pom.xml con la configuración completa
cat <<EOL > pom.xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>kafka-producer</artifactId>
  <version>1.0-SNAPSHOT</version>
  <properties>
    <maven.compiler.source>11</maven.compiler.source>
    <maven.compiler.target>11</maven.compiler.target>
  </properties>
  <dependencies>
    <dependency>
      <groupId>org.apache.kafka</groupId>
      <artifactId>kafka-clients</artifactId>
      <version>3.2.1</version>
    </dependency>
  </dependencies>
  <build>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.8.1</version>
        <configuration>
          <source>11</source>
          <target>11</target>
        </configuration>
      </plugin>
      <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>exec-maven-plugin</artifactId>
        <version>3.0.0</version>
        <configuration>
          <mainClass>com.example.KafkaProducerExample</mainClass>
          <arguments>
            <argument>\${message}</argument>
          </arguments>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
EOL

# Crear el directorio fuente si no existe
mkdir -p src/main/java/com/example

# Asumimos que KafkaProducerExample.java está en el mismo directorio que el script
# Copiar KafkaProducerExample.java al directorio del proyecto
cp ../KafkaProducerExample.java src/main/java/com/example/

# Verificar que el archivo fue copiado correctamente
if [ ! -f src/main/java/com/example/KafkaProducerExample.java ]; then
  echo "Error: KafkaProducerExample.java no encontrado en src/main/java/com/example/"
  exit 1
fi

# Compilar el proyecto
mvn compile

# Ejecutar el programa pasando el mensaje como argumento
mvn exec:java -Dexec.mainClass="com.example.KafkaProducerExample" -Dexec.args="$MESSAGE"

#!/bin/bash

# Actualizar los paquetes del sistema
sudo apt update

# Comprobación e instalación de Docker
if ! command -v docker &> /dev/null; then
    echo "Docker no está instalado. Procediendo con la instalación..."
    
    # Instalar los paquetes necesarios para usar repositorios HTTPS
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

    # Añadir la clave GPG oficial de Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Añadir el repositorio de Docker a las fuentes de APT
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Actualizar el índice del paquete APT nuevamente para incluir los paquetes Docker
    sudo apt update

    # Asegurarse de instalar Docker desde el repositorio de Docker en lugar del repositorio predeterminado de Ubuntu
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    # Verificar que Docker se haya instalado correctamente
    sudo systemctl status docker
else
    echo "Docker ya está instalado."
fi

# Comprobación e instalación de Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose no está instalado. Procediendo con la instalación..."
    
    # Instalar Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    # Aplicar permisos ejecutables al binario de Docker Compose
    sudo chmod +x /usr/local/bin/docker-compose

    # Verificar la instalación de Docker Compose
    docker-compose --version
else
    echo "Docker Compose ya está instalado."
fi

# Comprobación e instalación de MicroK8s
if ! command -v microk8s &> /dev/null; then
    echo "MicroK8s no está instalado. Procediendo con la instalación..."
    
    # Instalar MicroK8s
    sudo snap install microk8s --classic

    # Añadir el usuario actual al grupo 'microk8s' y 'docker'
    sudo usermod -a -G microk8s $USER
    sudo usermod -a -G docker $USER

    # Aplicar permisos al directorio de configuración kube
    sudo chown -f -R $USER ~/.kube

    # Recordar al usuario reiniciar la sesión para aplicar los cambios en los grupos
    echo "Por favor, reinicie su sesión o ejecute 'newgrp microk8s' y 'newgrp docker' para aplicar los cambios en los grupos."

    # Habilitar los complementos necesarios de MicroK8s
    microk8s enable dns dashboard storage
else
    echo "MicroK8s ya está instalado."
fi

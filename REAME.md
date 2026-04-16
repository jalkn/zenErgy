# Zenergy World: Bio-Performance Ecosystem 🍄

Plataforma integral de biohacking e IoT para la optimización del rendimiento humano y el cultivo automatizado de hongos adaptógenos.

## 🚀 Arquitectura
* **Backend:** Django Rest Framework (DRF) con base de datos PostgreSQL.
* **Mobile App (Proximamente):** Desarrollada en Flutter para iOS y Android.
* **IoT Hardware:** Z-Box V1.1 integrada mediante protocolos MQTT.

## 📁 Apps Principales
* **Biohacking App:** Bitácora de dosis, tracker de compuestos (BioRush) y registro de beneficios cognitivos.
* **Z-Box Control:** Monitoreo en tiempo real de temperatura y humedad para usuarios con hardware.

## 🛠 Instalación para Desarrollo
1. `python -m venv venv`
2. `source venv/bin/activate`
3. `pip install -r requirements.txt`
4. `python manage.py migrate`
5. `python manage.py runserver`

**Ubicación:** Santa Elena, Antioquia, Colombia.

zenergy-world/
├── manage.py
├── index.html
├── .gitignore
├── requirements.txt
├── README.md              <-- Actualizado con la nueva visión
├── core/                  <-- Configuración del proyecto Django
│   ├── settings.py
│   ├── urls.py            <-- Rutas globales (API y Admin)
│   └── wsgi.py
├── apps/                  <-- Carpeta contenedora de tus aplicaciones
│   ├── __init__.py
│   ├── biohacking/        <-- App de Bitácora, Dosis y Usuarios
│   │   ├── models.py      <-- Esquema de base de datos que diseñamos
│   │   ├── serializers.py <-- Conversión de datos para la App móvil
│   │   ├── views.py       <-- Lógica de negocio (API Endpoints)
│   │   └── urls.py
│   └── zbox/              <-- App de IoT y Hardware
│       ├── models.py      <-- Registro de módulos y lecturas de sensores
│       ├── consumers.py   <-- Lógica para recibir datos vía MQTT/Websockets
│       └── views.py
├── static/                <-- Archivos de tu Landing Page (index.html)
├── media/                 <-- Fotos de los cultivos y perfil de usuarios
└── templates/             <-- En caso de que uses vistas HTML desde Django
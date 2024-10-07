# app_movil

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Mi Enfermera Favorita - Aplicación Móvil

## Descripción
"Mi Enfermera Favorita" es una aplicación móvil que complementa la tienda de productos y servicios de enfermería, ofreciendo a los usuarios una experiencia optimizada para dispositivos móviles. Esta aplicación permite la compra, renta y reserva de productos de enfermería, y utiliza capacidades nativas como notificaciones push y acceso a funcionalidades offline.

## Objetivos
- Mejorar la accesibilidad y la experiencia del cliente.
- Ofrecer una aplicación móvil que aproveche las funcionalidades nativas de los dispositivos.
- Expandir el alcance geográfico de la tienda.
  
## Metodología de Trabajo
El desarrollo sigue la metodología ágil **Scrum**, con sprints de 2 semanas para la entrega continua de valor. Las tareas se gestionan en **Jira** y se priorizan según las necesidades del proyecto.

## Control de Versiones
Este proyecto utiliza **Git** para el control de versiones y **GitHub** como plataforma para la colaboración.

### Flujo de Trabajo Centralizado
- Todos los desarrolladores trabajan directamente en la rama principal (**main**).
- Antes de fusionar cambios en la rama principal, se crea un **Pull Request** para la revisión del código.
- Una vez aprobado el Pull Request, se fusiona en la rama `main`.

### Estrategia de Versionamiento
El proyecto utiliza una **Estrategia de Flujo de Trabajo Centralizado**:
- Todas las tareas se realizan en la rama principal (`main`).
- Las nuevas funcionalidades o correcciones se realizan en **branches** locales, que luego son revisadas y fusionadas en `main` mediante **Pull Requests**.

### Estrategia de Despliegue
La estrategia de despliegue seleccionada es **Despliegue Directo (Big Bang)**. Los cambios se despliegan de una vez en el entorno de producción después de pasar por las fases de desarrollo y staging.

### Entornos Definidos
- **Desarrollo (Development):** Entorno donde los desarrolladores trabajan en nuevas funcionalidades.
- **Staging:** Entorno de preproducción para realizar pruebas antes de desplegar en producción.
- **Producción (Production):** Entorno final donde la aplicación está disponible para los usuarios.

### CI/CD
El proyecto incluye **Integración Continua (CI)**, donde cada cambio en la rama `main` activa pruebas automáticas para asegurar la calidad del código antes del despliegue en producción.

- ## Instalación y Configuración
Para clonar este repositorio y configurarlo localmente, sigue estos pasos:

1. Clona el repositorio:
   ```bash
   git clone https://github.com/isaiale/App_Movil/tree/Main

2. Entrar en el Directorio del Proyecto
   ```bash
   -cd mi-enfermera-favorita-app

3. Instalar Dependencias
   ```bash
   -npm install

4. Ejecutar la Aplicación
   ```bash
   -npm start

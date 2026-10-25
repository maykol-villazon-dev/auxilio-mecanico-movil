# 🚗 Auxilio Mecánico Móvil

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Plataformas-Android%20%7C%20iOS-brightgreen?style=for-the-badge" alt="Plataformas" />
  <img src="https://img.shields.io/badge/Estado-En_Desarrollo-orange?style=for-the-badge" alt="Estado" />
</p>

Aplicación móvil multiplataforma diseñada para conectar a conductores en situaciones de emergencia vial con mecánicos y servicios de grúa disponibles en su zona en tiempo real.

---

### ✨ Características Principales

* 📍 **Solicitud de Auxilio en Ruta:** Petición rápida de servicios de batería, pinchaduras, remolque o mecánica ligera.
* ⚡ **Gestión de Estado Reactiva:** Implementado con el patrón **Provider** para una respuesta fluida de la interfaz de usuario.
* 🎨 **Diseño Moderno & UI/UX Adaptativa:** Soporte para modo oscuro/claro y componentes optimizados para pantallas táctiles.
* 🌐 **Arquitectura Modular Limpia:** Separación estricta de responsabilidades en `models`, `providers`, `services`, `screens` y `theme`.

---

### 📂 Estructura del Código

```text
lib/
├── constants/    # Constantes globales, colores y estilos
├── models/       # Modelos de datos y serialización JSON
├── providers/    # Lógica de estado reactivo (Provider)
├── routes/       # Enrutamiento y navegación declarativa
├── screens/      # Vistas y pantallas principales de la aplicación
├── services/     # Clientes HTTP y conexión con APIs REST
├── theme/        # Temas personalizados (Dark/Light Mode)
└── main.dart     # Punto de entrada de la aplicación

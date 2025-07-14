# Instrucciones del Sistema para Generación de Código

## 1. Principios Fundamentales del Proyecto

* **Rol:** Eres un desarrollador senior de Flutter. Tu tarea es generar código limpio, eficiente y mantenible siguiendo los patrones y la arquitectura existentes en el proyecto.
* **Arquitectura:** El proyecto utiliza **Arquitectura Limpia** (Clean Architecture) con una estricta separación de capas: `domain`, `data` y `presentation` (organizada por `features`). La regla de dependencia es sagrada: `presentation` -> `data` -> `domain`. La capa `domain` no debe tener dependencias de ninguna otra capa.
* **Stack Tecnológico Principal:**
    * **Lenguaje:** Dart con Null Safety activado.
    * **Framework:** Flutter.
    * **Gestión de Estado:** `riverpod`.
    * **Inyección de Dependencias:** `get_it` con `injectable`.
    * **Routing:** `go_router`.
    * **Modelos Inmutables:** `freezed`.
    * **Cliente HTTP:** `dio`.

## 2. Flujo de Trabajo para Nuevas Funcionalidades (Features)

Al crear una nueva funcionalidad, sigue esta estructura de directorios dentro de `lib/features/nombre_feature/`:

1.  **Capa `domain` (`lib/domain/`)**
    * **Entidades (`entities/`):** Define los objetos de negocio puros. Usa `freezed` si se requiere inmutabilidad y `copyWith`.
    * **Repositorios (`repositories/`):** Define la interfaz (clase abstracta) del repositorio.
        * Los métodos deben devolver `Future<Either<Failure, TipoDeDato>>`. `Failure` es una clase base definida en `lib/core/errors/failures.dart`.

2.  **Capa `data` (`lib/data/`)**
    * **Modelos (`models/`):** Crea modelos que extienden las entidades del dominio y añaden la lógica de serialización (`fromJson`, `toJson`) usando `json_serializable`. Deben terminar con el sufijo `Model` (e.g., `user_model.dart`).
    * **Fuentes de Datos (`datasources/`):** Implementa la lógica de obtención de datos (remotos o locales). Las fuentes de datos remotas deben usar el cliente `Dio` configurado en `lib/data/providers/api_provider.dart`.
    * **Repositorios (`repositories/`):** Crea la implementación del repositorio del `domain`. Esta clase debe inyectar las fuentes de datos necesarias.

3.  **Capa `presentation` (`lib/features/nombre_feature/presentation/`)**
    * **Riverpod (`providers/`):**
        * **Providers (`nombre_feature_provider.dart`):** Define los providers usando `StateNotifierProvider` o `NotifierProvider` según la complejidad. Implementa la lógica de negocio en clases que extienden `StateNotifier` o `Notifier`. Inyecta los repositorios (o casos de uso) necesarios.
        * **Estados (`nombre_feature_state.dart`):** Define los estados usando `freezed`. Incluye siempre un estado inicial, de carga, de éxito y de error.
    * **Páginas/Vistas (`pages/` o `screens/`):** Crea los widgets que representan pantallas completas. Utiliza `ConsumerWidget` o `Consumer` para acceder a los providers y reaccionar a los cambios de estado. El nombre del archivo debe terminar en `_page.dart`.
    * **Widgets (`widgets/`):** Crea widgets reutilizables específicos de esta funcionalidad.

## 3. Reglas y Convenciones Específicas

* **Inyección de Dependencias:** Registra **todas** las clases de repositorio y fuente de datos en el contenedor de `get_it` usando las anotaciones de `injectable` (e.g., `@injectable`, `@lazySingleton`). El fichero principal de configuración es `lib/core/di/injection.dart`. La lógica de presentación se implementa con providers de Riverpod (`StateNotifierProvider` o `NotifierProvider`), por lo que **no es necesario* **Generación de Código:** Después de añadir clases con anotaciones de `freezed`, `injectable`, `json_serializable` o `auto_route`, debes recordarme ejecutar el comando `flutter pub run build_runner build --delete-conflicting-outputs` para generar los ficheros `.g.dart`, `.freezed.dart` y `.gr.dart`.
* **Navegación:** Para crear una nueva ruta, añádela a la lista de `GoRouter` en el fichero `lib/app/routes/app_router.dart`. La navegación se realiza a través del router generado: `context.push('/turuta')`.
* **Estilo de Código:**
    * **Nombres de archivo:** `snake_case.dart`.
    * **Nombres de clase:** `UpperCamelCase`.
    * **Constantes:** Usa `const` siempre que sea posible para optimizar el rendimiento.
    * **UI:** Utiliza las definiciones de `AppTheme` que se encuentran en `lib/app/config/theme/app_theme.dart` para colores, tipografías y espaciados. No uses valores hardcodeados.
    * **Importaciones:** Organiza las importaciones en el siguiente orden: `dart:`, `package:flutter/`, `package:[otros_paquetes]`, y finalmente importaciones relativas del proyecto (`import '...';`).
* **Manejo de Errores:** En la capa `data`, captura las excepciones (`DioError`, etc.) y devuélvelas como un `Left(Failure())`. El BLoC recibirá este `Failure` y emitirá un estado de error correspondiente para que la UI lo muestre.
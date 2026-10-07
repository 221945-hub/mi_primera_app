# Práctica Nº 1 — Cuestionario

## 1. ¿Cuál es la diferencia fundamental entre un StatelessWidget y un StatefulWidget?

Un **StatelessWidget** es inmutable. Su apariencia depende solo de los parámetros que recibe en el constructor y de su contexto, y no guarda datos que cambien con el tiempo. Solo se reconstruye cuando su widget padre lo vuelve a crear con otros parámetros.

Un **StatefulWidget** está asociado a un objeto `State` que persiste entre reconstrucciones y guarda datos mutables. Cuando esos datos cambian, se llama a `setState()` y Flutter vuelve a ejecutar `build()` para reflejar el cambio.

- Ejemplo de StatelessWidget: la tarjeta de perfil del Ejercicio 2 (`Ejercicio2`, `_Estadistica`). Muestra datos fijos (nombre, estadísticas) que no cambian mientras se ve la pantalla.
- Ejemplo de StatefulWidget: el contador del Ejercicio 3 y la calculadora. El valor `_contador` o el número del display cambia cada vez que el usuario pulsa un botón.

## 2. ¿Por qué Flutter no usa componentes nativos del sistema operativo para renderizar su interfaz?

Flutter dibuja cada píxel con su propio motor gráfico (Skia, y ahora Impeller) sobre un lienzo que le entrega el sistema operativo. Esto tiene varias ventajas:

- **Consistencia:** la app se ve y se comporta igual en Android, iOS, web y escritorio, sin depender de la versión del SO ni del fabricante.
- **Rendimiento:** no hay un "puente" que traduzca cada widget a un componente nativo (como pasa en React Native). El código Dart se compila AOT a código máquina y dibuja directamente, lo que permite 60/120 fps.
- **Control total:** se pueden personalizar las animaciones, la tipografía y los efectos sin las limitaciones de los controles nativos.
- **Hot Reload:** como toda la UI vive en el framework, se puede recargar en milisegundos sin recompilar código nativo.

La desventaja es que los widgets no son los "reales" del sistema. Por eso Flutter imita su aspecto con Material (Android) y Cupertino (iOS), y el tamaño de la app es un poco mayor porque incluye el motor.

## 3. Explique qué hace el comando `flutter doctor` y para qué sirve cada sección de su resultado.

`flutter doctor` revisa el entorno de desarrollo y muestra, por categorías, qué está bien instalado (`[√]`), qué tiene advertencias (`[!]`) y qué falta (`[X]`). Con `-v` muestra los detalles (rutas y versiones).

| Sección | Qué verifica |
|---|---|
| **Flutter** | Versión y canal del SDK (stable/beta), ruta de instalación y versión de Dart. |
| **Windows Version** | Que el sistema operativo sea compatible. |
| **Android toolchain** | Android SDK, build-tools, plataformas, cmdline-tools, JDK y que las licencias de Android estén aceptadas (`flutter doctor --android-licenses`). |
| **Chrome** | Navegador para ejecutar apps Flutter Web (opcional si solo se desarrolla para móvil). |
| **Visual Studio** | Herramientas de C++ para compilar apps de escritorio Windows (opcional para móvil). |
| **Android Studio** | IDE detectado y sus plugins de Flutter y Dart (en versiones recientes puede no aparecer). |
| **Connected device** | Dispositivos donde se puede ejecutar la app: emuladores, teléfonos por USB, navegador o escritorio. |
| **Network resources** | Que haya conexión a los servidores de Google, pub.dev y GitHub para descargar paquetes y artefactos. |

Sirve para diagnosticar rápidamente por qué un proyecto no compila o no encuentra un dispositivo.

## 4. ¿Qué sucede internamente cuando se llama `setState()`?

1. Se ejecuta de forma síncrona la función que se le pasa (por ejemplo, `_contador++`), que modifica el estado.
2. El `Element` asociado a ese `State` se marca como **"dirty"** (sucio) y se agenda un nuevo frame.
3. En el siguiente frame, el framework recorre los elementos sucios y vuelve a llamar a su método `build()`. Esto genera un nuevo subárbol de **widgets**, que son objetos ligeros e inmutables.
4. **Reconciliación:** Flutter compara el nuevo árbol de widgets con el anterior usando el tipo y la `key` de cada widget. Si coinciden, reutiliza el `Element` y actualiza su configuración. Si no, lo desmonta y crea uno nuevo.
5. Los `RenderObject` que realmente cambiaron se marcan para **layout** y/o **paint**. Solo esos se vuelven a medir y dibujar.
6. El motor (Skia/Impeller) compone las capas y muestra el frame en pantalla.

Flutter mantiene tres árboles: **Widget** (la configuración), **Element** (las instancias montadas, que conservan el estado) y **RenderObject** (el layout y el dibujo). Por eso reconstruir widgets es barato: solo se rehace el trabajo costoso en lo que cambió.

## 5. ¿Cuál es la diferencia entre Hot Reload y Hot Restart?

| | Hot Reload | Hot Restart |
|---|---|---|
| Qué hace | Inyecta el código Dart modificado en la VM en ejecución y vuelve a ejecutar `build()` | Recompila y reinicia la app desde `main()` |
| Estado | **Se conserva** (por ejemplo, el valor del contador) | **Se pierde**: la app vuelve a su estado inicial |
| Velocidad | Menos de 1 segundo | Unos pocos segundos |
| Cuándo usarlo | Cambios de UI, estilos o lógica dentro de `build()` | Cambios en `main()`, inicializadores de variables globales o estáticas, `initState()`, enums o tipos genéricos |
| Atajo | `r` en la terminal, o guardar (Ctrl+S) en el IDE | `R` en la terminal, o Ctrl+Shift+\ en Android Studio |

Ninguno de los dos sirve para cambios en código nativo (Kotlin/Swift), en `pubspec.yaml` con plugins nativos ni en archivos de Gradle. En esos casos hay que detener la app y volver a ejecutarla.

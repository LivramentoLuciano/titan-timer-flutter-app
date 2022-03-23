# Titan Timer Flutter App ⏱💪

Este repositorio contiene la app desarrollada en Flutter para **Titan Timer**.

La funcionalidad principal de esta app es la de **permitir la configuración de una rutina de entrenamiento** a realizar, en cuanto a los **tiempos y cantidades de repeticiones**, la cual se comunicará a un **cronómetro físico** dispuesto en el gimnasio **via Bluetooth**.

## Features
- Tiempo de trabajo/descanso
- Cantidad de repeticiones (rounds/sets)
- Control del temporizador: Play/Pause/Stop
- Visualización en Cronómetro real via Bluetooth

## Screenshots
Menú  principal

![Home Menu](https://github.com/LivramentoLuciano/titan-timer-flutter-app.git/screenshots/Home_Menu.jpg)

Configuración de la rutina

![Routine Configuration](https://github.com/LivramentoLuciano/titan-timer-flutter-app.git/screenshots/Routine_Configuration.jpg)

Control bluetooth

![Home Menu](https://github.com/LivramentoLuciano/titan-timer-flutter-app.git/screenshots/Routine_Playing.jpg)

## ToDo's
Cabe mencionar que no logré hacer funcionar en segundo plano al 'timer' de Flutter (por tanto si el teléfono se bloquea o se deja inactiva la app por un tiempo, dejará de funcionar el temporizador), por esta razón se realizó la versión *control*, queda analizar, en un futuro, realizar una versión *full* 
    
- **Versión "Control" (DONE):** Permite realizar todas las configuraciones del entrenamiento mencionadas, pero NO incluye la visualización del tiempo del cronómetro en la app, funcionando como un control remoto Bluetooth del Cronómetro real (pausar, reanudar, terminar)
- **Versión "Full":** Adicional a la anterior, muestra en pantalla el tiempo del cronómetro (pero, con las herramientas que tengo ahora, dejaría de funcionar si queda inactiva la app)

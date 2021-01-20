# Titan Timer Flutter App

Este repositorio contiene la app desarrollada en Flutter para <b>Titan Timer</b> ⏱.

Contiene tanto la aplicacion principal (y sus versiones) como pruebas modulares sobre distintas funcionalidades.

<br />

## Description
La funcionalidad principal de esta app es la de <b>permitir la configuración de una rutina de entrenamiento</b> físico a realizar, en cuanto a los <b>tiempos y cantidades de repeticiones</b>, la cual se comunicará a un <b>cronómetro físico</b> dispuesto en el gimnasio <b>via Bluetooth</b>.

## Features
<ul>
    <li> Tiempo de trabajo/descanso </li>
    <li> Cantidad de repeticiones (rounds/sets) </li>
    <li> Control del temporizador: Play/Pause/Stop </li>
    <li> Visualización en Cronómetro real via Bluetooth </li>
</ul>

### Versions
Cabe mencionar que se realizaron 2 versiones, por una cuestión de que no logré hacer funcionar en segundo plano al 'timer' de Flutter (esto hacía que si el teléfono se bloquea o se deja inactiva la app por un tiempo, dejará de funcionar el temporizador):

<ol>
    <li>
        <b>Versión "Control"</b>:<br />
        Permite realizar todas las configuraciones del entrenamiento mencionadas, pero NO incluye la visualización del tiempo del cronómetro en la app, funcionando como un control remoto Bluetooth del Cronómetro real (pausar, reanudar, terminar)
    </li>
    <li>
        <b>Versión "Full"</b>:<br />
        Adicional a la anterior, muestra en pantalla el tiempo del cronómetro (pero dejará de funcionar si se deja inactiva la app)
    </li>
</ol>
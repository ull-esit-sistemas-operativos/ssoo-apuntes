sequenceDiagram
    autonumber
    participant UserThread1 as Hilo 1<br>de usuario
    participant Kernel as Núcleo
    participant UserThread Library as Librería de<br>hilos de usuario
    participant UserThread2 as Hilo 2<br>de usuario


    UserThread1 ->>+ Kernel: read()<br>(Operación de E/S)
    Note right of Kernel: "Hilo 1" bloqueado
    Kernel -)+ UserThread Library: Activación<br>del planificador<br>[nuevo hilo de núcleo]
    deactivate Kernel
    UserThread Library -)- UserThread2: Iniciar ejecución<br>en el nuevo hilo<br>de núcleo
    Note left of UserThread2:"Hilo 2" se ejecuta mientras<br>"Hilo 1" espera por la E/S
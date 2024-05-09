# flutter_Bluetooth_applicationnn

APLICACIÓN CARDIO TRACKER

Se desarrolló una aplicación cuya finalidad es mostrar la frecuencia cardíaca,
así como alertar al usuario cuando la frecuencia baje de 50 latidos por minuto 
y cuando esté por encima de los 140 latidos por minuto. Su uso está considerado 
para personas en estado de resposo. 

El funcionamiento es el siguiente:
1. Entrada del sensor óptico de pulsos cardíacos: Un LED infrarrojo emite luz 
y un fototransistor se utiliza para detectar cambios fotopletismográficos a partir de
la luz recibidad. Estos cambios están relacionados con la cantidad de sangre presente 
en los vasos sanguíneos del dedo, que varía con cada latido del corazón.
2. Proceso de detección con Arduino: Se utiliza un microcontrolador Arduino Uno para 
procesar la señal analógica generada por el sensor óptico. El código del Arduino 
está diseñado para calcular la frecuencia cardíaca del usuario basándose en los 
cambios fotopletismográficos detectados cada 15 segundos. 
3. Transformación de la señal analógica a digital: El Arduino convierte la señal 
analógica del sensor en una señal digital por medio del ADC. 
4. Envío de datos vía Bluetooth con módulo HC-06: Una vez que la frecuencia 
cardíaca ha sido calculada, los datos se envían a un dispositivo móvil mediante 
un módulo Bluetooth (HC-06). Esto permite la visualización de la frecuencia cardíaca e
en la aplicación móvil.

Link al video: https://drive.google.com/file/d/1Q3-xYH3dY4dMwMeIAGFy2AsEzRq7_B4M/view?usp=sharing
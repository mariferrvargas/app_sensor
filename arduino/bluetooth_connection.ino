#include <SoftwareSerial.h>
SoftwareSerial bluetooth(2,3); //RX, TX
int val;
void setup()  { 
  Serial.begin(9600);    // inicia el puerto serial para comunicacion con el módulo Bluetooth
  bluetooth.begin(9600); // start bluetooth communication at 9600bps
} 
void loop()  {
  val = analogRead(A0)/4;     // read the input pin
  if (val > 250) {
    val = 250;
  }
  bluetooth.println(val);
  delay(10);
}
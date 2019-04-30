//Instalar libreria "oscP5"
import oscP5.*;
import netP5.*;
//Instalar libreria "Open CV"
import gab.opencv.*;
//Instalar libreria "Video"
import processing.video.*;
import java.awt.*;

//Declaracion del objeto 'video' para la captura de video
Capture video;
//Declaracion del objeto 'opencv' para el reconocimiento en OpenCV
OpenCV opencv;
//Declaración del objeto 'oscp5' para transmisión con OscP5 
OscP5 oscP5;
//Declaración del objeto 'miDirección' para protocolo de transmisión
NetAddress miDireccion; 
NetAddress miDireccion2; 

void setup() {
  size(640,480);
  //Inicialización de instancias
  
  oscP5 = new OscP5(this,8000);
  //Se asignan las direcciones de red NetAddress(DireccionIP, Puerto)
  miDireccion = new NetAddress("127.0.0.1",5555);
  //Argumentos requeridos por el objeto: (this, ancho del video, alto del video)
  //Alto y ancho deben ser multiplos de formato adecuado
  video = new Capture(this, width, height);
  //Argumentos requeridos por el objeto: (this, ancho del video, alto del video)
////Deben ser las mismas medidas que el anterior para mantener la proporcion
  opencv = new OpenCV(this, width, height);
  //Declaracion del objeto a identificar
  
  //Identifica cara de frente
  //opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  
  //Identifica cara de perfil
  //opencv.loadCascade(OpenCV.CASCADE_PROFILEFACE);
  
  //Identifica parte superior del cuerpo
  //opencv.loadCascade(OpenCV.CASCADE_UPPERBODY);
  
  //Identifica la nariz
  opencv.loadCascade(OpenCV.CASCADE_NOSE);
  
  //Identifica los ojos
  //opencv.loadCascade(OpenCV.CASCADE_EYE);
  
  //Identifica la boca
  //opencv.loadCascade(OpenCV.CASCADE_MOUTH);
  
  //Comienza a grabar
  video.start();
}

void draw() {
  //Escala el video por la proporcion dentro del argument
  //scale(proporcion en X, proporcion en Y);
  scale(1, 1);
  //Muestra el video en la pantalla
  opencv.loadImage(video);
  image(video, 0, 0 );
  //Parametros para el rectangulo de identificacion
  noFill();
  stroke(0, 255, 180);
  strokeWeight(3);
  //Dibuja rectangulos en las partes identificadas
  Rectangle[] faces = opencv.detect();
  for (int i = 0; i < faces.length; i++) {
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    //Manda mensajes OSC
    OscMessage miMensaje = new OscMessage("/xy");
    miMensaje.add((float)faces[i].x);
    miMensaje.add((float)faces[i].y);
    //Funcion para enviar los mensajes (Mensaje, odjeto de la transmisión)
    oscP5.send(miMensaje,miDireccion);
  }
}

//Funcion necesaria para grabar continuamente
void captureEvent(Capture c) {
  c.read();
}


//Funcion que se ejecuta cuando el programa detecta 
//que se recibe un mensaje
//Imprime el mensaje en la consola
void oscEvent(OscMessage elMensajeOsc) {
  elMensajeOsc.print();
}

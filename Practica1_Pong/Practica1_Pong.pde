import ddf.minim.*;

int px, py;  //coordenada de pelota
int vx, vy;  //velocidad de la pelota
int jx_der,jx_izq, jy;  //coordenada rectangulo
int flagStarted;
int golesDerecha=0;
int golesIzquierda=0;
int ancho = 20;
int alto = 60;
int posicion_linea_x;
int posicion_linea_y;
int cuentaRebote = 0;
PFont f;
Minim soundengine;
AudioSample sonido1;
AudioSample sonido2;
AudioSample sonido3;

int backgroundMusic=1;

void setup() {
  size(700, 600);
  fill(255);
  noStroke();
  px=width/2-2;
  py=height/2;
  f = createFont("bit5x3.ttf", 128);
  textFont(f);
  soundengine = new Minim(this);
  sonido1 = soundengine.loadSample("intro.mp3", 1024);
  sonido1.trigger();
  sonido2 = soundengine.loadSample("background.mp3", 1024);
  sonido3 = soundengine.loadSample("rebote.mp3", 1024);
  pelotaAleatoria();
  
  posicion_linea_x = width/2-5;
  posicion_linea_y = height/20;

  jx_der=(int) (width*0.8);
  jx_izq = (int) (width*0.15);
  jy = (height/2)-20;
  
  flagStarted=0;
  
}

void draw() {
    background(0);
    ellipse(px, py, 20, 20); //(coordenada x, coordenada y, ancho, alto)
    rect(jx_der, mouseY,ancho,alto);
    rect(jx_izq,jy,ancho,alto);
    text(golesDerecha, width/2+100, 120);
    text(golesIzquierda, width/2-150, 120);
    for(int i = 0; i<60; i++){
      rect(posicion_linea_x, posicion_linea_y,5,5);
      posicion_linea_y +=10;
    }
      posicion_linea_y = height/20;
      if(keyPressed){
      
      if(key=='s'){
       jy=jy+10; 
      } else if(key=='w'){
       jy=jy-10;
      } else if(key==' '){
        flagStarted=1;
      }
    }
    
    if (jy > height-60){
      jy=height-60;
    } else if (jy < 0){
      jy=0;
    }
  
  
  if( flagStarted==1){

    sonido1.stop();
    musicStarts();
    
    if(cuentaRebote >6){
      if(vx<0){
        vx = vx-1;
      } else {
        vx = vx+1;
      }
       cuentaRebote=0;
    }
    
    /*magnitud=(int) sqrt(pow(jug_der_x,2)+pow(jug_der_y,2));
    
    if ((vx>0 && px>jx_der && magnitud<50)){
            vx=-vx;
    }*/
    
    
    
    if ((vx>0 && px+20>=jx_der && jx_der+ancho > px && mouseY <= py+20 && mouseY+alto > py )){  //Colision Rectangulo (linea) con circulo (pelota)
            vx=-vx;
            vy= (int) random(-5,5);
            sonido3.trigger();
            cuentaRebote++;
    }
    
    /*magnitud=(int) sqrt(pow(jug_izq_x,2)+pow(jug_izq_y,2));
    if ((vx<0 && px < (width*0.15)+ancho && magnitud<50)){
        vx=-vx;
    }*/

    if ((vx<0 && px+20 >=jx_izq && jx_izq+ancho > px && jy <= py+20 && jy+alto > py )){  //Colision Rectangulo (linea) con circulo (pelota)
            vx=-vx;
            vy= (int) random(-5,5);
            sonido3.trigger();
            cuentaRebote++;
    }
    
    //Controlar propiedades de la pelota
      px=px+vx;
    if (px>width) {
      golesIzquierda=golesIzquierda+1;
      flagStarted=0;
    } else if (px<0){
      golesDerecha=golesDerecha+1;
      flagStarted=0;
    }
    
    if(flagStarted==0){
        px=width/2;
        py=(width/2)-20;
        jy=(height/2)-20;
        backgroundMusic=1;
        sonido2.stop();
        sonido1.trigger();
        pelotaAleatoria();
    }
    
    py=py+vy;
    if (py>height || py < 0) {
      vy=-vy;
      sonido3.trigger();
    }   
  }
}


  void pelotaAleatoria(){ 
    if((int) random(0,10) %2 ==0){
      vx=5;  //Sale hacia la derecha
    } else {
      vx=-5;  //Sale hacia la izquierda
    }
    
    vy=(int) random(-5,5);  //Sale diagonalmente arriba o abajo, o recto
  }
  
  
  void musicStarts(){
    
    if(backgroundMusic==1){
      sonido2.trigger();
      backgroundMusic=0;
    }
  
  }
  

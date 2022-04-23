float dt = 1/20.0;
float masa = 1.0;
float g = -9.8;
int r = 15;
float t = dt;
 
PVector posIni, posSol, posEul, posHeun1, posHeun2, posRK2, posRK4_1, posRK4_2, posRK4_3, posRK4_4;
PVector vIni, vSol, vEul, vHeun1, vHeun2, vRK2_1, vRK2_2, vRK4_1, vRK4_2, vRK4_3, vRK4_4, vRK4_sum;
PVector acc;
 
void setup() {
  size(600, 600);
  background(255);
   
  posIni = new PVector(width*0.2, height*0.8);
  posSol = new PVector(0, 0);
  posEul = new PVector(0, 0);
  posHeun1 = new PVector(0, 0);
  posHeun2 = new PVector(0, 0);
  posRK2 = new PVector(0, 0);
  posRK4_1 = new PVector(0, 0);
  posRK4_2 = new PVector(0, 0);
  posRK4_3 = new PVector(0, 0);
  posRK4_4 = new PVector(0, 0);
   
  vIni = new PVector(30, -70);
  vSol = new PVector(vIni.x, vIni.y);
  vEul = new PVector(vIni.x, vIni.y);
  vHeun1 = new PVector(vIni.x, vIni.y);
  vHeun2 = new PVector(vIni.x, vIni.y);
  vRK2_1 = new PVector(vIni.x, vIni.y);
  vRK2_2 = new PVector(vIni.x, vIni.y);
  vRK4_1 = new PVector(vIni.x, vIni.y);
  vRK4_2 = new PVector(vIni.x, vIni.y);
  vRK4_3 = new PVector(vIni.x, vIni.y);
  vRK4_4 = new PVector(vIni.x, vIni.y);
   
  // Consideramos una única aceleración constante en todos los casos
  acc = new PVector(0, -masa*g);
}
 
void draw() {
  noStroke();
  translate(posIni.x, posIni.y);
   
  // Solución: negro
  posSol.x = vSol.x * t;
  posSol.y = -0.5 * g * t * t + vSol.y * t;
   
  fill(0);
  ellipse(posSol.x, posSol.y, r, r);
   
  // Euler explícito: rojo
  posEul = PVector.add(PVector.mult(vEul, dt), posEul);
  vEul = PVector.add(PVector.mult(acc, dt), vEul);
   
  fill(255, 0, 0);
  ellipse(posEul.x, posEul.y, r, r);  
   
  // Heun: verde
  posHeun2 = PVector.add(PVector.mult(vHeun1, dt), posHeun1);
  vHeun2 = PVector.add(PVector.mult(acc, dt), vHeun1);
  posHeun1 = PVector.add(PVector.mult(PVector.add(vHeun1, vHeun2), dt/2), posHeun1);
  vHeun1 = PVector.add(PVector.mult(PVector.add(acc, acc), dt/2), vHeun1);
   
  fill(0, 255, 0);
  ellipse(posHeun1.x, posHeun1.y, r, r);
    
  // RK2: azul
  vRK2_2 = PVector.add(PVector.mult(acc, dt/2), vRK2_1);
  posRK2 = PVector.add(PVector.mult(vRK2_2, dt), posRK2);
  vRK2_1 = PVector.add(PVector.mult(PVector.add(acc, acc), dt/2), vRK2_1);
   
  fill(0, 0, 255);
  ellipse(posRK2.x, posRK2.y, r, r);
   
  // Runge Kutta K4
  posRK4_2 = PVector.add(PVector.mult(vRK4_1, dt/2), posRK4_1);
  vRK4_2 = PVector.add(PVector.mult(acc, dt/2), vRK4_1);
  posRK4_3 = PVector.add(PVector.mult(vRK4_2, dt/2), posRK4_1);
  vRK4_3 = PVector.add(PVector.mult(acc, dt/2), vRK4_1);
  posRK4_4 = PVector.add(PVector.mult(vRK4_3, dt), posRK4_1);
  vRK4_4 = PVector.add(PVector.mult(acc, dt), vRK4_1);
  vRK4_sum = PVector.add(PVector.add(PVector.mult(vRK4_2, 2), PVector.add(PVector.mult(vRK4_3, 2), vRK4_4)), vRK4_1);
  posRK4_1 = PVector.add(PVector.mult(vRK4_sum, dt/6), posRK4_1);
  vRK4_1 = PVector.add(PVector.mult(acc, dt), vRK4_1);
   
  fill(255, 150, 0);
  ellipse(posRK4_1.x, posRK4_1.y, r, r);
   
  // Errores
  fill(255);
  rect(0, -500, 300, 200);
  textSize(16);
  fill(255, 0, 0);
  text("Error Euler: " + str(posEul.mag() - posSol.mag()), 0, -450);
  fill(0, 255, 0);
  text("Error Heun: " + str(posHeun1.mag() - posSol.mag()), 0, -430);
  fill(0, 0, 255);
  text("Error RK2: " + str(posRK2.mag() - posSol.mag()), 0, -410);
  fill(255, 150, 0);
  text("Error RK4: " + str(posRK4_1.mag() - posSol.mag()), 0, -390);
   
  if (posSol.y <= 0) {
    t += dt;
  } else {
    dt = 0.0;
  }
}
 
void keyPressed() {
  if (key == ' ') {
    //Reiniciar
    dt = 1/20.0;
    t = dt;
    background(200);
    posSol = new PVector(0, 0);
    posEul = new PVector(0, 0);
    posHeun1 = new PVector(0, 0);
    posHeun2 = new PVector(0, 0);
    posRK2 = new PVector(0, 0);
    posRK4_1 = new PVector(0, 0);
    posRK4_2 = new PVector(0, 0);
    posRK4_3 = new PVector(0, 0);
    posRK4_4 = new PVector(0, 0);
    vSol = new PVector(vIni.x, vIni.y);
    vEul = new PVector(vIni.x, vIni.y);
    vHeun1 = new PVector(vIni.x, vIni.y);
    vHeun2 = new PVector(vIni.x, vIni.y);
    vRK2_1 = new PVector(vIni.x, vIni.y);
    vRK2_2 = new PVector(vIni.x, vIni.y);
    vRK4_1 = new PVector(vIni.x, vIni.y);
    vRK4_2 = new PVector(vIni.x, vIni.y);
    vRK4_3 = new PVector(vIni.x, vIni.y);
    vRK4_4 = new PVector(vIni.x, vIni.y);
  }
}

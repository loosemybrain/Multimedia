//Class for cubes floating in space
class Cube {
  //Z position of spawn and maximum Z position
  float startingZ = -10000;
  float maxZ = 1000;
  
  //Position values
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  
  //Constructor
  Cube() {
    //Make the cube appear in a random place
    x = random(0, width);
    y = random(0, height);
    z = random(startingZ, maxZ);
    
    //random rotation for cubes
    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
  }
  
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    // Selection of the color, opacity determined by the intensity (volume of the band)
    color displayColor = color(scoreLow*random(0,1), scoreMid*random(0,1), scoreHi*random(0,1), intensity*10);
    fill(displayColor, 255);
    
    //Color lines, they disappear with the individual intensity of the cube
    color strokeColor = color(255, 150-(20*intensity));
    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/800));
    
    //Creating a transformation matrix to perform rotations, sizing
    pushMatrix();
    
    //displacement
    translate(x, y, z);
    
    //Calculation of the rotation according to the intensity for the cube
    sumRotX += intensity*(rotX/1000);
    sumRotY += intensity*(rotY/1000);
    sumRotZ += intensity*(rotZ/1000);
    
    //Application of the rotation
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    //Creation of the box, variable size according to the intensity for the cube
    box(100+(intensity/2));
    
    //Application of the matrix
    popMatrix();
    
    //Z displacement
    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));
    
    //Replace the box at the back when it is no longer visible
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = startingZ;
    }
  }
}

//Class for sphere floating in space
class Sphere {
  //Z position of spawn and maximum Z position
  float startingZ = -10000;
  float maxZ = 1000;
  
  //Position values
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  
  //Constructor
  Sphere() {
    //Make the cube appear in a random place
    x = random(0, width);
    y = random(0, height);
    z = random(startingZ, maxZ);
    
    //random rotation for cubes
    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
  }
  
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    // Selection of the color, opacity determined by the intensity (volume of the band)
    color displayColor = color(scoreLow*random(0,1), scoreMid*random(0,1), scoreHi*random(0,1), intensity*10);
    fill(displayColor, 255);
    
    //Color lines, they disappear with the individual intensity of the cube
    color strokeColor = color(255, 150-(20*intensity));
    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/800));
    
    //Creating a transformation matrix to perform rotations, sizing
    pushMatrix();
    
    //displacement
    translate(x, y, z);
    
    //Calculation of the rotation according to the intensity for the cube
    sumRotX += intensity*(rotX/1000);
    sumRotY += intensity*(rotY/1000);
    sumRotZ += intensity*(rotZ/1000);
    
    //Application of the rotation
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    sphere(50+(intensity/2));
    
    //Application of the matrix
    popMatrix();
    
    //Z displacement
    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));
    
    //Replace the box at the back when it is no longer visible
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = startingZ;
    }
  }
}

//Class for cubes floating in space
class Triangle {
  //Z position of spawn and maximum Z position
  float startingZ = -10000;
  float maxZ = 1000;
  
  //Position values
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  
  //Constructor
  Triangle() {
    //Make the cube appear in a random place
    x = random(0, width);
    y = random(0, height);
    z = random(startingZ, maxZ);
    
    //random rotation for cubes
    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
  }
  
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    // Selection of the color, opacity determined by the intensity (volume of the band)
    color displayColor = color(scoreLow*random(0,1), scoreMid*random(0,1), scoreHi*random(0,1), intensity*10);
    fill(displayColor, 255);
    
    //Color lines, they disappear with the individual intensity of the cube
    color strokeColor = color(255, 150-(20*intensity));
    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/800));
    
    //Creating a transformation matrix to perform rotations, sizing
    pushMatrix();
    
    //displacement
    translate(x, y, z);
    
    //Calculation of the rotation according to the intensity for the cube
    sumRotX += intensity*(rotX/1000);
    sumRotY += intensity*(rotY/1000);
    sumRotZ += intensity*(rotZ/1000);
    
    //Application of the rotation
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
        // creation of pyramid
    beginShape();
    vertex(-100, -100, -100);
    vertex( 100, -100, -100);
    vertex(   0,    0,  100);
    
    vertex( 100, -100, -100);
    vertex( 100,  100, -100);
    vertex(   0,    0,  100);
    
    vertex( 100, 100, -100);
    vertex(-100, 100, -100);
    vertex(   0,   0,  100);
    
    vertex(-100,  100, -100);
    vertex(-100, -100, -100);
    vertex(   0,    0,  100);
    endShape();
    
    fill(displayColor, 255);
    
    //Application of the matrix
    popMatrix();
    
    //Z displacement
    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));
    
    //Replace the box at the back when it is no longer visible
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = startingZ;
    }
  }
}

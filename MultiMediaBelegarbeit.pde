import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer song;
FFT fft;

//color intensity
float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.2;   // 20%

float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

float scoreDecreaseRate = 30;

int nbCubes;
Cube[] cubes;

int nbSpheres;
Sphere[] spheres;

int nbTriangles;
Triangle[] triangles;
 
// creat wall-lines
int nbWalls = 1000;
Wall[] walls;

void setup()
{
  //Anzeige in 3D auf dem gesamten Bildschirm
  fullScreen(P3D);
 
  //import Minim-library 
  minim = new Minim(this);
 
  //load Song
  song = minim.loadFile("emerge.mp3");
  
  //Erstellen des FFT-Objekts, um den Song zu analysieren
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  //one cube pro Frequenzband
  nbCubes = (int)(fft.specSize()*specHi);
  cubes = new Cube[nbCubes];
  println("nbCubes: " + nbCubes);
  
  nbSpheres = (int)(fft.specSize()*specMid);
  spheres = new Sphere[nbSpheres];
  println("nbSpheres: " + nbSpheres);
      
  //create walls
  walls = new Wall[nbWalls];

  //create cubes
  for (int i = 0; i < nbCubes; i++) {
   cubes[i] = new Cube(); 
  }
  
    //Create the Sphere objects
  for (int i = 0; i < nbSpheres; i++) {
   spheres[i] = new Sphere(); 
  }
  
  //Create the Triangle objects
  for (int i = 0; i < nbTriangles; i++) {
   triangles[i] = new Triangle(); 
  }
  
  //create wall objects
  //left wall
  for (int i = 0; i < nbWalls; i+=4) {
   walls[i] = new Wall(0, height/2, 10, height); 
  }
  
  //right wall
  for (int i = 1; i < nbWalls; i+=4) {
   walls[i] = new Wall(width, height/2, 10, height); 
  }
  
  //wall bottom
  for (int i = 2; i < nbWalls; i+=4) {
   walls[i] = new Wall(width/2, height, width, 10); 
  }
  
  //wall top
  for (int i = 3; i < nbWalls; i+=4) {
   walls[i] = new Wall(width/2, 0, width, 10); 
  }
  
  //background black
  background(0);
  
  //start the song
  song.play(0);
}

void draw()
{
  //Lied weiterleiten Ein Draw() für jeden "Frame" des Songs ...
  fft.forward(song.mix);
  
  //Berechnung von "Scores" (Leistung) für drei Klangkategorien
  //Zuerst alte Werte speichern
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;
  
  //reset values
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;
 
  //Calculate the new "scores"
  for(int i = 0; i < fft.specSize()*specLow; i++)
  {
    scoreLow += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++)
  {
    scoreMid += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++)
  {
    scoreHi += fft.getBand(i);
  }
  
  //den Abstieg verlangsamen
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }
  
  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }
  
  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }
  
  //Volume for all frequencies at this time
  //This allows the animation to go faster for the higher-pitched sounds, which is more noticeable (auffaeliger)
  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
  
  //discreet color of the background
  background(scoreLow/100, scoreMid/100, scoreHi/100);
   
  //Cube for each frequency band
  for(int i = 0; i < nbCubes; i++)
  {
    //Value of the frequency band
    float bandValue = fft.getBand(i);
    
  //Opacity is determined by the volume of the tape and the overall volume.
    cubes[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
  
    //Cube for each frequency band
  for(int i = 0; i < nbSpheres; i++)
  {
    //Value of the frequency band
    float bandValue = fft.getBand(i);
    
  //Opacity is determined by the volume of the tape and the overall volume.
    spheres[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
  
  for(int i = 0; i < nbTriangles; i++)
  {
    //Value of the frequency band
    float bandValue = fft.getBand(i);
    
  //Opacity is determined by the volume of the tape and the overall volume.
    triangles[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
  
  
  
  //Wall-lines, here we keep the value of the previous band and the next to connect them together
  float previousBandValue = fft.getBand(0);
  
  //Distance between each line point, negative because on the z dimension
  float dist = -50;
  
  //Multiply the height by this constant
  float heightMult = 0.2;
  
  //For each band
  for(int i = 1; i < fft.specSize(); i++)
  {
    //Value of the frequency band, we multiply the bands farther to make them more visible.
    float bandValue = fft.getBand(i)*(1 + (i/10));
    
    //Selection of the color according to the forces of the different types of sounds
    stroke(100+scoreLow, 100+scoreMid, 100+scoreHi, 127-i);
    strokeWeight(1 + (scoreGlobal/200));
    
    ////bottom left line
    line(0, height-(previousBandValue*heightMult), dist*(i-1), 0, height-(bandValue*heightMult), dist*i);
    line((previousBandValue*heightMult), height, dist*(i-1), (bandValue*heightMult), height, dist*i);
    line(0, height-(previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), height, dist*i);
    
    ////top left line
    line(0, (previousBandValue*heightMult), dist*(i-1), 0, (bandValue*heightMult), dist*i);
    line((previousBandValue*heightMult), 0, dist*(i-1), (bandValue*heightMult), 0, dist*i);
    line(0, (previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), 0, dist*i);
    
    //bottom right line
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width, height-(bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), height, dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    
    //top right line
    line(width, (previousBandValue*heightMult), dist*(i-1), width, (bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), 0, dist*(i-1), width-(bandValue*heightMult), 0, dist*i);
    line(width, (previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), 0, dist*i);
    
    //Save the value for the next loop round
    previousBandValue = bandValue;
  }
  
  //Wall rectangles
  for(int i = 0; i < nbWalls; i++)
  {
    //Each wall is assigned a band, and its strength is sent to it.
    float intensity = fft.getBand(i%((int)(fft.specSize()*specHi)));
    walls[i].display(scoreLow, scoreMid, scoreHi, intensity, scoreGlobal);
  }
}

//Class to display the lines on the sides
class Wall {
  //Z position of spawn and maximum Z position
  float startingZ = -10000;
  float maxZ = 50;
  
  //Position values
  float x, y, z;
  float sizeX, sizeY;
  
  //Constructor
  Wall(float x, float y, float sizeX, float sizeY) {
    //Make the line appear at the specified place
    this.x = x;
    this.y = y;
    //Random depth
    this.z = random(startingZ, maxZ);  
    
    //determine the size because the walls on the floors have a different size than those on the sides
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  
  //Display function
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    //Color determined by low, medium and high sounds
    //Opacity determined by the overall volume
    color displayColor = color(scoreLow*random(0, 0.3), scoreMid*random(0, 0.6), scoreHi*random(0, 1), scoreGlobal);
    
    //lines disappear in the distance to give an illusion of fog
    fill(displayColor, ((scoreGlobal-5)/1000)*(255+(z/25)));
    noStroke();
    
    //First band, the one that moves according to the force
    //transformation matrix
    pushMatrix();
    
    //displacement
    translate(x, y, z);
    
    //extension
    if (intensity > 100) intensity = 100;
    scale(sizeX*(intensity/100), sizeY*(intensity/100), 20);
    
    //Creation of the "box"
    box(1);
    popMatrix();
    
    //Second band, the one with the same size
    displayColor = color(scoreLow*0.5, scoreMid*0.5, scoreHi*0.5, scoreGlobal);
    fill(displayColor, (scoreGlobal/5000)*(255+(z/25)));

    pushMatrix();
    
    translate(x, y, z);

    scale(sizeX, sizeY, 10);

    box(1);
    popMatrix();
    
    //Z displacement
    z+= (pow((scoreGlobal/150), 2));
    if (z >= maxZ) {
      z = startingZ;  
    }
  }
}

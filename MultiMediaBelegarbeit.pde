import g4p_controls.*;

import ddf.minim.*;
import ddf.minim.analysis.*;

import java.awt.Font;

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

String file = "emerge.mp3";
boolean game_running = false;

int varCubes;
Cube[] cubes;

int varSpheres;
Sphere[] spheres;

int varTriangles;
Triangle[] triangles;
 
PFont font;


void setup()
{
  fullScreen(P3D);
  
  createGUI();
  mygui();
  
  //background black
  background(0);
  
  //start the song
  //song.play(0);
}

void draw()
{
  if (game_running) {
    //1 draw() for each "frame" of the song ...
    fft.forward(song.mix);
    
    labelSong.draw();
        
    //calculate the "Scores" (Power) for three sound categories
    //First save old values
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
  
  //slow down the descent
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
  //This allows the animation to go faster for the higher-pitched sounds, which is more noticeable
  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
  
  //discreet color of the background
  background(scoreLow/100, scoreMid/100, scoreHi/100);
   
  //Cube for each frequency band
  for(int i = 0; i < varCubes; i++)
  {
    //Value of the frequency band
    float bandValue = fft.getBand(i);
    
    //Opacity is determined by the volume of the tape and the overall volume.
    cubes[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
  
  //Sphere for each frequence band
  for(int i = 0; i < varSpheres; i++)
  {
    //Value of the frequence band
    float bandValue = fft.getBand(i);
    
    //Opacity is determined by the volume of the tape and the overall volume.
    spheres[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
    
  //for(int i = 0; i < varTriangles; i++)
  //{
  //  //Value of the frequency band
  //  float bandValue = fft.getBand(i);
    
  //  //Opacity is determined by the volume of the tape and the overall volume.
  //  triangles[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  //}
  
  
  
  //we keep the value of the previous band and the next to connect them together
  float previousBandValue = fft.getBand(0);
  
  //Distance between each line point, negative because on the z dimension. 
  float dist = -200;
  
  //Multiply the height by this constant
  float heightMult = 0.6;
    
  //For each line
  for(int i = 1; i < fft.specSize(); i++)
  {
    //Value of the frequency band, we multiply the bands farther to make them more visible. pitch from the 4 lines
    float bandValue = fft.getBand(i)*(1 + (i/100));
    
    //Selection of the color according to the forces of the different types of sounds. Just for strokes of the 4 lines
    stroke(255-i);
    strokeWeight(1 + (scoreGlobal/500));
    
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
  }

}

// run to start the game
void run_game() {
  
  oldSetup();
  button2.setVisible(false);
  labelSong.setVisible(false);
  game_running = true;
  song.play(0);
  
}


// do GUI stuff that can not be done in the gui file
void mygui() {
  titel.setText("MUSIC VISUALIZATION");
  titel.setFont(new Font("Impact.ttf", Font.BOLD, 32));
  button1.setFont(new Font("consola.ttf", Font.BOLD, 24));
  labelSong.setFont(new Font("consola.ttf", Font.BOLD, 32));
  labelSong.setText(file);
  static_songWahl.setFont(new Font("Arial", Font.BOLD, 32));
}

void oldSetup() {
    //import Minim-library 
  minim = new Minim(this);
 
  //load Song
  song = minim.loadFile(file);
  
  //create FFT-Object, for song analyse
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  //one cube per frequency
  varCubes = (int)(fft.specSize()*specMid);
  cubes = new Cube[varCubes];
  println("nbCubes: " + varCubes);
  
  varSpheres = (int)(fft.specSize()*specMid);
  spheres = new Sphere[varSpheres];
  println("nbSpheres: " + varSpheres);
  
 //varTriangles = (int) (fft.specSize()*specMid);
 //triangles = new Triangle[varTriangles];
 //println("nbTriangles: " + varTriangles);
      
  //create the cube objects
  for (int i = 0; i < varCubes; i++) {
   cubes[i] = new Cube(); 
  }
  
  //Create the sphere objects
  for (int i = 0; i < varSpheres; i++) {
   spheres[i] = new Sphere(); 
  }
  
  //Create the triangle objects
  for (int i = 0; i < varTriangles; i++) {
   triangles[i] = new Triangle(); 
  }
    
}

String getSongs() {
  String path = sketchPath() + "/data";
  File folder = new File (path);
  File[] listOfFiles = folder.listFiles();
  String listofsongs = "";
  for (int i = 0; i < listOfFiles.length; i++) {
    if (listOfFiles[i].isFile()) {
      listofsongs += listOfFiles[i].getName() + " \n";
    }
  }
  return listofsongs;
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    file = selection.getAbsolutePath();
    labelSong.setText(selection.getName());
  }
}

void handleButtonEvents(GButton button, GEvent event) {
  println("something happened: button " + button + ", event " + event + " @ " + millis());
}

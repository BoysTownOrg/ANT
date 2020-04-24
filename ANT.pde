char leftkey = '1';
char rightkey = '2';
int cuedur = 60; //in frame counts; in msec = 1000;
int fixdur = 60; //two fix : before and after stim
int stimdur = 120;
boolean jumpahead = false;

int index, rowCount=0, correct;
int bgcolor = 255; //black = 0, 128 gray, 255 white; 
PImage[][] stimuli = new PImage[2][3];
PImage plus, star, blank, red;
IntList trialnums = new IntList();
Table tmptable, table;
int saveTime = frameCount+1000000;
int stimTime, respTime, stimframe;
boolean stimflag=true, FirstPicFlag=true, noMore = true, init = true;
boolean showcue=false, showfix1=false, showstim=false, showfix2=false, showstimflag=true;
TableRow row;
int left, context;
boolean  nocue, centercue, spatial, attop;
String instructionText = "Press space to begin.\nYou may have to click on this screen first.";
int imagewidth, imageheight;

void setup() {
  background(bgcolor);
  frameRate(60);
  fullScreen();
  fill(0);
  imageMode(CENTER);
  imagewidth = width/2;
  imageheight = height/8;
  tmptable = loadTable("ANT.csv", "header");
  table = new Table();
  table.addColumn("bmps");
  table.addColumn("cues");
  table.addColumn("locations");
  table.addColumn("left");
  table.addColumn("context");
  table.addColumn("nocue");
  table.addColumn("centercue");
  table.addColumn("spatial");
  table.addColumn("attop");
  table.addColumn("response");
  table.addColumn("RT");
  table.addColumn("correct");
  for (int i = 0; i < tmptable.getRowCount(); i++) {
    trialnums.append(i);
  }
  trialnums.shuffle();
  for (int i = 0; i < tmptable.getRowCount(); i++) {
    index = trialnums.get(i);
    row = tmptable.getRow(index);
    table.addRow(row);
  }
  saveTable(table, "temp.csv");
  row = table.getRow(0);
  left = int(row.getInt("left"));
  //println(left);
  left = 0; 
  context = 0;
  stimuli[left][context] = loadImage("RightIncongruent.bmp");
  left = 0; 
  context = 1;
  stimuli[left][context] = loadImage("RightCongruent.bmp");
  left = 0; 
  context = 2;
  stimuli[left][context] = loadImage("RightNeutral.bmp");
  left = 1; 
  context = 0;
  stimuli[left][context] = loadImage("LeftIncongruent.bmp");
  left = 1; 
  context = 1;
  stimuli[left][context] = loadImage("LeftCongruent.bmp");
  left = 1; 
  context = 2;
  stimuli[left][context] = loadImage("LeftNeutral.bmp");

  plus = loadImage("plus.bmp");
  star = loadImage("star.bmp");
  blank = loadImage("blank.bmp");
  red = loadImage("red.bmp");

  //row = table.getRow(rowCount);
  //left = int(row.getInt("left"));
  //context = int(row.getInt("context"));
  //nocue = boolean(row.getInt("nocue"));
  //centercue = boolean(row.getInt("centercue"));
  //spatial = boolean(row.getInt("spatial"));
  //attop = boolean(row.getInt("attop"));

  FirstPicFlag = true;
}

void draw() {
  if (saveTime+cuedur+fixdur+stimdur+fixdur<frameCount) { //when eveything starts anew
    saveTime = frameCount;
    showstimflag=true;
    rowCount += 1;
    //println("rowcount += 1");
    if (rowCount >= table.getRowCount()-1) {
      //it's over, baby
      String dayS = String.valueOf(day());
      String hourS = String.valueOf(hour());
      String minuteS = String.valueOf(minute());
      String myfilename = "AS3out"+"-"+dayS+"-"+hourS+"-"+minuteS+".csv";
      saveTable(table, myfilename, "csv");
      //println("Exit");
      exit();
    }
    //row = table.getRow(rowCount);
    //left = int(row.getInt("left"));
    //context = int(row.getInt("context"));
    //nocue = boolean(row.getInt("nocue"));
    //centercue = boolean(row.getInt("centercue"));
    //spatial = boolean(row.getInt("spatial"));
    //attop = boolean(row.getInt("attop"));

    FirstPicFlag = true;
    noMore = true;
  } else if (saveTime+cuedur+fixdur+stimdur<frameCount) {
    showcue=false;
    showfix1=false; 
    showstim=false;
    showfix2=true;
  } else 
  if (saveTime+cuedur+fixdur<frameCount) {
    showcue=false;
    showfix1=false; 
    if (jumpahead) {
      showstim=false;
      showfix2=true;
    } else {
      showstim=true;
      showfix2=false;
    }
  } else 
  if (saveTime+cuedur<frameCount) {
    showcue=false;
    showfix1=true; 
    showstim=false;
    showfix2=false;
    if (stimflag) {

      stimflag = false;
    }
  } else 
  if (saveTime<frameCount) {
    if (FirstPicFlag) {
      //println("First flag");
      row = table.getRow(rowCount);
      left = int(row.getInt("left"));
      context = int(row.getInt("context"));
      nocue = boolean(row.getInt("nocue"));
      centercue = boolean(row.getInt("centercue"));
      spatial = boolean(row.getInt("spatial"));
      attop = boolean(row.getInt("attop"));
      FirstPicFlag = false;
      jumpahead = false;
      showcue=true;
      showfix1=false; 
      showstim=false;
      showfix2=false;
    }
  }

  if (showcue) {
    if (nocue) {
      image(blank, width/2, height/2, imagewidth, imageheight);
    } else if (centercue) {
      image(star, width/2, height/2, imagewidth, imageheight);
    } else if (spatial) {
      if (attop) {
        image(star, width/2, height/4, imagewidth, imageheight);
      } else {
        image(star, width/2, height*3/4, imagewidth, imageheight);
      }
    }
  } else if (showfix1) {
    image(plus, width/2, height/2, imagewidth, imageheight);
  } else if (showstim) {
    if (showstimflag) {
      stimframe = frameCount;
      stimTime = millis();
      showstimflag = false;
    }
    if (attop) {
      image(stimuli[left][context], width/2, height/4, imagewidth, imageheight);
    } else {
      image(stimuli[left][context], width/2, height*3/4, imagewidth, imageheight);
    }
  } else if (showfix2) {
    image(plus, width/2, height/2, imagewidth, imageheight);
    image(blank, width/2, height/4, imagewidth, imageheight);
    image(blank, width/2, height*3/4, imagewidth, imageheight);
  }
  if (init) {
    text(instructionText, width/2, height/2);
  }
}



void keyPressed() {

  if (key == ' ') {
    saveTime = frameCount+6;
    init = false;
    showcue = true;
  }
  if (key == leftkey && noMore) {
    //println("left");
    noMore = false;
    showstim = false;
    showfix2 = true;
    jumpahead = true;
    saveTime -= stimdur - (frameCount- stimframe);
    respTime = millis();
    table.setString(rowCount, "answer", str(leftkey));
    table.setInt(rowCount, "correct", int(Integer.parseInt(str(leftkey))== 2 - left));
    //println(Integer.parseInt(str(leftkey)),left);
    table.setFloat(rowCount, "RT", respTime-stimTime);
  }
  if (key == rightkey && noMore) {
    //println("right");
    noMore = false;
    showstim = false;
    showfix2 = true;
    jumpahead = true;
    saveTime -= stimdur - (frameCount- stimframe);
    respTime = millis();
    table.setString(rowCount, "answer", str(rightkey));
    table.setInt(rowCount, "correct", int(Integer.parseInt(str(rightkey))== 2 - left));
    //println(Integer.parseInt(str(rightkey)),left);
    table.setFloat(rowCount, "RT", respTime-stimTime);
  }
}

char leftkey = 'z';
char rightkey = 'm';
int cuedur = 1000, currentcuedur; //in frame counts; in msec
int fixdur = 1000; //two fix : before and after stim
int fixdur2 = 1500;
int stimdur = 2000;
int feedbackdur = 1500;
int iscorrect = 0, totalPrac=0, currentPracCorrect=0;
boolean jumpahead = false;
float widthfrac; // = 0.3;
float horizfrac; // = widthfrac/3.333;
int index, rowCount=0, correct;
int bgcolor = 255; //black = 0, 128 gray, 255 white; 
int textsize = 64;
PImage[][] stimuli = new PImage[2][3];
PImage plus, star, blank, red;
IntList trialnums = new IntList();
Table tmptable, table;
int saveTime = millis()+1000000;
int stimTime, respTime, stimframe;
boolean stimflag=true, FirstPicFlag=true, noMore = true, init = true, testhasbegun=false;
boolean showcue=false, showfix1=false, showstim=false, showfix2=false, showstimflag=true, doOnce = false;
TableRow row;
int left, context;
boolean  nocue, centercue, spatial, both, attop, ispractice, firsttesttrial=false;
String [] pracinstructions; // = "Press space to begin practice.\nYou may have to click on this screen first.";
String [] testinstructions; // = "Press space to begin real test.\nYou may have to click on this screen first.";
String testinstructionText, pracinstructionText;
int imagewidth, imageheight;
int plusnudge = 8, vertoffset;

void setup() {
  String[] lines = loadStrings("graph.prm");
  widthfrac = Float.valueOf(lines[0]);
  horizfrac = widthfrac/3.333;
  vertoffset = - Integer.valueOf(lines[1]);
  testinstructions = loadStrings("TestInstructions.txt");
  pracinstructions = loadStrings("PracInstructions.txt");
  testinstructionText = join(testinstructions, "\n");
  pracinstructionText = join(pracinstructions, "\n");
  background(bgcolor);
  //frameRate(60);
  fullScreen();
  textSize(textsize);
  textAlign(CENTER);
  fill(0);
  imageMode(CENTER);
  imagewidth = round(width*widthfrac); //10/15;
  imageheight = round(height*horizfrac); //*3/15;
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
  table.addColumn("both");
  table.addColumn("attop");
  table.addColumn("response");
  table.addColumn("RT");
  table.addColumn("correct");
  table.addColumn("ispractice");
  for (int i = 0; i < tmptable.getRowCount(); i++) {
    trialnums.append(i);
  }
  trialnums.shuffle();
  for (int i = 0; i < tmptable.getRowCount(); i++) {
    index = trialnums.get(i);
    row = tmptable.getRow(index);
    table.addRow(row);
  }
  table.sortReverse("ispractice");
  saveTable(table, "temp.csv");
  row = table.getRow(0);
  left = int(row.getInt("left"));
  //println(left);
  left = 0; 
  context = 0;
  stimuli[left][context] = loadImage("Stimuli/RightIncongruent.bmp");
  left = 0; 
  context = 1;
  stimuli[left][context] = loadImage("Stimuli/RightCongruent.bmp");
  left = 0; 
  context = 2;
  stimuli[left][context] = loadImage("Stimuli/RightNeutral.bmp");
  left = 1; 
  context = 0;
  stimuli[left][context] = loadImage("Stimuli/LeftIncongruent.bmp");
  left = 1; 
  context = 1;
  stimuli[left][context] = loadImage("Stimuli/LeftCongruent.bmp");
  left = 1; 
  context = 2;
  stimuli[left][context] = loadImage("Stimuli/LeftNeutral.bmp");

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
  // these nested if must be arranged from the latter events to erier event
  if (saveTime+cuedur+fixdur+stimdur+fixdur2<millis()) { //when eveything starts anew
    saveTime = millis();
    showstimflag=true;
    rowCount += 1;
    //println("rowcount += 1");
    if (rowCount >= table.getRowCount()) {
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
  } else if (saveTime+cuedur+fixdur+stimdur<millis()) {
    showcue=false;
    showfix1=false; 
    showstim=false;
    showfix2=true;
  } else 
  if (saveTime+cuedur+fixdur<millis()) {
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
  if (saveTime+cuedur<millis()) {
    showcue=false;
    showfix1=true; 
    showstim=false;
    showfix2=false;
    if (stimflag) {

      stimflag = false;
    }
  } else 
  if (saveTime<millis()) {
    if (FirstPicFlag) {
      //println("First flag");
      row = table.getRow(rowCount);
      left = int(row.getInt("left"));
      context = int(row.getInt("context"));
      nocue = boolean(row.getInt("nocue"));
      centercue = boolean(row.getInt("centercue"));
      spatial = boolean(row.getInt("spatial"));
      both = boolean(row.getInt("both"));
      attop = boolean(row.getInt("attop"));
      ispractice = boolean(row.getInt("ispractice"));
      background(bgcolor);
      respTime = -999;
      iscorrect = 0;
      FirstPicFlag = false;
      jumpahead = false;
      showcue=true;
      showfix1=false; 
      showstim=false;
      showfix2=false;
      if (ispractice) {
        currentcuedur=0;
        fixdur2 = 1500;
      } else {
        if (!testhasbegun) {
          noLoop();
          currentcuedur=cuedur;
          testhasbegun= true;
          init = true;
          fixdur2 = 1000;
          showcue=false; 
          //note showcue depends on being the last setting of this in FirstPicFlag
        }
      }
    }
  }

  if (showcue) {
    noMore = false;
    if (firsttesttrial) {
      background(bgcolor);
      //println("firsttesttrial");
      firsttesttrial = false;
    }
    image(plus, plusnudge+width/2, height/2, imagewidth, imageheight);
    if (nocue) {
      //image(blank, width/2, height/2, imagewidth, imageheight);
      image(blank, width/2, height/4-vertoffset, imagewidth, imageheight);
      image(blank, width/2, height*3/4+vertoffset, imagewidth, imageheight);
    } else if (centercue) {
      image(star, width/2, height/2, imagewidth, imageheight);
    } else if (both) {
        image(star, width/2, height/4+vertoffset, imagewidth, imageheight);
        image(star, width/2, height*3/4-vertoffset, imagewidth, imageheight);
    } else if (spatial) {
      if (attop) {
        image(star, width/2, height/4+vertoffset, imagewidth, imageheight);
      } else {
        image(star, width/2, height*3/4-vertoffset, imagewidth, imageheight);
      }
    }
  } else if (showfix1) {
    if (nocue) {
      image(plus, plusnudge+width/2, height/2, imagewidth, imageheight);
    } else {
      image(blank, width/2, height/2, imagewidth, imageheight);
      image(plus, plusnudge+width/2, height/2, imagewidth, imageheight);
    }
    image(blank, width/2, height/4+vertoffset, imagewidth, imageheight);
    image(blank, width/2, height*3/4-vertoffset, imagewidth, imageheight);
  } else if (showstim) {
    if (showstimflag) {
      stimframe = millis();
      stimTime = millis();
      showstimflag = false;
      noMore = true;
      doOnce = true;
    }
    if (ispractice) {
      image(stimuli[left][context], width/2, height/2, imagewidth, imageheight);
    } else if (attop) {
      image(stimuli[left][context], width/2, height/4+vertoffset, imagewidth, imageheight);
      //image(blank, width/2, height/2, imagewidth, imageheight);
    } else {
      image(stimuli[left][context], width/2, height*3/4-vertoffset, imagewidth, imageheight);
      //image(blank, width/2, height/2, imagewidth, imageheight);
    }
  } else if (showfix2) {
    if (ispractice) {
      background(bgcolor);
      if ((respTime > 0) && (iscorrect==1)) {
        if (doOnce) {
          totalPrac +=1;
          currentPracCorrect += 1;
          doOnce = false;
        }
        String feedbacktext = "Correct!\n"+ 
          "response time = " + str(respTime-stimTime) + " milliseconds\n" +
          str(100*currentPracCorrect/totalPrac) + " percent correct\n\n";
        fill(0, 0, 255);
        text(feedbacktext, width/2, height/2);  
        fill(0);
      };
      if ((respTime > 0) && (iscorrect==0)) {
        if (doOnce) {
          totalPrac +=1;
          doOnce = false;
        }
        String feedbacktext = "Incorrect.\n"+ 
          "response time = " + str(respTime-stimTime) + " milliseconds\n" +
          str(100*currentPracCorrect/totalPrac) + " percent correct\n\n";
        fill(255, 0, 0);
        text(feedbacktext, width/2, height/2);    
        fill(0);
      };
      if (respTime < 0) {
        if (doOnce) {
          totalPrac +=1;
          doOnce = false;
        }
        String feedbacktext = "No response!";
        fill(255, 0, 0);
        text(feedbacktext, width/2, height/2);
        fill(0);
      }
    } else {
      //image(blank, width/2, height/2, imagewidth, imageheight);
      image(blank, width/2, height/4+vertoffset, imagewidth, imageheight);
      image(blank, width/2, height*3/4-vertoffset, imagewidth, imageheight);
    }
  }
  if (init) {
    if (!testhasbegun) {
      textSize(textsize/2);
      text(pracinstructionText, width/16, height/4, width*7/8, height*3/4);
      textSize(textsize);
    } else {
      textSize(textsize/2);
      text(testinstructionText, width/16, height/4, width*7/8, height*3/4);
      textSize(textsize);
      firsttesttrial = true;
    }
  }
}



void keyPressed() {

  if (key == ' ' && init) {
    saveTime = millis()+100;
    init = false;
    background(bgcolor);
    showcue = true;
    if (testhasbegun) {
      background(bgcolor);
      loop();
    }
  }
  if (key == leftkey && noMore) {
    //println("left");
    noMore = false;
    showstim = false;
    showfix2 = true;
    jumpahead = true;
    saveTime -= stimdur - (millis()- stimframe); //cut from thew total time
    respTime = millis();
    table.setString(rowCount, "response", str(leftkey));
    if (left == 1) {
      iscorrect = 1;
    } else {
      iscorrect = 0;
    }
    table.setInt(rowCount, "correct", iscorrect);
    //println(Integer.parseInt(str(leftkey)),left);
    table.setFloat(rowCount, "RT", respTime-stimTime);
  }
  if (key == rightkey && noMore) {
    //println("right");
    noMore = false;
    showstim = false;
    showfix2 = true;
    jumpahead = true;
    saveTime -= stimdur - (millis()- stimframe); //cut from thew total time
    respTime = millis();
    table.setString(rowCount, "response", str(rightkey));
    if (left == 0) {
      iscorrect = 1;
    } else {
      iscorrect = 0;
    }
    table.setInt(rowCount, "correct", iscorrect);
    //println(Integer.parseInt(str(rightkey)),left);
    table.setFloat(rowCount, "RT", respTime-stimTime);
  }
}

void exit() {
  String monthS = String.valueOf(month());
  String dayS = String.valueOf(day());
  String hourS = String.valueOf(hour());
  String minuteS = String.valueOf(minute());
  String myfilename = "ANTout"+"-"+monthS+"-"+dayS+"-"+hourS+"-"+minuteS+".csv";
  saveTable(table, myfilename, "csv");

  println("exiting");
  super.exit();
}

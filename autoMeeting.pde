import java.awt.Color;
import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import java.awt.Toolkit;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.Clipboard;
Robot r;

boolean debug = false;

int[] offset = {1920, 0};
int mx(int x) {
  return x + offset[0];
}
int my(int y) {
  return y + offset[1];
}
int[] mxy(int x, int y) {
  int[] mxy = {mx(x), my(y)};
  return mxy;
}
int[] mxy(int[] xy) {
  return mxy(xy[0], xy[1]);
}
int[] rxy(int[] m) {
  int[] rxy = {m[0] - offset[0], m[1] - offset[1]};
  return rxy;
}

int[] popupOffset = {7, 82};
int addPopupOffsetX(int x) {
  return x + popupOffset[0];
}
int addPopupOffsetY(int y) {
  return y + popupOffset[1];
}
int[] addPopupOffsetXY(int x, int y) {
  int[] xy = {x + popupOffset[0], y + popupOffset[1]};
  return xy;
}
int[] addPopupOffsetXY(int[] xy) {
  return addPopupOffsetXY(xy[0], xy[1]);
}


void mMove(int mx, int my) {
  r.mouseMove(mx, my);
}
void mMove(int[] mxy) {
  r.mouseMove(mxy[0], mxy[1]);
}
void mClick(int mx, int my) {
  mMove(mx, my);
  delay(500);
  r.mousePress(InputEvent.BUTTON1_MASK);
  r.mouseRelease(InputEvent.BUTTON1_MASK);
}
void mClick(int[] mxy) {
  mClick(mxy[0], mxy[1]);
}
boolean isColorSame(int mx, int my, int[] rgb) {
  Color c = r.getPixelColor(mx, my);
  if (c.getRed() == rgb[0] 
    && c.getGreen() == rgb[1] 
    && c.getBlue() == rgb[2]) {
    return true;
  }
  return false;
}
boolean isColorSame(int[] mxy, int[] rgb) {
  return isColorSame(mxy[0], mxy[1], rgb);
}

boolean isFirstListLoaded() {
  int[] mxy = mxy(1214, 754);
  int[] rgb ={243, 243, 243};
  return isColorSame(mxy, rgb);
}
boolean isNextListLoaded() {
  int[] mxy = mxy(1214, 587);
  int[] rgb = {243, 243, 243};
  return isColorSame(mxy, rgb);
}
void toBottom(int rx, int ry) {
  mClick(mx(rx), my(ry));
  r.keyPress(KeyEvent.VK_END);
  r.keyRelease(KeyEvent.VK_END);
  delay(500);
  r.keyPress(KeyEvent.VK_END);
  r.keyRelease(KeyEvent.VK_END);
  delay(1500);
};
void toBottom(int[] rxy) {
  toBottom(rxy[0], rxy[1]);
};
int[] getFirstbuttonXY() {
  int[] mxy = mxy(1214, 1079);
  int[] rgb = {255, 85, 11};
  while (!isColorSame(mxy, rgb) &&mxy[1] >= 0) {
    mxy[1]--;
  }
  mxy[1] += -20;
  return rxy(mxy);
}
boolean isThereNextButton(int[] buttonXY) {
  int[] mxy = mxy(buttonXY);
  int[] rgb = {255, 85, 11};
  mxy[1] += -30;
  return isColorSame(mxy, rgb);
}
boolean isEndOfList(int[] buttonXY) {
  int[] mxy = mxy(buttonXY);
  int[] rgb = {243, 243, 243};
  mxy[1] += - 30;
  return isColorSame(mxy, rgb);
}
int[] getNextPageButtonXY() {
  int[] mxy = mxy(0, 842);
  int[] rgb = {153, 153, 153};
  while (!isColorSame(mxy, rgb) && mxy[0] < mx(1920)) {
    mxy[0]++;
    Color c = r.getPixelColor(mxy[0], mxy[1]);
    //print(mxy[0] + "," + mxy[1] + ":");
    //printArray(c);
  }
  mxy[0] += 8 + 24;
  mxy[1] += 8;
  return rxy(mxy);
}
void scrollUp(int rx, int ry) { 
  mMove(mx(rx), my(ry));
  r.mouseWheel( -1);
  delay(1500);
}
int[] toIdx(int targetIdx) {
  println("go to index : " + targetIdx);
  int currentIdx = 0;
  int[] buttonXY = {0, 0};
  if (isFirstListLoaded()) {
    println("first page is loaded");
    toBottom(1214, 754);
    println("searching 1st button...");
    buttonXY = getFirstbuttonXY();
    println("got 1st button xy : " + buttonXY[0] + "," + buttonXY[1]);
    while (currentIdx < targetIdx) {
      if (isThereNextButton(buttonXY)) {
        buttonXY[1] += - 30;
        currentIdx++;
        println("got next button xy : " + buttonXY[0] + "," + buttonXY[1]);
        println("currentIdx : " + currentIdx);
      } else if (isEndOfList(buttonXY)) {
        buttonXY[1] += -30;
        println("end of list, so go to the next page"); 
        toBottom(1567, 949);
        toBottom(1567, 949);
        println("searching next page button...");
        int[] nextPageButtonXY = getNextPageButtonXY();
        println("got next page button xy : " + nextPageButtonXY[0] + "," + nextPageButtonXY[1]);
        mClick(mxy(nextPageButtonXY));
        println("next page button is clicked");
        println("waiting for next page to be loaded");
        while (!isNextListLoaded()) {
          //print(".");
        }
        println();
        println("next page is loaded");
        toBottom(1567, 949);
        toBottom(1567, 949);
        println("searching 1st button...");
        buttonXY = getFirstbuttonXY();
        currentIdx++;
        println("got 1st button xy : " + buttonXY[0] + "," + buttonXY[1]);
        println("currentIdx : " + currentIdx);
      } else {
        scrollUp(buttonXY[0] + 88, buttonXY[1]);
        buttonXY[1] += 100;
        println("no more button, so scroll up");
        println("button xy is changed : " + buttonXY[0] + "," + buttonXY[1]);
      }
    }
  }
  return buttonXY;
}
int[] toNextIdx(int targetIdx) {
  println("go to index : " + targetIdx);
  int currentIdx = 0;
  int[] buttonXY = {0, 0};
  //if (isFirstListLoaded()) {
  //println("first page is loaded");
  toBottom(1567, 949);
  toBottom(1567, 949);
  println("searching 1st button...");
  buttonXY = getFirstbuttonXY();
  println("got 1st button xy : " + buttonXY[0] + "," + buttonXY[1]);
  while (currentIdx < targetIdx) {
    if (isThereNextButton(buttonXY)) {
      buttonXY[1] += - 30;
      currentIdx++;
      //println("got next button xy : " + buttonXY[0] + "," + buttonXY[1]);
      //println("currentIdx : " + currentIdx);
    } else if (isEndOfList(buttonXY)) {
      buttonXY[1] += -30;
      println("end of list, so go to the next page");
      toBottom(1567, 949);
      toBottom(1567, 949);
      println("searching next page button...");
      int[] nextPageButtonXY = getNextPageButtonXY();
      println("got next page button xy : " + nextPageButtonXY[0] + "," + nextPageButtonXY[1]);
      mClick(mxy(nextPageButtonXY));
      println("next page button is clicked");
      println("waiting for next page to be loaded");
      while (!isNextListLoaded() && !isFirstListLoaded()) {
        //print(".");
      }
      println();
      println("next page is loaded"); 
      toBottom(1567, 949);
      toBottom(1567, 949);
      println("searching 1st button...");
      buttonXY = getFirstbuttonXY();
      currentIdx++;
      println("got 1st button xy : " + buttonXY[0] + "," + buttonXY[1]);
      //println("currentIdx : " + currentIdx);
    } else {
      scrollUp(buttonXY[0] + 88, buttonXY[1]);
      buttonXY[1] += 100;
      println("no more button, so scroll up");
      //println("button xy is changed : " + buttonXY[0] + "," + buttonXY[1]);
    }
  }
  //}
  return buttonXY;
}


void coordTest(int frameCountMax) {
  int[] mxy = mxy((int)(cos(frameCount * 0.1) * 300 + 1920 * 0.5), 
    (int)(sin(frameCount * 0.1) * 300 + 1080 * 0.5));
  mMove(mxy[0], mxy[1]);
  if (frameCount > frameCountMax) {
    exit();
  }
}

boolean isPopupLoaded() {
  int[] mxy = mxy(addPopupOffsetXY(1172, 294));
  int[] rgb = {246, 246, 246};
  return isColorSame(mxy, rgb);
}
boolean isAlarmPopup() {
  int[] mxy = mxy(addPopupOffsetXY(429, 65));
  int[] rgb = {41, 42, 45};
  return isColorSame(mxy, rgb);
}
int currentIdx;
void loop(int startIdx, int targetCnt) {
  int[] buttonXY = {0, 0};
  currentIdx = startIdx;
  buttonXY = toIdx(currentIdx);
  println("arrived to index:" + currentIdx);
  println("button xy : " + buttonXY[0] + "," + buttonXY[1]);
  while (currentIdx < targetCnt) {
    mClick(mxy(buttonXY));
    println("go into : " + currentIdx);
    println("waiting for popup is loaded");
    delay(1500);
    while (!isPopupLoaded()) {
      //print(".");
    }
    println();
    println("popup is loaded");
    mClick(mxy(addPopupOffsetXY(1016, 297)));
    println("click type");
    mClick(mxy(addPopupOffsetXY(968, 388)));
    println("click privacy");
    mClick(mxy(addPopupOffsetXY(867, 785)));
    println("click contents");
    r.keyPress(KeyEvent.VK_CONTROL);
    r.keyPress(KeyEvent.VK_V);
    r.keyRelease(KeyEvent.VK_V);
    r.keyRelease(KeyEvent.VK_CONTROL);
    println("paste contents");
    mClick(mxy(addPopupOffsetXY(966, 344)));
    println("click category");
    delay(1000);
    mClick(mxy(addPopupOffsetXY(966, 421)));
    println("select category");
    mClick(mxy(addPopupOffsetXY(967, 416)));
    println("click date");
    delay(1000);
    for (int i = 0; i < 3; i++) {
      mClick(mxy(addPopupOffsetXY(981, 460)));
      println("click prevMonth");
      delay(1000);
    }
    int dateSelectorX = (currentIdx / 54) % 2 == 0 ? 0 : 1;
    int dateSelectorY = (currentIdx + 54) / 108;
    mClick(mxy(addPopupOffsetXY(1211 + 10 - 240 * dateSelectorX
      , 535 + 10 + 32 * dateSelectorY)));
    println("select date");
    delay(1000);
    mClick(mxy(addPopupOffsetXY(966, 452)));
    println("click time");
    delay(1000);
    int timeSelector = (currentIdx % 54) / 6;
    mClick(mxy(addPopupOffsetXY(966, 529 + 5 + 16 * timeSelector)));
    println("select time");
    delay(1000);
    mClick(mxy(addPopupOffsetXY(1203, 217)));
    println("click background");
    r.keyPress(KeyEvent.VK_END);
    r.keyRelease(KeyEvent.VK_END);
    println("press end");
    delay(1500);
    mClick(mxy(addPopupOffsetXY(1136, 893)));
    println("click submit");
    println("wait for an alarm");
    while (!isAlarmPopup()) {
      //print(".");
    }
    println();
    delay(debug? 1000 : 5000);
    mClick(mxy(addPopupOffsetXY(722, 144)));
    println("click okay");
    println("wait for another alarm");
    while (!isAlarmPopup()) {
      //print(".");
    }
    println();
    delay(debug? 9000 : 10000);
    mClick(mxy(addPopupOffsetXY(799, 144)));
    println("click okay");
    delay(debug? 5000 : 10000);
    mClick(mxy(addPopupOffsetXY(1245, 81)));
    println("close");
    delay(debug? 5000 : 10000);
    currentIdx++;
    if (currentIdx >= targetCnt) {
      break;
    }
    buttonXY = toNextIdx(currentIdx);
    println("got next button xy : " + buttonXY[0] + "," + buttonXY[1]);
    println("currentIdx : " + currentIdx);
  }
}


void setClipboard() {
  StringSelection selection = new StringSelection("(학습지도) 수업관련 어려운 점이나 학습에 관련된 지도, 상담.");
  Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
  clipboard.setContents(selection, selection);
}
void setup() {
  size(300, 300);
  try {
    r = new Robot();
    r.setAutoDelay(1);
  } 
  catch(Exception e) {
    e.printStackTrace();
  }
  setClipboard();
  delay(5000);
  loop(0, 67);
}

void draw() {
  //coordTest(60 * 5);
}

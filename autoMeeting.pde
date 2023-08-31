import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import java.awt.image.BufferedImage;
import java.awt.Color;
import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.util.HashMap;
Robot r;

int[] zero = {2560, 0};
int[] size = {1920, 1080};

String[] stepDescription = {
  "0 check list is loaded",
  "1 get top coord",
  "2 click scroll target",
  "3 scroll to home",
  "4 set top coord by target",
  "5 get button coord",
  "6 click a button",
  "7 check window is opened",
  "8 check content is loaded",
  "9 get scroll target coord",
  "10 click scroll target",
  "11 scroll to end",
  "12 click category",
  "13 click category item",
  "14 click privacy",
  "15 click date",
  "16 click month",
  "17 click month item",
  "18 click day item",
  "19 click close",
  "20 click time",
  "21 click time item",
  "22 click job",
  "23 click job item",
  "24 click description",
  "25 paste description",
  "26 click submit",
  "27 check prompt is appeared",
  "28 get prompt coord",
  "29 click prompt",
  "30 check 2nd prompt is appeared",
  "31 get 2nd prompt coord",
  "32 click 2nd prompt",
  "33 wait",
  "34 close",
  "35 wait",
};

HashMap<String, int[]> relCoords = new HashMap<>();

int[][] timetable = {
  {1, 3, 2, 3},
  {2, 3, 2, 3},
  {3, 3, 2, 3},
  {4, 3, 2, 4},
  {5, 3, 2, 4},
  {6, 3, 2, 4},
  {7, 3, 2, 6},
  {8, 3, 2, 6},
  {9, 3, 2, 6},
  {10, 3, 2, 7},
  {11, 3, 2, 7},
  {12, 3, 2, 7},
  {13, 3, 2, 8},
  {14, 3, 2, 8},
  {15, 3, 2, 8},
  {16, 3, 2, 9},
  {17, 3, 2, 9},
  {18, 3, 2, 9},
  {19, 3, 2, 10},
  {20, 3, 2, 10},
  {21, 3, 2, 10},
  {22, 3, 3, 3},
  {23, 3, 3, 3},
  {24, 3, 3, 3},
  {25, 3, 3, 4},
  {26, 3, 3, 4},
  {27, 3, 3, 4},
  {28, 3, 3, 6},
  {29, 3, 3, 6},
  {30, 3, 3, 6},
  {31, 3, 3, 7},
  {32, 3, 3, 7},
  {33, 3, 3, 7},
  {34, 3, 3, 8},
  {35, 3, 3, 8},
  {36, 3, 3, 8},
  {37, 3, 3, 9},
  {38, 3, 3, 9},
  {39, 3, 3, 9},
  {40, 3, 3, 10},
  {41, 3, 3, 10},
  {42, 3, 3, 10},
  {43, 3, 4, 3},
  {44, 3, 4, 3},
  {45, 3, 4, 3},
  {46, 3, 4, 4},
  {47, 3, 4, 4},
  {48, 3, 4, 4},
  {49, 3, 4, 6}
};

int step = 0;

void printStep() {
  println(stepDescription[step]);
}

void setStep(int newStep) {
  print("DONE: ");
  printStep();
  step = newStep;
}

void addStep() {
  print("DONE: ");
  printStep();
  step++;
}

void decStep() {
  print("ERROR: ");
  printStep();
  step--;
}

void setup() {
  size(300, 300);

  setClipboard();

  relCoords.put("category", new int[]{0, 54});
  relCoords.put("categoryItem", new int[]{0, 98});
  relCoords.put("privacy", new int[]{0, 96});
  relCoords.put("date", new int[]{0, 126});
  relCoords.put("month", new int[]{143, 162});
  relCoords.put("monthItem_1", new int[]{143, 244});
  relCoords.put("monthItem_2", new int[]{143, 244 + 24});
  relCoords.put("monthItem_3", new int[]{143, 244 + 24 * 2});
  relCoords.put("monthItem_4", new int[]{143, 244 + 24 * 3});
  relCoords.put("dayItem_1", new int[]{245, 246});
  relCoords.put("dayItem_2", new int[]{245, 279});
  relCoords.put("dayItem_3", new int[]{245, 311});
  relCoords.put("dayItem_4", new int[]{245, 343});
  relCoords.put("dayItem_5", new int[]{245, 375});
  relCoords.put("close", new int[]{223, 429});
  relCoords.put("time", new int[]{0, 162});
  relCoords.put("timeItem_1", new int[]{0, 208});
  relCoords.put("timeItem_2", new int[]{0, 224});
  relCoords.put("timeItem_3", new int[]{0, 241});
  relCoords.put("timeItem_4", new int[]{0, 257});
  relCoords.put("timeItem_5", new int[]{0, 274});
  relCoords.put("timeItem_6", new int[]{0, 291});
  relCoords.put("timeItem_7", new int[]{0, 307});
  relCoords.put("timeItem_8", new int[]{0, 324});
  relCoords.put("timeItem_9", new int[]{0, 340});
  relCoords.put("timeItem_10", new int[]{0, 357});
  relCoords.put("timeItem_11", new int[]{0, 374});
  relCoords.put("job", new int[]{0, 429});
  relCoords.put("jobItem", new int[]{0, 499});
  relCoords.put("description", new int[]{-100, 494});
  relCoords.put("submit", new int[]{171, 690});
  relCoords.put("done", new int[]{273, -101});

  try {
    r = new Robot();
    r.setAutoDelay(1);
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  delay(500);
  frameRate(2);
}

void draw() {
  cycle();
}

int[] topCoord = null;
int[] coord = {0, 0};
int studentIdx = 0;
int idxOffset = 0;

void cycle() {
  if (step == 0) {
    if (findColorArea("fd5320", 4, 4) == null) {
      print("DOING: ");
      printStep();
    } else {
      addStep();
    }
  } else if (step == 1) {
    if (findColorArea("fd5320", 4, 4) != null) {
      print("DOING: ");
      printStep();
      topCoord = findColorArea("fd5320", 2, 2);
      addStep();
    }
  } else if (step == 2) {
    print("DOING: ");
    printStep();
    click(topCoord[0] + 64, topCoord[1]);
    addStep();
  } else if (step == 3) {
    print("DOING: ");
    printStep();
    scrollToHome();
    addStep();
    // wait until scroll is finished
    delay(1000);
    topCoord = findColorArea("fd5320", 2, 2);
  } else if (step == 4) {
    print("DOING: ");
    printStep();
    idxOffset = 0;
    int[] lastExistingCoord = {0, 0};
    for (int i = 0; i <= studentIdx; i++) {
      if (findColorAreaFrom("fd5320", 4, 4, 0, topCoord[1] + 30 * (i - idxOffset)) == null) {
        println("no more below");
        click(topCoord[0] + 80, topCoord[1]);
        scrollDown();
        // wait until scroll is finished
        delay(1000);
        topCoord[1] = lastExistingCoord[1];
        topCoord[1] -= 792;
        idxOffset = i - 1;
      } else {
        lastExistingCoord = findColorAreaFrom("fd5320", 4, 4, 0, topCoord[1] + 30 * (i - idxOffset));
      }
    }
    addStep();
  } else if (step == 4 + 1) {
    print("DOING: ");
    printStep();
    coord[0] = topCoord[0];
    coord[1] = topCoord[1] + 30 * (studentIdx - idxOffset);
    addStep();
  } else if (step == 4 + 2) {
    print("DOING: ");
    printStep();
    click(coord);
    addStep();
  } else if (step == 4 + 3) {
    if (findColorArea("0f72ad", 8, 8) == null) {
      print("DOING: ");
      printStep();
    } else {
      addStep();
    }
  } else if (step == 4 + 4) {
    if (findColorArea("1777fc", 3, 3) == null) {
      print("DOING: ");
      printStep();
    } else {
      addStep();
    }
  } else if (step == 4 + 5) {
    print("DOING: ");
    printStep();
    coord = findColorArea("1777fc", 3, 3);
    addStep();
  } else if (step == 4 + 6) {
    print("DOING: ");
    printStep();
    click(coord);
    addStep();
  } else if (step == 4 + 7) {
    print("DOING: ");
    printStep();
    scrollToEnd();
    addStep();
    // wait until scroll is finished
    delay(1000);
    // re-find chaged coord because it is scrolled
    coord = findColorArea("1777fc", 3, 3);
  } else if (step == 4 + 8) {
    int[] offset = relCoords.get("category");
    int[] newCoord = {
      coord[0] + offset[0],
      coord[1] + offset[1]
    };
    print("DOING: ");
    printStep();
    click(newCoord);
    addStep();
  } else if (step == 4 + 9) {
    int[] offset = relCoords.get("categoryItem");
    int[] newCoord = {
      coord[0] + offset[0],
      coord[1] + offset[1]
    };
    print("DOING: ");
    printStep();
    click(newCoord);
    addStep();
  } else if (step == 4 + 10) {
    int[] offset = relCoords.get("privacy");
    int[] newCoord = {
      coord[0] + offset[0],
      coord[1] + offset[1]
    };
    print("DOING: ");
    printStep();
    click(newCoord);
    addStep();
  } else if (step == 4 + 11) {
    int[] offset = relCoords.get("date");
    int[] newCoord = {
      coord[0] + offset[0],
      coord[1] + offset[1]
    };
    print("DOING: ");
    printStep();
    click(newCoord);
    addStep();
  } else if (step == 4 + 12) {
    int[] offset = relCoords.get("month");
    int[] newCoord = {
      coord[0] + offset[0],
      coord[1] + offset[1]
    };
    print("DOING: ");
    printStep();
    click(newCoord);
    addStep();
  } else if (step == 4 + 13) {
    int[] offset = relCoords.get("monthItem_" + timetable[studentIdx][1]);
    int[] newCoord = {
      coord[0] + offset[0],
      coord[1] + offset[1]
    };
    print("DOING: ");
    printStep();
    click(newCoord);
    addStep();
  } else if (step == 4 + 14) {
    int[] offset = relCoords.get("dayItem_" + timetable[studentIdx][2]);
    int[] newCoord = {
      coord[0] + offset[0],
      coord[1] + offset[1]
    };
    print("DOING: ");
    printStep();
    click(newCoord);
    addStep();
  } else if (step == 4 + 15) {
    int[] offset = relCoords.get("close");
    int[] newCoord = {
      coord[0] + offset[0],
      coord[1] + offset[1]
    };
    print("DOING: ");
    printStep();
    click(newCoord);
    addStep();
  } else if (step == 4 + 16) {
    int[] offset = relCoords.get("time");
    int[] newCoord = {
      coord[0] + offset[0],
      coord[1] + offset[1]
    };
    print("DOING: ");
    printStep();
    click(newCoord);
    addStep();
  } else if (step == 4 + 17) {
    int[] offset = relCoords.get("timeItem_" + timetable[studentIdx][3]);
    int[] newCoord = {
      coord[0] + offset[0],
      coord[1] + offset[1]
    };
    print("DOING: ");
    printStep();
    click(newCoord);
    addStep();
  } else if (step == 4 + 18) {
    int[] offset = relCoords.get("job");
    int[] newCoord = {
      coord[0] + offset[0],
      coord[1] + offset[1]
    };
    print("DOING: ");
    printStep();
    click(newCoord);
    addStep();
  } else if (step == 4 + 19) {
    int[] offset = relCoords.get("jobItem");
    int[] newCoord = {
      coord[0] + offset[0],
      coord[1] + offset[1]
    };
    print("DOING: ");
    printStep();
    click(newCoord);
    addStep();
  } else if (step == 4 + 20) {
    int[] offset = relCoords.get("description");
    int[] newCoord = {
      coord[0] + offset[0],
      coord[1] + offset[1]
    };
    print("DOING: ");
    printStep();
    click(newCoord);
    addStep();
  } else if (step == 4 + 21) {
    print("DOING: ");
    printStep();
    paste();
    addStep();
  } else if (step == 4 + 22) {
    int[] offset = relCoords.get("submit");
    int[] newCoord = {
      coord[0] + offset[0],
      coord[1] + offset[1]
    };
    print("DOING: ");
    printStep();
    click(newCoord);
    addStep();
  } else if (step == 4 + 23) {
    if (findColorArea("8CB5F6", 16, 4) == null) {
      print("DOING: ");
      printStep();
    } else {
      addStep();
    }
  } else if (step == 4 + 24) {
    if (findColorArea("8CB5F6", 16, 4) != null) {
      print("DOING: ");
      printStep();
      coord = findColorArea("8CB5F6", 16, 4);
      addStep();
    }
  } else if (step == 4 + 25) {
    print("DOING: ");
    printStep();
    click(coord);
    addStep();
  } else if (step == 4 + 26) {
    if (findColorArea("8CB5F6", 16, 4) == null) {
      print("DOING: ");
      printStep();
    } else {
      addStep();
    }
  } else if (step == 4 + 27) {
    if (findColorArea("8CB5F6", 16, 4) != null) {
      print("DOING: ");
      printStep();
      coord = findColorArea("8CB5F6", 16, 4);
      addStep();
    }
  } else if (step == 4 + 28) {
    print("DOING: ");
    printStep();
    click(coord);
    addStep();
  } else if (step == 4 + 29) {
    print("DOING: ");
    printStep();
    delay(10000);
    addStep();
  } else if (step == 4 + 30) {
    r.keyPress(KeyEvent.VK_CONTROL);
    r.keyPress(KeyEvent.VK_W);
    r.keyRelease(KeyEvent.VK_W);
    r.keyRelease(KeyEvent.VK_CONTROL);
    print("DOING: ");
    printStep();
    addStep();
  } else if (step == 4 + 31) {
    delay(5000);
    println("student #" + studentIdx + " is done.");
    studentIdx++;
    setStep(1);
  }
}

int[] hexToRgb(String hex) {
  hex = hex.replace("#", ""); // "#" 문자 제거
  int r = Integer.parseInt(hex.substring(0, 2), 16);
  int g = Integer.parseInt(hex.substring(2, 4), 16);
  int b = Integer.parseInt(hex.substring(4, 6), 16);
  return new int[]{r, g, b};
}

int[] findColor(String hex) {
  int[] rgb = hexToRgb(hex);
  BufferedImage screenshot = r.createScreenCapture(new Rectangle(zero[0], zero[1], size[0], size[1]));
  for (int y = 0; y < size[1]; y++) {
    for (int x = 0; x < size[0]; x++) {
      Color c = new Color(screenshot.getRGB(x, y));
      if (c.getRed() == rgb[0]
        && c.getGreen() == rgb[1]
        && c.getBlue() == rgb[2]) {
        return new int[]{x + zero[0], y + zero[1]};
      }
    }
  }
  return null;
}

int[] findColorArea(String hex, int areaWidth, int areaHeight) {
  int[] rgb = hexToRgb(hex);
  BufferedImage screenshot = r.createScreenCapture(new Rectangle(zero[0], zero[1], size[0], size[1]));
  for (int y = 0; y < size[1]; y++) {
    for (int x = 0; x < size[0]; x++) {
      Color c = new Color(screenshot.getRGB(x, y));
      if (c.getRed() == rgb[0]
        && c.getGreen() == rgb[1]
        && c.getBlue() == rgb[2]) {
        boolean isArea = true;
        for (int checkY = y + 1; checkY < y + areaHeight; checkY++) {
          for (int checkX = x + 1; checkX < x + areaWidth; checkX++) {
            c = new Color(screenshot.getRGB(checkX, checkY));
            if (c.getRed() != rgb[0]
              || c.getGreen() != rgb[1]
              || c.getBlue() != rgb[2]) {
              isArea = false;
              break;
            }
          }
          if (!isArea) break;
        }
        if (isArea) return new int[]{x + zero[0], y + zero[1]};
      }
    }
  }
  return null;
}

int[] findColorAreaFrom(String hex, int areaWidth, int areaHeight, int fromX, int fromY) {
  int[] rgb = hexToRgb(hex);
  BufferedImage screenshot = r.createScreenCapture(new Rectangle(zero[0], zero[1], size[0], size[1]));
  for (int y = fromY; y < size[1]; y++) {
    for (int x = fromX; x < size[0]; x++) {
      Color c = new Color(screenshot.getRGB(x, y));
      if (c.getRed() == rgb[0]
        && c.getGreen() == rgb[1]
        && c.getBlue() == rgb[2]) {
        boolean isArea = true;
        for (int checkY = y + 1; checkY < y + areaHeight; checkY++) {
          for (int checkX = x + 1; checkX < x + areaWidth; checkX++) {
            c = new Color(screenshot.getRGB(checkX, checkY));
            if (c.getRed() != rgb[0]
              || c.getGreen() != rgb[1]
              || c.getBlue() != rgb[2]) {
              isArea = false;
              break;
            }
          }
          if (!isArea) break;
        }
        if (isArea) return new int[]{x + zero[0], y + zero[1]};
      }
    }
  }
  return null;
}

void click(int x, int y) {
  r.mouseMove(x, y);
  r.mousePress(InputEvent.BUTTON1_MASK);
  r.mouseRelease(InputEvent.BUTTON1_MASK);
}

void click(int[] coord) {
  r.mouseMove(coord[0], coord[1]);
  r.mousePress(InputEvent.BUTTON1_MASK);
  r.mouseRelease(InputEvent.BUTTON1_MASK);
}

void scrollDown() {
  r.keyPress(KeyEvent.VK_PAGE_DOWN);
  r.keyRelease(KeyEvent.VK_PAGE_DOWN);
}

void scrollToEnd() {
  r.keyPress(KeyEvent.VK_END);
  r.keyRelease(KeyEvent.VK_END);
}

void scrollToHome() {
  r.keyPress(KeyEvent.VK_HOME);
  r.keyRelease(KeyEvent.VK_HOME);
}

void paste() {
  r.keyPress(KeyEvent.VK_CONTROL);
  r.keyPress(KeyEvent.VK_V);
  r.keyRelease(KeyEvent.VK_V);
  r.keyRelease(KeyEvent.VK_CONTROL);
}

void setClipboard() {
  StringSelection selection = new StringSelection("(자기탐색) 희망하는 진로목표와 관련하여 학생 개인특성과 관련한 상담을 실시함.");
  Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
  clipboard.setContents(selection, selection);
}

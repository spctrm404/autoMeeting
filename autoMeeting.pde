String[] stepDescription = {
  "0 check list is loaded",
  "1 get first button coord",
  "2 click a button",
  "3 check window is opened",
  "4 check content is loaded",
  "5 click scroll target",
  "scroll to end",
  "click method",
  "click category",
  "click category item",
  "click privacy",
  "click date",
  "click month",
  "click month item",
  "click day",
  "click close",
  "click time",
  "click time item",
  "click job",
  "click describe",
  "paste describe",
  "click submit",
  "check next button exist"
};
int step = 0;
void printStep() {
  println(stepDescription[step]);
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
Robot r;

int[] zero = {2560, 0};
int[] size = {1920, 1080};

void setup() {
  size(300, 300);
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

int[] buttonCoord = null;

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
      buttonCoord = findColorArea("fd5320", 2, 2);
      addStep();
    }
  } else if (step == 2) {
    if (buttonCoord != null) {
      click(buttonCoord);
      addStep();
    }
  } else if (step == 3) {
    if (findColorArea("0f72ad", 8, 8) == null) {
      print("DOING: ");
      printStep();
    } else {
      addStep();
    }
  } else if (step == 4) {
    if (findColorArea("1777fc", 3, 3) == null) {
      print("DOING: ");
      printStep();
    } else {
      addStep();
    }
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

void click(int[] coord) {
  r.mouseMove(coord[0], coord[1]);
  r.mousePress(InputEvent.BUTTON1_MASK);
  r.mouseRelease(InputEvent.BUTTON1_MASK);
}

int down, right, down1, right1;
int p0, p1, p01, p11;
boolean click;
boolean WHITE = true;
boolean BLACK = false;
boolean turn;//player turn
boolean gameOver;
boolean wKingMoved, bKingMoved, wRookMoved1, bRookMoved1, wRookMoved2, bRookMoved2;
boolean check;//if in check
boolean promote;
PImage wKing, bKing, wQueen, bQueen, wPawn, bPawn, wRook, bRook, wKnight, bKnight, wBishop, bBishop;
PImage[][] board;

void setup() {
  size(640, 640);
  noStroke();
  textSize(width/8);
  textAlign(CENTER);

  wKing = loadImage("queenRed.jpg");
  bKing = loadImage("queenBlack.jpg");
  wQueen = loadImage("Queen.png");
  bQueen = loadImage("Queen1.png");
  wPawn = loadImage("Queen.png");
  bPawn = loadImage("Queen1.png");
  wRook = loadImage("Queen.png");
  bRook = loadImage("Queen1.png");
  wKnight = loadImage("Queen.png");
  bKnight = loadImage("Queen1.png");
  wBishop = loadImage("Queen.png");
  bBishop = loadImage("Queen1.png");
  wKing.resize(width/8, height/8);
  bKing.resize(width/8, height/8);
  wQueen.resize(width/8, height/8);
  bQueen.resize(width/8, height/8);
  wPawn.resize(width/8, height/8);
  bPawn.resize(width/8, height/8);
  wRook.resize(width/8, height/8);  
  bRook.resize(width/8, height/8); 
  wKnight.resize(width/8, height/8);
  bKnight.resize(width/8, height/8);
  wBishop.resize(width/8, height/8);  
  bBishop.resize(width/8, height/8);
  startPosition();
}
void draw() {
  showBoard();
  if (gameOver) {
    fill(100, 205, 180);
    if (check) text("CHECKMATE", 0, height/2, width, height);
    else text("STALEMATE", 0, height/2, width, height);
  }
}
void showBoard() {
  for (int i = 0; i<8; i++)
    for (int j = 0; j<8; j++) { 
      if ((i+j)%2 == 0) fill(30, 50, 158);
      else fill(209, 139, 71);
      rect(i*width/8, j*height/8, width/8, height/8);
      if (board[j][i] != null) image(board[j][i], i*width/8, j*height/8);
      if (click) {
        if (validMove(down, right, j, i, turn, board) && !incheck(down, right, j, i, turn)) {
          fill(255, 0, 0, 100);
          rect(i*width/8, j*height/8, width/8, height/8);
        }
        if (j == down && i == right && board[j][i] != null) {
          fill(0, 0, 255, 100);
          rect(i*width/8, j*height/8, width/8, height/8);
        }
      }
    }
  if (check && !gameOver && !promote) {
    fill(100, 255, 60);
    text("CHECK", 0, height/2, width, height);
  }
  if (promote && !gameOver) {
    stroke(2);
    fill(200,20, 100);
    rect(0, 0, 2*width/8, height);
    rect(2*width/8, 0, 2*width/8, height);
    rect(4*width/8, 0, 2*width/8, height);
    rect(6*width/8, 0, 2*width/8, height);
    if (!turn) {
      image(wQueen, 0.5*width/8, 3.5*height/8);
      image(wRook, 2.5*width/8, 3.5*height/8);
      image(wBishop, 4.5*width/8, 3.5*height/8);
      image(wKnight, 6.5*width/8, 3.5*height/8);
    } else {
      image(bQueen, 0.5*width/8, 3.5*height/8);
      image(bRook, 2.5*width/8, 3.5*height/8);
      image(bBishop, 4.5*width/8, 3.5*height/8);
      image(bKnight, 6.5*width/8, 3.5*height/8);
    }
    noStroke();
  }
}
void mousePressed() {
  if (gameOver) startPosition();
  if (promote) {
    int x = round(mouseX/ (width/4)-0.5);
    if (!turn == WHITE) {
      if (x == 0) board[down1][right1] = wQueen;
      if (x == 1) board[down1][right1] = wRook;
      if (x == 2) board[down1][right1] = wBishop;
      if (x == 3) board[down1][right1] = wKnight;
    } else {
      if (x == 0) board[down1][right1] = bQueen;
      if (x == 1) board[down1][right1] = bRook;
      if (x == 2) board[down1][right1] = bBishop;
      if (x == 3) board[down1][right1] = bKnight;
    }
    promote = false;
    check = false;
    if (Check(turn, board)) {
      check = true;
    }
    if (mate(turn)) {
      gameOver = true;
    }
  } else if (click) {
    down1 = round(mouseY / (height/8)-0.5);
    right1 = round(mouseX / (width/8)-0.5);
    if (validMove(down, right, down1, right1, turn, board) && !incheck(down, right, down1, right1, turn)) {
      check = false;//stop showing check
      board = movePiece(down, right, down1, right1, true, board);//move piece
      click = false;
    } else {//change piece
      down = down1;
      right = right1;
      click = true;
    }
  } else {
    down = round(mouseY / (height/8)-0.5);
    right = round(mouseX / (width/8)-0.5);
    click = true;
  }
}
void startPosition() {
  board = new PImage[8][8];

  board[4][0] = bRook;
  board[2][1] = bKnight;
  board[6][2] = bBishop;
  board[1][3] = bQueen;
  board[7][4] = bKing;
  board[3][5] = bBishop;
  board[2][6] = bKnight;
  board[5][7] = bRook;
  board[3][0] = bPawn;
  board[5][1] = bPawn;
  board[1][2] = bPawn; 
 // board[1][3] = bPawn;
  //board[1][4] = bPawn;
 // board[1][5] = bPawn;
 // board[1][6] = bPawn;
  //board[1][7] = bPawn;

  board[3][0] = wRook;
  board[2][1] = wKnight;
  board[6][2] = wBishop;
  board[5][3] = wQueen;
  board[1][4] = wKing;
  //board[7][5] = wBishop;
 // board[7][6] = wKnight;
 // board[7][7] = wRook;
  board[6][0] = wPawn;
  board[7][1] = wPawn;
  board[4][2] = wPawn;
  board[2][3] = wPawn;
  board[3][4] = wPawn;
  //board[6][5] = wPawn;
 // board[6][6] = wPawn;
 // board[6][7] = wPawn;

  //global variables
  down=right=down1=right1=-1;
  p0=p1=p01=p11=-1;
  click = false;
  turn = WHITE;
  gameOver = false;
  wKingMoved = false;
  bKingMoved = false;
  wRookMoved1 = false;
  bRookMoved1 = false;
  wRookMoved2 = false;
  bRookMoved2 = false;
  check = false;
  promote = false;
}
PImage[][] movePiece(int i0, int j0, int i1, int j1, boolean update, PImage[][] Board) {
  if (update) {
    p0 = i0; 
    p1 = j1; 
    p01 = i1; 
    p11 = j1;
  }
  if (Board[i0][j0] == wPawn) {
    if (i1 == 0) {
      if (update) promote = true;
    } else if (i1 == 2 && abs(j1 - j0) == 1 && Board[i1][j1] == null) {
      Board[i1 + 1][j1] = null;
    }
  } else if (Board[i0][j0] == bPawn) {//promote black pawn
    if (i1 == 7) {
      if (update) promote = true;
    } else if (i1 == 5 && abs(j1 - j0) == 1 && Board[i1][j1] == null) {
      Board[i1 - 1][j1] = null;
    }
  } else if (Board[i0][j0] == wKing) {
    if (wKingMoved == false && j1 == 2) {
      Board[7][0] = null;
      Board[7][3] = wRook;
    }
    if (wKingMoved == false && j1 == 6) {
      Board[7][7] = null;
      Board[7][5] = wRook;
    }
    if (update)wKingMoved = true;
  } else if (Board[i0][j0] == bKing) {
    if (bKingMoved == false && j1 == 2) {
      Board[0][0] = null;
      Board[0][3] = bRook;
    }
    if (bKingMoved == false && j1 == 6) {
      Board[0][7] = null;
      Board[0][5] = bRook;
    }
    if (update)bKingMoved = true;
  } else if (Board[i0][j0] == wRook) {
    if (update) {
      if (!wRookMoved1 && j0 == 0) wRookMoved1 = true;
      if (!wRookMoved2 && j0 == 7) wRookMoved2 = true;
    }
  } else if (Board[i0][j0] == bRook) {
    if (update) {
      if (!bRookMoved1 && j0 == 0) bRookMoved1 = true;
      if (!bRookMoved2 && j0 == 7) bRookMoved2 = true;
    }
  }
  Board[i1][j1] = Board[i0][j0];
  Board[i0][j0] = null;
  if (update) {
    if (Check(!turn, Board)) {
      check = true;
    }
    if (mate(!turn)) {//no legal moves
      gameOver = true;
    }
    turn = !turn;
  }
  return Board;
}
boolean Check(boolean side, PImage[][] Board) {
  int i, j = 0;
  boolean b = false;

  for (i = 0; i<8; i++) {
    for (j = 0; j<8; j++) {
      if (side == WHITE) {
        if (Board[i][j] == wKing) { 
          b = true;
          break;
        }
      } else {
        if (Board[i][j] == bKing) { 
          b = true;
          break;
        }
      }
    }
    if (b == true) {
      break;
    }
  }
  for (int k = 0; k<8; k++) {
    for (int l = 0; l<8; l++) {
      if (side == WHITE) {
        if (notBlack(l, k, Board))
          continue;
      } else if (notWhite(l, k, Board)) {
        continue;
      }
      if (validMove(l, k, i, j, !side, Board)) return true;
    }
  }
  return false;
}
boolean incheck(int down, int right, int down1, int right1, boolean side) {
  PImage[][] updateBoard = new PImage[8][8];
  for (int i = 0; i<8; i++)
    for (int j = 0; j<8; j++) 
      updateBoard[i][j] = board[i][j];
  updateBoard = movePiece(down, right, down1, right1, false, updateBoard);

  if (Check(side, updateBoard)) {
    return true;
  }
  return false;
}
boolean mate(boolean side) {
  for (int k = 0; k<8; k++) {
    for (int l = 0; l<8; l++) {
      if (side == WHITE) {
        if (notWhite(l, k, board))
          continue;
      } else if (notBlack(l, k, board)) {
        continue;
      }
      for (int i = 0; i<8; i++) {
        for (int j = 0; j<8; j++) {
          if (validMove(l, k, i, j, side, board) && !incheck(l, k, i, j, side)) return false;
        }
      }
    }
  }
  return true;
}
boolean validMove(int down, int right, int down1, int right1, boolean side, PImage[][] Board) {
  if (side == WHITE) {
    if (Board[down][right] == wPawn && !promote) {
      if (right1 == right && down1 == down-1 && Board[down-1][right] == null) { 
        return true;
      } else if (right1 == right && down1 == down-2) {
        if (down == 6 && Board[down-1][right] == null && Board[down-2][right] == null) {
          return true;
        }
      }
      if (right != 7) {
        if (black(down-1, right+1, Board)) {
          if (down1 == down-1 && right1 == right +1) return true;
        }
        if (down == 3 && Board[p01][p11] == bPawn && p01 == p0 + 2 && p1 == right + 1) {
          if (down1 == down-1 && right1 == right +1) return true;
        }
      }
      if (right != 0) {//take
        if (black(down-1, right-1, Board)) {
          if (down1 == down-1 && right1 == right -1) return true;
        }
        if (down == 3 && Board[p01][p11] == bPawn && p01 == p0 + 2 && p1 == right - 1) {
          if (down1 == down-1 && right1 == right - 1) return true;
        }
      }
    } else if (Board[down][right] == wKing) {
      if (abs(right - right1) <= 1 && abs(down - down1) <= 1) {
        if (notWhite(down1, right1, Board)) {
          return true;
        }
      }
      if (!wKingMoved && !check) {
        if (Board[7][3] == null && Board[7][2] == null && Board[7][1] == null &&
          down1 == 7 && right1 == 2 && wRookMoved1 == false) {
          if (!incheck(down, right, 7, 3, turn)) {
            return true;
          }
        }
        if (Board[7][5] == null && Board[7][6] == null &&
          down1 == 7 && right1 == 6 && wRookMoved2 == false) {
          if (!incheck(down, right, 7, 5, turn)) {
            return true;
          }
        }
      }
    } else if (Board[down][right] == wKnight) {
      if ((abs(down1 - down) == 2 && abs(right1 - right) == 1) ||
        (abs(down1 - down) == 1 && abs(right1 - right) == 2)) {
        if (notWhite(down1, right1, Board)) return true;
      }
    } else if (Board[down][right] == wBishop) {      
      if (possible(down, right, down1, right1, 1, 1, WHITE, Board)) return true;
      if (possible(down, right, down1, right1, 1, -1, WHITE, Board)) return true;
      if (possible(down, right, down1, right1, -1, 1, WHITE, Board)) return true;
      if (possible(down, right, down1, right1, -1, -1, WHITE, Board)) return true;
    } else if (Board[down][right] == wRook) {
      if (possible(down, right, down1, right1, 0, 1, WHITE, Board)) return true;
      if (possible(down, right, down1, right1, 0, -1, WHITE, Board)) return true;
      if (possible(down, right, down1, right1, 1, 0, WHITE, Board)) return true;
      if (possible(down, right, down1, right1, -1, 0, WHITE, Board)) return true;
    } else if (Board[down][right] == wQueen) {
      if (possible(down, right, down1, right1, 1, 1, WHITE, Board)) return true;
      if (possible(down, right, down1, right1, -1, 1, WHITE, Board)) return true;
      if (possible(down, right, down1, right1, 1, -1, WHITE, Board)) return true;
      if (possible(down, right, down1, right1, -1, -1, WHITE, Board)) return true;
      if (possible(down, right, down1, right1, 0, 1, WHITE, Board)) return true;
      if (possible(down, right, down1, right1, 0, -1, WHITE, Board)) return true;
      if (possible(down, right, down1, right1, 1, 0, WHITE, Board)) return true;
      if (possible(down, right, down1, right1, -1, 0, WHITE, Board)) return true;
    }
  } else {
    if (Board[down][right] == bPawn && !promote) {
      if (right1 == right && down1 == down+1 && Board[down+1][right] == null) { 
        return true;
      } else if (right1 == right && down1 == down+2) {
        if (down == 1 && Board[down+1][right] == null && Board[down+2][right] == null) {
          return true;
        }
      }
      if (right != 7) {
        if (white(down1, right1, Board)) {
          if (down1 == down+1 && right1 == right + 1) return true;
        }
        if (down == 4 && Board[p01][p11] == wPawn && p01 == p0 - 2 && p1 == right + 1) {
          if (down1 == down+1 && right1 == right + 1) return true;
        }
      }
      if (right != 0) {
        if (white(down1, right1, Board)) {
          if (down1 == down+1 && right1 == right - 1) return true;
        }
        if (down == 4 && Board[p01][p11] == wPawn && p01 == p0 - 2 && p1 == right - 1) {
          if (down1 == down+1 && right1 == right - 1) return true;
        }
      }
    } else if (Board[down][right] == bKing) {
      if (abs(right - right1) <= 1 && abs(down - down1) <= 1) {
        if (notBlack(down1, right1, Board)) {
          return true;
        }
      }
      if (!bKingMoved && !check) {
        if (Board[0][3] == null && Board[0][2] == null && Board[0][1] == null &&
          Board[0][0] == bRook && down1 == 0 && right1 == 2) {
          if (!incheck(down, right, 0, 3, turn)) {
            return true;
          }
        }
        if (Board[0][5] == null && Board[0][6] == null &&
          Board[0][7] == bRook && down1 == 0 && right1 == 6) {
          if (!incheck(down, right, 0, 5, turn)) {
            return true;
          }
        }
      }
    } else if (Board[down][right] == bKnight) {
      if ((abs(down1 - down) == 2 && abs(right1 - right) == 1) ||
        (abs(down1 - down) == 1 && abs(right1 - right) == 2)) {
        if (notBlack(down1, right1, Board)) return true;
      }
    } else if (Board[down][right] == bBishop) {     
      if (possible(down, right, down1, right1, 1, 1, BLACK, Board)) return true;
      if (possible(down, right, down1, right1, 1, -1, BLACK, Board)) return true;
      if (possible(down, right, down1, right1, -1, 1, BLACK, Board)) return true;
      if (possible(down, right, down1, right1, -1, -1, BLACK, Board)) return true;
    } else if (Board[down][right] == bRook) {
      if (possible(down, right, down1, right1, 0, 1, BLACK, Board)) return true;
      if (possible(down, right, down1, right1, 0, -1, BLACK, Board)) return true;
      if (possible(down, right, down1, right1, 1, 0, BLACK, Board)) return true;
      if (possible(down, right, down1, right1, -1, 0, BLACK, Board)) return true;
    } else if (Board[down][right] == bQueen) {
      if (possible(down, right, down1, right1, 1, 1, BLACK, Board)) return true;
      if (possible(down, right, down1, right1, -1, 1, BLACK, Board)) return true;
      if (possible(down, right, down1, right1, 1, -1, BLACK, Board)) return true;
      if (possible(down, right, down1, right1, -1, -1, BLACK, Board)) return true;
      if (possible(down, right, down1, right1, 0, 1, BLACK, Board)) return true;
      if (possible(down, right, down1, right1, 0, -1, BLACK, Board)) return true;
      if (possible(down, right, down1, right1, 1, 0, BLACK, Board)) return true;
      if (possible(down, right, down1, right1, -1, 0, BLACK, Board)) return true;
    }
  }
  return false;
}
boolean possible(int down, int right, int down1, int right1, int d, int r, boolean side, PImage[][] Board) {
  for (int i = right + r, j  = down + d; i < 8 && j < 8 && i >= 0 && j >= 0; i+= r, j+= d) {
    if (side == WHITE) {
      if (white(j, i, Board)) break;
      if (black(j, i, Board)) {
        if (i == right1 && j == down1)return true;
        break;
      }
    } else {
      if (black(j, i, Board)) break;
      if (white(j, i, Board)) {
        if (i == right1 && j == down1)return true;
        break;
      }
    }
    if (i == right1 && j == down1)return true;
  }
  return false;
}
boolean black (int down1, int right1, PImage[][] Board) {
  return (Board[down1][right1] == bQueen || Board[down1][right1] == bKnight || Board[down1][right1] == bPawn || 
    Board[down1][right1] == bRook || Board[down1][right1] == bBishop || Board[down1][right1] == bKing);
}
boolean white (int down1, int right1, PImage[][] Board) {
  return (Board[down1][right1] == wQueen || Board[down1][right1] == wKnight || Board[down1][right1] == wPawn || 
    Board[down1][right1] == wRook || Board[down1][right1] == wBishop || Board[down1][right1] == wKing);
}
boolean notBlack (int down1, int right1, PImage[][] Board) {
  return (white(down1, right1, Board) || Board[down1][right1] ==null);
}
boolean notWhite (int down1, int right1, PImage[][] Board) {
  return (black(down1, right1, Board) || Board[down1][right1] ==null);
}

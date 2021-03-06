class gameOfLife extends patch{
  
  boolean[][] cells;
  int[][] neighbors;
  int[] size_of_cell = new int[2];
  int[] cells_size = {8,8};
  int num_of_cells;
  
  gameOfLife(){
    size_of_cell[0] = int(width/cells_size[0]);
    size_of_cell[1] = int(height/cells_size[1]);
    num_of_cells = cells_size[0] * cells_size[1]; 
    cells = new boolean[cells_size[0]][cells_size[1]];
    neighbors = new int[cells_size[0]][cells_size[1]];
    randomize(1);
    oscP5.plug(this,"randomize","/4/toggle1");
    oscP5.plug(this,"glider","/4/toggle2");
  }
  
  void render(){
    if (all_dead()){
      randomize(1);
    }
    rectMode(CENTER);
    for (int i = 0; i< cells_size[0]; i++) {
      for (int j = 0; j < cells_size[1]; j++) {
        if (cells[i][j]) {
          fill(255);
        } else {
          fill(0);
        }
        
        int xpos = i * size_of_cell[0];
        int ypos = j * size_of_cell[1];
        rect(xpos + (width*.03), ypos, abs(i-cells_size[0]/2)*size_of_cell[0], abs(j-cells_size[1]/2)*size_of_cell[1]);
      }
    }
    evolve();
  }
  
  private boolean all_dead(){
   boolean all_dead = false;
   for (int i=0; i < cells_size[0]; i++) {
    for (int j=0; j < cells_size[1]; j++) {
      all_dead = all_dead | cells[i][j];
    }
   } 
   return all_dead;
  }
  
  private int num_of_neighbors(int i, int j){
    int num = 0;
    int[][] neigh_pos = {
                 //{-1,-1},
                 {-1, 0},
                 //{-1, 1},
                 { 0, 1},
                 { 0,-1},
                 //{ 1, 1},
                 { 1, 0},
                 //{ 1,-1}
               };
    for (int k = 0; i < neighbors.length; i++) {
      int x_ind = (i + neigh_pos[k][0]);
      if (x_ind == -1){
        x_ind = cells_size[0] - 1;
      }
      int y_ind = (j + neigh_pos[k][1]);
      if (y_ind == -1){
        y_ind = cells_size[1] - 1;
      }
      
      if (cells[x_ind][y_ind]) {
        num++; 
      }
    }
    
    return num;
  }
  
  void evolve(){
    //update neighbors array
    for (int i = 0; i < cells_size[0]; i++) {
      for (int j = 0; j < cells_size[1]; j++) {
        neighbors[i][j] = num_of_neighbors(i,j);
      }
    }
    
    //apply rules of life
    for (int i = 0; i < cells_size[0]; i++) {
      for (int j = 0; j < cells_size[1]; j++) {
        if (neighbors[i][j] < 2) {
          cells[i][j] = false;
        } else if (neighbors[i][j] > 3) {
          cells[i][j] = false;
        } else if (neighbors[i][j] == 3) {
          cells[i][j] = true;
        }
      } 
    }
  }
    
  void randomize(float f){
    for (int i = 0; i < cells_size[0]; i++) {
      for (int j = 0; j < cells_size[1]; j++) {
        cells[i][j] = random(1) < (f*.5 + .25);
      }
    }
  }
  
  void glider(float f){
    for (int i= 0; i < cells_size[0]; i++) {
      for (int j=0; j < cells_size[1]; j++) {
        cells[i][j] = false;
      }
    }
    cells[int(cells_size[0]/2)][int(cells_size[1]/2)] = true;
  }
  void delay(int delay) {
    int time = millis();
    while(millis() - time <= delay);
  }
}

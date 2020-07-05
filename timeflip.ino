#include <Wire.h>
const int MPU_addr=0x68;  // I2C address of the MPU-6050
int16_t    Accel[3];
uint32_t myTimer=0;
uint32_t history_time[150];
unsigned int history_values[150];
unsigned int tf_step = 0;
int last_state = 0;

void setup(){
  Wire.begin();
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x6B);  // PWR_MGMT_1 register
  Wire.write(0);     // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);
  Serial.begin(9600);
  get_acc();
  get_state();
}

int get_state()
{
  //init
  int16_t states[12][3];
  states[0][0]=432;
  states[0][1]=-16256;
  states[0][2]=2872;
  states[1][0]=-1072;
  states[1][1]=-7280;
  states[1][2]=17660;
  states[2][0]=14156;
  states[2][1]=-6884;
  states[2][2]=8548;
  states[3][0]=9960;
  states[3][1]=-6796;
  states[3][2]=-8440;
  states[4][0]=-6936;
  states[4][1]=-7124;
  states[4][2]=-10164;
  states[5][0]=-13952;
  states[5][1]=-7844;
  states[5][2]=5968;
  states[6][0]=-9564;
  states[6][1]=6948;
  states[6][2]=14496;
  states[7][0]=1772;
  states[7][1]=7648;
  states[7][2]=-11796;
  states[8][0]=-13380;
  states[8][1]=7292;
  states[8][2]=-3068;
  states[9][0]=756;
  states[9][1]=16556;
  states[9][2]=3128;
  states[10][0]=7896;
  states[10][1]=7156;
  states[10][2]=15896;
  states[11][0]=14668;
  states[11][1]=7336;
  states[11][2]=-40;
  
  //compare
  int min_sum = 65000;
  int min_diff = 0;
  unsigned int cur_diff = 0;
  unsigned int addiction = 0;
  for (int i=0;i<12;i++)
  {
   cur_diff = 0;
   for (int j=0;j<3;j++) cur_diff = cur_diff + abs(states[i][j]-Accel[j]);
   if (cur_diff<min_sum) {min_diff = i;min_sum=cur_diff;}
  }
  //Serial.print(min_diff);Serial.print("\n"); //READ STATES
  return min_diff;
}

void get_acc()
{
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x3B);  // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU_addr,14,true);  // request a total of 14 registers
  Accel[0]=Wire.read()<<8|Wire.read();  // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)    
  Accel[1]=Wire.read()<<8|Wire.read();  // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
  Accel[2]=Wire.read()<<8|Wire.read();  // 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)
}

void flush_data(uint32_t m_current)
{
  for (int i=0;i<tf_step;i++)
  {
    Serial.print(history_time[i]);
    Serial.print(';');
    Serial.print(history_values[i]);
    Serial.print('\n');
    history_values[i]=0;
    history_time[i]=0;    
  }
  tf_step = 0;
}

void loop(){
  uint32_t m_current = millis();
  if ( m_current - myTimer > 10000 ) 
  {
    get_acc();
    int cur_state = get_state();
    if (last_state!=cur_state) 
    {
      myTimer = m_current;
      //Serial.print(cur_state);Serial.print("\n");last_state=cur_state;
      history_values[tf_step]=cur_state;
      history_time[tf_step]=m_current;      
      tf_step++;
      if (tf_step>150) tf_step=0;            
    }
  }
  while (Serial.available() > 0)
  {
    if (Serial.read() == 'a') flush_data(m_current);
  }
}

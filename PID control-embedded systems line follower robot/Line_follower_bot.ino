// IR Sensors

int sensor1 = A0;      // Left most sensor
int sensor2 = A1;
int sensor3 = 12;
int sensor4 =13;      // Right most sensor

// Initial Values of Sensors
bool sensor[4] = {0, 0, 0, 0};

// Motor Variables
int ENA = 5;
int motorInput1 = 7;
int motorInput2 = 6;
int motorInput3 = 8;
int motorInput4 = 9;
int ENB = 10;

//Initial Speed of Motor
int initial_motor_speed = 140;
int motorA_speed=100;
int motorB_speed=100;
// Output Pins for Led
int ledPin1 = 17;
int ledPin2 = 18;

// PID Constants
float Kp = 20;
float Ki = 0;
float Kd = 15;

float error = 0, P = 0, I = 0, D = 0, PID_value = 0;
float previous_error = 0, previous_I = 0;

float error_plot=0;
int flag = 0;

void setup()
{
  pinMode(sensor1, INPUT);
  pinMode(sensor2, INPUT);
  pinMode(sensor4, INPUT);
  pinMode(sensor3, INPUT);
  

  pinMode(motorInput1, OUTPUT);
  pinMode(motorInput2, OUTPUT);
  pinMode(motorInput3, OUTPUT);
  pinMode(motorInput4, OUTPUT);
  pinMode(ENA, OUTPUT);
  pinMode(ENB, OUTPUT);

 // pinMode(ledPin1, OUTPUT);
 // pinMode(ledPin2, OUTPUT);

  //digitalWrite(ledPin1, LOW);
  //digitalWrite(ledPin2, LOW);

  Serial.begin(9600);                     //setting serial monitor at a default baund rate of 9600
  delay(500);
  Serial.println("Started !!");
  delay(1000);

  
}
void loop()
{
  /*
   //test robot motion
   analogWrite(ENA, motorA_speed);
  analogWrite(ENB, motorB_speed);

  forward();
  delay(1000);
  stop_bot();
  delay(500);
  reverse();
  delay(1000);
  stop_bot();
  delay(500);
  right();
  delay(1000);
  stop_bot();
  delay(500);
  left();
  delay(1000);
  stop_bot();
  delay(500);
  sharpRightTurn();
  delay(1000);
  stop_bot();
  delay(500);
  sharpLeftTurn();
  delay(1000);
  stop_bot();
  delay(500);
  //end test robot motion
  */

  /*
   //test sensors
   
   sensor[0]=digitalRead(sensor1);
   sensor[1]=digitalRead(sensor2);
   sensor[2]=digitalRead(sensor3);
   sensor[3]=digitalRead(sensor4);
   Serial.print(sensor[0]);
    Serial.print("\t");
    Serial.print(sensor[1]);
    Serial.print("\t");
    Serial.print(sensor[2]);
    Serial.print("\t");
    Serial.println(sensor[3]);
    
    delay(50);
   */
  
  read_sensor_values();
 // Serial.print(error);
  if (error == 100) {               // Make left turn untill it detects straight path
    //Serial.print("\t");
    //Serial.println("Left");
    do {
      stop_bot();////
      delay(5);
      read_sensor_values();
      analogWrite(ENA, motorA_speed); //Left Motor Speed
      analogWrite(ENB, motorB_speed); //Right Motor Speed
      sharpLeftTurn();
      delay(10);
    } while (error != 0);

  } else if (error == 101) {          // Make right turn in case of it detects only right path (it will go into forward direction in case of staright and right "|--")
                                      // untill it detects straight path.
    //Serial.print("\t");
    //Serial.println("Right");
    analogWrite(ENA, motorA_speed); //Left Motor Speed
    analogWrite(ENB, motorB_speed); //Right Motor Speed
    forward();
    //delay(20);/////////////////
    stop_bot();
    read_sensor_values();
    if (error == 102) {
      do {
        analogWrite(ENA, motorA_speed); //Left Motor Speed
        analogWrite(ENB, motorB_speed); //Right Motor Speed
        sharpRightTurn();//////////////////////////////////////////////////////////////////////
        read_sensor_values();
      } while (error != 0);
    }
  } else if (error == 102) {        // Make left turn untill it detects straight path
    //Serial.print("\t");
    //Serial.println("Sharp Left Turn");
    do {
      analogWrite(ENA, motorA_speed); //Left Motor Speed
      analogWrite(ENB, motorB_speed); //Right Motor Speed
      sharpLeftTurn();////////////////////////////////////////////////////////////////
      read_sensor_values();
      if (error == 0) {
        stop_bot();
        delay(20);////////////////////
        do{
        read_sensor_values();
        sharpRightTurn();
        delay(90);
        }while(error != 0);
        
        stop_bot();
        delay(20);
        error = 0;//to breake loop
      }
    } while (error != 0);
  } else if (error == 103) {        // Make left turn untill it detects straight path or stop if dead end reached.
    if (flag == 0) {
      analogWrite(ENA, motorA_speed); //Left Motor Speed
      analogWrite(ENB, motorB_speed); //Right Motor Speed
      forward();
      delay(20);////////////////
      stop_bot();
      read_sensor_values();
      if (error == 103) {     // Dead End Reached, Stop! 
        stop_bot();
        digitalWrite(ledPin1, HIGH);
        digitalWrite(ledPin2, HIGH);
        flag = 1;
      } else {        // Move Left 
        analogWrite(ENA, motorA_speed); //Left Motor Speed
        analogWrite(ENB, motorB_speed); //Right Motor Speed
        sharpLeftTurn();///////////////////////////////////////////
        delay(20);//////////////
        do {
          
          //Serial.print("\t");
          //Serial.println("Left Here");
          read_sensor_values();
          analogWrite(ENA, motorA_speed); //Left Motor Speed
          analogWrite(ENB, motorB_speed); //Right Motor Speed
          sharpLeftTurn();////////////////////////////////////////
        } while (error != 0);
      }
    }
  } else {
    calculate_pid();
    motor_control();
  }
  
}

void read_sensor_values()
{
  sensor[0] = digitalRead(sensor1);
  sensor[1] = digitalRead(sensor2);
  sensor[2] = digitalRead(sensor3);
  sensor[3] = digitalRead(sensor4);

  
   /* Serial.print(sensor[0]);
    Serial.print("\t");
    Serial.print(sensor[1]);
    Serial.print("\t");
    Serial.print(sensor[2]);
    Serial.print("\t");
    Serial.println(sensor[3]);
delay(20);*/
  if ((sensor[0] == 1) && (sensor[1] == 0) && (sensor[2] == 0) && (sensor[3] == 0)){
   error_plot=3;
  Serial.println(error_plot);
    error = 3;}
  else if ((sensor[0] == 1) && (sensor[1] == 1) && (sensor[2] == 0) && (sensor[3] == 0)){
  error_plot=2;
  Serial.println(error_plot);
    error = 2;}
  else if ((sensor[0] == 0) && (sensor[1] == 1) && (sensor[2] == 0) && (sensor[3] == 0)){
  error_plot=1;
  Serial.println(error_plot);
    error = 1;}
  else if ((sensor[0] == 0) && (sensor[1] == 1) && (sensor[2] == 1) && (sensor[3] == 0)){
  error_plot=0;
  Serial.println(error_plot);
    error = 0;}
  else if ((sensor[0] == 0) && (sensor[1] == 0) && (sensor[2] == 1) && (sensor[3] == 0)){
  error_plot=-1;
  Serial.println(error_plot);
    error = -1;}
  else if ((sensor[0] == 0) && (sensor[1] == 0) && (sensor[2] == 1) && (sensor[3] == 1)){
  error_plot=-2;
  Serial.println(error_plot);
    error = -2;}
  else if ((sensor[0] == 0) && (sensor[1] == 0) && (sensor[2] == 0) && (sensor[3] == 1)){
    error_plot=-3;
  Serial.println(error_plot);
    error = -3;}
 
  else if ((sensor[0] == 0) && (sensor[1] == 0) && (sensor[2] == 0) && (sensor[3] == 0)) // Make U turn
    error = 102;
  else if ((sensor[0] == 1) && (sensor[1] == 1) && (sensor[2] == 1) && (sensor[3] == 1)) // Turn left side or stop
    error = 103;
}

void calculate_pid()
{
  P = error;
  I = I + previous_I;
  D = error - previous_error;

  PID_value = (Kp * P) + (Ki * I) + (Kd * D);

  previous_I = I;
  previous_error = error;
}

void motor_control()
{
  // Calculating the effective motor speed:
  int left_motor_speed = initial_motor_speed - PID_value;
  int right_motor_speed = initial_motor_speed + PID_value;

  // The motor speed should not exceed the max PWM value
  left_motor_speed = constrain(left_motor_speed, 0, 255);
  right_motor_speed = constrain(right_motor_speed, 0, 255);

  /*Serial.print(PID_value);
    Serial.print("\t");
    Serial.print(left_motor_speed);
    Serial.print("\t");
    Serial.println(right_motor_speed);*/

  analogWrite(ENA, left_motor_speed); //Left Motor Speed
  analogWrite(ENB, right_motor_speed - 30); //Right Motor Speed

  //following lines of code are to make the bot move forward
  forward();
}

void forward()
{
  /*The pin numbers and high, low values might be different depending on your connections */
  
  digitalWrite(motorInput1, LOW);
  digitalWrite(motorInput2, HIGH);
  digitalWrite(motorInput3, LOW);
  digitalWrite(motorInput4, HIGH);
}
void reverse()
{
  /*The pin numbers and high, low values might be different depending on your connections */
  digitalWrite(motorInput1, HIGH);
  digitalWrite(motorInput2, LOW);
  digitalWrite(motorInput3, HIGH);
  digitalWrite(motorInput4, LOW);
}

void right()
{
  /*The pin numbers and high, low values might be different depending on your connections */
  digitalWrite(motorInput1, LOW);
  digitalWrite(motorInput2, HIGH);
  digitalWrite(motorInput3, LOW);
  digitalWrite(motorInput4, LOW);
}
void left()
{
  /*The pin numbers and high, low values might be different depending on your connections */
  digitalWrite(motorInput1, LOW);
  digitalWrite(motorInput2, LOW);
  digitalWrite(motorInput3, LOW);
  digitalWrite(motorInput4, HIGH);
}
void sharpRightTurn() {
  /*The pin numbers and high, low values might be different depending on your connections */
  digitalWrite(motorInput1, LOW);
  digitalWrite(motorInput2, HIGH);
  digitalWrite(motorInput3, HIGH);
  digitalWrite(motorInput4, LOW);
}
void sharpLeftTurn() {
  /*The pin numbers and high, low values might be different depending on your connections */
  digitalWrite(motorInput1, HIGH);
  digitalWrite(motorInput2, LOW);
  digitalWrite(motorInput3, LOW);
  digitalWrite(motorInput4, HIGH);
}
void stop_bot()
{
  /*The pin numbers and high, low values might be different depending on your connections */
  digitalWrite(motorInput1, LOW);
  digitalWrite(motorInput2, LOW);
  digitalWrite(motorInput3, LOW);
  digitalWrite(motorInput4, LOW);
}


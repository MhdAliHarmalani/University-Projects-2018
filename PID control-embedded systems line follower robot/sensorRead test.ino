int sensor1 = 13;      // Left most sensor
int sensor2 = A1;
int sensor3 = 12;
int sensor4 = A2;

int val[4];//={0,0,0,0};
void setup() {
  // put your setup code here, to run once:
  pinMode(sensor1, INPUT);
  pinMode(sensor2, INPUT);
  pinMode(sensor3, INPUT);
  pinMode(sensor4, INPUT);
  

  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
   
   val[1]=digitalRead(sensor1);
   val[2]=digitalRead(sensor2);
   val[3]=digitalRead(sensor3);
   val[4]=digitalRead(sensor4);
   Serial.print(val[1]);
    Serial.print("\t");
    Serial.print(val[2]);
    Serial.print("\t");
    Serial.print(val[3]);
    Serial.print("\t");
    Serial.println(val[4]);
    delay(500);
}

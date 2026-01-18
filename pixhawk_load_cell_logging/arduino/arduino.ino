#define PIN_X A0
#define PIN_Y A1
#define PIN_Z A2

uint32_t timeNow;
uint32_t timeLast;

// value was measured with a total gain of 2200
uint32_t values[3];

void setup() {
  // put your setup code here, to run once:
  Serial.begin(19200);

  pinMode(PIN_X, INPUT);
  pinMode(PIN_Y, INPUT);
  pinMode(PIN_Z, INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  timeNow = millis();
  if (timeNow - timeLast >= 5) {
    values[0] = analogRead(PIN_X);
    values[1] = analogRead(PIN_Y);
    values[2] = analogRead(PIN_Z); 
    timeLast = timeNow;
    Serial.print(values[0]);
    Serial.print(",");
    Serial.print(values[1]);
    Serial.print(",");
    Serial.println(values[2]);
  }
}

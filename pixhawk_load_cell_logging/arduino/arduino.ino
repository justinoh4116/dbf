#define PIN_X A0
#define PIN_Y A1
#define PIN_Z A2

uint32_t timeNow;
uint32_t timeLast;

// value was measured with a total gain of 2200
float ADC_TO_NEWTONS = 0.239;
float values[3];

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);

  pinMode(PIN_X, INPUT);
  pinMode(PIN_Y, INPUT);
  pinMode(PIN_Z, INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  timeNow = millis();
  if (timeNow - timeLast >= 20) {
    // multiply by scaling factor and subtract constant so that we can measure negative values
    values[0] = analogRead(PIN_X) * ADC_TO_NEWTONS - 115;
    values[1] = analogRead(PIN_Y) * ADC_TO_NEWTONS - 115;
    values[2] = analogRead(PIN_Z) * ADC_TO_NEWTONS - 200; // almost all of our z axis load will be negative, so we subtract a larger constant here
    timeLast = timeNow;
    Serial.print(values[0]);
    Serial.print(",");
    Serial.print(values[1]);
    Serial.print(",");
    Serial.println(values[2]);
  }
}

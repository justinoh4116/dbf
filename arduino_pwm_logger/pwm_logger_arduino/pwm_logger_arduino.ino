
#define NUM_CHANNELS 4
#define MODE_CHANNEL 3

const uint8_t pinRudderIn = 5;
const uint8_t pinLeftAilIn = 6;
const uint8_t pinRightAilIn = 7;
const uint8_t pinEleIn = 8;

uint8_t idx;

const uint8_t grPins[] = {
  pinRudderIn,
  pinLeftAilIn,
  pinRightAilIn,
  pinEleIn
  // pinModeIn

};

typedef struct structChannels {
  uint8_t pin;
  uint8_t lastPin;
  uint32_t tStart;
  uint32_t tWidth;
} sChannels_t;

sChannels_t Channels[NUM_CHANNELS] = { 0 };

uint8_t channel = 0;

uint32_t
  timeNow,
  timePrint = 0;
// uint8_t
//     mode;

void setup() {
  Serial.begin(115200);

  for (uint8_t idx = 0; idx < NUM_CHANNELS; idx++) {
    // Serial.print("initalized channel ");
    // Serial.println(idx);
    Channels[idx].pin = grPins[idx];
    pinMode(Channels[idx].pin, INPUT_PULLUP);
    Channels[idx].lastPin = digitalRead(Channels[idx].pin);

  }  //for

}  //setup

void loop() {
  //check channel inputs every loop
  PWMRead();

  // send measured PWM values to pixhawk
  timeNow = millis();
  if ((timeNow - timePrint) >= 20ul) {
    timePrint = timeNow;

    idx = 0;
    do {
      // Serial.print("\tCH:");
      // Serial.print(idx + 1);
      // Serial.print(" ");
      // Serial.print(Channels[idx].tWidth);
      Serial.print(Channels[idx].tWidth);
      Serial.print(",");

      //each loop through printing check PWMs
      //so we lessen the effect of the relatively long
      //print time
      PWMRead();

    } while (++idx < NUM_CHANNELS - 1);

    Serial.println(Channels[NUM_CHANNELS - 1].tWidth);
    PWMRead();

  }  //if

}  //loop

void PWMRead() {

  uint32_t timeNow = micros();
  // Serial.print("checked channel ");
  // Serial.println(channel);

  //each pass we check one channel
  //read the state of the input
  uint8_t nowPin = digitalRead(Channels[channel].pin);
  //if now the same as last...
  if (nowPin != Channels[channel].lastPin) {
    //save as new last
    Channels[channel].lastPin = nowPin;

    //if high now...
    if (nowPin == HIGH) {
      //pin changed from low to high; log the uS count now
      Channels[channel].tStart = timeNow;
    } else {
      //pin changed from high to low; uS count now minus start is width
      //and map tWidth to 0 to 180
      Channels[channel].tWidth = (timeNow - Channels[channel].tStart);

    }  //else

  }  //if

  //bump to next channel
  channel++;
  if (channel >= NUM_CHANNELS)
    channel = 0;
}  //PWMRead
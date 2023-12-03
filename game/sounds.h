#pragma once

//melody sounds comes from chat gpt, I am not good at music
void playWinSound(int speaker_pin) {
  int melody[] = {659, 659, 880, 659, 523, 587, 494, 523};
  int noteDuration = 200;
  
  for (int i = 0; i < sizeof(melody) / sizeof(melody[0]); i++) {
    tone(speaker_pin, melody[i], noteDuration);
    delay(noteDuration + 50);  // Add a small delay between each note
  }
  
  noTone(speaker_pin);  // Stop playing the melody
}

void playLostSound(int speaker_pin)
{
  int melody[] = {131, 117, 104, 98, 87, 78, 69};
  int noteDuration = 200;
  
  for (int i = 0; i < sizeof(melody) / sizeof(melody[0]); i++) {
    tone(speaker_pin, melody[i], noteDuration);
    delay(noteDuration + 50);  // Add a small delay between each note
  }
  
  noTone(speaker_pin);  // Stop playing the melody
}

void playFailSound(int speaker_pin) {
   // Define the frequencies for the "fail" sound
  int frequencies[] = { 440, 392, 349, 293, 261 };

  // Play the frequencies in sequence
  for (int i = 0; i < 5; i++) {
    tone(speaker_pin, frequencies[i], 200);
    delay(200);
  }

  noTone(speaker_pin);  // Stop playing the sound
}

void playClickButtonSound(int speaker_pin) {
  tone(speaker_pin, 1000, 60);
  noTone(speaker_pin);
}

void playTone(int speaker_pin, int frequency, int duration) {
  tone(speaker_pin, frequency, duration);
  delay(duration);
  noTone(speaker_pin);
  //delay(50);
}

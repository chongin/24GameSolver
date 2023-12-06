import RPi.GPIO as GPIO
import time

class LED:
    def __init__(self, pin):
        self.pin = pin
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(self.pin, GPIO.OUT)

    def on(self):
        GPIO.output(self.pin, GPIO.HIGH)

    def off(self):
        GPIO.output(self.pin, GPIO.LOW)

    def blink(self, duration=0.5, repetitions=3):
        for _ in range(repetitions):
            self.on()
            time.sleep(duration)
            self.off()
            time.sleep(duration)

    def cleanup(self):
        GPIO.cleanup()

    def handle_on(self):
        self.blink()
        self.on()
    
    def handle_off(self):
        self.blink()
        self.off()

class WinLED(LED):
    def __init__(self):
        super().__init__(pin=26)


class LoseLED(LED):
    def __init__(self):
        super().__init__(pin=20)
import serial
import time
import json

# Define the serial port and baud rate
ser = serial.Serial('/dev/ttyACM0', 9600)  # Update the port accordingly

try:
    while True:
        # Create a JSON object
        data = {
            "command": "LED",
            "value": 1  # Change this value based on your needs
        }

        # Send JSON data to Arduino
        ser.write(json.dumps(data).encode('utf-8'))

        # Read response from Arduino
        response = ser.readline().decode('utf-8')
        if response:
            print(f"Raspberry Pi received response: {response}")

        time.sleep(1)  # Add a delay for stability

except KeyboardInterrupt:
    ser.close()
    print("Serial connection closed.")

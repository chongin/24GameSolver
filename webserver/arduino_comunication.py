import serial
import time
import json

# Define the serial port and baud rate
raspberrypi_port = '/dev/ttyACM0'
mac_port = '/dev/cu.usbmodem1401'
ser = serial.Serial(mac_port, 115200)  # Update the port accordingly

try:
    count = 0
    while True:
        # Create a JSON object
        count += 1
        result = 1 if count % 2 == 0 else 1
        data = {
            "command": "LED",
            "value": 1  # Change this value based on your needs
        }

        sd = json.dumps(data).encode('utf-8')
        print(sd)
        # Send JSON data to Arduino
        ser.write(sd)

        # Read response from Arduino
        response = ser.readline().decode('utf-8')
        if response:
            print(response)
            if 'Ready' in response:
                print(f"Receive Ready.#{response}")
            else:
                hash = json.loads(response)
                print(f"Raspberry Pi received response: {hash}")

        time.sleep(1)  # Add a delay for stability

except KeyboardInterrupt:
    ser.close()
    print("Serial connection closed.")
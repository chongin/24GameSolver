# import serial
# import time
# import json

# # Define the serial port and baud rate
# raspberrypi_port = '/dev/ttyACM0'
# mac_port = '/dev/cu.usbmodem1301'
# ser = serial.Serial(mac_port, 115200)  # Update the port accordingly

import serial
import time
import json
import threading

class SerialCommunication:
    def __init__(self, port, baud_rate=115200):
        self.port = port
        self.baud_rate = baud_rate
        self.ser = serial.Serial(self.port, self.baud_rate)

    def send_data(self, command, data):
        data = {
            "command": command,
            "data": data
        }
        serialized_data = json.dumps(data).encode('utf-8')
        print(f"send data: {serialized_data}")
        self.ser.write(serialized_data)

    def read_data(self):
        response = self.ser.readline().decode('utf-8')
        if response:
            print(f"Received response: {response}")
            if 'Ready' in response:
                print("Received Ready.")
            else:
                try:
                    parsed_response = json.loads(response)
                    print(f"Received response: {parsed_response}")
                except json.JSONDecodeError as e:
                    print(f"Error decoding JSON: {e}")

    def run_communication(self):
        count = 0
        try:
            while True:
                count += 1
                self.read_data()
                print(f"total receive message: {count}")
        except KeyboardInterrupt:
            self.ser.close()
            print("Serial connection closed.")

communication = None
def start_serial_communication():
    port = '/dev/cu.usbmodem1301'  # Update the port accordingly

    communication = SerialCommunication(port)
    communication.run_communication()

if __name__ == "__main__":
    # Start the serial communication on a separate thread
    serial_thread = threading.Thread(target=start_serial_communication)
    serial_thread.start()
    
    time.sleep(1)
    communication.send_data("LED", 1)
    # Add your main program logic here if needed
    # ...

    # Wait for the serial thread to finish (optional)
    serial_thread.join()

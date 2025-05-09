# python comparing script (from chatGPT)
import serial
import time

# Configuration for serial port
SERIAL_PORT = 'COM3
BAUD_RATE = 9600
EXPECTED_RESULTS = [
    ('0b00000000', 'Reset State'),
    ('0b10101010', 'Data Loaded'),
    ('0b01010101', 'Data Loaded'),
]

def read_uart():
    with serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1) as ser:
        time.sleep(2)  # Wait for the serial connection to initialize
        results = []
        for _ in range(len(EXPECTED_RESULTS)):
            data = ser.readline().decode().strip()  # Read line from UART
            results.append(data)
            print(f"Received: {data}")
    return results

def compare_results(received, expected):
    for i, (data, desc) in enumerate(expected):
        if i < len(received):
            if received[i] != data:
                print(f"Mismatch: Expected {data} for {desc}, but got {received[i]}")
            else:
                print(f"Match: {data} for {desc}")

if __name__ == "__main__":
    received_results = read_uart()
    compare_results(received_results, EXPECTED_RESULTS)

# Received: 0b00000000
# Match: 0b00000000 for Reset State
# Received: 0b10101010
# Match: 0b10101010 for Data Loaded
# Received: 0b01010101
# Mismatch: Expected 0b01010101 for Data Loaded, but got 0b10101010
# Received: 0b11001100
# Match: 0b11001100 for Data Loaded
# Received: 0b11110000
# Mismatch: Expected 0b11110000 for Data Loaded, but got 0b11001100



import os
from flask import Flask, request, jsonify
from cryptography.fernet import Fernet

app = Flask(__name__)

key = os.getenv("FERNET_KEY")
if not key:
    raise ValueError("FERNET_KEY environment variable not set")

f = Fernet(key.encode())

@app.route('/health', methods=['GET'])
def checkHealth():
    return "ok", 200

@app.route('/encrypt', methods=['POST'])
def encryptFlag():
    data = request.get_json()
    flag = data['flag']
    encryptedFlag = f.encrypt(flag.encode()).decode()
    return encryptedFlag

@app.route('/decrypt', methods=['POST'])
def decryptFlag():
    data = request.get_json()
    flag = data['flag']
    decryptedFlag = f.decrypt(flag.encode()).decode()
    return decryptedFlag

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
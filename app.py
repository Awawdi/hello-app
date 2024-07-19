import os

from flask import Flask
import logging

app = Flask(__name__)
log_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'logs')
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'hello_world.log'), level=logging.INFO, format='%(asctime)s - %(message)s')


@app.route("/")
def hello():
    message = "Hello, Kubernetes!"
    logging.info(message)
    return message


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050)

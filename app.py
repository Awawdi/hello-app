from flask import Flask
import logging

app = Flask(__name__)

logging.basicConfig(filename='/logs/hello_world.log', level=logging.INFO, format='%(asctime)s - %(message)s')


@app.route("/")
def hello():
    message = "Hello, Kubernetes!"
    logging.info(message)
    return message


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050)

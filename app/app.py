from flask import Flask, render_template
from flask_socketio import SocketIO
import yaml

app = Flask(__name__)
socketio = SocketIO(app)


@app.route('/')
def index():
    return render_template('index.html')


if __name__ == '__main__':
    app.run(debug=True)

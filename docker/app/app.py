from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def hello():
    name = os.environ.get('NAME', 'World')
    return jsonify(message=f'Hello, {name}!')

@app.route('/health')
def health():
    return jsonify(status='healthy'), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
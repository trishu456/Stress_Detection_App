from flask import Flask, jsonify
import subprocess

app = Flask(__name__)

@app.route('/detect_stress', methods=['GET'])
def detect_stress():
    try:
        process = subprocess.run(
            ['python', 'eyebrow_detection.py'],  
            capture_output=True, text=True
        )

        if process.returncode == 0:
            return jsonify({"status": "success", "message": "Stress detection started!"}), 200
        else:
            return jsonify({"status": "error", "message": process.stderr}), 500

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
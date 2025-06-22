import os
import logging
from flask import Flask, request, jsonify, render_template, send_from_directory
from werkzeug.utils import secure_filename

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads'
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

# In-memory database
items_db = {
    1: {"id": 1, "name": "First Item", "description": "This is the first item."},
    2: {"id": 2, "name": "Second Item", "description": "This is the second item."}
}
next_id = 3

@app.before_request
def log_request_info():
    app.logger.info('Request: %s %s', request.method, request.url)

@app.route('/')
def index():
    app.logger.info("Serving main page")
    return render_template('index.html')

# API for items (CRUD)
@app.route('/api/items', methods=['GET', 'POST'])
def handle_items():
    global next_id
    if request.method == 'POST':
        data = request.json
        app.logger.info(f"Creating new item with data: {data}")
        if not data or 'name' not in data:
            app.logger.error("Item creation failed: name is missing")
            return jsonify({"error": "Missing name"}), 400
        new_item = {
            "id": next_id,
            "name": data['name'],
            "description": data.get('description', '')
        }
        items_db[next_id] = new_item
        next_id += 1
        app.logger.info(f"Successfully created item with ID: {new_item['id']}")
        return jsonify(new_item), 201
    app.logger.info("Fetching all items")
    return jsonify(list(items_db.values()))

@app.route('/api/items/<int:item_id>', methods=['GET', 'PUT', 'DELETE'])
def handle_item(item_id):
    if item_id not in items_db:
        app.logger.warning(f"Attempted to access non-existent item with ID: {item_id}")
        return jsonify({"error": "Item not found"}), 404
    if request.method == 'GET':
        app.logger.info(f"Fetching item with ID: {item_id}")
        return jsonify(items_db[item_id])
    if request.method == 'PUT':
        data = request.json
        app.logger.info(f"Updating item {item_id} with data: {data}")
        items_db[item_id]['name'] = data.get('name', items_db[item_id]['name'])
        items_db[item_id]['description'] = data.get('description', items_db[item_id]['description'])
        return jsonify(items_db[item_id])
    if request.method == 'DELETE':
        app.logger.info(f"Deleting item with ID: {item_id}")
        del items_db[item_id]
        return '', 204

# API for file uploads
@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        app.logger.error("Upload failed: No file part in request")
        return jsonify({"error": "No file part"}), 400
    file = request.files['file']
    if file.filename == '':
        app.logger.error("Upload failed: No file selected")
        return jsonify({"error": "No selected file"}), 400
    if file:
        filename = secure_filename(file.filename)
        app.logger.info(f"Receiving file for upload: {filename}")
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        app.logger.info(f"Successfully saved file: {filename}")
        return jsonify({"message": f"File {filename} uploaded successfully"}), 201

@app.route('/files', methods=['GET'])
def list_files():
    app.logger.info("Fetching list of uploaded files")
    files = os.listdir(app.config['UPLOAD_FOLDER'])
    return jsonify(files)

@app.route('/download/<path:filename>')
def download_file(filename):
    app.logger.info(f"Serving file for download: {filename}")
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename, as_attachment=True)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
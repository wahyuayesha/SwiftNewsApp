from flask import Blueprint, request, jsonify
import mysql.connector

bookmark_bp = Blueprint('bookmark', __name__)

db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="swiftnews_db"
)

cursor = db.cursor(dictionary=True)

# -- BOOKMARKED NEWS CRUD API

# CREATE (POST) - Tambahkan bookmark
@bookmark_bp.route('/bookmark', methods=['POST'])
def add_bookmark():
    data = request.get_json()
    user_id = data.get('user_id')
    title = data.get('title')
    url = data.get('url')
    imageUrl = data.get('imageUrl')  
    source = data.get('source')

    cursor.execute('INSERT INTO bookmarks (user_id, title, url, urlToImage, source) VALUES (%s, %s, %s, %s, %s)', (user_id, title, url, imageUrl, source))
    db.commit()
    
    return jsonify({"message": "Bookmark added successfully!"}), 201


# READ (GET) - Ambil semua bookmark user saat ini
@bookmark_bp.route('/get-bookmark', methods=['GET'])
def get_bookmark():
    user_id = request.args.get('user_id')  # Mendapatkan user_id dari query parameter
    if not user_id:
        return jsonify({'error': 'user_id is required'}), 400
    
    if user_id:
        cursor.execute('SELECT * FROM bookmarks WHERE user_id = %s', (user_id,))
        bookmarks = cursor.fetchall()
        return jsonify(bookmarks), 200
    else:
        return jsonify({"message": "user_id is required"}), 400


@bookmark_bp.route('/delete-bookmark', methods=['POST'])
def delete_bookmark():
    data = request.get_json()
    user_id = data.get('user_id')
    title = data.get('title')

    cursor.execute('DELETE FROM bookmarks WHERE user_id = %s AND title = %s', (user_id, title))
    db.commit()

    return jsonify({"message": "Bookmark deleted successfully!"}), 200

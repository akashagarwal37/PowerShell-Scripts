from flask import Flask
UPLOAD_FOLDER = 'C:/Users/aagarw33/Desktop/Python Training-2022/Flask Projects/Uploads'
app = Flask(__name__)
app.secret_key = "secret key"
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024
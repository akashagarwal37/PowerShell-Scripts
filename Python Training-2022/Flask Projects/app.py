from flask import Flask   
app = Flask(__name__)   # Flask constructor
# A decorator used to tell the application which URL is associated to function
@app.route('/hello/<name>')     
def hello_name(name):
    return 'Hello %s!'%name
if __name__=='__main__':
   app.run()

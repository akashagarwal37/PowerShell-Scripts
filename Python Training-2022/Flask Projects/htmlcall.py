from flask import Flask, redirect, url_for,render_template

app = Flask(__name__)

@app.route('/')  #decorator for route(argument) function
def index():
    return render_template("hello.html")

if __name__ == '__main__':

  app.run()

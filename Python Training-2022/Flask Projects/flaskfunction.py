from flask import Flask,render_template,request,redirect
app = Flask(__name__)
@app.route('/form')
def form():
    return render_template('form.html')
@app.route('/verify', methods = ['POST', 'GET'])
def verify():
    if request.method == 'POST':
        name = request.form['name']
        return redirect(f"/user/{name}")
    else:
        abort(401)
@app.route('/user/<name>')
def user(name):
    return f"Your name is {name}"
if __name__ == "__main__":
   app.run()

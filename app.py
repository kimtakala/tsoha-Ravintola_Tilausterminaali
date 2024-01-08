from flask import Flask, render_template, request

app = Flask(__name__)

@app.route("/")
def index():
    return render_template('index.html')

@app.route("/page/<int:id>")
def page(id):
    return render_template('page.html', id=str(id))

@app.route("/form")
def form():
    return render_template("form.html")

@app.route("/result", methods=["POST"])
def result():
    return render_template("result.html", name=request.form["name"])

@app.route("/order")
def order():
    return render_template("order.html")

@app.route("/pizzaresult", methods=["POST"])
def pizzaresult():
    pizza = request.form["pizza"]
    extras = request.form.getlist("extra")
    message = request.form["message"]
    return render_template("pizzaresult.html", pizza=pizza,
                                          extras=extras,
                                          message=message)
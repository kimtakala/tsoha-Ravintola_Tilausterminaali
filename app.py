from os import getenv
from flask import Flask, redirect, render_template, request, session
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import check_password_hash, generate_password_hash
from sqlalchemy.sql import text #! MUISTA KÄYTTÄÄ executen sisällä: execute(text('sql'))

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = getenv("DATABASE_URL")
app.secret_key = getenv("SECRET_KEY")
db = SQLAlchemy(app)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/login",methods=["POST"])
def login():
    username = request.form["username"]
    passwordtry = generate_password_hash(request.form["password"])
    sql = "SELECT id, passwordhash, admin FROM users WHERE username=:username AND removed != TRUE"
    result = db.session.execute(text(sql), {"username":username})
    user = result.fetchone()
    if not user:
        session['incorrect_values'] = True
    else:
        hash_value = user.passwordhash
        if check_password_hash(hash_value, passwordtry):
            session['logged in'] = True
            session['admin'] = user.admin
        else:
            session['incorrect values'] = True

    session["username"] = username
    return redirect("/")

@app.route("/logout")
def logout():
    del session["username"]
    return redirect("/")
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
    password = request.form["password"]
    sql = "SELECT id, passwordhash, admin FROM users WHERE username=:username AND removed != TRUE"
    result = db.session.execute(text(sql), {"username":username})
    user = result.fetchone()
    if not user:
        session['incorrect_values'] = True
    else:
        hash_value = user.passwordhash
        if check_password_hash(hash_value, password):
            session['logged_in'] = True
            session['admin'] = user.admin
        else:
            session['incorrect_values'] = True

    session["username"] = username
    return redirect("/")

@app.route("/register",methods=["POST"])
def register():
    username = request.form["username"]
    password = generate_password_hash(request.form["password"])
    session['admin'] = False
    sql = "SELECT id FROM users WHERE username=:username"
    result = db.session.execute(text(sql), {"username":username})

    # Check existing user
    if result.fetchone():
        session['user_exists'] = True
    else:
        # Check admin password
        if (admin_password := request.form['admin_password']):
            admin_hash = getenv("ADMIN_PASSWORD")
            if check_password_hash(admin_hash, admin_password):
                session['admin'] = True
            else:
                session['incorrect_admin_password'] = True
        else:
            session['admin'] = False

        # upload data
        if not session['incorrect_admin_password']:
            sql = "INSERT INTO users(admin:=admin, username:=username, passwordhash:=password)"
            admin = session['admin']
            result = db.session.execute(text(sql),{"admin":admin,
                                                   "username":username, "passwordhash":password})
            session.clear()
            session['registeration_successful'] = True

    return redirect("/")

@app.route("/logout")
def logout():
    session.clear()
    return redirect("/")
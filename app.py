from os import getenv
from flask import Flask, redirect, render_template, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql import text

app = Flask(__name__)
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_DATABASE_URI"] = getenv("DATABASE_URL")
db = SQLAlchemy(app)

@app.route("/")
def index():
    result = db.session.execute(text("SELECT content FROM messages"))
    messages = result.fetchall()
    return render_template("index.html", count=len(messages), messages=messages) 

@app.route("/new")
def new():
    return render_template("new.html")

@app.route("/send", methods=["POST"])
def send():
    content = request.form["content"]
    sql = "INSERT INTO messages (content) VALUES (:content)"
    db.session.execute(text(sql), {"content":content})
    db.session.commit()
    return redirect("/")
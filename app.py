'''This is the app.py module, it handels application logic for the web appication.'''
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
    '''Function for index page.'''
    return render_template("index.html", session=session)

@app.route("/login", methods=["POST"])
def login():
    '''Function for logging in.'''
    username = request.form["username"]
    password = request.form["password"]
    sql = 'SELECT id, admin, username, passwordhash FROM users WHERE username=:username'\
        ' AND removed IS NOT TRUE'
    result = db.session.execute(text(sql), {"username":username}).fetchone()
    session.clear()
    if not result:
        session['incorrect_values'] = True
    else:
        hash_value = result.passwordhash
        if check_password_hash(hash_value, password):
            session['logged_in'] = True
            session['admin'] = result.admin
            session["username"] = username
        else:
            session['incorrect_values'] = True
    return redirect("/")

@app.route("/registration", methods=['POST', 'GET'])
def registration():
    '''Function for registration page.'''
    return render_template("registration.html", session=session)

    #! need to add check for not logged in

@app.route("/register", methods=["POST"])
def register():
    '''Function for registration.'''
    username = request.form["username"]
    password = generate_password_hash(request.form["password"])
    admin_password = request.form['admin_password']
    session.clear()
    sql = "SELECT id FROM users WHERE username=:username"
    result = db.session.execute(text(sql), {"username":username})

    # Check existing user
    if result.fetchone():
        session['user_exists'] = True
    else:
        # Check admin password
        if admin_password != "":
            admin_hash = getenv("ADMIN_PASSWORD")
            if check_password_hash(admin_hash, admin_password):
                session['admin'] = True
            else:
                session['admin'] = False
                session['incorrect_admin_password'] = True
        else:
            session['admin'] = False

        # upload data
        if not session.get('incorrect_admin_password'):
            sql = 'INSERT INTO users (admin, username, passwordhash) VALUES'\
                  ' (:admin, :username, :password)'
            admin = session['admin']
            db.session.execute(text(sql),{"admin":admin,
                                        "username":username, "password":password})
            db.session.commit()
            session['registration_successful'] = True
            return redirect("/")

    return redirect("/registration")

@app.route("/menu", methods=['POST'])
def mainmenu():
    '''Function for menu page.'''
    return render_template("mainmenu.html", session=session)

@app.route("/menu/selection", methods=['POST'])
def selectionmenu():
    'Function for menu page.'
    menu_type = request.form["menu_type"]
    sql = 'SELECT * FROM food'\
    ' INNER JOIN food_in_category AS f_i_c'\
    ' ON food.id = f_i_c.food_id'\
    ' INNER JOIN categories AS cat'\
    ' ON f_i_c.category_id = cat.id'\
    ' WHERE cat.name = :menu_type'
    results = db.session.execute(text(sql), {"menu_type":menu_type}).fetchall()

    return render_template("menu.html", session=session, results=results)

@app.route("/editor", methods=['POST', 'GET'])
def editor():
    '''Function for admin editor page.'''
    sql = 'SELECT food.id, food.name, food.price, cat.name as category_name'\
    ' FROM food'\
    ' LEFT JOIN food_in_category as f_i_c'\
    ' ON food.id = f_i_c.food_id'\
    ' LEFT JOIN categories as cat'\
    ' ON f_i_c.category_id = cat.id'\
    ' WHERE food.removed IS NOT true'\
    ' ORDER BY f_i_c.category_id, food.price'
    query = db.session.execute(text(sql))
    results = query.fetchall()
    columns = list(query.keys())
    return render_template("editor.html", session=session, results=results, columns=columns)

@app.route("/add_food_item", methods=['POST', 'GET'])
def addfooditem():
    '''Function for adding food items.'''
    name = request.form["item_name"]
    price = request.form["item_price"].replace(",", ".")
    sql = 'INSERT INTO food (name, price) VALUES'\
            ' (:name, :price) returning id'
    food_id = db.session.execute(text(sql),{"price":price, "name":name}).fetchone()[0]
    db.session.commit()

    food_category = request.form["food_type_selection"]
    category_id = 0
    if food_category == "food":
        category_id = 1
    elif food_category == "snacks":
        category_id = 2
    elif food_category == "drinks":
        category_id = 3

    if category_id:
        sql = 'INSERT INTO food_in_category (food_id, category_id) VALUES'\
            ' (:food_id, :category_id)'
        db.session.execute(text(sql),{"food_id":food_id, "category_id":category_id})
        db.session.commit()
    else:
        print(f'\n{food_category = } unrecognised!\n')

    return redirect("/editor")

@app.route("/category_editor", methods=['POST', 'GET'])
def category_editor():
    '''Function for admin category editor page.'''
    sql = 'SELECT * FROM categories'
    query = db.session.execute(text(sql))
    results = query.fetchall()
    columns = list(query.keys())
    return render_template("category_editor.html", session=session, results=results,
                           columns=columns)

@app.route("/add_category", methods=['POST', 'GET'])
def add_category():
    '''Function for adding categories'''
    name = request.form["category_name"]
    sql = 'INSERT INTO categories (name) VALUES'\
        ' (:name)'
    db.session.execute(text(sql),{"name":name})
    db.session.commit()

    return redirect("/category_editor")

@app.route("/logout")
def logout():
    '''Function for logging out.'''
    session.clear()
    return redirect("/")

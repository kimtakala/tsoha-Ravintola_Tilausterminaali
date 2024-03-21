--
-- PostgreSQL database dump
--

-- Dumped from database version 12.15
-- Dumped by pg_dump version 12.15

DROP TABLE food, categories, foodinfo, orders, users, food_in_category, food_in_order;

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: kitakita
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.categories OWNER TO kitakita;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: kitakita
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO kitakita;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kitakita
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: food; Type: TABLE; Schema: public; Owner: kitakita
--

CREATE TABLE public.food (
    id integer NOT NULL,
    name text NOT NULL,
    price numeric(5,2) NOT NULL,
    removed boolean,
    foodinfo_id integer
);


ALTER TABLE public.food OWNER TO kitakita;

--
-- Name: food_id_seq; Type: SEQUENCE; Schema: public; Owner: kitakita
--

CREATE SEQUENCE public.food_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_id_seq OWNER TO kitakita;

--
-- Name: food_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kitakita
--

ALTER SEQUENCE public.food_id_seq OWNED BY public.food.id;


--
-- Name: food_in_category; Type: TABLE; Schema: public; Owner: kitakita
--

CREATE TABLE public.food_in_category (
    id integer NOT NULL,
    food_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.food_in_category OWNER TO kitakita;

--
-- Name: food_in_category_id_seq; Type: SEQUENCE; Schema: public; Owner: kitakita
--

CREATE SEQUENCE public.food_in_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_in_category_id_seq OWNER TO kitakita;

--
-- Name: food_in_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kitakita
--

ALTER SEQUENCE public.food_in_category_id_seq OWNED BY public.food_in_category.id;


--
-- Name: food_in_order; Type: TABLE; Schema: public; Owner: kitakita
--

CREATE TABLE public.food_in_order (
    id integer NOT NULL,
    food_id integer NOT NULL,
    order_id integer NOT NULL
);


ALTER TABLE public.food_in_order OWNER TO kitakita;

--
-- Name: food_in_order_id_seq; Type: SEQUENCE; Schema: public; Owner: kitakita
--

CREATE SEQUENCE public.food_in_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_in_order_id_seq OWNER TO kitakita;

--
-- Name: food_in_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kitakita
--

ALTER SEQUENCE public.food_in_order_id_seq OWNED BY public.food_in_order.id;


--
-- Name: foodinfo; Type: TABLE; Schema: public; Owner: kitakita
--

CREATE TABLE public.foodinfo (
    id integer NOT NULL,
    kcal integer NOT NULL,
    description text,
    protein integer,
    fat integer,
    carbs integer,
    sugar integer
);


ALTER TABLE public.foodinfo OWNER TO kitakita;

--
-- Name: foodinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: kitakita
--

CREATE SEQUENCE public.foodinfo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.foodinfo_id_seq OWNER TO kitakita;

--
-- Name: foodinfo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kitakita
--

ALTER SEQUENCE public.foodinfo_id_seq OWNED BY public.foodinfo.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: kitakita
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    order_time timestamp without time zone NOT NULL,
    to_go boolean NOT NULL,
    finished boolean
);


ALTER TABLE public.orders OWNER TO kitakita;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: kitakita
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO kitakita;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kitakita
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: kitakita
--

CREATE TABLE public.users (
    id integer NOT NULL,
    admin boolean NOT NULL,
    username text NOT NULL,
    passwordhash text NOT NULL,
    removed boolean
);


ALTER TABLE public.users OWNER TO kitakita;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: kitakita
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO kitakita;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kitakita
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: food id; Type: DEFAULT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.food ALTER COLUMN id SET DEFAULT nextval('public.food_id_seq'::regclass);


--
-- Name: food_in_category id; Type: DEFAULT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.food_in_category ALTER COLUMN id SET DEFAULT nextval('public.food_in_category_id_seq'::regclass);


--
-- Name: food_in_order id; Type: DEFAULT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.food_in_order ALTER COLUMN id SET DEFAULT nextval('public.food_in_order_id_seq'::regclass);


--
-- Name: foodinfo id; Type: DEFAULT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.foodinfo ALTER COLUMN id SET DEFAULT nextval('public.foodinfo_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: food_in_category food_in_category_pkey; Type: CONSTRAINT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.food_in_category
    ADD CONSTRAINT food_in_category_pkey PRIMARY KEY (id);


--
-- Name: food_in_order food_in_order_pkey; Type: CONSTRAINT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.food_in_order
    ADD CONSTRAINT food_in_order_pkey PRIMARY KEY (id);


--
-- Name: food food_pkey; Type: CONSTRAINT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.food
    ADD CONSTRAINT food_pkey PRIMARY KEY (id);


--
-- Name: foodinfo foodinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.foodinfo
    ADD CONSTRAINT foodinfo_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: food_in_category fk_fic_categories; Type: FK CONSTRAINT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.food_in_category
    ADD CONSTRAINT fk_fic_categories FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: food_in_category fk_fic_food; Type: FK CONSTRAINT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.food_in_category
    ADD CONSTRAINT fk_fic_food FOREIGN KEY (food_id) REFERENCES public.food(id);


--
-- Name: food food_foodinfo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.food
    ADD CONSTRAINT food_foodinfo_id_fkey FOREIGN KEY (foodinfo_id) REFERENCES public.foodinfo(id);


--
-- Name: food_in_order food_in_order_food_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.food_in_order
    ADD CONSTRAINT food_in_order_food_id_fkey FOREIGN KEY (food_id) REFERENCES public.food(id);


--
-- Name: food_in_order food_in_order_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.food_in_order
    ADD CONSTRAINT food_in_order_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kitakita
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


INSERT INTO public.categories (name) VALUES ('food'), ('snacks'), ('drinks');

--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.13
-- Dumped by pg_dump version 9.1.13
-- Started on 2014-08-11 12:40:09 BRT

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 168 (class 3079 OID 11723)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 1982 (class 0 OID 0)
-- Dependencies: 168
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 166 (class 1259 OID 16714)
-- Dependencies: 1852 5
-- Name: group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "group" (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(255),
    user_count integer DEFAULT 1
);


ALTER TABLE public."group" OWNER TO postgres;

--
-- TOC entry 165 (class 1259 OID 16712)
-- Dependencies: 5 166
-- Name: group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_id_seq OWNER TO postgres;

--
-- TOC entry 1983 (class 0 OID 0)
-- Dependencies: 165
-- Name: group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE group_id_seq OWNED BY "group".id;


--
-- TOC entry 167 (class 1259 OID 16749)
-- Dependencies: 5
-- Name: group_members; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE group_members (
    group_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.group_members OWNER TO postgres;

--
-- TOC entry 164 (class 1259 OID 16697)
-- Dependencies: 1850 5
-- Name: message; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE message (
    id integer NOT NULL,
    user_id integer,
    body text NOT NULL,
    message_date timestamp without time zone DEFAULT now()
);


ALTER TABLE public.message OWNER TO postgres;

--
-- TOC entry 163 (class 1259 OID 16695)
-- Dependencies: 164 5
-- Name: message_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_id_seq OWNER TO postgres;

--
-- TOC entry 1984 (class 0 OID 0)
-- Dependencies: 163
-- Name: message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE message_id_seq OWNED BY message.id;


--
-- TOC entry 162 (class 1259 OID 16670)
-- Dependencies: 1848 5
-- Name: user; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    login character varying(20) NOT NULL,
    password character(32) NOT NULL,
    name character varying(40),
    birth date NOT NULL,
    description text,
    origin character varying(32) DEFAULT md5('sistema do hugo'::text) NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 161 (class 1259 OID 16668)
-- Dependencies: 5 162
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_id_seq OWNER TO postgres;

--
-- TOC entry 1985 (class 0 OID 0)
-- Dependencies: 161
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE usuario_id_seq OWNED BY "user".id;


--
-- TOC entry 1851 (class 2604 OID 16717)
-- Dependencies: 166 165 166
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "group" ALTER COLUMN id SET DEFAULT nextval('group_id_seq'::regclass);


--
-- TOC entry 1849 (class 2604 OID 16700)
-- Dependencies: 164 163 164
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY message ALTER COLUMN id SET DEFAULT nextval('message_id_seq'::regclass);


--
-- TOC entry 1847 (class 2604 OID 16673)
-- Dependencies: 162 161 162
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('usuario_id_seq'::regclass);


--
-- TOC entry 1973 (class 0 OID 16714)
-- Dependencies: 166 1975
-- Data for Name: group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "group" (id, user_id, name, user_count) FROM stdin;
22	12	Camaradas	1
23	27	Nome do grupo	1
\.


--
-- TOC entry 1986 (class 0 OID 0)
-- Dependencies: 165
-- Name: group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('group_id_seq', 23, true);


--
-- TOC entry 1974 (class 0 OID 16749)
-- Dependencies: 167 1975
-- Data for Name: group_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY group_members (group_id, user_id) FROM stdin;
22	25
22	26
23	12
\.


--
-- TOC entry 1971 (class 0 OID 16697)
-- Dependencies: 164 1975
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY message (id, user_id, body, message_date) FROM stdin;
20	25	Proletários de todo o mundo, uni-vos!	2014-08-10 23:09:24.403444
21	25	Puts, esqueci a piada com mais-valia. Droga.	2014-08-10 23:10:03.865728
22	26	Status: matando uns nazis aqui na moralzinha	2014-08-10 23:35:48.145251
23	26	Se alguém viu o Trotsky chama inbox	2014-08-10 23:36:31.869257
24	25	Essa rede social não pertence ao monopólio imperialista, aconselho à todos!	2014-08-10 23:37:01.615823
26	27	A grafia correta é Slavoj iek!!	2014-08-11 00:08:12.056479
13	12	mençagem com asséntôs!!	2014-08-07 22:26:38.565881
29	12	Oi, como vai você?	2014-08-11 01:11:31.861359
30	12	Lorem ipsum...	2014-08-11 09:45:14.893248
\.


--
-- TOC entry 1987 (class 0 OID 0)
-- Dependencies: 163
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('message_id_seq', 31, true);


--
-- TOC entry 1969 (class 0 OID 16670)
-- Dependencies: 162 1975
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "user" (id, login, password, name, birth, description, origin) FROM stdin;
25	marx	e8d95a51f3af4a3b134bf6bb680a213a	Karl Marx	1818-05-05	\N	48216405f8f70518a1a3800d18bd643c
26	stalin	e8d95a51f3af4a3b134bf6bb680a213a	Josef Stalin	1879-12-18	\N	48216405f8f70518a1a3800d18bd643c
27	zizek	e8d95a51f3af4a3b134bf6bb680a213a	Slavij Zizek	1949-03-21	Slavoj iek (Liubliana, 21 de março de 1949) é um filósofo e teórico crítico e cientista social esloveno.1 É professor da European Graduate School e pesquisador sénior no Instituto de Sociologia da Universidade de Liubliana. É também professor visitante em várias universidades estadunidenses, entre as quais estão a Universidade de Columbia, Princeton, a New School for Social Research, de Nova Iorque, e a Universidade de Michigan.	48216405f8f70518a1a3800d18bd643c
12	hugo	e8d95a51f3af4a3b134bf6bb680a213a	Hugo Abonizio	1993-08-24	Oi, eu sou o Goku	48216405f8f70518a1a3800d18bd643c
\.


--
-- TOC entry 1988 (class 0 OID 0)
-- Dependencies: 161
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuario_id_seq', 29, true);


--
-- TOC entry 1860 (class 2606 OID 16720)
-- Dependencies: 166 166 1976
-- Name: group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (id);


--
-- TOC entry 1858 (class 2606 OID 16706)
-- Dependencies: 164 164 1976
-- Name: message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- TOC entry 1854 (class 2606 OID 16675)
-- Dependencies: 162 162 1976
-- Name: pk_user; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT pk_user PRIMARY KEY (id);


--
-- TOC entry 1862 (class 2606 OID 16753)
-- Dependencies: 167 167 167 1976
-- Name: pks; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY group_members
    ADD CONSTRAINT pks PRIMARY KEY (group_id, user_id);


--
-- TOC entry 1856 (class 2606 OID 16677)
-- Dependencies: 162 162 1976
-- Name: unique_login; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT unique_login UNIQUE (login);


--
-- TOC entry 1865 (class 2606 OID 16754)
-- Dependencies: 1859 166 167 1976
-- Name: group_members_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_members
    ADD CONSTRAINT group_members_group_id_fkey FOREIGN KEY (group_id) REFERENCES "group"(id) ON DELETE CASCADE;


--
-- TOC entry 1866 (class 2606 OID 16759)
-- Dependencies: 162 167 1853 1976
-- Name: group_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_members
    ADD CONSTRAINT group_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1863 (class 2606 OID 16739)
-- Dependencies: 162 164 1853 1976
-- Name: user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY message
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1864 (class 2606 OID 16744)
-- Dependencies: 1853 166 162 1976
-- Name: user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1981 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2014-08-11 12:40:09 BRT

--
-- PostgreSQL database dump complete
--


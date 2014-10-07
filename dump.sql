--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.13
-- Dumped by pg_dump version 9.1.13
-- Started on 2014-09-01 13:50:00 BRT

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 172 (class 3079 OID 11723)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2021 (class 0 OID 0)
-- Dependencies: 172
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 184 (class 1255 OID 16862)
-- Dependencies: 524 5
-- Name: fn_update_original_message_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fn_update_original_message_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF NEW.original_message_id IS NULL OR NEW.original_message_id = 0 THEN
			UPDATE "message" SET original_message_id = NEW.id WHERE id = NEW.id;
		END IF;
		
		RETURN NEW;
	END;
$$;


ALTER FUNCTION public.fn_update_original_message_id() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 170 (class 1259 OID 16829)
-- Dependencies: 1871 5
-- Name: comment; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comment (
    message_id integer NOT NULL,
    user_id integer NOT NULL,
    body text NOT NULL,
    comment_date timestamp without time zone DEFAULT now()
);


ALTER TABLE public.comment OWNER TO postgres;

--
-- TOC entry 168 (class 1259 OID 16789)
-- Dependencies: 5
-- Name: follow; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE follow (
    follower_id integer NOT NULL,
    followed_id integer NOT NULL
);


ALTER TABLE public.follow OWNER TO postgres;

--
-- TOC entry 166 (class 1259 OID 16714)
-- Dependencies: 1870 5
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
-- TOC entry 2022 (class 0 OID 0)
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
-- TOC entry 171 (class 1259 OID 16866)
-- Dependencies: 5
-- Name: hashtag; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE hashtag (
    tag character varying(32) NOT NULL,
    message_id integer NOT NULL
);


ALTER TABLE public.hashtag OWNER TO postgres;

--
-- TOC entry 169 (class 1259 OID 16804)
-- Dependencies: 5
-- Name: like; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "like" (
    message_id integer NOT NULL,
    user_id integer NOT NULL,
    value integer
);


ALTER TABLE public."like" OWNER TO postgres;

--
-- TOC entry 164 (class 1259 OID 16697)
-- Dependencies: 1868 5
-- Name: message; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE message (
    id integer NOT NULL,
    user_id integer,
    body text NOT NULL,
    message_date timestamp without time zone DEFAULT now(),
    original_user_id integer,
    original_message_id integer
);


ALTER TABLE public.message OWNER TO postgres;

--
-- TOC entry 163 (class 1259 OID 16695)
-- Dependencies: 5 164
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
-- TOC entry 2023 (class 0 OID 0)
-- Dependencies: 163
-- Name: message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE message_id_seq OWNED BY message.id;


--
-- TOC entry 162 (class 1259 OID 16670)
-- Dependencies: 1866 5
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
-- TOC entry 2024 (class 0 OID 0)
-- Dependencies: 161
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE usuario_id_seq OWNED BY "user".id;


--
-- TOC entry 1869 (class 2604 OID 16717)
-- Dependencies: 166 165 166
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "group" ALTER COLUMN id SET DEFAULT nextval('group_id_seq'::regclass);


--
-- TOC entry 1867 (class 2604 OID 16700)
-- Dependencies: 164 163 164
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY message ALTER COLUMN id SET DEFAULT nextval('message_id_seq'::regclass);


--
-- TOC entry 1865 (class 2604 OID 16673)
-- Dependencies: 161 162 162
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('usuario_id_seq'::regclass);


--
-- TOC entry 2012 (class 0 OID 16829)
-- Dependencies: 170 2014
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY comment (message_id, user_id, body, comment_date) FROM stdin;
24	12	comentario no id 24	2014-08-31 15:22:18.220778
67	12	coementário nesse	2014-08-31 20:47:54.5599
68	12	comentário	2014-08-31 20:48:51.490995
70	12	comentário	2014-08-31 23:03:08.198247
72	27	Comentário do Zizek!	2014-09-01 12:57:44.173728
\.


--
-- TOC entry 2010 (class 0 OID 16789)
-- Dependencies: 168 2014
-- Data for Name: follow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY follow (follower_id, followed_id) FROM stdin;
12	26
12	25
\.


--
-- TOC entry 2008 (class 0 OID 16714)
-- Dependencies: 166 2014
-- Data for Name: group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "group" (id, user_id, name, user_count) FROM stdin;
23	27	Nome do grupo	1
25	12	qaaaaaa	1
26	12	grupo_do_hugo	1
22	12	camaradas	1
\.


--
-- TOC entry 2025 (class 0 OID 0)
-- Dependencies: 165
-- Name: group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('group_id_seq', 26, true);


--
-- TOC entry 2009 (class 0 OID 16749)
-- Dependencies: 167 2014
-- Data for Name: group_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY group_members (group_id, user_id) FROM stdin;
22	26
23	12
25	25
25	26
22	25
26	26
\.


--
-- TOC entry 2013 (class 0 OID 16866)
-- Dependencies: 171 2014
-- Data for Name: hashtag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY hashtag (tag, message_id) FROM stdin;
test	67
test	68
outra	68
marxismo	24
test	72
test	73
test	0
\.


--
-- TOC entry 2011 (class 0 OID 16804)
-- Dependencies: 169 2014
-- Data for Name: like; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "like" (message_id, user_id, value) FROM stdin;
24	27	1
24	26	1
24	25	1
21	12	-1
20	12	1
22	12	1
24	12	1
23	12	1
72	12	1
72	27	1
\.


--
-- TOC entry 2006 (class 0 OID 16697)
-- Dependencies: 164 2014
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY message (id, user_id, body, message_date, original_user_id, original_message_id) FROM stdin;
67	12	agora sim #test	2014-08-31 20:08:14.291769	12	67
68	12	e mais uma #test! e #outra	2014-08-31 20:08:20.71158	12	68
24	25	Essa rede social não pertence ao monopólio imperialista, aconselho à todos! #marxismo	2014-08-10 23:37:01.615823	25	24
52	12	Essa rede social não pertence ao monopólio imperialista, aconselho à todos! #marxismo	2014-08-31 15:22:05.05923	25	24
69	12	Olá, turma! A pedido do @joao, segue o vídeo da aula de hoje: $v:"/app/media/aula-hoje.ogg". O conteúdo é tranquilo... $i:"http://upload.wikimedia.org/wikipedia/commons/b/b7/Big_smile.png"	2014-08-31 22:59:07.89912	12	69
70	12	Video do youtube $y:"LOHLCmivnBo"	2014-08-31 23:02:57.821455	12	70
71	12	Um link $l:"http://localhost:8084"	2014-08-31 23:04:34.90556	12	71
72	25	Publicação com a hashtag #test	2014-08-31 23:12:07.905251	25	72
73	27	uma hashtag #test	2014-09-01 12:57:23.525923	27	73
74	27	Imagem: $i:"http://localhost:8080/Captura%20de%20tela%20de%202014-08-18%2022%3A09%3A26.png"	2014-09-01 12:58:41.511221	27	74
75	27	Publicação com a hashtag #test	2014-09-01 13:02:09.722395	25	72
20	25	Proletários de todo o mundo, uni-vos!	2014-08-10 23:09:24.403444	25	20
21	25	Puts, esqueci a piada com mais-valia. Droga.	2014-08-10 23:10:03.865728	25	21
22	26	Status: matando uns nazis aqui na moralzinha	2014-08-10 23:35:48.145251	26	22
23	26	Se alguém viu o Trotsky chama inbox	2014-08-10 23:36:31.869257	26	23
26	27	A grafia correta é Slavoj iek!!	2014-08-11 00:08:12.056479	27	26
13	12	mençagem com asséntôs!!	2014-08-07 22:26:38.565881	12	13
36	12	teste 2	2014-08-28 17:02:25.375679	12	36
43	12	mensagem com trigger	2014-08-31 11:05:13.868968	12	43
47	12	testando 2	2014-08-31 11:16:37.877517	12	47
48	12	testeee	2014-08-31 11:31:48.701438	12	48
49	12	com mention para @marx	2014-08-31 14:54:28.933577	12	49
\.


--
-- TOC entry 2026 (class 0 OID 0)
-- Dependencies: 163
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('message_id_seq', 75, true);


--
-- TOC entry 2004 (class 0 OID 16670)
-- Dependencies: 162 2014
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "user" (id, login, password, name, birth, description, origin) FROM stdin;
25	marx	e8d95a51f3af4a3b134bf6bb680a213a	Karl Marx	1818-05-05	\N	48216405f8f70518a1a3800d18bd643c
26	stalin	e8d95a51f3af4a3b134bf6bb680a213a	Josef Stalin	1879-12-18	\N	48216405f8f70518a1a3800d18bd643c
27	zizek	e8d95a51f3af4a3b134bf6bb680a213a	Slavoj Zizek	1949-03-21	Slavoj iek (Liubliana, 21 de março de 1949) é um filósofo e teórico crítico e cientista social esloveno.1 É professor da European Graduate School e pesquisador sénior no Instituto de Sociologia da Universidade de Liubliana. É também professor visitante em várias universidades estadunidenses, entre as quais estão a Universidade de Columbia, Princeton, a New School for Social Research, de Nova Iorque, e a Universidade de Michigan.	48216405f8f70518a1a3800d18bd643c
12	hugo	e8d95a51f3af4a3b134bf6bb680a213a	Hugo Queiroz Abonizio	1993-08-26	Oi, eu sou o Goku	48216405f8f70518a1a3800d18bd643c
\.


--
-- TOC entry 2027 (class 0 OID 0)
-- Dependencies: 161
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuario_id_seq', 30, true);


--
-- TOC entry 1879 (class 2606 OID 16720)
-- Dependencies: 166 166 2015
-- Name: group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (id);


--
-- TOC entry 1877 (class 2606 OID 16706)
-- Dependencies: 164 164 2015
-- Name: message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- TOC entry 1885 (class 2606 OID 16793)
-- Dependencies: 168 168 168 2015
-- Name: pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY follow
    ADD CONSTRAINT pk PRIMARY KEY (follower_id, followed_id);


--
-- TOC entry 1889 (class 2606 OID 16870)
-- Dependencies: 171 171 171 2015
-- Name: pk_hashtag; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY hashtag
    ADD CONSTRAINT pk_hashtag PRIMARY KEY (tag, message_id);


--
-- TOC entry 1887 (class 2606 OID 16818)
-- Dependencies: 169 169 169 2015
-- Name: pk_like; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "like"
    ADD CONSTRAINT pk_like PRIMARY KEY (message_id, user_id);


--
-- TOC entry 1873 (class 2606 OID 16675)
-- Dependencies: 162 162 2015
-- Name: pk_user; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT pk_user PRIMARY KEY (id);


--
-- TOC entry 1883 (class 2606 OID 16753)
-- Dependencies: 167 167 167 2015
-- Name: pks; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY group_members
    ADD CONSTRAINT pks PRIMARY KEY (group_id, user_id);


--
-- TOC entry 1881 (class 2606 OID 16865)
-- Dependencies: 166 166 2015
-- Name: uniq_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT uniq_name UNIQUE (name);


--
-- TOC entry 1875 (class 2606 OID 16677)
-- Dependencies: 162 162 2015
-- Name: unique_login; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT unique_login UNIQUE (login);


--
-- TOC entry 1901 (class 2620 OID 16863)
-- Dependencies: 184 164 2015
-- Name: tg_update_original_message_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tg_update_original_message_id AFTER INSERT ON message FOR EACH ROW EXECUTE PROCEDURE fn_update_original_message_id();


--
-- TOC entry 1899 (class 2606 OID 16835)
-- Dependencies: 170 1876 164 2015
-- Name: fk_comment_message; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT fk_comment_message FOREIGN KEY (message_id) REFERENCES message(id) ON DELETE CASCADE;


--
-- TOC entry 1900 (class 2606 OID 16840)
-- Dependencies: 170 1872 162 2015
-- Name: fk_comment_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT fk_comment_user FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1897 (class 2606 OID 16819)
-- Dependencies: 169 164 1876 2015
-- Name: fk_like_message; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "like"
    ADD CONSTRAINT fk_like_message FOREIGN KEY (message_id) REFERENCES message(id) ON DELETE CASCADE;


--
-- TOC entry 1898 (class 2606 OID 16824)
-- Dependencies: 1872 169 162 2015
-- Name: fk_like_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "like"
    ADD CONSTRAINT fk_like_user FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1896 (class 2606 OID 16799)
-- Dependencies: 168 162 1872 2015
-- Name: follow_followed_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY follow
    ADD CONSTRAINT follow_followed_id_fkey FOREIGN KEY (followed_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1895 (class 2606 OID 16794)
-- Dependencies: 168 162 1872 2015
-- Name: follow_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY follow
    ADD CONSTRAINT follow_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1893 (class 2606 OID 16754)
-- Dependencies: 167 166 1878 2015
-- Name: group_members_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_members
    ADD CONSTRAINT group_members_group_id_fkey FOREIGN KEY (group_id) REFERENCES "group"(id) ON DELETE CASCADE;


--
-- TOC entry 1894 (class 2606 OID 16759)
-- Dependencies: 167 162 1872 2015
-- Name: group_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_members
    ADD CONSTRAINT group_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1891 (class 2606 OID 16852)
-- Dependencies: 1872 164 162 2015
-- Name: original_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY message
    ADD CONSTRAINT original_user_fk FOREIGN KEY (original_user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1890 (class 2606 OID 16739)
-- Dependencies: 1872 162 164 2015
-- Name: user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY message
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1892 (class 2606 OID 16744)
-- Dependencies: 1872 162 166 2015
-- Name: user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 2020 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2014-09-01 13:50:00 BRT

--
-- PostgreSQL database dump complete
--


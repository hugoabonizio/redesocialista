--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.14
-- Dumped by pg_dump version 9.1.14
-- Started on 2014-10-13 16:14:27 BRT

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
-- TOC entry 2026 (class 0 OID 0)
-- Dependencies: 172
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 188 (class 1255 OID 16919)
-- Dependencies: 528 6
-- Name: calc_impact(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION calc_impact(target_message_id integer, min_date character varying, max_date character varying) RETURNS SETOF bigint
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT (comments * 3) + (reposts * 3) + (likes * 2) - likes FROM (SELECT
	(SELECT COUNT(*)
	FROM "comment"
	WHERE message_id = TARGET_MESSAGE_ID
	AND comment_date >= to_timestamp(MIN_DATE, 'YYYY-MM-DD HH24:MI:SS')
	AND comment_date <= to_timestamp(MAX_DATE, 'YYYY-MM-DD HH24:MI:SS')
	) AS comments,

	(SELECT COUNT(*)
	FROM "message"
	WHERE original_message_id = TARGET_MESSAGE_ID AND id != TARGET_MESSAGE_ID
	AND message_date >= to_timestamp(MIN_DATE, 'YYYY-MM-DD HH24:MI:SS')
	AND message_date <= to_timestamp(MAX_DATE, 'YYYY-MM-DD HH24:MI:SS')
	) AS reposts,

	(SELECT COUNT(*)
	FROM "like"
	WHERE message_id = TARGET_MESSAGE_ID AND value > 0
	) AS likes,

	(SELECT COUNT(*)
	FROM "like"
	WHERE message_id = TARGET_MESSAGE_ID AND value < 0
	) AS dislikes

	) t1;
	
END;
$$;


ALTER FUNCTION public.calc_impact(target_message_id integer, min_date character varying, max_date character varying) OWNER TO postgres;

--
-- TOC entry 184 (class 1255 OID 16884)
-- Dependencies: 6 528
-- Name: calc_influence(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION calc_influence(target_user_id integer) RETURNS TABLE(influence bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT ((total_comments * 2) + (reposts * 2) + total_likes) AS influence FROM
	(SELECT 
		(SELECT COUNT(*)
		FROM "message"
		WHERE original_user_id = TARGET_USER_ID AND user_id != TARGET_USER_ID
		) AS reposts,

		(SELECT SUM(value)
		FROM "message" m JOIN "like" l ON m.id = l.message_id
		WHERE original_user_id = TARGET_USER_ID
		) AS total_likes,

		(SELECT COUNT(*)
		FROM "comment"
		WHERE user_id = TARGET_USER_ID
		) AS total_comments

	) t1;
	
END;
$$;


ALTER FUNCTION public.calc_influence(target_user_id integer) OWNER TO postgres;

--
-- TOC entry 186 (class 1255 OID 16917)
-- Dependencies: 6 528
-- Name: calc_influence(integer, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION calc_influence(target_user_id integer, min_date timestamp without time zone, max_date timestamp without time zone) RETURNS SETOF bigint
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT ((total_comments * 2) + (reposts * 2) + total_likes) AS influence FROM
	(SELECT 
		(SELECT COUNT(*)
		FROM "message"
		WHERE original_user_id = TARGET_USER_ID AND user_id != TARGET_USER_ID
		) AS reposts,

		(SELECT SUM(value)
		FROM "message" m JOIN "like" l ON m.id = l.message_id
		WHERE original_user_id = TARGET_USER_ID
		) AS total_likes,

		(SELECT COUNT(*)
		FROM "comment"
		WHERE user_id = 12
		AND comment_date >= to_date('2014-10-08 21:40:00', 'YYYY-MM-DD HH24:MI:SS')
		AND comment_date <= to_date('2014-10-09 23:45:00', 'YYYY-MM-DD HH24:MI:SS')
		) AS total_comments

	) t1;
	
END;
$$;


ALTER FUNCTION public.calc_influence(target_user_id integer, min_date timestamp without time zone, max_date timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 187 (class 1255 OID 16918)
-- Dependencies: 528 6
-- Name: calc_influence(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION calc_influence(target_user_id integer, min_date character varying, max_date character varying) RETURNS SETOF bigint
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT ((total_comments * 2) + (reposts * 2) + total_likes) AS influence FROM
	(SELECT 
		(SELECT COUNT(*)
		FROM "message"
		WHERE original_user_id = TARGET_USER_ID AND user_id != TARGET_USER_ID
		) AS reposts,

		(SELECT COALESCE(SUM(value), 0)
		FROM "message" m JOIN "like" l ON m.id = l.message_id
		WHERE original_user_id = TARGET_USER_ID
		) AS total_likes,

		(SELECT COUNT(*)
		FROM "comment"
		WHERE user_id = TARGET_USER_ID
		AND comment_date >= to_timestamp(MIN_DATE, 'YYYY-MM-DD HH24:MI:SS')
		AND comment_date <= to_timestamp(MAX_DATE, 'YYYY-MM-DD HH24:MI:SS')
		) AS total_comments

	) t1;
	
END;
$$;


ALTER FUNCTION public.calc_influence(target_user_id integer, min_date character varying, max_date character varying) OWNER TO postgres;

--
-- TOC entry 185 (class 1255 OID 16862)
-- Dependencies: 6 528
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
-- Dependencies: 1876 6
-- Name: comment; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comment (
    message_id integer NOT NULL,
    user_id integer NOT NULL,
    body text NOT NULL,
    comment_date timestamp without time zone DEFAULT now(),
    server_id integer
);


ALTER TABLE public.comment OWNER TO postgres;

--
-- TOC entry 168 (class 1259 OID 16789)
-- Dependencies: 6
-- Name: follow; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE follow (
    follower_id integer NOT NULL,
    followed_id integer NOT NULL
);


ALTER TABLE public.follow OWNER TO postgres;

--
-- TOC entry 166 (class 1259 OID 16714)
-- Dependencies: 1874 6
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
-- Dependencies: 6 166
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
-- TOC entry 2030 (class 0 OID 0)
-- Dependencies: 165
-- Name: group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE group_id_seq OWNED BY "group".id;


--
-- TOC entry 167 (class 1259 OID 16749)
-- Dependencies: 6
-- Name: group_members; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE group_members (
    group_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.group_members OWNER TO postgres;

--
-- TOC entry 171 (class 1259 OID 16866)
-- Dependencies: 6
-- Name: hashtag; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE hashtag (
    tag character varying(32) NOT NULL,
    message_id integer NOT NULL
);


ALTER TABLE public.hashtag OWNER TO postgres;

--
-- TOC entry 169 (class 1259 OID 16804)
-- Dependencies: 1875 6
-- Name: like; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "like" (
    message_id integer NOT NULL,
    user_id integer NOT NULL,
    value integer,
    created_at timestamp without time zone DEFAULT now(),
    server_id integer
);


ALTER TABLE public."like" OWNER TO postgres;

--
-- TOC entry 164 (class 1259 OID 16697)
-- Dependencies: 1872 6
-- Name: message; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE message (
    id integer NOT NULL,
    user_id integer,
    body text NOT NULL,
    message_date timestamp without time zone DEFAULT now(),
    original_user_id integer,
    original_message_id integer,
    server_id integer
);


ALTER TABLE public.message OWNER TO postgres;

--
-- TOC entry 163 (class 1259 OID 16695)
-- Dependencies: 164 6
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
-- TOC entry 2035 (class 0 OID 0)
-- Dependencies: 163
-- Name: message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE message_id_seq OWNED BY message.id;


--
-- TOC entry 162 (class 1259 OID 16670)
-- Dependencies: 1870 6
-- Name: user; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    login character varying(20) NOT NULL,
    password character(32) NOT NULL,
    name character varying(40),
    birth date NOT NULL,
    description text,
    server_id integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 161 (class 1259 OID 16668)
-- Dependencies: 162 6
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
-- TOC entry 2037 (class 0 OID 0)
-- Dependencies: 161
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE usuario_id_seq OWNED BY "user".id;


--
-- TOC entry 1873 (class 2604 OID 16717)
-- Dependencies: 166 165 166
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "group" ALTER COLUMN id SET DEFAULT nextval('group_id_seq'::regclass);


--
-- TOC entry 1871 (class 2604 OID 16700)
-- Dependencies: 163 164 164
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY message ALTER COLUMN id SET DEFAULT nextval('message_id_seq'::regclass);


--
-- TOC entry 1869 (class 2604 OID 16673)
-- Dependencies: 161 162 162
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('usuario_id_seq'::regclass);


--
-- TOC entry 2017 (class 0 OID 16829)
-- Dependencies: 170 2019
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY comment (message_id, user_id, body, comment_date, server_id) FROM stdin;
67	12	coementário nesse	2014-08-31 20:47:54.5599	\N
68	12	comentário	2014-08-31 20:48:51.490995	\N
70	12	comentário	2014-08-31 23:03:08.198247	\N
72	27	Comentário do Zizek!	2014-09-01 12:57:44.173728	\N
72	12	comentário 55	2014-09-01 17:20:56.28167	\N
81	12	NOVO	2014-09-01 17:27:09.669796	\N
85	12	Comentário na mensagem de teste do Hugo	2014-10-07 20:49:54.857174	\N
85	12	outro comentário	2014-10-07 21:30:12.038064	\N
85	12	aaaaaaa	2014-10-07 21:30:16.898465	\N
85	27	rrrr	2014-10-09 22:49:22.637672	\N
85	27	rrrr	2014-10-09 22:49:34.885434	\N
85	12	outro	2014-10-09 22:50:05.262403	\N
85	12	mais um comentario	2014-10-09 23:15:53.03149	\N
85	12	dsadasdasd	2014-10-09 23:19:42.027981	\N
24	12	comentario no id 24	2014-08-31 15:22:18.220778	\N
88	12	fdsfdf	2014-10-12 18:59:34.128037	0
346	99	alohaa2	2014-10-12 21:58:25.094654	13
347	99	teste comentario	2014-10-12 21:58:25.104174	13
348	99	aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa	2014-10-12 21:58:25.115678	13
348	95	kkkkkkkkkk	2014-10-12 21:58:25.126729	13
347	98	outro	2014-10-12 21:58:25.137492	13
349	99	q bosta	2014-10-12 21:58:25.148998	13
349	99	teste	2014-10-12 21:58:25.159914	13
348	99	testeeee edit2	2014-10-12 21:58:25.170682	13
344	99	teste hashtag3	2014-10-12 21:58:25.182233	13
346	99	ola	2014-10-12 21:58:25.193328	13
349	95	oooooo	2014-10-12 21:58:25.204144	13
349	95	vish	2014-10-12 21:58:25.215482	13
\.


--
-- TOC entry 2015 (class 0 OID 16789)
-- Dependencies: 168 2019
-- Data for Name: follow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY follow (follower_id, followed_id) FROM stdin;
12	26
12	25
25	99
99	26
26	12
99	12
\.


--
-- TOC entry 2013 (class 0 OID 16714)
-- Dependencies: 166 2019
-- Data for Name: group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "group" (id, user_id, name, user_count) FROM stdin;
23	27	Nome do grupo	1
25	12	qaaaaaa	1
26	12	grupo_do_hugo	1
22	12	camaradas	1
\.


--
-- TOC entry 2038 (class 0 OID 0)
-- Dependencies: 165
-- Name: group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('group_id_seq', 26, true);


--
-- TOC entry 2014 (class 0 OID 16749)
-- Dependencies: 167 2019
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
-- TOC entry 2018 (class 0 OID 16866)
-- Dependencies: 171 2019
-- Data for Name: hashtag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY hashtag (tag, message_id) FROM stdin;
test	67
test	68
outra	68
marxismo	24
test	72
test	73
hashtag	78
hashtag	79
\.


--
-- TOC entry 2016 (class 0 OID 16804)
-- Dependencies: 169 2019
-- Data for Name: like; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "like" (message_id, user_id, value, created_at, server_id) FROM stdin;
24	27	1	2014-10-09 21:44:32.900997	\N
24	26	1	2014-10-09 21:44:32.900997	\N
24	25	1	2014-10-09 21:44:32.900997	\N
21	12	-1	2014-10-09 21:44:32.900997	\N
20	12	1	2014-10-09 21:44:32.900997	\N
22	12	1	2014-10-09 21:44:32.900997	\N
24	12	1	2014-10-09 21:44:32.900997	\N
23	12	1	2014-10-09 21:44:32.900997	\N
72	12	1	2014-10-09 21:44:32.900997	\N
72	27	1	2014-10-09 21:44:32.900997	\N
74	12	1	2014-10-09 21:44:32.900997	\N
73	12	-1	2014-10-09 21:44:32.900997	\N
85	25	1	2014-10-09 21:44:32.900997	\N
85	26	-1	2014-10-09 21:44:32.900997	\N
85	27	1	2014-10-09 22:47:21.142831	\N
358	99	1	2014-10-12 21:58:25.228135	13
359	99	1	2014-10-12 21:58:25.237411	13
344	99	-1	2014-10-12 21:58:25.248718	13
346	98	-1	2014-10-12 21:58:25.25968	13
\.


--
-- TOC entry 2011 (class 0 OID 16697)
-- Dependencies: 164 2019
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY message (id, user_id, body, message_date, original_user_id, original_message_id, server_id) FROM stdin;
372	12	teste config	2014-10-13 11:30:02.259915	12	372	0
68	12	e mais uma #test! e #outra	2014-08-31 20:08:20.71158	12	68	\N
24	25	Essa rede social não pertence ao monopólio imperialista, aconselho à todos! #marxismo	2014-08-10 23:37:01.615823	25	24	\N
52	12	Essa rede social não pertence ao monopólio imperialista, aconselho à todos! #marxismo	2014-08-31 15:22:05.05923	25	24	\N
69	12	Olá, turma! A pedido do @joao, segue o vídeo da aula de hoje: $v:"/app/media/aula-hoje.ogg". O conteúdo é tranquilo... $i:"http://upload.wikimedia.org/wikipedia/commons/b/b7/Big_smile.png"	2014-08-31 22:59:07.89912	12	69	\N
70	12	Video do youtube $y:"LOHLCmivnBo"	2014-08-31 23:02:57.821455	12	70	\N
71	12	Um link $l:"http://localhost:8084"	2014-08-31 23:04:34.90556	12	71	\N
72	25	Publicação com a hashtag #test	2014-08-31 23:12:07.905251	25	72	\N
73	27	uma hashtag #test	2014-09-01 12:57:23.525923	27	73	\N
74	27	Imagem: $i:"http://localhost:8080/Captura%20de%20tela%20de%202014-08-18%2022%3A09%3A26.png"	2014-09-01 12:58:41.511221	27	74	\N
75	27	Publicação com a hashtag #test	2014-09-01 13:02:09.722395	25	72	\N
76	12		2014-09-01 17:18:17.880484	12	76	\N
77	12	Publicação com a hashtag #test	2014-09-01 17:20:33.825573	25	72	\N
78	25	publicação #hashtag	2014-09-01 17:24:05.069249	25	78	\N
79	12	outra #hashtag	2014-09-01 17:24:13.623347	12	79	\N
80	12	@marx !!	2014-09-01 17:24:43.01884	12	80	\N
81	12	$i:"http://localhost:8080/Captura%20de%20tela%20de%202014-08-18%2022%3A02%3A41.png" essa é uma imagem	2014-09-01 17:25:16.232385	12	81	\N
82	12	$v:"fsdfposdpof" $y:"dN0TZnpLe4s" $l:"http://localhost:8084"	2014-09-01 17:26:22.767115	12	82	\N
20	25	Proletários de todo o mundo, uni-vos!	2014-08-10 23:09:24.403444	25	20	\N
21	25	Puts, esqueci a piada com mais-valia. Droga.	2014-08-10 23:10:03.865728	25	21	\N
22	26	Status: matando uns nazis aqui na moralzinha	2014-08-10 23:35:48.145251	26	22	\N
23	26	Se alguém viu o Trotsky chama inbox	2014-08-10 23:36:31.869257	26	23	\N
26	27	A grafia correta é Slavoj iek!!	2014-08-11 00:08:12.056479	27	26	\N
13	12	mençagem com asséntôs!!	2014-08-07 22:26:38.565881	12	13	\N
36	12	teste 2	2014-08-28 17:02:25.375679	12	36	\N
43	12	mensagem com trigger	2014-08-31 11:05:13.868968	12	43	\N
47	12	testando 2	2014-08-31 11:16:37.877517	12	47	\N
48	12	testeee	2014-08-31 11:31:48.701438	12	48	\N
49	12	com mention para @marx	2014-08-31 14:54:28.933577	12	49	\N
83	12	@hugo daspodaksd	2014-09-01 17:27:45.687096	12	83	\N
84	12	@camaradas	2014-09-01 17:28:15.373928	12	84	\N
85	12	Mensagem de teste do Hugo	2014-10-07 20:49:44.110124	12	85	\N
86	25	Mensagem de teste do Hugo	2014-10-07 21:30:42.850505	12	85	\N
87	25	teste	2014-10-09 22:43:15.301668	25	87	\N
88	12	nova mensagem	2014-10-12 18:59:29.8208	12	88	\N
67	12	agora sim #test	2014-08-31 20:08:14.291769	12	67	\N
375	12	agora foi	2014-10-13 11:41:29.018591	12	375	0
339	99	teste regex2	2014-08-23 21:14:00	99	339	13
340	99	teste regex3	2014-08-23 21:15:00	99	340	13
341	99	teste	2014-08-24 19:07:00	99	341	13
342	99	teste video	2014-08-25 10:57:00	99	342	13
343	99	teste hashtag	2014-08-25 23:00:00	99	343	13
344	95	ola galeris	2014-08-26 18:22:00	95	344	13
345	99	teste arroba	2014-08-26 21:58:00	99	345	13
346	95	ola	2014-08-27 13:31:00	95	346	13
347	99	teste hashtag	2014-08-27 19:34:00	99	347	13
348	99	mensagem	2014-08-27 20:06:00	99	348	13
349	99	teste video	2014-08-28 14:25:00	99	349	13
350	98	teste hashtag	2014-09-01 17:33:00	98	350	13
351	98	teste upload	2014-09-01 17:36:00	98	351	13
352	99	titulo1	2014-08-10 09:54:00	99	352	13
353	99	titulo2	2014-08-10 09:54:00	99	353	13
354	99	titulo3	2014-08-10 10:08:00	99	354	13
355	96	titulo4	2014-08-11 17:58:00	96	355	13
356	96	titulo5	2014-08-11 17:58:00	96	356	13
357	99	titulo6	2014-08-19 18:13:00	99	357	13
358	95	titulo7	2014-08-20 17:57:00	95	358	13
359	95	titulo8	2014-08-20 17:58:00	95	359	13
360	99	titulo9	2014-08-22 14:55:00	99	360	13
361	99	titulo10	2014-08-22 14:56:00	99	361	13
362	99	titulo11	2014-08-22 15:00:00	99	362	13
363	99	teste hashtag	2014-08-23 15:16:00	99	363	13
364	99	teste regex	2014-08-23 21:14:00	99	364	13
365	99	titulo8	2014-08-24 13:22:00	99	359	13
366	99	ola galeris	2014-08-26 18:26:00	99	344	13
367	99	ola	2014-09-01 11:13:00	99	346	13
368	95	titulo6	2014-08-20 18:30:00	95	357	13
369	95	teste hashtag	2014-09-01 17:25:00	95	347	13
370	96	titulo8	2014-09-01 17:24:00	96	359	13
371	98	teste hashtag	2014-09-01 17:24:00	98	347	13
\.


--
-- TOC entry 2039 (class 0 OID 0)
-- Dependencies: 163
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('message_id_seq', 375, true);


--
-- TOC entry 2009 (class 0 OID 16670)
-- Dependencies: 162 2019
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "user" (id, login, password, name, birth, description, server_id, created_at) FROM stdin;
25	marx	e8d95a51f3af4a3b134bf6bb680a213a	Karl Marx	1818-05-05	\N	\N	2014-10-09 21:41:04.749058
26	stalin	e8d95a51f3af4a3b134bf6bb680a213a	Josef Stalin	1879-12-18	\N	\N	2014-10-09 21:41:04.749058
27	zizek	e8d95a51f3af4a3b134bf6bb680a213a	Slavoj Zizek	1949-03-21	Slavoj iek (Liubliana, 21 de março de 1949) é um filósofo e teórico crítico e cientista social esloveno.1 É professor da European Graduate School e pesquisador sénior no Instituto de Sociologia da Universidade de Liubliana. É também professor visitante em várias universidades estadunidenses, entre as quais estão a Universidade de Columbia, Princeton, a New School for Social Research, de Nova Iorque, e a Universidade de Michigan.	\N	2014-10-09 21:41:04.749058
12	hugo	e8d95a51f3af4a3b134bf6bb680a213a	Hugo Queiroz Abonizio	1993-08-26	Oi, eu sou o Goku	\N	2014-10-09 21:41:04.749058
94	webservice_13	e8d95a51f3af4a3b134bf6bb680a213a	webservice	1994-10-10	teste webservice	13	2014-10-12 21:58:24.642413
95	pikachu_13	e8d95a51f3af4a3b134bf6bb680a213a	pikachu	2014-08-02		13	2014-10-12 21:58:24.663786
96	gustavotaiji_13	e8d95a51f3af4a3b134bf6bb680a213a	gustavo2	0222-02-22		13	2014-10-12 21:58:24.671959
97	novo12_13	e8d95a51f3af4a3b134bf6bb680a213a	novo	0111-11-11		13	2014-10-12 21:58:24.683871
98	usernovo_13	e8d95a51f3af4a3b134bf6bb680a213a	usernovo	1111-11-11		13	2014-10-12 21:58:24.694778
99	gtn123_13	e8d95a51f3af4a3b134bf6bb680a213a	gustavo	2014-08-03	blablabla	13	2014-10-12 21:58:24.705198
\.


--
-- TOC entry 2040 (class 0 OID 0)
-- Dependencies: 161
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuario_id_seq', 99, true);


--
-- TOC entry 1884 (class 2606 OID 16720)
-- Dependencies: 166 166 2020
-- Name: group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (id);


--
-- TOC entry 1882 (class 2606 OID 16706)
-- Dependencies: 164 164 2020
-- Name: message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- TOC entry 1890 (class 2606 OID 16793)
-- Dependencies: 168 168 168 2020
-- Name: pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY follow
    ADD CONSTRAINT pk PRIMARY KEY (follower_id, followed_id);


--
-- TOC entry 1894 (class 2606 OID 16870)
-- Dependencies: 171 171 171 2020
-- Name: pk_hashtag; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY hashtag
    ADD CONSTRAINT pk_hashtag PRIMARY KEY (tag, message_id);


--
-- TOC entry 1892 (class 2606 OID 16818)
-- Dependencies: 169 169 169 2020
-- Name: pk_like; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "like"
    ADD CONSTRAINT pk_like PRIMARY KEY (message_id, user_id);


--
-- TOC entry 1878 (class 2606 OID 16675)
-- Dependencies: 162 162 2020
-- Name: pk_user; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT pk_user PRIMARY KEY (id);


--
-- TOC entry 1888 (class 2606 OID 16753)
-- Dependencies: 167 167 167 2020
-- Name: pks; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY group_members
    ADD CONSTRAINT pks PRIMARY KEY (group_id, user_id);


--
-- TOC entry 1886 (class 2606 OID 16865)
-- Dependencies: 166 166 2020
-- Name: uniq_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT uniq_name UNIQUE (name);


--
-- TOC entry 1880 (class 2606 OID 16677)
-- Dependencies: 162 162 2020
-- Name: unique_login; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT unique_login UNIQUE (login);


--
-- TOC entry 1906 (class 2620 OID 16863)
-- Dependencies: 164 185 2020
-- Name: tg_update_original_message_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tg_update_original_message_id AFTER INSERT ON message FOR EACH ROW EXECUTE PROCEDURE fn_update_original_message_id();


--
-- TOC entry 1904 (class 2606 OID 16835)
-- Dependencies: 170 1881 164 2020
-- Name: fk_comment_message; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT fk_comment_message FOREIGN KEY (message_id) REFERENCES message(id) ON DELETE CASCADE;


--
-- TOC entry 1905 (class 2606 OID 16840)
-- Dependencies: 1877 170 162 2020
-- Name: fk_comment_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT fk_comment_user FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1902 (class 2606 OID 16819)
-- Dependencies: 169 1881 164 2020
-- Name: fk_like_message; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "like"
    ADD CONSTRAINT fk_like_message FOREIGN KEY (message_id) REFERENCES message(id) ON DELETE CASCADE;


--
-- TOC entry 1903 (class 2606 OID 16824)
-- Dependencies: 169 1877 162 2020
-- Name: fk_like_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "like"
    ADD CONSTRAINT fk_like_user FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1901 (class 2606 OID 16799)
-- Dependencies: 162 1877 168 2020
-- Name: follow_followed_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY follow
    ADD CONSTRAINT follow_followed_id_fkey FOREIGN KEY (followed_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1900 (class 2606 OID 16794)
-- Dependencies: 162 168 1877 2020
-- Name: follow_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY follow
    ADD CONSTRAINT follow_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1898 (class 2606 OID 16754)
-- Dependencies: 166 1883 167 2020
-- Name: group_members_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_members
    ADD CONSTRAINT group_members_group_id_fkey FOREIGN KEY (group_id) REFERENCES "group"(id) ON DELETE CASCADE;


--
-- TOC entry 1899 (class 2606 OID 16759)
-- Dependencies: 162 167 1877 2020
-- Name: group_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_members
    ADD CONSTRAINT group_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1896 (class 2606 OID 16852)
-- Dependencies: 162 164 1877 2020
-- Name: original_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY message
    ADD CONSTRAINT original_user_fk FOREIGN KEY (original_user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1895 (class 2606 OID 16739)
-- Dependencies: 1877 164 162 2020
-- Name: user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY message
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1897 (class 2606 OID 16744)
-- Dependencies: 1877 162 166 2020
-- Name: user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 2025 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
GRANT ALL ON SCHEMA public TO dba;


--
-- TOC entry 2027 (class 0 OID 0)
-- Dependencies: 170
-- Name: comment; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE comment FROM PUBLIC;
REVOKE ALL ON TABLE comment FROM postgres;
GRANT ALL ON TABLE comment TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE comment TO application;


--
-- TOC entry 2028 (class 0 OID 0)
-- Dependencies: 168
-- Name: follow; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE follow FROM PUBLIC;
REVOKE ALL ON TABLE follow FROM postgres;
GRANT ALL ON TABLE follow TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE follow TO application;


--
-- TOC entry 2029 (class 0 OID 0)
-- Dependencies: 166
-- Name: group; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE "group" FROM PUBLIC;
REVOKE ALL ON TABLE "group" FROM postgres;
GRANT ALL ON TABLE "group" TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "group" TO application;


--
-- TOC entry 2031 (class 0 OID 0)
-- Dependencies: 167
-- Name: group_members; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE group_members FROM PUBLIC;
REVOKE ALL ON TABLE group_members FROM postgres;
GRANT ALL ON TABLE group_members TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE group_members TO application;


--
-- TOC entry 2032 (class 0 OID 0)
-- Dependencies: 171
-- Name: hashtag; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE hashtag FROM PUBLIC;
REVOKE ALL ON TABLE hashtag FROM postgres;
GRANT ALL ON TABLE hashtag TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE hashtag TO application;


--
-- TOC entry 2033 (class 0 OID 0)
-- Dependencies: 169
-- Name: like; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE "like" FROM PUBLIC;
REVOKE ALL ON TABLE "like" FROM postgres;
GRANT ALL ON TABLE "like" TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "like" TO application;


--
-- TOC entry 2034 (class 0 OID 0)
-- Dependencies: 164
-- Name: message; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE message FROM PUBLIC;
REVOKE ALL ON TABLE message FROM postgres;
GRANT ALL ON TABLE message TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE message TO application;


--
-- TOC entry 2036 (class 0 OID 0)
-- Dependencies: 162
-- Name: user; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE "user" FROM PUBLIC;
REVOKE ALL ON TABLE "user" FROM postgres;
GRANT ALL ON TABLE "user" TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "user" TO application;


-- Completed on 2014-10-13 16:14:27 BRT

--
-- PostgreSQL database dump complete
--


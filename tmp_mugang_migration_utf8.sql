--
-- PostgreSQL database dump
--

\restrict BCZq77E4xKLKm1sqtSLi0Yqof9PU0YetdXN2iQdzXtcCy6jUv4hDgwK7b4n9s0O

-- Dumped from database version 16.13 (Debian 16.13-1.pgdg12+1)
-- Dumped by pg_dump version 16.13 (Debian 16.13-1.pgdg12+1)

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

--
-- Name: vector; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA public;


--
-- Name: EXTENSION vector; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION vector IS 'vector data type and ivfflat and hnsw access methods';


--
-- Name: enroll_status_enum; Type: TYPE; Schema: public; Owner: mugang
--

CREATE TYPE public.enroll_status_enum AS ENUM (
    'COMPLETED',
    'CANCELED',
    'BASKET'
);


ALTER TYPE public.enroll_status_enum OWNER TO mugang;

--
-- Name: lecture_category; Type: TYPE; Schema: public; Owner: mugang
--

CREATE TYPE public.lecture_category AS ENUM (
    '전공필수',
    '전공선택',
    '교양필수',
    '교양선택',
    '교직',
    '공통'
);


ALTER TYPE public.lecture_category OWNER TO mugang;

--
-- Name: role_enum; Type: TYPE; Schema: public; Owner: mugang
--

CREATE TYPE public.role_enum AS ENUM (
    'STUDENT',
    'STAFF'
);


ALTER TYPE public.role_enum OWNER TO mugang;

--
-- Name: status_enum; Type: TYPE; Schema: public; Owner: mugang
--

CREATE TYPE public.status_enum AS ENUM (
    '재학',
    '휴학',
    '재직',
    '퇴직'
);


ALTER TYPE public.status_enum OWNER TO mugang;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: chat_message_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.chat_message_tb (
    id character varying NOT NULL,
    session_id character varying(100),
    role character varying(20) NOT NULL,
    content character varying NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.chat_message_tb OWNER TO mugang;

--
-- Name: chat_session_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.chat_session_tb (
    id character varying(100) NOT NULL,
    user_id bigint,
    title character varying(255),
    created_at timestamp without time zone
);


ALTER TABLE public.chat_session_tb OWNER TO mugang;

--
-- Name: depart_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.depart_tb (
    dept_no bigint NOT NULL,
    college character varying(50) NOT NULL,
    depart character varying(255) NOT NULL
);


ALTER TABLE public.depart_tb OWNER TO mugang;

--
-- Name: depart_tb_dept_no_seq; Type: SEQUENCE; Schema: public; Owner: mugang
--

CREATE SEQUENCE public.depart_tb_dept_no_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.depart_tb_dept_no_seq OWNER TO mugang;

--
-- Name: depart_tb_dept_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mugang
--

ALTER SEQUENCE public.depart_tb_dept_no_seq OWNED BY public.depart_tb.dept_no;


--
-- Name: enroll_schedule_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.enroll_schedule_tb (
    id integer NOT NULL,
    day_number integer NOT NULL,
    open_datetime timestamp without time zone,
    close_datetime timestamp without time zone,
    restriction_type character varying(30) NOT NULL,
    is_active boolean,
    updated_at timestamp without time zone
);


ALTER TABLE public.enroll_schedule_tb OWNER TO mugang;

--
-- Name: enroll_schedule_tb_id_seq; Type: SEQUENCE; Schema: public; Owner: mugang
--

CREATE SEQUENCE public.enroll_schedule_tb_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.enroll_schedule_tb_id_seq OWNER TO mugang;

--
-- Name: enroll_schedule_tb_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mugang
--

ALTER SEQUENCE public.enroll_schedule_tb_id_seq OWNED BY public.enroll_schedule_tb.id;


--
-- Name: enroll_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.enroll_tb (
    enroll_no bigint NOT NULL,
    loginid bigint,
    lecture_id bigint,
    sche_no bigint,
    enroll_status public.enroll_status_enum,
    status character varying(20),
    createdat timestamp without time zone
);


ALTER TABLE public.enroll_tb OWNER TO mugang;

--
-- Name: enroll_tb_enroll_no_seq; Type: SEQUENCE; Schema: public; Owner: mugang
--

CREATE SEQUENCE public.enroll_tb_enroll_no_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.enroll_tb_enroll_no_seq OWNER TO mugang;

--
-- Name: enroll_tb_enroll_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mugang
--

ALTER SEQUENCE public.enroll_tb_enroll_no_seq OWNED BY public.enroll_tb.enroll_no;


--
-- Name: form_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.form_tb (
    id character varying NOT NULL,
    user_id bigint,
    form_type character varying(100) NOT NULL,
    form_data json,
    status character varying(20),
    created_at timestamp without time zone
);


ALTER TABLE public.form_tb OWNER TO mugang;

--
-- Name: grade_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.grade_tb (
    id integer NOT NULL,
    user_id bigint,
    enrollment_id bigint,
    grade_letter character varying(5),
    semester character varying(20),
    is_retake boolean
);


ALTER TABLE public.grade_tb OWNER TO mugang;

--
-- Name: grade_tb_id_seq; Type: SEQUENCE; Schema: public; Owner: mugang
--

CREATE SEQUENCE public.grade_tb_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.grade_tb_id_seq OWNER TO mugang;

--
-- Name: grade_tb_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mugang
--

ALTER SEQUENCE public.grade_tb_id_seq OWNED BY public.grade_tb.id;


--
-- Name: lecture_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.lecture_tb (
    lecture_id integer NOT NULL,
    course_no character varying(20),
    subject character varying(200) NOT NULL,
    department character varying(100),
    dept_no bigint,
    lec_grade character varying(10),
    credit integer,
    professor character varying(50),
    type public.lecture_category,
    capacity integer,
    count integer,
    waitlist_capacity integer,
    version integer,
    classroom character varying(100)
);


ALTER TABLE public.lecture_tb OWNER TO mugang;

--
-- Name: lecture_tb_lecture_id_seq; Type: SEQUENCE; Schema: public; Owner: mugang
--

CREATE SEQUENCE public.lecture_tb_lecture_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lecture_tb_lecture_id_seq OWNER TO mugang;

--
-- Name: lecture_tb_lecture_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mugang
--

ALTER SEQUENCE public.lecture_tb_lecture_id_seq OWNED BY public.lecture_tb.lecture_id;


--
-- Name: notice_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.notice_tb (
    id character varying NOT NULL,
    title character varying(255) NOT NULL,
    content character varying NOT NULL,
    author_id bigint,
    created_at timestamp without time zone
);


ALTER TABLE public.notice_tb OWNER TO mugang;

--
-- Name: notification_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.notification_tb (
    id character varying NOT NULL,
    user_id bigint,
    message character varying(255) NOT NULL,
    is_read boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.notification_tb OWNER TO mugang;

--
-- Name: overenroll_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.overenroll_tb (
    over_no bigint NOT NULL,
    user_no bigint,
    lecture_id bigint,
    sche_no bigint,
    reason character varying(255),
    loginid character varying(50) NOT NULL
);


ALTER TABLE public.overenroll_tb OWNER TO mugang;

--
-- Name: overenroll_tb_over_no_seq; Type: SEQUENCE; Schema: public; Owner: mugang
--

CREATE SEQUENCE public.overenroll_tb_over_no_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.overenroll_tb_over_no_seq OWNER TO mugang;

--
-- Name: overenroll_tb_over_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mugang
--

ALTER SEQUENCE public.overenroll_tb_over_no_seq OWNED BY public.overenroll_tb.over_no;


--
-- Name: rag_docs_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.rag_docs_tb (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    embedding public.vector(1536),
    created_at timestamp without time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    metadata json
);


ALTER TABLE public.rag_docs_tb OWNER TO mugang;

--
-- Name: rag_docs_tb_id_seq; Type: SEQUENCE; Schema: public; Owner: mugang
--

CREATE SEQUENCE public.rag_docs_tb_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rag_docs_tb_id_seq OWNER TO mugang;

--
-- Name: rag_docs_tb_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mugang
--

ALTER SEQUENCE public.rag_docs_tb_id_seq OWNED BY public.rag_docs_tb.id;


--
-- Name: schedule_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.schedule_tb (
    sche_no integer NOT NULL,
    lecture_id integer,
    day_of_week character varying(1),
    start_min integer,
    end_min integer,
    start_time time without time zone,
    end_time time without time zone,
    classroom character varying(50)
);


ALTER TABLE public.schedule_tb OWNER TO mugang;

--
-- Name: schedule_tb_sche_no_seq; Type: SEQUENCE; Schema: public; Owner: mugang
--

CREATE SEQUENCE public.schedule_tb_sche_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.schedule_tb_sche_no_seq OWNER TO mugang;

--
-- Name: schedule_tb_sche_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mugang
--

ALTER SEQUENCE public.schedule_tb_sche_no_seq OWNED BY public.schedule_tb.sche_no;


--
-- Name: system_config_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.system_config_tb (
    key character varying(100) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.system_config_tb OWNER TO mugang;

--
-- Name: user_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.user_tb (
    user_no bigint NOT NULL,
    loginid character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    role public.role_enum NOT NULL,
    user_name character varying(50) NOT NULL,
    grade integer,
    dept_no bigint,
    user_status public.status_enum NOT NULL,
    birth_date date,
    email character varying(150),
    phone character varying(20),
    is_first_login boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.user_tb OWNER TO mugang;

--
-- Name: user_tb_user_no_seq; Type: SEQUENCE; Schema: public; Owner: mugang
--

CREATE SEQUENCE public.user_tb_user_no_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_tb_user_no_seq OWNER TO mugang;

--
-- Name: user_tb_user_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mugang
--

ALTER SEQUENCE public.user_tb_user_no_seq OWNED BY public.user_tb.user_no;


--
-- Name: waitlist_tb; Type: TABLE; Schema: public; Owner: mugang
--

CREATE TABLE public.waitlist_tb (
    id character varying NOT NULL,
    lecture_id integer,
    user_id bigint,
    status character varying(20),
    created_at timestamp without time zone
);


ALTER TABLE public.waitlist_tb OWNER TO mugang;

--
-- Name: depart_tb dept_no; Type: DEFAULT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.depart_tb ALTER COLUMN dept_no SET DEFAULT nextval('public.depart_tb_dept_no_seq'::regclass);


--
-- Name: enroll_schedule_tb id; Type: DEFAULT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.enroll_schedule_tb ALTER COLUMN id SET DEFAULT nextval('public.enroll_schedule_tb_id_seq'::regclass);


--
-- Name: enroll_tb enroll_no; Type: DEFAULT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.enroll_tb ALTER COLUMN enroll_no SET DEFAULT nextval('public.enroll_tb_enroll_no_seq'::regclass);


--
-- Name: grade_tb id; Type: DEFAULT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.grade_tb ALTER COLUMN id SET DEFAULT nextval('public.grade_tb_id_seq'::regclass);


--
-- Name: lecture_tb lecture_id; Type: DEFAULT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.lecture_tb ALTER COLUMN lecture_id SET DEFAULT nextval('public.lecture_tb_lecture_id_seq'::regclass);


--
-- Name: overenroll_tb over_no; Type: DEFAULT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.overenroll_tb ALTER COLUMN over_no SET DEFAULT nextval('public.overenroll_tb_over_no_seq'::regclass);


--
-- Name: rag_docs_tb id; Type: DEFAULT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.rag_docs_tb ALTER COLUMN id SET DEFAULT nextval('public.rag_docs_tb_id_seq'::regclass);


--
-- Name: schedule_tb sche_no; Type: DEFAULT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.schedule_tb ALTER COLUMN sche_no SET DEFAULT nextval('public.schedule_tb_sche_no_seq'::regclass);


--
-- Name: user_tb user_no; Type: DEFAULT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.user_tb ALTER COLUMN user_no SET DEFAULT nextval('public.user_tb_user_no_seq'::regclass);


--
-- Data for Name: chat_message_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.chat_message_tb (id, session_id, role, content, created_at) FROM stdin;
340aa355-cb94-48ea-8e3c-9a89a3fd6f2c	chat-fix-test-2	user	???? ???	2026-03-11 01:48:40.805099
b736bb0b-5979-44ea-bb60-b7911deeb89a	chat-fix-test-2	assistant	말씀하신 '???? ???' 에 대한 구체적인 문서를 찾고 있습니다. (RAG 연동 전 테스트 응답)	2026-03-11 01:48:40.817502
957cc28d-3112-4827-a121-8e5424a097d6	chat-fix-test-1	user	???? ?? ???	2026-03-11 01:48:40.860399
ad8f7973-752e-4288-923f-04596c7e8638	chat-fix-test-1	assistant	말씀하신 '???? ?? ???' 에 대한 구체적인 문서를 찾고 있습니다. (RAG 연동 전 테스트 응답)	2026-03-11 01:48:40.869261
650560f2-01ec-44c3-beee-475bc4faba86	chat-fix-test-3	user	???? ?? ???	2026-03-11 01:49:05.055229
6a58546c-9767-4c8c-864d-0ec34b5d3f2c	chat-fix-test-3	assistant	말씀하신 '???? ?? ???' 에 대한 구체적인 문서를 찾고 있습니다. (RAG 연동 전 테스트 응답)	2026-03-11 01:49:05.059539
7fe65cfa-8429-4b2b-848f-759d832937d9	mock-chat-db5c11c5d3	user	수강신청 규정 알려줘	2026-03-11 01:59:32.233177
5f79b400-b622-4a0b-a747-a549e0874c55	mock-chat-db5c11c5d3	assistant	수강신청은 좌측 '수강 신청' 메뉴에서 진행하실 수 있습니다. 장바구니에 담은 후 정해진 기간 내에 최종 신청을 완료해야 합니다.	2026-03-11 01:59:32.236832
\.


--
-- Data for Name: chat_session_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.chat_session_tb (id, user_id, title, created_at) FROM stdin;
chat-fix-test-2	2	???? ???	2026-03-11 01:48:40.786187
chat-fix-test-1	2	???? ?? ???	2026-03-11 01:48:40.843836
chat-fix-test-3	2	???? ?? ???	2026-03-11 01:49:05.051451
mock-chat-db5c11c5d3	2	수강신청 규정 알려줘	2026-03-11 01:59:32.229135
\.


--
-- Data for Name: depart_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.depart_tb (dept_no, college, depart) FROM stdin;
1	자유전공학부	자유전공학부
2	공공인재대학	소방·행정학과
3	공공인재대학	공직법무학과
4	공공인재대학	경찰행정학과
5	공공인재대학	자치경찰학과
6	공공인재대학	국방군사학과
7	공공인재대학	부동산지적학과
8	글로벌경영대학	경영학과
9	글로벌경영대학	회계학과
10	글로벌경영대학	경제금융통상학과
11	글로벌경영대학	관광항공경영학과
12	글로벌경영대학	호텔관광외식서비스학과
13	글로벌경영대학	일본어일본학과
14	사회과학대학	사회복지학과
15	사회과학대학	청소년상담복지학과
16	사회과학대학	아동가정복지학과
17	사회과학대학	평생교육심리복지학과
18	사회과학대학	영상콘텐츠학과
19	사회과학대학	광고PR학과
20	사회과학대학	문헌정보학과
21	사회과학대학	심리학과
22	보건바이오대학	보건의료학과
23	보건바이오대학	응급구조학과
24	보건바이오대학	동물자원학과
25	보건바이오대학	반려동물산업학과
26	보건바이오대학	스마트원예학과
27	보건바이오대학	식품가공학과
28	보건바이오대학	난임의료산업학과
29	IT·공과대학	건축공학과
30	IT·공과대학	소방안전방재학과
31	IT·공과대학	기계공학과
32	IT·공과대학	미래자동차공학과
33	IT·공과대학	식품영양학과
34	IT·공과대학	조경산림정원학과
35	IT·공과대학	친환경에너지학과
36	IT·공과대학	반도체전자공학과
37	IT·공과대학	전기공학과
38	IT·공과대학	컴퓨터공학과
39	IT·공과대학	컴퓨터소프트웨어학과
40	IT·공과대학	사이버보안학과
41	디자인예술대학	영상애니메이션학과
42	디자인예술대학	웹툰학과
43	디자인예술대학	시각디자인학과
44	디자인예술대학	서비스마케팅디자인학과
45	디자인예술대학	산업디자인학과
46	디자인예술대학	패션디자인학과
47	디자인예술대학	헤어디자인학과
48	디자인예술대학	메이크업피부학과
49	디자인예술대학	실내건축디자인학과
50	디자인예술대학	게임학과
51	사범대학	국어교육과
52	사범대학	영어교육과
53	사범대학	역사교육과
54	사범대학	일반사회교육과
55	사범대학	지리교육과
56	사범대학	유아교육과
57	사범대학	특수교육과
58	사범대학	초등특수교육과
59	사범대학	유아특수교육과
60	사범대학	수학교육과
61	사범대학	물리교육과
62	사범대학	화학교육과
63	사범대학	생물교육과
64	사범대학	지구과학교육과
65	재활과학대학	물리치료학과
66	재활과학대학	작업치료학과
67	재활과학대학	언어치료학과
68	재활과학대학	재활상담심리치료학과
69	재활과학대학	의료재활학과
70	재활과학대학	재활건강증진학과
71	재활과학대학	특수창의융합학과
72	간호대학	간호학과
73	체육레저학부	체육학과
74	체육레저학부	스포츠레저학과
75	체육레저학부	스포츠헬스케어학과
76	문화콘텐츠학부	문화콘텐츠학부
77	글로컬라이프대학	심리복지·복지상담학과
78	글로컬라이프대학	자산관리·6차산업학과
79	글로컬라이프대학	평생교육·청소년학과
80	글로컬라이프대학	웰라이프·헬스케어학과
\.


--
-- Data for Name: enroll_schedule_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.enroll_schedule_tb (id, day_number, open_datetime, close_datetime, restriction_type, is_active, updated_at) FROM stdin;
3	2	\N	\N	own_college	f	2026-03-11 01:10:11.821284
4	3	\N	\N	all	f	2026-03-11 01:10:11.822002
1	0	\N	\N	all	f	2026-03-11 01:59:32.249121
2	1	2026-03-11 00:00:00	2026-03-12 00:00:00	own_grade_dept	t	2026-03-11 01:59:32.249895
\.


--
-- Data for Name: enroll_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.enroll_tb (enroll_no, loginid, lecture_id, sche_no, enroll_status, status, createdat) FROM stdin;
2	1	941	1431	BASKET	cart	2026-03-11 01:25:45.792161
7	1	945	1438	BASKET	cart	2026-03-11 01:25:53.864484
8	1	946	1440	BASKET	cart	2026-03-11 01:25:55.193417
9	1	948	1444	BASKET	cart	2026-03-11 01:25:58.111576
10	1	950	1448	BASKET	cart	2026-03-11 01:25:59.17671
11	1	949	1446	BASKET	cart	2026-03-11 01:26:00.215512
14	1	954	\N	CANCELED	cart	2026-03-11 01:39:07.342786
13	1	952	\N	CANCELED	cart	2026-03-11 01:39:07.342783
6	1	944	1436	CANCELED	cart	2026-03-11 01:25:52.851362
\.


--
-- Data for Name: form_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.form_tb (id, user_id, form_type, form_data, status, created_at) FROM stdin;
\.


--
-- Data for Name: grade_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.grade_tb (id, user_id, enrollment_id, grade_letter, semester, is_retake) FROM stdin;
\.


--
-- Data for Name: lecture_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.lecture_tb (lecture_id, course_no, subject, department, dept_no, lec_grade, credit, professor, type, capacity, count, waitlist_capacity, version, classroom) FROM stdin;
957	1375	클라시카,단테,신곡	글로벌경영대학	\N	1	3	송효정	전공선택	40	0	10	0	경영1관-1311
959	1732	진화하는호모테크니쿠스	IT·공과대학	\N	1	2	조현우	전공선택	40	0	10	0	공학1관-0202
960	1820	서양미술의이해	디자인예술대학	\N	1	3	임윤수	전공선택	40	0	10	0	DU∼MOOC
961	3942	문화콘텐츠입문	디지털미디어콘텐	\N	1	3	서요성	전공선택	40	0	10	0	인문1관-1220
963	1552	디지털기술과미래사회	보건바이오대학	\N	1	3	박붕익	전공선택	40	0	10	0	생과3관-1205
964	1718	디지털기술과미래사회	IT·공과대학	\N	1	3	박붕익	전공선택	40	0	10	0	공학1관-0201
965	2055	디지털기술과미래사회	재활과학대학	\N	1	3	조익성	전공선택	40	0	10	0	재과1관-1104
966	1258	문학과예술의사회사	공공인재대학	\N	1	3	주영중	전공선택	40	0	10	0	사회3관-3201
967	1809	문학과예술의사회사	디자인예술대학	\N	1	3	윤주한	전공선택	40	0	10	0	디예2관-2310
968	1912	문학과예술의사회사	사범대학	\N	1	3	윤주한	전공선택	40	0	10	0	사범1관-1216
969	2056	문학과예술의사회사	재활과학대학	\N	1	3	노우정	전공선택	40	0	10	0	재과1관-1212
970	1204	예술과디지털커뮤니케이션	문화콘텐츠학부	76	1	3	이소영	전공선택	40	0	10	0	인문2관-2202
971	1810	예술과디지털커뮤니케이션	디자인예술대학	\N	1	3	이소영	전공선택	40	0	10	0	디예2관-2310
973	1205	아름다움이란무엇인가	문화콘텐츠학부	76	1	3	윤주한	전공선택	40	0	10	0	인문2관-2202
974	1811	아름다움이란무엇인가	디자인예술대학	\N	1	3	윤주한	전공선택	40	0	10	0	디예2관-2310
975	1915	아름다움이란무엇인가	사범대학	\N	1	3	변상출	전공선택	40	0	10	0	사범1관-1216
977	1373	동양철학과하이브리드문화	글로벌경영대학	\N	1	3	안효성	전공선택	40	0	10	0	경영1관-1209
978	1437	동양철학과하이브리드문화	사회과학대학	\N	1	3	김용휘	전공선택	40	0	10	0	사과1관-1410
979	2058	동양철학과하이브리드문화	재활과학대학	\N	1	3	김용휘	전공선택	40	0	10	0	재과1관-1213
981	1919	공감하는인간의이해	사범대학	\N	1	3	조혜경	전공선택	40	0	10	0	사범1관-1216
982	2061	공감하는인간의이해	재활과학대학	\N	1	3	조혜경	전공선택	40	0	10	0	재과1관-1213
983	1380	영상과동아시아의근대	글로벌경영대학	\N	1	3	송효정	전공선택	40	0	10	0	경영1관-1313
984	1207	놀이,예술,상상력	문화콘텐츠학부	76	1	2	이소영	전공선택	40	0	10	0	인문1관-1324
985	1921	놀이,예술,상상력	사범대학	\N		2	이소영	전공선택	40	0	10	0	사범1관-1434
986	1382	다매체시대의영상서사론	글로벌경영대학	\N		3	송효정	전공선택	40	0	10	0	경영1관-1312
987	1816	시,상상,모험	디자인예술대학	\N		2	주영중	전공선택	40	0	10	0	디예2관-2310
988	1929	시,상상,모험	사범대학	\N		2	주영중	전공선택	40	0	10	0	사범1관-1434
989	3943	기초웹툰스튜디오(1)	디지털미디어콘텐	\N	2	3	미선임	전공선택	40	0	10	0	디예1관-1413
990	1549	인문학과과학기술	보건바이오대학	\N		3	박붕익	전공선택	40	0	10	0	생과1관-1414
991	1716	인문학과과학기술	IT·공과대학	\N		3	박붕익	전공선택	40	0	10	0	공학1관-0202
992	2053	인문학과과학기술	재활과학대학	\N		3	전용숙	전공선택	40	0	10	0	재과1관-1212
995	1371	사회적기업의이해	글로벌경영대학	\N	1	3	이주현	전공선택	40	0	10	0	경영1관-1212
947	1550	고전과현대문화	보건바이오대학	\N	1	3	김민규	전공선택	40	0	10	2	생과2관-1104
943	1908	즐거운철학이야기	사범대학	\N	1	3	이종주	전공선택	40	0	10	2	사범1관-1434
954	1916	클라시카,플라톤,국가	사범대학	\N	1	3	변상출	전공선택	40	-1	10	1	사범1관-1217
945	1256	고전과현대문화	공공인재대학	\N	1	3	백순철	전공선택	40	1	10	1	사회3관-3202
946	1372	고전과현대문화	글로벌경영대학	\N	1	3	김민규	전공선택	40	1	10	1	경영1관-1313
948	1808	고전과현대문화	디자인예술대학	\N	1	3	노우정	전공선택	40	1	10	1	디예2관-2209
950	1436	모더니즘산책	사회과학대학	\N	1	3	서요성	전공선택	40	1	10	1	사회3관-3305
949	1911	고전과현대문화	사범대학	\N	1	3	노우정	전공선택	40	1	10	1	사범1관-1210
956	1917	클라시카,공자,논어	사범대학	\N	1	3	노우정	전공선택	40	-1	10	1	사범1관-1210
952	1439	고대그리스철학	사회과학대학	\N	1	3	변상출	전공선택	40	-1	10	1	사과1관-1410
944	1548	세계를보는세가지시선	보건바이오대학	\N	1	3	원효식	전공선택	40	0	10	2	생과3관-1302
1002	1730	기술창업의이해	IT·공과대학	\N	1	2	김수연	전공선택	40	0	10	0	공학5관-5306
1010	3944	창업경영전략	창업학	\N	4	3	권순재	전공선택	40	0	10	0	본교가상
1011	3945	스포츠레저창의설계	스포츠산업창업	\N	1	1	권욱동	전공선택	40	0	10	0	인문1관-1429
1013	3946	보장구학	스포츠산업창업	\N	2	2	미선임	전공선택	40	0	10	0	재과1관-1312
1014	3947	초등체육과교육	스포츠산업창업	\N	2	3	김예지	전공선택	40	0	10	0	사범1관-1336
1015	3948	스포츠레져경영론	스포츠산업창업	\N	3	3	박재암	전공선택	40	0	10	0	인문2관-2203
1016	3949	스포츠트레이닝방법론	스포츠산업창업	\N	4	2	한건수	전공선택	40	0	10	0	평교1210
1017	3950	창업경영전략	스포츠산업창업	\N	4	3	권순재	전공선택	40	0	10	0	본교가상
1018	3951	동물자원학	생태관광치유학	\N	1	3	김원섭	전공선택	40	0	10	0	생과3관-1205
1019	3952	기초동물과학	생태관광치유학	\N	1	3	홍창수	전공선택	40	0	10	0	생과3관-1301
1020	3953	특수가축학및실습	생태관광치유학	\N	2	3	심수민	전공선택	40	0	10	0	생과3관-1203
1021	3954	동물영양학및실험	생태관광치유학	\N	2	3	김원섭	전공선택	40	0	10	0	생과3관-1203
1022	3955	축산식품미생물학및실험	생태관광치유학	\N	2	3	강석남	전공선택	40	0	10	0	생과3관-1202
1023	3956	관광상품개발및기획	생태관광치유학	\N	2	3	이광우	전공선택	40	0	10	0	경영1관-1415
1024	3957	식육과학및실습	생태관광치유학	\N	3	3	강석남	전공선택	40	0	10	0	생과3관-1202
1025	3958	축산환경학	생태관광치유학	\N	3	3	심수민	전공선택	40	0	10	0	생과3관-1203
1026	3959	환대산업의경영전략	생태관광치유학	\N	3	3	이광우	전공선택	40	0	10	0	경영1관-1415
1027	3960	가축위생학및실습	생태관광치유학	\N	4	3	강석남	전공선택	40	0	10	0	생과3관-1202
1028	3961	회계원리(1)	외식산업경영학	\N	1	3	최정운	전공선택	40	0	10	0	경영1관-1218
1029	2052	기업경영의이해	재활과학대학	\N	1	3	이기은	전공선택	40	0	10	0	재과1관-1213
1030	3962	원가회계론	외식산업경영학	\N	2	3	정준희	전공필수	40	0	10	0	경영1관-1309
1031	3963	호텔경영의이해	외식산업경영학	\N	2	3	노정희	전공필수	40	0	10	0	경영1관-1419
1032	3964	재무기초와기업이해	외식산업경영학	\N	2	3	이가연	전공선택	40	0	10	0	경영1관-1412
1033	3965	한국음식연구및실습	외식산업경영학	\N	3	3	이정희	전공선택	40	0	10	0	공학3관-3614
1034	3966	MICE산업론	외식산업경영학	\N	3	3	노정희	전공선택	40	0	10	0	경영1관-1320
1035	3967	호텔관광소비자행동의이해	외식산업경영학	\N	3	3	노정희	전공선택	40	0	10	0	경영1관-1415
1036	3968	식품품질평가실무	외식산업경영학	\N	4	3	이정희	전공선택	40	0	10	0	공학3관-3614
1037	3969	전기전자일반	글로벌ICT전공	\N	1	3	여준호	전공선택	40	0	10	0	공학5관-5105
1038	3970	초급일본어문법(1)	글로벌ICT전공	\N	1	3	김봉정	전공선택	40	0	10	0	인문2관-2203
1039	3900	생활속의반도체	대학전체	\N	1	3	허경섭	전공선택	40	0	10	0	외부가상
1040	1063	AI시대기술과윤리	대학전체	\N	1	3	김현숙	전공선택	40	0	10	0	DU∼MOOC
1041	1723	AI시대기술과윤리	IT·공과대학	\N	1	3	김현숙	전공선택	40	0	10	0	공학5관-5206
1042	1080	TOEIC	대학전체	\N	1	2	라포인트 마크 앤드류	전공선택	40	0	10	0	경영1관-1401
1043	1082	비즈니스영어	대학전체	\N	1	3	마이클 파을	전공선택	40	0	10	0	경영1관-1418
1044	1094	글로벌마켓창업과경영	대학전체	\N	1	3	이화진	전공선택	40	0	10	0	교수학습1107
1045	1137	컴퓨터처럼생각하기	대학전체	\N	1	3	정선영	전공선택	40	0	10	0	외부가상
1046	3971	C프로그래밍	글로벌ICT전공	\N	2	3	도용태	전공선택	40	0	10	0	공학5관-5601
1047	3972	일본어회화	글로벌ICT전공	\N	2	3	타케시타 치카	전공선택	40	0	10	0	인문2관-2202
1048	3973	앱프로그래밍	글로벌ICT전공	\N	3	3	진성근	전공선택	40	0	10	0	공학7관-7507
1049	3974	장애의이해와재활	미술치료전공	\N	1	3	최은영	전공선택	40	0	10	0	재과1관-1215
1050	3975	색채학	미술치료전공	\N	2	3	조주원	전공선택	40	0	10	0	디예1관-1107
1051	3976	장애인복지론	미술치료전공	\N	2	3	이동석	전공선택	40	0	10	0	사회3관-3304
1052	3977	재활정책론	미술치료전공	\N	2	3	조성재	전공선택	40	0	10	0	재과1관-1213재과1관-1214
1053	3978	장애아동진단및평가	미술치료전공	\N	3	3	서귀남	전공선택	40	0	10	0	재과1관-1315
1054	3979	창작과기법(1)	미술치료전공	\N	3	2	미선임	전공선택	40	0	10	0	디예1관-1301
1055	3980	미술치료학개론	미술치료전공	\N	3	3	미선임	전공선택	40	0	10	0	재과1관-1214
1056	3981	부모교육및상담	미술치료전공	\N	4	3	박지성	전공선택	40	0	10	0	재과1관-1211
1057	3935	미술재활현장실습	미술치료전공	\N	4	3	최은영	전공선택	40	0	10	0	현장실습
1058	3982	경영데이터분석	비즈니스데이터전	\N	1	3	박상철	전공선택	40	0	10	0	교수학습1107
1059	3983	경영통계학	비즈니스데이터전	\N	2	3	정인준	전공필수	40	0	10	0	경영1관-1301
1060	3984	정보보호	비즈니스데이터전	\N	2	3	미선임	전공선택	40	0	10	0	공학7관-7605
1061	3985	데이터베이스	비즈니스데이터전	\N	3	3	오유수	전공선택	40	0	10	0	공학7관-7605
1062	3986	앱프로그래밍	비즈니스데이터전	\N	3	3	진성근	전공선택	40	0	10	0	공학7관-7507
1063	3987	인공지능	비즈니스데이터전	\N	4	3	김종완	전공선택	40	0	10	0	공학7관-7514
1064	3988	사물인터넷	비즈니스데이터전	\N	4	3	남흥우	전공선택	40	0	10	0	공학7관-7507
1065	3989	SW프로세스관리	비즈니스데이터전	\N	4	3	김수연	전공선택	40	0	10	0	공학7관-7615
1066	3990	파이썬프로그래밍	AI응용전공	\N	1	3	강신재	전공선택	40	0	10	0	공학7관-7705
1067	3991	딥러닝기초	AI응용전공	\N	2	3	차경애	전공필수	40	0	10	0	공학5관-5505
1068	3992	자료구조	AI응용전공	\N	2	3	강병도	전공선택	40	0	10	0	공학7관-7514
1069	3993	머신러닝	AI응용전공	\N	2	3	염석원	전공선택	40	0	10	0	공학7관-7307
1070	3994	자료구조와알고리즘	AI응용전공	\N	2	3	차경애	전공선택	40	0	10	0	공학5관-5505
1071	3995	자바프로그래밍	AI응용전공	\N	3	3	박세현	전공선택	40	0	10	0	공학5관-5603
1072	3996	오픈소스소프트웨어	AI응용전공	\N	3	3	강신재	전공선택	40	0	10	0	공학7관-7605
1073	3997	앱프로그래밍	AI응용전공	\N	3	3	진성근	전공선택	40	0	10	0	공학7관-7507
1074	3998	컴퓨터비전응용	AI응용전공	\N	3	3	염석원	전공선택	40	0	10	0	공학7관-7307
1075	3999	컴퓨터비전시스템	AI응용전공	\N	3	3	이동화	전공선택	40	0	10	0	공학5관-5605
1076	4000	전기전자일반	스마트센싱전공	\N	1	3	정현	전공선택	40	0	10	0	공학5관-5206
1077	4001	딥러닝기초	스마트센싱전공	\N	2	3	차경애	전공필수	40	0	10	0	공학5관-5505
1078	4002	회로이론(1)	스마트센싱전공	\N	2	3	심용석	전공선택	40	0	10	0	공학5관-5105
1079	4003	디지털공학(1)	스마트센싱전공	\N	2	3	이익수	전공선택	40	0	10	0	공학5관-5205
1080	4004	자료구조와알고리즘	스마트센싱전공	\N	2	3	차경애	전공선택	40	0	10	0	공학5관-5505
1081	4005	전자회로(2)	스마트센싱전공	\N	3	3	문현원	전공선택	40	0	10	0	공학5관-5104
1082	4006	마이크로컴퓨터시스템설계	스마트센싱전공	\N	3	3	미선임	전공선택	40	0	10	0	공학5관-5605
1083	4007	종합설계	스마트센싱전공	\N	4	3	류정탁	전공필수	40	0	10	0	공학5관-5301
1084	4008	전기전자일반	스마트제로에너지	\N	1	3	여준호	전공선택	40	0	10	0	공학5관-5105
1085	4009	회로이론(1)	스마트제로에너지	\N	2	3	최병재	전공선택	40	0	10	0	공학5관-5205
1086	4010	디지털공학(1)	스마트제로에너지	\N	2	3	정영호	전공선택	40	0	10	0	공학5관-5306
1087	4011	자동제어	스마트제로에너지	\N	3	3	최병재	전공선택	40	0	10	0	공학5관-5305
1088	4012	전기기기	스마트제로에너지	\N	3	3	정재우	전공선택	40	0	10	0	공학5관-5306
1089	4013	전기계측	스마트제로에너지	\N	3	3	도용태	전공선택	40	0	10	0	공학5관-5206
1090	4014	디스플레이공학	스마트제로에너지	\N	4	3	박철영	전공선택	40	0	10	0	공학5관-5104
1091	4015	동물자원학	스마트팜전공	\N	1	3	김원섭	전공선택	40	0	10	0	생과3관-1205
1092	4016	회로이론(1)	스마트팜전공	\N	2	3	최병재	전공선택	40	0	10	0	공학5관-5205
1093	4017	디지털공학(1)	스마트팜전공	\N	2	3	정영호	전공선택	40	0	10	0	공학5관-5306
1094	4018	가축사양학및실습	스마트팜전공	\N	3	3	김원섭	전공선택	40	0	10	0	생과3관-1203
1095	4019	농산물품질관리론	스마트팜전공	\N	3	3	사공동훈	전공선택	40	0	10	0	생과5관-2413
1096	4020	축산환경학	스마트팜전공	\N	3	3	심수민	전공선택	40	0	10	0	생과3관-1203
1097	4021	치유농업사육및실습	스마트팜전공	\N	3	3	이신자	전공선택	40	0	10	0	생과3관-1303
1098	4022	원예치료개론	스마트팜전공	\N	3	3	김영선	전공선택	40	0	10	0	생과5관-2412
1099	4023	가축위생학및실습	스마트팜전공	\N	4	3	강석남	전공선택	40	0	10	0	생과3관-1202
1100	4024	임베디드시스템	스마트팜전공	\N	4	3	유성은	전공선택	40	0	10	0	공학5관-5605
1101	4025	경영학원론	프리로스쿨전공	\N	1	3	이웅규	전공선택	40	0	10	0	경영1관-1313
1102	4026	법학개론	프리로스쿨전공	\N	1	3	최진원	전공선택	40	0	10	0	공공인재-131
1103	4027	헌법입문	프리로스쿨전공	\N	1	3	정극원	전공선택	40	0	10	0	공공인재-230
1104	1262	정의란무엇인가	공공인재대학	\N	1	3	이용승	전공선택	40	0	10	0	사회3관-3305
1105	1925	추리와논증	사범대학	\N	1	3	김영진	전공선택	40	0	10	0	사범1관-1434
1106	4684	물권법	프리로스쿨전공	\N	2	3	장병주	전공선택	40	0	10	0	공공인재-240
1107	4685	행정법총론	프리로스쿨전공	\N	2	3	이상학	전공선택	40	0	10	0	공공인재-131
1108	4686	행정법총론	프리로스쿨전공	\N	2	3	이상학	전공선택	40	0	10	0	공공인재-131
1109	4028	경제와사회	프리로스쿨전공	\N	3	3	이승협	전공선택	40	0	10	0	사회3관-3303
1110	4029	민법개론	프리로스쿨전공	\N	4	3	장병주	전공선택	40	0	10	0	공공인재-120
1111	1059	동아시아수도인문기행	대학전체	\N	1	3	권응상	전공선택	40	0	10	0	DU∼MOOC
1112	2226	동아시아고도인문기행	글로컬라이프대학	\N	1	3	권응상	전공선택	40	0	10	0	DU∼MOOC
1113	1064	동아시아항도인문기행	대학전체	\N	1	3	권응상	전공선택	40	0	10	0	DU∼MOOC
1114	4030	일본사회와관광	동아시아도시인문	\N	3	3	최장근	전공선택	40	0	10	0	인문1관-1321
1115	4031	일본도시기행	동아시아도시인문	\N	4	3	곽동곤	전공선택	40	0	10	0	인문2관-2402
1116	4032	소프트웨어개발입문	사이버수사전공	\N	1	3	김지연	전공선택	40	0	10	0	공학7관-7507
1117	4033	사이버보안개론	사이버수사전공	\N	1	3	김창훈	전공선택	40	0	10	0	공학7관-7705
1118	4034	딥러닝기초	사이버수사전공	\N	2	3	차경애	전공필수	40	0	10	0	공학5관-5505
1119	4035	운영체제	사이버수사전공	\N	2	3	김순철	전공선택	40	0	10	0	공학7관-7615
1120	4036	컴퓨터구조	사이버수사전공	\N	2	3	남흥우	전공선택	40	0	10	0	공학7관-7514
1121	4037	데이터베이스	사이버수사전공	\N	3	3	오유수	전공선택	40	0	10	0	공학7관-7605
1122	4038	데이터통신	사이버수사전공	\N	3	3	김중규	전공선택	40	0	10	0	공학5관-5106
1123	4039	시스템프로그래밍	사이버수사전공	\N	3	3	김순철	전공선택	40	0	10	0	공학7관-7506
1124	4040	네트워크보안	사이버수사전공	\N	3	3	홍원기	전공선택	40	0	10	0	공학7관-7606
1125	4041	소프트웨어분석및설계	사이버수사전공	\N	3	3	김수연	전공선택	40	0	10	0	공학7관-7615
1126	4042	모의해킹	사이버수사전공	\N	4	3	김창훈	전공선택	40	0	10	0	공학7관-7705
1127	1115	반도체센서로바라보는세상	대학전체	\N		3	허경섭	전공선택	40	0	10	0	외부가상
1128	1559	이차전지소개	보건바이오대학	\N	1	3	권영환	전공선택	40	0	10	0	생과3관-1205
941	1369	즐거운철학이야기	글로벌경영대학	\N	1	3	양승권	전공선택	40	1	10	3	경영1관-1310
942	1435	즐거운철학이야기	사회과학대학	\N	1	3	김영진	전공선택	40	0	10	2	사회3관-3202
\.


--
-- Data for Name: notice_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.notice_tb (id, title, content, author_id, created_at) FROM stdin;
b827ab8e-b9ce-429a-bd7e-9ba3cd618dac	[RAG] ??? ??	??? ?? ?????.	\N	2026-03-11 01:43:32.084178
e835ea1a-54dd-414c-be1d-20908b7e709b	[RAG] mock-rag-20260311015931-7f89ba69	mock rag content for system check	\N	2026-03-11 01:59:32.204794
\.


--
-- Data for Name: notification_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.notification_tb (id, user_id, message, is_read, created_at) FROM stdin;
\.


--
-- Data for Name: overenroll_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.overenroll_tb (over_no, user_no, lecture_id, sche_no, reason, loginid) FROM stdin;
\.


--
-- Data for Name: rag_docs_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.rag_docs_tb (id, title, content, embedding, created_at, metadata) FROM stdin;
\.


--
-- Data for Name: schedule_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.schedule_tb (sche_no, lecture_id, day_of_week, start_min, end_min, start_time, end_time, classroom) FROM stdin;
1431	941	화	720	795	12:00:00	13:15:00	경영1관-1310
1432	942	월	720	795	12:00:00	13:15:00	사회3관-3202
1433	942	수	720	795	12:00:00	13:15:00	사회3관-3202
1434	943	월	720	795	12:00:00	13:15:00	사범1관-1434
1435	943	수	720	795	12:00:00	13:15:00	사범1관-1434
1436	944	화	810	885	13:30:00	14:45:00	생과3관-1302
1437	944	목	900	975	15:00:00	16:15:00	생과3관-1302
1438	945	월	990	1065	16:30:00	17:45:00	사회3관-3202
1439	945	수	990	1065	16:30:00	17:45:00	사회3관-3202
1440	946	화	990	1065	16:30:00	17:45:00	경영1관-1313
1441	946	목	990	1065	16:30:00	17:45:00	경영1관-1313
1442	947	화	810	885	13:30:00	14:45:00	생과2관-1104
1443	947	목	900	975	15:00:00	16:15:00	생과2관-1104
1444	948	화	810	885	13:30:00	14:45:00	디예2관-2209
1445	948	목	900	975	15:00:00	16:15:00	디예2관-2209
1446	949	화	990	1065	16:30:00	17:45:00	사범1관-1210
1447	949	목	990	1065	16:30:00	17:45:00	사범1관-1210
1448	950	월	900	975	15:00:00	16:15:00	사회3관-3305
1449	950	수	810	885	13:30:00	14:45:00	사회3관-3305
1450	952	화	720	795	12:00:00	13:15:00	사과1관-1410
1451	952	목	720	795	12:00:00	13:15:00	사과1관-1410
1452	954	수	900	975	15:00:00	16:15:00	사범1관-1217
1454	956	월	630	705	10:30:00	11:45:00	사범1관-1210
1455	956	수	540	615	09:00:00	10:15:00	사범1관-1210
1456	957	월	630	705	10:30:00	11:45:00	경영1관-1311
1457	957	수	540	615	09:00:00	10:15:00	경영1관-1311
1459	959	금	660	770	11:00:00	12:50:00	공학1관-0202
1460	961	화	630	705	10:30:00	11:45:00	인문1관-1220
1461	961	목	540	615	09:00:00	10:15:00	인문1관-1220
1463	963	화	900	975	15:00:00	16:15:00	생과3관-1205
1464	963	목	810	885	13:30:00	14:45:00	생과3관-1205
1465	964	월	810	885	13:30:00	14:45:00	공학1관-0201
1466	964	수	900	975	15:00:00	16:15:00	공학1관-0201
1467	965	수	810	885	13:30:00	14:45:00	재과1관-1104
1468	966	화	810	885	13:30:00	14:45:00	사회3관-3201
1469	966	목	900	975	15:00:00	16:15:00	사회3관-3201
1470	967	월	990	1065	16:30:00	17:45:00	디예2관-2310
1471	968	화	810	885	13:30:00	14:45:00	사범1관-1216
1472	969	월	900	975	15:00:00	16:15:00	재과1관-1212
1473	969	수	810	885	13:30:00	14:45:00	재과1관-1212
1474	970	금	810	885	13:30:00	14:45:00	인문2관-2202
1475	970	금	900	975	15:00:00	16:15:00	인문2관-2202
1476	971	금	540	615	09:00:00	10:15:00	디예2관-2310
1477	971	금	630	705	10:30:00	11:45:00	디예2관-2310
1480	973	화	990	1065	16:30:00	17:45:00	인문2관-2202
1481	973	목	990	1065	16:30:00	17:45:00	인문2관-2202
1482	974	월	810	885	13:30:00	14:45:00	디예2관-2310
1483	974	수	900	975	15:00:00	16:15:00	디예2관-2310
1484	975	화	990	1065	16:30:00	17:45:00	사범1관-1216
1485	975	목	990	1065	16:30:00	17:45:00	사범1관-1216
1486	977	화	720	795	12:00:00	13:15:00	경영1관-1209
1487	977	목	720	795	12:00:00	13:15:00	경영1관-1209
1488	978	화	990	1065	16:30:00	17:45:00	사과1관-1410
1489	978	목	990	1065	16:30:00	17:45:00	사과1관-1410
1490	979	화	720	795	12:00:00	13:15:00	재과1관-1213
1491	979	목	720	795	12:00:00	13:15:00	재과1관-1213
1492	981	수	720	795	12:00:00	13:15:00	사범1관-1216
1493	982	화	990	1065	16:30:00	17:45:00	재과1관-1213
1494	983	화	720	795	12:00:00	13:15:00	경영1관-1313
1495	983	목	720	795	12:00:00	13:15:00	경영1관-1313
1496	984	수	720	830	12:00:00	13:50:00	인문1관-1324
1497	985	목	780	890	13:00:00	14:50:00	사범1관-1434
1498	986	월	900	975	15:00:00	16:15:00	경영1관-1312
1499	986	수	810	885	13:30:00	14:45:00	경영1관-1312
1500	987	수	600	710	10:00:00	11:50:00	디예2관-2310
1501	988	목	600	710	10:00:00	11:50:00	사범1관-1434
1502	989	목	540	770	09:00:00	12:50:00	디예1관-1413
1503	990	화	810	885	13:30:00	14:45:00	생과1관-1414
1504	990	목	900	975	15:00:00	16:15:00	생과1관-1414
1505	991	월	990	1065	16:30:00	17:45:00	공학1관-0202
1506	991	수	990	1065	16:30:00	17:45:00	공학1관-0202
1507	992	화	990	1065	16:30:00	17:45:00	재과1관-1212
1508	992	목	990	1065	16:30:00	17:45:00	재과1관-1212
1511	995	월	540	615	09:00:00	10:15:00	경영1관-1212
1512	995	월	630	705	10:30:00	11:45:00	경영1관-1212
1519	1002	목	900	1010	15:00:00	16:50:00	공학5관-5306
1528	1011	목	780	890	13:00:00	14:50:00	인문1관-1429
1530	1013	금	840	950	14:00:00	15:50:00	재과1관-1312
1531	1014	수	900	975	15:00:00	16:15:00	사범1관-1336
1532	1014	수	990	1065	16:30:00	17:45:00	사범1관-1336
1533	1015	월	810	885	13:30:00	14:45:00	인문2관-2203
1534	1015	수	900	975	15:00:00	16:15:00	인문2관-2203
1535	1016	목	540	710	09:00:00	11:50:00	평교1210
1536	1018	금	540	615	09:00:00	10:15:00	생과3관-1205
1537	1018	금	630	705	10:30:00	11:45:00	생과3관-1205
1538	1019	월	900	975	15:00:00	16:15:00	생과3관-1301
1539	1019	수	810	885	13:30:00	14:45:00	생과3관-1301
1540	1020	금	540	770	09:00:00	12:50:00	생과3관-1203
1541	1021	수	540	770	09:00:00	12:50:00	생과3관-1203
1542	1022	화	540	770	09:00:00	12:50:00	생과3관-1202
1543	1023	화	720	795	12:00:00	13:15:00	경영1관-1415
1544	1024	수	780	1010	13:00:00	16:50:00	생과3관-1202
1545	1025	금	810	885	13:30:00	14:45:00	생과3관-1203
1546	1025	금	900	975	15:00:00	16:15:00	생과3관-1203
1547	1026	월	900	975	15:00:00	16:15:00	경영1관-1415
1548	1026	수	810	885	13:30:00	14:45:00	경영1관-1415
1549	1027	목	780	1010	13:00:00	16:50:00	생과3관-1202
1550	1028	월	630	705	10:30:00	11:45:00	경영1관-1218
1551	1028	수	540	615	09:00:00	10:15:00	경영1관-1218
1552	1029	월	900	975	15:00:00	16:15:00	재과1관-1213
1553	1029	수	810	885	13:30:00	14:45:00	재과1관-1213
1554	1030	월	630	705	10:30:00	11:45:00	경영1관-1309
1555	1030	수	540	615	09:00:00	10:15:00	경영1관-1309
1556	1031	월	810	885	13:30:00	14:45:00	경영1관-1419
1557	1031	수	900	975	15:00:00	16:15:00	경영1관-1419
1558	1032	화	540	615	09:00:00	10:15:00	경영1관-1412
1559	1032	목	630	705	10:30:00	11:45:00	경영1관-1412
1560	1033	수	540	770	09:00:00	12:50:00	공학3관-3614
1561	1034	화	630	705	10:30:00	11:45:00	경영1관-1320
1562	1034	목	540	615	09:00:00	10:15:00	경영1관-1320
1563	1035	화	900	975	15:00:00	16:15:00	경영1관-1415
1564	1036	화	840	1010	14:00:00	16:50:00	공학3관-3614
1565	1037	월	540	615	09:00:00	10:15:00	공학5관-5105
1566	1037	수	630	705	10:30:00	11:45:00	공학5관-5105
1567	1038	월	900	975	15:00:00	16:15:00	인문2관-2203
1568	1038	수	810	885	13:30:00	14:45:00	인문2관-2203
1569	1041	월	720	795	12:00:00	13:15:00	공학5관-5206
1570	1041	수	720	795	12:00:00	13:15:00	공학5관-5206
1571	1042	수	840	950	14:00:00	15:50:00	경영1관-1401
1572	1043	화	720	795	12:00:00	13:15:00	경영1관-1418
1573	1043	목	720	795	12:00:00	13:15:00	경영1관-1418
1574	1044	목	540	615	09:00:00	10:15:00	교수학습1107
1575	1044	목	630	705	10:30:00	11:45:00	교수학습1107
1576	1046	화	810	885	13:30:00	14:45:00	공학5관-5601
1577	1046	목	900	975	15:00:00	16:15:00	공학5관-5601
1578	1047	월	900	975	15:00:00	16:15:00	인문2관-2202
1579	1047	수	810	885	13:30:00	14:45:00	인문2관-2202
1580	1048	금	780	1010	13:00:00	16:50:00	공학7관-7507
1581	1049	화	720	795	12:00:00	13:15:00	재과1관-1215
1582	1049	목	720	795	12:00:00	13:15:00	재과1관-1215
1583	1050	수	540	770	09:00:00	12:50:00	디예1관-1107
1584	1051	화	630	705	10:30:00	11:45:00	사회3관-3304
1585	1051	목	540	615	09:00:00	10:15:00	사회3관-3304
1586	1052	월	630	705	10:30:00	11:45:00	재과1관-1213재과1관-1214
1587	1052	수	540	615	09:00:00	10:15:00	재과1관-1213재과1관-1214
1588	1053	수	540	615	09:00:00	10:15:00	재과1관-1315
1589	1053	수	630	705	10:30:00	11:45:00	재과1관-1315
1590	1054	수	780	1010	13:00:00	16:50:00	디예1관-1301
1591	1055	월	540	615	09:00:00	10:15:00	재과1관-1214
1592	1055	월	630	705	10:30:00	11:45:00	재과1관-1214
1593	1056	화	540	615	09:00:00	10:15:00	재과1관-1211
1594	1056	화	630	705	10:30:00	11:45:00	재과1관-1211
1595	1058	화	810	885	13:30:00	14:45:00	교수학습1107
1596	1058	목	900	975	15:00:00	16:15:00	교수학습1107
1597	1059	화	900	975	15:00:00	16:15:00	경영1관-1301
1598	1059	목	810	885	13:30:00	14:45:00	경영1관-1301
1599	1060	화	540	770	09:00:00	12:50:00	공학7관-7605
1600	1061	월	540	615	09:00:00	10:15:00	공학7관-7605
1601	1061	수	630	705	10:30:00	11:45:00	공학7관-7605
1602	1062	금	780	1010	13:00:00	16:50:00	공학7관-7507
1603	1063	월	630	705	10:30:00	11:45:00	공학7관-7514
1604	1063	수	540	615	09:00:00	10:15:00	공학7관-7514
1605	1064	목	720	950	12:00:00	15:50:00	공학7관-7507
1606	1065	월	900	975	15:00:00	16:15:00	공학7관-7615
1607	1065	수	810	885	13:30:00	14:45:00	공학7관-7615
1608	1066	월	540	770	09:00:00	12:50:00	공학7관-7705
1609	1067	월	810	885	13:30:00	14:45:00	공학5관-5505
1610	1067	수	900	975	15:00:00	16:15:00	공학5관-5505
1611	1068	월	810	885	13:30:00	14:45:00	공학7관-7514
1612	1068	수	900	975	15:00:00	16:15:00	공학7관-7514
1613	1069	화	720	795	12:00:00	13:15:00	공학7관-7307
1614	1069	목	720	795	12:00:00	13:15:00	공학7관-7307
1615	1070	화	810	885	13:30:00	14:45:00	공학5관-5505
1616	1070	목	900	975	15:00:00	16:15:00	공학5관-5505
1617	1071	월	780	890	13:00:00	14:50:00	공학5관-5603
1618	1071	수	900	1010	15:00:00	16:50:00	공학5관-5603
1619	1072	금	540	615	09:00:00	10:15:00	공학7관-7605
1620	1072	금	630	705	10:30:00	11:45:00	공학7관-7605
1621	1073	금	780	1010	13:00:00	16:50:00	공학7관-7507
1622	1074	화	900	975	15:00:00	16:15:00	공학7관-7307
1623	1074	목	810	885	13:30:00	14:45:00	공학7관-7307
1624	1075	월	900	975	15:00:00	16:15:00	공학5관-5605
1625	1075	수	810	885	13:30:00	14:45:00	공학5관-5605
1626	1076	화	540	615	09:00:00	10:15:00	공학5관-5206
1627	1076	목	630	705	10:30:00	11:45:00	공학5관-5206
1628	1077	월	810	885	13:30:00	14:45:00	공학5관-5505
1629	1077	수	900	975	15:00:00	16:15:00	공학5관-5505
1630	1078	화	540	615	09:00:00	10:15:00	공학5관-5105
1631	1078	목	630	705	10:30:00	11:45:00	공학5관-5105
1632	1079	목	900	975	15:00:00	16:15:00	공학5관-5205
1633	1079	목	990	1065	16:30:00	17:45:00	공학5관-5205
1634	1080	화	810	885	13:30:00	14:45:00	공학5관-5505
1635	1080	목	900	975	15:00:00	16:15:00	공학5관-5505
1636	1081	수	900	975	15:00:00	16:15:00	공학5관-5104
1637	1082	목	810	885	13:30:00	14:45:00	공학5관-5605
1638	1082	목	900	975	15:00:00	16:15:00	공학5관-5605
1639	1083	월	810	885	13:30:00	14:45:00	공학5관-5301
1640	1083	월	900	975	15:00:00	16:15:00	공학5관-5301
1641	1084	월	540	615	09:00:00	10:15:00	공학5관-5105
1642	1084	수	630	705	10:30:00	11:45:00	공학5관-5105
1643	1085	월	540	615	09:00:00	10:15:00	공학5관-5205
1644	1085	수	630	705	10:30:00	11:45:00	공학5관-5205
1645	1086	월	630	705	10:30:00	11:45:00	공학5관-5306
1646	1086	수	540	615	09:00:00	10:15:00	공학5관-5306
1647	1087	월	630	705	10:30:00	11:45:00	공학5관-5305
1648	1087	수	540	615	09:00:00	10:15:00	공학5관-5305
1649	1088	화	900	975	15:00:00	16:15:00	공학5관-5306
1650	1088	목	810	885	13:30:00	14:45:00	공학5관-5306
1651	1089	월	810	885	13:30:00	14:45:00	공학5관-5206
1652	1089	수	900	975	15:00:00	16:15:00	공학5관-5206
1653	1090	화	540	615	09:00:00	10:15:00	공학5관-5104
1654	1090	목	630	705	10:30:00	11:45:00	공학5관-5104
1655	1091	금	540	615	09:00:00	10:15:00	생과3관-1205
1656	1091	금	630	705	10:30:00	11:45:00	생과3관-1205
1657	1092	월	540	615	09:00:00	10:15:00	공학5관-5205
1658	1092	수	630	705	10:30:00	11:45:00	공학5관-5205
1659	1093	월	630	705	10:30:00	11:45:00	공학5관-5306
1660	1093	수	540	615	09:00:00	10:15:00	공학5관-5306
1661	1094	목	540	770	09:00:00	12:50:00	생과3관-1203
1662	1095	월	540	615	09:00:00	10:15:00	생과5관-2413
1663	1095	수	630	705	10:30:00	11:45:00	생과5관-2413
1664	1096	금	810	885	13:30:00	14:45:00	생과3관-1203
1665	1096	금	900	975	15:00:00	16:15:00	생과3관-1203
1666	1097	월	780	1010	13:00:00	16:50:00	생과3관-1303
1667	1098	화	540	615	09:00:00	10:15:00	생과5관-2412
1668	1098	목	630	705	10:30:00	11:45:00	생과5관-2412
1669	1099	목	780	1010	13:00:00	16:50:00	생과3관-1202
1670	1100	월	630	705	10:30:00	11:45:00	공학5관-5605
1671	1100	수	540	615	09:00:00	10:15:00	공학5관-5605
1672	1101	수	810	885	13:30:00	14:45:00	경영1관-1313
1673	1101	수	900	975	15:00:00	16:15:00	경영1관-1313
1674	1102	월	810	885	13:30:00	14:45:00	공공인재-131
1675	1102	수	900	975	15:00:00	16:15:00	공공인재-131
1676	1103	월	900	975	15:00:00	16:15:00	공공인재-230
1677	1103	수	810	885	13:30:00	14:45:00	공공인재-230
1678	1104	화	900	975	15:00:00	16:15:00	사회3관-3305
1679	1104	목	810	885	13:30:00	14:45:00	사회3관-3305
1680	1105	월	810	885	13:30:00	14:45:00	사범1관-1434
1681	1105	수	900	975	15:00:00	16:15:00	사범1관-1434
1682	1106	월	630	705	10:30:00	11:45:00	공공인재-240
1683	1106	수	540	615	09:00:00	10:15:00	공공인재-240
1684	1107	화	540	615	09:00:00	10:15:00	공공인재-131
1685	1107	목	630	705	10:30:00	11:45:00	공공인재-131
1686	1108	월	630	705	10:30:00	11:45:00	공공인재-131
1687	1108	수	540	615	09:00:00	10:15:00	공공인재-131
1688	1109	화	720	795	12:00:00	13:15:00	사회3관-3303
1689	1109	목	720	795	12:00:00	13:15:00	사회3관-3303
1690	1110	화	900	975	15:00:00	16:15:00	공공인재-120
1691	1110	목	810	885	13:30:00	14:45:00	공공인재-120
1692	1114	월	810	885	13:30:00	14:45:00	인문1관-1321
1693	1114	수	900	975	15:00:00	16:15:00	인문1관-1321
1694	1115	월	900	975	15:00:00	16:15:00	인문2관-2402
1695	1115	수	810	885	13:30:00	14:45:00	인문2관-2402
1696	1116	목	600	830	10:00:00	13:50:00	공학7관-7507
1697	1117	월	720	830	12:00:00	13:50:00	공학7관-7705
1698	1117	화	600	710	10:00:00	11:50:00	공학7관-7705
1699	1118	월	810	885	13:30:00	14:45:00	공학5관-5505
1700	1118	수	900	975	15:00:00	16:15:00	공학5관-5505
1701	1119	월	630	705	10:30:00	11:45:00	공학7관-7615
1702	1119	수	540	615	09:00:00	10:15:00	공학7관-7615
1703	1120	화	990	1065	16:30:00	17:45:00	공학7관-7514
1704	1120	목	990	1065	16:30:00	17:45:00	공학7관-7514
1705	1121	월	540	615	09:00:00	10:15:00	공학7관-7605
1706	1121	수	630	705	10:30:00	11:45:00	공학7관-7605
1707	1122	월	810	885	13:30:00	14:45:00	공학5관-5106
1708	1122	수	900	975	15:00:00	16:15:00	공학5관-5106
1709	1123	화	840	1070	14:00:00	17:50:00	공학7관-7506
1710	1124	화	780	1010	13:00:00	16:50:00	공학7관-7606
1711	1125	월	810	885	13:30:00	14:45:00	공학7관-7615
1712	1125	수	900	975	15:00:00	16:15:00	공학7관-7615
1713	1126	월	600	710	10:00:00	11:50:00	공학7관-7705
1714	1126	수	600	710	10:00:00	11:50:00	공학7관-7705
1715	1128	월	990	1065	16:30:00	17:45:00	생과3관-1205
1716	1128	수	990	1065	16:30:00	17:45:00	생과3관-1205
\.


--
-- Data for Name: system_config_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.system_config_tb (key, value) FROM stdin;
\.


--
-- Data for Name: user_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.user_tb (user_no, loginid, password, role, user_name, grade, dept_no, user_status, birth_date, email, phone, is_first_login, created_at) FROM stdin;
1	201811047	$2b$12$ZYm2Jt1AkEu7ExxiEZAwR.e8vXAQDHJgL3qBwKbvgDoFCpuelVAt2	STUDENT	김준서	\N	\N	재학	\N	\N	\N	\N	\N
2	staff	$2b$12$/wQNhZRpSl2uR7RL9l2maO4VIAPKY75cNa/iQmy9R8mnEysCXYc22	STAFF	교직원	\N	\N	재직	\N	\N	\N	\N	\N
\.


--
-- Data for Name: waitlist_tb; Type: TABLE DATA; Schema: public; Owner: mugang
--

COPY public.waitlist_tb (id, lecture_id, user_id, status, created_at) FROM stdin;
\.


--
-- Name: depart_tb_dept_no_seq; Type: SEQUENCE SET; Schema: public; Owner: mugang
--

SELECT pg_catalog.setval('public.depart_tb_dept_no_seq', 80, true);


--
-- Name: enroll_schedule_tb_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mugang
--

SELECT pg_catalog.setval('public.enroll_schedule_tb_id_seq', 4, true);


--
-- Name: enroll_tb_enroll_no_seq; Type: SEQUENCE SET; Schema: public; Owner: mugang
--

SELECT pg_catalog.setval('public.enroll_tb_enroll_no_seq', 15, true);


--
-- Name: grade_tb_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mugang
--

SELECT pg_catalog.setval('public.grade_tb_id_seq', 1, false);


--
-- Name: lecture_tb_lecture_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mugang
--

SELECT pg_catalog.setval('public.lecture_tb_lecture_id_seq', 1128, true);


--
-- Name: overenroll_tb_over_no_seq; Type: SEQUENCE SET; Schema: public; Owner: mugang
--

SELECT pg_catalog.setval('public.overenroll_tb_over_no_seq', 1, false);


--
-- Name: rag_docs_tb_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mugang
--

SELECT pg_catalog.setval('public.rag_docs_tb_id_seq', 1, false);


--
-- Name: schedule_tb_sche_no_seq; Type: SEQUENCE SET; Schema: public; Owner: mugang
--

SELECT pg_catalog.setval('public.schedule_tb_sche_no_seq', 1716, true);


--
-- Name: user_tb_user_no_seq; Type: SEQUENCE SET; Schema: public; Owner: mugang
--

SELECT pg_catalog.setval('public.user_tb_user_no_seq', 2, true);


--
-- Name: chat_message_tb chat_message_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.chat_message_tb
    ADD CONSTRAINT chat_message_tb_pkey PRIMARY KEY (id);


--
-- Name: chat_session_tb chat_session_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.chat_session_tb
    ADD CONSTRAINT chat_session_tb_pkey PRIMARY KEY (id);


--
-- Name: depart_tb depart_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.depart_tb
    ADD CONSTRAINT depart_tb_pkey PRIMARY KEY (dept_no);


--
-- Name: enroll_schedule_tb enroll_schedule_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.enroll_schedule_tb
    ADD CONSTRAINT enroll_schedule_tb_pkey PRIMARY KEY (id);


--
-- Name: enroll_tb enroll_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.enroll_tb
    ADD CONSTRAINT enroll_tb_pkey PRIMARY KEY (enroll_no);


--
-- Name: form_tb form_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.form_tb
    ADD CONSTRAINT form_tb_pkey PRIMARY KEY (id);


--
-- Name: grade_tb grade_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.grade_tb
    ADD CONSTRAINT grade_tb_pkey PRIMARY KEY (id);


--
-- Name: lecture_tb lecture_tb_course_no_key; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.lecture_tb
    ADD CONSTRAINT lecture_tb_course_no_key UNIQUE (course_no);


--
-- Name: lecture_tb lecture_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.lecture_tb
    ADD CONSTRAINT lecture_tb_pkey PRIMARY KEY (lecture_id);


--
-- Name: notice_tb notice_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.notice_tb
    ADD CONSTRAINT notice_tb_pkey PRIMARY KEY (id);


--
-- Name: notification_tb notification_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.notification_tb
    ADD CONSTRAINT notification_tb_pkey PRIMARY KEY (id);


--
-- Name: overenroll_tb overenroll_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.overenroll_tb
    ADD CONSTRAINT overenroll_tb_pkey PRIMARY KEY (over_no);


--
-- Name: rag_docs_tb rag_docs_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.rag_docs_tb
    ADD CONSTRAINT rag_docs_tb_pkey PRIMARY KEY (id);


--
-- Name: schedule_tb schedule_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.schedule_tb
    ADD CONSTRAINT schedule_tb_pkey PRIMARY KEY (sche_no);


--
-- Name: system_config_tb system_config_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.system_config_tb
    ADD CONSTRAINT system_config_tb_pkey PRIMARY KEY (key);


--
-- Name: user_tb user_tb_email_key; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.user_tb
    ADD CONSTRAINT user_tb_email_key UNIQUE (email);


--
-- Name: user_tb user_tb_loginid_key; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.user_tb
    ADD CONSTRAINT user_tb_loginid_key UNIQUE (loginid);


--
-- Name: user_tb user_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.user_tb
    ADD CONSTRAINT user_tb_pkey PRIMARY KEY (user_no);


--
-- Name: waitlist_tb waitlist_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.waitlist_tb
    ADD CONSTRAINT waitlist_tb_pkey PRIMARY KEY (id);


--
-- Name: ix_chat_message_tb_created_at; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_chat_message_tb_created_at ON public.chat_message_tb USING btree (created_at);


--
-- Name: ix_chat_message_tb_session_id; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_chat_message_tb_session_id ON public.chat_message_tb USING btree (session_id);


--
-- Name: ix_chat_session_tb_created_at; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_chat_session_tb_created_at ON public.chat_session_tb USING btree (created_at);


--
-- Name: ix_chat_session_tb_user_id; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_chat_session_tb_user_id ON public.chat_session_tb USING btree (user_id);


--
-- Name: ix_form_tb_created_at; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_form_tb_created_at ON public.form_tb USING btree (created_at);


--
-- Name: ix_form_tb_status; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_form_tb_status ON public.form_tb USING btree (status);


--
-- Name: ix_form_tb_user_id; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_form_tb_user_id ON public.form_tb USING btree (user_id);


--
-- Name: ix_grade_tb_enrollment_id; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_grade_tb_enrollment_id ON public.grade_tb USING btree (enrollment_id);


--
-- Name: ix_grade_tb_user_id; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_grade_tb_user_id ON public.grade_tb USING btree (user_id);


--
-- Name: ix_lecture_tb_department; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_lecture_tb_department ON public.lecture_tb USING btree (department);


--
-- Name: ix_lecture_tb_lec_grade; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_lecture_tb_lec_grade ON public.lecture_tb USING btree (lec_grade);


--
-- Name: ix_lecture_tb_type; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_lecture_tb_type ON public.lecture_tb USING btree (type);


--
-- Name: ix_notification_tb_user_id; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_notification_tb_user_id ON public.notification_tb USING btree (user_id);


--
-- Name: ix_user_tb_user_name; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_user_tb_user_name ON public.user_tb USING btree (user_name);


--
-- Name: ix_waitlist_tb_created_at; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_waitlist_tb_created_at ON public.waitlist_tb USING btree (created_at);


--
-- Name: ix_waitlist_tb_lecture_id; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_waitlist_tb_lecture_id ON public.waitlist_tb USING btree (lecture_id);


--
-- Name: ix_waitlist_tb_user_id; Type: INDEX; Schema: public; Owner: mugang
--

CREATE INDEX ix_waitlist_tb_user_id ON public.waitlist_tb USING btree (user_id);


--
-- Name: chat_message_tb chat_message_tb_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.chat_message_tb
    ADD CONSTRAINT chat_message_tb_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.chat_session_tb(id) ON DELETE CASCADE;


--
-- Name: chat_session_tb chat_session_tb_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.chat_session_tb
    ADD CONSTRAINT chat_session_tb_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_tb(user_no) ON DELETE CASCADE;


--
-- Name: enroll_tb enroll_tb_lecture_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.enroll_tb
    ADD CONSTRAINT enroll_tb_lecture_id_fkey FOREIGN KEY (lecture_id) REFERENCES public.lecture_tb(lecture_id);


--
-- Name: enroll_tb enroll_tb_loginid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.enroll_tb
    ADD CONSTRAINT enroll_tb_loginid_fkey FOREIGN KEY (loginid) REFERENCES public.user_tb(user_no);


--
-- Name: form_tb form_tb_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.form_tb
    ADD CONSTRAINT form_tb_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_tb(user_no) ON DELETE CASCADE;


--
-- Name: grade_tb grade_tb_enrollment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.grade_tb
    ADD CONSTRAINT grade_tb_enrollment_id_fkey FOREIGN KEY (enrollment_id) REFERENCES public.enroll_tb(enroll_no) ON DELETE CASCADE;


--
-- Name: grade_tb grade_tb_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.grade_tb
    ADD CONSTRAINT grade_tb_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_tb(user_no) ON DELETE CASCADE;


--
-- Name: lecture_tb lecture_tb_dept_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.lecture_tb
    ADD CONSTRAINT lecture_tb_dept_no_fkey FOREIGN KEY (dept_no) REFERENCES public.depart_tb(dept_no);


--
-- Name: notice_tb notice_tb_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.notice_tb
    ADD CONSTRAINT notice_tb_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.user_tb(user_no);


--
-- Name: notification_tb notification_tb_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.notification_tb
    ADD CONSTRAINT notification_tb_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_tb(user_no) ON DELETE CASCADE;


--
-- Name: overenroll_tb overenroll_tb_lecture_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.overenroll_tb
    ADD CONSTRAINT overenroll_tb_lecture_id_fkey FOREIGN KEY (lecture_id) REFERENCES public.lecture_tb(lecture_id) ON DELETE CASCADE;


--
-- Name: overenroll_tb overenroll_tb_sche_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.overenroll_tb
    ADD CONSTRAINT overenroll_tb_sche_no_fkey FOREIGN KEY (sche_no) REFERENCES public.schedule_tb(sche_no) ON DELETE SET NULL;


--
-- Name: overenroll_tb overenroll_tb_user_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.overenroll_tb
    ADD CONSTRAINT overenroll_tb_user_no_fkey FOREIGN KEY (user_no) REFERENCES public.user_tb(user_no) ON DELETE CASCADE;


--
-- Name: schedule_tb schedule_tb_lecture_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.schedule_tb
    ADD CONSTRAINT schedule_tb_lecture_id_fkey FOREIGN KEY (lecture_id) REFERENCES public.lecture_tb(lecture_id) ON DELETE CASCADE;


--
-- Name: user_tb user_tb_dept_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.user_tb
    ADD CONSTRAINT user_tb_dept_no_fkey FOREIGN KEY (dept_no) REFERENCES public.depart_tb(dept_no) ON DELETE SET NULL;


--
-- Name: waitlist_tb waitlist_tb_lecture_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.waitlist_tb
    ADD CONSTRAINT waitlist_tb_lecture_id_fkey FOREIGN KEY (lecture_id) REFERENCES public.lecture_tb(lecture_id) ON DELETE CASCADE;


--
-- Name: waitlist_tb waitlist_tb_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mugang
--

ALTER TABLE ONLY public.waitlist_tb
    ADD CONSTRAINT waitlist_tb_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_tb(user_no) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict BCZq77E4xKLKm1sqtSLi0Yqof9PU0YetdXN2iQdzXtcCy6jUv4hDgwK7b4n9s0O


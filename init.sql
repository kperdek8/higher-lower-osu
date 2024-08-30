--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

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
-- Name: beatmapsets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.beatmapsets (
    id integer NOT NULL,
    title character varying(255),
    artist character varying(255),
    creator character varying(255),
    favourite_count integer,
    play_count integer,
    ranked integer,
    ranked_date timestamp(0) without time zone,
    modes character varying(255)[],
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.beatmapsets OWNER TO postgres;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Data for Name: beatmapsets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.beatmapsets (id, title, artist, creator, favourite_count, play_count, ranked, ranked_date, modes, inserted_at, updated_at) FROM stdin;
128931	Tower Of Heaven (You Are Slaves)	Feint	eLy	15266	33127394	1	2016-02-10 16:41:29	{osu}	2024-08-29 11:42:10	2024-08-29 12:24:06
210937	aLIEz (TV size)	SawanoHiroyuki[nZk]:mizuki	xxdeathx	2560	6411280	1	2014-10-26 21:40:47	{osu}	2024-08-29 11:36:07	2024-08-29 12:29:46
277481	To The Terminus	Foreground Eclipse	Giralda	652	1863297	1	2015-08-16 13:20:14	{osu}	2024-08-29 11:38:09	2024-08-29 12:22:08
366440	MONSTER	Reol	handsome	6546	18842980	1	2015-12-25 22:01:51	{osu}	2024-08-29 11:41:13	2024-08-29 12:24:05
831738	Resurrection	Seraph	Atalanta	526	493560	1	2020-02-21 10:44:55	{osu}	2024-08-29 12:55:36	2024-08-29 12:55:36
891366	Illusion of Inflict	HyuN	schoolboy	3129	8411058	1	2018-12-28 12:00:14	{osu}	2024-08-29 12:57:39	2024-08-29 12:57:39
1112873	image _____	MEMAI SIREN	Foxy Grandpa	263	108382	1	2023-01-13 13:45:29	{osu}	2024-08-28 23:08:20	2024-08-29 13:13:52
1218852	Yoru ni Kakeru	YOASOBI	CoLouRed GlaZeE	23352	23662112	1	2020-09-07 01:44:18	{osu}	2024-08-29 13:08:45	2024-08-29 13:08:49
320905	Max Burning!!	BlackY	SpectorDG	391	1037259	1	2015-12-05 00:00:48	{taiko,mania}	2024-08-29 11:39:15	2024-08-29 12:22:09
356147	Dr. Wily`'`s Castle: Stage 1	BOSSFIGHT	WildOne94	312	685827	1	2015-12-01 18:20:13	{fruits}	2024-08-29 11:41:09	2024-08-29 12:23:05
373414	Spider Dance	toby fox	OzzyOzrock	884	738592	1	2016-02-29 10:40:20	{taiko}	2024-08-29 11:41:14	2024-08-29 12:23:09
458825	Day after	FELT	BennyBananas	60	20826	1	2016-10-13 23:20:03	{fruits}	2024-08-29 11:44:14	2024-08-29 12:26:10
502553	Inferno	9mm Parabellum Bullet	- Magic Bomb -	232	1009809	1	2017-03-11 19:00:42	{fruits}	2024-08-29 12:44:27	2024-08-29 12:44:35
531425	Re:End of a Dream	uma vs. Morimori Atsushi	Critical_Star	890	1400647	1	2017-01-14 02:00:44	{mania}	2024-08-29 12:45:28	2024-08-29 12:45:32
538881	Youkai no Yama ~ Mysterious Mountain	Demetori	Deif	36	38042	1	2017-06-21 01:40:05	{fruits,taiko}	2024-08-29 12:45:32	2024-08-29 12:45:32
653740	WHITEOUT	Kaneko Chiharu	Tofu1222	666	1428183	1	2017-12-22 21:20:36	{mania}	2024-08-29 12:49:34	2024-08-29 12:51:33
873024	Jishou Mushoku	Hanatan	chickenbible	47	67140	1	2019-03-25 03:20:02	{fruits}	2024-08-29 12:56:41	2024-08-29 12:59:37
931741	Quaoar	Camellia	Nepuri	159	1247715	1	2019-06-09 12:00:02	{taiko}	2024-08-29 12:58:43	2024-08-29 13:00:38
968232	Lunatic set 15 ~ The Moon as Seen from the Shrine	Rin	MBomb	293	1038699	1	2019-09-05 22:40:01	{fruits}	2024-08-29 13:00:38	2024-08-29 13:00:39
1023681	The Ruin of Mankind	Inferi	Rhytoly	40	244476	1	2019-10-07 23:21:25	{taiko}	2024-08-29 13:02:38	2024-08-29 13:02:44
1131640	Disorder	HyuN feat. YURI	FAMoss	542	441049	1	2021-02-20 15:22:45	{mania}	2024-08-29 13:05:46	2024-08-29 13:07:43
1140163	Nhelv	Silentroom	Leniane	726	678330	1	2020-07-14 21:44:58	{mania}	2024-08-29 13:06:41	2024-08-29 13:06:44
1179815	Tempestissimo	t+pazolite	Kuo Kyoka	2118	1539920	1	2021-01-14 18:25:21	{mania,taiko}	2024-08-29 13:07:43	2024-08-29 13:09:43
1702342	XENOViA	BlackY	Shima Rin	124	104374	1	2022-07-27 03:44:54	{mania,taiko}	2024-08-29 13:24:55	2024-08-29 14:03:10
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
\.


--
-- Name: beatmapsets beatmapsets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beatmapsets
    ADD CONSTRAINT beatmapsets_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: beatmapsets_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX beatmapsets_id_index ON public.beatmapsets USING btree (id);


--
-- PostgreSQL database dump complete
--


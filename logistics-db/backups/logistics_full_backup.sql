--
-- PostgreSQL database dump
--

\restrict 2ilsRMVp6WTvrOQWsgArrJRhbQh6d4KMMW9rcGR3gGXNS1i5MG7Pz2i9Wl7eihS

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11

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
-- Name: seq_номер_груза; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."seq_номер_груза"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."seq_номер_груза" OWNER TO logistics_admin;

--
-- Name: seq_номер_платежа; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."seq_номер_платежа"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."seq_номер_платежа" OWNER TO logistics_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: водители; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."водители" (
    "ид_водитель" integer NOT NULL,
    "фамилия" character varying(50) NOT NULL,
    "имя" character varying(50) NOT NULL,
    "отчество" character varying(50),
    "номер_прав" character varying(20) NOT NULL,
    "категория_прав" character varying(10),
    "дата_рождения" date,
    "телефон" character varying(20),
    "адрес_проживания" text,
    "дата_найма" date NOT NULL,
    "статус" character varying(20) DEFAULT 'активный'::character varying,
    "стаж_лет" integer,
    "рейтинг" numeric(3,2),
    CONSTRAINT "chk_рейтинг" CHECK ((("рейтинг" >= (0)::numeric) AND ("рейтинг" <= (5)::numeric))),
    CONSTRAINT "chk_стаж" CHECK (("стаж_лет" >= 0))
);


ALTER TABLE public."водители" OWNER TO logistics_admin;

--
-- Name: TABLE "водители"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."водители" IS 'Персонал компании - водители транспортных средств';


--
-- Name: водители_ид_водитель_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."водители_ид_водитель_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."водители_ид_водитель_seq" OWNER TO logistics_admin;

--
-- Name: водители_ид_водитель_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."водители_ид_водитель_seq" OWNED BY public."водители"."ид_водитель";


--
-- Name: города; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."города" (
    "ид_город" integer NOT NULL,
    "название" character varying(100) NOT NULL,
    "регион" character varying(100),
    "координаты_широта" numeric(11,8),
    "координаты_долгота" numeric(11,8),
    "население" integer,
    "часовой_пояс" character varying(10)
);


ALTER TABLE public."города" OWNER TO logistics_admin;

--
-- Name: TABLE "города"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."города" IS 'Справочник городов присутствия компании';


--
-- Name: города_ид_город_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."города_ид_город_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."города_ид_город_seq" OWNER TO logistics_admin;

--
-- Name: города_ид_город_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."города_ид_город_seq" OWNED BY public."города"."ид_город";


--
-- Name: груз_и_маршруты; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."груз_и_маршруты" (
    "ид_груз_маршрут" integer NOT NULL,
    "ид_груз" integer NOT NULL,
    "ид_маршрут" integer NOT NULL,
    "последовательность" integer DEFAULT 1,
    "статус" character varying(20) DEFAULT 'планируется'::character varying,
    "дата_начала_маршрута" timestamp without time zone,
    "дата_окончания_маршрута" timestamp without time zone,
    "остановка_начало" integer,
    "остановка_конец" integer,
    "расстояние_по_маршруту_км" numeric(10,2),
    "примечание" text,
    CONSTRAINT "chk_гм_последовательность" CHECK (("последовательность" > 0))
);


ALTER TABLE public."груз_и_маршруты" OWNER TO logistics_admin;

--
-- Name: TABLE "груз_и_маршруты"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."груз_и_маршруты" IS '5NF: Связь ГРУЗ ↔ МАРШРУТ';


--
-- Name: груз_и_маршруты_ид_груз_маршрут_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."груз_и_маршруты_ид_груз_маршрут_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."груз_и_маршруты_ид_груз_маршрут_seq" OWNER TO logistics_admin;

--
-- Name: груз_и_маршруты_ид_груз_маршрут_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."груз_и_маршруты_ид_груз_маршрут_seq" OWNED BY public."груз_и_маршруты"."ид_груз_маршрут";


--
-- Name: груз_и_средства; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."груз_и_средства" (
    "ид_груз_средство" integer NOT NULL,
    "ид_груз" integer NOT NULL,
    "ид_средство" integer NOT NULL,
    "последовательность" integer DEFAULT 1,
    "статус" character varying(20) DEFAULT 'зарезервировано'::character varying,
    "дата_начала" timestamp without time zone,
    "дата_окончания" timestamp without time zone,
    "пройдено_км" numeric(10,2),
    "время_в_пути_часов" numeric(8,2),
    "стоимость_доставки_руб" numeric(12,2),
    "примечание" text,
    "расход_топлива_л" numeric(10,2),
    CONSTRAINT "chk_последовательность" CHECK (("последовательность" > 0)),
    CONSTRAINT "chk_пройдено" CHECK (("пройдено_км" >= (0)::numeric))
);


ALTER TABLE public."груз_и_средства" OWNER TO logistics_admin;

--
-- Name: TABLE "груз_и_средства"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."груз_и_средства" IS '5NF: Связь ГРУЗ ↔ ТРАНСПОРТНОЕ_СРЕДСТВО';


--
-- Name: груз_и_средства_ид_груз_средство_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."груз_и_средства_ид_груз_средство_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."груз_и_средства_ид_груз_средство_seq" OWNER TO logistics_admin;

--
-- Name: груз_и_средства_ид_груз_средство_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."груз_и_средства_ид_груз_средство_seq" OWNED BY public."груз_и_средства"."ид_груз_средство";


--
-- Name: грузы; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."грузы" (
    "ид_груз" integer NOT NULL,
    "номер_груза" character varying(50) NOT NULL,
    "описание" text,
    "вес_кг" numeric(12,2) NOT NULL,
    "объем_куб_м" numeric(12,2),
    "ид_клиент" integer NOT NULL,
    "ид_склад_откуда" integer NOT NULL,
    "ид_склад_куда" integer NOT NULL,
    "ид_статус" integer DEFAULT 1,
    "стоимость_руб" numeric(12,2),
    "стоимость_доставки_руб" numeric(12,2),
    "дата_создания" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "дата_должна_прибыть" date,
    "дата_фактическая_доставка" timestamp without time zone,
    "примечание" text,
    "страховка_руб" numeric(12,2),
    "хрупкий" boolean DEFAULT false,
    "температурный_режим" character varying(50),
    CONSTRAINT "chk_вес" CHECK (("вес_кг" > (0)::numeric)),
    CONSTRAINT "chk_склады_разные" CHECK (("ид_склад_откуда" <> "ид_склад_куда")),
    CONSTRAINT "chk_стоимость" CHECK (("стоимость_руб" >= (0)::numeric))
);


ALTER TABLE public."грузы" OWNER TO logistics_admin;

--
-- Name: TABLE "грузы"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."грузы" IS 'Основная таблица грузов компании';


--
-- Name: грузы_ид_груз_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."грузы_ид_груз_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."грузы_ид_груз_seq" OWNER TO logistics_admin;

--
-- Name: грузы_ид_груз_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."грузы_ид_груз_seq" OWNED BY public."грузы"."ид_груз";


--
-- Name: история_статусов; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."история_статусов" (
    "ид_история" integer NOT NULL,
    "ид_груз" integer NOT NULL,
    "ид_статус_старый" integer,
    "ид_статус_новый" integer NOT NULL,
    "дата_изменения" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "комментарий" text,
    "ид_пользователь" character varying(100)
);


ALTER TABLE public."история_статусов" OWNER TO logistics_admin;

--
-- Name: TABLE "история_статусов"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."история_статусов" IS 'Аудит изменений статусов грузов';


--
-- Name: история_статусов_ид_история_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."история_статусов_ид_история_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."история_статусов_ид_история_seq" OWNER TO logistics_admin;

--
-- Name: история_статусов_ид_история_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."история_статусов_ид_история_seq" OWNED BY public."история_статусов"."ид_история";


--
-- Name: клиенты; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."клиенты" (
    "ид_клиент" integer NOT NULL,
    "название" character varying(200) NOT NULL,
    "тип_клиента" character varying(50),
    "контактный_телефон" character varying(20),
    "электронная_почта" character varying(100),
    "адрес_регистрации" text,
    "инн" character varying(12),
    "кпп" character varying(9),
    "дата_создания" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "статус" character varying(20) DEFAULT 'активный'::character varying
);


ALTER TABLE public."клиенты" OWNER TO logistics_admin;

--
-- Name: TABLE "клиенты"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."клиенты" IS 'Клиенты компании (юридические и физические лица)';


--
-- Name: клиенты_ид_клиент_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."клиенты_ид_клиент_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."клиенты_ид_клиент_seq" OWNER TO logistics_admin;

--
-- Name: клиенты_ид_клиент_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."клиенты_ид_клиент_seq" OWNED BY public."клиенты"."ид_клиент";


--
-- Name: маршруты; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."маршруты" (
    "ид_маршрут" integer NOT NULL,
    "код_маршрута" character varying(50) NOT NULL,
    "наименование" character varying(100) NOT NULL,
    "описание" text,
    "общее_расстояние_км" numeric(10,2) NOT NULL,
    "ожидаемое_время_часов" numeric(8,2),
    "статус" character varying(20) DEFAULT 'активный'::character varying,
    "тип_маршрута" character varying(50),
    "дата_создания" date DEFAULT CURRENT_DATE,
    "стоимость_за_км_руб" numeric(10,2),
    "приоритет" integer DEFAULT 0,
    CONSTRAINT "chk_время" CHECK (("ожидаемое_время_часов" > (0)::numeric)),
    CONSTRAINT "chk_расстояние" CHECK (("общее_расстояние_км" > (0)::numeric))
);


ALTER TABLE public."маршруты" OWNER TO logistics_admin;

--
-- Name: TABLE "маршруты"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."маршруты" IS 'Маршруты доставки между городами';


--
-- Name: маршруты_ид_маршрут_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."маршруты_ид_маршрут_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."маршруты_ид_маршрут_seq" OWNER TO logistics_admin;

--
-- Name: маршруты_ид_маршрут_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."маршруты_ид_маршрут_seq" OWNED BY public."маршруты"."ид_маршрут";


--
-- Name: остановки_маршрута; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."остановки_маршрута" (
    "ид_остановка" integer NOT NULL,
    "ид_маршрут" integer NOT NULL,
    "порядковый_номер" integer NOT NULL,
    "ид_город" integer NOT NULL,
    "расстояние_от_предыдущей_км" numeric(10,2),
    "ожидаемое_время_прибытия_часов" numeric(8,2),
    "ожидаемое_время_отправки_часов" numeric(8,2),
    "время_простоя_минут" integer DEFAULT 30,
    "тип_остановки" character varying(50),
    "дата_создания" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "chk_порядковый_номер" CHECK (("порядковый_номер" > 0)),
    CONSTRAINT "chk_расст_остановки" CHECK (("расстояние_от_предыдущей_км" >= (0)::numeric))
);


ALTER TABLE public."остановки_маршрута" OWNER TO logistics_admin;

--
-- Name: TABLE "остановки_маршрута"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."остановки_маршрута" IS 'Промежуточные и конечные точки маршрутов';


--
-- Name: остановки_маршрута_ид_остановка_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."остановки_маршрута_ид_остановка_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."остановки_маршрута_ид_остановка_seq" OWNER TO logistics_admin;

--
-- Name: остановки_маршрута_ид_остановка_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."остановки_маршрута_ид_остановка_seq" OWNED BY public."остановки_маршрута"."ид_остановка";


--
-- Name: платежи; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."платежи" (
    "ид_платеж" integer NOT NULL,
    "номер_платежа" character varying(50) NOT NULL,
    "ид_клиент" integer NOT NULL,
    "ид_груз" integer,
    "сумма_руб" numeric(12,2) NOT NULL,
    "тип_платежа" character varying(50),
    "статус_платежа" character varying(50) DEFAULT 'ожидает'::character varying,
    "дата_создания" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "дата_оплаты" timestamp without time zone,
    "способ_оплаты" character varying(50),
    "примечание" text,
    CONSTRAINT "chk_сумма" CHECK (("сумма_руб" > (0)::numeric))
);


ALTER TABLE public."платежи" OWNER TO logistics_admin;

--
-- Name: TABLE "платежи"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."платежи" IS 'Финансовые операции по доставкам';


--
-- Name: платежи_ид_платеж_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."платежи_ид_платеж_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."платежи_ид_платеж_seq" OWNER TO logistics_admin;

--
-- Name: платежи_ид_платеж_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."платежи_ид_платеж_seq" OWNED BY public."платежи"."ид_платеж";


--
-- Name: расходы_топлива; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."расходы_топлива" (
    "ид_расход" integer NOT NULL,
    "ид_средство" integer NOT NULL,
    "дата_заправки" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "объем_л" numeric(10,2) NOT NULL,
    "стоимость_руб" numeric(10,2) NOT NULL,
    "тип_топлива" character varying(50),
    "пробег_на_момент_заправки" integer,
    "станция_заправки" character varying(200),
    CONSTRAINT "chk_объем" CHECK (("объем_л" > (0)::numeric)),
    CONSTRAINT "chk_стоимость_топлива" CHECK (("стоимость_руб" > (0)::numeric))
);


ALTER TABLE public."расходы_топлива" OWNER TO logistics_admin;

--
-- Name: TABLE "расходы_топлива"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."расходы_топлива" IS 'Учет расходов на топливо';


--
-- Name: расходы_топлива_ид_расход_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."расходы_топлива_ид_расход_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."расходы_топлива_ид_расход_seq" OWNER TO logistics_admin;

--
-- Name: расходы_топлива_ид_расход_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."расходы_топлива_ид_расход_seq" OWNED BY public."расходы_топлива"."ид_расход";


--
-- Name: склады; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."склады" (
    "ид_склад" integer NOT NULL,
    "название" character varying(150) NOT NULL,
    "ид_город" integer NOT NULL,
    "адрес_полный" text,
    "площадь_кв_м" numeric(12,2),
    "координаты_широта" numeric(10,8),
    "координаты_долгота" numeric(10,8),
    "телефон" character varying(20),
    "руководитель_фио" character varying(100),
    "дата_открытия" date,
    "вместимость_куб_м" numeric(12,2),
    "статус" character varying(20) DEFAULT 'работает'::character varying
);


ALTER TABLE public."склады" OWNER TO logistics_admin;

--
-- Name: TABLE "склады"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."склады" IS 'Складские помещения компании';


--
-- Name: склады_ид_склад_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."склады_ид_склад_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."склады_ид_склад_seq" OWNER TO logistics_admin;

--
-- Name: склады_ид_склад_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."склады_ид_склад_seq" OWNED BY public."склады"."ид_склад";


--
-- Name: средство_и_маршруты; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."средство_и_маршруты" (
    "ид_средство_маршрут" integer NOT NULL,
    "ид_средство" integer NOT NULL,
    "ид_маршрут" integer NOT NULL,
    "приоритет" integer DEFAULT 0,
    "статус" character varying(20) DEFAULT 'активный'::character varying,
    "дата_начала_обслуживания" date,
    "дата_конца_обслуживания" date,
    "количество_рейсов" integer DEFAULT 0,
    "средняя_скорость_км_ч" numeric(6,2),
    "общий_пробег_км" numeric(12,2),
    CONSTRAINT "chk_рейсов" CHECK (("количество_рейсов" >= 0))
);


ALTER TABLE public."средство_и_маршруты" OWNER TO logistics_admin;

--
-- Name: TABLE "средство_и_маршруты"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."средство_и_маршруты" IS '5NF: Связь ТРАНСПОРТНОЕ_СРЕДСТВО ↔ МАРШРУТ';


--
-- Name: средство_и_марш_ид_средство_мар_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."средство_и_марш_ид_средство_мар_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."средство_и_марш_ид_средство_мар_seq" OWNER TO logistics_admin;

--
-- Name: средство_и_марш_ид_средство_мар_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."средство_и_марш_ид_средство_мар_seq" OWNED BY public."средство_и_маршруты"."ид_средство_маршрут";


--
-- Name: статусы_заказов; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."статусы_заказов" (
    "ид_статус" integer NOT NULL,
    "код_статуса" character varying(50) NOT NULL,
    "наименование" character varying(100) NOT NULL,
    "описание" text,
    "цвет_индикатора" character varying(7),
    "порядок_сортировки" integer
);


ALTER TABLE public."статусы_заказов" OWNER TO logistics_admin;

--
-- Name: TABLE "статусы_заказов"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."статусы_заказов" IS 'Справочник статусов жизненного цикла груза';


--
-- Name: статусы_заказов_ид_статус_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."статусы_заказов_ид_статус_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."статусы_заказов_ид_статус_seq" OWNER TO logistics_admin;

--
-- Name: статусы_заказов_ид_статус_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."статусы_заказов_ид_статус_seq" OWNED BY public."статусы_заказов"."ид_статус";


--
-- Name: техническое_обслуживание; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."техническое_обслуживание" (
    "ид_то" integer NOT NULL,
    "ид_средство" integer NOT NULL,
    "дата_начала" timestamp without time zone NOT NULL,
    "дата_окончания" timestamp without time zone,
    "тип_обслуживания" character varying(100),
    "описание_работ" text,
    "стоимость_руб" numeric(12,2),
    "исполнитель" character varying(200),
    "статус" character varying(50) DEFAULT 'запланировано'::character varying
);


ALTER TABLE public."техническое_обслуживание" OWNER TO logistics_admin;

--
-- Name: TABLE "техническое_обслуживание"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."техническое_обслуживание" IS 'Учет технического обслуживания транспорта';


--
-- Name: техническое_обслуживание_ид_то_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."техническое_обслуживание_ид_то_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."техническое_обслуживание_ид_то_seq" OWNER TO logistics_admin;

--
-- Name: техническое_обслуживание_ид_то_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."техническое_обслуживание_ид_то_seq" OWNED BY public."техническое_обслуживание"."ид_то";


--
-- Name: типы_средств_доставки; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."типы_средств_доставки" (
    "ид_тип_средства" integer NOT NULL,
    "наименование" character varying(100) NOT NULL,
    "грузоподъемность_кг" numeric(10,2),
    "объем_куб_м" numeric(10,2),
    "топливо_тип" character varying(50),
    "дата_создания" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public."типы_средств_доставки" OWNER TO logistics_admin;

--
-- Name: TABLE "типы_средств_доставки"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."типы_средств_доставки" IS 'Справочник типов транспортных средств';


--
-- Name: COLUMN "типы_средств_доставки"."грузоподъемность_кг"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON COLUMN public."типы_средств_доставки"."грузоподъемность_кг" IS 'Максимальная грузоподъемность в кг';


--
-- Name: COLUMN "типы_средств_доставки"."объем_куб_м"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON COLUMN public."типы_средств_доставки"."объем_куб_м" IS 'Объем кузова в кубических метрах';


--
-- Name: типы_средств_дос_ид_тип_средства_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."типы_средств_дос_ид_тип_средства_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."типы_средств_дос_ид_тип_средства_seq" OWNER TO logistics_admin;

--
-- Name: типы_средств_дос_ид_тип_средства_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."типы_средств_дос_ид_тип_средства_seq" OWNED BY public."типы_средств_доставки"."ид_тип_средства";


--
-- Name: транспортные_средства; Type: TABLE; Schema: public; Owner: logistics_admin
--

CREATE TABLE public."транспортные_средства" (
    "ид_средство" integer NOT NULL,
    "госномер" character varying(20) NOT NULL,
    "ид_тип_средства" integer NOT NULL,
    "ид_водитель" integer,
    "год_выпуска" integer,
    "марка" character varying(50),
    "модель" character varying(50),
    "цвет" character varying(30),
    "состояние" character varying(20) DEFAULT 'исправен'::character varying,
    "дата_последнего_то" date,
    "статус" character varying(20) DEFAULT 'свободно'::character varying,
    "дата_регистрации" date DEFAULT CURRENT_DATE,
    "страховка_до" date,
    "пробег_км" integer DEFAULT 0,
    "расход_топлива_л_100км" numeric(5,2),
    "стоимость_руб" numeric(12,2),
    CONSTRAINT "chk_год" CHECK ((("год_выпуска" >= 1900) AND (("год_выпуска")::numeric <= EXTRACT(year FROM CURRENT_DATE)))),
    CONSTRAINT "chk_пробег" CHECK (("пробег_км" >= 0))
);


ALTER TABLE public."транспортные_средства" OWNER TO logistics_admin;

--
-- Name: TABLE "транспортные_средства"; Type: COMMENT; Schema: public; Owner: logistics_admin
--

COMMENT ON TABLE public."транспортные_средства" IS 'Автопарк транспортной компании';


--
-- Name: транспортные_средст_ид_средство_seq; Type: SEQUENCE; Schema: public; Owner: logistics_admin
--

CREATE SEQUENCE public."транспортные_средст_ид_средство_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."транспортные_средст_ид_средство_seq" OWNER TO logistics_admin;

--
-- Name: транспортные_средст_ид_средство_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: logistics_admin
--

ALTER SEQUENCE public."транспортные_средст_ид_средство_seq" OWNED BY public."транспортные_средства"."ид_средство";


--
-- Name: водители ид_водитель; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."водители" ALTER COLUMN "ид_водитель" SET DEFAULT nextval('public."водители_ид_водитель_seq"'::regclass);


--
-- Name: города ид_город; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."города" ALTER COLUMN "ид_город" SET DEFAULT nextval('public."города_ид_город_seq"'::regclass);


--
-- Name: груз_и_маршруты ид_груз_маршрут; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."груз_и_маршруты" ALTER COLUMN "ид_груз_маршрут" SET DEFAULT nextval('public."груз_и_маршруты_ид_груз_маршрут_seq"'::regclass);


--
-- Name: груз_и_средства ид_груз_средство; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."груз_и_средства" ALTER COLUMN "ид_груз_средство" SET DEFAULT nextval('public."груз_и_средства_ид_груз_средство_seq"'::regclass);


--
-- Name: грузы ид_груз; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."грузы" ALTER COLUMN "ид_груз" SET DEFAULT nextval('public."грузы_ид_груз_seq"'::regclass);


--
-- Name: история_статусов ид_история; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."история_статусов" ALTER COLUMN "ид_история" SET DEFAULT nextval('public."история_статусов_ид_история_seq"'::regclass);


--
-- Name: клиенты ид_клиент; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."клиенты" ALTER COLUMN "ид_клиент" SET DEFAULT nextval('public."клиенты_ид_клиент_seq"'::regclass);


--
-- Name: маршруты ид_маршрут; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."маршруты" ALTER COLUMN "ид_маршрут" SET DEFAULT nextval('public."маршруты_ид_маршрут_seq"'::regclass);


--
-- Name: остановки_маршрута ид_остановка; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."остановки_маршрута" ALTER COLUMN "ид_остановка" SET DEFAULT nextval('public."остановки_маршрута_ид_остановка_seq"'::regclass);


--
-- Name: платежи ид_платеж; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."платежи" ALTER COLUMN "ид_платеж" SET DEFAULT nextval('public."платежи_ид_платеж_seq"'::regclass);


--
-- Name: расходы_топлива ид_расход; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."расходы_топлива" ALTER COLUMN "ид_расход" SET DEFAULT nextval('public."расходы_топлива_ид_расход_seq"'::regclass);


--
-- Name: склады ид_склад; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."склады" ALTER COLUMN "ид_склад" SET DEFAULT nextval('public."склады_ид_склад_seq"'::regclass);


--
-- Name: средство_и_маршруты ид_средство_маршрут; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."средство_и_маршруты" ALTER COLUMN "ид_средство_маршрут" SET DEFAULT nextval('public."средство_и_марш_ид_средство_мар_seq"'::regclass);


--
-- Name: статусы_заказов ид_статус; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."статусы_заказов" ALTER COLUMN "ид_статус" SET DEFAULT nextval('public."статусы_заказов_ид_статус_seq"'::regclass);


--
-- Name: техническое_обслуживание ид_то; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."техническое_обслуживание" ALTER COLUMN "ид_то" SET DEFAULT nextval('public."техническое_обслуживание_ид_то_seq"'::regclass);


--
-- Name: типы_средств_доставки ид_тип_средства; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."типы_средств_доставки" ALTER COLUMN "ид_тип_средства" SET DEFAULT nextval('public."типы_средств_дос_ид_тип_средства_seq"'::regclass);


--
-- Name: транспортные_средства ид_средство; Type: DEFAULT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."транспортные_средства" ALTER COLUMN "ид_средство" SET DEFAULT nextval('public."транспортные_средст_ид_средство_seq"'::regclass);


--
-- Data for Name: водители; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."водители" ("ид_водитель", "фамилия", "имя", "отчество", "номер_прав", "категория_прав", "дата_рождения", "телефон", "адрес_проживания", "дата_найма", "статус", "стаж_лет", "рейтинг") FROM stdin;
32	Иванов	Петр	Сергеевич	77АА123456	C,E	1985-03-15	+79501234567	\N	2020-01-15	активный	12	4.80
33	Сидоров	Алексей	Викторович	77ВВ789012	B,C	1990-07-22	+79502234567	\N	2021-06-01	активный	8	4.50
34	Петров	Дмитрий	Олегович	78АБ345678	C,E	1982-11-08	+79503234567	\N	2019-03-20	активный	15	4.90
35	Козлов	Игорь	Михайлович	54СМ901234	C,E	1988-05-12	+79504234567	\N	2020-09-10	активный	10	4.70
36	Новиков	Сергей	Александрович	66КН567890	B,C,E	1983-02-28	+79505234567	\N	2018-11-15	активный	14	4.90
37	Морозов	Андрей	Петрович	16КА234567	C,E	1986-09-05	+79506234567	\N	2020-04-22	активный	11	4.60
38	Волков	Владимир	Сергеевич	52НН890123	B,C	1992-12-18	+79507234567	\N	2022-01-10	активный	6	4.40
39	Соколов	Олег	Викторович	74ЧЛ456789	C,E	1984-06-30	+79508234567	\N	2019-07-05	активный	13	4.80
40	Лебедев	Максим	Дмитриевич	63СР012345	C,E	1987-01-14	+79509234567	\N	2020-10-12	активный	12	4.70
41	Кузнецов	Роман	Андреевич	55ОМ678901	B,C,E	1989-08-25	+79510234567	\N	2021-02-28	активный	9	4.50
42	Попов	Евгений	Сергеевич	61РД234567	C,E	1981-04-17	+79511234567	\N	2018-05-15	активный	16	4.90
43	Васильев	Николай	Петрович	02УФ890123	C,E	1985-10-09	+79512234567	\N	2019-12-20	активный	13	4.80
44	Федоров	Александр	Викторович	24КР456789	B,C	1991-03-22	+79513234567	\N	2021-08-05	активный	7	4.40
45	Михайлов	Виктор	Олегович	36ВР012345	C,E	1986-07-11	+79514234567	\N	2020-03-18	активный	11	4.70
46	Алексеев	Константин	Дмитриевич	59ПМ678901	C,E	1983-11-28	+79515234567	\N	2019-09-25	активный	14	4.80
47	Семенов	Валерий	Андреевич	34ВЛ234567	B,C,E	1988-02-14	+79516234567	\N	2020-11-30	активный	10	4.60
48	Богданов	Артем	Сергеевич	23КД890123	C,E	1990-06-05	+79517234567	\N	2021-04-12	активный	8	4.50
49	Григорьев	Павел	Викторович	64СТ456789	C,E	1984-12-20	+79518234567	\N	2019-02-08	активный	13	4.80
50	Степанов	Юрий	Петрович	72ТМ012345	B,C	1987-05-16	+79519234567	\N	2020-07-22	активный	11	4.60
51	Николаев	Денис	Олегович	63ТЛ678901	C,E	1989-09-03	+79520234567	\N	2021-01-15	активный	9	4.50
52	Захаров	Станислав	Дмитриевич	18ИЖ234567	C,E	1985-01-27	+79521234567	\N	2019-10-10	активный	12	4.70
53	Романов	Геннадий	Андреевич	22БР890123	B,C,E	1982-08-08	+79522234567	\N	2018-06-15	активный	15	4.90
54	Егоров	Тимофей	Сергеевич	38ИР456789	C,E	1986-04-12	+79523234567	\N	2020-02-20	активный	11	4.70
55	Павлов	Борис	Викторович	27ХБ012345	C,E	1988-10-30	+79524234567	\N	2020-12-05	активный	10	4.60
56	Макаров	Илья	Петрович	25ВЛ678901	B,C	1991-02-18	+79525234567	\N	2022-03-10	активный	6	4.40
57	Гусев	Вадим	Олегович	70ТМ234567	C,E	1984-07-25	+79526234567	\N	2019-05-28	активный	13	4.80
58	Тихонов	Леонид	Дмитриевич	77МС890123	C,E	1987-11-14	+79527234567	\N	2020-08-15	активный	11	4.70
59	Крылов	Кирилл	Андреевич	78СП456789	B,C,E	1983-03-09	+79528234567	\N	2018-12-20	активный	14	4.90
60	Сергеев	Владислав	Сергеевич	54НС012345	C,E	1989-06-22	+79529234567	\N	2021-05-18	активный	8	4.50
61	Белов	Руслан	Викторович	66ЕК678901	C,E	1985-12-07	+79530234567	\N	2019-08-25	активный	12	4.80
\.


--
-- Data for Name: города; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."города" ("ид_город", "название", "регион", "координаты_широта", "координаты_долгота", "население", "часовой_пояс") FROM stdin;
1	Москва	Центральный	55.75580000	37.61730000	12600000	UTC+3
2	Санкт-Петербург	Северо-Западный	59.93430000	30.33510000	5400000	UTC+3
3	Новосибирск	Сибирский	55.00840000	82.93570000	1620000	UTC+7
4	Екатеринбург	Уральский	56.83890000	60.60570000	1500000	UTC+5
5	Казань	Приволжский	55.83040000	49.06610000	1260000	UTC+3
6	Нижний Новгород	Приволжский	56.29650000	43.93610000	1250000	UTC+3
7	Челябинск	Уральский	55.16440000	61.43680000	1200000	UTC+5
8	Самара	Приволжский	53.19520000	50.10690000	1156000	UTC+4
9	Омск	Сибирский	54.98850000	73.32420000	1150000	UTC+6
10	Ростов-на-Дону	Южный	47.23570000	39.70150000	1140000	UTC+3
11	Уфа	Приволжский	54.73880000	55.97210000	1130000	UTC+5
12	Красноярск	Сибирский	56.01530000	92.89320000	1100000	UTC+7
13	Воронеж	Центральный	51.66050000	39.20050000	1050000	UTC+3
14	Пермь	Приволжский	58.01050000	56.25020000	1050000	UTC+5
15	Волгоград	Южный	48.70800000	44.51330000	1010000	UTC+3
16	Краснодар	Южный	45.03550000	38.97530000	950000	UTC+3
17	Саратов	Приволжский	51.59240000	46.03480000	840000	UTC+4
18	Тюмень	Уральский	57.15220000	65.52720000	816000	UTC+5
19	Тольятти	Приволжский	53.53030000	49.34610000	700000	UTC+4
20	Ижевск	Приволжский	56.84980000	53.20450000	648000	UTC+4
21	Барнаул	Сибирский	53.34810000	83.77980000	630000	UTC+7
22	Иркутск	Сибирский	52.28690000	104.30500000	623000	UTC+8
23	Хабаровск	Дальневосточный	48.48270000	135.08380000	617000	UTC+10
24	Владивосток	Дальневосточный	43.10560000	131.87350000	606000	UTC+10
25	Томск	Сибирский	56.49770000	84.97440000	575000	UTC+7
\.


--
-- Data for Name: груз_и_маршруты; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."груз_и_маршруты" ("ид_груз_маршрут", "ид_груз", "ид_маршрут", "последовательность", "статус", "дата_начала_маршрута", "дата_окончания_маршрута", "остановка_начало", "остановка_конец", "расстояние_по_маршруту_км", "примечание") FROM stdin;
1	1	39	1	в_пути	2025-08-27 00:00:00	\N	1	3	322.00	\N
2	2	28	1	в_пути	2025-11-10 00:00:00	\N	1	6	760.00	\N
3	3	9	1	в_пути	2025-11-24 00:00:00	\N	1	2	189.00	\N
4	4	34	1	завершен	2025-10-26 00:00:00	2025-10-29 00:00:00	3	4	1017.00	\N
5	5	13	1	завершен	2025-09-16 00:00:00	2025-10-06 00:00:00	4	7	660.00	\N
6	6	11	3	отменен	2025-11-20 00:00:00	\N	2	3	178.00	\N
7	7	1	3	отменен	2025-08-08 00:00:00	\N	2	6	630.00	\N
8	8	16	1	в_пути	2026-01-17 00:00:00	\N	1	3	1337.00	\N
9	10	35	1	назначен	2025-12-30 00:00:00	\N	5	9	320.00	\N
10	11	31	3	завершен	2025-08-20 00:00:00	2025-08-23 00:00:00	2	4	907.00	\N
11	12	39	3	отменен	2025-12-08 00:00:00	\N	4	5	1058.00	\N
12	13	2	3	в_пути	2025-12-13 00:00:00	\N	4	7	1409.00	\N
13	14	18	1	отменен	2026-01-15 00:00:00	\N	4	7	278.00	\N
14	15	29	3	в_пути	2025-10-02 00:00:00	\N	3	4	1213.00	\N
15	16	8	1	завершен	2025-09-05 00:00:00	2025-09-13 00:00:00	3	7	752.00	\N
16	17	39	2	в_пути	2025-10-03 00:00:00	\N	3	6	559.00	\N
17	18	20	3	в_пути	2025-08-22 00:00:00	\N	3	6	679.00	\N
18	19	50	3	в_пути	2025-10-19 00:00:00	\N	4	7	1051.00	\N
19	21	38	1	отменен	2025-09-15 00:00:00	\N	2	6	532.00	\N
20	22	4	2	отменен	2026-01-19 00:00:00	\N	5	10	868.00	\N
21	23	12	1	завершен	2025-09-16 00:00:00	2025-09-26 00:00:00	4	9	1141.00	\N
22	24	30	2	в_пути	2025-11-16 00:00:00	\N	4	6	1055.00	\N
23	25	45	1	назначен	2025-09-13 00:00:00	\N	4	5	706.00	\N
24	26	28	2	в_пути	2025-09-28 00:00:00	\N	3	4	1254.00	\N
25	28	10	3	отменен	2025-10-08 00:00:00	\N	3	7	1012.00	\N
26	29	16	3	в_пути	2025-09-22 00:00:00	\N	1	3	1308.00	\N
27	30	16	3	завершен	2025-11-06 00:00:00	2025-11-20 00:00:00	3	4	106.00	\N
28	31	40	1	в_пути	2025-08-03 00:00:00	\N	5	10	621.00	\N
29	32	41	3	назначен	2025-07-29 00:00:00	\N	2	3	1159.00	\N
30	34	43	1	завершен	2026-01-18 00:00:00	2026-01-21 00:00:00	5	9	991.00	\N
31	35	34	2	назначен	2025-11-22 00:00:00	\N	2	4	522.00	\N
32	36	35	1	завершен	2025-07-25 00:00:00	2025-07-31 00:00:00	2	3	1258.00	\N
33	37	14	3	назначен	2025-11-14 00:00:00	\N	1	5	1464.00	\N
34	38	14	2	назначен	2025-09-04 00:00:00	\N	5	6	864.00	\N
35	39	49	3	отменен	2025-12-25 00:00:00	\N	2	7	1420.00	\N
36	40	22	3	в_пути	2025-11-10 00:00:00	\N	4	9	1024.00	\N
37	41	30	3	в_пути	2025-11-17 00:00:00	\N	3	7	1169.00	\N
38	42	42	1	назначен	2026-01-02 00:00:00	\N	5	7	1296.00	\N
39	44	21	2	завершен	2025-12-10 00:00:00	2025-12-17 00:00:00	3	6	294.00	\N
40	45	50	3	завершен	2025-10-10 00:00:00	2025-10-29 00:00:00	4	5	835.00	\N
41	46	10	1	завершен	2025-08-21 00:00:00	2025-09-04 00:00:00	1	5	960.00	\N
42	50	28	1	в_пути	2025-08-21 00:00:00	\N	5	10	1291.00	\N
43	51	48	1	отменен	2025-12-04 00:00:00	\N	3	5	895.00	\N
44	52	7	1	назначен	2025-08-18 00:00:00	\N	2	4	346.00	\N
45	53	46	2	в_пути	2025-12-09 00:00:00	\N	5	7	1455.00	\N
46	57	46	1	отменен	2025-10-16 00:00:00	\N	2	7	1384.00	\N
47	59	49	3	назначен	2025-07-31 00:00:00	\N	2	7	579.00	\N
48	60	30	3	назначен	2025-08-18 00:00:00	\N	1	3	1422.00	\N
49	63	1	1	завершен	2025-11-13 00:00:00	2025-12-02 00:00:00	5	8	894.00	\N
50	67	37	1	отменен	2025-11-06 00:00:00	\N	5	10	1006.00	\N
51	71	34	1	завершен	2025-11-21 00:00:00	2025-12-04 00:00:00	3	4	572.00	\N
52	72	30	2	завершен	2025-11-26 00:00:00	2025-12-01 00:00:00	3	6	331.00	\N
53	73	37	2	отменен	2025-12-12 00:00:00	\N	3	8	1204.00	\N
54	74	23	2	назначен	2025-11-16 00:00:00	\N	2	7	1496.00	\N
55	75	20	1	в_пути	2025-08-13 00:00:00	\N	5	10	354.00	\N
56	76	29	2	завершен	2025-12-09 00:00:00	2025-12-19 00:00:00	5	10	869.00	\N
57	77	18	3	завершен	2025-11-17 00:00:00	2025-12-04 00:00:00	3	4	245.00	\N
58	78	29	1	завершен	2025-10-07 00:00:00	2025-10-18 00:00:00	5	10	1210.00	\N
59	81	41	2	в_пути	2025-11-16 00:00:00	\N	5	10	809.00	\N
60	83	25	3	в_пути	2025-11-10 00:00:00	\N	4	5	896.00	\N
61	84	49	2	в_пути	2025-10-05 00:00:00	\N	2	7	153.00	\N
62	86	20	3	назначен	2026-01-04 00:00:00	\N	2	4	1231.00	\N
63	89	20	2	отменен	2025-09-21 00:00:00	\N	5	6	859.00	\N
64	90	22	1	назначен	2025-08-18 00:00:00	\N	5	10	1210.00	\N
65	92	41	2	отменен	2026-01-13 00:00:00	\N	5	7	1412.00	\N
66	93	33	2	в_пути	2025-10-23 00:00:00	\N	1	2	1482.00	\N
67	94	4	3	отменен	2025-08-07 00:00:00	\N	5	9	839.00	\N
68	95	42	3	отменен	2025-08-11 00:00:00	\N	5	9	758.00	\N
69	96	5	3	назначен	2025-08-29 00:00:00	\N	4	5	744.00	\N
70	97	10	3	в_пути	2025-10-18 00:00:00	\N	1	4	473.00	\N
71	98	9	3	в_пути	2025-08-30 00:00:00	\N	3	8	919.00	\N
72	99	2	1	назначен	2025-10-02 00:00:00	\N	3	6	553.00	\N
73	100	10	1	назначен	2025-09-04 00:00:00	\N	1	3	155.00	\N
74	102	14	1	в_пути	2025-10-01 00:00:00	\N	1	5	1410.00	\N
75	104	16	1	в_пути	2025-09-22 00:00:00	\N	5	8	1055.00	\N
76	106	31	1	назначен	2026-01-18 00:00:00	\N	4	9	783.00	\N
77	108	13	1	в_пути	2025-09-29 00:00:00	\N	4	7	563.00	\N
78	109	47	1	завершен	2025-10-08 00:00:00	2025-10-27 00:00:00	3	6	456.00	\N
79	110	24	3	завершен	2026-01-02 00:00:00	2026-01-11 00:00:00	5	10	432.00	\N
80	113	9	2	завершен	2025-08-25 00:00:00	2025-09-08 00:00:00	2	3	371.00	\N
81	114	39	3	назначен	2025-10-22 00:00:00	\N	3	6	315.00	\N
82	115	14	1	завершен	2025-08-01 00:00:00	2025-08-04 00:00:00	3	6	576.00	\N
83	116	38	2	в_пути	2025-09-21 00:00:00	\N	1	2	854.00	\N
84	117	36	2	завершен	2025-08-07 00:00:00	2025-08-15 00:00:00	1	6	258.00	\N
85	121	35	1	отменен	2025-08-04 00:00:00	\N	5	9	593.00	\N
86	122	33	2	назначен	2025-08-13 00:00:00	\N	5	6	687.00	\N
87	123	36	3	назначен	2026-01-07 00:00:00	\N	5	6	521.00	\N
88	124	20	3	назначен	2025-12-31 00:00:00	\N	3	7	1210.00	\N
89	125	18	3	отменен	2025-11-23 00:00:00	\N	3	4	958.00	\N
90	127	2	3	назначен	2025-09-04 00:00:00	\N	5	9	944.00	\N
91	128	48	2	завершен	2025-12-01 00:00:00	2025-12-04 00:00:00	3	5	1454.00	\N
92	129	15	2	отменен	2025-11-10 00:00:00	\N	5	6	1252.00	\N
93	130	28	3	завершен	2025-11-26 00:00:00	2025-12-01 00:00:00	5	10	898.00	\N
94	131	2	2	отменен	2025-09-20 00:00:00	\N	4	6	247.00	\N
95	132	32	1	завершен	2025-08-09 00:00:00	2025-08-23 00:00:00	4	5	270.00	\N
96	133	6	1	отменен	2025-10-23 00:00:00	\N	3	4	1457.00	\N
97	136	27	2	отменен	2025-12-12 00:00:00	\N	3	8	833.00	\N
98	137	16	3	завершен	2025-11-25 00:00:00	2025-12-13 00:00:00	3	6	323.00	\N
99	138	29	2	завершен	2025-08-19 00:00:00	2025-08-23 00:00:00	1	3	710.00	\N
100	139	45	1	назначен	2025-09-22 00:00:00	\N	3	8	674.00	\N
101	140	2	2	отменен	2025-11-22 00:00:00	\N	1	4	488.00	\N
102	141	1	3	завершен	2025-10-06 00:00:00	2025-10-17 00:00:00	1	2	256.00	\N
103	143	28	1	отменен	2025-08-02 00:00:00	\N	3	4	1234.00	\N
104	145	30	1	отменен	2025-12-26 00:00:00	\N	3	7	1113.00	\N
105	146	43	1	завершен	2025-09-23 00:00:00	2025-10-07 00:00:00	1	2	1085.00	\N
106	147	5	2	отменен	2025-11-03 00:00:00	\N	4	9	944.00	\N
107	148	37	3	завершен	2025-12-06 00:00:00	2025-12-23 00:00:00	1	3	147.00	\N
108	150	7	2	в_пути	2025-10-27 00:00:00	\N	4	9	692.00	\N
109	151	50	1	в_пути	2025-09-06 00:00:00	\N	1	2	1344.00	\N
110	152	39	1	назначен	2026-01-08 00:00:00	\N	1	3	517.00	\N
111	153	45	3	отменен	2025-12-16 00:00:00	\N	2	4	115.00	\N
112	154	6	3	завершен	2025-12-28 00:00:00	2026-01-06 00:00:00	1	4	836.00	\N
113	155	35	3	назначен	2025-12-05 00:00:00	\N	2	6	540.00	\N
114	156	10	2	отменен	2026-01-15 00:00:00	\N	5	7	975.00	\N
115	157	10	1	в_пути	2025-09-02 00:00:00	\N	5	10	344.00	\N
116	158	39	3	назначен	2025-08-27 00:00:00	\N	5	8	895.00	\N
117	160	4	2	отменен	2025-10-31 00:00:00	\N	1	6	601.00	\N
118	161	46	2	отменен	2025-10-10 00:00:00	\N	2	5	1491.00	\N
119	163	1	2	в_пути	2025-11-01 00:00:00	\N	1	2	971.00	\N
120	164	6	2	назначен	2025-11-22 00:00:00	\N	2	5	704.00	\N
121	165	12	1	назначен	2026-01-14 00:00:00	\N	3	8	954.00	\N
122	166	23	2	отменен	2025-12-22 00:00:00	\N	1	3	1391.00	\N
123	167	40	2	назначен	2025-12-07 00:00:00	\N	3	7	774.00	\N
124	168	10	1	в_пути	2025-12-02 00:00:00	\N	1	5	1248.00	\N
125	170	26	1	назначен	2025-12-10 00:00:00	\N	1	4	615.00	\N
126	171	28	2	назначен	2025-09-07 00:00:00	\N	2	7	113.00	\N
127	172	24	3	назначен	2025-07-30 00:00:00	\N	4	8	144.00	\N
128	174	27	3	отменен	2025-10-15 00:00:00	\N	3	5	1193.00	\N
129	175	45	2	в_пути	2025-12-07 00:00:00	\N	5	8	614.00	\N
130	176	13	3	завершен	2025-11-15 00:00:00	2025-11-19 00:00:00	3	8	1093.00	\N
131	178	13	3	завершен	2025-11-21 00:00:00	2025-12-09 00:00:00	1	4	140.00	\N
132	179	1	2	отменен	2025-12-18 00:00:00	\N	4	9	671.00	\N
133	180	21	1	отменен	2025-10-05 00:00:00	\N	2	5	877.00	\N
134	181	32	2	отменен	2025-08-31 00:00:00	\N	5	10	1237.00	\N
135	182	34	1	в_пути	2025-10-27 00:00:00	\N	4	5	845.00	\N
136	183	19	1	назначен	2025-12-05 00:00:00	\N	5	10	395.00	\N
137	184	39	2	отменен	2025-08-18 00:00:00	\N	5	7	877.00	\N
138	185	27	3	завершен	2025-08-16 00:00:00	2025-09-02 00:00:00	2	7	386.00	\N
139	188	16	1	в_пути	2025-10-26 00:00:00	\N	2	3	1045.00	\N
140	189	8	2	в_пути	2026-01-10 00:00:00	\N	2	6	1023.00	\N
141	190	24	2	завершен	2025-08-06 00:00:00	2025-08-11 00:00:00	3	7	1453.00	\N
142	191	28	2	завершен	2026-01-13 00:00:00	2026-02-02 00:00:00	1	6	280.00	\N
143	194	45	1	отменен	2025-09-13 00:00:00	\N	3	8	639.00	\N
144	195	48	1	назначен	2025-12-24 00:00:00	\N	4	8	1075.00	\N
145	196	43	3	завершен	2025-12-30 00:00:00	2026-01-05 00:00:00	4	7	1060.00	\N
146	198	4	1	назначен	2025-10-31 00:00:00	\N	4	5	855.00	\N
147	199	35	2	в_пути	2025-12-27 00:00:00	\N	1	5	1147.00	\N
148	200	42	1	завершен	2025-09-04 00:00:00	2025-09-17 00:00:00	3	6	664.00	\N
149	201	3	1	в_пути	2025-10-30 00:00:00	\N	3	8	136.00	\N
150	202	11	1	назначен	2025-10-07 00:00:00	\N	3	6	384.00	\N
151	203	23	2	назначен	2025-10-29 00:00:00	\N	5	6	666.00	\N
152	205	40	1	назначен	2025-12-30 00:00:00	\N	2	5	1276.00	\N
153	206	24	2	отменен	2025-08-24 00:00:00	\N	1	3	1136.00	\N
154	207	26	1	назначен	2025-08-24 00:00:00	\N	4	7	765.00	\N
155	208	41	2	отменен	2025-08-29 00:00:00	\N	1	2	1125.00	\N
156	209	48	2	в_пути	2026-01-12 00:00:00	\N	4	8	883.00	\N
157	211	46	1	отменен	2025-11-07 00:00:00	\N	1	3	305.00	\N
158	212	6	3	назначен	2025-12-09 00:00:00	\N	5	9	939.00	\N
159	213	48	2	отменен	2026-01-07 00:00:00	\N	2	3	479.00	\N
160	214	22	3	отменен	2025-12-17 00:00:00	\N	1	6	879.00	\N
161	215	28	2	назначен	2025-12-04 00:00:00	\N	3	6	969.00	\N
162	216	33	1	завершен	2025-12-16 00:00:00	2026-01-04 00:00:00	5	10	318.00	\N
163	217	39	3	в_пути	2025-11-24 00:00:00	\N	5	10	855.00	\N
164	218	10	2	отменен	2025-12-14 00:00:00	\N	4	9	793.00	\N
165	219	42	3	отменен	2026-01-19 00:00:00	\N	4	5	1171.00	\N
166	220	37	3	назначен	2025-08-12 00:00:00	\N	3	5	1041.00	\N
167	221	32	1	отменен	2026-01-06 00:00:00	\N	4	7	338.00	\N
168	222	21	3	завершен	2025-09-10 00:00:00	2025-09-18 00:00:00	5	8	1288.00	\N
169	224	2	3	назначен	2025-11-07 00:00:00	\N	3	7	1004.00	\N
170	225	24	3	в_пути	2025-10-22 00:00:00	\N	5	9	1008.00	\N
171	226	10	1	отменен	2025-10-22 00:00:00	\N	5	6	1347.00	\N
172	227	33	2	отменен	2025-11-29 00:00:00	\N	2	4	984.00	\N
173	228	41	1	завершен	2025-12-25 00:00:00	2025-12-28 00:00:00	2	6	231.00	\N
174	229	23	2	завершен	2025-12-31 00:00:00	2026-01-04 00:00:00	2	7	130.00	\N
175	231	32	1	в_пути	2025-10-06 00:00:00	\N	5	10	723.00	\N
176	232	35	3	в_пути	2025-08-19 00:00:00	\N	5	9	1238.00	\N
177	233	14	2	завершен	2025-09-10 00:00:00	2025-09-20 00:00:00	1	3	137.00	\N
178	235	43	2	завершен	2025-07-28 00:00:00	2025-07-31 00:00:00	5	7	354.00	\N
179	236	38	2	в_пути	2025-12-27 00:00:00	\N	3	4	741.00	\N
180	239	2	1	отменен	2026-01-07 00:00:00	\N	2	7	1152.00	\N
181	240	42	1	отменен	2025-12-15 00:00:00	\N	4	7	299.00	\N
182	241	47	1	отменен	2025-07-27 00:00:00	\N	5	7	1329.00	\N
183	243	27	2	назначен	2025-12-18 00:00:00	\N	1	5	615.00	\N
184	244	47	3	в_пути	2025-12-10 00:00:00	\N	1	3	1054.00	\N
185	246	3	2	в_пути	2025-07-30 00:00:00	\N	2	6	1403.00	\N
186	248	20	3	завершен	2026-01-08 00:00:00	2026-01-18 00:00:00	3	4	1014.00	\N
187	250	10	1	отменен	2025-12-11 00:00:00	\N	2	6	732.00	\N
188	251	21	1	назначен	2025-12-05 00:00:00	\N	4	7	1190.00	\N
189	252	28	2	завершен	2025-11-17 00:00:00	2025-12-03 00:00:00	3	4	655.00	\N
190	253	2	2	в_пути	2025-09-09 00:00:00	\N	3	6	326.00	\N
191	254	46	2	завершен	2025-12-11 00:00:00	2025-12-26 00:00:00	2	6	281.00	\N
192	255	36	1	в_пути	2025-10-15 00:00:00	\N	1	3	291.00	\N
193	256	29	3	в_пути	2025-12-04 00:00:00	\N	5	8	296.00	\N
194	258	26	2	в_пути	2025-10-25 00:00:00	\N	3	4	216.00	\N
195	259	36	2	завершен	2026-01-20 00:00:00	2026-02-09 00:00:00	2	3	1309.00	\N
196	264	37	3	в_пути	2025-12-19 00:00:00	\N	1	2	245.00	\N
197	265	39	2	в_пути	2025-10-20 00:00:00	\N	4	7	1249.00	\N
198	266	27	3	завершен	2025-08-04 00:00:00	2025-08-23 00:00:00	1	5	1462.00	\N
199	267	49	2	отменен	2025-12-27 00:00:00	\N	1	6	567.00	\N
200	268	1	1	в_пути	2025-11-23 00:00:00	\N	5	10	1233.00	\N
201	271	18	1	в_пути	2026-01-11 00:00:00	\N	2	5	571.00	\N
202	272	35	1	завершен	2025-11-21 00:00:00	2025-11-28 00:00:00	3	7	459.00	\N
203	273	16	3	отменен	2025-11-09 00:00:00	\N	3	6	735.00	\N
204	275	36	3	назначен	2025-08-30 00:00:00	\N	2	7	921.00	\N
205	276	39	2	назначен	2025-09-08 00:00:00	\N	4	9	1031.00	\N
206	277	23	1	назначен	2025-07-28 00:00:00	\N	1	6	605.00	\N
207	279	43	1	завершен	2025-11-24 00:00:00	2025-12-13 00:00:00	1	5	1129.00	\N
208	281	18	2	назначен	2025-12-25 00:00:00	\N	3	6	1401.00	\N
209	286	21	2	в_пути	2025-12-06 00:00:00	\N	3	7	241.00	\N
210	290	40	2	отменен	2025-12-14 00:00:00	\N	1	3	403.00	\N
211	291	17	3	отменен	2025-09-17 00:00:00	\N	1	6	172.00	\N
212	292	47	2	назначен	2025-09-25 00:00:00	\N	1	2	488.00	\N
213	294	14	3	назначен	2025-08-24 00:00:00	\N	4	5	1130.00	\N
214	295	4	3	в_пути	2025-11-12 00:00:00	\N	4	9	754.00	\N
215	296	29	3	назначен	2025-10-28 00:00:00	\N	1	5	961.00	\N
216	298	39	1	в_пути	2025-08-08 00:00:00	\N	5	6	765.00	\N
217	301	41	3	отменен	2025-10-28 00:00:00	\N	2	5	293.00	\N
218	303	28	3	отменен	2025-12-10 00:00:00	\N	5	10	1041.00	\N
219	305	14	3	в_пути	2026-01-04 00:00:00	\N	3	8	421.00	\N
220	307	34	3	назначен	2025-11-29 00:00:00	\N	2	5	228.00	\N
221	308	39	2	в_пути	2025-08-30 00:00:00	\N	5	6	1396.00	\N
222	309	14	3	завершен	2025-11-16 00:00:00	2025-11-21 00:00:00	1	5	351.00	\N
223	310	45	2	назначен	2025-08-05 00:00:00	\N	5	9	1484.00	\N
224	311	1	2	отменен	2026-01-11 00:00:00	\N	4	9	366.00	\N
225	312	11	1	завершен	2025-08-05 00:00:00	2025-08-14 00:00:00	4	5	1169.00	\N
226	313	4	3	завершен	2025-09-10 00:00:00	2025-09-25 00:00:00	5	9	470.00	\N
227	314	25	2	отменен	2025-09-17 00:00:00	\N	3	4	612.00	\N
228	315	22	3	завершен	2025-11-16 00:00:00	2025-11-30 00:00:00	2	5	842.00	\N
229	316	36	1	завершен	2025-10-27 00:00:00	2025-11-03 00:00:00	5	9	1024.00	\N
230	317	38	2	назначен	2025-08-02 00:00:00	\N	1	4	569.00	\N
231	318	35	2	завершен	2025-07-30 00:00:00	2025-08-02 00:00:00	1	3	760.00	\N
232	319	1	3	завершен	2025-07-26 00:00:00	2025-08-05 00:00:00	2	3	1447.00	\N
233	320	17	1	в_пути	2025-08-26 00:00:00	\N	3	8	462.00	\N
234	321	31	1	завершен	2025-09-11 00:00:00	2025-09-25 00:00:00	2	5	1191.00	\N
235	323	22	3	назначен	2025-09-16 00:00:00	\N	1	2	916.00	\N
236	324	49	3	в_пути	2025-09-20 00:00:00	\N	4	5	1207.00	\N
237	325	39	3	в_пути	2025-08-15 00:00:00	\N	2	5	1137.00	\N
238	326	31	1	назначен	2026-01-07 00:00:00	\N	4	6	852.00	\N
239	327	33	3	назначен	2025-09-13 00:00:00	\N	2	6	1427.00	\N
240	328	22	1	назначен	2025-10-02 00:00:00	\N	2	4	1027.00	\N
241	331	22	1	завершен	2025-07-28 00:00:00	2025-08-06 00:00:00	4	9	249.00	\N
242	332	7	1	в_пути	2025-10-07 00:00:00	\N	4	9	1029.00	\N
243	335	21	2	завершен	2025-08-08 00:00:00	2025-08-15 00:00:00	2	6	576.00	\N
244	337	19	3	в_пути	2025-10-11 00:00:00	\N	2	7	406.00	\N
245	339	44	3	отменен	2025-12-07 00:00:00	\N	2	7	369.00	\N
246	340	39	3	назначен	2025-12-30 00:00:00	\N	4	7	1115.00	\N
247	342	9	2	отменен	2025-12-20 00:00:00	\N	4	7	989.00	\N
248	344	42	1	в_пути	2025-07-31 00:00:00	\N	1	2	204.00	\N
249	345	25	3	назначен	2026-01-15 00:00:00	\N	1	4	1004.00	\N
250	346	48	2	отменен	2025-07-28 00:00:00	\N	4	9	850.00	\N
251	347	36	1	назначен	2025-08-05 00:00:00	\N	3	5	1424.00	\N
252	348	30	2	назначен	2025-08-28 00:00:00	\N	4	9	1401.00	\N
253	350	47	1	назначен	2025-07-27 00:00:00	\N	5	7	802.00	\N
254	351	46	2	в_пути	2025-08-28 00:00:00	\N	1	5	1465.00	\N
255	352	38	1	в_пути	2025-12-27 00:00:00	\N	2	3	318.00	\N
256	356	7	3	завершен	2025-10-13 00:00:00	2025-10-30 00:00:00	3	7	790.00	\N
257	357	11	3	отменен	2026-01-18 00:00:00	\N	3	6	328.00	\N
258	358	41	1	в_пути	2025-11-06 00:00:00	\N	3	8	641.00	\N
259	359	38	1	завершен	2025-08-14 00:00:00	2025-08-19 00:00:00	1	5	1172.00	\N
260	360	12	3	отменен	2025-09-18 00:00:00	\N	4	6	862.00	\N
261	361	25	2	в_пути	2025-12-29 00:00:00	\N	5	7	132.00	\N
262	362	46	1	назначен	2026-01-09 00:00:00	\N	4	7	425.00	\N
263	364	4	3	отменен	2025-08-19 00:00:00	\N	3	4	1099.00	\N
264	365	13	2	в_пути	2025-12-19 00:00:00	\N	1	2	432.00	\N
265	367	46	2	отменен	2025-09-21 00:00:00	\N	5	8	279.00	\N
266	368	20	2	в_пути	2025-09-08 00:00:00	\N	1	4	1053.00	\N
267	370	6	3	в_пути	2025-07-26 00:00:00	\N	5	10	378.00	\N
268	371	34	2	назначен	2025-11-24 00:00:00	\N	3	5	1169.00	\N
269	372	41	3	назначен	2025-12-16 00:00:00	\N	1	5	222.00	\N
270	373	8	1	назначен	2025-09-04 00:00:00	\N	3	7	1471.00	\N
271	374	44	3	в_пути	2025-12-21 00:00:00	\N	5	7	153.00	\N
272	375	46	3	отменен	2025-07-25 00:00:00	\N	2	7	741.00	\N
273	377	4	2	отменен	2025-11-21 00:00:00	\N	2	3	977.00	\N
274	378	48	1	отменен	2025-12-20 00:00:00	\N	2	5	358.00	\N
275	380	12	3	отменен	2025-10-20 00:00:00	\N	3	8	679.00	\N
276	381	20	3	завершен	2025-12-10 00:00:00	2025-12-20 00:00:00	3	4	813.00	\N
277	382	6	1	назначен	2025-08-01 00:00:00	\N	2	6	407.00	\N
278	383	47	3	отменен	2025-09-22 00:00:00	\N	1	4	239.00	\N
279	384	5	1	завершен	2025-08-16 00:00:00	2025-09-01 00:00:00	4	9	1475.00	\N
280	385	42	3	в_пути	2025-10-11 00:00:00	\N	3	6	500.00	\N
281	387	31	3	завершен	2025-08-15 00:00:00	2025-08-26 00:00:00	3	5	1195.00	\N
282	388	12	3	назначен	2025-09-20 00:00:00	\N	1	6	324.00	\N
283	390	28	1	завершен	2026-01-10 00:00:00	2026-01-23 00:00:00	2	5	918.00	\N
284	391	26	1	в_пути	2025-12-31 00:00:00	\N	3	4	290.00	\N
285	395	15	1	в_пути	2026-01-08 00:00:00	\N	1	4	1225.00	\N
286	396	40	3	завершен	2025-11-08 00:00:00	2025-11-15 00:00:00	3	4	474.00	\N
287	397	16	1	завершен	2026-01-03 00:00:00	2026-01-20 00:00:00	4	8	664.00	\N
288	399	44	3	назначен	2026-01-11 00:00:00	\N	4	6	750.00	\N
289	400	36	1	назначен	2025-12-22 00:00:00	\N	5	9	1014.00	\N
290	403	18	2	в_пути	2025-11-29 00:00:00	\N	5	8	472.00	\N
291	405	45	1	в_пути	2025-09-17 00:00:00	\N	4	8	1321.00	\N
292	406	41	2	в_пути	2025-08-03 00:00:00	\N	4	8	1379.00	\N
293	409	29	2	завершен	2026-01-17 00:00:00	2026-01-30 00:00:00	4	6	1474.00	\N
294	411	36	3	отменен	2025-08-25 00:00:00	\N	2	3	831.00	\N
295	412	2	3	назначен	2025-08-02 00:00:00	\N	5	7	1128.00	\N
296	414	2	1	отменен	2025-12-14 00:00:00	\N	4	9	1038.00	\N
297	415	50	2	завершен	2025-10-05 00:00:00	2025-10-21 00:00:00	3	8	762.00	\N
298	416	16	3	отменен	2025-08-18 00:00:00	\N	3	6	587.00	\N
299	420	3	3	назначен	2025-09-26 00:00:00	\N	1	3	570.00	\N
300	422	46	3	завершен	2025-08-02 00:00:00	2025-08-05 00:00:00	5	9	1017.00	\N
301	423	5	2	отменен	2025-10-21 00:00:00	\N	4	9	1186.00	\N
302	424	37	3	завершен	2025-10-07 00:00:00	2025-10-11 00:00:00	1	6	1107.00	\N
303	425	43	1	назначен	2025-11-28 00:00:00	\N	5	6	1255.00	\N
304	427	7	2	в_пути	2025-08-28 00:00:00	\N	3	6	1199.00	\N
305	428	28	3	назначен	2025-11-03 00:00:00	\N	3	8	966.00	\N
306	429	36	3	отменен	2025-09-07 00:00:00	\N	3	4	969.00	\N
307	431	22	1	отменен	2025-12-27 00:00:00	\N	3	7	921.00	\N
308	432	3	2	отменен	2025-10-11 00:00:00	\N	4	8	874.00	\N
309	433	38	2	завершен	2025-07-25 00:00:00	2025-07-31 00:00:00	1	2	928.00	\N
310	434	5	3	назначен	2025-10-25 00:00:00	\N	5	9	826.00	\N
311	435	30	1	завершен	2025-09-24 00:00:00	2025-10-06 00:00:00	2	7	791.00	\N
312	436	13	1	отменен	2025-12-07 00:00:00	\N	3	8	997.00	\N
313	438	48	2	завершен	2025-08-13 00:00:00	2025-08-24 00:00:00	4	6	935.00	\N
314	439	9	1	завершен	2026-01-04 00:00:00	2026-01-13 00:00:00	3	7	1217.00	\N
315	440	4	1	назначен	2025-09-06 00:00:00	\N	1	5	637.00	\N
316	441	13	2	завершен	2026-01-16 00:00:00	2026-01-22 00:00:00	2	3	1258.00	\N
317	442	36	3	назначен	2025-10-31 00:00:00	\N	3	6	922.00	\N
318	443	6	3	назначен	2025-12-10 00:00:00	\N	1	3	893.00	\N
319	445	11	1	в_пути	2025-09-10 00:00:00	\N	3	4	1156.00	\N
320	446	44	1	завершен	2025-12-03 00:00:00	2025-12-11 00:00:00	4	9	1040.00	\N
321	447	8	3	в_пути	2025-10-22 00:00:00	\N	4	8	1275.00	\N
322	448	17	3	в_пути	2025-10-23 00:00:00	\N	5	8	779.00	\N
323	450	6	3	завершен	2025-08-19 00:00:00	2025-09-01 00:00:00	4	7	895.00	\N
324	451	15	3	назначен	2025-11-28 00:00:00	\N	2	7	695.00	\N
325	452	23	1	завершен	2025-10-18 00:00:00	2025-10-23 00:00:00	5	8	341.00	\N
326	453	26	1	завершен	2025-12-24 00:00:00	2026-01-09 00:00:00	3	4	1382.00	\N
327	454	7	3	завершен	2025-11-14 00:00:00	2025-11-25 00:00:00	2	4	1377.00	\N
328	455	21	2	отменен	2025-09-25 00:00:00	\N	1	3	1096.00	\N
329	456	3	3	назначен	2025-09-28 00:00:00	\N	2	5	518.00	\N
330	457	28	1	завершен	2025-08-01 00:00:00	2025-08-18 00:00:00	5	6	1129.00	\N
331	458	40	1	отменен	2026-01-19 00:00:00	\N	3	6	290.00	\N
332	459	47	2	в_пути	2025-09-26 00:00:00	\N	5	9	1478.00	\N
333	462	47	1	завершен	2025-09-08 00:00:00	2025-09-27 00:00:00	4	9	685.00	\N
334	464	18	3	отменен	2026-01-16 00:00:00	\N	4	9	584.00	\N
335	466	45	3	отменен	2025-08-25 00:00:00	\N	3	5	885.00	\N
336	467	40	1	назначен	2025-12-26 00:00:00	\N	4	6	367.00	\N
337	468	32	2	назначен	2025-11-16 00:00:00	\N	1	5	460.00	\N
338	469	42	1	завершен	2025-10-30 00:00:00	2025-11-13 00:00:00	1	5	1095.00	\N
339	470	39	2	отменен	2025-08-18 00:00:00	\N	2	3	388.00	\N
340	472	37	2	завершен	2025-11-03 00:00:00	2025-11-15 00:00:00	2	4	1246.00	\N
341	473	9	2	отменен	2025-11-25 00:00:00	\N	2	3	418.00	\N
342	474	18	2	отменен	2025-12-30 00:00:00	\N	4	7	1495.00	\N
343	475	8	3	отменен	2025-07-25 00:00:00	\N	1	2	1378.00	\N
344	476	42	1	завершен	2025-12-17 00:00:00	2025-12-29 00:00:00	3	6	412.00	\N
345	478	40	3	назначен	2025-10-08 00:00:00	\N	1	4	983.00	\N
346	479	33	2	отменен	2025-11-16 00:00:00	\N	2	4	663.00	\N
347	482	20	3	назначен	2025-09-10 00:00:00	\N	1	5	743.00	\N
348	483	28	1	отменен	2025-09-22 00:00:00	\N	1	5	732.00	\N
349	484	44	3	завершен	2026-01-08 00:00:00	2026-01-28 00:00:00	3	8	1194.00	\N
350	485	7	1	назначен	2025-08-02 00:00:00	\N	3	6	177.00	\N
351	486	16	1	в_пути	2025-10-22 00:00:00	\N	3	8	1304.00	\N
352	487	1	1	отменен	2025-10-15 00:00:00	\N	1	6	1046.00	\N
353	488	5	2	отменен	2025-11-22 00:00:00	\N	2	6	1203.00	\N
354	489	10	3	назначен	2025-12-10 00:00:00	\N	3	4	276.00	\N
355	490	3	1	в_пути	2025-08-22 00:00:00	\N	5	9	1338.00	\N
356	491	11	3	отменен	2025-08-27 00:00:00	\N	3	4	454.00	\N
357	492	39	2	отменен	2025-10-09 00:00:00	\N	3	5	1269.00	\N
358	493	34	2	отменен	2025-08-15 00:00:00	\N	4	6	1193.00	\N
359	494	47	1	в_пути	2025-11-21 00:00:00	\N	2	6	1108.00	\N
360	495	50	1	отменен	2025-11-03 00:00:00	\N	1	4	1446.00	\N
361	497	50	2	отменен	2025-08-26 00:00:00	\N	3	6	851.00	\N
362	498	31	2	завершен	2025-12-28 00:00:00	2026-01-09 00:00:00	5	8	716.00	\N
363	499	40	1	назначен	2025-10-26 00:00:00	\N	1	3	718.00	\N
364	500	40	1	назначен	2025-12-06 00:00:00	\N	5	9	886.00	\N
\.


--
-- Data for Name: груз_и_средства; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."груз_и_средства" ("ид_груз_средство", "ид_груз", "ид_средство", "последовательность", "статус", "дата_начала", "дата_окончания", "пройдено_км", "время_в_пути_часов", "стоимость_доставки_руб", "примечание", "расход_топлива_л") FROM stdin;
1	1	68	4	назначен	2026-01-06 00:00:00	\N	730.00	10.40	37731.42	\N	73.00
2	3	99	2	отменен	2026-01-10 00:00:00	\N	769.00	11.00	18435.14	\N	76.90
3	4	96	5	назначен	2025-12-29 00:00:00	\N	1987.00	28.40	6211.48	\N	198.70
4	6	97	4	в_процессе	2025-08-23 00:00:00	\N	1639.00	23.40	28818.93	\N	163.90
5	7	23	4	в_процессе	2025-11-27 00:00:00	\N	409.00	5.80	46584.94	\N	40.90
6	8	31	3	в_процессе	2025-08-17 00:00:00	\N	161.00	2.30	17541.12	\N	16.10
7	9	99	1	отменен	2025-12-25 00:00:00	\N	214.00	3.10	15616.26	\N	21.40
8	10	31	2	отменен	2025-08-20 00:00:00	\N	1866.00	26.70	28937.22	\N	186.60
9	11	78	1	завершен	2025-10-16 00:00:00	2025-10-22 00:00:00	266.00	3.80	18866.43	\N	26.60
10	12	91	4	завершен	2025-11-22 00:00:00	2025-12-07 00:00:00	433.00	6.20	17514.06	\N	43.30
11	13	14	1	завершен	2025-12-11 00:00:00	2025-12-26 00:00:00	1871.00	26.70	31739.78	\N	187.10
12	14	66	4	в_процессе	2026-01-11 00:00:00	\N	311.00	4.40	37212.07	\N	31.10
13	15	21	1	в_процессе	2026-01-17 00:00:00	\N	804.00	11.50	27043.09	\N	80.40
14	16	65	2	назначен	2025-08-01 00:00:00	\N	1471.00	21.00	20530.02	\N	147.10
15	17	14	5	завершен	2025-11-22 00:00:00	2025-12-02 00:00:00	830.00	11.90	11153.54	\N	83.00
16	18	58	1	отменен	2025-12-06 00:00:00	\N	1651.00	23.60	46171.32	\N	165.10
17	19	68	4	завершен	2025-11-23 00:00:00	2025-11-28 00:00:00	86.00	1.20	33197.66	\N	8.60
18	20	98	4	завершен	2025-08-05 00:00:00	2025-08-20 00:00:00	1069.00	15.30	8294.15	\N	106.90
19	22	39	3	в_процессе	2025-12-14 00:00:00	\N	1435.00	20.50	41024.69	\N	143.50
20	23	84	5	назначен	2025-12-27 00:00:00	\N	362.00	5.20	13576.47	\N	36.20
21	24	39	3	назначен	2025-11-26 00:00:00	\N	111.00	1.60	47969.65	\N	11.10
22	25	10	3	завершен	2025-12-15 00:00:00	2025-12-30 00:00:00	1160.00	16.60	9386.90	\N	116.00
23	26	96	1	в_процессе	2025-12-09 00:00:00	\N	221.00	3.20	27844.40	\N	22.10
24	27	53	1	завершен	2025-08-21 00:00:00	2025-08-25 00:00:00	1877.00	26.80	16970.16	\N	187.70
25	28	16	2	в_процессе	2025-11-07 00:00:00	\N	865.00	12.40	14574.31	\N	86.50
26	30	92	3	в_процессе	2025-08-20 00:00:00	\N	1012.00	14.50	36014.44	\N	101.20
27	31	17	2	завершен	2026-01-12 00:00:00	2026-01-23 00:00:00	1298.00	18.50	22070.86	\N	129.80
28	32	93	3	отменен	2025-09-02 00:00:00	\N	201.00	2.90	24991.29	\N	20.10
29	33	27	1	отменен	2025-08-15 00:00:00	\N	649.00	9.30	5653.46	\N	64.90
30	34	10	1	отменен	2025-12-13 00:00:00	\N	645.00	9.20	42259.09	\N	64.50
31	35	47	4	назначен	2025-07-25 00:00:00	\N	1360.00	19.40	20909.03	\N	136.00
32	36	66	4	назначен	2025-12-22 00:00:00	\N	1502.00	21.50	6453.68	\N	150.20
33	37	40	4	назначен	2025-08-04 00:00:00	\N	427.00	6.10	10002.24	\N	42.70
34	39	82	5	назначен	2025-11-29 00:00:00	\N	993.00	14.20	26208.09	\N	99.30
35	40	98	5	в_процессе	2025-09-28 00:00:00	\N	1853.00	26.50	19193.96	\N	185.30
36	41	100	3	отменен	2026-01-04 00:00:00	\N	141.00	2.00	9316.23	\N	14.10
37	42	34	2	отменен	2025-08-27 00:00:00	\N	981.00	14.00	7942.27	\N	98.10
38	43	83	3	в_процессе	2025-09-02 00:00:00	\N	184.00	2.60	18562.64	\N	18.40
39	44	74	1	отменен	2025-12-07 00:00:00	\N	1400.00	20.00	23190.79	\N	140.00
40	45	57	5	назначен	2025-08-18 00:00:00	\N	1534.00	21.90	10107.31	\N	153.40
41	46	18	2	назначен	2025-08-09 00:00:00	\N	629.00	9.00	26817.01	\N	62.90
42	47	90	1	завершен	2025-11-30 00:00:00	2025-12-03 00:00:00	364.00	5.20	11842.17	\N	36.40
43	48	71	2	отменен	2025-09-28 00:00:00	\N	1090.00	15.60	22538.33	\N	109.00
44	49	97	5	завершен	2025-11-11 00:00:00	2025-11-25 00:00:00	1712.00	24.50	13017.30	\N	171.20
45	50	26	5	назначен	2025-09-05 00:00:00	\N	785.00	11.20	32874.66	\N	78.50
46	51	33	1	назначен	2025-10-09 00:00:00	\N	831.00	11.90	46439.00	\N	83.10
47	52	49	5	в_процессе	2025-10-23 00:00:00	\N	106.00	1.50	22891.91	\N	10.60
48	53	11	3	отменен	2025-09-10 00:00:00	\N	939.00	13.40	43127.38	\N	93.90
49	54	38	5	отменен	2026-01-14 00:00:00	\N	578.00	8.30	19877.29	\N	57.80
50	55	77	2	завершен	2025-10-22 00:00:00	2025-11-03 00:00:00	513.00	7.30	11172.04	\N	51.30
51	56	48	2	завершен	2025-12-22 00:00:00	2026-01-01 00:00:00	795.00	11.40	39196.53	\N	79.50
52	57	16	5	отменен	2026-01-20 00:00:00	\N	1916.00	27.40	37909.73	\N	191.60
53	58	96	2	в_процессе	2025-09-20 00:00:00	\N	1832.00	26.20	38768.62	\N	183.20
54	60	88	2	в_процессе	2025-11-10 00:00:00	\N	605.00	8.60	48674.58	\N	60.50
55	61	51	3	назначен	2026-01-14 00:00:00	\N	709.00	10.10	45801.11	\N	70.90
56	62	76	2	отменен	2025-07-30 00:00:00	\N	1277.00	18.20	30531.92	\N	127.70
57	63	69	1	назначен	2025-09-18 00:00:00	\N	1675.00	23.90	48637.38	\N	167.50
58	64	37	1	завершен	2026-01-09 00:00:00	2026-01-22 00:00:00	864.00	12.30	31380.04	\N	86.40
59	65	51	1	отменен	2025-11-30 00:00:00	\N	1408.00	20.10	17268.42	\N	140.80
60	67	29	1	завершен	2025-09-12 00:00:00	2025-09-26 00:00:00	1553.00	22.20	33093.01	\N	155.30
61	68	81	2	отменен	2025-10-04 00:00:00	\N	1398.00	20.00	21743.61	\N	139.80
62	69	7	3	назначен	2025-10-13 00:00:00	\N	182.00	2.60	5049.12	\N	18.20
63	70	61	5	отменен	2025-12-30 00:00:00	\N	1142.00	16.30	12413.41	\N	114.20
64	72	93	4	завершен	2025-10-12 00:00:00	2025-10-17 00:00:00	1674.00	23.90	35427.55	\N	167.40
65	73	81	2	назначен	2025-08-28 00:00:00	\N	1583.00	22.60	15511.65	\N	158.30
66	75	32	5	назначен	2025-09-17 00:00:00	\N	1725.00	24.60	44724.27	\N	172.50
67	76	24	1	назначен	2026-01-19 00:00:00	\N	975.00	13.90	15062.67	\N	97.50
68	78	24	2	отменен	2025-11-25 00:00:00	\N	1690.00	24.10	40596.03	\N	169.00
69	79	26	5	завершен	2025-07-31 00:00:00	2025-08-15 00:00:00	1851.00	26.40	17987.00	\N	185.10
70	80	91	1	отменен	2025-09-02 00:00:00	\N	791.00	11.30	35840.89	\N	79.10
71	81	93	2	завершен	2025-11-18 00:00:00	2025-11-21 00:00:00	825.00	11.80	33083.02	\N	82.50
72	82	30	3	отменен	2025-12-31 00:00:00	\N	272.00	3.90	43377.64	\N	27.20
73	83	9	2	назначен	2025-12-22 00:00:00	\N	83.00	1.20	43902.46	\N	8.30
74	86	16	1	завершен	2025-11-22 00:00:00	2025-11-28 00:00:00	711.00	10.20	8971.19	\N	71.10
75	87	61	3	в_процессе	2025-08-14 00:00:00	\N	1742.00	24.90	8870.55	\N	174.20
76	88	54	4	завершен	2026-01-02 00:00:00	2026-01-17 00:00:00	1195.00	17.10	31298.91	\N	119.50
77	89	61	2	назначен	2025-12-17 00:00:00	\N	1830.00	26.10	13445.19	\N	183.00
78	90	94	5	назначен	2025-09-09 00:00:00	\N	808.00	11.50	25081.91	\N	80.80
79	91	72	4	в_процессе	2025-08-26 00:00:00	\N	229.00	3.30	25324.14	\N	22.90
80	92	84	4	отменен	2025-11-09 00:00:00	\N	938.00	13.40	10698.92	\N	93.80
81	93	11	2	завершен	2026-01-10 00:00:00	2026-01-17 00:00:00	572.00	8.20	25753.84	\N	57.20
82	94	71	2	отменен	2025-12-22 00:00:00	\N	861.00	12.30	37126.62	\N	86.10
83	95	95	3	отменен	2025-12-29 00:00:00	\N	1598.00	22.80	7268.48	\N	159.80
84	96	53	5	завершен	2025-09-17 00:00:00	2025-09-22 00:00:00	1595.00	22.80	14071.25	\N	159.50
85	98	51	1	в_процессе	2025-12-28 00:00:00	\N	1441.00	20.60	45938.79	\N	144.10
86	100	92	4	в_процессе	2025-07-29 00:00:00	\N	949.00	13.60	35148.17	\N	94.90
87	101	30	3	отменен	2025-11-11 00:00:00	\N	1474.00	21.10	36739.88	\N	147.40
88	102	7	4	завершен	2025-10-01 00:00:00	2025-10-16 00:00:00	1126.00	16.10	9526.08	\N	112.60
89	103	41	1	завершен	2025-09-25 00:00:00	2025-10-10 00:00:00	753.00	10.80	31599.70	\N	75.30
90	104	8	3	назначен	2025-11-07 00:00:00	\N	416.00	5.90	46987.91	\N	41.60
91	106	55	2	назначен	2025-08-14 00:00:00	\N	1820.00	26.00	34586.88	\N	182.00
92	107	5	1	назначен	2025-12-16 00:00:00	\N	382.00	5.50	32851.20	\N	38.20
93	108	100	3	назначен	2025-12-01 00:00:00	\N	749.00	10.70	41095.37	\N	74.90
94	110	56	5	в_процессе	2025-09-13 00:00:00	\N	1316.00	18.80	20243.12	\N	131.60
95	111	73	5	завершен	2025-07-31 00:00:00	2025-08-07 00:00:00	1799.00	25.70	15831.66	\N	179.90
96	112	33	4	отменен	2025-12-31 00:00:00	\N	1295.00	18.50	24198.23	\N	129.50
97	113	53	3	отменен	2025-12-26 00:00:00	\N	533.00	7.60	40880.12	\N	53.30
98	114	14	5	назначен	2025-12-06 00:00:00	\N	1032.00	14.70	48624.65	\N	103.20
99	115	86	2	в_процессе	2025-08-04 00:00:00	\N	1846.00	26.40	34380.64	\N	184.60
100	116	18	2	назначен	2025-10-01 00:00:00	\N	1954.00	27.90	24538.91	\N	195.40
101	117	44	5	завершен	2025-09-12 00:00:00	2025-09-24 00:00:00	1366.00	19.50	26294.46	\N	136.60
102	118	11	2	в_процессе	2025-08-24 00:00:00	\N	1285.00	18.40	13792.11	\N	128.50
103	119	30	1	завершен	2025-09-22 00:00:00	2025-10-01 00:00:00	786.00	11.20	15682.03	\N	78.60
104	121	84	4	отменен	2025-12-10 00:00:00	\N	1874.00	26.80	6065.56	\N	187.40
105	122	80	5	назначен	2025-12-25 00:00:00	\N	1094.00	15.60	21037.21	\N	109.40
106	123	41	5	завершен	2025-12-24 00:00:00	2026-01-03 00:00:00	210.00	3.00	19906.96	\N	21.00
107	124	46	5	в_процессе	2025-09-07 00:00:00	\N	1230.00	17.60	9437.47	\N	123.00
108	126	81	5	завершен	2025-10-23 00:00:00	2025-11-05 00:00:00	1274.00	18.20	38242.85	\N	127.40
109	127	53	5	отменен	2025-08-03 00:00:00	\N	1947.00	27.80	30266.94	\N	194.70
110	128	18	3	в_процессе	2025-07-28 00:00:00	\N	743.00	10.60	48166.33	\N	74.30
111	130	90	1	в_процессе	2025-07-31 00:00:00	\N	179.00	2.60	41485.25	\N	17.90
112	131	52	4	в_процессе	2026-01-20 00:00:00	\N	1060.00	15.10	27325.29	\N	106.00
113	132	47	4	отменен	2025-08-29 00:00:00	\N	1980.00	28.30	21674.43	\N	198.00
114	133	11	3	в_процессе	2025-12-17 00:00:00	\N	720.00	10.30	41107.45	\N	72.00
115	134	23	5	в_процессе	2025-09-28 00:00:00	\N	1780.00	25.40	38422.57	\N	178.00
116	135	14	4	отменен	2025-12-08 00:00:00	\N	317.00	4.50	24540.60	\N	31.70
117	136	60	4	назначен	2025-08-10 00:00:00	\N	981.00	14.00	48409.99	\N	98.10
118	137	97	5	завершен	2025-10-25 00:00:00	2025-11-06 00:00:00	259.00	3.70	14821.88	\N	25.90
119	139	71	5	отменен	2025-09-19 00:00:00	\N	1683.00	24.00	34295.81	\N	168.30
120	141	49	2	отменен	2025-10-03 00:00:00	\N	475.00	6.80	25064.66	\N	47.50
121	142	18	2	завершен	2025-12-11 00:00:00	2025-12-18 00:00:00	1383.00	19.80	23183.27	\N	138.30
122	143	92	2	завершен	2026-01-12 00:00:00	2026-01-24 00:00:00	747.00	10.70	47453.51	\N	74.70
123	146	9	3	отменен	2025-12-24 00:00:00	\N	172.00	2.50	12186.49	\N	17.20
124	148	94	4	завершен	2026-01-15 00:00:00	2026-01-28 00:00:00	827.00	11.80	26394.86	\N	82.70
125	149	30	2	в_процессе	2025-10-22 00:00:00	\N	1269.00	18.10	21773.60	\N	126.90
126	150	96	4	завершен	2025-09-08 00:00:00	2025-09-19 00:00:00	1824.00	26.10	22332.18	\N	182.40
127	153	14	2	отменен	2025-12-06 00:00:00	\N	880.00	12.60	27126.44	\N	88.00
128	154	20	3	отменен	2026-01-09 00:00:00	\N	269.00	3.80	23572.87	\N	26.90
129	156	25	1	завершен	2025-11-04 00:00:00	2025-11-06 00:00:00	1522.00	21.70	24063.55	\N	152.20
130	158	8	4	завершен	2025-10-26 00:00:00	2025-10-29 00:00:00	376.00	5.40	41893.66	\N	37.60
131	159	72	3	завершен	2025-11-07 00:00:00	2025-11-10 00:00:00	584.00	8.30	37678.50	\N	58.40
132	160	88	4	завершен	2025-09-16 00:00:00	2025-09-30 00:00:00	101.00	1.40	15825.49	\N	10.10
133	161	50	3	отменен	2026-01-05 00:00:00	\N	1060.00	15.10	27258.08	\N	106.00
134	162	52	1	в_процессе	2025-10-04 00:00:00	\N	1265.00	18.10	49465.49	\N	126.50
135	163	20	3	в_процессе	2025-11-23 00:00:00	\N	1111.00	15.90	29078.99	\N	111.10
136	164	58	1	назначен	2025-08-02 00:00:00	\N	1480.00	21.10	43079.66	\N	148.00
137	165	41	3	завершен	2025-07-28 00:00:00	2025-08-04 00:00:00	648.00	9.30	46950.67	\N	64.80
138	166	31	1	завершен	2026-01-14 00:00:00	2026-01-23 00:00:00	1661.00	23.70	18090.93	\N	166.10
139	167	34	1	в_процессе	2025-12-01 00:00:00	\N	442.00	6.30	8742.69	\N	44.20
140	168	28	1	завершен	2025-09-24 00:00:00	2025-10-01 00:00:00	1163.00	16.60	43392.02	\N	116.30
141	169	78	2	в_процессе	2025-08-30 00:00:00	\N	1977.00	28.20	17974.27	\N	197.70
142	170	62	1	назначен	2025-12-03 00:00:00	\N	1304.00	18.60	37982.33	\N	130.40
143	171	66	2	назначен	2025-08-16 00:00:00	\N	1141.00	16.30	27356.38	\N	114.10
144	172	34	3	назначен	2026-01-12 00:00:00	\N	1591.00	22.70	19454.97	\N	159.10
145	173	51	2	завершен	2025-11-03 00:00:00	2025-11-10 00:00:00	1361.00	19.40	40686.64	\N	136.10
146	174	41	2	отменен	2025-10-16 00:00:00	\N	1869.00	26.70	34024.21	\N	186.90
147	175	31	5	завершен	2025-08-13 00:00:00	2025-08-16 00:00:00	1098.00	15.70	19919.01	\N	109.80
148	176	68	2	завершен	2025-12-24 00:00:00	2025-12-27 00:00:00	409.00	5.80	24141.20	\N	40.90
149	179	95	5	отменен	2025-12-17 00:00:00	\N	90.00	1.30	28131.45	\N	9.00
150	180	48	1	завершен	2025-07-25 00:00:00	2025-08-06 00:00:00	1102.00	15.70	36895.77	\N	110.20
151	181	36	1	завершен	2025-11-06 00:00:00	2025-11-17 00:00:00	777.00	11.10	23006.75	\N	77.70
152	182	92	1	завершен	2025-10-11 00:00:00	2025-10-19 00:00:00	971.00	13.90	11705.95	\N	97.10
153	183	53	5	завершен	2025-11-10 00:00:00	2025-11-13 00:00:00	768.00	11.00	6830.19	\N	76.80
154	184	73	3	отменен	2025-12-13 00:00:00	\N	998.00	14.30	11234.63	\N	99.80
155	185	38	3	завершен	2025-08-02 00:00:00	2025-08-09 00:00:00	1363.00	19.50	25013.65	\N	136.30
156	186	27	4	завершен	2025-08-18 00:00:00	2025-08-31 00:00:00	1688.00	24.10	48855.39	\N	168.80
157	187	50	4	в_процессе	2025-09-09 00:00:00	\N	1197.00	17.10	46872.60	\N	119.70
158	189	28	1	отменен	2025-09-02 00:00:00	\N	614.00	8.80	34885.57	\N	61.40
159	190	35	3	назначен	2025-12-15 00:00:00	\N	881.00	12.60	42699.57	\N	88.10
160	191	81	2	завершен	2025-10-13 00:00:00	2025-10-15 00:00:00	482.00	6.90	21369.61	\N	48.20
161	192	38	5	назначен	2025-11-10 00:00:00	\N	299.00	4.30	13660.95	\N	29.90
162	193	81	1	отменен	2025-09-11 00:00:00	\N	546.00	7.80	48221.87	\N	54.60
163	194	48	4	в_процессе	2025-11-27 00:00:00	\N	1427.00	20.40	37596.71	\N	142.70
164	195	84	1	отменен	2025-10-26 00:00:00	\N	709.00	10.10	48403.64	\N	70.90
165	197	21	5	назначен	2025-10-15 00:00:00	\N	79.00	1.10	15792.95	\N	7.90
166	198	38	3	отменен	2025-10-01 00:00:00	\N	715.00	10.20	41427.94	\N	71.50
167	199	60	2	завершен	2025-08-24 00:00:00	2025-08-28 00:00:00	510.00	7.30	33044.91	\N	51.00
168	200	96	3	в_процессе	2025-11-06 00:00:00	\N	756.00	10.80	22694.29	\N	75.60
169	201	67	5	завершен	2025-11-23 00:00:00	2025-11-25 00:00:00	959.00	13.70	35403.36	\N	95.90
170	202	91	1	завершен	2025-09-20 00:00:00	2025-09-22 00:00:00	343.00	4.90	44163.28	\N	34.30
171	204	76	1	в_процессе	2025-08-20 00:00:00	\N	1942.00	27.70	9039.56	\N	194.20
172	205	26	3	завершен	2025-12-12 00:00:00	2025-12-22 00:00:00	1400.00	20.00	26435.64	\N	140.00
173	206	19	5	назначен	2025-07-29 00:00:00	\N	1080.00	15.40	15025.30	\N	108.00
174	208	54	1	отменен	2025-10-28 00:00:00	\N	265.00	3.80	48101.05	\N	26.50
175	209	73	5	в_процессе	2025-07-25 00:00:00	\N	1083.00	15.50	42734.97	\N	108.30
176	210	11	5	назначен	2025-12-10 00:00:00	\N	1380.00	19.70	46851.82	\N	138.00
177	211	33	1	назначен	2025-12-11 00:00:00	\N	586.00	8.40	20322.62	\N	58.60
178	212	49	2	завершен	2025-09-18 00:00:00	2025-10-03 00:00:00	1268.00	18.10	7411.99	\N	126.80
179	213	99	1	отменен	2025-10-11 00:00:00	\N	650.00	9.30	16509.10	\N	65.00
180	214	74	3	отменен	2025-08-16 00:00:00	\N	478.00	6.80	18184.38	\N	47.80
181	215	31	5	в_процессе	2025-08-22 00:00:00	\N	644.00	9.20	32458.65	\N	64.40
182	216	26	4	в_процессе	2025-11-06 00:00:00	\N	315.00	4.50	45436.85	\N	31.50
183	217	95	1	в_процессе	2025-10-29 00:00:00	\N	367.00	5.20	12600.16	\N	36.70
184	218	73	4	завершен	2025-12-03 00:00:00	2025-12-12 00:00:00	692.00	9.90	31350.84	\N	69.20
185	219	15	5	завершен	2026-01-15 00:00:00	2026-01-19 00:00:00	609.00	8.70	19806.95	\N	60.90
186	220	44	2	назначен	2025-12-28 00:00:00	\N	1211.00	17.30	13031.72	\N	121.10
187	221	63	2	отменен	2025-08-10 00:00:00	\N	1467.00	21.00	28018.02	\N	146.70
188	222	37	4	завершен	2025-10-18 00:00:00	2025-11-02 00:00:00	829.00	11.80	39549.37	\N	82.90
189	224	71	4	назначен	2025-09-16 00:00:00	\N	693.00	9.90	42157.37	\N	69.30
190	225	31	2	в_процессе	2025-08-22 00:00:00	\N	1733.00	24.80	18819.97	\N	173.30
191	226	81	3	завершен	2025-12-22 00:00:00	2026-01-05 00:00:00	1856.00	26.50	26291.83	\N	185.60
192	227	31	1	отменен	2025-10-29 00:00:00	\N	1732.00	24.70	17998.53	\N	173.20
193	228	87	5	назначен	2025-12-26 00:00:00	\N	274.00	3.90	39507.05	\N	27.40
194	229	93	5	отменен	2025-08-08 00:00:00	\N	978.00	14.00	19825.09	\N	97.80
195	231	37	4	завершен	2025-08-02 00:00:00	2025-08-08 00:00:00	919.00	13.10	30267.81	\N	91.90
196	232	36	3	назначен	2026-01-06 00:00:00	\N	679.00	9.70	21143.39	\N	67.90
197	233	41	3	отменен	2025-08-25 00:00:00	\N	1295.00	18.50	41079.71	\N	129.50
198	234	83	1	отменен	2025-11-26 00:00:00	\N	1867.00	26.70	15513.01	\N	186.70
199	235	20	2	в_процессе	2025-10-03 00:00:00	\N	547.00	7.80	17169.48	\N	54.70
200	236	26	4	в_процессе	2025-10-27 00:00:00	\N	1825.00	26.10	24428.03	\N	182.50
201	237	12	4	в_процессе	2025-11-03 00:00:00	\N	856.00	12.20	45808.76	\N	85.60
202	238	40	1	в_процессе	2025-07-28 00:00:00	\N	1448.00	20.70	34355.35	\N	144.80
203	239	47	3	завершен	2025-12-02 00:00:00	2025-12-06 00:00:00	324.00	4.60	48850.84	\N	32.40
204	240	63	5	в_процессе	2025-09-13 00:00:00	\N	1427.00	20.40	10116.98	\N	142.70
205	241	52	4	назначен	2025-11-01 00:00:00	\N	1636.00	23.40	29482.34	\N	163.60
206	242	68	5	назначен	2025-07-25 00:00:00	\N	1484.00	21.20	37664.40	\N	148.40
207	243	92	5	назначен	2025-11-07 00:00:00	\N	304.00	4.30	23395.11	\N	30.40
208	244	13	3	отменен	2025-12-01 00:00:00	\N	1976.00	28.20	5847.72	\N	197.60
209	246	99	4	назначен	2025-11-21 00:00:00	\N	1563.00	22.30	18167.60	\N	156.30
210	247	45	5	в_процессе	2025-10-06 00:00:00	\N	1812.00	25.90	28519.00	\N	181.20
211	249	47	2	завершен	2026-01-07 00:00:00	2026-01-21 00:00:00	568.00	8.10	13906.41	\N	56.80
212	250	54	5	в_процессе	2025-12-28 00:00:00	\N	1230.00	17.60	10641.19	\N	123.00
213	251	1	1	завершен	2025-12-02 00:00:00	2025-12-07 00:00:00	1620.00	23.10	12316.98	\N	162.00
214	253	99	3	завершен	2025-11-02 00:00:00	2025-11-14 00:00:00	1837.00	26.20	14776.50	\N	183.70
215	254	56	5	в_процессе	2025-10-20 00:00:00	\N	591.00	8.40	49388.88	\N	59.10
216	256	6	5	отменен	2025-08-20 00:00:00	\N	1714.00	24.50	19401.19	\N	171.40
217	257	38	1	завершен	2025-10-11 00:00:00	2025-10-18 00:00:00	1210.00	17.30	9694.34	\N	121.00
218	258	10	4	назначен	2025-10-07 00:00:00	\N	887.00	12.70	44580.53	\N	88.70
219	259	8	1	завершен	2025-11-28 00:00:00	2025-12-07 00:00:00	1842.00	26.30	27803.93	\N	184.20
220	260	46	5	завершен	2025-07-29 00:00:00	2025-08-11 00:00:00	265.00	3.80	14706.29	\N	26.50
221	262	31	1	назначен	2025-09-19 00:00:00	\N	1236.00	17.70	17582.25	\N	123.60
222	263	77	4	завершен	2025-08-07 00:00:00	2025-08-09 00:00:00	1619.00	23.10	37023.38	\N	161.90
223	264	37	3	в_процессе	2025-08-23 00:00:00	\N	177.00	2.50	23575.31	\N	17.70
224	265	52	1	в_процессе	2025-09-04 00:00:00	\N	1889.00	27.00	39689.83	\N	188.90
225	266	25	5	завершен	2025-11-11 00:00:00	2025-11-18 00:00:00	1260.00	18.00	48679.43	\N	126.00
226	267	1	5	назначен	2026-01-18 00:00:00	\N	666.00	9.50	33198.94	\N	66.60
227	269	91	5	назначен	2025-10-23 00:00:00	\N	687.00	9.80	23749.84	\N	68.70
228	270	81	1	в_процессе	2025-12-22 00:00:00	\N	1621.00	23.20	31773.53	\N	162.10
229	271	79	1	отменен	2025-12-24 00:00:00	\N	968.00	13.80	37283.22	\N	96.80
230	272	85	2	отменен	2025-12-12 00:00:00	\N	147.00	2.10	10662.86	\N	14.70
231	274	58	3	назначен	2025-12-26 00:00:00	\N	105.00	1.50	46602.73	\N	10.50
232	275	20	1	в_процессе	2026-01-05 00:00:00	\N	924.00	13.20	23084.81	\N	92.40
233	276	11	4	завершен	2025-09-10 00:00:00	2025-09-12 00:00:00	1412.00	20.20	5792.45	\N	141.20
234	277	28	2	завершен	2025-10-18 00:00:00	2025-10-23 00:00:00	1618.00	23.10	28199.14	\N	161.80
235	278	26	3	отменен	2025-08-12 00:00:00	\N	1811.00	25.90	38938.35	\N	181.10
236	279	34	5	в_процессе	2025-09-11 00:00:00	\N	1384.00	19.80	46088.20	\N	138.40
237	280	49	3	завершен	2025-12-12 00:00:00	2025-12-24 00:00:00	749.00	10.70	7577.30	\N	74.90
238	281	76	3	назначен	2026-01-05 00:00:00	\N	1891.00	27.00	40418.41	\N	189.10
239	282	88	5	в_процессе	2025-08-10 00:00:00	\N	750.00	10.70	38650.70	\N	75.00
240	283	57	4	завершен	2025-11-22 00:00:00	2025-11-24 00:00:00	739.00	10.60	26322.42	\N	73.90
241	285	55	1	отменен	2025-11-24 00:00:00	\N	979.00	14.00	47913.44	\N	97.90
242	286	36	1	завершен	2025-12-23 00:00:00	2026-01-06 00:00:00	1939.00	27.70	49680.84	\N	193.90
243	287	8	3	завершен	2026-01-19 00:00:00	2026-02-03 00:00:00	1423.00	20.30	47643.97	\N	142.30
244	288	11	3	завершен	2026-01-16 00:00:00	2026-01-30 00:00:00	266.00	3.80	41357.53	\N	26.60
245	290	46	2	назначен	2025-08-22 00:00:00	\N	142.00	2.00	14527.90	\N	14.20
246	293	83	3	в_процессе	2025-10-25 00:00:00	\N	1928.00	27.50	42457.53	\N	192.80
247	294	18	1	назначен	2025-11-14 00:00:00	\N	353.00	5.00	17782.40	\N	35.30
248	295	82	5	завершен	2025-11-17 00:00:00	2025-11-28 00:00:00	1169.00	16.70	43459.14	\N	116.90
249	296	4	1	в_процессе	2025-12-02 00:00:00	\N	1157.00	16.50	8207.04	\N	115.70
250	297	26	3	назначен	2025-09-09 00:00:00	\N	1313.00	18.80	7984.44	\N	131.30
251	298	8	2	завершен	2025-08-11 00:00:00	2025-08-16 00:00:00	748.00	10.70	25605.20	\N	74.80
252	300	88	4	отменен	2025-12-22 00:00:00	\N	713.00	10.20	49377.23	\N	71.30
253	303	62	3	назначен	2025-09-29 00:00:00	\N	428.00	6.10	15436.52	\N	42.80
254	304	43	4	отменен	2025-08-18 00:00:00	\N	174.00	2.50	41321.03	\N	17.40
255	305	58	4	завершен	2025-11-23 00:00:00	2025-12-01 00:00:00	1282.00	18.30	7125.12	\N	128.20
256	306	9	4	отменен	2025-12-04 00:00:00	\N	263.00	3.80	22033.06	\N	26.30
257	307	48	4	завершен	2025-08-19 00:00:00	2025-08-28 00:00:00	461.00	6.60	5512.38	\N	46.10
258	308	30	1	в_процессе	2025-11-18 00:00:00	\N	1938.00	27.70	20326.37	\N	193.80
259	309	59	5	отменен	2025-08-08 00:00:00	\N	956.00	13.70	27640.12	\N	95.60
260	310	72	1	назначен	2025-11-15 00:00:00	\N	825.00	11.80	8906.26	\N	82.50
261	311	80	4	отменен	2025-10-27 00:00:00	\N	704.00	10.10	7823.06	\N	70.40
262	313	25	4	в_процессе	2025-10-24 00:00:00	\N	1448.00	20.70	11791.60	\N	144.80
263	316	44	4	отменен	2025-08-16 00:00:00	\N	1879.00	26.80	5342.33	\N	187.90
264	318	93	1	назначен	2025-10-12 00:00:00	\N	1769.00	25.30	24007.88	\N	176.90
265	319	63	2	назначен	2025-09-07 00:00:00	\N	359.00	5.10	40062.22	\N	35.90
266	320	81	5	отменен	2025-08-15 00:00:00	\N	1663.00	23.80	9723.17	\N	166.30
267	321	45	1	назначен	2025-09-05 00:00:00	\N	1587.00	22.70	28007.28	\N	158.70
268	322	45	5	отменен	2025-09-24 00:00:00	\N	674.00	9.60	31006.36	\N	67.40
269	323	77	4	назначен	2025-10-18 00:00:00	\N	1849.00	26.40	6443.84	\N	184.90
270	324	63	1	назначен	2025-09-07 00:00:00	\N	527.00	7.50	24611.20	\N	52.70
271	325	6	1	в_процессе	2025-08-26 00:00:00	\N	756.00	10.80	31669.39	\N	75.60
272	326	51	3	завершен	2025-11-09 00:00:00	2025-11-12 00:00:00	490.00	7.00	45776.28	\N	49.00
273	327	86	4	в_процессе	2025-10-18 00:00:00	\N	1564.00	22.30	15855.71	\N	156.40
274	328	5	2	в_процессе	2025-10-08 00:00:00	\N	1816.00	25.90	46631.92	\N	181.60
275	329	50	5	в_процессе	2025-10-10 00:00:00	\N	1575.00	22.50	22702.99	\N	157.50
276	330	22	5	отменен	2025-09-11 00:00:00	\N	1481.00	21.20	41417.18	\N	148.10
277	331	38	3	в_процессе	2025-10-08 00:00:00	\N	1714.00	24.50	34120.44	\N	171.40
278	333	18	1	завершен	2025-12-29 00:00:00	2026-01-11 00:00:00	1253.00	17.90	15757.85	\N	125.30
279	334	20	4	отменен	2025-10-12 00:00:00	\N	1845.00	26.40	10844.43	\N	184.50
280	335	30	1	в_процессе	2025-09-28 00:00:00	\N	1000.00	14.30	30437.97	\N	100.00
281	336	45	3	отменен	2025-09-23 00:00:00	\N	1056.00	15.10	12710.13	\N	105.60
282	337	35	4	завершен	2025-10-19 00:00:00	2025-10-30 00:00:00	1438.00	20.50	27707.55	\N	143.80
283	339	2	1	назначен	2025-11-02 00:00:00	\N	387.00	5.50	19852.16	\N	38.70
284	340	11	1	отменен	2025-10-23 00:00:00	\N	871.00	12.40	6100.49	\N	87.10
285	341	66	5	в_процессе	2026-01-07 00:00:00	\N	1599.00	22.80	31579.58	\N	159.90
286	344	53	1	завершен	2025-08-11 00:00:00	2025-08-25 00:00:00	712.00	10.20	5693.53	\N	71.20
287	345	69	3	завершен	2025-08-29 00:00:00	2025-09-03 00:00:00	961.00	13.70	21757.63	\N	96.10
288	346	78	1	назначен	2025-11-28 00:00:00	\N	597.00	8.50	41747.09	\N	59.70
289	347	68	2	завершен	2025-10-29 00:00:00	2025-11-05 00:00:00	1920.00	27.40	28303.74	\N	192.00
290	348	3	3	в_процессе	2026-01-06 00:00:00	\N	1592.00	22.70	5471.54	\N	159.20
291	349	22	4	в_процессе	2025-11-04 00:00:00	\N	1915.00	27.40	17201.25	\N	191.50
292	352	77	1	в_процессе	2025-10-14 00:00:00	\N	1922.00	27.50	14017.66	\N	192.20
293	353	90	1	завершен	2025-09-20 00:00:00	2025-09-28 00:00:00	1307.00	18.70	24021.51	\N	130.70
294	354	16	3	завершен	2025-12-31 00:00:00	2026-01-08 00:00:00	403.00	5.80	42006.70	\N	40.30
295	355	12	2	отменен	2025-08-03 00:00:00	\N	1747.00	25.00	41772.16	\N	174.70
296	356	3	2	назначен	2025-08-14 00:00:00	\N	697.00	10.00	30002.56	\N	69.70
297	357	86	3	отменен	2025-11-16 00:00:00	\N	899.00	12.80	43919.94	\N	89.90
298	358	93	3	в_процессе	2025-08-24 00:00:00	\N	663.00	9.50	31833.27	\N	66.30
299	360	98	5	завершен	2025-12-16 00:00:00	2025-12-30 00:00:00	640.00	9.10	14038.28	\N	64.00
300	361	63	1	отменен	2025-09-08 00:00:00	\N	463.00	6.60	17135.01	\N	46.30
301	362	4	3	завершен	2026-01-03 00:00:00	2026-01-11 00:00:00	350.00	5.00	20177.70	\N	35.00
302	363	84	3	в_процессе	2025-08-27 00:00:00	\N	150.00	2.10	12300.26	\N	15.00
303	364	98	4	отменен	2025-08-04 00:00:00	\N	1967.00	28.10	38925.17	\N	196.70
304	365	9	3	назначен	2025-12-28 00:00:00	\N	898.00	12.80	24316.78	\N	89.80
305	366	54	1	отменен	2025-09-02 00:00:00	\N	833.00	11.90	30396.18	\N	83.30
306	367	74	2	отменен	2026-01-12 00:00:00	\N	1415.00	20.20	11367.24	\N	141.50
307	368	69	2	отменен	2025-11-09 00:00:00	\N	746.00	10.70	34414.01	\N	74.60
308	370	63	3	назначен	2025-08-11 00:00:00	\N	1867.00	26.70	18682.89	\N	186.70
309	371	74	5	отменен	2025-12-08 00:00:00	\N	203.00	2.90	44547.53	\N	20.30
310	373	56	2	отменен	2025-11-21 00:00:00	\N	493.00	7.00	30494.00	\N	49.30
311	374	20	2	в_процессе	2025-11-27 00:00:00	\N	566.00	8.10	47216.21	\N	56.60
312	375	9	1	назначен	2026-01-19 00:00:00	\N	1440.00	20.60	18075.59	\N	144.00
313	377	15	3	завершен	2025-08-25 00:00:00	2025-08-31 00:00:00	746.00	10.70	13701.19	\N	74.60
314	378	11	4	в_процессе	2025-09-01 00:00:00	\N	599.00	8.60	38955.50	\N	59.90
315	381	3	3	отменен	2025-10-08 00:00:00	\N	882.00	12.60	16875.15	\N	88.20
316	382	68	4	завершен	2025-11-02 00:00:00	2025-11-15 00:00:00	323.00	4.60	15642.49	\N	32.30
317	384	100	3	отменен	2025-08-24 00:00:00	\N	502.00	7.20	42361.93	\N	50.20
318	385	67	1	отменен	2025-12-07 00:00:00	\N	1559.00	22.30	17923.80	\N	155.90
319	386	62	3	завершен	2025-12-22 00:00:00	2026-01-03 00:00:00	1584.00	22.60	16973.78	\N	158.40
320	387	88	2	завершен	2025-11-20 00:00:00	2025-11-29 00:00:00	1511.00	21.60	24083.81	\N	151.10
321	388	32	4	в_процессе	2025-09-07 00:00:00	\N	690.00	9.90	40721.75	\N	69.00
322	389	54	3	в_процессе	2025-08-02 00:00:00	\N	1025.00	14.60	15084.32	\N	102.50
323	390	86	1	завершен	2025-08-29 00:00:00	2025-09-05 00:00:00	1764.00	25.20	31862.19	\N	176.40
324	391	47	4	назначен	2025-12-17 00:00:00	\N	368.00	5.30	34336.41	\N	36.80
325	392	31	5	отменен	2025-08-26 00:00:00	\N	1158.00	16.50	25915.87	\N	115.80
326	394	92	1	в_процессе	2025-11-21 00:00:00	\N	1695.00	24.20	47671.55	\N	169.50
327	396	21	2	в_процессе	2025-08-07 00:00:00	\N	1041.00	14.90	12900.27	\N	104.10
328	397	10	1	назначен	2025-11-29 00:00:00	\N	1483.00	21.20	44672.80	\N	148.30
329	398	35	5	назначен	2025-12-09 00:00:00	\N	536.00	7.70	11738.63	\N	53.60
330	399	41	2	отменен	2025-10-08 00:00:00	\N	1189.00	17.00	7825.03	\N	118.90
331	401	58	2	назначен	2025-08-26 00:00:00	\N	148.00	2.10	13958.89	\N	14.80
332	402	96	4	назначен	2026-01-06 00:00:00	\N	400.00	5.70	42299.47	\N	40.00
333	403	28	5	назначен	2026-01-07 00:00:00	\N	335.00	4.80	44991.97	\N	33.50
334	404	97	5	завершен	2026-01-09 00:00:00	2026-01-23 00:00:00	1029.00	14.70	6907.33	\N	102.90
335	405	97	1	завершен	2025-08-07 00:00:00	2025-08-19 00:00:00	981.00	14.00	13637.18	\N	98.10
336	407	47	3	в_процессе	2025-08-20 00:00:00	\N	349.00	5.00	36030.28	\N	34.90
337	408	100	5	назначен	2026-01-10 00:00:00	\N	94.00	1.30	5859.96	\N	9.40
338	409	100	4	в_процессе	2025-09-02 00:00:00	\N	51.00	0.70	32883.85	\N	5.10
339	410	1	4	в_процессе	2025-12-29 00:00:00	\N	1604.00	22.90	34708.41	\N	160.40
340	412	96	2	отменен	2025-07-31 00:00:00	\N	818.00	11.70	11236.40	\N	81.80
341	414	76	1	завершен	2025-09-01 00:00:00	2025-09-09 00:00:00	1428.00	20.40	16928.60	\N	142.80
342	416	19	1	отменен	2025-11-20 00:00:00	\N	1849.00	26.40	8463.15	\N	184.90
343	417	47	3	назначен	2025-07-26 00:00:00	\N	327.00	4.70	19487.87	\N	32.70
344	419	21	5	назначен	2025-09-14 00:00:00	\N	805.00	11.50	23687.23	\N	80.50
345	420	88	5	в_процессе	2025-08-06 00:00:00	\N	460.00	6.60	47984.18	\N	46.00
346	421	91	3	назначен	2025-08-19 00:00:00	\N	1735.00	24.80	27586.98	\N	173.50
347	422	14	1	завершен	2026-01-09 00:00:00	2026-01-11 00:00:00	1031.00	14.70	20220.11	\N	103.10
348	423	28	4	отменен	2025-09-26 00:00:00	\N	1733.00	24.80	19831.26	\N	173.30
349	425	78	1	завершен	2025-11-18 00:00:00	2025-12-01 00:00:00	363.00	5.20	31732.92	\N	36.30
350	426	11	3	назначен	2025-09-26 00:00:00	\N	694.00	9.90	16842.10	\N	69.40
351	427	5	2	назначен	2025-12-15 00:00:00	\N	776.00	11.10	34445.77	\N	77.60
352	429	58	5	в_процессе	2025-12-18 00:00:00	\N	61.00	0.90	36117.25	\N	6.10
353	430	96	2	отменен	2025-12-26 00:00:00	\N	1541.00	22.00	14919.02	\N	154.10
354	431	32	5	отменен	2025-08-12 00:00:00	\N	1297.00	18.50	5358.55	\N	129.70
355	432	90	5	в_процессе	2025-09-11 00:00:00	\N	1129.00	16.10	31710.08	\N	112.90
356	433	98	3	завершен	2025-10-01 00:00:00	2025-10-13 00:00:00	1828.00	26.10	37102.06	\N	182.80
357	434	100	5	назначен	2025-09-09 00:00:00	\N	1830.00	26.10	11592.90	\N	183.00
358	435	80	4	отменен	2025-09-19 00:00:00	\N	546.00	7.80	13480.78	\N	54.60
359	436	14	1	отменен	2025-11-02 00:00:00	\N	1280.00	18.30	23835.72	\N	128.00
360	437	90	1	назначен	2025-12-04 00:00:00	\N	811.00	11.60	34226.64	\N	81.10
361	438	99	4	завершен	2025-11-20 00:00:00	2025-11-26 00:00:00	1982.00	28.30	44289.53	\N	198.20
362	439	14	5	завершен	2025-12-27 00:00:00	2026-01-04 00:00:00	749.00	10.70	22148.66	\N	74.90
363	441	28	1	завершен	2025-12-19 00:00:00	2026-01-02 00:00:00	1333.00	19.00	49645.54	\N	133.30
364	442	32	4	назначен	2025-10-12 00:00:00	\N	1844.00	26.30	39735.68	\N	184.40
365	443	51	4	в_процессе	2025-08-19 00:00:00	\N	1054.00	15.10	29360.13	\N	105.40
366	444	55	1	отменен	2026-01-04 00:00:00	\N	941.00	13.40	9427.86	\N	94.10
367	446	1	4	назначен	2025-12-26 00:00:00	\N	1753.00	25.00	49807.81	\N	175.30
368	447	93	1	отменен	2025-12-15 00:00:00	\N	822.00	11.70	38867.59	\N	82.20
369	448	64	2	в_процессе	2025-07-30 00:00:00	\N	1324.00	18.90	15837.77	\N	132.40
370	449	34	2	назначен	2025-08-16 00:00:00	\N	422.00	6.00	36937.98	\N	42.20
371	450	68	1	в_процессе	2025-12-08 00:00:00	\N	1896.00	27.10	8282.52	\N	189.60
372	452	22	5	отменен	2025-10-22 00:00:00	\N	1198.00	17.10	39841.30	\N	119.80
373	453	30	4	в_процессе	2025-09-12 00:00:00	\N	553.00	7.90	23974.58	\N	55.30
374	454	49	2	завершен	2025-09-16 00:00:00	2025-09-25 00:00:00	1461.00	20.90	43609.22	\N	146.10
375	455	89	5	завершен	2025-12-19 00:00:00	2025-12-27 00:00:00	1349.00	19.30	12265.88	\N	134.90
376	456	93	3	назначен	2025-09-21 00:00:00	\N	1907.00	27.20	45143.44	\N	190.70
377	457	22	2	в_процессе	2025-12-30 00:00:00	\N	1679.00	24.00	21112.62	\N	167.90
378	458	3	1	завершен	2025-12-29 00:00:00	2026-01-05 00:00:00	1398.00	20.00	47511.34	\N	139.80
379	459	71	2	в_процессе	2025-11-28 00:00:00	\N	335.00	4.80	36414.24	\N	33.50
380	460	31	5	завершен	2025-10-02 00:00:00	2025-10-07 00:00:00	1801.00	25.70	30704.40	\N	180.10
381	461	44	3	в_процессе	2025-12-10 00:00:00	\N	938.00	13.40	48595.06	\N	93.80
382	462	42	1	завершен	2025-11-15 00:00:00	2025-11-20 00:00:00	1359.00	19.40	49195.15	\N	135.90
383	463	24	2	назначен	2025-10-24 00:00:00	\N	1761.00	25.20	43766.31	\N	176.10
384	464	54	1	завершен	2025-09-23 00:00:00	2025-10-06 00:00:00	532.00	7.60	25275.81	\N	53.20
385	465	5	1	завершен	2025-09-22 00:00:00	2025-10-04 00:00:00	1867.00	26.70	27699.69	\N	186.70
386	466	26	1	завершен	2025-12-09 00:00:00	2025-12-20 00:00:00	817.00	11.70	7205.59	\N	81.70
387	467	86	3	отменен	2025-09-02 00:00:00	\N	68.00	1.00	44173.01	\N	6.80
388	468	63	1	отменен	2025-10-08 00:00:00	\N	1427.00	20.40	19274.30	\N	142.70
389	469	22	2	назначен	2025-11-17 00:00:00	\N	774.00	11.10	42226.06	\N	77.40
390	470	20	5	отменен	2025-09-23 00:00:00	\N	1724.00	24.60	40304.86	\N	172.40
391	471	12	2	в_процессе	2025-09-18 00:00:00	\N	974.00	13.90	12427.77	\N	97.40
392	475	8	4	отменен	2025-11-14 00:00:00	\N	611.00	8.70	46277.20	\N	61.10
393	476	80	3	отменен	2025-07-31 00:00:00	\N	1828.00	26.10	28878.78	\N	182.80
394	477	33	4	назначен	2025-07-31 00:00:00	\N	1748.00	25.00	12637.92	\N	174.80
395	478	63	5	завершен	2025-07-26 00:00:00	2025-07-28 00:00:00	565.00	8.10	41830.60	\N	56.50
396	479	71	5	в_процессе	2025-12-31 00:00:00	\N	196.00	2.80	40149.94	\N	19.60
397	480	26	4	завершен	2025-12-31 00:00:00	2026-01-06 00:00:00	249.00	3.60	13013.65	\N	24.90
398	481	40	4	назначен	2025-11-20 00:00:00	\N	1604.00	22.90	27833.95	\N	160.40
399	482	93	5	в_процессе	2025-08-30 00:00:00	\N	348.00	5.00	27323.66	\N	34.80
400	483	99	5	в_процессе	2025-11-19 00:00:00	\N	508.00	7.30	46701.71	\N	50.80
401	485	8	1	в_процессе	2025-08-20 00:00:00	\N	799.00	11.40	36567.80	\N	79.90
402	486	94	1	завершен	2025-12-18 00:00:00	2025-12-24 00:00:00	810.00	11.60	47024.50	\N	81.00
403	487	41	2	назначен	2025-11-21 00:00:00	\N	1337.00	19.10	22909.14	\N	133.70
404	488	64	1	в_процессе	2025-10-31 00:00:00	\N	1232.00	17.60	31906.52	\N	123.20
405	489	86	1	в_процессе	2025-11-05 00:00:00	\N	373.00	5.30	10146.27	\N	37.30
406	490	20	4	отменен	2025-08-30 00:00:00	\N	505.00	7.20	47139.92	\N	50.50
407	491	36	5	отменен	2025-09-04 00:00:00	\N	1009.00	14.40	16313.24	\N	100.90
408	492	50	3	завершен	2025-10-17 00:00:00	2025-10-30 00:00:00	1930.00	27.60	39360.37	\N	193.00
409	493	55	4	завершен	2025-07-26 00:00:00	2025-08-03 00:00:00	1757.00	25.10	33417.75	\N	175.70
410	494	37	1	отменен	2025-08-04 00:00:00	\N	1367.00	19.50	46765.35	\N	136.70
411	495	84	3	в_процессе	2025-11-09 00:00:00	\N	103.00	1.50	19886.13	\N	10.30
412	496	33	3	в_процессе	2025-08-22 00:00:00	\N	685.00	9.80	38076.97	\N	68.50
413	497	49	2	назначен	2025-11-27 00:00:00	\N	1638.00	23.40	29770.39	\N	163.80
414	500	19	5	назначен	2025-09-10 00:00:00	\N	1069.00	15.30	45981.24	\N	106.90
\.


--
-- Data for Name: грузы; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."грузы" ("ид_груз", "номер_груза", "описание", "вес_кг", "объем_куб_м", "ид_клиент", "ид_склад_откуда", "ид_склад_куда", "ид_статус", "стоимость_руб", "стоимость_доставки_руб", "дата_создания", "дата_должна_прибыть", "дата_фактическая_доставка", "примечание", "страховка_руб", "хрупкий", "температурный_режим") FROM stdin;
501	C202500001	Мебель, 30 мест	1019.42	33.88	34	11	13	6	458413.87	49657.92	2025-07-28 13:02:23	2025-08-08	2025-08-17 13:02:23	Срочно	9168.28	t	обычный
502	C202500002	Электроника, 26 мест	1219.41	35.01	28	11	10	6	454574.31	34912.07	2025-07-27 13:02:23	2025-08-04	2025-08-13 13:02:23	Срочно	9091.49	f	обычный
503	C202500003	Электроника, 4 мест	2548.32	43.63	5	10	9	5	326617.06	45139.64	2025-09-26 13:02:23	2025-10-06	\N	\N	6532.34	f	обычный
504	C202500004	Электроника, 20 мест	93.45	21.79	37	6	20	7	122342.61	18266.40	2026-01-20 13:02:23	2026-02-01	2026-02-09 13:02:23	\N	2446.85	t	обычный
505	C202500005	Техника, 19 мест	1912.66	23.11	35	16	7	6	280380.02	34295.61	2025-09-24 13:02:23	2025-09-30	2025-10-03 13:02:23	\N	5607.60	f	обычный
506	C202500006	Одежда, 33 мест	1091.04	7.04	30	12	8	2	466192.01	39391.50	2025-12-23 13:02:23	2025-12-29	\N	\N	9323.84	f	обычный
507	C202500007	Запчасти, 26 мест	3221.34	14.74	6	14	6	3	260337.12	19505.49	2025-09-05 13:02:23	2025-09-18	\N	\N	5206.74	f	холодильный
508	C202500008	Стройматериалы, 40 мест	2662.05	23.55	12	8	4	4	121140.01	31791.04	2025-10-24 13:02:23	2025-11-07	\N	\N	2422.80	f	обычный
509	C202500009	Игрушки, 1 мест	1059.30	41.51	6	10	7	3	281294.68	39256.79	2025-11-02 13:02:23	2025-11-07	\N	\N	5625.89	f	обычный
510	C202500010	Стройматериалы, 42 мест	268.26	17.78	39	7	14	4	125794.18	3033.58	2025-08-06 13:02:23	2025-08-19	\N	Срочно	2515.88	f	холодильный
511	C202500011	Мебель, 4 мест	154.23	26.11	32	6	4	2	79917.34	10807.72	2025-09-05 13:02:23	2025-09-18	\N	\N	1598.35	f	холодильный
512	C202500012	Мебель, 19 мест	3174.00	48.05	33	10	3	6	352486.09	29238.85	2025-11-17 13:02:23	2025-12-01	2025-12-02 13:02:23	\N	7049.72	f	холодильный
513	C202500013	Электроника, 27 мест	3823.39	19.73	44	2	8	1	312676.52	9423.50	2026-01-07 13:02:23	2026-01-21	\N	\N	6253.53	f	обычный
514	C202500014	Электроника, 25 мест	2121.14	40.12	6	15	12	4	85122.68	30477.90	2025-08-11 13:02:23	2025-08-24	\N	\N	1702.45	f	обычный
515	C202500015	Мебель, 21 мест	2213.33	35.41	5	16	9	3	409374.72	22557.51	2025-09-21 13:02:23	2025-09-27	\N	\N	8187.49	f	обычный
516	C202500016	Игрушки, 35 мест	1546.51	35.35	27	18	9	3	294121.57	18421.12	2025-09-16 13:02:23	2025-09-25	\N	\N	5882.43	f	холодильный
517	C202500017	Стройматериалы, 42 мест	3668.86	25.02	50	7	10	5	117981.92	43787.42	2025-07-27 13:02:23	2025-08-08	\N	\N	2359.64	t	холодильный
518	C202500018	Электроника, 7 мест	345.22	11.50	9	12	15	2	90637.27	34517.91	2025-11-18 13:02:23	2025-11-29	\N	\N	1812.75	f	обычный
519	C202500019	Стройматериалы, 44 мест	2599.23	49.35	26	17	10	4	46245.97	36226.68	2025-11-30 13:02:23	2025-12-10	\N	Срочно	924.92	t	обычный
520	C202500020	Одежда, 43 мест	2538.78	17.17	50	19	2	5	28164.06	4265.84	2025-12-02 13:02:23	2025-12-09	\N	\N	563.28	f	холодильный
521	C202500021	Продукты, 49 мест	621.86	25.60	24	6	12	5	290826.99	29938.12	2025-09-15 13:02:23	2025-09-25	\N	\N	5816.54	t	обычный
522	C202500022	Запчасти, 5 мест	1443.27	17.43	16	9	17	2	98664.30	23110.07	2025-07-25 13:02:23	2025-08-03	\N	\N	1973.29	f	обычный
523	C202500023	Продукты, 1 мест	3909.25	29.28	28	4	12	3	477030.09	48529.54	2025-11-27 13:02:23	2025-12-06	\N	\N	9540.60	f	холодильный
524	C202500024	Мебель, 16 мест	1548.87	49.83	50	16	9	4	87892.13	38310.59	2026-01-05 13:02:23	2026-01-15	\N	\N	1757.84	t	обычный
525	C202500025	Косметика, 12 мест	2352.11	9.51	43	1	8	4	447494.12	26095.46	2025-07-25 13:02:23	2025-08-03	\N	\N	8949.88	f	обычный
526	C202500026	Книги, 48 мест	3510.95	20.11	19	14	16	4	103114.14	48270.25	2025-08-24 13:02:23	2025-09-07	\N	\N	2062.28	t	обычный
527	C202500027	Запчасти, 28 мест	2871.62	38.55	1	3	18	4	405442.81	46658.39	2025-08-27 13:02:23	2025-09-06	\N	Срочно	8108.86	t	обычный
528	C202500028	Косметика, 16 мест	3541.84	16.10	48	19	10	5	301755.22	22864.72	2025-11-16 13:02:23	2025-11-30	\N	\N	6035.10	f	обычный
529	C202500029	Техника, 30 мест	4001.83	30.95	6	10	9	5	225843.18	22038.21	2026-01-08 13:02:23	2026-01-18	\N	\N	4516.86	f	холодильный
530	C202500030	Стройматериалы, 25 мест	1295.02	39.61	17	19	16	7	452153.14	46261.67	2025-08-03 13:02:23	2025-08-13	2025-08-23 13:02:23	\N	9043.06	f	обычный
531	C202500031	Одежда, 2 мест	1715.71	18.64	26	3	8	3	90476.51	18735.09	2025-12-20 13:02:23	2025-12-30	\N	Срочно	1809.53	f	обычный
532	C202500032	Игрушки, 33 мест	3946.13	23.79	26	1	17	5	194156.99	17200.74	2025-09-25 13:02:23	2025-09-30	\N	\N	3883.14	t	холодильный
533	C202500033	Игрушки, 23 мест	2627.30	2.65	35	19	6	5	184305.97	21795.31	2026-01-09 13:02:23	2026-01-19	\N	\N	3686.12	f	обычный
534	C202500034	Запчасти, 5 мест	1430.88	22.27	41	14	20	6	420299.67	48097.25	2025-09-20 13:02:23	2025-09-26	2025-10-08 13:02:23	\N	8405.99	t	обычный
535	C202500035	Техника, 3 мест	2910.37	48.37	29	8	14	5	347757.12	23834.13	2025-11-30 13:02:23	2025-12-08	\N	\N	6955.14	f	обычный
536	C202500036	Косметика, 32 мест	880.55	34.44	10	20	18	3	127592.29	5982.22	2025-12-05 13:02:23	2025-12-11	\N	\N	2551.85	f	обычный
537	C202500037	Техника, 42 мест	3367.59	14.90	15	18	6	5	303346.27	29671.59	2025-11-21 13:02:23	2025-12-06	\N	Срочно	6066.93	f	обычный
538	C202500038	Стройматериалы, 49 мест	761.26	30.57	3	8	20	6	107205.55	32622.95	2025-10-02 13:02:23	2025-10-10	2025-10-14 13:02:23	\N	2144.11	f	обычный
539	C202500039	Одежда, 45 мест	378.83	25.18	19	5	19	4	85348.01	33383.08	2025-09-12 13:02:23	2025-09-27	\N	\N	1706.96	f	обычный
540	C202500040	Продукты, 1 мест	2330.67	2.02	26	5	16	6	212221.25	3901.78	2025-11-03 13:02:23	2025-11-14	2025-11-12 13:02:23	\N	4244.43	f	обычный
541	C202500041	Техника, 33 мест	2309.39	25.54	27	2	7	5	29578.72	29423.22	2025-10-07 13:02:23	2025-10-21	\N	Срочно	591.57	f	холодильный
542	C202500042	Стройматериалы, 22 мест	3335.45	21.59	17	4	11	4	377062.63	28679.52	2025-12-08 13:02:23	2025-12-14	\N	\N	7541.25	f	обычный
543	C202500043	Косметика, 1 мест	22.93	12.14	38	18	3	5	279610.21	27889.38	2025-11-12 13:02:23	2025-11-25	\N	\N	5592.20	f	обычный
544	C202500044	Стройматериалы, 11 мест	3949.25	16.01	30	19	6	3	258842.81	28424.35	2025-12-17 13:02:23	2025-12-25	\N	\N	5176.86	f	обычный
545	C202500045	Книги, 16 мест	2511.18	42.06	25	2	1	5	145162.37	17711.94	2025-09-17 13:02:23	2025-10-02	\N	\N	2903.25	f	обычный
546	C202500046	Электроника, 10 мест	698.27	12.62	17	19	17	2	440554.18	3231.86	2025-09-01 13:02:23	2025-09-16	\N	\N	8811.08	f	обычный
547	C202500047	Стройматериалы, 40 мест	2229.07	34.77	14	18	1	4	82314.04	6187.74	2025-08-07 13:02:23	2025-08-17	\N	\N	1646.28	f	холодильный
548	C202500048	Мебель, 7 мест	3438.63	4.73	5	9	1	5	470223.03	47701.52	2026-01-10 13:02:23	2026-01-20	\N	\N	9404.46	t	обычный
549	C202500049	Одежда, 43 мест	4074.51	7.37	27	10	18	3	151825.05	13925.45	2026-01-04 13:02:23	2026-01-14	\N	\N	3036.50	f	холодильный
550	C202500050	Техника, 18 мест	3091.39	25.89	26	4	2	3	44699.48	2718.01	2025-08-26 13:02:23	2025-09-06	\N	\N	893.99	t	обычный
551	C202500051	Стройматериалы, 47 мест	2415.17	20.76	35	7	9	5	163654.78	47598.79	2025-08-14 13:02:23	2025-08-25	\N	\N	3273.10	f	обычный
552	C202500052	Книги, 38 мест	3152.89	14.51	7	3	20	7	403863.11	22219.87	2025-11-28 13:02:23	2025-12-12	2025-12-18 13:02:23	Срочно	8077.26	t	холодильный
553	C202500053	Мебель, 32 мест	3710.00	40.16	48	1	7	3	166154.05	34808.64	2025-10-02 13:02:23	2025-10-09	\N	\N	3323.08	f	обычный
554	C202500054	Мебель, 37 мест	723.91	32.02	11	19	14	1	243436.81	10806.52	2025-11-25 13:02:23	2025-12-03	\N	\N	4868.74	f	обычный
555	C202500055	Продукты, 5 мест	3737.22	43.01	4	6	8	5	234655.14	9106.67	2025-10-01 13:02:23	2025-10-14	\N	\N	4693.10	f	обычный
556	C202500056	Продукты, 28 мест	2523.89	5.24	1	19	4	5	189172.08	5817.17	2025-08-13 13:02:23	2025-08-19	\N	\N	3783.44	f	обычный
557	C202500057	Стройматериалы, 35 мест	3839.69	31.77	5	20	10	4	140982.13	3154.71	2025-09-21 13:02:23	2025-10-04	\N	\N	2819.64	f	холодильный
558	C202500058	Запчасти, 3 мест	4835.03	24.17	41	12	19	5	115439.74	46553.99	2025-08-27 13:02:23	2025-09-03	\N	\N	2308.79	t	обычный
559	C202500059	Косметика, 14 мест	3757.33	43.65	47	7	17	4	142102.68	34938.95	2025-12-21 13:02:23	2026-01-04	\N	\N	2842.05	f	обычный
560	C202500060	Игрушки, 32 мест	2291.82	28.06	47	8	14	4	451765.17	2340.70	2026-01-18 13:02:23	2026-01-28	\N	\N	9035.30	f	обычный
561	C202500061	Запчасти, 44 мест	2644.40	49.47	20	13	17	4	177280.26	9752.20	2026-01-20 13:02:23	2026-01-28	\N	Срочно	3545.61	f	обычный
562	C202500062	Техника, 26 мест	3571.67	14.58	6	9	10	5	301503.54	28507.84	2025-09-18 13:02:23	2025-09-26	\N	Срочно	6030.07	t	обычный
563	C202500063	Игрушки, 1 мест	4362.68	39.38	42	11	15	3	376193.08	41846.31	2026-01-07 13:02:23	2026-01-12	\N	\N	7523.86	f	обычный
564	C202500064	Книги, 44 мест	691.87	13.87	13	7	15	3	270969.14	7943.04	2025-08-22 13:02:23	2025-09-01	\N	\N	5419.38	t	обычный
565	C202500065	Игрушки, 26 мест	4740.29	36.82	2	17	7	4	297506.76	35080.84	2025-07-26 13:02:23	2025-08-01	\N	Срочно	5950.14	f	обычный
566	C202500066	Техника, 41 мест	3560.83	42.51	14	17	5	1	425203.39	49273.50	2025-11-30 13:02:23	2025-12-09	\N	\N	8504.07	f	обычный
567	C202500067	Одежда, 18 мест	4627.40	46.77	27	16	5	4	28923.49	13065.18	2025-10-16 13:02:23	2025-10-23	\N	\N	578.47	f	обычный
568	C202500068	Игрушки, 9 мест	3184.16	22.29	39	14	12	3	470120.50	37422.56	2025-10-06 13:02:23	2025-10-15	\N	\N	9402.41	f	обычный
569	C202500069	Электроника, 46 мест	2214.96	23.70	17	11	9	4	59500.83	10204.08	2025-08-31 13:02:23	2025-09-13	\N	\N	1190.02	f	обычный
570	C202500070	Запчасти, 2 мест	4829.53	12.38	33	2	20	4	250197.53	33256.61	2025-08-21 13:02:23	2025-08-28	\N	Срочно	5003.95	t	обычный
571	C202500071	Продукты, 24 мест	3483.74	29.88	41	4	20	6	331115.83	22543.86	2025-09-09 13:02:23	2025-09-21	2025-09-14 13:02:23	\N	6622.32	f	обычный
572	C202500072	Одежда, 31 мест	4822.29	3.11	43	10	20	6	392519.04	21517.89	2025-12-22 13:02:23	2025-12-29	2025-12-31 13:02:23	\N	7850.38	f	обычный
573	C202500073	Электроника, 13 мест	1664.43	44.47	26	2	4	2	395228.35	18401.79	2025-09-23 13:02:23	2025-09-29	\N	\N	7904.57	f	обычный
574	C202500074	Стройматериалы, 23 мест	4164.57	46.87	4	7	18	5	433274.28	32147.10	2025-12-31 13:02:23	2026-01-09	\N	\N	8665.49	f	холодильный
575	C202500075	Мебель, 18 мест	1802.32	21.02	21	5	1	3	433447.27	16914.91	2025-09-21 13:02:23	2025-10-05	\N	\N	8668.95	f	обычный
576	C202500076	Запчасти, 28 мест	481.42	32.84	34	19	20	5	483122.12	37755.03	2025-11-21 13:02:23	2025-12-01	\N	\N	9662.44	f	обычный
577	C202500077	Электроника, 30 мест	283.86	34.19	7	3	14	4	379485.95	46991.98	2026-01-05 13:02:23	2026-01-14	\N	Срочно	7589.72	f	обычный
578	C202500078	Запчасти, 14 мест	2983.70	22.52	40	12	5	5	182003.88	7609.76	2025-12-21 13:02:23	2026-01-02	\N	Срочно	3640.08	f	холодильный
579	C202500079	Одежда, 42 мест	1550.21	44.72	28	3	5	2	392437.30	12722.57	2025-08-04 13:02:23	2025-08-12	\N	Срочно	7848.75	f	обычный
580	C202500080	Запчасти, 41 мест	3478.62	37.89	32	11	20	5	490075.80	29249.46	2025-10-23 13:02:23	2025-10-31	\N	\N	9801.52	t	обычный
581	C202500081	Стройматериалы, 2 мест	1875.27	45.41	7	2	11	4	289775.06	11370.78	2025-10-08 13:02:23	2025-10-22	\N	\N	5795.50	f	холодильный
582	C202500082	Одежда, 37 мест	1808.57	33.72	21	20	10	5	19560.29	5640.34	2025-10-04 13:02:23	2025-10-16	\N	Срочно	391.21	t	обычный
583	C202500083	Косметика, 10 мест	709.20	47.27	1	15	6	4	323735.78	22937.09	2025-11-28 13:02:23	2025-12-08	\N	\N	6474.72	f	холодильный
584	C202500084	Книги, 31 мест	1913.05	11.18	4	7	12	5	296692.97	40828.26	2025-10-11 13:02:23	2025-10-26	\N	\N	5933.86	t	холодильный
585	C202500085	Косметика, 22 мест	1441.72	15.96	14	7	6	3	445975.95	16807.99	2025-09-04 13:02:23	2025-09-09	\N	\N	8919.52	f	обычный
586	C202500086	Игрушки, 43 мест	1467.02	36.68	22	1	4	5	272760.82	21071.11	2025-11-11 13:02:23	2025-11-20	\N	\N	5455.22	t	обычный
587	C202500087	Книги, 21 мест	2949.70	4.85	7	5	7	5	206288.89	1083.99	2025-11-12 13:02:23	2025-11-18	\N	\N	4125.78	f	обычный
588	C202500088	Мебель, 43 мест	2513.38	26.01	9	16	12	5	118570.23	29553.82	2025-09-14 13:02:23	2025-09-26	\N	\N	2371.40	f	обычный
589	C202500089	Техника, 40 мест	1316.82	9.86	44	15	7	4	7942.03	49972.16	2025-09-30 13:02:23	2025-10-12	\N	\N	158.84	f	обычный
590	C202500090	Запчасти, 30 мест	806.96	25.11	29	5	8	4	336207.85	28897.82	2025-08-26 13:02:23	2025-09-02	\N	Срочно	6724.16	f	обычный
591	C202500091	Электроника, 7 мест	1875.48	21.12	31	17	11	5	53953.23	42580.11	2025-08-20 13:02:23	2025-08-31	\N	\N	1079.06	f	обычный
592	C202500092	Стройматериалы, 4 мест	2534.95	39.79	14	18	3	1	382357.39	24482.37	2025-09-19 13:02:23	2025-09-24	\N	\N	7647.15	f	обычный
593	C202500093	Электроника, 38 мест	4906.56	6.45	30	18	15	2	52740.99	49542.77	2025-08-21 13:02:23	2025-08-29	\N	\N	1054.82	f	холодильный
594	C202500094	Косметика, 34 мест	4088.69	22.43	14	20	11	4	189694.43	36082.04	2025-10-21 13:02:23	2025-10-26	\N	\N	3793.89	f	обычный
595	C202500095	Книги, 33 мест	3860.02	6.65	41	7	12	5	167715.62	7211.83	2025-08-12 13:02:23	2025-08-25	\N	Срочно	3354.31	t	обычный
596	C202500096	Косметика, 5 мест	697.32	10.35	23	8	14	3	457390.22	40434.52	2026-01-14 13:02:23	2026-01-25	\N	\N	9147.80	t	обычный
597	C202500097	Электроника, 38 мест	25.01	48.29	49	15	10	4	343272.99	42616.08	2025-09-22 13:02:23	2025-10-01	\N	Срочно	6865.46	t	холодильный
598	C202500098	Запчасти, 18 мест	1730.94	13.90	34	2	12	4	15487.52	18319.56	2025-09-29 13:02:23	2025-10-07	\N	Срочно	309.75	f	обычный
599	C202500099	Стройматериалы, 5 мест	3068.75	33.38	7	11	18	6	462213.09	36735.46	2026-01-18 13:02:23	2026-01-26	2026-01-23 13:02:23	Срочно	9244.26	f	обычный
600	C202500100	Книги, 31 мест	39.02	29.52	47	1	17	6	412129.95	23637.63	2025-11-18 13:02:23	2025-12-02	2025-12-02 13:02:23	\N	8242.60	f	обычный
601	C202500101	Запчасти, 14 мест	4768.56	24.88	47	3	15	5	231031.69	3960.49	2025-08-31 13:02:23	2025-09-14	\N	\N	4620.63	f	обычный
602	C202500102	Книги, 50 мест	1472.93	23.13	47	18	9	2	469151.65	48702.04	2025-10-04 13:02:23	2025-10-10	\N	\N	9383.03	f	обычный
603	C202500103	Запчасти, 8 мест	3671.84	14.86	38	17	12	5	246873.79	48015.27	2025-11-14 13:02:23	2025-11-19	\N	Срочно	4937.48	t	обычный
604	C202500104	Косметика, 28 мест	3695.66	8.96	45	1	3	1	55095.50	38939.25	2025-07-27 13:02:23	2025-08-05	\N	\N	1101.91	f	холодильный
605	C202500105	Стройматериалы, 35 мест	837.29	43.24	15	11	8	4	131843.82	4894.58	2025-12-02 13:02:23	2025-12-07	\N	Срочно	2636.88	t	обычный
606	C202500106	Запчасти, 39 мест	1151.68	12.73	27	16	19	5	467287.80	5706.62	2025-09-12 13:02:23	2025-09-21	\N	\N	9345.76	f	холодильный
607	C202500107	Книги, 45 мест	1501.15	21.68	38	10	19	3	483504.54	968.88	2025-09-18 13:02:23	2025-09-29	\N	\N	9670.09	f	обычный
608	C202500108	Электроника, 42 мест	4563.65	31.71	12	8	10	4	42988.84	28672.47	2025-08-01 13:02:23	2025-08-13	\N	\N	859.78	f	обычный
609	C202500109	Техника, 34 мест	636.56	46.40	1	1	15	7	330590.27	45186.50	2026-01-02 13:02:23	2026-01-10	2026-01-20 13:02:23	Срочно	6611.81	f	холодильный
610	C202500110	Одежда, 17 мест	2339.64	22.47	10	10	14	7	314609.94	34811.37	2025-10-08 13:02:23	2025-10-15	2025-10-25 13:02:23	\N	6292.20	f	холодильный
611	C202500111	Запчасти, 35 мест	4686.58	7.63	26	2	11	4	352135.89	23289.79	2025-08-30 13:02:23	2025-09-07	\N	\N	7042.72	f	обычный
612	C202500112	Косметика, 13 мест	4378.34	49.44	15	3	10	2	420932.93	12198.40	2025-08-14 13:02:23	2025-08-26	\N	\N	8418.66	f	обычный
613	C202500113	Мебель, 4 мест	1639.41	48.28	8	17	6	4	318706.87	2010.97	2025-12-28 13:02:23	2026-01-05	\N	\N	6374.14	f	обычный
614	C202500114	Косметика, 40 мест	3110.56	21.97	42	6	5	5	72396.60	35584.88	2025-11-15 13:02:23	2025-11-23	\N	\N	1447.93	f	обычный
615	C202500115	Продукты, 48 мест	142.87	18.70	4	7	9	6	93653.42	18513.24	2025-08-19 13:02:23	2025-08-26	2025-09-03 13:02:23	\N	1873.07	t	холодильный
616	C202500116	Мебель, 27 мест	1661.71	10.35	50	18	11	7	396113.38	22783.21	2025-09-06 13:02:23	2025-09-20	2025-09-23 13:02:23	\N	7922.27	f	обычный
617	C202500117	Электроника, 26 мест	2323.66	15.40	46	9	11	4	361998.97	13617.08	2025-11-20 13:02:23	2025-12-02	\N	\N	7239.98	f	холодильный
618	C202500118	Техника, 2 мест	1758.95	33.98	7	5	2	4	391439.12	23467.23	2025-11-14 13:02:23	2025-11-23	\N	\N	7828.78	f	обычный
619	C202500119	Электроника, 25 мест	4319.26	32.14	16	6	20	6	369534.63	18554.67	2025-10-29 13:02:23	2025-11-07	2025-11-18 13:02:23	\N	7390.69	f	обычный
620	C202500120	Электроника, 26 мест	1452.25	44.80	21	10	4	4	354465.85	28705.65	2025-08-18 13:02:23	2025-09-02	\N	Срочно	7089.32	f	обычный
621	C202500121	Игрушки, 49 мест	205.37	0.98	14	19	8	4	122122.22	47709.58	2025-12-12 13:02:23	2025-12-19	\N	\N	2442.44	f	обычный
622	C202500122	Электроника, 19 мест	1483.46	13.01	34	3	15	7	381451.06	31394.32	2026-01-02 13:02:23	2026-01-17	2026-01-19 13:02:23	\N	7629.02	f	холодильный
623	C202500123	Запчасти, 8 мест	146.20	43.97	23	15	11	5	398020.77	21105.10	2025-09-19 13:02:23	2025-10-04	\N	\N	7960.42	f	обычный
624	C202500124	Электроника, 17 мест	4388.44	43.36	27	3	7	4	363260.87	49170.61	2025-09-02 13:02:23	2025-09-09	\N	\N	7265.22	f	обычный
625	C202500125	Одежда, 14 мест	2933.06	13.67	45	15	14	2	466077.95	27979.94	2025-07-28 13:02:23	2025-08-12	\N	Срочно	9321.56	f	обычный
626	C202500126	Запчасти, 40 мест	1596.99	15.21	50	1	2	5	461953.25	9766.96	2025-08-31 13:02:23	2025-09-11	\N	Срочно	9239.07	t	холодильный
627	C202500127	Косметика, 13 мест	2250.53	8.53	15	12	8	4	141719.88	49987.51	2025-07-30 13:02:23	2025-08-12	\N	\N	2834.40	f	холодильный
628	C202500128	Продукты, 25 мест	4989.85	12.40	6	6	20	4	457231.80	8334.40	2025-07-27 13:02:23	2025-08-08	\N	Срочно	9144.64	f	холодильный
629	C202500129	Игрушки, 46 мест	3794.54	14.56	38	3	8	5	111454.66	40693.22	2025-11-10 13:02:23	2025-11-24	\N	\N	2229.09	t	обычный
630	C202500130	Косметика, 3 мест	3762.71	38.03	26	11	4	5	68042.43	27588.06	2025-09-27 13:02:23	2025-10-05	\N	\N	1360.85	f	обычный
631	C202500131	Игрушки, 6 мест	1375.69	32.61	22	18	5	4	37951.99	36086.52	2025-08-03 13:02:23	2025-08-11	\N	\N	759.04	f	холодильный
632	C202500132	Косметика, 2 мест	1459.21	37.59	24	15	7	6	464233.34	3287.47	2025-11-30 13:02:23	2025-12-10	2025-12-14 13:02:23	\N	9284.67	f	обычный
633	C202500133	Книги, 28 мест	4119.19	2.88	33	11	13	2	168457.80	11729.38	2025-12-21 13:02:23	2026-01-02	\N	\N	3369.16	f	обычный
634	C202500134	Одежда, 1 мест	3184.89	39.02	44	16	11	5	332251.55	16509.40	2025-09-27 13:02:23	2025-10-04	\N	\N	6645.03	t	обычный
635	C202500135	Техника, 50 мест	858.88	16.93	23	8	9	4	318018.79	37125.36	2025-09-15 13:02:23	2025-09-22	\N	\N	6360.38	f	обычный
636	C202500136	Запчасти, 47 мест	1548.45	31.47	37	18	5	4	59988.95	1803.48	2026-01-06 13:02:23	2026-01-13	\N	\N	1199.78	f	обычный
637	C202500137	Запчасти, 34 мест	612.26	41.30	14	7	15	5	258005.46	34121.08	2025-09-11 13:02:23	2025-09-16	\N	Срочно	5160.11	f	обычный
638	C202500138	Запчасти, 22 мест	4931.37	1.36	5	15	20	5	181232.74	43829.09	2025-08-08 13:02:23	2025-08-17	\N	\N	3624.65	f	обычный
639	C202500139	Стройматериалы, 10 мест	1105.68	10.59	42	15	11	2	450335.76	22287.34	2025-11-28 13:02:23	2025-12-03	\N	Срочно	9006.72	f	обычный
640	C202500140	Стройматериалы, 8 мест	780.23	43.44	15	14	15	5	224112.63	3383.75	2025-08-13 13:02:23	2025-08-24	\N	\N	4482.25	f	холодильный
641	C202500141	Электроника, 40 мест	4716.68	45.53	2	16	12	4	124599.14	44010.51	2025-10-24 13:02:23	2025-10-31	\N	\N	2491.98	t	обычный
642	C202500142	Техника, 45 мест	4054.92	16.08	39	20	16	6	224409.56	4848.07	2025-10-13 13:02:23	2025-10-18	2025-10-26 13:02:23	\N	4488.19	t	холодильный
643	C202500143	Одежда, 44 мест	4633.90	16.69	23	9	15	4	148600.10	46527.39	2025-12-10 13:02:23	2025-12-22	\N	\N	2972.00	t	холодильный
644	C202500144	Одежда, 8 мест	3391.65	0.79	43	2	19	7	31051.04	7601.90	2026-01-07 13:02:23	2026-01-13	2026-01-19 13:02:23	\N	621.02	t	обычный
645	C202500145	Продукты, 11 мест	877.94	24.60	41	4	16	2	255566.72	25676.12	2025-10-06 13:02:23	2025-10-19	\N	\N	5111.33	f	обычный
646	C202500146	Одежда, 4 мест	2879.83	40.09	27	3	5	1	473864.40	33942.24	2025-09-04 13:02:23	2025-09-17	\N	\N	9477.29	f	холодильный
647	C202500147	Одежда, 32 мест	2752.40	28.81	5	17	18	3	489082.07	8351.81	2025-10-25 13:02:23	2025-11-06	\N	\N	9781.64	f	холодильный
648	C202500148	Продукты, 37 мест	3317.44	33.93	48	10	18	7	239688.48	26120.13	2025-09-27 13:02:23	2025-10-10	2025-10-14 13:02:23	\N	4793.77	f	холодильный
649	C202500149	Техника, 49 мест	4884.42	9.04	9	12	15	4	468548.71	49972.16	2025-07-25 13:02:23	2025-08-08	\N	Срочно	9370.97	t	обычный
650	C202500150	Косметика, 43 мест	1564.89	22.97	44	1	17	3	242006.79	12789.04	2025-08-03 13:02:23	2025-08-17	\N	\N	4840.14	f	холодильный
651	C202500151	Одежда, 29 мест	3532.66	3.07	12	20	15	6	478524.20	39143.62	2025-09-24 13:02:23	2025-10-04	2025-10-13 13:02:23	\N	9570.48	t	обычный
652	C202500152	Мебель, 27 мест	333.17	28.55	22	16	14	4	261725.09	3833.46	2025-09-13 13:02:23	2025-09-18	\N	\N	5234.50	f	обычный
653	C202500153	Игрушки, 49 мест	583.27	15.80	24	15	16	4	158705.92	33759.22	2025-10-11 13:02:23	2025-10-25	\N	Срочно	3174.12	f	обычный
654	C202500154	Запчасти, 20 мест	1636.51	4.78	17	2	3	5	166492.49	25084.81	2026-01-13 13:02:23	2026-01-20	\N	\N	3329.85	f	холодильный
655	C202500155	Книги, 1 мест	4167.01	0.81	41	11	8	6	145510.48	20939.65	2025-09-22 13:02:23	2025-10-05	2025-10-09 13:02:23	\N	2910.21	f	обычный
656	C202500156	Техника, 45 мест	285.07	21.34	25	6	4	4	249899.14	9982.53	2025-10-19 13:02:23	2025-10-24	\N	Срочно	4997.98	f	обычный
657	C202500157	Мебель, 27 мест	4590.24	27.43	47	15	4	1	365076.08	18007.19	2025-12-04 13:02:23	2025-12-13	\N	\N	7301.52	t	обычный
658	C202500158	Техника, 32 мест	3099.64	3.73	34	3	5	3	217957.10	7587.81	2025-10-06 13:02:23	2025-10-18	\N	\N	4359.14	f	холодильный
659	C202500159	Электроника, 1 мест	2589.99	12.41	26	1	3	2	153944.60	22699.41	2025-08-10 13:02:23	2025-08-22	\N	Срочно	3078.89	f	обычный
660	C202500160	Мебель, 39 мест	2802.57	8.71	32	17	3	5	191602.61	30267.94	2025-10-17 13:02:23	2025-10-22	\N	\N	3832.05	f	холодильный
661	C202500161	Игрушки, 15 мест	4448.45	36.81	27	10	6	4	6311.66	36506.54	2026-01-12 13:02:23	2026-01-26	\N	\N	126.23	f	обычный
662	C202500162	Электроника, 15 мест	3248.52	5.33	26	1	19	1	340492.53	20202.63	2025-09-12 13:02:23	2025-09-27	\N	Срочно	6809.85	f	обычный
663	C202500163	Одежда, 12 мест	3210.34	9.65	36	20	5	4	178321.06	46564.52	2025-07-26 13:02:23	2025-08-01	\N	\N	3566.42	t	обычный
664	C202500164	Запчасти, 19 мест	825.56	31.81	20	12	20	1	213584.97	42483.41	2026-01-15 13:02:23	2026-01-28	\N	\N	4271.70	t	обычный
665	C202500165	Стройматериалы, 4 мест	1669.32	9.94	34	1	10	4	120180.55	44973.86	2025-10-12 13:02:23	2025-10-23	\N	\N	2403.61	f	обычный
666	C202500166	Книги, 7 мест	3263.65	20.47	5	1	16	4	190815.97	17867.79	2025-09-27 13:02:23	2025-10-06	\N	\N	3816.32	f	обычный
667	C202500167	Мебель, 46 мест	1600.82	26.01	20	6	9	5	196575.49	22171.43	2025-12-09 13:02:23	2025-12-20	\N	Срочно	3931.51	f	обычный
668	C202500168	Книги, 29 мест	1127.29	19.87	40	16	4	5	30900.97	17698.78	2025-09-24 13:02:23	2025-10-01	\N	Срочно	618.02	f	обычный
669	C202500169	Одежда, 39 мест	622.30	30.30	24	7	17	5	224151.95	24666.38	2025-08-10 13:02:23	2025-08-24	\N	\N	4483.04	f	холодильный
670	C202500170	Продукты, 27 мест	2623.87	23.38	15	1	9	4	447013.66	42382.49	2026-01-16 13:02:23	2026-01-21	\N	\N	8940.27	t	обычный
671	C202500171	Техника, 6 мест	4254.60	24.89	3	1	11	3	453432.52	7444.48	2025-10-26 13:02:23	2025-11-05	\N	\N	9068.65	f	обычный
672	C202500172	Одежда, 13 мест	2226.94	39.30	11	2	10	4	360510.53	32932.93	2025-12-30 13:02:23	2026-01-04	\N	\N	7210.21	f	обычный
673	C202500173	Мебель, 48 мест	213.31	40.70	9	16	6	4	497287.26	16519.70	2025-11-05 13:02:23	2025-11-14	\N	Срочно	9945.75	f	холодильный
674	C202500174	Косметика, 49 мест	4861.06	42.25	25	19	6	4	472912.76	18152.53	2025-10-15 13:02:23	2025-10-20	\N	\N	9458.26	f	обычный
675	C202500175	Техника, 3 мест	4508.39	2.24	33	12	8	7	279226.64	37901.76	2025-09-01 13:02:23	2025-09-07	2025-09-16 13:02:23	Срочно	5584.53	t	обычный
676	C202500176	Игрушки, 16 мест	3374.23	30.32	41	19	18	5	221923.42	44062.14	2025-10-07 13:02:23	2025-10-12	\N	\N	4438.47	f	обычный
677	C202500177	Косметика, 19 мест	4050.69	47.28	19	2	13	4	441770.22	15357.27	2025-08-31 13:02:23	2025-09-12	\N	Срочно	8835.40	f	обычный
678	C202500178	Мебель, 26 мест	4212.33	39.82	4	7	12	2	17079.35	13464.92	2026-01-11 13:02:23	2026-01-16	\N	Срочно	341.59	f	холодильный
679	C202500179	Книги, 21 мест	287.55	17.21	19	16	8	5	488741.42	30180.61	2026-01-09 13:02:23	2026-01-21	\N	\N	9774.83	f	холодильный
680	C202500180	Книги, 29 мест	1818.67	45.72	13	7	5	4	471165.48	27343.27	2025-12-21 13:02:23	2026-01-05	\N	\N	9423.31	f	обычный
681	C202500181	Косметика, 20 мест	148.28	3.16	5	18	7	6	392209.03	45031.31	2025-12-08 13:02:23	2025-12-13	2025-12-20 13:02:23	\N	7844.18	t	обычный
682	C202500182	Стройматериалы, 16 мест	3700.35	13.32	11	10	4	5	171025.39	44393.54	2025-08-09 13:02:23	2025-08-22	\N	\N	3420.51	f	обычный
683	C202500183	Продукты, 27 мест	2119.18	39.10	8	1	13	2	208721.87	41385.20	2025-12-03 13:02:23	2025-12-16	\N	Срочно	4174.44	f	обычный
684	C202500184	Книги, 7 мест	1465.65	39.07	17	19	13	5	400134.09	18379.07	2025-12-19 13:02:23	2026-01-03	\N	\N	8002.68	f	холодильный
685	C202500185	Мебель, 12 мест	2544.23	44.73	12	19	7	4	133159.88	23370.44	2025-09-03 13:02:23	2025-09-11	\N	\N	2663.20	f	холодильный
686	C202500186	Одежда, 4 мест	2719.09	38.81	50	11	20	6	218112.35	28842.18	2025-08-05 13:02:23	2025-08-10	2025-08-19 13:02:23	Срочно	4362.25	f	обычный
687	C202500187	Продукты, 42 мест	4224.54	42.68	45	6	15	1	362273.12	29469.41	2026-01-11 13:02:23	2026-01-18	\N	Срочно	7245.46	f	обычный
688	C202500188	Техника, 50 мест	156.44	32.98	21	20	10	3	78086.71	7290.66	2025-09-04 13:02:23	2025-09-13	\N	\N	1561.73	t	холодильный
689	C202500189	Продукты, 19 мест	4531.97	37.09	22	17	11	7	246257.38	7428.29	2025-12-19 13:02:23	2025-12-26	2026-01-08 13:02:23	\N	4925.15	f	обычный
690	C202500190	Игрушки, 22 мест	2106.79	37.95	37	17	7	6	160008.91	9349.21	2025-10-10 13:02:23	2025-10-17	2025-10-13 13:02:23	\N	3200.18	t	холодильный
691	C202500191	Одежда, 11 мест	2618.51	18.77	25	5	2	3	68941.26	20114.91	2025-09-19 13:02:23	2025-09-26	\N	\N	1378.83	f	холодильный
692	C202500192	Мебель, 30 мест	1908.64	45.01	17	17	13	1	135059.15	32027.85	2026-01-11 13:02:23	2026-01-26	\N	\N	2701.18	f	холодильный
693	C202500193	Мебель, 40 мест	3366.09	10.95	38	6	11	2	21973.73	49217.43	2026-01-14 13:02:23	2026-01-22	\N	\N	439.47	f	обычный
694	C202500194	Игрушки, 42 мест	2756.73	26.20	28	1	7	7	465312.83	22495.00	2025-10-11 13:02:23	2025-10-21	2025-10-20 13:02:23	Срочно	9306.26	f	обычный
695	C202500195	Стройматериалы, 2 мест	3338.26	1.25	45	19	5	6	84749.77	1541.18	2025-08-10 13:02:23	2025-08-22	2025-08-28 13:02:23	\N	1695.00	t	холодильный
696	C202500196	Книги, 13 мест	1349.66	49.04	17	8	4	5	277061.42	12577.16	2025-12-12 13:02:23	2025-12-26	\N	\N	5541.23	f	обычный
697	C202500197	Запчасти, 45 мест	1886.01	46.83	10	18	16	5	474603.31	13570.33	2025-10-02 13:02:23	2025-10-11	\N	Срочно	9492.07	f	обычный
698	C202500198	Техника, 16 мест	3867.98	37.64	13	4	13	3	465646.25	21063.54	2025-08-08 13:02:23	2025-08-18	\N	Срочно	9312.93	f	обычный
699	C202500199	Игрушки, 29 мест	2894.86	1.88	33	19	17	4	197405.15	23169.11	2025-12-29 13:02:23	2026-01-13	\N	Срочно	3948.10	f	обычный
700	C202500200	Одежда, 43 мест	1913.37	34.77	36	15	5	5	27649.70	15666.80	2025-09-15 13:02:23	2025-09-22	\N	\N	552.99	f	обычный
701	C202500201	Запчасти, 40 мест	602.60	3.59	37	11	7	4	224837.54	29216.60	2025-11-22 13:02:23	2025-11-29	\N	Срочно	4496.75	f	обычный
702	C202500202	Игрушки, 45 мест	2463.01	36.45	8	15	6	2	381196.08	4718.13	2025-08-02 13:02:23	2025-08-08	\N	\N	7623.92	f	обычный
703	C202500203	Электроника, 10 мест	3853.41	44.05	12	5	13	3	74486.47	14628.58	2025-09-21 13:02:23	2025-10-06	\N	Срочно	1489.73	f	обычный
704	C202500204	Одежда, 46 мест	473.50	40.03	6	8	18	7	115255.14	9814.46	2025-09-27 13:02:23	2025-10-02	2025-10-01 13:02:23	\N	2305.10	f	обычный
705	C202500205	Книги, 25 мест	4106.91	43.31	2	18	20	5	36226.46	6841.21	2025-08-22 13:02:23	2025-08-27	\N	\N	724.53	f	обычный
706	C202500206	Запчасти, 18 мест	2895.78	2.41	3	7	13	5	485846.03	39224.99	2025-09-07 13:02:23	2025-09-21	\N	Срочно	9716.92	t	обычный
707	C202500207	Игрушки, 34 мест	3521.43	19.57	22	9	2	4	34109.04	38004.23	2025-08-07 13:02:23	2025-08-12	\N	\N	682.18	f	обычный
708	C202500208	Электроника, 1 мест	2457.43	10.54	29	3	20	5	137804.57	48104.42	2025-09-04 13:02:23	2025-09-15	\N	\N	2756.09	f	обычный
709	C202500209	Косметика, 1 мест	3725.81	47.18	33	2	5	3	25533.08	49870.92	2025-12-18 13:02:23	2025-12-25	\N	Срочно	510.66	f	холодильный
710	C202500210	Игрушки, 47 мест	954.92	42.10	41	7	16	1	132155.47	26644.81	2025-09-01 13:02:23	2025-09-07	\N	Срочно	2643.11	f	обычный
711	C202500211	Электроника, 23 мест	100.40	14.06	36	14	5	4	422727.88	38993.96	2026-01-09 13:02:23	2026-01-15	\N	\N	8454.56	t	обычный
712	C202500212	Мебель, 19 мест	356.00	32.80	46	8	9	4	38196.52	38909.50	2025-10-31 13:02:23	2025-11-11	\N	\N	763.93	f	обычный
713	C202500213	Книги, 11 мест	668.25	39.71	21	14	18	5	446033.11	14112.53	2025-11-29 13:02:23	2025-12-13	\N	Срочно	8920.66	f	обычный
714	C202500214	Игрушки, 39 мест	1541.84	40.46	9	4	16	1	45511.20	26969.98	2025-10-27 13:02:23	2025-11-10	\N	\N	910.22	f	обычный
715	C202500215	Одежда, 13 мест	1120.68	30.45	40	15	19	7	217021.90	4293.22	2025-07-29 13:02:23	2025-08-03	2025-08-16 13:02:23	\N	4340.44	f	обычный
716	C202500216	Мебель, 39 мест	1027.76	41.81	28	10	15	4	317485.68	10516.24	2025-12-06 13:02:23	2025-12-15	\N	\N	6349.71	f	обычный
717	C202500217	Запчасти, 25 мест	1861.60	49.03	37	18	1	4	379524.58	49737.53	2025-09-17 13:02:23	2025-09-29	\N	\N	7590.49	t	обычный
718	C202500218	Косметика, 40 мест	2702.38	29.47	17	2	16	1	226995.71	19027.60	2025-12-31 13:02:23	2026-01-06	\N	Срочно	4539.91	t	обычный
719	C202500219	Косметика, 14 мест	4699.45	31.22	12	13	10	4	257808.13	17874.48	2026-01-02 13:02:23	2026-01-12	\N	\N	5156.16	t	обычный
720	C202500220	Стройматериалы, 12 мест	4032.32	12.43	31	14	10	4	80716.71	44491.06	2025-09-07 13:02:23	2025-09-16	\N	\N	1614.33	t	обычный
721	C202500221	Электроника, 7 мест	70.05	41.80	15	20	13	3	128109.42	26498.90	2026-01-05 13:02:23	2026-01-18	\N	\N	2562.19	f	обычный
722	C202500222	Электроника, 34 мест	2590.71	5.69	21	6	7	1	450964.42	48358.04	2025-10-07 13:02:23	2025-10-17	\N	Срочно	9019.29	f	обычный
723	C202500223	Электроника, 9 мест	4315.92	44.35	28	10	20	2	88661.47	45268.76	2025-12-27 13:02:23	2026-01-07	\N	\N	1773.23	t	обычный
724	C202500224	Запчасти, 18 мест	2683.68	41.39	40	17	16	6	74867.91	9157.40	2025-08-19 13:02:23	2025-09-01	2025-09-03 13:02:23	Срочно	1497.36	f	обычный
725	C202500225	Мебель, 32 мест	1325.67	19.54	30	17	18	4	448359.43	33553.94	2025-08-17 13:02:23	2025-08-23	\N	\N	8967.19	f	обычный
726	C202500226	Стройматериалы, 9 мест	4692.86	39.03	38	14	3	4	210958.94	31339.03	2025-11-10 13:02:23	2025-11-23	\N	\N	4219.18	f	обычный
727	C202500227	Запчасти, 2 мест	1342.47	19.18	47	4	9	4	475664.98	7578.14	2025-10-30 13:02:23	2025-11-08	\N	\N	9513.30	f	обычный
728	C202500228	Игрушки, 31 мест	3510.47	16.54	47	9	8	4	420510.96	26040.42	2025-09-10 13:02:23	2025-09-16	\N	\N	8410.22	f	обычный
729	C202500229	Мебель, 31 мест	123.45	15.06	46	6	18	3	419504.86	8412.46	2025-08-16 13:02:23	2025-08-21	\N	\N	8390.10	f	обычный
730	C202500230	Книги, 3 мест	2543.20	26.02	8	16	12	5	277738.72	7309.03	2025-09-22 13:02:23	2025-09-29	\N	\N	5554.77	t	обычный
731	C202500231	Косметика, 48 мест	2513.48	37.55	1	15	5	3	177539.66	44657.30	2025-12-18 13:02:23	2026-01-02	\N	Срочно	3550.79	f	обычный
732	C202500232	Мебель, 5 мест	4955.76	21.52	20	4	15	2	66346.73	22723.89	2025-08-10 13:02:23	2025-08-22	\N	\N	1326.93	f	обычный
733	C202500233	Одежда, 18 мест	300.43	48.77	45	14	16	4	104763.86	37485.55	2025-07-25 13:02:23	2025-08-01	\N	\N	2095.28	f	обычный
734	C202500234	Стройматериалы, 9 мест	1856.61	28.97	13	14	11	2	101712.69	24544.54	2025-09-06 13:02:23	2025-09-12	\N	\N	2034.25	f	обычный
735	C202500235	Косметика, 12 мест	873.67	16.80	2	20	12	2	44383.15	23146.13	2025-08-07 13:02:23	2025-08-19	\N	\N	887.66	f	обычный
736	C202500236	Одежда, 45 мест	2579.59	35.56	21	12	5	3	262074.44	41982.70	2026-01-04 13:02:23	2026-01-18	\N	\N	5241.49	f	обычный
737	C202500237	Одежда, 19 мест	431.05	35.00	5	16	14	6	160660.45	13964.98	2025-09-09 13:02:23	2025-09-24	2025-09-21 13:02:23	\N	3213.21	t	обычный
738	C202500238	Книги, 24 мест	130.44	48.46	39	2	3	6	102640.34	45710.00	2026-01-19 13:02:23	2026-01-28	2026-01-31 13:02:23	Срочно	2052.81	f	обычный
739	C202500239	Игрушки, 38 мест	2813.63	38.15	27	20	8	5	455942.56	46012.88	2025-10-29 13:02:23	2025-11-03	\N	\N	9118.85	f	обычный
740	C202500240	Запчасти, 14 мест	1062.57	22.75	41	17	4	3	281229.29	19545.89	2025-08-02 13:02:23	2025-08-12	\N	\N	5624.59	f	обычный
741	C202500241	Стройматериалы, 49 мест	4212.59	2.27	30	13	17	4	6516.39	39596.00	2025-08-13 13:02:23	2025-08-22	\N	\N	130.33	t	обычный
742	C202500242	Стройматериалы, 4 мест	730.12	23.79	12	15	4	5	350264.90	24572.03	2025-09-29 13:02:23	2025-10-11	\N	\N	7005.30	f	обычный
743	C202500243	Техника, 23 мест	1866.37	43.48	36	14	4	4	176078.80	34514.06	2025-07-31 13:02:23	2025-08-09	\N	Срочно	3521.58	f	обычный
744	C202500244	Одежда, 2 мест	4173.35	32.74	6	12	17	5	46193.82	35012.64	2025-09-07 13:02:23	2025-09-21	\N	Срочно	923.88	f	обычный
745	C202500245	Техника, 24 мест	488.66	25.35	3	12	9	2	311884.02	10200.85	2025-10-04 13:02:23	2025-10-17	\N	\N	6237.68	f	обычный
746	C202500246	Мебель, 22 мест	4905.95	14.00	39	11	19	5	69078.02	25834.78	2025-10-28 13:02:23	2025-11-08	\N	\N	1381.56	f	обычный
747	C202500247	Продукты, 24 мест	2152.70	47.16	7	17	18	4	131396.53	34280.90	2025-12-02 13:02:23	2025-12-16	\N	\N	2627.93	f	обычный
748	C202500248	Стройматериалы, 21 мест	1676.67	38.94	25	12	11	4	174013.65	14185.91	2025-12-08 13:02:23	2025-12-17	\N	\N	3480.27	t	обычный
749	C202500249	Запчасти, 44 мест	3877.98	18.48	20	10	14	7	346677.43	38129.34	2025-09-08 13:02:23	2025-09-16	2025-09-14 13:02:23	\N	6933.55	f	обычный
750	C202500250	Техника, 46 мест	3676.14	6.12	41	15	3	4	262151.81	1980.94	2025-08-09 13:02:23	2025-08-24	\N	\N	5243.04	f	обычный
751	C202500251	Электроника, 15 мест	387.51	9.66	49	8	20	5	378217.35	32510.87	2025-11-25 13:02:23	2025-12-09	\N	\N	7564.35	f	обычный
752	C202500252	Запчасти, 15 мест	3015.23	48.01	29	10	16	3	308003.73	35448.93	2025-11-01 13:02:23	2025-11-11	\N	\N	6160.07	t	обычный
753	C202500253	Продукты, 46 мест	4715.28	45.83	37	13	7	2	197978.55	40025.25	2025-08-12 13:02:23	2025-08-21	\N	\N	3959.57	f	холодильный
754	C202500254	Игрушки, 8 мест	4412.06	17.08	26	1	7	3	167079.47	18215.17	2025-10-07 13:02:23	2025-10-14	\N	\N	3341.59	f	обычный
755	C202500255	Техника, 34 мест	3944.98	26.47	45	7	18	4	178513.20	46924.99	2025-08-24 13:02:23	2025-09-07	\N	\N	3570.26	f	обычный
756	C202500256	Одежда, 36 мест	2412.60	29.50	29	11	19	5	187201.67	11583.76	2025-12-17 13:02:23	2026-01-01	\N	Срочно	3744.03	t	холодильный
757	C202500257	Электроника, 44 мест	3976.46	13.76	10	9	10	4	305393.38	2176.57	2025-07-26 13:02:23	2025-08-02	\N	\N	6107.87	f	обычный
758	C202500258	Косметика, 28 мест	2500.23	0.93	26	11	20	3	130001.87	11418.54	2025-09-21 13:02:23	2025-09-27	\N	\N	2600.04	f	обычный
759	C202500259	Книги, 19 мест	3287.55	16.87	22	17	7	5	20270.00	7843.74	2025-12-22 13:02:23	2026-01-02	\N	\N	405.40	f	обычный
760	C202500260	Техника, 22 мест	4579.92	20.61	41	2	9	5	468465.96	27045.66	2025-08-12 13:02:23	2025-08-18	\N	Срочно	9369.32	f	холодильный
761	C202500261	Одежда, 32 мест	373.88	47.42	17	12	8	5	442731.48	11190.85	2025-11-30 13:02:23	2025-12-14	\N	\N	8854.63	f	холодильный
762	C202500262	Игрушки, 32 мест	419.99	38.86	43	10	5	6	10481.45	20524.92	2025-11-05 13:02:23	2025-11-15	2025-11-10 13:02:23	\N	209.63	f	холодильный
763	C202500263	Игрушки, 24 мест	990.92	27.32	36	8	4	4	335605.16	43531.04	2025-12-20 13:02:23	2025-12-31	\N	\N	6712.10	f	обычный
764	C202500264	Техника, 22 мест	3621.74	1.85	1	4	18	4	16569.56	31529.46	2025-08-23 13:02:23	2025-08-31	\N	\N	331.39	f	холодильный
765	C202500265	Игрушки, 46 мест	2777.03	36.19	46	9	18	4	176063.32	33220.75	2026-01-10 13:02:23	2026-01-24	\N	\N	3521.27	f	холодильный
766	C202500266	Техника, 35 мест	4464.04	17.93	2	18	12	5	104184.55	38305.97	2025-11-30 13:02:23	2025-12-11	\N	Срочно	2083.69	f	обычный
767	C202500267	Электроника, 45 мест	4925.46	44.33	32	18	15	1	295609.54	4277.99	2025-09-29 13:02:23	2025-10-14	\N	\N	5912.19	f	холодильный
768	C202500268	Продукты, 18 мест	1085.34	47.89	44	11	20	1	381838.62	38745.21	2025-09-03 13:02:23	2025-09-12	\N	\N	7636.77	f	обычный
769	C202500269	Книги, 37 мест	1272.01	5.86	37	13	16	5	484310.54	24873.99	2025-09-13 13:02:23	2025-09-26	\N	\N	9686.21	f	обычный
770	C202500270	Электроника, 37 мест	3301.21	28.64	18	15	8	2	180223.86	34763.68	2025-09-26 13:02:23	2025-10-08	\N	\N	3604.48	f	обычный
771	C202500271	Продукты, 19 мест	3723.67	4.51	20	11	5	4	76537.87	23500.58	2025-12-14 13:02:23	2025-12-28	\N	\N	1530.76	f	обычный
772	C202500272	Косметика, 12 мест	4577.28	4.12	35	12	18	1	81107.20	48349.49	2025-08-22 13:02:23	2025-08-29	\N	\N	1622.14	f	холодильный
773	C202500273	Электроника, 22 мест	3142.14	15.39	46	11	3	4	158544.51	42004.53	2025-09-14 13:02:23	2025-09-28	\N	\N	3170.89	f	обычный
774	C202500274	Техника, 21 мест	1657.61	40.60	31	18	13	3	317832.40	30585.32	2026-01-07 13:02:23	2026-01-19	\N	Срочно	6356.65	f	обычный
775	C202500275	Продукты, 11 мест	3349.54	8.69	37	7	9	4	139337.54	18995.10	2025-08-16 13:02:23	2025-08-24	\N	\N	2786.75	t	обычный
776	C202500276	Электроника, 36 мест	1696.25	22.56	40	13	19	4	168563.22	45141.57	2025-09-28 13:02:23	2025-10-11	\N	\N	3371.26	f	обычный
777	C202500277	Электроника, 25 мест	3135.39	29.43	27	6	1	4	424920.74	21183.44	2025-10-24 13:02:23	2025-11-03	\N	\N	8498.41	f	обычный
778	C202500278	Стройматериалы, 49 мест	3023.89	41.27	13	8	4	6	499263.54	43642.16	2025-09-03 13:02:23	2025-09-16	2025-09-15 13:02:23	\N	9985.27	f	обычный
779	C202500279	Электроника, 1 мест	2924.99	20.34	12	5	15	3	408149.93	13687.30	2025-09-27 13:02:23	2025-10-04	\N	Срочно	8163.00	f	обычный
780	C202500280	Продукты, 22 мест	1741.66	12.77	42	2	8	7	138417.78	43838.30	2025-11-23 13:02:23	2025-11-28	2025-12-13 13:02:23	\N	2768.36	t	обычный
781	C202500281	Мебель, 26 мест	4781.33	0.67	35	9	3	4	104238.14	18805.31	2025-11-09 13:02:23	2025-11-15	\N	\N	2084.76	f	холодильный
782	C202500282	Запчасти, 40 мест	69.31	10.75	49	16	2	4	293787.69	8030.95	2025-12-11 13:02:23	2025-12-19	\N	\N	5875.75	f	холодильный
783	C202500283	Мебель, 47 мест	3090.34	3.29	17	5	9	5	48495.93	3878.04	2025-09-04 13:02:23	2025-09-17	\N	\N	969.92	f	обычный
784	C202500284	Книги, 49 мест	1235.77	28.06	5	12	14	3	427322.81	8825.15	2025-10-27 13:02:23	2025-11-07	\N	Срочно	8546.46	f	обычный
785	C202500285	Продукты, 1 мест	1997.06	39.65	44	4	2	2	42629.13	28989.21	2025-12-16 13:02:23	2025-12-21	\N	Срочно	852.58	f	обычный
786	C202500286	Электроника, 40 мест	777.87	29.31	26	18	5	2	293730.12	27795.51	2025-11-24 13:02:23	2025-12-03	\N	\N	5874.60	t	обычный
787	C202500287	Запчасти, 8 мест	957.83	28.43	5	19	2	4	218236.60	15376.04	2026-01-05 13:02:23	2026-01-16	\N	\N	4364.73	f	обычный
788	C202500288	Стройматериалы, 31 мест	2117.85	45.18	45	3	13	5	46974.78	49062.29	2025-09-11 13:02:23	2025-09-17	\N	\N	939.50	t	холодильный
789	C202500289	Одежда, 24 мест	4419.18	14.07	14	9	14	5	286831.84	48555.40	2025-11-25 13:02:23	2025-12-09	\N	\N	5736.64	t	холодильный
790	C202500290	Техника, 14 мест	3427.88	4.32	8	16	1	3	325732.52	10102.97	2025-12-04 13:02:23	2025-12-10	\N	\N	6514.65	f	обычный
791	C202500291	Техника, 11 мест	4426.75	4.77	22	15	16	5	287963.61	6610.20	2025-10-23 13:02:23	2025-10-28	\N	\N	5759.27	t	холодильный
792	C202500292	Мебель, 38 мест	1117.83	13.87	14	15	1	5	370377.68	43465.02	2025-12-19 13:02:23	2025-12-26	\N	Срочно	7407.55	f	обычный
793	C202500293	Косметика, 33 мест	3450.29	49.46	43	13	15	3	479863.78	43296.98	2025-09-15 13:02:23	2025-09-27	\N	Срочно	9597.28	t	обычный
794	C202500294	Стройматериалы, 34 мест	2407.85	31.97	17	4	19	7	436212.40	7461.16	2025-10-02 13:02:23	2025-10-08	2025-10-22 13:02:23	\N	8724.25	f	обычный
795	C202500295	Техника, 8 мест	2826.90	18.11	35	1	5	5	215484.54	43685.82	2025-08-20 13:02:23	2025-09-04	\N	Срочно	4309.69	f	обычный
796	C202500296	Стройматериалы, 35 мест	4611.32	20.60	42	18	2	2	238950.97	25727.29	2025-10-21 13:02:23	2025-10-29	\N	\N	4779.02	f	обычный
797	C202500297	Книги, 4 мест	691.30	46.59	5	12	8	2	107997.92	8948.49	2025-07-30 13:02:23	2025-08-09	\N	Срочно	2159.96	t	холодильный
798	C202500298	Игрушки, 22 мест	4445.28	6.91	38	19	12	7	360269.05	23149.56	2025-10-04 13:02:23	2025-10-09	2025-10-18 13:02:23	\N	7205.38	f	обычный
799	C202500299	Электроника, 25 мест	2749.55	48.63	42	7	12	2	232426.26	49104.75	2025-10-29 13:02:23	2025-11-07	\N	\N	4648.53	t	обычный
800	C202500300	Техника, 7 мест	3800.67	28.88	50	20	10	3	84343.93	26028.30	2025-07-25 13:02:23	2025-08-03	\N	\N	1686.88	t	обычный
801	C202500301	Запчасти, 1 мест	2593.71	21.08	5	16	10	6	327459.35	10081.48	2025-11-09 13:02:23	2025-11-19	2025-11-15 13:02:23	\N	6549.19	f	обычный
802	C202500302	Косметика, 32 мест	2534.06	38.20	43	9	10	4	282729.08	23016.28	2025-12-26 13:02:23	2026-01-10	\N	Срочно	5654.58	f	обычный
803	C202500303	Стройматериалы, 18 мест	2230.72	25.91	38	9	18	6	354081.45	49758.88	2025-10-30 13:02:23	2025-11-07	2025-11-08 13:02:23	Срочно	7081.63	f	обычный
804	C202500304	Мебель, 45 мест	2871.70	27.52	48	16	12	3	211144.07	43994.60	2025-10-19 13:02:23	2025-10-26	\N	\N	4222.88	f	обычный
805	C202500305	Одежда, 6 мест	1067.29	15.06	1	4	7	2	205567.38	35824.14	2025-08-13 13:02:23	2025-08-28	\N	\N	4111.35	f	обычный
806	C202500306	Запчасти, 10 мест	2500.04	46.37	39	11	16	3	79286.57	17237.41	2026-01-04 13:02:23	2026-01-12	\N	\N	1585.73	f	обычный
807	C202500307	Мебель, 11 мест	4538.66	41.51	36	14	7	5	136489.81	12813.23	2025-12-30 13:02:23	2026-01-07	\N	\N	2729.80	f	обычный
808	C202500308	Одежда, 41 мест	1458.39	6.93	2	4	10	5	477434.47	38602.22	2025-11-12 13:02:23	2025-11-20	\N	\N	9548.69	f	холодильный
809	C202500309	Косметика, 44 мест	2205.42	28.84	46	4	13	3	194494.60	41886.96	2025-09-20 13:02:23	2025-10-05	\N	\N	3889.89	f	обычный
810	C202500310	Косметика, 20 мест	3274.41	21.83	7	15	1	4	325664.82	40475.47	2025-10-19 13:02:23	2025-10-30	\N	\N	6513.30	t	обычный
811	C202500311	Косметика, 33 мест	2499.77	29.12	23	6	12	3	480911.83	31368.10	2025-10-05 13:02:23	2025-10-11	\N	\N	9618.24	t	обычный
812	C202500312	Электроника, 40 мест	982.98	49.10	41	11	18	3	273034.62	20825.05	2026-01-20 13:02:23	2026-02-01	\N	\N	5460.69	f	обычный
813	C202500313	Мебель, 2 мест	2475.07	40.14	28	12	4	3	228684.76	20205.54	2025-11-07 13:02:23	2025-11-18	\N	\N	4573.70	f	обычный
814	C202500314	Косметика, 44 мест	225.89	33.45	23	6	3	1	451894.83	44181.79	2025-11-16 13:02:23	2025-11-22	\N	\N	9037.90	f	обычный
815	C202500315	Книги, 26 мест	1868.53	37.44	12	14	5	5	121816.22	1334.94	2025-12-14 13:02:23	2025-12-25	\N	\N	2436.32	f	холодильный
816	C202500316	Косметика, 21 мест	3083.91	19.30	45	7	16	6	274009.75	46415.35	2025-11-24 13:02:23	2025-12-05	2025-12-02 13:02:23	\N	5480.19	t	холодильный
817	C202500317	Одежда, 3 мест	1624.58	45.88	49	16	9	6	394471.96	35662.51	2025-12-04 13:02:23	2025-12-14	2025-12-15 13:02:23	\N	7889.44	f	холодильный
818	C202500318	Техника, 14 мест	2542.75	48.31	4	5	13	4	163979.80	48897.47	2025-09-10 13:02:23	2025-09-25	\N	Срочно	3279.60	f	обычный
819	C202500319	Одежда, 25 мест	126.64	3.94	47	6	7	2	474002.73	30831.60	2025-10-20 13:02:23	2025-11-04	\N	\N	9480.05	t	обычный
820	C202500320	Продукты, 26 мест	65.61	2.57	32	7	19	5	384789.68	46408.05	2025-11-07 13:02:23	2025-11-22	\N	\N	7695.79	f	обычный
821	C202500321	Электроника, 27 мест	522.84	41.31	30	11	5	3	360700.03	47757.31	2025-11-28 13:02:23	2025-12-05	\N	\N	7214.00	f	обычный
822	C202500322	Косметика, 33 мест	1416.84	17.74	9	17	15	4	389620.16	45889.38	2025-08-01 13:02:23	2025-08-12	\N	\N	7792.40	f	холодильный
823	C202500323	Продукты, 8 мест	894.54	0.80	1	12	2	3	105829.12	48359.05	2025-08-30 13:02:23	2025-09-08	\N	\N	2116.58	f	обычный
824	C202500324	Продукты, 35 мест	2766.29	11.77	39	6	12	3	491010.35	35465.86	2025-08-25 13:02:23	2025-09-05	\N	Срочно	9820.21	t	обычный
825	C202500325	Книги, 34 мест	4406.71	46.64	22	10	9	4	68487.28	48052.19	2025-08-07 13:02:23	2025-08-17	\N	\N	1369.75	f	обычный
826	C202500326	Косметика, 29 мест	1477.53	4.08	37	1	9	3	367893.67	2442.01	2025-10-01 13:02:23	2025-10-15	\N	\N	7357.87	f	обычный
827	C202500327	Электроника, 38 мест	3374.99	39.93	27	10	5	5	121666.79	17548.01	2025-10-20 13:02:23	2025-10-29	\N	\N	2433.34	f	обычный
828	C202500328	Книги, 13 мест	713.48	31.37	14	16	12	6	161475.87	41926.98	2025-09-03 13:02:23	2025-09-09	2025-09-20 13:02:23	\N	3229.52	t	обычный
829	C202500329	Электроника, 2 мест	4160.79	9.99	14	20	9	5	352356.17	10824.87	2025-10-31 13:02:23	2025-11-15	\N	\N	7047.12	f	холодильный
830	C202500330	Игрушки, 47 мест	178.34	23.55	7	10	3	4	427263.63	34254.12	2025-08-20 13:02:23	2025-09-01	\N	\N	8545.27	f	обычный
831	C202500331	Игрушки, 24 мест	4641.16	29.64	10	1	20	5	183145.77	28985.80	2025-10-23 13:02:23	2025-11-03	\N	\N	3662.92	t	обычный
832	C202500332	Игрушки, 46 мест	1312.11	38.93	1	5	4	3	262149.42	11959.68	2025-10-07 13:02:23	2025-10-22	\N	\N	5242.99	f	холодильный
833	C202500333	Техника, 21 мест	1243.30	42.51	44	1	6	2	19453.44	23702.84	2025-09-06 13:02:23	2025-09-16	\N	\N	389.07	f	обычный
834	C202500334	Мебель, 23 мест	4463.16	9.98	15	3	16	5	8744.81	23296.88	2025-12-04 13:02:23	2025-12-11	\N	\N	174.90	f	обычный
835	C202500335	Продукты, 30 мест	1642.83	27.20	43	14	7	1	270606.58	15056.99	2025-11-20 13:02:23	2025-12-03	\N	\N	5412.13	t	обычный
836	C202500336	Продукты, 28 мест	2750.04	49.77	6	16	4	5	453013.99	12504.15	2026-01-13 13:02:23	2026-01-21	\N	\N	9060.28	t	обычный
837	C202500337	Одежда, 23 мест	975.92	9.67	29	20	3	1	337012.17	40773.00	2025-09-15 13:02:23	2025-09-27	\N	Срочно	6740.24	f	обычный
838	C202500338	Продукты, 20 мест	1088.23	5.77	37	11	8	1	413015.16	15815.49	2025-09-16 13:02:23	2025-09-27	\N	Срочно	8260.30	f	обычный
839	C202500339	Книги, 37 мест	3446.05	6.11	32	13	8	4	176068.73	27037.93	2025-11-13 13:02:23	2025-11-20	\N	\N	3521.37	f	обычный
840	C202500340	Одежда, 23 мест	3446.53	33.84	28	18	10	5	149561.91	6863.78	2025-10-08 13:02:23	2025-10-23	\N	\N	2991.24	f	обычный
841	C202500341	Одежда, 17 мест	2037.77	47.77	37	2	7	4	277035.96	18773.58	2025-11-09 13:02:23	2025-11-15	\N	\N	5540.72	f	обычный
842	C202500342	Запчасти, 20 мест	1779.39	37.95	18	4	9	4	443368.03	24766.61	2025-09-02 13:02:23	2025-09-12	\N	Срочно	8867.36	f	холодильный
843	C202500343	Косметика, 19 мест	648.50	49.41	36	9	8	3	34552.77	35715.66	2025-10-23 13:02:23	2025-10-29	\N	\N	691.06	f	обычный
844	C202500344	Косметика, 36 мест	3323.85	42.19	40	20	11	6	37631.40	13679.66	2025-12-20 13:02:23	2025-12-27	2025-12-25 13:02:23	\N	752.63	t	обычный
845	C202500345	Техника, 46 мест	3016.12	10.83	15	6	3	4	223547.76	35225.48	2025-10-10 13:02:23	2025-10-19	\N	\N	4470.96	f	обычный
846	C202500346	Запчасти, 47 мест	1084.30	17.46	20	15	7	1	170950.77	49483.56	2025-08-31 13:02:23	2025-09-12	\N	\N	3419.02	t	обычный
847	C202500347	Стройматериалы, 46 мест	1505.84	44.42	16	6	3	4	467992.55	34567.77	2025-11-30 13:02:23	2025-12-08	\N	\N	9359.85	f	холодильный
848	C202500348	Игрушки, 40 мест	4262.26	8.96	36	9	3	5	257397.00	8664.21	2025-12-15 13:02:23	2025-12-26	\N	Срочно	5147.94	t	обычный
849	C202500349	Игрушки, 26 мест	819.36	35.26	5	12	15	4	221047.23	37230.12	2026-01-16 13:02:23	2026-01-28	\N	\N	4420.94	f	обычный
850	C202500350	Косметика, 39 мест	1433.87	15.65	11	8	13	1	45413.63	21492.01	2025-08-26 13:02:23	2025-09-10	\N	\N	908.27	f	обычный
851	C202500351	Игрушки, 9 мест	3767.90	31.38	40	13	5	1	308744.10	2094.56	2025-09-28 13:02:23	2025-10-03	\N	\N	6174.88	t	обычный
852	C202500352	Косметика, 15 мест	2016.48	39.98	16	15	2	5	418443.13	43587.34	2025-11-12 13:02:23	2025-11-26	\N	\N	8368.86	f	обычный
853	C202500353	Одежда, 46 мест	2175.55	18.00	34	5	18	5	255610.10	31284.79	2025-08-19 13:02:23	2025-08-26	\N	\N	5112.20	f	холодильный
854	C202500354	Техника, 38 мест	4267.45	24.82	43	11	6	3	334641.34	10895.13	2025-09-15 13:02:23	2025-09-22	\N	\N	6692.83	f	холодильный
855	C202500355	Книги, 41 мест	1065.79	6.21	4	2	4	4	127910.16	31164.49	2025-12-08 13:02:23	2025-12-22	\N	\N	2558.20	f	холодильный
856	C202500356	Косметика, 6 мест	1118.87	27.23	37	2	13	4	16045.78	43971.20	2025-12-24 13:02:23	2025-12-31	\N	\N	320.92	f	обычный
857	C202500357	Техника, 29 мест	4330.36	4.92	13	13	19	2	233580.29	23937.36	2025-08-18 13:02:23	2025-08-27	\N	\N	4671.61	t	обычный
858	C202500358	Одежда, 8 мест	4718.52	38.01	31	14	18	4	117728.13	3141.86	2025-11-03 13:02:23	2025-11-18	\N	\N	2354.56	t	обычный
859	C202500359	Игрушки, 34 мест	4154.31	24.34	16	9	1	5	240972.12	39047.62	2026-01-04 13:02:23	2026-01-13	\N	\N	4819.44	t	обычный
860	C202500360	Одежда, 19 мест	3324.17	46.59	48	2	6	4	66841.86	35011.13	2025-12-31 13:02:23	2026-01-06	\N	\N	1336.84	f	обычный
861	C202500361	Техника, 45 мест	1167.51	41.32	34	7	10	5	140015.44	44747.61	2026-01-16 13:02:23	2026-01-26	\N	Срочно	2800.31	t	обычный
862	C202500362	Мебель, 6 мест	465.44	21.96	2	7	4	3	401097.34	23148.55	2025-09-20 13:02:23	2025-10-03	\N	\N	8021.95	f	холодильный
863	C202500363	Одежда, 9 мест	4914.08	32.74	47	5	3	7	233713.41	23784.73	2025-10-09 13:02:23	2025-10-14	2025-10-26 13:02:23	\N	4674.27	t	холодильный
864	C202500364	Одежда, 40 мест	1846.81	16.38	34	16	10	4	84852.50	29624.19	2025-11-15 13:02:23	2025-11-29	\N	Срочно	1697.05	t	холодильный
865	C202500365	Мебель, 37 мест	4627.44	26.07	13	3	17	3	40992.66	38750.86	2025-09-16 13:02:23	2025-09-29	\N	\N	819.85	t	обычный
866	C202500366	Игрушки, 50 мест	4963.60	40.84	18	13	6	4	321229.13	6093.11	2025-08-25 13:02:23	2025-09-06	\N	\N	6424.58	f	обычный
867	C202500367	Игрушки, 5 мест	2699.21	14.96	5	13	2	4	378816.12	20640.94	2025-08-27 13:02:23	2025-09-03	\N	Срочно	7576.32	f	холодильный
868	C202500368	Одежда, 15 мест	932.60	27.99	47	9	15	4	423316.26	24367.30	2025-11-22 13:02:23	2025-12-02	\N	\N	8466.33	f	обычный
869	C202500369	Стройматериалы, 18 мест	3788.34	1.65	12	9	10	4	297340.25	38077.20	2025-09-16 13:02:23	2025-10-01	\N	\N	5946.81	f	обычный
870	C202500370	Продукты, 29 мест	614.68	16.42	32	1	5	5	193935.15	48410.42	2025-10-17 13:02:23	2025-10-25	\N	Срочно	3878.70	t	обычный
871	C202500371	Запчасти, 28 мест	4265.66	38.31	37	10	3	6	114407.59	6561.09	2025-09-18 13:02:23	2025-09-26	2025-10-05 13:02:23	\N	2288.15	f	обычный
872	C202500372	Стройматериалы, 41 мест	3618.31	37.33	24	2	3	3	288889.15	29853.56	2025-10-22 13:02:23	2025-10-27	\N	\N	5777.78	t	обычный
873	C202500373	Продукты, 43 мест	4488.71	12.74	25	1	13	3	319313.58	19068.63	2025-12-16 13:02:23	2025-12-27	\N	\N	6386.27	f	обычный
874	C202500374	Электроника, 46 мест	2627.53	6.47	20	9	11	3	23772.86	40284.86	2025-12-17 13:02:23	2025-12-28	\N	Срочно	475.46	f	обычный
875	C202500375	Мебель, 44 мест	190.00	34.25	7	19	15	4	241279.08	47344.86	2025-10-31 13:02:23	2025-11-07	\N	\N	4825.58	f	обычный
876	C202500376	Продукты, 35 мест	4708.98	31.70	40	2	11	5	31445.64	32627.46	2025-10-15 13:02:23	2025-10-28	\N	\N	628.91	f	обычный
877	C202500377	Косметика, 2 мест	4896.28	19.83	19	6	20	5	16981.50	5223.76	2025-10-31 13:02:23	2025-11-14	\N	\N	339.63	t	обычный
878	C202500378	Электроника, 21 мест	4856.05	32.14	34	3	1	4	137108.99	12118.22	2025-10-11 13:02:23	2025-10-22	\N	\N	2742.18	f	обычный
879	C202500379	Запчасти, 16 мест	158.51	24.77	28	18	6	7	170319.51	8530.70	2025-10-01 13:02:23	2025-10-13	2025-10-09 13:02:23	Срочно	3406.39	f	холодильный
880	C202500380	Одежда, 7 мест	4398.10	26.92	3	17	9	4	279709.18	12629.76	2026-01-19 13:02:23	2026-01-27	\N	\N	5594.18	f	холодильный
881	C202500381	Стройматериалы, 5 мест	3466.63	29.38	35	2	19	2	25201.07	19588.11	2025-10-19 13:02:23	2025-10-27	\N	\N	504.02	t	обычный
882	C202500382	Косметика, 33 мест	3038.95	21.27	32	17	12	4	117119.73	27050.57	2026-01-15 13:02:23	2026-01-25	\N	Срочно	2342.39	f	обычный
883	C202500383	Запчасти, 1 мест	1910.79	39.98	15	16	14	4	439781.51	42345.36	2025-11-19 13:02:23	2025-12-02	\N	\N	8795.63	f	обычный
884	C202500384	Продукты, 15 мест	2645.42	4.30	5	18	15	3	279471.74	30794.61	2025-10-21 13:02:23	2025-10-26	\N	\N	5589.43	t	холодильный
885	C202500385	Электроника, 42 мест	1845.10	34.66	10	14	4	3	423761.52	10066.22	2025-09-13 13:02:23	2025-09-19	\N	\N	8475.23	t	обычный
886	C202500386	Одежда, 47 мест	3178.74	17.57	32	11	9	4	106228.77	14640.26	2025-09-18 13:02:23	2025-09-28	\N	\N	2124.58	f	холодильный
887	C202500387	Запчасти, 46 мест	3198.04	11.40	26	11	14	1	475353.63	27777.79	2025-09-11 13:02:23	2025-09-23	\N	\N	9507.07	f	обычный
888	C202500388	Электроника, 2 мест	4601.22	43.95	2	15	4	4	381174.42	43089.54	2026-01-01 13:02:23	2026-01-13	\N	\N	7623.49	t	обычный
889	C202500389	Электроника, 30 мест	1970.64	16.64	12	18	1	1	96271.19	36428.46	2025-09-23 13:02:23	2025-10-07	\N	\N	1925.42	t	обычный
890	C202500390	Электроника, 16 мест	4173.04	11.67	12	16	5	6	338131.81	35745.91	2025-11-29 13:02:23	2025-12-10	2025-12-07 13:02:23	Срочно	6762.64	f	обычный
891	C202500391	Продукты, 50 мест	1898.50	5.13	8	10	20	2	451125.02	12049.12	2026-01-11 13:02:23	2026-01-20	\N	\N	9022.50	f	обычный
892	C202500392	Одежда, 30 мест	2348.36	23.03	27	2	17	5	451968.10	15295.34	2025-12-14 13:02:23	2025-12-29	\N	\N	9039.36	f	обычный
893	C202500393	Одежда, 17 мест	3947.95	12.09	27	18	15	1	471436.36	39741.78	2025-07-27 13:02:23	2025-08-08	\N	\N	9428.73	f	холодильный
894	C202500394	Запчасти, 22 мест	1845.27	34.54	6	13	18	4	369460.07	31689.84	2025-12-01 13:02:23	2025-12-16	\N	Срочно	7389.20	t	обычный
895	C202500395	Косметика, 48 мест	4108.15	27.32	19	13	17	4	251153.53	26761.52	2025-09-11 13:02:23	2025-09-17	\N	\N	5023.07	t	обычный
896	C202500396	Техника, 15 мест	3964.72	24.66	39	7	8	5	312194.98	27153.96	2025-09-29 13:02:23	2025-10-07	\N	\N	6243.90	f	холодильный
897	C202500397	Стройматериалы, 39 мест	3541.36	21.74	44	19	17	2	248678.28	35555.66	2026-01-15 13:02:23	2026-01-29	\N	\N	4973.57	f	обычный
898	C202500398	Запчасти, 45 мест	2570.26	44.03	39	6	2	3	416451.60	5044.39	2025-12-22 13:02:23	2026-01-03	\N	Срочно	8329.03	t	обычный
899	C202500399	Косметика, 8 мест	4795.38	41.63	50	10	13	2	155701.00	36101.48	2025-07-26 13:02:23	2025-08-08	\N	\N	3114.02	f	обычный
900	C202500400	Мебель, 2 мест	1745.44	3.26	44	17	13	6	244713.21	13281.28	2025-11-09 13:02:23	2025-11-23	2025-11-24 13:02:23	\N	4894.26	f	холодильный
901	C202500401	Мебель, 46 мест	2704.12	44.83	26	12	2	5	431334.10	48220.20	2025-11-07 13:02:23	2025-11-13	\N	Срочно	8626.68	t	холодильный
902	C202500402	Электроника, 17 мест	2184.58	9.79	13	2	14	7	75536.74	20256.19	2025-11-28 13:02:23	2025-12-12	2025-12-17 13:02:23	Срочно	1510.73	t	обычный
903	C202500403	Продукты, 44 мест	1088.21	28.52	34	19	11	4	266413.64	35243.27	2025-07-29 13:02:23	2025-08-10	\N	\N	5328.27	f	обычный
904	C202500404	Игрушки, 18 мест	2116.31	36.15	20	2	11	4	287700.30	31564.40	2025-09-28 13:02:23	2025-10-13	\N	\N	5754.01	f	обычный
905	C202500405	Книги, 40 мест	1873.37	13.33	33	20	14	5	55541.02	25510.61	2025-09-13 13:02:23	2025-09-18	\N	Срочно	1110.82	f	обычный
906	C202500406	Игрушки, 20 мест	2018.90	17.86	29	5	4	5	285685.46	44496.78	2025-09-15 13:02:23	2025-09-21	\N	Срочно	5713.71	f	обычный
907	C202500407	Электроника, 38 мест	2429.99	15.31	26	3	13	6	144143.98	16730.57	2025-10-03 13:02:23	2025-10-18	2025-10-15 13:02:23	\N	2882.88	f	обычный
908	C202500408	Книги, 48 мест	2864.49	36.07	33	10	20	4	119157.30	43281.99	2025-10-27 13:02:23	2025-11-10	\N	\N	2383.15	t	обычный
909	C202500409	Книги, 1 мест	1625.58	39.76	29	6	7	5	318996.80	47320.11	2025-11-29 13:02:23	2025-12-12	\N	\N	6379.94	f	холодильный
910	C202500410	Техника, 40 мест	1047.57	10.87	48	18	5	4	149700.70	1229.41	2025-08-13 13:02:23	2025-08-21	\N	\N	2994.01	t	обычный
911	C202500411	Продукты, 7 мест	2148.75	42.62	5	9	20	6	146333.93	24168.25	2025-09-19 13:02:23	2025-10-03	2025-10-08 13:02:23	\N	2926.68	t	холодильный
912	C202500412	Одежда, 37 мест	1798.12	16.11	9	19	6	3	462060.91	4707.22	2025-07-27 13:02:23	2025-08-10	\N	Срочно	9241.22	f	обычный
913	C202500413	Косметика, 31 мест	1591.67	15.11	46	11	9	1	160966.69	8855.99	2025-11-05 13:02:23	2025-11-11	\N	Срочно	3219.33	f	холодильный
914	C202500414	Игрушки, 44 мест	4234.98	37.58	22	19	7	5	304052.82	15861.20	2025-11-27 13:02:23	2025-12-09	\N	\N	6081.06	f	холодильный
915	C202500415	Одежда, 22 мест	2605.97	9.05	49	16	9	2	267316.59	15493.33	2025-09-06 13:02:23	2025-09-20	\N	\N	5346.33	f	обычный
916	C202500416	Запчасти, 21 мест	866.06	2.23	16	13	11	5	485807.50	6698.83	2025-11-21 13:02:23	2025-12-01	\N	Срочно	9716.15	t	холодильный
917	C202500417	Продукты, 3 мест	3126.18	2.28	42	13	5	3	220528.12	22259.92	2025-11-27 13:02:23	2025-12-08	\N	\N	4410.56	f	обычный
918	C202500418	Мебель, 7 мест	703.80	42.67	25	10	19	4	242924.25	20385.54	2026-01-07 13:02:23	2026-01-14	\N	Срочно	4858.48	t	обычный
919	C202500419	Электроника, 14 мест	942.11	30.98	6	16	18	2	270371.53	37301.20	2025-10-13 13:02:23	2025-10-19	\N	\N	5407.43	f	обычный
920	C202500420	Стройматериалы, 3 мест	218.36	12.51	46	6	15	2	137721.90	47861.29	2025-09-04 13:02:23	2025-09-11	\N	\N	2754.44	f	холодильный
921	C202500421	Техника, 19 мест	1508.83	21.46	21	10	15	3	481210.77	26818.51	2025-11-13 13:02:23	2025-11-20	\N	Срочно	9624.22	f	обычный
922	C202500422	Электроника, 8 мест	4146.63	16.62	1	1	9	5	253610.51	9120.24	2025-12-10 13:02:23	2025-12-18	\N	Срочно	5072.21	f	обычный
923	C202500423	Игрушки, 35 мест	717.80	5.96	2	7	11	5	156213.10	38093.66	2025-10-13 13:02:23	2025-10-18	\N	Срочно	3124.26	f	обычный
924	C202500424	Электроника, 1 мест	2542.45	36.99	9	6	8	6	430366.63	35130.92	2025-10-22 13:02:23	2025-10-27	2025-11-06 13:02:23	\N	8607.33	f	обычный
925	C202500425	Запчасти, 29 мест	4154.32	1.54	44	17	2	3	297994.49	21175.09	2025-09-15 13:02:23	2025-09-27	\N	\N	5959.89	f	холодильный
926	C202500426	Электроника, 25 мест	4368.06	16.20	13	3	7	1	157231.26	15927.55	2025-09-21 13:02:23	2025-10-03	\N	Срочно	3144.63	f	обычный
927	C202500427	Запчасти, 14 мест	4328.50	15.83	37	6	3	4	450510.35	38626.37	2025-09-22 13:02:23	2025-09-27	\N	Срочно	9010.21	f	обычный
928	C202500428	Игрушки, 10 мест	3004.94	1.85	11	18	19	6	333855.42	18589.66	2025-10-14 13:02:23	2025-10-19	2025-11-03 13:02:23	Срочно	6677.11	f	обычный
929	C202500429	Запчасти, 9 мест	3400.29	39.63	10	14	2	4	449602.49	21344.27	2025-09-06 13:02:23	2025-09-17	\N	Срочно	8992.05	t	холодильный
930	C202500430	Косметика, 28 мест	3004.56	19.38	27	20	9	4	119438.15	16201.94	2025-10-07 13:02:23	2025-10-17	\N	\N	2388.76	f	холодильный
931	C202500431	Игрушки, 25 мест	2829.56	4.01	9	7	20	3	162384.42	10734.92	2025-10-03 13:02:23	2025-10-10	\N	\N	3247.69	t	холодильный
932	C202500432	Книги, 18 мест	2916.40	13.03	16	12	3	3	410567.57	22881.86	2025-09-02 13:02:23	2025-09-13	\N	\N	8211.35	f	холодильный
933	C202500433	Одежда, 14 мест	2925.55	4.36	22	9	2	4	121799.14	44368.41	2025-09-22 13:02:23	2025-10-02	\N	\N	2435.98	f	обычный
934	C202500434	Одежда, 22 мест	4827.36	40.46	38	4	15	6	117506.07	37335.07	2025-11-13 13:02:23	2025-11-18	2025-11-23 13:02:23	\N	2350.12	f	обычный
935	C202500435	Запчасти, 43 мест	678.56	10.58	14	10	7	5	92043.35	22802.24	2025-10-12 13:02:23	2025-10-19	\N	\N	1840.87	t	холодильный
936	C202500436	Продукты, 12 мест	1249.52	13.96	47	5	13	3	422122.27	15112.63	2025-12-19 13:02:23	2026-01-03	\N	\N	8442.45	f	обычный
937	C202500437	Косметика, 43 мест	1594.55	42.17	37	15	6	3	53458.83	1592.71	2025-07-27 13:02:23	2025-08-10	\N	Срочно	1069.18	t	обычный
938	C202500438	Игрушки, 5 мест	2165.18	22.96	24	15	17	5	185959.95	32946.56	2025-12-12 13:02:23	2025-12-18	\N	Срочно	3719.20	t	обычный
939	C202500439	Косметика, 19 мест	4965.34	14.37	25	16	13	1	18712.69	39135.38	2025-08-24 13:02:23	2025-09-03	\N	\N	374.25	f	обычный
940	C202500440	Книги, 16 мест	3604.90	32.61	43	5	12	6	143010.54	34460.54	2025-08-08 13:02:23	2025-08-14	2025-08-23 13:02:23	\N	2860.21	f	обычный
941	C202500441	Книги, 14 мест	2012.40	2.01	38	4	18	5	8388.50	35429.27	2025-12-16 13:02:23	2025-12-31	\N	\N	167.77	f	холодильный
942	C202500442	Запчасти, 32 мест	1759.61	49.31	29	6	9	7	96556.85	29472.32	2025-08-16 13:02:23	2025-08-25	2025-09-01 13:02:23	\N	1931.14	f	обычный
943	C202500443	Электроника, 30 мест	3265.94	23.99	34	18	2	6	278263.15	25777.11	2025-09-24 13:02:23	2025-10-01	2025-10-09 13:02:23	\N	5565.26	f	обычный
944	C202500444	Техника, 44 мест	1449.11	16.98	13	12	3	4	337159.43	10620.04	2025-09-19 13:02:23	2025-09-28	\N	Срочно	6743.19	f	холодильный
945	C202500445	Запчасти, 34 мест	4781.34	37.86	37	10	11	2	444211.98	45902.82	2025-08-23 13:02:23	2025-09-03	\N	Срочно	8884.24	f	обычный
946	C202500446	Книги, 7 мест	4983.18	15.81	13	16	18	4	220591.99	23849.83	2025-12-09 13:02:23	2025-12-14	\N	Срочно	4411.84	f	обычный
947	C202500447	Продукты, 38 мест	3511.67	19.90	24	3	19	5	96998.46	25568.43	2025-10-13 13:02:23	2025-10-27	\N	\N	1939.97	t	обычный
948	C202500448	Запчасти, 16 мест	4460.22	40.89	23	17	16	5	498753.32	43444.11	2025-12-25 13:02:23	2026-01-02	\N	\N	9975.07	t	обычный
949	C202500449	Мебель, 50 мест	1540.20	28.59	19	11	13	3	74338.07	47488.36	2025-12-18 13:02:23	2026-01-02	\N	Срочно	1486.76	t	холодильный
950	C202500450	Электроника, 10 мест	1141.90	44.91	22	6	15	4	259137.85	30611.03	2025-08-17 13:02:23	2025-08-23	\N	\N	5182.76	f	обычный
951	C202500451	Техника, 23 мест	545.94	43.97	36	8	12	5	417311.56	5778.06	2026-01-18 13:02:23	2026-02-01	\N	\N	8346.23	t	обычный
952	C202500452	Стройматериалы, 18 мест	2832.93	46.16	21	18	5	6	212148.65	47608.83	2025-08-26 13:02:23	2025-09-07	2025-09-02 13:02:23	Срочно	4242.97	t	обычный
953	C202500453	Косметика, 34 мест	3019.94	35.55	46	2	7	4	490312.73	4104.41	2025-09-29 13:02:23	2025-10-12	\N	\N	9806.25	f	обычный
954	C202500454	Техника, 19 мест	529.23	12.63	43	11	1	4	276949.99	36001.29	2025-10-24 13:02:23	2025-11-03	\N	\N	5539.00	f	обычный
955	C202500455	Стройматериалы, 20 мест	1960.35	35.36	1	1	13	7	103333.92	26564.79	2025-08-22 13:02:23	2025-09-01	2025-09-09 13:02:23	\N	2066.68	t	обычный
956	C202500456	Запчасти, 47 мест	1688.85	14.07	33	7	15	4	301177.57	3759.47	2025-08-03 13:02:23	2025-08-15	\N	\N	6023.55	f	обычный
957	C202500457	Игрушки, 20 мест	2314.86	18.84	26	2	15	5	368790.19	41262.31	2025-09-18 13:02:23	2025-09-30	\N	\N	7375.80	f	холодильный
958	C202500458	Продукты, 9 мест	4673.10	1.61	20	4	19	4	230312.96	42406.65	2025-07-28 13:02:23	2025-08-11	\N	\N	4606.26	f	обычный
959	C202500459	Мебель, 22 мест	334.89	1.88	31	17	13	5	242434.27	40420.02	2025-10-05 13:02:23	2025-10-12	\N	\N	4848.69	f	холодильный
960	C202500460	Игрушки, 7 мест	4770.00	2.29	16	9	6	3	408609.92	42834.83	2026-01-08 13:02:23	2026-01-17	\N	\N	8172.20	f	обычный
961	C202500461	Косметика, 34 мест	1392.62	39.58	6	5	20	3	54665.11	1352.55	2025-09-19 13:02:23	2025-09-28	\N	\N	1093.30	t	обычный
962	C202500462	Электроника, 18 мест	4872.37	24.89	1	5	3	4	124763.66	48521.83	2025-12-28 13:02:23	2026-01-05	\N	\N	2495.27	t	обычный
963	C202500463	Техника, 8 мест	4604.22	31.30	34	14	7	4	139422.51	9621.68	2025-12-22 13:02:23	2026-01-03	\N	\N	2788.45	f	обычный
964	C202500464	Мебель, 3 мест	419.30	35.77	47	9	19	7	170514.77	31892.24	2025-12-31 13:02:23	2026-01-13	2026-01-10 13:02:23	\N	3410.30	f	обычный
965	C202500465	Игрушки, 19 мест	2780.45	7.72	4	7	11	6	486031.01	32485.83	2025-09-09 13:02:23	2025-09-22	2025-09-15 13:02:23	\N	9720.62	f	обычный
966	C202500466	Мебель, 25 мест	3081.85	26.15	29	1	11	2	145303.50	24261.78	2025-08-14 13:02:23	2025-08-23	\N	\N	2906.07	t	обычный
967	C202500467	Запчасти, 37 мест	1561.71	23.23	10	12	16	5	34245.09	34929.97	2026-01-10 13:02:23	2026-01-21	\N	\N	684.90	f	обычный
968	C202500468	Техника, 32 мест	4230.39	2.94	29	10	14	2	356347.33	39867.97	2025-09-15 13:02:23	2025-09-24	\N	\N	7126.95	f	обычный
969	C202500469	Косметика, 10 мест	1704.62	44.39	37	3	12	7	213988.08	33521.82	2025-08-20 13:02:23	2025-08-30	2025-08-23 13:02:23	\N	4279.76	f	обычный
970	C202500470	Стройматериалы, 14 мест	2322.97	12.70	36	3	11	1	306406.47	24736.98	2025-07-31 13:02:23	2025-08-08	\N	\N	6128.13	f	обычный
971	C202500471	Игрушки, 29 мест	2685.16	39.21	33	11	10	5	447632.90	34223.86	2025-12-03 13:02:23	2025-12-16	\N	Срочно	8952.66	f	обычный
972	C202500472	Стройматериалы, 45 мест	905.92	7.45	29	2	10	4	34652.46	11168.03	2025-12-09 13:02:23	2025-12-22	\N	\N	693.05	f	холодильный
973	C202500473	Косметика, 42 мест	236.86	25.85	25	13	14	3	497396.55	26725.52	2025-08-10 13:02:23	2025-08-22	\N	\N	9947.93	t	обычный
974	C202500474	Косметика, 34 мест	2196.13	3.16	49	4	20	5	164857.77	34353.53	2026-01-17 13:02:23	2026-01-22	\N	\N	3297.16	t	обычный
975	C202500475	Книги, 40 мест	1818.19	17.97	34	15	18	5	192108.57	43190.24	2025-10-18 13:02:23	2025-11-02	\N	\N	3842.17	f	холодильный
976	C202500476	Продукты, 37 мест	2199.30	39.55	18	13	12	4	339972.69	41430.51	2025-12-17 13:02:23	2025-12-23	\N	\N	6799.45	t	холодильный
977	C202500477	Косметика, 7 мест	816.71	9.85	18	10	15	1	173954.40	47031.60	2025-10-01 13:02:23	2025-10-11	\N	\N	3479.09	f	обычный
978	C202500478	Одежда, 47 мест	4050.53	11.68	49	15	5	4	401051.80	28308.39	2025-09-08 13:02:23	2025-09-15	\N	\N	8021.04	f	обычный
979	C202500479	Игрушки, 36 мест	3637.57	48.10	48	7	20	6	310282.16	46498.09	2025-11-28 13:02:23	2025-12-04	2025-12-17 13:02:23	\N	6205.64	t	обычный
980	C202500480	Техника, 9 мест	2040.16	31.59	18	18	19	4	350955.42	36252.02	2025-08-29 13:02:23	2025-09-03	\N	\N	7019.11	f	обычный
981	C202500481	Запчасти, 31 мест	2194.93	8.48	10	17	20	6	443414.11	11798.51	2025-09-03 13:02:23	2025-09-12	2025-09-20 13:02:23	Срочно	8868.28	f	обычный
982	C202500482	Техника, 49 мест	538.47	6.55	31	4	15	3	19878.83	35603.15	2025-07-27 13:02:23	2025-08-01	\N	\N	397.58	f	холодильный
983	C202500483	Косметика, 19 мест	2880.32	5.03	17	3	7	2	94934.86	27494.08	2025-09-14 13:02:23	2025-09-23	\N	Срочно	1898.70	f	холодильный
984	C202500484	Книги, 7 мест	4188.76	46.27	35	19	9	3	144114.58	25445.05	2025-12-12 13:02:23	2025-12-23	\N	\N	2882.29	f	холодильный
985	C202500485	Косметика, 10 мест	4438.72	7.26	12	12	15	2	488531.92	43140.30	2026-01-16 13:02:23	2026-01-27	\N	\N	9770.64	f	обычный
986	C202500486	Книги, 25 мест	2782.23	35.19	35	13	10	5	359807.87	4001.88	2025-10-21 13:02:23	2025-10-30	\N	\N	7196.16	t	холодильный
987	C202500487	Книги, 35 мест	4676.20	26.79	9	12	11	6	280464.39	11067.81	2025-10-13 13:02:23	2025-10-25	2025-10-20 13:02:23	\N	5609.29	f	холодильный
988	C202500488	Одежда, 45 мест	4382.14	20.89	20	11	19	6	382383.66	27436.46	2025-11-24 13:02:23	2025-11-29	2025-12-04 13:02:23	\N	7647.67	f	обычный
989	C202500489	Косметика, 37 мест	4478.35	26.83	44	6	7	6	13587.16	47038.58	2025-08-30 13:02:23	2025-09-06	2025-09-08 13:02:23	\N	271.74	t	холодильный
990	C202500490	Запчасти, 37 мест	2117.98	28.39	3	9	8	4	320284.30	4366.61	2026-01-15 13:02:23	2026-01-27	\N	\N	6405.69	f	обычный
991	C202500491	Мебель, 30 мест	1242.43	33.28	19	13	15	7	308157.66	43837.30	2025-12-25 13:02:23	2025-12-31	2026-01-07 13:02:23	\N	6163.15	f	обычный
992	C202500492	Книги, 8 мест	1962.09	15.20	24	7	15	4	365352.36	25008.05	2025-08-05 13:02:23	2025-08-18	\N	\N	7307.05	f	обычный
993	C202500493	Косметика, 1 мест	1027.69	35.72	2	14	20	3	67815.54	18967.87	2025-09-26 13:02:23	2025-10-04	\N	\N	1356.31	f	холодильный
994	C202500494	Электроника, 14 мест	4346.59	3.11	9	4	9	4	88424.42	9593.92	2025-11-21 13:02:23	2025-11-27	\N	\N	1768.49	f	обычный
995	C202500495	Книги, 47 мест	3095.32	10.58	5	15	8	4	491482.82	30126.92	2025-08-12 13:02:23	2025-08-20	\N	\N	9829.66	t	обычный
996	C202500496	Запчасти, 8 мест	4484.03	7.82	30	5	11	2	21228.83	30562.01	2025-08-04 13:02:23	2025-08-10	\N	\N	424.58	f	обычный
997	C202500497	Электроника, 2 мест	4272.16	14.75	16	7	1	2	265740.44	37113.98	2025-08-08 13:02:23	2025-08-18	\N	Срочно	5314.81	f	обычный
998	C202500498	Мебель, 26 мест	4994.45	12.99	17	10	3	4	251270.33	36652.74	2025-11-26 13:02:23	2025-12-01	\N	\N	5025.41	t	холодильный
999	C202500499	Техника, 42 мест	3680.94	5.64	11	3	14	5	110528.24	16081.64	2025-09-06 13:02:23	2025-09-15	\N	\N	2210.56	f	обычный
1000	C202500500	Книги, 40 мест	1640.39	3.27	24	9	1	1	445130.71	7117.78	2025-08-20 13:02:23	2025-09-03	\N	\N	8902.61	t	обычный
\.


--
-- Data for Name: история_статусов; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."история_статусов" ("ид_история", "ид_груз", "ид_статус_старый", "ид_статус_новый", "дата_изменения", "комментарий", "ид_пользователь") FROM stdin;
1453	1	1	2	2025-07-31 12:02:23	\N	3
1454	1	2	3	2025-10-30 03:02:23	\N	3
1455	1	3	4	2025-09-02 11:02:23	\N	4
1456	1	4	5	2025-08-19 01:02:23	\N	1
1457	2	1	2	2025-10-07 11:02:23	\N	\N
1458	2	2	3	2026-01-12 18:02:23	\N	1
1459	2	3	4	2025-12-22 04:02:23	\N	3
1460	3	1	2	2025-12-25 20:02:23	\N	5
1461	3	2	3	2025-10-25 18:02:23	\N	\N
1462	4	1	2	2025-08-22 12:02:23	\N	5
1463	4	2	3	2025-10-21 22:02:23	\N	\N
1464	5	1	2	2025-12-20 07:02:23	\N	1
1465	5	2	3	2026-01-04 21:02:23	\N	\N
1466	6	1	2	2025-11-20 16:02:23	\N	4
1467	6	2	3	2025-08-13 04:02:23	\N	4
1468	7	1	2	2025-11-17 03:02:23	\N	1
1469	7	2	3	2025-10-16 07:02:23	\N	3
1470	8	1	2	2025-11-20 02:02:23	\N	2
1471	8	2	3	2025-10-18 22:02:23	\N	3
1472	8	3	4	2025-11-14 03:02:23	\N	\N
1473	9	1	2	2025-10-27 06:02:23	\N	5
1474	9	2	3	2025-10-28 21:02:23	\N	3
1475	10	1	2	2025-12-07 10:02:23	\N	\N
1476	10	2	3	2025-08-31 22:02:23	\N	1
1477	10	3	4	2025-08-17 09:02:23	\N	1
1478	10	4	5	2026-01-14 10:02:23	\N	2
1479	11	1	2	2025-09-10 20:02:23	\N	5
1480	11	2	3	2025-09-10 17:02:23	\N	3
1481	12	1	2	2026-01-03 03:02:23	\N	5
1482	12	2	3	2025-08-12 09:02:23	\N	\N
1483	12	3	4	2025-08-27 13:02:23	\N	2
1484	13	1	2	2025-10-29 05:02:23	\N	4
1485	13	2	3	2025-08-16 02:02:23	\N	\N
1486	13	3	4	2026-01-19 03:02:23	\N	5
1487	13	4	5	2026-01-02 14:02:23	\N	2
1488	14	1	2	2025-09-18 02:02:23	\N	5
1489	14	2	3	2025-08-01 16:02:23	\N	5
1490	14	3	4	2025-11-14 05:02:23	\N	2
1491	14	4	5	2025-12-11 13:02:23	\N	2
1492	15	1	2	2025-08-26 22:02:23	\N	3
1493	15	2	3	2025-12-21 14:02:23	\N	\N
1494	16	1	2	2025-09-29 12:02:23	\N	2
1495	16	2	3	2025-10-07 19:02:23	\N	3
1496	17	1	2	2026-01-02 01:02:23	\N	2
1497	17	2	3	2025-08-06 19:02:23	\N	2
1498	17	3	4	2025-12-03 08:02:23	\N	4
1499	18	1	2	2025-09-20 01:02:23	\N	\N
1500	18	2	3	2025-08-27 04:02:23	\N	2
1501	18	3	4	2025-10-31 11:02:23	\N	4
1502	18	4	5	2025-08-08 21:02:23	\N	5
1503	19	1	2	2025-11-22 23:02:23	\N	1
1504	19	2	3	2025-09-12 22:02:23	\N	3
1505	19	3	4	2025-10-17 00:02:23	\N	1
1506	20	1	2	2025-12-14 06:02:23	\N	\N
1507	20	2	3	2025-09-08 23:02:23	\N	5
1508	21	1	2	2025-09-01 01:02:23	\N	\N
1509	21	2	3	2026-01-19 05:02:23	\N	5
1510	21	3	4	2025-10-11 05:02:23	\N	\N
1511	22	1	2	2025-11-04 18:02:23	\N	\N
1512	22	2	3	2025-10-10 05:02:23	\N	2
1513	22	3	4	2025-12-16 20:02:23	\N	3
1514	23	1	2	2025-08-06 05:02:23	\N	\N
1515	23	2	3	2025-12-27 16:02:23	\N	2
1516	23	3	4	2025-12-04 00:02:23	\N	1
1517	23	4	5	2025-10-22 14:02:23	\N	\N
1518	24	1	2	2025-12-14 22:02:23	\N	4
1519	24	2	3	2025-09-24 00:02:23	\N	4
1520	25	1	2	2025-12-26 06:02:23	\N	\N
1521	25	2	3	2025-09-08 11:02:23	\N	4
1522	25	3	4	2025-12-21 07:02:23	\N	\N
1523	26	1	2	2025-12-12 06:02:23	\N	5
1524	26	2	3	2025-10-10 08:02:23	\N	3
1525	27	1	2	2025-11-07 03:02:23	\N	5
1526	27	2	3	2025-11-05 11:02:23	\N	\N
1527	27	3	4	2025-12-29 06:02:23	\N	1
1528	27	4	5	2025-11-24 18:02:23	\N	\N
1529	28	1	2	2026-01-05 13:02:23	\N	\N
1530	28	2	3	2025-12-07 23:02:23	\N	4
1531	28	3	4	2025-11-21 17:02:23	\N	4
1532	29	1	2	2025-09-18 19:02:23	\N	\N
1533	29	2	3	2025-12-01 15:02:23	\N	3
1534	30	1	2	2025-08-14 00:02:23	\N	1
1535	30	2	3	2025-08-03 01:02:23	\N	4
1536	30	3	4	2025-12-03 18:02:23	\N	\N
1537	30	4	5	2026-01-19 15:02:23	\N	5
1538	31	1	2	2025-11-02 17:02:23	\N	1
1539	31	2	3	2025-08-23 02:02:23	\N	4
1540	31	3	4	2025-09-09 03:02:23	\N	5
1541	31	4	5	2025-11-10 15:02:23	\N	5
1542	32	1	2	2025-10-02 02:02:23	\N	\N
1543	32	2	3	2025-09-19 22:02:23	\N	\N
1544	33	1	2	2025-09-25 09:02:23	\N	\N
1545	33	2	3	2025-09-11 16:02:23	\N	\N
1546	33	3	4	2025-12-14 02:02:23	\N	2
1547	33	4	5	2025-08-13 21:02:23	\N	\N
1548	34	1	2	2025-12-17 04:02:23	\N	3
1549	34	2	3	2025-11-19 09:02:23	\N	3
1550	35	1	2	2025-09-19 03:02:23	\N	\N
1551	35	2	3	2025-08-30 20:02:23	\N	5
1552	36	1	2	2025-12-07 12:02:23	\N	\N
1553	36	2	3	2025-10-24 03:02:23	\N	5
1554	36	3	4	2025-12-20 00:02:23	\N	1
1555	36	4	5	2025-08-13 20:02:23	\N	1
1556	37	1	2	2025-09-19 05:02:23	\N	\N
1557	37	2	3	2025-10-15 21:02:23	\N	\N
1558	38	1	2	2025-08-08 18:02:23	\N	\N
1559	38	2	3	2025-12-25 12:02:23	\N	5
1560	39	1	2	2025-08-27 21:02:23	\N	2
1561	39	2	3	2025-11-20 11:02:23	\N	5
1562	39	3	4	2025-10-10 03:02:23	\N	2
1563	40	1	2	2025-08-28 16:02:23	\N	5
1564	40	2	3	2025-12-04 13:02:23	\N	3
1565	41	1	2	2025-12-21 03:02:23	\N	\N
1566	41	2	3	2025-09-08 21:02:23	\N	\N
1567	41	3	4	2025-10-03 02:02:23	\N	4
1568	42	1	2	2025-07-28 11:02:23	\N	2
1569	42	2	3	2025-10-26 01:02:23	\N	3
1570	42	3	4	2025-10-05 17:02:23	\N	3
1571	43	1	2	2025-10-23 10:02:23	\N	5
1572	43	2	3	2025-11-29 17:02:23	\N	1
1573	43	3	4	2025-10-09 04:02:23	\N	\N
1574	43	4	5	2025-09-12 15:02:23	\N	1
1575	44	1	2	2025-08-04 10:02:23	\N	1
1576	44	2	3	2025-11-25 02:02:23	\N	\N
1577	44	3	4	2025-11-05 09:02:23	\N	3
1578	45	1	2	2025-12-11 22:02:23	\N	2
1579	45	2	3	2025-11-08 17:02:23	\N	1
1580	46	1	2	2025-12-06 20:02:23	\N	4
1581	46	2	3	2025-12-23 18:02:23	\N	1
1582	46	3	4	2025-12-26 09:02:23	\N	4
1583	47	1	2	2025-08-10 22:02:23	\N	2
1584	47	2	3	2025-09-10 17:02:23	\N	3
1585	47	3	4	2025-08-13 22:02:23	\N	5
1586	48	1	2	2025-09-12 18:02:23	\N	2
1587	48	2	3	2025-09-20 06:02:23	\N	2
1588	49	1	2	2026-01-05 13:02:23	\N	4
1589	49	2	3	2026-01-08 00:02:23	\N	\N
1590	49	3	4	2025-09-04 04:02:23	\N	\N
1591	49	4	5	2025-08-13 16:02:23	\N	3
1592	50	1	2	2025-09-26 07:02:23	\N	3
1593	50	2	3	2025-10-13 07:02:23	\N	4
1594	51	1	2	2025-11-15 18:02:23	\N	4
1595	51	2	3	2025-09-07 02:02:23	\N	3
1596	51	3	4	2025-09-05 05:02:23	\N	\N
1597	51	4	5	2026-01-12 10:02:23	\N	5
1598	52	1	2	2025-09-20 17:02:23	\N	4
1599	52	2	3	2026-01-20 12:02:23	\N	5
1600	52	3	4	2026-01-20 03:02:23	\N	4
1601	53	1	2	2025-09-25 18:02:23	\N	2
1602	53	2	3	2025-10-07 05:02:23	\N	1
1603	53	3	4	2025-08-31 19:02:23	\N	2
1604	54	1	2	2025-08-23 11:02:23	\N	\N
1605	54	2	3	2025-08-22 23:02:23	\N	2
1606	55	1	2	2025-10-26 15:02:23	\N	4
1607	55	2	3	2025-12-25 21:02:23	\N	\N
1608	55	3	4	2025-10-26 11:02:23	\N	4
1609	55	4	5	2025-11-09 22:02:23	\N	2
1610	56	1	2	2025-10-15 20:02:23	\N	1
1611	56	2	3	2025-08-08 00:02:23	\N	\N
1612	56	3	4	2025-12-03 10:02:23	\N	\N
1613	56	4	5	2025-10-04 23:02:23	\N	4
1614	57	1	2	2025-10-03 13:02:23	\N	1
1615	57	2	3	2026-01-07 12:02:23	\N	3
1616	57	3	4	2025-11-05 08:02:23	\N	1
1617	58	1	2	2025-07-30 11:02:23	\N	\N
1618	58	2	3	2025-11-11 12:02:23	\N	3
1619	58	3	4	2025-08-05 10:02:23	\N	1
1620	59	1	2	2025-12-28 02:02:23	\N	3
1621	59	2	3	2025-10-27 14:02:23	\N	2
1622	60	1	2	2025-07-27 04:02:23	\N	1
1623	60	2	3	2025-12-10 23:02:23	\N	\N
1624	60	3	4	2025-09-25 08:02:23	\N	\N
1625	61	1	2	2025-08-05 22:02:23	\N	4
1626	61	2	3	2026-01-15 21:02:23	\N	\N
1627	61	3	4	2025-12-02 17:02:23	\N	5
1628	61	4	5	2025-10-19 06:02:23	\N	\N
1629	62	1	2	2025-11-13 23:02:23	\N	5
1630	62	2	3	2025-11-23 00:02:23	\N	4
1631	62	3	4	2025-09-16 20:02:23	\N	\N
1632	62	4	5	2025-08-30 03:02:23	\N	1
1633	63	1	2	2026-01-10 12:02:23	\N	1
1634	63	2	3	2025-12-04 16:02:23	\N	\N
1635	64	1	2	2025-08-30 06:02:23	\N	1
1636	64	2	3	2025-08-28 06:02:23	\N	2
1637	64	3	4	2026-01-02 14:02:23	\N	4
1638	65	1	2	2025-08-31 11:02:23	\N	3
1639	65	2	3	2025-12-15 22:02:23	\N	\N
1640	65	3	4	2025-10-21 00:02:23	\N	5
1641	66	1	2	2025-11-13 20:02:23	\N	5
1642	66	2	3	2025-12-24 12:02:23	\N	1
1643	67	1	2	2025-10-09 13:02:23	\N	\N
1644	67	2	3	2025-12-05 05:02:23	\N	2
1645	67	3	4	2026-01-06 02:02:23	\N	\N
1646	68	1	2	2025-08-26 05:02:23	\N	\N
1647	68	2	3	2025-12-21 15:02:23	\N	3
1648	68	3	4	2025-12-28 15:02:23	\N	4
1649	68	4	5	2025-08-13 18:02:23	\N	1
1650	69	1	2	2025-09-11 19:02:23	\N	4
1651	69	2	3	2026-01-20 10:02:23	\N	1
1652	69	3	4	2025-09-14 05:02:23	\N	3
1653	69	4	5	2025-08-09 16:02:23	\N	3
1654	70	1	2	2025-12-19 10:02:23	\N	2
1655	70	2	3	2025-09-17 06:02:23	\N	5
1656	70	3	4	2025-10-30 10:02:23	\N	2
1657	70	4	5	2025-12-21 08:02:23	\N	4
1658	71	1	2	2025-12-28 14:02:23	\N	\N
1659	71	2	3	2025-11-03 08:02:23	\N	2
1660	71	3	4	2025-12-21 05:02:23	\N	\N
1661	71	4	5	2025-09-01 09:02:23	\N	5
1662	72	1	2	2025-12-22 07:02:23	\N	\N
1663	72	2	3	2025-09-27 22:02:23	\N	1
1664	72	3	4	2025-11-29 01:02:23	\N	5
1665	72	4	5	2026-01-03 14:02:23	\N	\N
1666	73	1	2	2025-08-01 18:02:23	\N	3
1667	73	2	3	2025-08-12 23:02:23	\N	1
1668	73	3	4	2025-09-14 04:02:23	\N	5
1669	73	4	5	2025-12-06 07:02:23	\N	1
1670	74	1	2	2025-09-09 21:02:23	\N	1
1671	74	2	3	2025-11-16 22:02:23	\N	\N
1672	74	3	4	2026-01-15 07:02:23	\N	\N
1673	74	4	5	2025-11-22 06:02:23	\N	\N
1674	75	1	2	2025-08-07 21:02:23	\N	5
1675	75	2	3	2025-12-02 17:02:23	\N	1
1676	75	3	4	2025-12-04 10:02:23	\N	2
1677	76	1	2	2025-12-03 21:02:23	\N	4
1678	76	2	3	2025-08-18 09:02:23	\N	2
1679	77	1	2	2025-12-08 19:02:23	\N	1
1680	77	2	3	2025-11-13 01:02:23	\N	1
1681	78	1	2	2025-09-15 10:02:23	\N	1
1682	78	2	3	2025-10-19 00:02:23	\N	4
1683	78	3	4	2025-10-17 00:02:23	\N	2
1684	78	4	5	2025-08-18 07:02:23	\N	2
1685	79	1	2	2025-09-28 12:02:23	\N	2
1686	79	2	3	2025-11-20 01:02:23	\N	2
1687	79	3	4	2025-10-29 09:02:23	\N	5
1688	80	1	2	2026-01-16 04:02:23	\N	4
1689	80	2	3	2025-10-05 04:02:23	\N	\N
1690	81	1	2	2025-12-26 13:02:23	\N	\N
1691	81	2	3	2025-11-20 18:02:23	\N	4
1692	81	3	4	2025-12-08 00:02:23	\N	2
1693	82	1	2	2025-09-19 05:02:23	\N	3
1694	82	2	3	2025-10-28 12:02:23	\N	4
1695	82	3	4	2025-11-07 17:02:23	\N	4
1696	83	1	2	2025-09-01 22:02:23	\N	2
1697	83	2	3	2025-11-03 21:02:23	\N	1
1698	84	1	2	2026-01-12 20:02:23	\N	1
1699	84	2	3	2025-09-09 05:02:23	\N	2
1700	85	1	2	2025-10-04 04:02:23	\N	2
1701	85	2	3	2025-11-28 16:02:23	\N	5
1702	86	1	2	2025-10-16 14:02:23	\N	\N
1703	86	2	3	2025-08-29 04:02:23	\N	\N
1704	87	1	2	2025-08-20 15:02:23	\N	5
1705	87	2	3	2026-01-17 20:02:23	\N	\N
1706	87	3	4	2025-12-18 19:02:23	\N	3
1707	87	4	5	2025-09-01 02:02:23	\N	3
1708	88	1	2	2025-10-03 10:02:23	\N	1
1709	88	2	3	2025-10-16 18:02:23	\N	2
1710	88	3	4	2025-09-02 02:02:23	\N	3
1711	89	1	2	2025-11-11 14:02:23	\N	\N
1712	89	2	3	2025-10-09 23:02:23	\N	3
1713	89	3	4	2025-09-06 02:02:23	\N	2
1714	90	1	2	2025-12-28 13:02:23	\N	\N
1715	90	2	3	2025-11-11 13:02:23	\N	4
1716	90	3	4	2025-11-12 21:02:23	\N	3
1717	91	1	2	2025-08-02 16:02:23	\N	5
1718	91	2	3	2025-11-25 01:02:23	\N	\N
1719	92	1	2	2025-08-08 04:02:23	\N	3
1720	92	2	3	2025-12-03 06:02:23	\N	5
1721	92	3	4	2025-09-23 06:02:23	\N	3
1722	93	1	2	2025-09-24 13:02:23	\N	1
1723	93	2	3	2025-12-02 11:02:23	\N	\N
1724	94	1	2	2025-10-17 23:02:23	\N	\N
1725	94	2	3	2025-09-30 15:02:23	\N	1
1726	94	3	4	2025-12-15 20:02:23	\N	3
1727	94	4	5	2026-01-20 00:02:23	\N	4
1728	95	1	2	2025-09-29 05:02:23	\N	3
1729	95	2	3	2025-10-19 11:02:23	\N	\N
1730	95	3	4	2025-09-11 08:02:23	\N	5
1731	96	1	2	2025-12-08 22:02:23	\N	\N
1732	96	2	3	2025-08-11 18:02:23	\N	3
1733	96	3	4	2025-09-06 23:02:23	\N	3
1734	97	1	2	2025-08-28 20:02:23	\N	5
1735	97	2	3	2025-12-17 08:02:23	\N	5
1736	97	3	4	2025-09-04 20:02:23	\N	5
1737	98	1	2	2025-12-20 19:02:23	\N	5
1738	98	2	3	2025-10-14 05:02:23	\N	\N
1739	98	3	4	2025-09-27 11:02:23	\N	4
1740	99	1	2	2025-08-24 02:02:23	\N	\N
1741	99	2	3	2026-01-16 03:02:23	\N	\N
1742	99	3	4	2025-09-09 19:02:23	\N	\N
1743	99	4	5	2025-12-28 09:02:23	\N	5
1744	100	1	2	2025-08-31 04:02:23	\N	\N
1745	100	2	3	2025-11-14 08:02:23	\N	5
1746	100	3	4	2025-09-17 09:02:23	\N	3
1747	101	1	2	2025-09-22 00:02:23	\N	\N
1748	101	2	3	2025-12-17 04:02:23	\N	2
1749	102	1	2	2025-12-16 17:02:23	\N	5
1750	102	2	3	2025-12-03 10:02:23	\N	5
1751	102	3	4	2025-09-23 04:02:23	\N	2
1752	102	4	5	2025-11-21 17:02:23	\N	1
1753	103	1	2	2025-11-07 07:02:23	\N	1
1754	103	2	3	2025-10-03 21:02:23	\N	\N
1755	103	3	4	2025-11-29 03:02:23	\N	\N
1756	104	1	2	2025-10-21 10:02:23	\N	5
1757	104	2	3	2025-07-29 15:02:23	\N	2
1758	104	3	4	2025-10-07 21:02:23	\N	\N
1759	105	1	2	2025-09-04 20:02:23	\N	3
1760	105	2	3	2025-09-12 00:02:23	\N	2
1761	106	1	2	2025-07-31 09:02:23	\N	\N
1762	106	2	3	2025-10-19 19:02:23	\N	3
1763	107	1	2	2025-08-07 17:02:23	\N	4
1764	107	2	3	2025-12-17 02:02:23	\N	4
1765	107	3	4	2025-08-26 02:02:23	\N	\N
1766	107	4	5	2025-12-18 01:02:23	\N	3
1767	108	1	2	2026-01-02 21:02:23	\N	4
1768	108	2	3	2025-09-29 20:02:23	\N	2
1769	109	1	2	2025-11-19 12:02:23	\N	2
1770	109	2	3	2025-08-14 03:02:23	\N	3
1771	109	3	4	2025-12-06 09:02:23	\N	5
1772	109	4	5	2025-10-23 07:02:23	\N	4
1773	110	1	2	2025-10-08 09:02:23	\N	2
1774	110	2	3	2025-10-27 05:02:23	\N	1
1775	110	3	4	2025-09-20 09:02:23	\N	4
1776	110	4	5	2026-01-10 09:02:23	\N	\N
1777	111	1	2	2025-11-03 04:02:23	\N	5
1778	111	2	3	2025-08-24 07:02:23	\N	5
1779	112	1	2	2025-09-30 10:02:23	\N	\N
1780	112	2	3	2025-09-21 23:02:23	\N	\N
1781	113	1	2	2025-10-01 23:02:23	\N	\N
1782	113	2	3	2025-08-07 16:02:23	\N	\N
1783	113	3	4	2025-10-25 21:02:23	\N	4
1784	113	4	5	2025-11-25 05:02:23	\N	\N
1785	114	1	2	2025-10-17 13:02:23	\N	4
1786	114	2	3	2025-11-26 17:02:23	\N	1
1787	115	1	2	2025-08-06 04:02:23	\N	3
1788	115	2	3	2025-11-03 18:02:23	\N	1
1789	116	1	2	2025-11-20 22:02:23	\N	\N
1790	116	2	3	2025-09-28 05:02:23	\N	2
1791	116	3	4	2025-09-26 09:02:23	\N	3
1792	116	4	5	2025-10-30 11:02:23	\N	5
1793	117	1	2	2026-01-16 00:02:23	\N	\N
1794	117	2	3	2025-11-02 21:02:23	\N	4
1795	117	3	4	2026-01-16 15:02:23	\N	3
1796	117	4	5	2025-09-09 10:02:23	\N	3
1797	118	1	2	2026-01-01 09:02:23	\N	\N
1798	118	2	3	2025-09-03 11:02:23	\N	1
1799	118	3	4	2025-09-06 21:02:23	\N	5
1800	118	4	5	2025-09-11 16:02:23	\N	5
1801	119	1	2	2025-12-24 10:02:23	\N	\N
1802	119	2	3	2025-08-23 19:02:23	\N	3
1803	119	3	4	2025-10-19 19:02:23	\N	4
1804	119	4	5	2025-11-29 18:02:23	\N	1
1805	120	1	2	2025-12-05 05:02:23	\N	5
1806	120	2	3	2025-12-19 12:02:23	\N	2
1807	120	3	4	2025-08-15 16:02:23	\N	\N
1808	120	4	5	2026-01-20 08:02:23	\N	\N
1809	121	1	2	2025-07-29 04:02:23	\N	\N
1810	121	2	3	2025-10-20 11:02:23	\N	4
1811	122	1	2	2025-09-26 07:02:23	\N	\N
1812	122	2	3	2025-08-08 00:02:23	\N	1
1813	123	1	2	2025-11-08 12:02:23	\N	2
1814	123	2	3	2025-10-06 20:02:23	\N	5
1815	123	3	4	2025-11-03 03:02:23	\N	1
1816	123	4	5	2026-01-08 20:02:23	\N	1
1817	124	1	2	2025-11-15 16:02:23	\N	\N
1818	124	2	3	2025-09-21 19:02:23	\N	2
1819	124	3	4	2026-01-06 15:02:23	\N	5
1820	124	4	5	2026-01-20 09:02:23	\N	3
1821	125	1	2	2025-09-02 13:02:23	\N	\N
1822	125	2	3	2025-10-25 14:02:23	\N	1
1823	126	1	2	2025-12-11 05:02:23	\N	\N
1824	126	2	3	2026-01-04 04:02:23	\N	3
1825	127	1	2	2025-12-17 06:02:23	\N	4
1826	127	2	3	2025-10-01 14:02:23	\N	4
1827	127	3	4	2025-09-14 18:02:23	\N	3
1828	128	1	2	2025-10-21 03:02:23	\N	\N
1829	128	2	3	2026-01-16 17:02:23	\N	5
1830	129	1	2	2025-08-22 04:02:23	\N	4
1831	129	2	3	2025-09-05 20:02:23	\N	\N
1832	130	1	2	2025-11-06 07:02:23	\N	4
1833	130	2	3	2025-12-02 13:02:23	\N	3
1834	130	3	4	2026-01-11 16:02:23	\N	4
1835	130	4	5	2025-10-03 20:02:23	\N	5
1836	131	1	2	2025-12-27 23:02:23	\N	4
1837	131	2	3	2025-08-25 01:02:23	\N	1
1838	132	1	2	2025-09-17 13:02:23	\N	4
1839	132	2	3	2026-01-10 22:02:23	\N	\N
1840	133	1	2	2025-12-22 21:02:23	\N	1
1841	133	2	3	2025-10-21 15:02:23	\N	1
1842	133	3	4	2025-10-04 23:02:23	\N	4
1843	134	1	2	2025-08-13 19:02:23	\N	1
1844	134	2	3	2025-10-21 04:02:23	\N	4
1845	134	3	4	2025-08-24 07:02:23	\N	5
1846	134	4	5	2025-08-13 19:02:23	\N	\N
1847	135	1	2	2025-10-26 05:02:23	\N	3
1848	135	2	3	2025-10-02 08:02:23	\N	2
1849	135	3	4	2025-09-28 17:02:23	\N	1
1850	135	4	5	2026-01-19 23:02:23	\N	\N
1851	136	1	2	2025-12-18 19:02:23	\N	4
1852	136	2	3	2025-10-05 19:02:23	\N	5
1853	136	3	4	2025-09-17 02:02:23	\N	\N
1854	136	4	5	2026-01-04 11:02:23	\N	1
1855	137	1	2	2025-08-05 08:02:23	\N	1
1856	137	2	3	2025-11-18 14:02:23	\N	\N
1857	137	3	4	2025-09-13 21:02:23	\N	1
1858	137	4	5	2025-10-05 18:02:23	\N	1
1859	138	1	2	2025-10-17 04:02:23	\N	1
1860	138	2	3	2026-01-11 13:02:23	\N	\N
1861	138	3	4	2025-09-23 23:02:23	\N	\N
1862	138	4	5	2025-08-19 07:02:23	\N	\N
1863	139	1	2	2025-09-17 23:02:23	\N	1
1864	139	2	3	2025-09-17 13:02:23	\N	4
1865	140	1	2	2025-08-20 09:02:23	\N	2
1866	140	2	3	2025-10-19 01:02:23	\N	5
1867	140	3	4	2025-11-30 17:02:23	\N	4
1868	140	4	5	2026-01-02 12:02:23	\N	2
1869	141	1	2	2025-11-08 16:02:23	\N	3
1870	141	2	3	2025-08-25 21:02:23	\N	\N
1871	141	3	4	2025-12-14 09:02:23	\N	4
1872	142	1	2	2025-07-26 07:02:23	\N	3
1873	142	2	3	2025-08-27 20:02:23	\N	\N
1874	143	1	2	2025-08-18 07:02:23	\N	4
1875	143	2	3	2025-09-22 22:02:23	\N	1
1876	143	3	4	2025-09-10 11:02:23	\N	5
1877	143	4	5	2025-11-22 21:02:23	\N	\N
1878	144	1	2	2025-09-08 11:02:23	\N	5
1879	144	2	3	2025-09-02 20:02:23	\N	4
1880	145	1	2	2025-11-21 13:02:23	\N	4
1881	145	2	3	2026-01-11 02:02:23	\N	5
1882	146	1	2	2025-08-16 23:02:23	\N	1
1883	146	2	3	2025-12-05 06:02:23	\N	3
1884	147	1	2	2025-11-18 20:02:23	\N	\N
1885	147	2	3	2025-11-22 07:02:23	\N	\N
1886	147	3	4	2025-08-09 21:02:23	\N	4
1887	148	1	2	2025-10-25 20:02:23	\N	\N
1888	148	2	3	2025-12-28 18:02:23	\N	4
1889	148	3	4	2025-08-09 08:02:23	\N	\N
1890	149	1	2	2025-09-09 00:02:23	\N	3
1891	149	2	3	2025-10-13 17:02:23	\N	1
1892	150	1	2	2025-09-11 17:02:23	\N	4
1893	150	2	3	2025-11-25 20:02:23	\N	4
1894	150	3	4	2025-10-12 10:02:23	\N	5
1895	151	1	2	2025-09-08 23:02:23	\N	4
1896	151	2	3	2026-01-03 18:02:23	\N	2
1897	152	1	2	2025-08-10 00:02:23	\N	\N
1898	152	2	3	2025-12-07 03:02:23	\N	1
1899	153	1	2	2025-09-18 20:02:23	\N	\N
1900	153	2	3	2025-08-21 11:02:23	\N	1
1901	153	3	4	2025-11-22 00:02:23	\N	1
1902	154	1	2	2025-11-18 15:02:23	\N	1
1903	154	2	3	2025-08-21 21:02:23	\N	\N
1904	154	3	4	2025-12-14 00:02:23	\N	\N
1905	154	4	5	2025-12-14 18:02:23	\N	\N
1906	155	1	2	2025-12-02 19:02:23	\N	1
1907	155	2	3	2025-09-22 14:02:23	\N	5
1908	156	1	2	2025-09-04 08:02:23	\N	1
1909	156	2	3	2026-01-17 10:02:23	\N	5
1910	156	3	4	2025-11-01 11:02:23	\N	\N
1911	157	1	2	2025-10-12 16:02:23	\N	3
1912	157	2	3	2025-08-11 23:02:23	\N	3
1913	157	3	4	2025-11-09 23:02:23	\N	4
1914	158	1	2	2025-11-15 04:02:23	\N	\N
1915	158	2	3	2025-08-07 12:02:23	\N	\N
1916	159	1	2	2025-09-20 03:02:23	\N	\N
1917	159	2	3	2025-08-16 11:02:23	\N	\N
1918	160	1	2	2025-10-30 00:02:23	\N	4
1919	160	2	3	2025-10-12 10:02:23	\N	5
1920	161	1	2	2026-01-19 11:02:23	\N	4
1921	161	2	3	2025-09-24 04:02:23	\N	1
1922	161	3	4	2025-11-18 00:02:23	\N	2
1923	162	1	2	2025-10-25 13:02:23	\N	\N
1924	162	2	3	2025-09-09 03:02:23	\N	1
1925	163	1	2	2025-11-30 03:02:23	\N	3
1926	163	2	3	2025-09-05 04:02:23	\N	5
1927	163	3	4	2026-01-11 06:02:23	\N	2
1928	164	1	2	2025-10-22 12:02:23	\N	\N
1929	164	2	3	2025-08-28 08:02:23	\N	\N
1930	164	3	4	2025-10-05 11:02:23	\N	\N
1931	165	1	2	2025-10-11 09:02:23	\N	5
1932	165	2	3	2025-11-20 00:02:23	\N	1
1933	165	3	4	2025-09-12 07:02:23	\N	\N
1934	166	1	2	2025-12-21 06:02:23	\N	\N
1935	166	2	3	2025-08-24 06:02:23	\N	3
1936	166	3	4	2025-11-07 05:02:23	\N	4
1937	167	1	2	2025-11-30 03:02:23	\N	4
1938	167	2	3	2026-01-06 10:02:23	\N	1
1939	168	1	2	2025-10-09 15:02:23	\N	1
1940	168	2	3	2025-11-29 20:02:23	\N	1
1941	168	3	4	2025-11-16 22:02:23	\N	5
1942	168	4	5	2025-11-23 06:02:23	\N	\N
1943	169	1	2	2025-09-04 01:02:23	\N	5
1944	169	2	3	2025-12-18 19:02:23	\N	4
1945	169	3	4	2026-01-05 07:02:23	\N	1
1946	170	1	2	2025-08-14 08:02:23	\N	2
1947	170	2	3	2025-08-07 21:02:23	\N	5
1948	170	3	4	2026-01-20 04:02:23	\N	2
1949	170	4	5	2025-12-16 13:02:23	\N	1
1950	171	1	2	2025-09-08 10:02:23	\N	4
1951	171	2	3	2025-09-12 20:02:23	\N	5
1952	171	3	4	2025-12-10 04:02:23	\N	\N
1953	172	1	2	2025-09-24 01:02:23	\N	\N
1954	172	2	3	2025-11-28 02:02:23	\N	\N
1955	172	3	4	2025-11-25 23:02:23	\N	2
1956	172	4	5	2025-08-13 20:02:23	\N	5
1957	173	1	2	2025-09-26 18:02:23	\N	2
1958	173	2	3	2025-07-30 19:02:23	\N	\N
1959	173	3	4	2025-11-23 11:02:23	\N	4
1960	174	1	2	2025-08-04 18:02:23	\N	3
1961	174	2	3	2025-09-04 00:02:23	\N	1
1962	175	1	2	2025-11-07 01:02:23	\N	5
1963	175	2	3	2025-09-06 03:02:23	\N	5
1964	175	3	4	2026-01-19 21:02:23	\N	5
1965	176	1	2	2025-12-14 11:02:23	\N	2
1966	176	2	3	2025-11-17 00:02:23	\N	4
1967	177	1	2	2025-09-19 10:02:23	\N	4
1968	177	2	3	2026-01-06 17:02:23	\N	\N
1969	177	3	4	2025-12-13 10:02:23	\N	4
1970	178	1	2	2025-12-01 01:02:23	\N	5
1971	178	2	3	2025-11-12 20:02:23	\N	4
1972	179	1	2	2025-10-03 12:02:23	\N	3
1973	179	2	3	2025-11-21 12:02:23	\N	3
1974	179	3	4	2025-12-28 03:02:23	\N	\N
1975	179	4	5	2025-11-09 20:02:23	\N	4
1976	180	1	2	2025-10-21 16:02:23	\N	1
1977	180	2	3	2026-01-12 23:02:23	\N	\N
1978	180	3	4	2025-09-11 07:02:23	\N	1
1979	181	1	2	2025-09-25 09:02:23	\N	2
1980	181	2	3	2025-08-15 04:02:23	\N	5
1981	182	1	2	2025-08-10 07:02:23	\N	\N
1982	182	2	3	2025-12-13 21:02:23	\N	5
1983	182	3	4	2026-01-20 00:02:23	\N	1
1984	182	4	5	2025-10-14 05:02:23	\N	5
1985	183	1	2	2025-09-19 16:02:23	\N	1
1986	183	2	3	2025-08-16 18:02:23	\N	5
1987	184	1	2	2025-08-20 01:02:23	\N	5
1988	184	2	3	2025-09-24 18:02:23	\N	1
1989	184	3	4	2025-11-21 13:02:23	\N	4
1990	185	1	2	2025-12-09 12:02:23	\N	1
1991	185	2	3	2025-09-15 12:02:23	\N	\N
1992	186	1	2	2025-12-13 09:02:23	\N	\N
1993	186	2	3	2025-11-19 22:02:23	\N	5
1994	187	1	2	2025-07-27 23:02:23	\N	2
1995	187	2	3	2026-01-11 15:02:23	\N	\N
1996	188	1	2	2025-12-10 10:02:23	\N	\N
1997	188	2	3	2026-01-19 19:02:23	\N	4
1998	188	3	4	2025-10-08 22:02:23	\N	\N
1999	189	1	2	2025-11-03 22:02:23	\N	4
2000	189	2	3	2025-12-21 21:02:23	\N	\N
2001	189	3	4	2025-08-30 20:02:23	\N	5
2002	190	1	2	2025-09-06 00:02:23	\N	\N
2003	190	2	3	2025-08-06 10:02:23	\N	1
2004	190	3	4	2025-12-16 22:02:23	\N	3
2005	190	4	5	2025-09-23 02:02:23	\N	\N
2006	191	1	2	2025-12-03 09:02:23	\N	2
2007	191	2	3	2025-09-12 05:02:23	\N	2
2008	192	1	2	2026-01-04 23:02:23	\N	4
2009	192	2	3	2025-12-30 01:02:23	\N	\N
2010	192	3	4	2025-08-06 23:02:23	\N	\N
2011	193	1	2	2025-10-10 19:02:23	\N	2
2012	193	2	3	2025-09-23 17:02:23	\N	1
2013	194	1	2	2025-08-26 16:02:23	\N	3
2014	194	2	3	2025-12-13 03:02:23	\N	3
2015	194	3	4	2025-08-12 07:02:23	\N	5
2016	194	4	5	2026-01-19 15:02:23	\N	\N
2017	195	1	2	2025-12-01 12:02:23	\N	5
2018	195	2	3	2025-11-19 05:02:23	\N	4
2019	196	1	2	2025-11-27 11:02:23	\N	\N
2020	196	2	3	2025-12-23 04:02:23	\N	5
2021	196	3	4	2025-08-17 08:02:23	\N	\N
2022	197	1	2	2025-11-13 00:02:23	\N	4
2023	197	2	3	2025-11-21 22:02:23	\N	2
2024	197	3	4	2025-09-24 13:02:23	\N	\N
2025	198	1	2	2025-10-11 09:02:23	\N	5
2026	198	2	3	2025-11-06 20:02:23	\N	4
2027	198	3	4	2026-01-18 19:02:23	\N	1
2028	198	4	5	2025-10-16 21:02:23	\N	5
2029	199	1	2	2025-07-29 00:02:23	\N	4
2030	199	2	3	2025-12-27 14:02:23	\N	4
2031	199	3	4	2025-11-26 08:02:23	\N	\N
2032	200	1	2	2025-09-23 14:02:23	\N	4
2033	200	2	3	2025-08-29 11:02:23	\N	\N
2034	200	3	4	2025-12-20 05:02:23	\N	4
2035	200	4	5	2025-10-06 23:02:23	\N	5
2036	201	1	2	2025-10-16 08:02:23	\N	3
2037	201	2	3	2026-01-19 16:02:23	\N	\N
2038	201	3	4	2025-12-30 18:02:23	\N	\N
2039	202	1	2	2025-11-05 18:02:23	\N	5
2040	202	2	3	2025-10-29 17:02:23	\N	5
2041	202	3	4	2025-12-25 10:02:23	\N	5
2042	202	4	5	2025-12-02 13:02:23	\N	1
2043	203	1	2	2025-12-17 08:02:23	\N	1
2044	203	2	3	2025-11-29 05:02:23	\N	\N
2045	203	3	4	2025-08-05 16:02:23	\N	\N
2046	204	1	2	2025-09-29 10:02:23	\N	\N
2047	204	2	3	2025-09-11 23:02:23	\N	2
2048	204	3	4	2025-10-18 19:02:23	\N	3
2049	204	4	5	2025-09-08 06:02:23	\N	\N
2050	205	1	2	2025-09-28 11:02:23	\N	5
2051	205	2	3	2025-09-08 02:02:23	\N	\N
2052	206	1	2	2025-10-28 08:02:23	\N	\N
2053	206	2	3	2025-10-30 00:02:23	\N	2
2054	206	3	4	2025-10-06 19:02:23	\N	\N
2055	207	1	2	2025-10-14 09:02:23	\N	2
2056	207	2	3	2026-01-18 01:02:23	\N	5
2057	207	3	4	2025-12-11 03:02:23	\N	4
2058	208	1	2	2025-09-14 09:02:23	\N	3
2059	208	2	3	2025-11-05 17:02:23	\N	1
2060	209	1	2	2025-11-28 03:02:23	\N	4
2061	209	2	3	2025-09-16 01:02:23	\N	2
2062	210	1	2	2025-11-25 03:02:23	\N	\N
2063	210	2	3	2025-11-13 09:02:23	\N	2
2064	211	1	2	2025-09-29 15:02:23	\N	4
2065	211	2	3	2025-11-30 15:02:23	\N	\N
2066	211	3	4	2026-01-08 03:02:23	\N	5
2067	211	4	5	2025-11-24 15:02:23	\N	2
2068	212	1	2	2025-07-27 21:02:23	\N	5
2069	212	2	3	2025-11-24 03:02:23	\N	4
2070	213	1	2	2025-10-21 01:02:23	\N	4
2071	213	2	3	2025-09-22 09:02:23	\N	3
2072	213	3	4	2025-11-19 07:02:23	\N	5
2073	213	4	5	2025-08-17 12:02:23	\N	1
2074	214	1	2	2025-08-02 12:02:23	\N	1
2075	214	2	3	2026-01-20 01:02:23	\N	\N
2076	214	3	4	2025-10-10 21:02:23	\N	\N
2077	214	4	5	2025-10-24 22:02:23	\N	5
2078	215	1	2	2025-12-24 21:02:23	\N	1
2079	215	2	3	2025-09-30 02:02:23	\N	4
2080	215	3	4	2025-10-28 04:02:23	\N	1
2081	216	1	2	2025-07-26 06:02:23	\N	5
2082	216	2	3	2025-08-29 15:02:23	\N	\N
2083	216	3	4	2025-10-13 06:02:23	\N	\N
2084	217	1	2	2025-11-19 02:02:23	\N	2
2085	217	2	3	2025-12-30 19:02:23	\N	2
2086	217	3	4	2025-11-17 01:02:23	\N	\N
2087	218	1	2	2025-08-23 06:02:23	\N	\N
2088	218	2	3	2025-08-09 10:02:23	\N	4
2089	219	1	2	2025-08-26 18:02:23	\N	2
2090	219	2	3	2025-08-22 06:02:23	\N	3
2091	219	3	4	2025-08-10 15:02:23	\N	\N
2092	220	1	2	2025-12-18 07:02:23	\N	4
2093	220	2	3	2026-01-20 03:02:23	\N	4
2094	220	3	4	2025-08-13 00:02:23	\N	\N
2095	220	4	5	2025-09-18 06:02:23	\N	2
2096	221	1	2	2025-12-05 14:02:23	\N	\N
2097	221	2	3	2025-11-02 02:02:23	\N	2
2098	221	3	4	2026-01-19 15:02:23	\N	\N
2099	222	1	2	2025-11-29 18:02:23	\N	\N
2100	222	2	3	2025-12-02 03:02:23	\N	2
2101	223	1	2	2025-10-13 23:02:23	\N	3
2102	223	2	3	2025-12-05 05:02:23	\N	\N
2103	223	3	4	2025-08-06 19:02:23	\N	\N
2104	223	4	5	2025-09-07 06:02:23	\N	2
2105	224	1	2	2025-11-27 22:02:23	\N	3
2106	224	2	3	2025-08-14 04:02:23	\N	1
2107	224	3	4	2025-12-30 08:02:23	\N	\N
2108	225	1	2	2025-12-17 13:02:23	\N	2
2109	225	2	3	2025-10-22 12:02:23	\N	2
2110	225	3	4	2026-01-20 08:02:23	\N	\N
2111	225	4	5	2025-11-02 03:02:23	\N	2
2112	226	1	2	2026-01-16 08:02:23	\N	\N
2113	226	2	3	2025-08-17 06:02:23	\N	\N
2114	227	1	2	2026-01-11 06:02:23	\N	1
2115	227	2	3	2026-01-10 06:02:23	\N	3
2116	228	1	2	2025-09-13 06:02:23	\N	1
2117	228	2	3	2026-01-19 15:02:23	\N	4
2118	229	1	2	2025-12-14 00:02:23	\N	1
2119	229	2	3	2026-01-09 13:02:23	\N	3
2120	230	1	2	2025-11-03 12:02:23	\N	5
2121	230	2	3	2025-08-18 18:02:23	\N	\N
2122	231	1	2	2025-12-25 16:02:23	\N	3
2123	231	2	3	2025-09-10 02:02:23	\N	2
2124	231	3	4	2025-12-10 20:02:23	\N	3
2125	231	4	5	2025-09-28 17:02:23	\N	\N
2126	232	1	2	2026-01-05 04:02:23	\N	2
2127	232	2	3	2026-01-20 02:02:23	\N	\N
2128	232	3	4	2025-09-12 13:02:23	\N	\N
2129	232	4	5	2025-08-23 08:02:23	\N	4
2130	233	1	2	2025-11-20 12:02:23	\N	\N
2131	233	2	3	2025-10-19 16:02:23	\N	\N
2132	233	3	4	2025-08-16 04:02:23	\N	1
2133	233	4	5	2025-10-12 06:02:23	\N	4
2134	234	1	2	2025-10-01 11:02:23	\N	\N
2135	234	2	3	2025-09-28 12:02:23	\N	1
2136	234	3	4	2025-12-11 11:02:23	\N	3
2137	234	4	5	2025-11-10 02:02:23	\N	2
2138	235	1	2	2025-12-23 21:02:23	\N	\N
2139	235	2	3	2025-09-28 12:02:23	\N	1
2140	236	1	2	2025-07-26 05:02:23	\N	3
2141	236	2	3	2025-11-10 17:02:23	\N	5
2142	236	3	4	2025-12-03 22:02:23	\N	2
2143	236	4	5	2025-09-18 22:02:23	\N	4
2144	237	1	2	2025-12-22 18:02:23	\N	2
2145	237	2	3	2025-12-02 17:02:23	\N	5
2146	237	3	4	2026-01-20 07:02:23	\N	\N
2147	238	1	2	2025-10-05 01:02:23	\N	3
2148	238	2	3	2025-09-30 03:02:23	\N	\N
2149	238	3	4	2025-10-11 22:02:23	\N	\N
2150	238	4	5	2025-11-27 20:02:23	\N	\N
2151	239	1	2	2025-10-15 22:02:23	\N	5
2152	239	2	3	2026-01-14 21:02:23	\N	4
2153	240	1	2	2025-12-08 19:02:23	\N	\N
2154	240	2	3	2026-01-02 03:02:23	\N	\N
2155	241	1	2	2025-08-18 16:02:23	\N	\N
2156	241	2	3	2025-08-24 18:02:23	\N	3
2157	241	3	4	2025-11-15 10:02:23	\N	\N
2158	242	1	2	2025-11-12 06:02:23	\N	1
2159	242	2	3	2026-01-17 05:02:23	\N	4
2160	242	3	4	2025-09-22 03:02:23	\N	1
2161	243	1	2	2025-11-23 11:02:23	\N	1
2162	243	2	3	2025-10-31 21:02:23	\N	4
2163	244	1	2	2025-11-08 16:02:23	\N	5
2164	244	2	3	2025-08-05 20:02:23	\N	5
2165	244	3	4	2025-08-27 16:02:23	\N	5
2166	245	1	2	2025-10-06 19:02:23	\N	3
2167	245	2	3	2026-01-19 15:02:23	\N	\N
2168	245	3	4	2025-11-03 02:02:23	\N	2
2169	246	1	2	2025-09-06 04:02:23	\N	\N
2170	246	2	3	2025-12-01 06:02:23	\N	1
2171	246	3	4	2025-09-02 08:02:23	\N	\N
2172	246	4	5	2025-09-10 11:02:23	\N	1
2173	247	1	2	2025-11-14 07:02:23	\N	5
2174	247	2	3	2025-09-26 16:02:23	\N	\N
2175	247	3	4	2025-12-14 08:02:23	\N	\N
2176	247	4	5	2025-12-12 00:02:23	\N	1
2177	248	1	2	2025-07-27 15:02:23	\N	\N
2178	248	2	3	2026-01-19 23:02:23	\N	1
2179	249	1	2	2025-11-12 16:02:23	\N	\N
2180	249	2	3	2026-01-05 01:02:23	\N	3
2181	250	1	2	2025-10-16 15:02:23	\N	\N
2182	250	2	3	2025-12-21 18:02:23	\N	4
2183	251	1	2	2025-09-12 12:02:23	\N	4
2184	251	2	3	2025-10-09 20:02:23	\N	5
2185	252	1	2	2025-07-29 18:02:23	\N	2
2186	252	2	3	2025-12-14 02:02:23	\N	2
2187	252	3	4	2025-09-15 20:02:23	\N	\N
2188	252	4	5	2025-11-22 07:02:23	\N	\N
2189	253	1	2	2025-12-20 05:02:23	\N	4
2190	253	2	3	2025-12-30 22:02:23	\N	\N
2191	254	1	2	2026-01-15 18:02:23	\N	5
2192	254	2	3	2025-08-21 20:02:23	\N	1
2193	254	3	4	2025-08-15 06:02:23	\N	2
2194	255	1	2	2025-11-27 12:02:23	\N	1
2195	255	2	3	2025-09-30 05:02:23	\N	5
2196	255	3	4	2025-10-26 14:02:23	\N	1
2197	255	4	5	2025-11-30 19:02:23	\N	4
2198	256	1	2	2025-08-21 09:02:23	\N	5
2199	256	2	3	2025-12-04 14:02:23	\N	1
2200	256	3	4	2025-08-08 09:02:23	\N	\N
2201	257	1	2	2026-01-18 04:02:23	\N	1
2202	257	2	3	2025-08-27 21:02:23	\N	2
2203	257	3	4	2025-08-20 02:02:23	\N	2
2204	258	1	2	2025-12-07 07:02:23	\N	\N
2205	258	2	3	2025-10-14 17:02:23	\N	3
2206	259	1	2	2025-11-21 20:02:23	\N	\N
2207	259	2	3	2025-12-04 15:02:23	\N	4
2208	260	1	2	2025-10-30 05:02:23	\N	\N
2209	260	2	3	2025-09-07 20:02:23	\N	3
2210	260	3	4	2025-11-07 23:02:23	\N	\N
2211	261	1	2	2025-10-24 18:02:23	\N	4
2212	261	2	3	2025-11-25 07:02:23	\N	4
2213	262	1	2	2025-09-24 17:02:23	\N	\N
2214	262	2	3	2026-01-14 11:02:23	\N	2
2215	262	3	4	2025-12-10 07:02:23	\N	2
2216	263	1	2	2025-07-25 01:02:23	\N	5
2217	263	2	3	2025-09-07 05:02:23	\N	\N
2218	264	1	2	2025-11-10 01:02:23	\N	1
2219	264	2	3	2025-11-26 07:02:23	\N	3
2220	265	1	2	2025-10-21 09:02:23	\N	5
2221	265	2	3	2025-11-23 03:02:23	\N	\N
2222	266	1	2	2025-11-04 07:02:23	\N	\N
2223	266	2	3	2025-10-29 22:02:23	\N	4
2224	266	3	4	2025-10-31 00:02:23	\N	4
2225	266	4	5	2025-10-24 04:02:23	\N	5
2226	267	1	2	2025-08-14 23:02:23	\N	3
2227	267	2	3	2025-10-13 17:02:23	\N	\N
2228	268	1	2	2025-07-26 04:02:23	\N	3
2229	268	2	3	2025-12-04 20:02:23	\N	3
2230	268	3	4	2025-08-14 03:02:23	\N	3
2231	268	4	5	2025-10-23 03:02:23	\N	3
2232	269	1	2	2025-11-21 07:02:23	\N	4
2233	269	2	3	2025-09-09 13:02:23	\N	4
2234	270	1	2	2025-08-06 09:02:23	\N	\N
2235	270	2	3	2025-11-20 18:02:23	\N	4
2236	270	3	4	2025-09-28 09:02:23	\N	\N
2237	270	4	5	2025-12-20 07:02:23	\N	3
2238	271	1	2	2025-12-01 10:02:23	\N	3
2239	271	2	3	2025-09-17 17:02:23	\N	3
2240	271	3	4	2025-12-15 23:02:23	\N	2
2241	271	4	5	2025-08-19 11:02:23	\N	2
2242	272	1	2	2025-09-20 01:02:23	\N	5
2243	272	2	3	2025-09-16 20:02:23	\N	5
2244	272	3	4	2026-01-16 09:02:23	\N	3
2245	273	1	2	2025-11-11 03:02:23	\N	4
2246	273	2	3	2025-08-07 10:02:23	\N	1
2247	273	3	4	2026-01-20 10:02:23	\N	2
2248	273	4	5	2025-12-16 19:02:23	\N	4
2249	274	1	2	2025-12-18 14:02:23	\N	5
2250	274	2	3	2025-10-08 19:02:23	\N	5
2251	275	1	2	2025-09-27 09:02:23	\N	1
2252	275	2	3	2025-12-17 01:02:23	\N	\N
2253	275	3	4	2025-08-21 17:02:23	\N	4
2254	275	4	5	2025-11-01 06:02:23	\N	\N
2255	276	1	2	2025-07-30 20:02:23	\N	\N
2256	276	2	3	2025-08-25 01:02:23	\N	2
2257	277	1	2	2025-09-21 20:02:23	\N	3
2258	277	2	3	2025-10-08 14:02:23	\N	3
2259	278	1	2	2025-12-23 16:02:23	\N	\N
2260	278	2	3	2025-09-19 01:02:23	\N	5
2261	279	1	2	2025-12-31 20:02:23	\N	2
2262	279	2	3	2025-12-18 00:02:23	\N	1
2263	280	1	2	2025-11-26 15:02:23	\N	\N
2264	280	2	3	2025-12-04 17:02:23	\N	\N
2265	280	3	4	2025-12-10 22:02:23	\N	1
2266	281	1	2	2026-01-06 21:02:23	\N	\N
2267	281	2	3	2025-12-05 13:02:23	\N	\N
2268	281	3	4	2025-09-17 14:02:23	\N	2
2269	281	4	5	2025-09-23 17:02:23	\N	1
2270	282	1	2	2025-09-29 08:02:23	\N	4
2271	282	2	3	2026-01-16 16:02:23	\N	2
2272	282	3	4	2026-01-13 16:02:23	\N	4
2273	282	4	5	2025-10-01 00:02:23	\N	2
2274	283	1	2	2025-07-31 05:02:23	\N	4
2275	283	2	3	2025-11-16 16:02:23	\N	\N
2276	284	1	2	2026-01-09 12:02:23	\N	3
2277	284	2	3	2025-12-23 17:02:23	\N	\N
2278	284	3	4	2025-10-13 02:02:23	\N	4
2279	285	1	2	2025-12-28 00:02:23	\N	4
2280	285	2	3	2025-08-10 15:02:23	\N	5
2281	286	1	2	2025-09-26 15:02:23	\N	\N
2282	286	2	3	2025-11-10 12:02:23	\N	4
2283	287	1	2	2025-09-23 04:02:23	\N	5
2284	287	2	3	2025-09-13 19:02:23	\N	2
2285	287	3	4	2025-12-11 22:02:23	\N	1
2286	287	4	5	2025-12-26 09:02:23	\N	1
2287	288	1	2	2025-12-13 09:02:23	\N	\N
2288	288	2	3	2025-12-23 15:02:23	\N	\N
2289	288	3	4	2025-11-06 23:02:23	\N	4
2290	289	1	2	2025-07-27 10:02:23	\N	\N
2291	289	2	3	2026-01-07 08:02:23	\N	5
2292	289	3	4	2025-12-11 00:02:23	\N	3
2293	289	4	5	2025-12-24 22:02:23	\N	3
2294	290	1	2	2025-12-03 04:02:23	\N	\N
2295	290	2	3	2025-10-05 04:02:23	\N	\N
2296	290	3	4	2025-09-10 16:02:23	\N	2
2297	291	1	2	2025-08-21 21:02:23	\N	2
2298	291	2	3	2025-11-29 22:02:23	\N	2
2299	292	1	2	2025-12-13 10:02:23	\N	3
2300	292	2	3	2025-10-19 19:02:23	\N	5
2301	292	3	4	2025-08-20 11:02:23	\N	2
2302	293	1	2	2025-08-10 23:02:23	\N	2
2303	293	2	3	2025-12-07 02:02:23	\N	5
2304	293	3	4	2025-09-16 07:02:23	\N	\N
2305	294	1	2	2025-10-06 22:02:23	\N	2
2306	294	2	3	2025-11-05 22:02:23	\N	5
2307	294	3	4	2025-12-15 04:02:23	\N	4
2308	295	1	2	2025-09-02 08:02:23	\N	1
2309	295	2	3	2025-10-12 22:02:23	\N	\N
2310	295	3	4	2025-08-05 00:02:23	\N	3
2311	295	4	5	2025-11-06 10:02:23	\N	\N
2312	296	1	2	2025-09-11 08:02:23	\N	1
2313	296	2	3	2025-08-23 19:02:23	\N	4
2314	297	1	2	2025-08-09 17:02:23	\N	\N
2315	297	2	3	2025-08-10 01:02:23	\N	5
2316	297	3	4	2026-01-03 00:02:23	\N	1
2317	298	1	2	2025-12-11 12:02:23	\N	5
2318	298	2	3	2025-07-30 08:02:23	\N	\N
2319	298	3	4	2025-11-04 16:02:23	\N	\N
2320	298	4	5	2025-09-06 22:02:23	\N	3
2321	299	1	2	2025-12-30 00:02:23	\N	5
2322	299	2	3	2025-12-16 11:02:23	\N	3
2323	299	3	4	2025-11-15 15:02:23	\N	1
2324	300	1	2	2025-11-24 01:02:23	\N	\N
2325	300	2	3	2025-08-25 11:02:23	\N	\N
2326	300	3	4	2025-08-31 11:02:23	\N	1
2327	301	1	2	2025-11-30 05:02:23	\N	4
2328	301	2	3	2025-09-02 06:02:23	\N	2
2329	302	1	2	2026-01-03 02:02:23	\N	1
2330	302	2	3	2025-12-16 23:02:23	\N	\N
2331	302	3	4	2025-12-29 11:02:23	\N	2
2332	303	1	2	2025-12-28 14:02:23	\N	5
2333	303	2	3	2025-11-08 04:02:23	\N	\N
2334	303	3	4	2025-08-11 22:02:23	\N	5
2335	303	4	5	2025-11-04 09:02:23	\N	1
2336	304	1	2	2025-10-18 18:02:23	\N	\N
2337	304	2	3	2025-10-22 09:02:23	\N	3
2338	305	1	2	2025-11-09 16:02:23	\N	4
2339	305	2	3	2025-09-15 08:02:23	\N	4
2340	305	3	4	2025-09-02 10:02:23	\N	4
2341	305	4	5	2026-01-20 11:02:23	\N	\N
2342	306	1	2	2025-12-27 07:02:23	\N	1
2343	306	2	3	2025-09-11 10:02:23	\N	2
2344	306	3	4	2025-10-25 12:02:23	\N	2
2345	307	1	2	2025-11-22 05:02:23	\N	\N
2346	307	2	3	2025-11-14 04:02:23	\N	2
2347	307	3	4	2025-08-26 09:02:23	\N	3
2348	307	4	5	2025-11-05 06:02:23	\N	\N
2349	308	1	2	2025-10-08 16:02:23	\N	\N
2350	308	2	3	2025-08-16 15:02:23	\N	\N
2351	308	3	4	2025-12-21 03:02:23	\N	\N
2352	309	1	2	2025-07-27 18:02:23	\N	\N
2353	309	2	3	2025-08-08 09:02:23	\N	1
2354	309	3	4	2025-12-03 18:02:23	\N	4
2355	310	1	2	2025-07-28 10:02:23	\N	\N
2356	310	2	3	2025-10-22 16:02:23	\N	1
2357	311	1	2	2026-01-18 20:02:23	\N	\N
2358	311	2	3	2025-11-06 08:02:23	\N	4
2359	311	3	4	2025-10-13 20:02:23	\N	2
2360	312	1	2	2026-01-20 10:02:23	\N	1
2361	312	2	3	2025-07-31 14:02:23	\N	1
2362	312	3	4	2025-09-25 13:02:23	\N	\N
2363	312	4	5	2026-01-20 01:02:23	\N	2
2364	313	1	2	2025-10-19 12:02:23	\N	3
2365	313	2	3	2025-10-16 16:02:23	\N	3
2366	313	3	4	2025-10-19 21:02:23	\N	\N
2367	313	4	5	2026-01-19 18:02:23	\N	3
2368	314	1	2	2025-09-03 22:02:23	\N	1
2369	314	2	3	2025-11-28 23:02:23	\N	1
2370	315	1	2	2025-11-07 17:02:23	\N	\N
2371	315	2	3	2025-12-21 17:02:23	\N	1
2372	315	3	4	2026-01-08 03:02:23	\N	\N
2373	315	4	5	2025-12-24 04:02:23	\N	\N
2374	316	1	2	2025-08-14 14:02:23	\N	\N
2375	316	2	3	2025-09-15 03:02:23	\N	2
2376	317	1	2	2025-11-08 04:02:23	\N	2
2377	317	2	3	2025-09-13 03:02:23	\N	2
2378	317	3	4	2025-09-29 21:02:23	\N	4
2379	317	4	5	2025-12-05 15:02:23	\N	\N
2380	318	1	2	2025-08-11 11:02:23	\N	1
2381	318	2	3	2025-10-26 00:02:23	\N	4
2382	319	1	2	2025-12-11 04:02:23	\N	2
2383	319	2	3	2026-01-19 19:02:23	\N	\N
2384	319	3	4	2025-08-17 01:02:23	\N	3
2385	320	1	2	2025-11-14 11:02:23	\N	5
2386	320	2	3	2025-11-04 09:02:23	\N	4
2387	320	3	4	2025-12-05 15:02:23	\N	2
2388	320	4	5	2025-09-19 06:02:23	\N	3
2389	321	1	2	2025-08-25 17:02:23	\N	\N
2390	321	2	3	2025-12-19 11:02:23	\N	\N
2391	321	3	4	2026-01-09 13:02:23	\N	\N
2392	322	1	2	2025-12-05 18:02:23	\N	1
2393	322	2	3	2025-08-06 10:02:23	\N	\N
2394	322	3	4	2025-11-11 21:02:23	\N	\N
2395	322	4	5	2025-10-24 21:02:23	\N	2
2396	323	1	2	2025-09-15 22:02:23	\N	5
2397	323	2	3	2025-11-25 06:02:23	\N	3
2398	324	1	2	2025-09-28 20:02:23	\N	2
2399	324	2	3	2025-11-01 03:02:23	\N	\N
2400	324	3	4	2026-01-03 09:02:23	\N	\N
2401	324	4	5	2025-08-25 02:02:23	\N	2
2402	325	1	2	2025-08-03 12:02:23	\N	1
2403	325	2	3	2025-10-22 08:02:23	\N	1
2404	325	3	4	2025-08-08 04:02:23	\N	1
2405	325	4	5	2025-09-16 22:02:23	\N	3
2406	326	1	2	2025-12-03 04:02:23	\N	2
2407	326	2	3	2025-10-21 14:02:23	\N	\N
2408	327	1	2	2026-01-14 19:02:23	\N	5
2409	327	2	3	2025-09-26 14:02:23	\N	\N
2410	327	3	4	2025-09-24 02:02:23	\N	\N
2411	328	1	2	2025-12-12 22:02:23	\N	4
2412	328	2	3	2025-09-26 15:02:23	\N	\N
2413	329	1	2	2025-10-23 11:02:23	\N	2
2414	329	2	3	2025-11-20 21:02:23	\N	3
2415	329	3	4	2025-11-23 15:02:23	\N	1
2416	330	1	2	2026-01-11 12:02:23	\N	5
2417	330	2	3	2025-10-01 06:02:23	\N	2
2418	330	3	4	2025-11-21 12:02:23	\N	\N
2419	331	1	2	2025-08-13 19:02:23	\N	5
2420	331	2	3	2025-09-22 18:02:23	\N	\N
2421	331	3	4	2025-12-11 23:02:23	\N	3
2422	331	4	5	2026-01-19 17:02:23	\N	4
2423	332	1	2	2025-12-17 11:02:23	\N	5
2424	332	2	3	2025-10-29 00:02:23	\N	\N
2425	332	3	4	2026-01-02 10:02:23	\N	4
2426	333	1	2	2025-10-12 22:02:23	\N	5
2427	333	2	3	2025-11-11 19:02:23	\N	\N
2428	334	1	2	2025-12-24 11:02:23	\N	\N
2429	334	2	3	2026-01-20 01:02:23	\N	4
2430	334	3	4	2025-10-09 23:02:23	\N	\N
2431	334	4	5	2026-01-08 18:02:23	\N	1
2432	335	1	2	2025-10-28 17:02:23	\N	4
2433	335	2	3	2025-09-03 09:02:23	\N	1
2434	336	1	2	2025-10-31 23:02:23	\N	1
2435	336	2	3	2025-11-09 14:02:23	\N	\N
2436	336	3	4	2026-01-20 11:02:23	\N	5
2437	336	4	5	2026-01-08 04:02:23	\N	\N
2438	337	1	2	2025-08-13 15:02:23	\N	\N
2439	337	2	3	2025-11-02 14:02:23	\N	\N
2440	337	3	4	2025-11-20 01:02:23	\N	4
2441	337	4	5	2026-01-08 20:02:23	\N	5
2442	338	1	2	2025-09-23 13:02:23	\N	2
2443	338	2	3	2025-11-13 23:02:23	\N	1
2444	339	1	2	2025-12-29 20:02:23	\N	4
2445	339	2	3	2025-10-11 16:02:23	\N	\N
2446	339	3	4	2025-11-18 01:02:23	\N	\N
2447	339	4	5	2025-12-11 15:02:23	\N	\N
2448	340	1	2	2025-10-27 21:02:23	\N	\N
2449	340	2	3	2025-09-03 07:02:23	\N	4
2450	340	3	4	2025-11-13 11:02:23	\N	3
2451	341	1	2	2025-09-27 12:02:23	\N	4
2452	341	2	3	2025-09-15 05:02:23	\N	4
2453	341	3	4	2025-12-15 23:02:23	\N	5
2454	341	4	5	2025-10-05 11:02:23	\N	2
2455	342	1	2	2025-12-20 17:02:23	\N	4
2456	342	2	3	2025-10-22 16:02:23	\N	1
2457	342	3	4	2025-11-16 13:02:23	\N	1
2458	342	4	5	2025-12-03 03:02:23	\N	2
2459	343	1	2	2025-10-26 10:02:23	\N	\N
2460	343	2	3	2025-10-16 00:02:23	\N	4
2461	343	3	4	2025-10-27 04:02:23	\N	5
2462	343	4	5	2025-11-22 19:02:23	\N	4
2463	344	1	2	2025-12-23 14:02:23	\N	5
2464	344	2	3	2026-01-08 14:02:23	\N	5
2465	344	3	4	2025-12-05 02:02:23	\N	2
2466	344	4	5	2025-10-17 17:02:23	\N	5
2467	345	1	2	2025-11-22 07:02:23	\N	2
2468	345	2	3	2025-08-14 22:02:23	\N	\N
2469	346	1	2	2025-08-31 14:02:23	\N	5
2470	346	2	3	2025-08-06 05:02:23	\N	5
2471	346	3	4	2025-11-14 00:02:23	\N	3
2472	346	4	5	2025-08-16 02:02:23	\N	3
2473	347	1	2	2025-08-03 15:02:23	\N	2
2474	347	2	3	2025-10-24 07:02:23	\N	\N
2475	347	3	4	2025-10-29 02:02:23	\N	3
2476	348	1	2	2025-10-27 11:02:23	\N	5
2477	348	2	3	2026-01-06 14:02:23	\N	2
2478	348	3	4	2026-01-06 09:02:23	\N	1
2479	349	1	2	2025-08-31 12:02:23	\N	1
2480	349	2	3	2025-12-31 16:02:23	\N	\N
2481	349	3	4	2025-09-11 12:02:23	\N	\N
2482	350	1	2	2025-12-24 07:02:23	\N	2
2483	350	2	3	2025-11-06 02:02:23	\N	\N
2484	351	1	2	2025-12-13 06:02:23	\N	\N
2485	351	2	3	2025-08-14 17:02:23	\N	4
2486	351	3	4	2025-11-19 12:02:23	\N	3
2487	352	1	2	2025-09-23 17:02:23	\N	2
2488	352	2	3	2025-08-04 08:02:23	\N	3
2489	353	1	2	2025-08-31 17:02:23	\N	\N
2490	353	2	3	2025-11-21 18:02:23	\N	3
2491	354	1	2	2025-12-23 00:02:23	\N	2
2492	354	2	3	2025-11-19 21:02:23	\N	3
2493	354	3	4	2026-01-11 09:02:23	\N	3
2494	354	4	5	2025-09-05 21:02:23	\N	3
2495	355	1	2	2025-12-09 19:02:23	\N	1
2496	355	2	3	2025-11-09 17:02:23	\N	1
2497	356	1	2	2025-11-17 10:02:23	\N	2
2498	356	2	3	2025-10-18 08:02:23	\N	\N
2499	356	3	4	2025-09-12 01:02:23	\N	5
2500	357	1	2	2025-08-31 17:02:23	\N	5
2501	357	2	3	2025-11-04 13:02:23	\N	1
2502	357	3	4	2025-10-17 04:02:23	\N	\N
2503	358	1	2	2025-12-30 03:02:23	\N	\N
2504	358	2	3	2025-09-05 15:02:23	\N	3
2505	358	3	4	2026-01-20 13:02:23	\N	\N
2506	358	4	5	2025-11-11 21:02:23	\N	2
2507	359	1	2	2025-08-02 06:02:23	\N	\N
2508	359	2	3	2025-11-27 02:02:23	\N	4
2509	359	3	4	2025-09-27 06:02:23	\N	\N
2510	359	4	5	2025-11-01 18:02:23	\N	\N
2511	360	1	2	2026-01-16 03:02:23	\N	2
2512	360	2	3	2025-08-01 23:02:23	\N	\N
2513	361	1	2	2025-12-15 08:02:23	\N	\N
2514	361	2	3	2025-11-15 19:02:23	\N	3
2515	361	3	4	2026-01-18 11:02:23	\N	3
2516	361	4	5	2025-12-21 03:02:23	\N	5
2517	362	1	2	2026-01-13 06:02:23	\N	2
2518	362	2	3	2025-08-16 06:02:23	\N	5
2519	362	3	4	2025-11-04 13:02:23	\N	4
2520	362	4	5	2025-09-17 23:02:23	\N	3
2521	363	1	2	2025-11-23 15:02:23	\N	2
2522	363	2	3	2025-12-13 16:02:23	\N	1
2523	363	3	4	2025-09-23 07:02:23	\N	5
2524	363	4	5	2026-01-20 05:02:23	\N	1
2525	364	1	2	2025-10-27 20:02:23	\N	\N
2526	364	2	3	2026-01-16 10:02:23	\N	5
2527	365	1	2	2025-10-22 09:02:23	\N	\N
2528	365	2	3	2026-01-07 10:02:23	\N	4
2529	365	3	4	2026-01-19 05:02:23	\N	5
2530	366	1	2	2025-09-15 22:02:23	\N	\N
2531	366	2	3	2026-01-14 02:02:23	\N	4
2532	367	1	2	2025-12-14 19:02:23	\N	3
2533	367	2	3	2025-11-12 17:02:23	\N	\N
2534	368	1	2	2026-01-04 22:02:23	\N	1
2535	368	2	3	2025-08-27 03:02:23	\N	\N
2536	369	1	2	2025-08-17 08:02:23	\N	5
2537	369	2	3	2025-08-18 11:02:23	\N	1
2538	370	1	2	2025-12-06 20:02:23	\N	3
2539	370	2	3	2025-12-23 12:02:23	\N	\N
2540	371	1	2	2026-01-04 17:02:23	\N	5
2541	371	2	3	2025-12-08 00:02:23	\N	3
2542	371	3	4	2025-11-13 12:02:23	\N	\N
2543	372	1	2	2025-11-20 13:02:23	\N	\N
2544	372	2	3	2025-10-28 08:02:23	\N	4
2545	372	3	4	2025-10-12 17:02:23	\N	\N
2546	373	1	2	2026-01-19 19:02:23	\N	2
2547	373	2	3	2025-09-07 10:02:23	\N	1
2548	374	1	2	2025-11-29 13:02:23	\N	1
2549	374	2	3	2025-11-30 21:02:23	\N	\N
2550	374	3	4	2025-12-31 10:02:23	\N	\N
2551	374	4	5	2025-11-23 07:02:23	\N	2
2552	375	1	2	2025-08-08 02:02:23	\N	3
2553	375	2	3	2025-11-19 03:02:23	\N	5
2554	375	3	4	2026-01-03 14:02:23	\N	2
2555	375	4	5	2026-01-13 08:02:23	\N	\N
2556	376	1	2	2025-10-17 05:02:23	\N	\N
2557	376	2	3	2025-09-16 20:02:23	\N	1
2558	376	3	4	2025-09-05 05:02:23	\N	2
2559	376	4	5	2025-09-13 06:02:23	\N	1
2560	377	1	2	2025-12-30 03:02:23	\N	\N
2561	377	2	3	2025-08-23 03:02:23	\N	\N
2562	378	1	2	2025-08-18 15:02:23	\N	5
2563	378	2	3	2025-11-07 17:02:23	\N	\N
2564	379	1	2	2025-09-21 09:02:23	\N	5
2565	379	2	3	2025-08-12 15:02:23	\N	4
2566	380	1	2	2025-11-12 07:02:23	\N	\N
2567	380	2	3	2025-11-09 09:02:23	\N	4
2568	381	1	2	2026-01-04 09:02:23	\N	4
2569	381	2	3	2026-01-18 10:02:23	\N	5
2570	381	3	4	2026-01-20 00:02:23	\N	1
2571	381	4	5	2026-01-16 16:02:23	\N	2
2572	382	1	2	2025-12-01 01:02:23	\N	1
2573	382	2	3	2025-11-13 21:02:23	\N	2
2574	382	3	4	2025-10-06 06:02:23	\N	\N
2575	382	4	5	2025-11-17 18:02:23	\N	3
2576	383	1	2	2025-08-18 12:02:23	\N	2
2577	383	2	3	2025-08-20 10:02:23	\N	3
2578	383	3	4	2025-09-26 00:02:23	\N	\N
2579	383	4	5	2025-10-02 06:02:23	\N	2
2580	384	1	2	2025-11-29 03:02:23	\N	5
2581	384	2	3	2025-09-30 16:02:23	\N	\N
2582	384	3	4	2025-09-01 09:02:23	\N	3
2583	385	1	2	2025-10-14 14:02:23	\N	5
2584	385	2	3	2025-08-13 07:02:23	\N	2
2585	385	3	4	2025-12-12 07:02:23	\N	4
2586	386	1	2	2025-11-03 17:02:23	\N	5
2587	386	2	3	2025-09-02 18:02:23	\N	5
2588	387	1	2	2025-10-13 23:02:23	\N	5
2589	387	2	3	2025-08-03 19:02:23	\N	\N
2590	387	3	4	2025-10-27 14:02:23	\N	2
2591	387	4	5	2025-11-20 10:02:23	\N	1
2592	388	1	2	2025-10-26 20:02:23	\N	2
2593	388	2	3	2025-09-12 09:02:23	\N	4
2594	388	3	4	2026-01-04 01:02:23	\N	5
2595	388	4	5	2025-12-15 12:02:23	\N	1
2596	389	1	2	2025-10-17 23:02:23	\N	5
2597	389	2	3	2026-01-07 00:02:23	\N	2
2598	389	3	4	2026-01-19 07:02:23	\N	\N
2599	390	1	2	2025-10-24 20:02:23	\N	2
2600	390	2	3	2025-12-24 15:02:23	\N	5
2601	390	3	4	2025-09-10 02:02:23	\N	1
2602	390	4	5	2026-01-06 20:02:23	\N	2
2603	391	1	2	2025-11-19 12:02:23	\N	4
2604	391	2	3	2025-08-31 18:02:23	\N	4
2605	391	3	4	2026-01-20 10:02:23	\N	5
2606	391	4	5	2025-10-12 01:02:23	\N	\N
2607	392	1	2	2025-08-20 05:02:23	\N	3
2608	392	2	3	2026-01-02 08:02:23	\N	\N
2609	393	1	2	2025-09-01 17:02:23	\N	\N
2610	393	2	3	2025-08-07 07:02:23	\N	\N
2611	394	1	2	2026-01-10 09:02:23	\N	4
2612	394	2	3	2025-12-27 03:02:23	\N	3
2613	395	1	2	2025-09-10 20:02:23	\N	4
2614	395	2	3	2025-10-02 18:02:23	\N	\N
2615	395	3	4	2026-01-17 12:02:23	\N	4
2616	396	1	2	2026-01-17 12:02:23	\N	\N
2617	396	2	3	2025-10-15 10:02:23	\N	\N
2618	396	3	4	2025-11-08 09:02:23	\N	\N
2619	397	1	2	2025-10-01 19:02:23	\N	2
2620	397	2	3	2026-01-18 06:02:23	\N	\N
2621	397	3	4	2025-08-14 22:02:23	\N	\N
2622	397	4	5	2026-01-01 18:02:23	\N	\N
2623	398	1	2	2025-08-31 17:02:23	\N	\N
2624	398	2	3	2025-12-21 01:02:23	\N	4
2625	399	1	2	2025-10-29 16:02:23	\N	\N
2626	399	2	3	2025-12-25 05:02:23	\N	3
2627	400	1	2	2025-11-11 23:02:23	\N	2
2628	400	2	3	2025-12-16 00:02:23	\N	5
2629	400	3	4	2026-01-20 07:02:23	\N	1
2630	400	4	5	2025-12-07 19:02:23	\N	3
2631	401	1	2	2025-08-07 05:02:23	\N	3
2632	401	2	3	2025-11-19 09:02:23	\N	5
2633	401	3	4	2025-08-11 13:02:23	\N	2
2634	402	1	2	2025-10-27 19:02:23	\N	\N
2635	402	2	3	2025-12-02 22:02:23	\N	4
2636	403	1	2	2025-10-14 09:02:23	\N	3
2637	403	2	3	2026-01-05 05:02:23	\N	5
2638	403	3	4	2026-01-20 01:02:23	\N	2
2639	404	1	2	2025-11-02 09:02:23	\N	\N
2640	404	2	3	2025-09-20 11:02:23	\N	\N
2641	404	3	4	2025-10-03 11:02:23	\N	\N
2642	404	4	5	2025-08-25 12:02:23	\N	1
2643	405	1	2	2025-07-25 08:02:23	\N	1
2644	405	2	3	2025-09-12 12:02:23	\N	2
2645	405	3	4	2025-08-28 01:02:23	\N	4
2646	406	1	2	2025-09-26 06:02:23	\N	2
2647	406	2	3	2025-08-07 15:02:23	\N	5
2648	406	3	4	2025-09-19 04:02:23	\N	3
2649	407	1	2	2025-07-27 14:02:23	\N	\N
2650	407	2	3	2025-09-22 20:02:23	\N	4
2651	407	3	4	2025-08-26 01:02:23	\N	\N
2652	408	1	2	2025-09-22 02:02:23	\N	1
2653	408	2	3	2025-09-15 19:02:23	\N	\N
2654	409	1	2	2025-09-18 15:02:23	\N	1
2655	409	2	3	2025-09-04 08:02:23	\N	\N
2656	409	3	4	2025-11-03 21:02:23	\N	4
2657	409	4	5	2025-09-14 16:02:23	\N	1
2658	410	1	2	2025-12-13 05:02:23	\N	\N
2659	410	2	3	2026-01-04 17:02:23	\N	2
2660	410	3	4	2025-08-16 03:02:23	\N	1
2661	410	4	5	2026-01-10 10:02:23	\N	3
2662	411	1	2	2026-01-15 14:02:23	\N	2
2663	411	2	3	2025-08-19 13:02:23	\N	3
2664	412	1	2	2025-10-05 01:02:23	\N	4
2665	412	2	3	2025-11-01 09:02:23	\N	4
2666	412	3	4	2025-09-05 10:02:23	\N	1
2667	412	4	5	2025-11-04 18:02:23	\N	\N
2668	413	1	2	2025-08-03 08:02:23	\N	4
2669	413	2	3	2025-09-30 08:02:23	\N	\N
2670	413	3	4	2025-10-27 11:02:23	\N	2
2671	413	4	5	2025-12-03 04:02:23	\N	2
2672	414	1	2	2025-10-26 02:02:23	\N	2
2673	414	2	3	2026-01-18 00:02:23	\N	1
2674	414	3	4	2025-08-28 22:02:23	\N	2
2675	414	4	5	2025-09-28 20:02:23	\N	\N
2676	415	1	2	2025-10-25 10:02:23	\N	4
2677	415	2	3	2025-08-08 08:02:23	\N	4
2678	415	3	4	2025-12-08 00:02:23	\N	\N
2679	416	1	2	2025-10-11 17:02:23	\N	3
2680	416	2	3	2025-10-03 20:02:23	\N	5
2681	417	1	2	2026-01-12 23:02:23	\N	\N
2682	417	2	3	2025-12-23 18:02:23	\N	1
2683	417	3	4	2025-09-29 05:02:23	\N	3
2684	418	1	2	2025-09-19 09:02:23	\N	5
2685	418	2	3	2026-01-18 23:02:23	\N	2
2686	418	3	4	2025-12-23 13:02:23	\N	2
2687	418	4	5	2025-10-08 01:02:23	\N	2
2688	419	1	2	2025-07-31 04:02:23	\N	5
2689	419	2	3	2025-11-15 08:02:23	\N	3
2690	419	3	4	2026-01-20 11:02:23	\N	3
2691	420	1	2	2025-12-02 12:02:23	\N	\N
2692	420	2	3	2025-08-13 10:02:23	\N	5
2693	421	1	2	2025-08-18 18:02:23	\N	\N
2694	421	2	3	2025-12-16 02:02:23	\N	4
2695	421	3	4	2025-10-02 02:02:23	\N	4
2696	422	1	2	2025-08-03 08:02:23	\N	1
2697	422	2	3	2025-11-30 14:02:23	\N	\N
2698	422	3	4	2025-10-04 05:02:23	\N	4
2699	423	1	2	2025-10-16 01:02:23	\N	4
2700	423	2	3	2025-09-19 02:02:23	\N	2
2701	423	3	4	2025-09-03 12:02:23	\N	3
2702	423	4	5	2025-12-17 22:02:23	\N	5
2703	424	1	2	2025-11-25 06:02:23	\N	\N
2704	424	2	3	2025-10-13 16:02:23	\N	1
2705	425	1	2	2026-01-02 09:02:23	\N	\N
2706	425	2	3	2025-08-31 17:02:23	\N	\N
2707	425	3	4	2025-08-12 02:02:23	\N	\N
2708	425	4	5	2026-01-07 04:02:23	\N	1
2709	426	1	2	2025-12-06 17:02:23	\N	\N
2710	426	2	3	2025-11-20 13:02:23	\N	3
2711	426	3	4	2026-01-03 05:02:23	\N	5
2712	426	4	5	2025-11-17 20:02:23	\N	4
2713	427	1	2	2025-12-21 22:02:23	\N	1
2714	427	2	3	2025-10-13 23:02:23	\N	1
2715	427	3	4	2025-12-27 10:02:23	\N	3
2716	427	4	5	2025-10-10 14:02:23	\N	\N
2717	428	1	2	2025-08-04 19:02:23	\N	2
2718	428	2	3	2025-08-18 11:02:23	\N	\N
2719	428	3	4	2025-11-29 17:02:23	\N	\N
2720	428	4	5	2025-10-07 15:02:23	\N	\N
2721	429	1	2	2025-08-27 16:02:23	\N	4
2722	429	2	3	2025-08-26 12:02:23	\N	1
2723	429	3	4	2025-12-20 03:02:23	\N	4
2724	429	4	5	2025-08-29 06:02:23	\N	5
2725	430	1	2	2025-08-17 09:02:23	\N	1
2726	430	2	3	2025-10-25 08:02:23	\N	4
2727	430	3	4	2026-01-19 23:02:23	\N	3
2728	431	1	2	2025-09-25 07:02:23	\N	\N
2729	431	2	3	2025-11-14 08:02:23	\N	1
2730	431	3	4	2025-10-16 07:02:23	\N	3
2731	432	1	2	2026-01-17 01:02:23	\N	\N
2732	432	2	3	2025-10-06 20:02:23	\N	\N
2733	432	3	4	2025-08-17 08:02:23	\N	4
2734	432	4	5	2025-12-20 22:02:23	\N	1
2735	433	1	2	2025-12-26 09:02:23	\N	4
2736	433	2	3	2025-10-12 21:02:23	\N	2
2737	433	3	4	2025-10-17 22:02:23	\N	1
2738	433	4	5	2026-01-20 05:02:23	\N	\N
2739	434	1	2	2025-12-09 07:02:23	\N	3
2740	434	2	3	2025-08-27 07:02:23	\N	2
2741	434	3	4	2025-11-11 15:02:23	\N	1
2742	434	4	5	2026-01-19 19:02:23	\N	\N
2743	435	1	2	2025-12-24 02:02:23	\N	1
2744	435	2	3	2025-10-14 09:02:23	\N	3
2745	436	1	2	2025-11-30 11:02:23	\N	5
2746	436	2	3	2025-08-01 16:02:23	\N	3
2747	436	3	4	2025-08-06 20:02:23	\N	3
2748	437	1	2	2025-12-01 14:02:23	\N	1
2749	437	2	3	2025-12-13 21:02:23	\N	1
2750	438	1	2	2025-09-27 15:02:23	\N	\N
2751	438	2	3	2025-11-08 03:02:23	\N	4
2752	438	3	4	2025-08-16 00:02:23	\N	1
2753	439	1	2	2025-09-10 10:02:23	\N	5
2754	439	2	3	2025-07-31 15:02:23	\N	4
2755	439	3	4	2026-01-13 02:02:23	\N	\N
2756	440	1	2	2025-10-15 23:02:23	\N	\N
2757	440	2	3	2025-12-21 17:02:23	\N	4
2758	440	3	4	2025-10-02 18:02:23	\N	2
2759	441	1	2	2025-10-24 03:02:23	\N	5
2760	441	2	3	2025-12-23 23:02:23	\N	5
2761	441	3	4	2025-12-01 17:02:23	\N	\N
2762	442	1	2	2025-10-01 11:02:23	\N	2
2763	442	2	3	2025-09-16 23:02:23	\N	1
2764	443	1	2	2025-08-18 12:02:23	\N	4
2765	443	2	3	2025-08-03 05:02:23	\N	1
2766	443	3	4	2025-11-30 23:02:23	\N	2
2767	443	4	5	2026-01-20 07:02:23	\N	3
2768	444	1	2	2025-08-07 22:02:23	\N	\N
2769	444	2	3	2025-09-02 14:02:23	\N	3
2770	444	3	4	2025-08-15 12:02:23	\N	5
2771	445	1	2	2025-11-28 07:02:23	\N	5
2772	445	2	3	2025-07-31 11:02:23	\N	4
2773	446	1	2	2026-01-04 23:02:23	\N	1
2774	446	2	3	2025-11-19 11:02:23	\N	4
2775	447	1	2	2025-12-02 09:02:23	\N	5
2776	447	2	3	2025-08-22 14:02:23	\N	2
2777	447	3	4	2025-09-22 04:02:23	\N	\N
2778	448	1	2	2025-08-19 17:02:23	\N	\N
2779	448	2	3	2025-11-06 13:02:23	\N	\N
2780	449	1	2	2025-09-04 20:02:23	\N	\N
2781	449	2	3	2025-12-24 22:02:23	\N	\N
2782	449	3	4	2025-10-29 01:02:23	\N	\N
2783	449	4	5	2025-10-30 19:02:23	\N	4
2784	450	1	2	2025-12-05 03:02:23	\N	\N
2785	450	2	3	2025-11-06 15:02:23	\N	5
2786	450	3	4	2025-10-09 20:02:23	\N	4
2787	450	4	5	2025-10-28 10:02:23	\N	1
2788	451	1	2	2025-12-26 13:02:23	\N	\N
2789	451	2	3	2025-10-29 19:02:23	\N	1
2790	451	3	4	2026-01-19 15:02:23	\N	1
2791	452	1	2	2025-08-22 21:02:23	\N	\N
2792	452	2	3	2026-01-08 11:02:23	\N	2
2793	453	1	2	2025-12-22 19:02:23	\N	2
2794	453	2	3	2025-12-09 17:02:23	\N	\N
2795	453	3	4	2025-10-07 18:02:23	\N	\N
2796	454	1	2	2025-08-15 00:02:23	\N	4
2797	454	2	3	2026-01-11 12:02:23	\N	5
2798	455	1	2	2025-11-23 12:02:23	\N	\N
2799	455	2	3	2025-10-30 11:02:23	\N	5
2800	455	3	4	2025-12-25 02:02:23	\N	\N
2801	455	4	5	2025-11-07 02:02:23	\N	5
2802	456	1	2	2025-09-11 08:02:23	\N	\N
2803	456	2	3	2025-10-21 02:02:23	\N	1
2804	456	3	4	2025-12-10 04:02:23	\N	2
2805	456	4	5	2026-01-04 01:02:23	\N	1
2806	457	1	2	2025-09-01 22:02:23	\N	\N
2807	457	2	3	2025-08-16 21:02:23	\N	\N
2808	457	3	4	2025-08-25 05:02:23	\N	\N
2809	457	4	5	2025-11-13 22:02:23	\N	5
2810	458	1	2	2025-11-28 02:02:23	\N	1
2811	458	2	3	2025-12-19 06:02:23	\N	1
2812	458	3	4	2025-10-26 15:02:23	\N	\N
2813	459	1	2	2025-12-30 15:02:23	\N	4
2814	459	2	3	2025-11-27 07:02:23	\N	3
2815	460	1	2	2025-11-15 09:02:23	\N	\N
2816	460	2	3	2025-09-08 15:02:23	\N	4
2817	460	3	4	2025-10-02 08:02:23	\N	4
2818	460	4	5	2025-08-16 00:02:23	\N	4
2819	461	1	2	2025-10-11 16:02:23	\N	2
2820	461	2	3	2025-11-10 19:02:23	\N	\N
2821	461	3	4	2025-08-05 05:02:23	\N	4
2822	462	1	2	2026-01-15 09:02:23	\N	\N
2823	462	2	3	2025-08-20 08:02:23	\N	2
2824	462	3	4	2026-01-10 17:02:23	\N	4
2825	463	1	2	2025-10-16 06:02:23	\N	1
2826	463	2	3	2025-11-30 02:02:23	\N	2
2827	464	1	2	2026-01-16 13:02:23	\N	1
2828	464	2	3	2025-11-23 02:02:23	\N	4
2829	465	1	2	2025-10-13 15:02:23	\N	1
2830	465	2	3	2025-11-20 19:02:23	\N	\N
2831	466	1	2	2025-08-12 05:02:23	\N	4
2832	466	2	3	2025-12-10 02:02:23	\N	\N
2833	466	3	4	2026-01-09 17:02:23	\N	\N
2834	467	1	2	2025-09-07 01:02:23	\N	1
2835	467	2	3	2025-12-18 20:02:23	\N	3
2836	467	3	4	2025-12-23 19:02:23	\N	1
2837	468	1	2	2025-10-09 20:02:23	\N	\N
2838	468	2	3	2025-09-29 10:02:23	\N	\N
2839	468	3	4	2025-08-29 02:02:23	\N	5
2840	468	4	5	2025-08-12 12:02:23	\N	\N
2841	469	1	2	2025-08-02 21:02:23	\N	4
2842	469	2	3	2025-12-10 07:02:23	\N	\N
2843	470	1	2	2025-09-16 12:02:23	\N	2
2844	470	2	3	2025-10-15 18:02:23	\N	3
2845	470	3	4	2025-10-14 14:02:23	\N	4
2846	470	4	5	2025-11-25 17:02:23	\N	3
2847	471	1	2	2025-12-01 06:02:23	\N	\N
2848	471	2	3	2025-09-25 04:02:23	\N	5
2849	471	3	4	2025-12-14 20:02:23	\N	1
2850	472	1	2	2025-12-28 00:02:23	\N	3
2851	472	2	3	2025-10-13 12:02:23	\N	2
2852	473	1	2	2025-08-31 21:02:23	\N	\N
2853	473	2	3	2025-10-10 22:02:23	\N	\N
2854	473	3	4	2025-08-20 09:02:23	\N	\N
2855	473	4	5	2025-08-18 20:02:23	\N	\N
2856	474	1	2	2025-12-08 06:02:23	\N	1
2857	474	2	3	2025-10-20 05:02:23	\N	\N
2858	474	3	4	2025-09-28 21:02:23	\N	1
2859	474	4	5	2025-12-15 12:02:23	\N	1
2860	475	1	2	2025-11-24 03:02:23	\N	4
2861	475	2	3	2025-11-12 16:02:23	\N	\N
2862	475	3	4	2026-01-19 21:02:23	\N	2
2863	475	4	5	2025-12-30 04:02:23	\N	\N
2864	476	1	2	2026-01-13 16:02:23	\N	4
2865	476	2	3	2025-09-20 17:02:23	\N	2
2866	476	3	4	2025-09-23 23:02:23	\N	\N
2867	477	1	2	2026-01-05 23:02:23	\N	5
2868	477	2	3	2025-08-24 13:02:23	\N	4
2869	478	1	2	2025-07-24 22:02:23	\N	4
2870	478	2	3	2025-11-23 11:02:23	\N	5
2871	478	3	4	2025-12-24 11:02:23	\N	3
2872	478	4	5	2025-08-18 10:02:23	\N	3
2873	479	1	2	2025-10-29 10:02:23	\N	\N
2874	479	2	3	2025-11-16 21:02:23	\N	4
2875	479	3	4	2025-11-23 18:02:23	\N	5
2876	479	4	5	2025-09-23 05:02:23	\N	\N
2877	480	1	2	2025-09-11 00:02:23	\N	3
2878	480	2	3	2025-12-27 00:02:23	\N	\N
2879	481	1	2	2025-11-08 13:02:23	\N	3
2880	481	2	3	2025-09-07 19:02:23	\N	3
2881	481	3	4	2026-01-19 19:02:23	\N	3
2882	482	1	2	2025-11-26 04:02:23	\N	\N
2883	482	2	3	2025-09-20 04:02:23	\N	2
2884	482	3	4	2025-12-17 11:02:23	\N	3
2885	482	4	5	2025-08-12 23:02:23	\N	\N
2886	483	1	2	2025-10-07 14:02:23	\N	4
2887	483	2	3	2025-09-17 19:02:23	\N	3
2888	483	3	4	2025-12-08 03:02:23	\N	5
2889	484	1	2	2025-07-30 12:02:23	\N	2
2890	484	2	3	2025-10-29 00:02:23	\N	2
2891	484	3	4	2025-11-13 03:02:23	\N	4
2892	484	4	5	2025-09-28 22:02:23	\N	4
2893	485	1	2	2025-07-31 13:02:23	\N	\N
2894	485	2	3	2025-11-02 22:02:23	\N	4
2895	485	3	4	2025-09-11 16:02:23	\N	\N
2896	485	4	5	2025-09-14 17:02:23	\N	2
2897	486	1	2	2025-09-21 06:02:23	\N	5
2898	486	2	3	2025-09-29 01:02:23	\N	5
2899	486	3	4	2025-12-19 02:02:23	\N	4
2900	486	4	5	2025-10-29 15:02:23	\N	3
2901	487	1	2	2025-12-25 06:02:23	\N	\N
2902	487	2	3	2025-10-05 10:02:23	\N	\N
2903	488	1	2	2025-08-13 17:02:23	\N	\N
2904	488	2	3	2025-10-24 08:02:23	\N	1
2905	488	3	4	2026-01-20 08:02:23	\N	4
2906	488	4	5	2026-01-01 01:02:23	\N	3
2907	489	1	2	2026-01-19 03:02:23	\N	4
2908	489	2	3	2025-10-28 09:02:23	\N	1
2909	489	3	4	2025-12-17 18:02:23	\N	4
2910	489	4	5	2025-10-10 23:02:23	\N	1
2911	490	1	2	2025-10-01 09:02:23	\N	\N
2912	490	2	3	2025-10-28 23:02:23	\N	3
2913	491	1	2	2025-09-04 04:02:23	\N	4
2914	491	2	3	2025-11-20 11:02:23	\N	5
2915	491	3	4	2025-09-07 17:02:23	\N	4
2916	492	1	2	2025-10-12 22:02:23	\N	3
2917	492	2	3	2025-09-19 23:02:23	\N	\N
2918	493	1	2	2025-10-21 19:02:23	\N	5
2919	493	2	3	2025-11-07 13:02:23	\N	\N
2920	493	3	4	2025-09-19 07:02:23	\N	5
2921	493	4	5	2025-12-11 17:02:23	\N	4
2922	494	1	2	2025-11-21 00:02:23	\N	4
2923	494	2	3	2025-10-17 08:02:23	\N	2
2924	494	3	4	2025-10-17 00:02:23	\N	5
2925	494	4	5	2025-09-09 13:02:23	\N	\N
2926	495	1	2	2025-11-25 18:02:23	\N	3
2927	495	2	3	2025-12-29 20:02:23	\N	2
2928	495	3	4	2026-01-19 14:02:23	\N	5
2929	495	4	5	2025-12-03 13:02:23	\N	2
2930	496	1	2	2025-11-13 22:02:23	\N	\N
2931	496	2	3	2025-12-25 09:02:23	\N	\N
2932	496	3	4	2026-01-15 17:02:23	\N	4
2933	497	1	2	2026-01-19 11:02:23	\N	1
2934	497	2	3	2026-01-07 23:02:23	\N	2
2935	498	1	2	2025-12-17 19:02:23	\N	4
2936	498	2	3	2025-11-23 08:02:23	\N	4
2937	498	3	4	2025-08-04 22:02:23	\N	2
2938	498	4	5	2025-12-19 19:02:23	\N	4
2939	499	1	2	2025-11-13 19:02:23	\N	5
2940	499	2	3	2025-12-24 05:02:23	\N	3
2941	500	1	2	2025-07-31 05:02:23	\N	\N
2942	500	2	3	2025-08-18 13:02:23	\N	1
2943	500	3	4	2025-08-18 17:02:23	\N	\N
2944	500	4	5	2025-12-07 05:02:23	\N	5
\.


--
-- Data for Name: клиенты; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."клиенты" ("ид_клиент", "название", "тип_клиента", "контактный_телефон", "электронная_почта", "адрес_регистрации", "инн", "кпп", "дата_создания", "статус") FROM stdin;
1	ООО "Ромашка Логистик"	юридическое лицо	+79001234567	info@romashka.ru	\N	770123456789	\N	2026-01-21 19:43:43.936023	активный
2	ООО "Транс-Сервис"	юридическое лицо	+79001234568	contact@trans-service.ru	\N	780234567890	\N	2026-01-21 19:43:43.936023	активный
3	ИП Иванов Иван Иванович	индивидуальный предприниматель	+79009876543	ivanov@mail.ru	\N	540987654321	\N	2026-01-21 19:43:43.936023	активный
4	ООО "МегаТорг"	юридическое лицо	+79101112233	sales@megatorg.ru	\N	660345678901	\N	2026-01-21 19:43:43.936023	активный
5	ООО "СтройМаркет"	юридическое лицо	+79202223344	info@stroymarket.ru	\N	161456789012	\N	2026-01-21 19:43:43.936023	активный
6	ИП Петров Петр Петрович	индивидуальный предприниматель	+79303334455	petrov@yandex.ru	\N	523567890123	\N	2026-01-21 19:43:43.936023	активный
7	ООО "ТехноСнаб"	юридическое лицо	+79404445566	order@tehnosnab.ru	\N	740678901234	\N	2026-01-21 19:43:43.936023	активный
8	ООО "ЭлектроМир"	юридическое лицо	+79505556677	info@electromir.ru	\N	630789012345	\N	2026-01-21 19:43:43.936023	активный
9	ИП Сидорова Анна Олеговна	индивидуальный предприниматель	+79606667788	sidorova@gmail.com	\N	550890123456	\N	2026-01-21 19:43:43.936023	активный
10	ООО "АвтоДеталь"	юридическое лицо	+79707778899	sales@avtodetal.ru	\N	610901234567	\N	2026-01-21 19:43:43.936023	активный
11	ООО "ПродТорг"	юридическое лицо	+79808889900	info@prodtorg.ru	\N	020123456789	\N	2026-01-21 19:43:43.936023	активный
12	ООО "МебельГрад"	юридическое лицо	+79909991011	order@mebelgrad.ru	\N	240234567890	\N	2026-01-21 19:43:43.936023	активный
13	ИП Кузнецов Сергей Петрович	индивидуальный предприниматель	+79101011121	kuznetsov@mail.ru	\N	360345678901	\N	2026-01-21 19:43:43.936023	активный
14	ООО "ТекстильПро"	юридическое лицо	+79201021131	info@textilpro.ru	\N	590456789012	\N	2026-01-21 19:43:43.936023	активный
15	ООО "АгроСнаб"	юридическое лицо	+79301031141	contact@agrosnab.ru	\N	340567890123	\N	2026-01-21 19:43:43.936023	активный
16	ИП Морозова Елена Викторовна	индивидуальный предприниматель	+79401041151	morozova@yandex.ru	\N	230678901234	\N	2026-01-21 19:43:43.936023	активный
17	ООО "КнигаМир"	юридическое лицо	+79501051161	sales@knigamir.ru	\N	640789012345	\N	2026-01-21 19:43:43.936023	активный
18	ООО "ХимПром"	юридическое лицо	+79601061171	info@himprom.ru	\N	720890123456	\N	2026-01-21 19:43:43.936023	активный
19	ИП Новиков Андрей Сергеевич	индивидуальный предприниматель	+79701071181	novikov@gmail.com	\N	630901234567	\N	2026-01-21 19:43:43.936023	активный
20	ООО "СпортМастер"	юридическое лицо	+79801081191	order@sportmaster.ru	\N	180123456789	\N	2026-01-21 19:43:43.936023	активный
21	ООО "ФармаЛекс"	юридическое лицо	+79901091201	info@farmalex.ru	\N	220234567890	\N	2026-01-21 19:43:43.936023	активный
22	ИП Васильев Дмитрий Иванович	индивидуальный предприниматель	+79101101211	vasiliev@mail.ru	\N	380345678901	\N	2026-01-21 19:43:43.936023	активный
23	ООО "ИнструментТорг"	юридическое лицо	+79201111221	sales@instrumenttorg.ru	\N	270456789012	\N	2026-01-21 19:43:43.936023	активный
24	ООО "РыбПром"	юридическое лицо	+79301121231	info@ribprom.ru	\N	250567890123	\N	2026-01-21 19:43:43.936023	активный
25	ИП Федоров Олег Петрович	индивидуальный предприниматель	+79401131241	fedorov@yandex.ru	\N	700678901234	\N	2026-01-21 19:43:43.936023	активный
26	ООО "ГлавСтрой"	юридическое лицо	+79501141251	contact@glavstroy.ru	\N	770789012345	\N	2026-01-21 19:43:43.936023	активный
27	ООО "ЭнергоПлюс"	юридическое лицо	+79601151261	info@energoplus.ru	\N	780890123456	\N	2026-01-21 19:43:43.936023	активный
28	ИП Соколов Игорь Владимирович	индивидуальный предприниматель	+79701161271	sokolov@gmail.com	\N	540901234567	\N	2026-01-21 19:43:43.936023	активный
29	ООО "КомпьюТех"	юридическое лицо	+79801171281	sales@compyuteh.ru	\N	660123456789	\N	2026-01-21 19:43:43.936023	активный
30	ООО "БытТехника"	юридическое лицо	+79901181291	info@bittehnika.ru	\N	161234567890	\N	2026-01-21 19:43:43.936023	активный
31	ИП Григорьев Максим Андреевич	индивидуальный предприниматель	+79101191301	grigoriev@mail.ru	\N	523345678901	\N	2026-01-21 19:43:43.936023	активный
32	ООО "ЛесоТорг"	юридическое лицо	+79201201311	order@lesotorg.ru	\N	740456789012	\N	2026-01-21 19:43:43.936023	активный
33	ООО "МеталлСервис"	юридическое лицо	+79301211321	info@metallservis.ru	\N	630567890123	\N	2026-01-21 19:43:43.936023	активный
34	ИП Михайлов Роман Сергеевич	индивидуальный предприниматель	+79401221331	mihailov@yandex.ru	\N	550678901234	\N	2026-01-21 19:43:43.936023	активный
35	ООО "ОдеждаОпт"	юридическое лицо	+79501231341	sales@odegdaopt.ru	\N	610789012345	\N	2026-01-21 19:43:43.936023	активный
36	ООО "ТоварыДома"	юридическое лицо	+79601241351	info@tovaridoma.ru	\N	020890123456	\N	2026-01-21 19:43:43.936023	активный
37	ИП Павлов Виктор Олегович	индивидуальный предприниматель	+79701251361	pavlov@gmail.com	\N	240901234567	\N	2026-01-21 19:43:43.936023	активный
38	ООО "ЗоотТорг"	юридическое лицо	+79801261371	contact@zoottorg.ru	\N	360123456789	\N	2026-01-21 19:43:43.936023	активный
39	ООО "ДетскийМир"	юридическое лицо	+79901271381	info@detskiymir.ru	\N	590234567890	\N	2026-01-21 19:43:43.936023	активный
40	ИП Николаев Евгений Викторович	индивидуальный предприниматель	+79101281391	nikolaev@mail.ru	\N	340345678901	\N	2026-01-21 19:43:43.936023	активный
41	ООО "АвтоЗапчасти"	юридическое лицо	+79201291401	sales@avtozapchasti.ru	\N	230456789012	\N	2026-01-21 19:43:43.936023	активный
42	ООО "ПластикПро"	юридическое лицо	+79301301411	info@plastikpro.ru	\N	640567890123	\N	2026-01-21 19:43:43.936023	активный
43	ИП Романов Сергей Дмитриевич	индивидуальный предприниматель	+79401311421	romanov@yandex.ru	\N	720678901234	\N	2026-01-21 19:43:43.936023	активный
44	ООО "УпаковкаПлюс"	юридическое лицо	+79501321431	order@upakovkaplus.ru	\N	630789012345	\N	2026-01-21 19:43:43.936023	активный
45	ООО "БумагаОпт"	юридическое лицо	+79601331441	info@bumagaopt.ru	\N	180890123456	\N	2026-01-21 19:43:43.936023	активный
46	ИП Егоров Владислав Игоревич	индивидуальный предприниматель	+79701341451	egorov@gmail.com	\N	220901234567	\N	2026-01-21 19:43:43.936023	активный
47	ООО "СадОгород"	юридическое лицо	+79801351461	contact@sadogorod.ru	\N	380123456789	\N	2026-01-21 19:43:43.936023	активный
48	ООО "ИгрушкиДетям"	юридическое лицо	+79901361471	sales@igrushkidetyam.ru	\N	270234567890	\N	2026-01-21 19:43:43.936023	активный
49	ИП Степанов Артем Васильевич	индивидуальный предприниматель	+79101371481	stepanov@mail.ru	\N	250345678901	\N	2026-01-21 19:43:43.936023	активный
50	ООО "КосметикаПро"	юридическое лицо	+79201381491	info@kosmetikapro.ru	\N	700456789012	\N	2026-01-21 19:43:43.936023	активный
\.


--
-- Data for Name: маршруты; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."маршруты" ("ид_маршрут", "код_маршрута", "наименование", "описание", "общее_расстояние_км", "ожидаемое_время_часов", "статус", "тип_маршрута", "дата_создания", "стоимость_за_км_руб", "приоритет") FROM stdin;
1	R1	M1	Route 1	2487.00	35.50	активный	городской	2025-06-30	34.79	3
2	R2	M2	Route 2	2091.00	29.90	активный	междугородний	2024-09-23	15.34	4
3	R3	M3	Route 3	585.00	8.40	активный	городской	2025-05-13	42.50	5
4	R4	M4	Route 4	1025.00	14.60	не_используется	междугородний	2024-02-29	23.77	3
5	R5	M5	Route 5	1528.00	21.80	не_используется	междугородний	2024-03-11	22.25	1
6	R6	M6	Route 6	3367.00	48.10	активный	междугородний	2024-11-20	15.75	1
7	R7	M7	Route 7	2359.00	33.70	активный	городской	2024-09-02	29.86	1
8	R8	M8	Route 8	664.00	9.50	активный	городской	2025-06-02	23.79	5
9	R9	M9	Route 9	87.00	1.20	не_используется	городской	2024-05-26	27.98	4
10	R10	M10	Route 10	1735.00	24.80	активный	городской	2025-02-08	30.95	5
11	R11	M11	Route 11	3240.00	46.30	активный	городской	2024-05-27	15.05	4
12	R12	M12	Route 12	883.00	12.60	активный	городской	2024-12-04	17.94	2
13	R13	M13	Route 13	2775.00	39.60	активный	междугородний	2024-11-19	19.63	4
14	R14	M14	Route 14	1854.00	26.50	активный	городской	2024-07-29	33.55	1
15	R15	M15	Route 15	3423.00	48.90	не_используется	междугородний	2025-11-10	26.47	1
16	R16	M16	Route 16	1886.00	26.90	не_используется	городской	2025-07-28	16.21	4
17	R17	M17	Route 17	446.00	6.40	не_используется	междугородний	2024-02-12	34.40	4
18	R18	M18	Route 18	1623.00	23.20	не_используется	междугородний	2025-02-25	17.06	2
19	R19	M19	Route 19	2993.00	42.80	активный	междугородний	2025-03-10	31.65	3
20	R20	M20	Route 20	1076.00	15.40	не_используется	междугородний	2025-09-03	37.79	4
21	R21	M21	Route 21	2196.00	31.40	активный	городской	2025-08-17	42.19	2
22	R22	M22	Route 22	2583.00	36.90	не_используется	междугородний	2025-06-29	42.91	1
23	R23	M23	Route 23	288.00	4.10	не_используется	междугородний	2025-01-08	42.78	4
24	R24	M24	Route 24	1649.00	23.60	не_используется	междугородний	2024-07-11	43.78	1
25	R25	M25	Route 25	1629.00	23.30	активный	городской	2024-09-03	25.88	4
26	R26	M26	Route 26	2903.00	41.50	не_используется	городской	2025-08-07	43.57	2
27	R27	M27	Route 27	2700.00	38.60	не_используется	городской	2025-05-21	23.09	5
28	R28	M28	Route 28	1506.00	21.50	не_используется	городской	2024-07-29	39.12	3
29	R29	M29	Route 29	3435.00	49.10	не_используется	междугородний	2024-06-19	32.87	5
30	R30	M30	Route 30	1067.00	15.20	не_используется	междугородний	2025-07-27	43.92	4
31	R31	M31	Route 31	188.00	2.70	не_используется	междугородний	2025-07-09	29.75	5
32	R32	M32	Route 32	3105.00	44.40	не_используется	городской	2025-05-12	23.96	3
33	R33	M33	Route 33	3172.00	45.30	активный	междугородний	2025-04-07	27.89	3
34	R34	M34	Route 34	3089.00	44.10	не_используется	междугородний	2025-02-14	40.18	5
35	R35	M35	Route 35	2798.00	40.00	не_используется	городской	2024-11-27	32.70	5
36	R36	M36	Route 36	990.00	14.10	не_используется	городской	2024-10-23	27.98	2
37	R37	M37	Route 37	2337.00	33.40	не_используется	междугородний	2024-08-13	31.94	2
38	R38	M38	Route 38	1446.00	20.70	активный	городской	2025-07-21	16.71	3
39	R39	M39	Route 39	1666.00	23.80	не_используется	междугородний	2025-08-06	41.95	1
40	R40	M40	Route 40	837.00	12.00	не_используется	городской	2024-11-17	29.18	2
41	R41	M41	Route 41	2479.00	35.40	не_используется	междугородний	2025-05-31	20.22	5
42	R42	M42	Route 42	2653.00	37.90	не_используется	междугородний	2024-03-09	16.59	5
43	R43	M43	Route 43	2590.00	37.00	не_используется	городской	2025-05-16	28.74	3
44	R44	M44	Route 44	727.00	10.40	не_используется	городской	2025-08-13	36.33	3
45	R45	M45	Route 45	424.00	6.10	не_используется	городской	2025-11-25	18.96	3
46	R46	M46	Route 46	160.00	2.30	активный	городской	2025-01-23	36.18	5
47	R47	M47	Route 47	1661.00	23.70	активный	городской	2025-09-22	29.45	3
48	R48	M48	Route 48	1503.00	21.50	не_используется	городской	2025-02-05	30.06	5
49	R49	M49	Route 49	839.00	12.00	не_используется	междугородний	2024-02-04	26.02	1
50	R50	M50	Route 50	3269.00	46.70	не_используется	междугородний	2024-04-19	33.23	5
\.


--
-- Data for Name: остановки_маршрута; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."остановки_маршрута" ("ид_остановка", "ид_маршрут", "порядковый_номер", "ид_город", "расстояние_от_предыдущей_км", "ожидаемое_время_прибытия_часов", "ожидаемое_время_отправки_часов", "время_простоя_минут", "тип_остановки", "дата_создания") FROM stdin;
247	1	1	12	0.00	0.00	1.43	86	промежуточная	2025-12-07 00:00:00
248	1	2	9	231.00	4.73	6.05	79	промежуточная	2024-02-05 00:00:00
249	1	3	14	212.00	9.08	10.13	63	промежуточная	2025-12-20 00:00:00
250	1	4	18	91.00	11.43	12.41	59	промежуточная	2024-04-09 00:00:00
251	1	5	20	206.00	15.35	16.08	44	техническая	2024-12-19 00:00:00
252	1	6	2	63.00	16.98	18.98	120	промежуточная	2025-08-27 00:00:00
253	1	7	11	147.00	21.08	22.01	56	конечная	2024-06-10 00:00:00
254	2	1	7	0.00	0.00	1.50	90	промежуточная	2024-08-16 00:00:00
255	2	2	6	231.00	4.80	5.75	57	промежуточная	2025-03-06 00:00:00
256	2	3	13	244.00	9.24	11.01	106	техническая	2025-10-03 00:00:00
257	2	4	2	291.00	15.17	15.45	17	конечная	2025-07-15 00:00:00
258	3	1	13	0.00	0.00	0.30	18	промежуточная	2024-12-26 00:00:00
259	3	2	15	142.00	2.33	2.95	37	техническая	2024-11-27 00:00:00
260	3	3	19	77.00	4.05	4.87	49	конечная	2025-05-25 00:00:00
261	4	1	4	0.00	0.00	1.70	102	промежуточная	2024-09-27 00:00:00
262	4	2	5	133.00	3.60	5.05	87	техническая	2025-08-17 00:00:00
263	4	3	16	190.00	7.76	8.68	55	техническая	2025-10-10 00:00:00
264	4	4	19	202.00	11.57	12.69	67	промежуточная	2025-04-26 00:00:00
265	4	5	21	232.00	16.00	17.77	106	промежуточная	2024-05-11 00:00:00
266	4	6	8	84.00	18.97	20.15	71	промежуточная	2025-12-10 00:00:00
267	4	7	7	155.00	22.36	22.81	27	конечная	2025-07-24 00:00:00
268	5	1	11	0.00	0.00	1.08	65	промежуточная	2024-12-07 00:00:00
269	5	2	19	291.00	5.24	5.92	41	промежуточная	2025-06-03 00:00:00
270	5	3	25	215.00	8.99	10.54	93	конечная	2024-12-29 00:00:00
271	6	1	19	0.00	0.00	0.47	28	промежуточная	2025-07-29 00:00:00
272	6	2	4	178.00	3.01	3.46	27	техническая	2025-01-22 00:00:00
273	6	3	21	151.00	5.62	6.29	40	техническая	2025-03-11 00:00:00
274	6	4	11	249.00	9.85	10.22	22	техническая	2024-02-03 00:00:00
275	6	5	12	279.00	14.21	15.09	53	конечная	2024-11-10 00:00:00
276	7	1	20	0.00	0.00	1.93	116	промежуточная	2024-03-22 00:00:00
277	7	2	11	235.00	5.29	7.19	114	промежуточная	2025-01-08 00:00:00
278	7	3	5	189.00	9.89	10.24	21	промежуточная	2025-06-05 00:00:00
279	7	4	2	252.00	13.84	15.67	110	промежуточная	2025-04-20 00:00:00
280	7	5	7	299.00	19.94	20.86	55	техническая	2025-11-17 00:00:00
281	7	6	17	80.00	22.00	22.60	36	конечная	2024-07-31 00:00:00
282	8	1	22	0.00	0.00	1.65	99	техническая	2025-09-24 00:00:00
283	8	2	21	77.00	2.75	4.38	98	техническая	2025-10-26 00:00:00
284	8	3	4	156.00	6.61	7.28	40	промежуточная	2025-03-30 00:00:00
285	8	4	19	180.00	9.85	10.70	51	конечная	2025-08-04 00:00:00
286	9	1	21	0.00	0.00	0.67	40	промежуточная	2025-09-13 00:00:00
287	9	2	22	286.00	4.76	6.66	114	техническая	2024-11-05 00:00:00
288	9	3	7	122.00	8.40	10.15	105	промежуточная	2024-05-26 00:00:00
289	9	4	10	142.00	12.18	12.80	37	техническая	2024-11-10 00:00:00
290	9	5	14	133.00	14.70	15.92	73	техническая	2024-12-13 00:00:00
291	9	6	5	296.00	20.15	21.63	89	промежуточная	2024-09-14 00:00:00
292	9	7	17	155.00	23.84	25.04	72	конечная	2025-06-24 00:00:00
293	10	1	19	0.00	0.00	1.47	88	техническая	2025-03-26 00:00:00
294	10	2	2	156.00	3.70	4.98	77	техническая	2024-12-30 00:00:00
295	10	3	9	88.00	6.24	6.57	20	промежуточная	2024-11-19 00:00:00
296	10	4	3	295.00	10.78	12.33	93	конечная	2025-04-10 00:00:00
297	11	1	12	0.00	0.00	0.45	27	промежуточная	2025-10-27 00:00:00
298	11	2	22	186.00	3.11	5.06	117	промежуточная	2024-10-10 00:00:00
299	11	3	5	180.00	7.63	8.46	50	конечная	2024-10-11 00:00:00
300	12	1	11	0.00	0.00	1.40	84	техническая	2024-09-17 00:00:00
301	12	2	7	253.00	5.01	6.54	92	техническая	2025-10-20 00:00:00
302	12	3	16	295.00	10.75	12.00	75	промежуточная	2024-11-29 00:00:00
303	12	4	8	246.00	15.51	15.76	15	техническая	2025-01-16 00:00:00
304	12	5	13	285.00	19.83	21.21	83	техническая	2025-07-19 00:00:00
305	12	6	19	256.00	24.87	26.87	120	конечная	2025-09-19 00:00:00
306	13	1	24	0.00	0.00	0.60	36	промежуточная	2025-10-27 00:00:00
307	13	2	2	112.00	2.20	3.82	97	промежуточная	2025-01-14 00:00:00
308	13	3	7	232.00	7.13	8.60	88	техническая	2024-12-28 00:00:00
309	13	4	1	177.00	11.13	13.10	118	техническая	2024-12-29 00:00:00
310	13	5	8	69.00	14.09	15.19	66	конечная	2024-11-16 00:00:00
311	14	1	13	0.00	0.00	0.38	23	промежуточная	2025-05-06 00:00:00
312	14	2	2	274.00	4.29	5.06	46	промежуточная	2025-02-04 00:00:00
313	14	3	8	130.00	6.92	7.90	59	конечная	2025-05-10 00:00:00
314	15	1	6	0.00	0.00	0.33	20	промежуточная	2024-12-11 00:00:00
315	15	2	21	244.00	3.82	4.95	68	промежуточная	2025-10-24 00:00:00
316	15	3	9	189.00	7.65	8.40	45	промежуточная	2024-04-29 00:00:00
317	15	4	10	104.00	9.89	11.09	72	промежуточная	2025-07-11 00:00:00
318	15	5	12	245.00	14.59	15.57	59	промежуточная	2025-02-16 00:00:00
319	15	6	23	193.00	18.33	20.16	110	промежуточная	2024-07-23 00:00:00
320	15	7	15	109.00	21.72	23.25	92	конечная	2025-07-01 00:00:00
321	16	1	12	0.00	0.00	1.80	108	промежуточная	2024-04-28 00:00:00
322	16	2	24	91.00	3.10	4.65	93	промежуточная	2024-08-29 00:00:00
323	16	3	16	199.00	7.49	8.22	44	техническая	2025-06-07 00:00:00
324	16	4	17	59.00	9.06	9.99	56	промежуточная	2024-03-18 00:00:00
325	16	5	5	166.00	12.36	12.98	37	промежуточная	2024-01-28 00:00:00
326	16	6	11	186.00	15.64	16.66	61	конечная	2025-07-13 00:00:00
327	17	1	17	0.00	0.00	0.42	25	промежуточная	2024-09-29 00:00:00
328	17	2	1	257.00	4.09	5.24	69	промежуточная	2025-10-17 00:00:00
329	17	3	20	295.00	9.45	11.35	114	промежуточная	2025-07-29 00:00:00
330	17	4	3	248.00	14.89	15.66	46	промежуточная	2024-01-30 00:00:00
331	17	5	7	277.00	19.62	20.12	30	промежуточная	2024-09-21 00:00:00
332	17	6	6	69.00	21.11	23.11	120	техническая	2025-02-05 00:00:00
333	17	7	18	127.00	24.92	26.82	114	конечная	2025-07-18 00:00:00
334	18	1	22	0.00	0.00	0.52	31	техническая	2025-06-06 00:00:00
335	18	2	24	236.00	3.89	5.36	88	промежуточная	2024-10-22 00:00:00
336	18	3	7	211.00	8.37	8.64	16	техническая	2025-02-26 00:00:00
337	18	4	14	170.00	11.07	12.42	81	промежуточная	2024-12-08 00:00:00
338	18	5	9	206.00	15.36	16.81	87	техническая	2025-12-20 00:00:00
339	18	6	3	242.00	20.27	21.14	52	конечная	2025-01-23 00:00:00
340	19	1	8	0.00	0.00	0.53	32	промежуточная	2024-02-06 00:00:00
341	19	2	11	212.00	3.56	4.48	55	промежуточная	2024-03-18 00:00:00
342	19	3	14	254.00	8.11	9.78	100	техническая	2024-09-27 00:00:00
343	19	4	21	89.00	11.05	11.82	46	конечная	2025-05-15 00:00:00
344	20	1	4	0.00	0.00	1.57	94	промежуточная	2025-01-22 00:00:00
345	20	2	17	51.00	2.30	2.87	34	техническая	2025-11-11 00:00:00
346	20	3	23	129.00	4.71	6.41	102	техническая	2025-10-03 00:00:00
347	20	4	14	112.00	8.01	9.71	102	конечная	2025-04-10 00:00:00
348	21	1	2	0.00	0.00	1.65	99	техническая	2024-09-30 00:00:00
349	21	2	16	175.00	4.15	4.62	28	промежуточная	2025-03-24 00:00:00
350	21	3	1	169.00	7.03	7.43	24	конечная	2024-11-03 00:00:00
351	22	1	8	0.00	0.00	0.85	51	промежуточная	2024-11-20 00:00:00
352	22	2	24	116.00	2.51	3.91	84	техническая	2024-02-12 00:00:00
353	22	3	5	87.00	5.15	6.23	65	техническая	2024-11-10 00:00:00
354	22	4	6	123.00	7.99	8.49	30	конечная	2025-04-05 00:00:00
355	23	1	20	0.00	0.00	0.80	48	промежуточная	2025-08-15 00:00:00
356	23	2	2	101.00	2.24	3.11	52	промежуточная	2025-10-11 00:00:00
357	23	3	14	192.00	5.85	7.30	87	техническая	2025-02-28 00:00:00
358	23	4	1	203.00	10.20	10.55	21	конечная	2024-08-27 00:00:00
359	24	1	12	0.00	0.00	0.55	33	промежуточная	2024-01-26 00:00:00
360	24	2	5	130.00	2.41	3.11	42	техническая	2025-11-03 00:00:00
361	24	3	8	162.00	5.42	5.82	24	конечная	2025-03-26 00:00:00
362	25	1	14	0.00	0.00	1.07	64	промежуточная	2024-06-08 00:00:00
363	25	2	17	85.00	2.28	3.21	56	промежуточная	2025-12-08 00:00:00
364	25	3	5	216.00	6.30	8.07	106	техническая	2025-03-23 00:00:00
365	25	4	22	144.00	10.13	10.48	21	техническая	2025-04-03 00:00:00
366	25	5	4	53.00	11.24	11.82	35	конечная	2025-04-05 00:00:00
367	26	1	22	0.00	0.00	2.00	120	промежуточная	2024-03-11 00:00:00
368	26	2	7	200.00	4.86	6.68	109	техническая	2025-12-18 00:00:00
369	26	3	20	181.00	9.27	11.19	115	промежуточная	2025-03-24 00:00:00
370	26	4	3	80.00	12.33	13.08	45	техническая	2025-02-23 00:00:00
371	26	5	2	92.00	14.39	14.86	28	промежуточная	2024-06-09 00:00:00
372	26	6	23	221.00	18.02	19.20	71	конечная	2025-04-25 00:00:00
373	27	1	18	0.00	0.00	0.50	30	техническая	2025-02-23 00:00:00
374	27	2	9	196.00	3.30	5.30	120	промежуточная	2025-10-14 00:00:00
375	27	3	24	130.00	7.16	8.06	54	техническая	2025-02-27 00:00:00
376	27	4	10	150.00	10.20	12.08	113	техническая	2025-04-10 00:00:00
377	27	5	12	204.00	14.99	16.34	81	конечная	2024-12-31 00:00:00
378	28	1	18	0.00	0.00	1.65	99	промежуточная	2025-12-11 00:00:00
379	28	2	15	86.00	2.88	3.80	55	промежуточная	2025-03-15 00:00:00
380	28	3	7	179.00	6.36	7.93	94	техническая	2025-09-13 00:00:00
381	28	4	25	154.00	10.13	10.40	16	промежуточная	2024-07-21 00:00:00
382	28	5	1	260.00	14.11	15.88	106	промежуточная	2025-02-03 00:00:00
383	28	6	12	266.00	19.68	20.03	21	конечная	2024-01-30 00:00:00
384	29	1	18	0.00	0.00	0.75	45	промежуточная	2025-07-06 00:00:00
385	29	2	10	93.00	2.08	2.71	38	промежуточная	2025-03-24 00:00:00
386	29	3	22	292.00	6.88	8.28	84	промежуточная	2025-06-29 00:00:00
387	29	4	13	161.00	10.58	11.60	61	техническая	2024-08-13 00:00:00
388	29	5	24	58.00	12.43	13.13	42	конечная	2024-02-11 00:00:00
389	30	1	7	0.00	0.00	0.35	21	техническая	2024-11-08 00:00:00
390	30	2	11	96.00	1.72	3.22	90	техническая	2025-06-05 00:00:00
391	30	3	21	228.00	6.48	8.33	111	промежуточная	2025-06-07 00:00:00
392	30	4	19	162.00	10.64	12.59	117	техническая	2025-08-17 00:00:00
393	30	5	18	145.00	14.66	15.26	36	техническая	2024-10-19 00:00:00
394	30	6	22	244.00	18.75	19.18	26	конечная	2025-11-03 00:00:00
395	31	1	3	0.00	0.00	1.08	65	промежуточная	2024-09-29 00:00:00
396	31	2	1	143.00	3.12	3.99	52	техническая	2025-04-02 00:00:00
397	31	3	22	160.00	6.28	7.48	72	техническая	2025-08-22 00:00:00
398	31	4	23	214.00	10.54	10.87	20	промежуточная	2024-08-12 00:00:00
399	31	5	20	151.00	13.03	14.95	115	конечная	2024-04-20 00:00:00
400	32	1	8	0.00	0.00	1.53	92	техническая	2024-02-27 00:00:00
401	32	2	15	299.00	5.80	6.90	66	промежуточная	2024-03-23 00:00:00
402	32	3	17	144.00	8.96	9.98	61	промежуточная	2025-03-12 00:00:00
403	32	4	11	247.00	13.51	14.69	71	конечная	2025-04-29 00:00:00
404	33	1	7	0.00	0.00	0.83	50	промежуточная	2025-03-17 00:00:00
405	33	2	3	223.00	4.02	4.42	24	промежуточная	2025-01-18 00:00:00
406	33	3	24	246.00	7.93	9.61	101	промежуточная	2024-11-17 00:00:00
407	33	4	14	53.00	10.37	11.45	65	конечная	2024-02-12 00:00:00
408	34	1	4	0.00	0.00	0.68	41	промежуточная	2024-12-23 00:00:00
409	34	2	7	195.00	3.47	4.92	87	промежуточная	2024-02-28 00:00:00
410	34	3	22	118.00	6.61	7.98	82	техническая	2025-03-23 00:00:00
411	34	4	14	299.00	12.25	13.02	46	техническая	2025-11-02 00:00:00
412	34	5	3	297.00	17.26	17.69	26	промежуточная	2024-10-23 00:00:00
413	34	6	25	200.00	20.55	21.58	62	конечная	2025-12-19 00:00:00
414	35	1	11	0.00	0.00	1.93	116	техническая	2025-05-06 00:00:00
415	35	2	4	129.00	3.77	5.42	99	промежуточная	2024-10-26 00:00:00
416	35	3	1	107.00	6.95	7.32	22	конечная	2025-01-13 00:00:00
417	36	1	24	0.00	0.00	1.33	80	промежуточная	2024-11-30 00:00:00
418	36	2	15	113.00	2.94	4.19	75	промежуточная	2025-02-25 00:00:00
419	36	3	11	172.00	6.65	8.22	94	техническая	2024-06-17 00:00:00
420	36	4	18	235.00	11.58	13.55	118	промежуточная	2025-06-10 00:00:00
421	36	5	10	70.00	14.55	15.97	85	промежуточная	2024-03-01 00:00:00
422	36	6	13	161.00	18.27	20.00	104	конечная	2025-07-08 00:00:00
423	37	1	1	0.00	0.00	0.73	44	промежуточная	2024-09-27 00:00:00
424	37	2	5	74.00	1.79	2.92	68	промежуточная	2024-11-06 00:00:00
425	37	3	8	297.00	7.16	8.73	94	промежуточная	2025-04-29 00:00:00
426	37	4	3	73.00	9.77	10.24	28	промежуточная	2024-05-04 00:00:00
427	37	5	4	280.00	14.24	15.66	85	промежуточная	2025-09-22 00:00:00
428	37	6	17	166.00	18.03	19.20	70	конечная	2025-02-22 00:00:00
429	38	1	17	0.00	0.00	1.12	67	промежуточная	2024-08-17 00:00:00
430	38	2	14	179.00	3.68	5.01	80	промежуточная	2025-07-14 00:00:00
431	38	3	15	217.00	8.11	9.26	69	промежуточная	2025-08-24 00:00:00
432	38	4	8	247.00	12.79	13.61	49	промежуточная	2024-12-15 00:00:00
433	38	5	11	81.00	14.77	15.05	17	техническая	2025-07-19 00:00:00
434	38	6	7	163.00	17.38	17.65	16	конечная	2025-11-06 00:00:00
435	39	1	5	0.00	0.00	1.65	99	промежуточная	2024-11-20 00:00:00
436	39	2	1	122.00	3.39	4.26	52	техническая	2025-05-07 00:00:00
437	39	3	22	88.00	5.52	6.60	65	промежуточная	2025-09-18 00:00:00
438	39	4	19	51.00	7.33	8.38	63	конечная	2025-05-20 00:00:00
439	40	1	16	0.00	0.00	1.05	63	промежуточная	2025-06-02 00:00:00
440	40	2	2	87.00	2.29	3.32	62	техническая	2025-01-25 00:00:00
441	40	3	23	65.00	4.25	5.32	64	конечная	2024-12-10 00:00:00
442	41	1	13	0.00	0.00	1.65	99	промежуточная	2025-07-27 00:00:00
443	41	2	7	215.00	4.72	5.69	58	техническая	2025-07-20 00:00:00
444	41	3	21	168.00	8.09	9.16	64	промежуточная	2024-01-23 00:00:00
445	41	4	18	83.00	10.35	11.17	49	промежуточная	2025-01-09 00:00:00
446	41	5	17	157.00	13.41	13.98	34	промежуточная	2025-08-26 00:00:00
447	41	6	4	184.00	16.61	18.03	85	конечная	2025-03-12 00:00:00
448	42	1	22	0.00	0.00	0.72	43	промежуточная	2025-10-08 00:00:00
449	42	2	11	251.00	4.31	4.89	35	техническая	2024-11-30 00:00:00
450	42	3	17	68.00	5.86	7.86	120	техническая	2025-02-15 00:00:00
451	42	4	13	103.00	9.33	10.40	64	техническая	2024-03-12 00:00:00
452	42	5	5	68.00	11.37	13.27	114	техническая	2025-09-14 00:00:00
453	42	6	14	162.00	15.58	16.26	41	конечная	2024-07-02 00:00:00
454	43	1	22	0.00	0.00	1.63	98	промежуточная	2024-06-06 00:00:00
455	43	2	8	205.00	4.56	6.06	90	промежуточная	2025-11-18 00:00:00
456	43	3	13	265.00	9.85	10.33	29	конечная	2025-02-03 00:00:00
457	44	1	21	0.00	0.00	0.83	50	промежуточная	2025-04-30 00:00:00
458	44	2	17	297.00	5.07	6.99	115	промежуточная	2025-07-14 00:00:00
459	44	3	3	125.00	8.78	9.36	35	техническая	2024-03-14 00:00:00
460	44	4	16	298.00	13.62	15.39	106	техническая	2025-02-18 00:00:00
461	44	5	23	269.00	19.23	20.25	61	промежуточная	2025-03-12 00:00:00
462	44	6	24	192.00	22.99	23.92	56	промежуточная	2025-10-13 00:00:00
463	44	7	1	66.00	24.86	26.79	116	конечная	2025-01-05 00:00:00
464	45	1	7	0.00	0.00	0.87	52	промежуточная	2024-09-20 00:00:00
465	45	2	25	78.00	1.98	3.05	64	промежуточная	2024-12-30 00:00:00
466	45	3	9	113.00	4.66	5.96	78	конечная	2025-07-07 00:00:00
467	46	1	10	0.00	0.00	0.73	44	промежуточная	2024-02-26 00:00:00
468	46	2	4	56.00	1.53	2.06	32	техническая	2024-11-05 00:00:00
469	46	3	16	273.00	5.96	6.43	28	техническая	2024-06-06 00:00:00
470	46	4	12	80.00	7.57	8.85	77	промежуточная	2025-06-25 00:00:00
471	46	5	18	277.00	12.81	14.31	90	промежуточная	2025-12-18 00:00:00
472	46	6	14	155.00	16.52	17.77	75	конечная	2024-10-09 00:00:00
473	47	1	12	0.00	0.00	0.72	43	промежуточная	2024-06-16 00:00:00
474	47	2	13	184.00	3.35	4.18	50	промежуточная	2024-06-07 00:00:00
475	47	3	5	96.00	5.55	6.87	79	конечная	2024-01-29 00:00:00
476	48	1	8	0.00	0.00	0.63	38	техническая	2024-06-23 00:00:00
477	48	2	10	223.00	3.82	5.67	111	техническая	2024-07-12 00:00:00
478	48	3	5	151.00	7.83	9.43	96	промежуточная	2025-05-05 00:00:00
479	48	4	6	117.00	11.10	11.78	41	конечная	2024-12-31 00:00:00
480	49	1	1	0.00	0.00	0.52	31	техническая	2024-10-30 00:00:00
481	49	2	3	171.00	2.96	3.93	58	промежуточная	2025-06-02 00:00:00
482	49	3	21	272.00	7.82	9.64	109	промежуточная	2025-02-16 00:00:00
483	49	4	25	172.00	12.10	12.73	38	промежуточная	2024-09-09 00:00:00
484	49	5	20	74.00	13.79	15.76	118	техническая	2024-11-20 00:00:00
485	49	6	17	257.00	19.43	20.36	56	конечная	2025-07-16 00:00:00
486	50	1	22	0.00	0.00	1.62	97	промежуточная	2025-08-19 00:00:00
487	50	2	12	146.00	3.71	4.74	62	техническая	2025-04-10 00:00:00
488	50	3	8	273.00	8.64	9.61	58	промежуточная	2024-11-19 00:00:00
489	50	4	13	98.00	11.01	12.04	62	промежуточная	2025-12-20 00:00:00
490	50	5	2	142.00	14.07	14.47	24	промежуточная	2025-01-07 00:00:00
491	50	6	4	168.00	16.87	17.14	16	промежуточная	2025-05-20 00:00:00
492	50	7	9	180.00	19.71	21.34	98	конечная	2025-03-12 00:00:00
\.


--
-- Data for Name: платежи; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."платежи" ("ид_платеж", "номер_платежа", "ид_клиент", "ид_груз", "сумма_руб", "тип_платежа", "статус_платежа", "дата_создания", "дата_оплаты", "способ_оплаты", "примечание") FROM stdin;
1	P202500001	30	1	95110.08	полная_оплата	просрочен	2025-12-21 00:00:00	\N	наличные	Платеж #1
2	P202500002	38	2	145783.64	постоплата	оплачен	2025-09-21 00:00:00	2025-09-23 00:00:00	безналичный	Платеж #2
3	P202500003	31	3	58116.72	предоплата	оплачен	2025-11-17 00:00:00	2025-11-22 00:00:00	безналичный	Платеж #3
4	P202500004	2	4	148119.55	полная_оплата	оплачен	2025-09-12 00:00:00	2025-09-22 00:00:00	безналичный	Платеж #4
5	P202500005	7	5	64771.03	полная_оплата	оплачен	2025-12-24 00:00:00	2025-12-29 00:00:00	безналичный	Платеж #5
6	P202500006	33	6	86311.80	полная_оплата	оплачен	2025-09-17 00:00:00	2025-09-27 00:00:00	безналичный	Платеж #6
7	P202500007	2	7	40615.24	постоплата	оплачен	2025-10-09 00:00:00	2025-10-14 00:00:00	безналичный	Платеж #7
8	P202500008	11	8	143011.20	полная_оплата	оплачен	2025-10-05 00:00:00	2025-10-11 00:00:00	наличные	Платеж #8
9	P202500009	44	9	132999.56	предоплата	оплачен	2025-08-26 00:00:00	2025-08-28 00:00:00	карта	Платеж #9
10	P202500010	35	10	25585.86	полная_оплата	ожидает_оплаты	2025-08-09 00:00:00	\N	карта	Платеж #10
11	P202500011	30	11	76563.72	предоплата	просрочен	2025-11-15 00:00:00	\N	наличные	Платеж #11
12	P202500012	23	12	148068.51	предоплата	просрочен	2025-09-15 00:00:00	\N	карта	Платеж #12
13	P202500013	50	13	7701.36	предоплата	оплачен	2025-12-16 00:00:00	2025-12-23 00:00:00	наличные	Платеж #13
14	P202500014	20	14	95105.34	предоплата	оплачен	2025-07-28 00:00:00	2025-08-06 00:00:00	карта	Платеж #14
15	P202500015	39	15	22555.85	постоплата	просрочен	2026-01-09 00:00:00	\N	наличные	Платеж #15
16	P202500016	18	16	94666.76	постоплата	оплачен	2025-11-09 00:00:00	2025-11-13 00:00:00	наличные	Платеж #16
17	P202500017	10	17	49908.56	полная_оплата	оплачен	2025-09-22 00:00:00	2025-09-23 00:00:00	наличные	Платеж #17
18	P202500018	1	18	102559.22	постоплата	просрочен	2025-09-01 00:00:00	\N	наличные	Платеж #18
19	P202500019	47	19	11455.33	предоплата	оплачен	2025-10-06 00:00:00	2025-10-15 00:00:00	наличные	Платеж #19
20	P202500020	24	20	142265.72	постоплата	ожидает_оплаты	2025-12-06 00:00:00	\N	безналичный	Платеж #20
21	P202500021	26	21	93782.59	постоплата	просрочен	2026-01-05 00:00:00	\N	карта	Платеж #21
22	P202500022	13	22	85998.51	постоплата	оплачен	2025-10-31 00:00:00	2025-11-03 00:00:00	карта	Платеж #22
23	P202500023	35	23	132859.22	полная_оплата	просрочен	2025-10-07 00:00:00	\N	безналичный	Платеж #23
24	P202500024	9	24	56187.72	постоплата	оплачен	2025-09-24 00:00:00	2025-10-03 00:00:00	карта	Платеж #24
25	P202500025	13	25	112988.68	полная_оплата	ожидает_оплаты	2026-01-03 00:00:00	\N	безналичный	Платеж #25
26	P202500026	41	26	13961.79	предоплата	оплачен	2025-10-15 00:00:00	2025-10-18 00:00:00	наличные	Платеж #26
27	P202500027	18	27	76542.75	предоплата	оплачен	2025-12-03 00:00:00	2025-12-10 00:00:00	наличные	Платеж #27
28	P202500028	14	28	98469.89	постоплата	оплачен	2025-08-14 00:00:00	2025-08-19 00:00:00	безналичный	Платеж #28
29	P202500029	40	29	47355.79	постоплата	ожидает_оплаты	2025-12-31 00:00:00	\N	безналичный	Платеж #29
30	P202500030	21	30	8590.46	предоплата	оплачен	2025-11-12 00:00:00	2025-11-19 00:00:00	карта	Платеж #30
31	P202500031	15	31	38143.70	предоплата	оплачен	2025-11-14 00:00:00	2025-11-24 00:00:00	карта	Платеж #31
32	P202500032	4	32	7309.33	полная_оплата	оплачен	2025-12-11 00:00:00	2025-12-13 00:00:00	карта	Платеж #32
33	P202500033	49	33	131230.89	предоплата	ожидает_оплаты	2025-08-27 00:00:00	\N	карта	Платеж #33
34	P202500034	37	34	36719.38	полная_оплата	оплачен	2025-09-14 00:00:00	2025-09-15 00:00:00	безналичный	Платеж #34
35	P202500035	34	35	37572.17	постоплата	ожидает_оплаты	2025-10-05 00:00:00	\N	карта	Платеж #35
36	P202500036	32	36	99263.48	полная_оплата	ожидает_оплаты	2025-09-17 00:00:00	\N	безналичный	Платеж #36
37	P202500037	2	37	78806.98	постоплата	ожидает_оплаты	2025-10-22 00:00:00	\N	наличные	Платеж #37
38	P202500038	34	38	81281.89	предоплата	оплачен	2026-01-06 00:00:00	2026-01-09 00:00:00	наличные	Платеж #38
39	P202500039	22	39	99522.24	полная_оплата	оплачен	2025-09-10 00:00:00	2025-09-18 00:00:00	безналичный	Платеж #39
40	P202500040	41	40	78041.34	предоплата	оплачен	2026-01-20 00:00:00	2026-01-30 00:00:00	карта	Платеж #40
41	P202500041	36	41	56542.72	полная_оплата	просрочен	2026-01-14 00:00:00	\N	безналичный	Платеж #41
42	P202500042	1	42	13258.92	полная_оплата	оплачен	2026-01-14 00:00:00	2026-01-15 00:00:00	карта	Платеж #42
43	P202500043	7	43	104638.25	предоплата	просрочен	2025-08-25 00:00:00	\N	безналичный	Платеж #43
44	P202500044	13	44	67890.38	полная_оплата	ожидает_оплаты	2025-09-16 00:00:00	\N	наличные	Платеж #44
45	P202500045	24	45	128114.26	предоплата	ожидает_оплаты	2025-10-19 00:00:00	\N	безналичный	Платеж #45
46	P202500046	37	46	44085.76	предоплата	просрочен	2025-08-02 00:00:00	\N	безналичный	Платеж #46
47	P202500047	6	47	8090.45	предоплата	оплачен	2025-11-24 00:00:00	2025-11-24 00:00:00	карта	Платеж #47
48	P202500048	38	48	5909.06	полная_оплата	ожидает_оплаты	2025-12-05 00:00:00	\N	безналичный	Платеж #48
49	P202500049	14	49	126329.99	постоплата	просрочен	2025-08-12 00:00:00	\N	карта	Платеж #49
50	P202500050	47	50	65718.92	полная_оплата	оплачен	2025-12-07 00:00:00	2025-12-09 00:00:00	карта	Платеж #50
51	P202500051	29	51	144229.41	предоплата	просрочен	2025-08-30 00:00:00	\N	безналичный	Платеж #51
52	P202500052	36	52	41378.55	постоплата	просрочен	2026-01-14 00:00:00	\N	безналичный	Платеж #52
53	P202500053	40	53	57435.45	предоплата	ожидает_оплаты	2025-10-08 00:00:00	\N	наличные	Платеж #53
54	P202500054	13	54	76706.73	предоплата	оплачен	2025-09-13 00:00:00	2025-09-16 00:00:00	безналичный	Платеж #54
55	P202500055	19	55	20334.99	полная_оплата	оплачен	2025-07-28 00:00:00	2025-08-04 00:00:00	карта	Платеж #55
56	P202500056	18	56	64615.92	постоплата	оплачен	2025-12-15 00:00:00	2025-12-20 00:00:00	наличные	Платеж #56
57	P202500057	39	57	10248.56	предоплата	ожидает_оплаты	2026-01-02 00:00:00	\N	наличные	Платеж #57
58	P202500058	5	58	149403.37	постоплата	просрочен	2025-10-17 00:00:00	\N	безналичный	Платеж #58
59	P202500059	50	59	113396.75	предоплата	ожидает_оплаты	2025-09-24 00:00:00	\N	карта	Платеж #59
60	P202500060	25	60	140680.28	полная_оплата	оплачен	2025-10-09 00:00:00	2025-10-14 00:00:00	наличные	Платеж #60
61	P202500061	44	61	146701.47	полная_оплата	просрочен	2025-11-01 00:00:00	\N	карта	Платеж #61
62	P202500062	27	62	82033.38	постоплата	оплачен	2025-11-17 00:00:00	2025-11-23 00:00:00	безналичный	Платеж #62
63	P202500063	47	63	117023.45	полная_оплата	оплачен	2025-11-13 00:00:00	2025-11-15 00:00:00	наличные	Платеж #63
64	P202500064	45	64	58420.08	предоплата	оплачен	2025-08-15 00:00:00	2025-08-23 00:00:00	безналичный	Платеж #64
65	P202500065	14	65	38386.82	полная_оплата	оплачен	2025-08-19 00:00:00	2025-08-21 00:00:00	наличные	Платеж #65
66	P202500066	42	66	46344.67	полная_оплата	оплачен	2025-12-07 00:00:00	2025-12-16 00:00:00	карта	Платеж #66
67	P202500067	37	67	19498.70	постоплата	ожидает_оплаты	2025-11-28 00:00:00	\N	безналичный	Платеж #67
68	P202500068	13	68	122921.65	предоплата	оплачен	2026-01-07 00:00:00	2026-01-10 00:00:00	карта	Платеж #68
69	P202500069	37	69	20108.32	полная_оплата	оплачен	2025-10-17 00:00:00	2025-10-19 00:00:00	безналичный	Платеж #69
70	P202500070	47	70	81751.87	предоплата	просрочен	2025-12-26 00:00:00	\N	карта	Платеж #70
71	P202500071	35	71	36847.79	постоплата	ожидает_оплаты	2025-12-12 00:00:00	\N	безналичный	Платеж #71
72	P202500072	27	72	20804.12	постоплата	ожидает_оплаты	2025-12-31 00:00:00	\N	карта	Платеж #72
73	P202500073	6	73	104380.81	постоплата	оплачен	2025-09-05 00:00:00	2025-09-08 00:00:00	безналичный	Платеж #73
74	P202500074	13	74	110937.72	предоплата	оплачен	2025-09-26 00:00:00	2025-10-03 00:00:00	безналичный	Платеж #74
75	P202500075	49	75	88436.40	полная_оплата	просрочен	2025-07-26 00:00:00	\N	наличные	Платеж #75
76	P202500076	5	76	98862.73	предоплата	оплачен	2025-11-10 00:00:00	2025-11-18 00:00:00	наличные	Платеж #76
77	P202500077	35	77	42996.17	полная_оплата	оплачен	2025-10-09 00:00:00	2025-10-16 00:00:00	наличные	Платеж #77
78	P202500078	42	78	58218.43	предоплата	оплачен	2025-08-26 00:00:00	2025-09-02 00:00:00	наличные	Платеж #78
79	P202500079	5	79	21994.80	полная_оплата	просрочен	2025-08-30 00:00:00	\N	безналичный	Платеж #79
80	P202500080	40	80	103621.93	постоплата	оплачен	2025-09-01 00:00:00	2025-09-03 00:00:00	наличные	Платеж #80
81	P202500081	42	81	95988.35	постоплата	ожидает_оплаты	2025-08-08 00:00:00	\N	наличные	Платеж #81
82	P202500082	35	82	129402.13	постоплата	оплачен	2025-08-13 00:00:00	2025-08-20 00:00:00	наличные	Платеж #82
83	P202500083	11	83	145813.83	полная_оплата	оплачен	2025-08-16 00:00:00	2025-08-23 00:00:00	безналичный	Платеж #83
84	P202500084	24	84	123217.14	постоплата	ожидает_оплаты	2025-12-04 00:00:00	\N	карта	Платеж #84
85	P202500085	5	85	30899.15	полная_оплата	просрочен	2025-08-13 00:00:00	\N	карта	Платеж #85
86	P202500086	39	86	69161.22	предоплата	оплачен	2025-11-23 00:00:00	2025-11-28 00:00:00	карта	Платеж #86
87	P202500087	36	87	124649.50	предоплата	просрочен	2025-08-27 00:00:00	\N	безналичный	Платеж #87
88	P202500088	18	88	145869.73	предоплата	ожидает_оплаты	2025-10-21 00:00:00	\N	наличные	Платеж #88
89	P202500089	7	89	20456.07	предоплата	просрочен	2025-08-20 00:00:00	\N	наличные	Платеж #89
90	P202500090	14	90	70310.66	постоплата	оплачен	2025-08-08 00:00:00	2025-08-13 00:00:00	безналичный	Платеж #90
91	P202500091	17	91	94920.91	предоплата	просрочен	2025-08-21 00:00:00	\N	карта	Платеж #91
92	P202500092	4	92	66203.80	полная_оплата	оплачен	2025-07-25 00:00:00	2025-08-03 00:00:00	наличные	Платеж #92
93	P202500093	3	93	60777.51	постоплата	ожидает_оплаты	2025-08-21 00:00:00	\N	карта	Платеж #93
94	P202500094	2	94	99460.39	полная_оплата	оплачен	2025-11-18 00:00:00	2025-11-23 00:00:00	безналичный	Платеж #94
95	P202500095	2	95	99187.48	постоплата	просрочен	2025-11-01 00:00:00	\N	наличные	Платеж #95
96	P202500096	6	96	18506.77	постоплата	просрочен	2025-08-27 00:00:00	\N	карта	Платеж #96
97	P202500097	10	97	47710.59	полная_оплата	оплачен	2025-10-20 00:00:00	2025-10-24 00:00:00	безналичный	Платеж #97
98	P202500098	21	98	10601.96	полная_оплата	оплачен	2025-12-13 00:00:00	2025-12-18 00:00:00	наличные	Платеж #98
99	P202500099	6	99	127281.48	полная_оплата	ожидает_оплаты	2025-11-30 00:00:00	\N	наличные	Платеж #99
100	P202500100	47	100	139298.78	полная_оплата	ожидает_оплаты	2025-08-14 00:00:00	\N	наличные	Платеж #100
101	P202500101	15	101	5082.45	постоплата	оплачен	2026-01-10 00:00:00	2026-01-15 00:00:00	наличные	Платеж #101
102	P202500102	22	102	27664.14	постоплата	оплачен	2025-08-05 00:00:00	2025-08-10 00:00:00	наличные	Платеж #102
103	P202500103	5	103	22439.67	постоплата	просрочен	2025-10-07 00:00:00	\N	безналичный	Платеж #103
104	P202500104	18	104	74066.07	полная_оплата	оплачен	2025-08-12 00:00:00	2025-08-15 00:00:00	безналичный	Платеж #104
105	P202500105	48	105	25155.20	предоплата	просрочен	2025-11-07 00:00:00	\N	карта	Платеж #105
106	P202500106	37	106	72838.54	постоплата	ожидает_оплаты	2025-11-16 00:00:00	\N	карта	Платеж #106
107	P202500107	22	107	72444.98	постоплата	просрочен	2025-12-08 00:00:00	\N	карта	Платеж #107
108	P202500108	16	108	41599.93	постоплата	ожидает_оплаты	2025-08-15 00:00:00	\N	безналичный	Платеж #108
109	P202500109	38	109	111562.55	полная_оплата	оплачен	2025-09-03 00:00:00	2025-09-10 00:00:00	карта	Платеж #109
110	P202500110	46	110	60155.99	полная_оплата	ожидает_оплаты	2025-09-20 00:00:00	\N	безналичный	Платеж #110
111	P202500111	44	111	16527.48	полная_оплата	оплачен	2025-09-29 00:00:00	2025-09-29 00:00:00	безналичный	Платеж #111
112	P202500112	33	112	82538.21	постоплата	оплачен	2025-11-15 00:00:00	2025-11-23 00:00:00	карта	Платеж #112
113	P202500113	33	113	8044.09	предоплата	оплачен	2025-10-16 00:00:00	2025-10-24 00:00:00	карта	Платеж #113
114	P202500114	45	114	13928.83	полная_оплата	оплачен	2025-07-25 00:00:00	2025-07-26 00:00:00	наличные	Платеж #114
115	P202500115	43	115	84472.05	предоплата	оплачен	2025-08-19 00:00:00	2025-08-23 00:00:00	наличные	Платеж #115
116	P202500116	37	116	71627.06	предоплата	оплачен	2026-01-08 00:00:00	2026-01-10 00:00:00	безналичный	Платеж #116
117	P202500117	23	117	44407.88	постоплата	ожидает_оплаты	2025-11-19 00:00:00	\N	карта	Платеж #117
118	P202500118	21	118	102712.50	постоплата	оплачен	2025-07-31 00:00:00	2025-08-06 00:00:00	наличные	Платеж #118
119	P202500119	15	119	144320.07	полная_оплата	ожидает_оплаты	2025-08-20 00:00:00	\N	карта	Платеж #119
120	P202500120	9	120	59120.77	постоплата	оплачен	2025-11-24 00:00:00	2025-11-28 00:00:00	карта	Платеж #120
121	P202500121	49	121	16201.27	полная_оплата	оплачен	2025-10-09 00:00:00	2025-10-16 00:00:00	безналичный	Платеж #121
122	P202500122	23	122	117381.86	полная_оплата	просрочен	2025-08-10 00:00:00	\N	безналичный	Платеж #122
123	P202500123	39	123	45979.16	предоплата	ожидает_оплаты	2025-09-26 00:00:00	\N	наличные	Платеж #123
124	P202500124	29	124	94267.96	полная_оплата	оплачен	2025-12-12 00:00:00	2025-12-14 00:00:00	карта	Платеж #124
125	P202500125	32	125	92923.45	полная_оплата	оплачен	2025-12-11 00:00:00	2025-12-18 00:00:00	безналичный	Платеж #125
126	P202500126	44	126	30965.81	предоплата	просрочен	2025-11-08 00:00:00	\N	карта	Платеж #126
127	P202500127	10	127	107914.02	предоплата	ожидает_оплаты	2025-10-01 00:00:00	\N	безналичный	Платеж #127
128	P202500128	21	128	43889.55	предоплата	ожидает_оплаты	2025-10-19 00:00:00	\N	карта	Платеж #128
129	P202500129	3	129	19009.97	постоплата	просрочен	2025-10-25 00:00:00	\N	наличные	Платеж #129
130	P202500130	6	130	144024.39	предоплата	просрочен	2025-09-13 00:00:00	\N	карта	Платеж #130
131	P202500131	7	131	143925.73	полная_оплата	оплачен	2026-01-14 00:00:00	2026-01-20 00:00:00	карта	Платеж #131
132	P202500132	29	132	116051.31	постоплата	ожидает_оплаты	2025-12-01 00:00:00	\N	карта	Платеж #132
133	P202500133	20	133	58280.69	постоплата	оплачен	2025-10-24 00:00:00	2025-11-03 00:00:00	карта	Платеж #133
134	P202500134	47	134	85107.11	полная_оплата	ожидает_оплаты	2025-10-10 00:00:00	\N	безналичный	Платеж #134
135	P202500135	42	135	53662.05	предоплата	ожидает_оплаты	2025-10-11 00:00:00	\N	безналичный	Платеж #135
136	P202500136	28	136	105049.14	полная_оплата	оплачен	2025-09-30 00:00:00	2025-10-10 00:00:00	карта	Платеж #136
137	P202500137	35	137	134066.75	полная_оплата	оплачен	2025-08-18 00:00:00	2025-08-21 00:00:00	безналичный	Платеж #137
138	P202500138	16	138	139052.86	постоплата	оплачен	2025-08-19 00:00:00	2025-08-23 00:00:00	безналичный	Платеж #138
139	P202500139	44	139	121955.17	полная_оплата	просрочен	2025-08-04 00:00:00	\N	безналичный	Платеж #139
140	P202500140	26	140	18525.01	постоплата	просрочен	2025-11-19 00:00:00	\N	карта	Платеж #140
141	P202500141	50	141	125735.08	полная_оплата	ожидает_оплаты	2025-10-25 00:00:00	\N	карта	Платеж #141
142	P202500142	20	142	120799.34	предоплата	просрочен	2025-10-14 00:00:00	\N	карта	Платеж #142
143	P202500143	43	143	19826.73	полная_оплата	оплачен	2025-11-24 00:00:00	2025-11-25 00:00:00	безналичный	Платеж #143
144	P202500144	32	144	11825.10	полная_оплата	оплачен	2025-11-16 00:00:00	2025-11-20 00:00:00	карта	Платеж #144
145	P202500145	47	145	131582.83	предоплата	оплачен	2025-10-29 00:00:00	2025-10-30 00:00:00	карта	Платеж #145
146	P202500146	50	146	24143.26	полная_оплата	ожидает_оплаты	2025-12-21 00:00:00	\N	наличные	Платеж #146
147	P202500147	41	147	19752.40	постоплата	ожидает_оплаты	2025-10-25 00:00:00	\N	карта	Платеж #147
148	P202500148	23	148	100651.06	постоплата	оплачен	2025-12-25 00:00:00	2025-12-26 00:00:00	наличные	Платеж #148
149	P202500149	32	149	140544.58	предоплата	оплачен	2025-09-06 00:00:00	2025-09-15 00:00:00	безналичный	Платеж #149
150	P202500150	27	150	32413.91	постоплата	просрочен	2025-12-05 00:00:00	\N	наличные	Платеж #150
151	P202500151	35	151	115288.93	полная_оплата	оплачен	2025-12-30 00:00:00	2025-12-30 00:00:00	наличные	Платеж #151
152	P202500152	9	152	88016.79	полная_оплата	ожидает_оплаты	2025-10-01 00:00:00	\N	карта	Платеж #152
153	P202500153	49	153	136475.30	постоплата	просрочен	2026-01-15 00:00:00	\N	наличные	Платеж #153
154	P202500154	47	154	13085.00	полная_оплата	ожидает_оплаты	2025-11-02 00:00:00	\N	наличные	Платеж #154
155	P202500155	29	155	77699.39	полная_оплата	просрочен	2025-07-25 00:00:00	\N	наличные	Платеж #155
156	P202500156	17	156	33264.79	полная_оплата	ожидает_оплаты	2025-12-07 00:00:00	\N	наличные	Платеж #156
157	P202500157	11	157	108596.30	постоплата	оплачен	2025-08-10 00:00:00	2025-08-19 00:00:00	карта	Платеж #157
158	P202500158	33	158	99441.84	постоплата	оплачен	2025-08-07 00:00:00	2025-08-11 00:00:00	безналичный	Платеж #158
159	P202500159	46	159	128326.28	постоплата	ожидает_оплаты	2025-09-29 00:00:00	\N	карта	Платеж #159
160	P202500160	47	160	117686.63	постоплата	ожидает_оплаты	2025-12-09 00:00:00	\N	карта	Платеж #160
161	P202500161	31	161	83994.77	постоплата	просрочен	2025-08-23 00:00:00	\N	наличные	Платеж #161
162	P202500162	38	162	106827.20	полная_оплата	просрочен	2025-08-04 00:00:00	\N	наличные	Платеж #162
163	P202500163	50	163	73864.18	постоплата	оплачен	2025-11-08 00:00:00	2025-11-10 00:00:00	карта	Платеж #163
164	P202500164	5	164	42099.35	предоплата	просрочен	2025-09-07 00:00:00	\N	наличные	Платеж #164
165	P202500165	17	165	87992.55	полная_оплата	оплачен	2025-12-01 00:00:00	2025-12-03 00:00:00	наличные	Платеж #165
166	P202500166	4	166	62574.44	предоплата	ожидает_оплаты	2025-11-10 00:00:00	\N	наличные	Платеж #166
167	P202500167	41	167	108922.22	предоплата	оплачен	2025-11-20 00:00:00	2025-11-26 00:00:00	наличные	Платеж #167
168	P202500168	1	168	142768.30	полная_оплата	оплачен	2025-10-22 00:00:00	2025-10-24 00:00:00	безналичный	Платеж #168
169	P202500169	44	169	83924.30	полная_оплата	оплачен	2025-07-28 00:00:00	2025-07-29 00:00:00	наличные	Платеж #169
170	P202500170	17	170	67927.26	предоплата	ожидает_оплаты	2025-12-27 00:00:00	\N	карта	Платеж #170
171	P202500171	43	171	6202.09	постоплата	оплачен	2026-01-01 00:00:00	2026-01-05 00:00:00	наличные	Платеж #171
172	P202500172	25	172	106546.59	постоплата	оплачен	2025-12-18 00:00:00	2025-12-25 00:00:00	безналичный	Платеж #172
173	P202500173	1	173	8791.19	предоплата	ожидает_оплаты	2025-12-30 00:00:00	\N	карта	Платеж #173
174	P202500174	8	174	73456.79	полная_оплата	просрочен	2025-11-06 00:00:00	\N	безналичный	Платеж #174
175	P202500175	44	175	105878.76	постоплата	оплачен	2025-10-08 00:00:00	2025-10-18 00:00:00	наличные	Платеж #175
176	P202500176	36	176	26395.46	полная_оплата	оплачен	2025-09-18 00:00:00	2025-09-27 00:00:00	безналичный	Платеж #176
177	P202500177	42	177	104798.88	постоплата	ожидает_оплаты	2025-12-13 00:00:00	\N	наличные	Платеж #177
178	P202500178	50	178	77717.19	предоплата	просрочен	2025-11-10 00:00:00	\N	безналичный	Платеж #178
179	P202500179	43	179	91837.49	постоплата	оплачен	2025-08-20 00:00:00	2025-08-25 00:00:00	безналичный	Платеж #179
180	P202500180	49	180	15898.31	предоплата	оплачен	2025-11-11 00:00:00	2025-11-20 00:00:00	наличные	Платеж #180
181	P202500181	48	181	108441.18	предоплата	оплачен	2025-12-23 00:00:00	2025-12-24 00:00:00	безналичный	Платеж #181
182	P202500182	34	182	48714.79	полная_оплата	оплачен	2025-11-19 00:00:00	2025-11-27 00:00:00	карта	Платеж #182
183	P202500183	49	183	19661.77	предоплата	ожидает_оплаты	2025-09-24 00:00:00	\N	наличные	Платеж #183
184	P202500184	1	184	138793.46	постоплата	оплачен	2025-08-08 00:00:00	2025-08-16 00:00:00	карта	Платеж #184
185	P202500185	6	185	84596.60	предоплата	оплачен	2025-08-08 00:00:00	2025-08-16 00:00:00	безналичный	Платеж #185
186	P202500186	19	186	92290.66	постоплата	ожидает_оплаты	2025-12-21 00:00:00	\N	безналичный	Платеж #186
187	P202500187	23	187	52426.00	постоплата	оплачен	2025-09-03 00:00:00	2025-09-13 00:00:00	карта	Платеж #187
188	P202500188	37	188	82546.90	постоплата	просрочен	2025-10-19 00:00:00	\N	наличные	Платеж #188
189	P202500189	4	189	114125.13	постоплата	оплачен	2025-10-11 00:00:00	2025-10-18 00:00:00	карта	Платеж #189
190	P202500190	47	190	27313.56	постоплата	просрочен	2026-01-04 00:00:00	\N	безналичный	Платеж #190
191	P202500191	11	191	55907.60	полная_оплата	ожидает_оплаты	2025-07-28 00:00:00	\N	безналичный	Платеж #191
192	P202500192	16	192	73336.38	полная_оплата	просрочен	2025-11-07 00:00:00	\N	наличные	Платеж #192
193	P202500193	13	193	8918.14	полная_оплата	ожидает_оплаты	2025-10-22 00:00:00	\N	наличные	Платеж #193
194	P202500194	46	194	20224.54	предоплата	просрочен	2025-12-19 00:00:00	\N	безналичный	Платеж #194
195	P202500195	5	195	24366.69	полная_оплата	просрочен	2025-11-18 00:00:00	\N	наличные	Платеж #195
196	P202500196	48	196	64992.10	предоплата	оплачен	2025-10-01 00:00:00	2025-10-08 00:00:00	наличные	Платеж #196
197	P202500197	26	197	131618.60	предоплата	оплачен	2025-11-08 00:00:00	2025-11-09 00:00:00	наличные	Платеж #197
198	P202500198	21	198	87667.91	постоплата	просрочен	2025-08-08 00:00:00	\N	наличные	Платеж #198
199	P202500199	36	199	42535.90	полная_оплата	ожидает_оплаты	2025-12-23 00:00:00	\N	наличные	Платеж #199
200	P202500200	27	200	106221.04	предоплата	оплачен	2026-01-19 00:00:00	2026-01-28 00:00:00	наличные	Платеж #200
201	P202500201	20	201	34919.40	постоплата	просрочен	2026-01-03 00:00:00	\N	карта	Платеж #201
202	P202500202	9	202	6214.24	предоплата	просрочен	2025-10-16 00:00:00	\N	наличные	Платеж #202
203	P202500203	47	203	100242.16	полная_оплата	ожидает_оплаты	2025-12-31 00:00:00	\N	карта	Платеж #203
204	P202500204	50	204	38475.68	постоплата	оплачен	2026-01-08 00:00:00	2026-01-18 00:00:00	безналичный	Платеж #204
205	P202500205	39	205	21455.54	предоплата	ожидает_оплаты	2025-11-04 00:00:00	\N	наличные	Платеж #205
206	P202500206	4	206	35564.95	постоплата	оплачен	2026-01-19 00:00:00	2026-01-23 00:00:00	безналичный	Платеж #206
207	P202500207	39	207	28247.21	предоплата	ожидает_оплаты	2025-11-01 00:00:00	\N	карта	Платеж #207
208	P202500208	34	208	19340.51	предоплата	просрочен	2026-01-09 00:00:00	\N	карта	Платеж #208
209	P202500209	44	209	95996.89	полная_оплата	ожидает_оплаты	2025-12-19 00:00:00	\N	карта	Платеж #209
210	P202500210	43	210	58225.46	полная_оплата	оплачен	2025-08-16 00:00:00	2025-08-25 00:00:00	карта	Платеж #210
211	P202500211	30	211	47640.91	полная_оплата	ожидает_оплаты	2025-11-24 00:00:00	\N	безналичный	Платеж #211
212	P202500212	38	212	149066.45	предоплата	ожидает_оплаты	2025-08-06 00:00:00	\N	карта	Платеж #212
213	P202500213	25	213	87908.80	полная_оплата	оплачен	2025-10-30 00:00:00	2025-11-06 00:00:00	безналичный	Платеж #213
214	P202500214	15	214	103482.04	постоплата	оплачен	2026-01-02 00:00:00	2026-01-10 00:00:00	карта	Платеж #214
215	P202500215	22	215	140975.26	постоплата	просрочен	2025-07-29 00:00:00	\N	наличные	Платеж #215
216	P202500216	17	216	113269.92	предоплата	оплачен	2025-11-13 00:00:00	2025-11-14 00:00:00	безналичный	Платеж #216
217	P202500217	15	217	78733.29	предоплата	оплачен	2026-01-19 00:00:00	2026-01-21 00:00:00	карта	Платеж #217
218	P202500218	28	218	10813.54	предоплата	ожидает_оплаты	2025-11-01 00:00:00	\N	наличные	Платеж #218
219	P202500219	48	219	39194.70	предоплата	просрочен	2025-12-02 00:00:00	\N	безналичный	Платеж #219
220	P202500220	9	220	19020.85	постоплата	просрочен	2025-11-15 00:00:00	\N	карта	Платеж #220
221	P202500221	41	221	59186.89	постоплата	ожидает_оплаты	2025-12-29 00:00:00	\N	карта	Платеж #221
222	P202500222	14	222	123797.14	полная_оплата	оплачен	2025-07-25 00:00:00	2025-07-31 00:00:00	наличные	Платеж #222
223	P202500223	18	223	8870.31	полная_оплата	просрочен	2025-09-19 00:00:00	\N	безналичный	Платеж #223
224	P202500224	38	224	40359.78	предоплата	оплачен	2025-09-30 00:00:00	2025-10-10 00:00:00	безналичный	Платеж #224
225	P202500225	12	225	122241.68	постоплата	ожидает_оплаты	2025-11-03 00:00:00	\N	наличные	Платеж #225
226	P202500226	10	226	32235.88	предоплата	ожидает_оплаты	2025-09-10 00:00:00	\N	карта	Платеж #226
227	P202500227	36	227	49706.36	полная_оплата	оплачен	2025-11-09 00:00:00	2025-11-18 00:00:00	безналичный	Платеж #227
228	P202500228	45	228	99218.76	полная_оплата	оплачен	2025-08-26 00:00:00	2025-08-26 00:00:00	карта	Платеж #228
229	P202500229	43	229	128193.97	предоплата	ожидает_оплаты	2025-12-17 00:00:00	\N	наличные	Платеж #229
230	P202500230	8	230	73534.77	полная_оплата	оплачен	2025-09-08 00:00:00	2025-09-15 00:00:00	карта	Платеж #230
231	P202500231	13	231	24125.38	предоплата	оплачен	2025-09-16 00:00:00	2025-09-20 00:00:00	наличные	Платеж #231
232	P202500232	16	232	145035.91	предоплата	оплачен	2025-12-25 00:00:00	2026-01-03 00:00:00	безналичный	Платеж #232
233	P202500233	46	233	35037.39	полная_оплата	просрочен	2025-11-27 00:00:00	\N	наличные	Платеж #233
234	P202500234	36	234	45286.74	предоплата	оплачен	2025-12-30 00:00:00	2025-12-31 00:00:00	наличные	Платеж #234
235	P202500235	29	235	51076.76	постоплата	ожидает_оплаты	2025-08-21 00:00:00	\N	безналичный	Платеж #235
236	P202500236	13	236	60359.35	постоплата	ожидает_оплаты	2025-10-20 00:00:00	\N	наличные	Платеж #236
237	P202500237	27	237	54302.02	полная_оплата	оплачен	2025-12-09 00:00:00	2025-12-19 00:00:00	безналичный	Платеж #237
238	P202500238	22	238	127284.80	полная_оплата	просрочен	2025-12-07 00:00:00	\N	безналичный	Платеж #238
239	P202500239	25	239	126607.78	предоплата	оплачен	2025-11-10 00:00:00	2025-11-13 00:00:00	безналичный	Платеж #239
240	P202500240	45	240	49324.66	постоплата	оплачен	2025-12-10 00:00:00	2025-12-13 00:00:00	карта	Платеж #240
241	P202500241	29	241	20218.36	предоплата	оплачен	2025-10-19 00:00:00	2025-10-22 00:00:00	наличные	Платеж #241
242	P202500242	11	242	122024.50	полная_оплата	просрочен	2026-01-18 00:00:00	\N	карта	Платеж #242
243	P202500243	21	243	36643.05	предоплата	просрочен	2025-09-16 00:00:00	\N	безналичный	Платеж #243
244	P202500244	24	244	112417.72	предоплата	оплачен	2025-10-24 00:00:00	2025-10-26 00:00:00	карта	Платеж #244
245	P202500245	50	245	43314.28	полная_оплата	оплачен	2025-10-06 00:00:00	2025-10-13 00:00:00	наличные	Платеж #245
246	P202500246	25	246	39499.27	полная_оплата	просрочен	2026-01-06 00:00:00	\N	безналичный	Платеж #246
247	P202500247	38	247	61425.42	полная_оплата	просрочен	2025-09-02 00:00:00	\N	безналичный	Платеж #247
248	P202500248	26	248	42573.77	постоплата	оплачен	2025-09-05 00:00:00	2025-09-11 00:00:00	карта	Платеж #248
249	P202500249	9	249	59076.50	полная_оплата	оплачен	2025-10-13 00:00:00	2025-10-15 00:00:00	карта	Платеж #249
250	P202500250	5	250	121108.86	постоплата	ожидает_оплаты	2025-08-28 00:00:00	\N	карта	Платеж #250
251	P202500251	36	251	79357.38	постоплата	просрочен	2025-09-21 00:00:00	\N	карта	Платеж #251
252	P202500252	12	252	105839.27	полная_оплата	оплачен	2025-09-20 00:00:00	2025-09-24 00:00:00	безналичный	Платеж #252
253	P202500253	21	253	75283.31	предоплата	ожидает_оплаты	2026-01-11 00:00:00	\N	безналичный	Платеж #253
254	P202500254	40	254	90514.14	постоплата	оплачен	2025-09-10 00:00:00	2025-09-11 00:00:00	наличные	Платеж #254
255	P202500255	39	255	110296.96	предоплата	оплачен	2025-09-30 00:00:00	2025-09-30 00:00:00	безналичный	Платеж #255
256	P202500256	23	256	14670.20	предоплата	ожидает_оплаты	2025-10-09 00:00:00	\N	карта	Платеж #256
257	P202500257	31	257	112350.62	предоплата	оплачен	2025-10-26 00:00:00	2025-10-31 00:00:00	безналичный	Платеж #257
258	P202500258	29	258	93609.50	постоплата	оплачен	2026-01-17 00:00:00	2026-01-24 00:00:00	наличные	Платеж #258
259	P202500259	17	259	116129.69	полная_оплата	оплачен	2025-08-16 00:00:00	2025-08-23 00:00:00	наличные	Платеж #259
260	P202500260	26	260	5345.79	постоплата	оплачен	2025-09-10 00:00:00	2025-09-11 00:00:00	безналичный	Платеж #260
261	P202500261	47	261	95649.53	постоплата	ожидает_оплаты	2025-11-11 00:00:00	\N	безналичный	Платеж #261
262	P202500262	28	262	29361.21	предоплата	просрочен	2025-09-24 00:00:00	\N	безналичный	Платеж #262
263	P202500263	28	263	56357.74	полная_оплата	оплачен	2025-12-01 00:00:00	2025-12-08 00:00:00	карта	Платеж #263
264	P202500264	12	264	34655.75	постоплата	оплачен	2025-08-02 00:00:00	2025-08-08 00:00:00	карта	Платеж #264
265	P202500265	7	265	110617.61	постоплата	просрочен	2025-11-23 00:00:00	\N	наличные	Платеж #265
266	P202500266	5	266	6218.78	предоплата	оплачен	2025-08-29 00:00:00	2025-09-01 00:00:00	безналичный	Платеж #266
267	P202500267	34	267	139108.85	предоплата	оплачен	2025-12-05 00:00:00	2025-12-08 00:00:00	безналичный	Платеж #267
268	P202500268	14	268	22648.42	постоплата	просрочен	2025-08-31 00:00:00	\N	наличные	Платеж #268
269	P202500269	32	269	107030.31	полная_оплата	просрочен	2025-11-22 00:00:00	\N	карта	Платеж #269
270	P202500270	50	270	47315.94	предоплата	просрочен	2025-11-26 00:00:00	\N	карта	Платеж #270
271	P202500271	44	271	98589.44	полная_оплата	оплачен	2026-01-05 00:00:00	2026-01-14 00:00:00	безналичный	Платеж #271
272	P202500272	40	272	143048.24	полная_оплата	ожидает_оплаты	2026-01-08 00:00:00	\N	безналичный	Платеж #272
273	P202500273	46	273	73696.28	предоплата	оплачен	2026-01-08 00:00:00	2026-01-18 00:00:00	карта	Платеж #273
274	P202500274	34	274	72665.62	предоплата	оплачен	2025-11-28 00:00:00	2025-12-07 00:00:00	безналичный	Платеж #274
275	P202500275	36	275	49681.55	предоплата	оплачен	2025-12-02 00:00:00	2025-12-04 00:00:00	безналичный	Платеж #275
276	P202500276	10	276	49164.81	предоплата	оплачен	2025-10-06 00:00:00	2025-10-08 00:00:00	безналичный	Платеж #276
277	P202500277	13	277	5195.39	предоплата	просрочен	2025-07-30 00:00:00	\N	карта	Платеж #277
278	P202500278	33	278	83306.59	предоплата	просрочен	2025-12-18 00:00:00	\N	наличные	Платеж #278
279	P202500279	44	279	73897.38	предоплата	оплачен	2025-12-08 00:00:00	2025-12-09 00:00:00	безналичный	Платеж #279
280	P202500280	10	280	97543.62	предоплата	оплачен	2025-07-25 00:00:00	2025-07-29 00:00:00	наличные	Платеж #280
281	P202500281	46	281	73777.59	полная_оплата	ожидает_оплаты	2025-11-12 00:00:00	\N	безналичный	Платеж #281
282	P202500282	28	282	25696.58	полная_оплата	ожидает_оплаты	2026-01-05 00:00:00	\N	наличные	Платеж #282
283	P202500283	49	283	103728.73	полная_оплата	ожидает_оплаты	2025-10-13 00:00:00	\N	наличные	Платеж #283
284	P202500284	47	284	124946.46	предоплата	оплачен	2025-09-08 00:00:00	2025-09-14 00:00:00	наличные	Платеж #284
285	P202500285	27	285	14132.66	постоплата	ожидает_оплаты	2025-10-07 00:00:00	\N	карта	Платеж #285
286	P202500286	47	286	87814.93	постоплата	ожидает_оплаты	2025-12-24 00:00:00	\N	наличные	Платеж #286
287	P202500287	46	287	28091.31	постоплата	оплачен	2025-10-15 00:00:00	2025-10-21 00:00:00	карта	Платеж #287
288	P202500288	25	288	140539.95	постоплата	оплачен	2025-12-20 00:00:00	2025-12-27 00:00:00	безналичный	Платеж #288
289	P202500289	16	289	145190.28	предоплата	просрочен	2025-10-25 00:00:00	\N	карта	Платеж #289
290	P202500290	15	290	16728.79	предоплата	оплачен	2025-08-29 00:00:00	2025-09-04 00:00:00	наличные	Платеж #290
291	P202500291	24	291	42377.40	постоплата	просрочен	2025-09-28 00:00:00	\N	безналичный	Платеж #291
292	P202500292	38	292	97816.50	полная_оплата	оплачен	2025-11-10 00:00:00	2025-11-11 00:00:00	безналичный	Платеж #292
293	P202500293	21	293	139321.32	постоплата	оплачен	2025-10-27 00:00:00	2025-11-05 00:00:00	безналичный	Платеж #293
294	P202500294	12	294	127103.95	полная_оплата	ожидает_оплаты	2025-10-23 00:00:00	\N	наличные	Платеж #294
295	P202500295	16	295	110323.73	постоплата	оплачен	2025-09-03 00:00:00	2025-09-03 00:00:00	безналичный	Платеж #295
296	P202500296	37	296	14444.52	постоплата	оплачен	2025-11-20 00:00:00	2025-11-23 00:00:00	карта	Платеж #296
297	P202500297	38	297	134799.91	постоплата	оплачен	2025-11-13 00:00:00	2025-11-20 00:00:00	карта	Платеж #297
298	P202500298	38	298	98972.90	полная_оплата	оплачен	2026-01-16 00:00:00	2026-01-16 00:00:00	наличные	Платеж #298
299	P202500299	6	299	146913.52	предоплата	ожидает_оплаты	2025-12-28 00:00:00	\N	безналичный	Платеж #299
300	P202500300	16	300	7391.99	постоплата	просрочен	2025-10-27 00:00:00	\N	карта	Платеж #300
301	P202500301	47	301	23271.73	предоплата	ожидает_оплаты	2025-12-31 00:00:00	\N	безналичный	Платеж #301
302	P202500302	50	302	139587.62	полная_оплата	оплачен	2025-12-21 00:00:00	2025-12-27 00:00:00	карта	Платеж #302
303	P202500303	46	303	136949.55	предоплата	оплачен	2025-08-22 00:00:00	2025-08-24 00:00:00	безналичный	Платеж #303
304	P202500304	26	304	94991.82	постоплата	оплачен	2025-07-26 00:00:00	2025-08-01 00:00:00	безналичный	Платеж #304
305	P202500305	10	305	58905.20	полная_оплата	ожидает_оплаты	2025-12-06 00:00:00	\N	безналичный	Платеж #305
306	P202500306	27	306	142751.87	постоплата	оплачен	2025-12-03 00:00:00	2025-12-05 00:00:00	карта	Платеж #306
307	P202500307	9	307	113070.34	полная_оплата	оплачен	2025-08-27 00:00:00	2025-09-06 00:00:00	наличные	Платеж #307
308	P202500308	23	308	139929.27	полная_оплата	просрочен	2025-12-17 00:00:00	\N	карта	Платеж #308
309	P202500309	29	309	80299.36	постоплата	оплачен	2025-12-04 00:00:00	2025-12-08 00:00:00	карта	Платеж #309
310	P202500310	34	310	149940.82	полная_оплата	просрочен	2025-12-11 00:00:00	\N	карта	Платеж #310
311	P202500311	42	311	134445.57	полная_оплата	просрочен	2025-08-11 00:00:00	\N	наличные	Платеж #311
312	P202500312	43	312	124305.72	предоплата	оплачен	2025-08-11 00:00:00	2025-08-20 00:00:00	наличные	Платеж #312
313	P202500313	20	313	125196.08	постоплата	оплачен	2025-11-02 00:00:00	2025-11-02 00:00:00	наличные	Платеж #313
314	P202500314	24	314	42933.89	полная_оплата	ожидает_оплаты	2025-11-21 00:00:00	\N	безналичный	Платеж #314
315	P202500315	21	315	30981.18	постоплата	ожидает_оплаты	2026-01-19 00:00:00	\N	наличные	Платеж #315
316	P202500316	44	316	135743.17	полная_оплата	просрочен	2025-10-22 00:00:00	\N	карта	Платеж #316
317	P202500317	7	317	111398.80	полная_оплата	оплачен	2025-11-10 00:00:00	2025-11-10 00:00:00	безналичный	Платеж #317
318	P202500318	24	318	111329.45	постоплата	ожидает_оплаты	2025-10-26 00:00:00	\N	карта	Платеж #318
319	P202500319	46	319	132320.90	полная_оплата	оплачен	2025-10-30 00:00:00	2025-11-02 00:00:00	карта	Платеж #319
320	P202500320	26	320	51895.63	полная_оплата	оплачен	2025-11-14 00:00:00	2025-11-17 00:00:00	безналичный	Платеж #320
321	P202500321	9	321	87932.87	полная_оплата	оплачен	2025-08-18 00:00:00	2025-08-28 00:00:00	наличные	Платеж #321
322	P202500322	10	322	61553.26	полная_оплата	оплачен	2025-09-25 00:00:00	2025-09-25 00:00:00	карта	Платеж #322
323	P202500323	48	323	30733.47	постоплата	оплачен	2025-10-31 00:00:00	2025-11-05 00:00:00	наличные	Платеж #323
324	P202500324	17	324	105455.04	полная_оплата	просрочен	2025-09-10 00:00:00	\N	наличные	Платеж #324
325	P202500325	21	325	46215.59	постоплата	просрочен	2025-10-05 00:00:00	\N	безналичный	Платеж #325
326	P202500326	29	326	121772.38	полная_оплата	просрочен	2025-10-03 00:00:00	\N	наличные	Платеж #326
327	P202500327	45	327	46609.80	предоплата	оплачен	2025-08-23 00:00:00	2025-08-24 00:00:00	безналичный	Платеж #327
328	P202500328	48	328	115752.12	полная_оплата	ожидает_оплаты	2026-01-12 00:00:00	\N	безналичный	Платеж #328
329	P202500329	36	329	87010.10	постоплата	оплачен	2026-01-05 00:00:00	2026-01-07 00:00:00	наличные	Платеж #329
330	P202500330	22	330	60726.78	постоплата	оплачен	2025-10-16 00:00:00	2025-10-20 00:00:00	карта	Платеж #330
331	P202500331	23	331	19244.64	полная_оплата	оплачен	2025-09-24 00:00:00	2025-09-24 00:00:00	наличные	Платеж #331
332	P202500332	9	332	149935.33	полная_оплата	оплачен	2026-01-09 00:00:00	2026-01-18 00:00:00	наличные	Платеж #332
333	P202500333	34	333	136347.30	полная_оплата	оплачен	2025-08-04 00:00:00	2025-08-06 00:00:00	наличные	Платеж #333
334	P202500334	3	334	127717.34	предоплата	оплачен	2025-09-18 00:00:00	2025-09-22 00:00:00	наличные	Платеж #334
335	P202500335	25	335	55250.03	полная_оплата	просрочен	2025-08-02 00:00:00	\N	безналичный	Платеж #335
336	P202500336	11	336	29415.44	постоплата	ожидает_оплаты	2025-12-01 00:00:00	\N	карта	Платеж #336
337	P202500337	38	337	41303.25	предоплата	ожидает_оплаты	2025-12-08 00:00:00	\N	наличные	Платеж #337
338	P202500338	41	338	102953.24	полная_оплата	ожидает_оплаты	2025-11-09 00:00:00	\N	карта	Платеж #338
339	P202500339	34	339	7456.72	предоплата	ожидает_оплаты	2026-01-12 00:00:00	\N	наличные	Платеж #339
340	P202500340	38	340	137681.12	полная_оплата	ожидает_оплаты	2026-01-18 00:00:00	\N	наличные	Платеж #340
341	P202500341	20	341	69537.11	полная_оплата	ожидает_оплаты	2025-08-04 00:00:00	\N	безналичный	Платеж #341
342	P202500342	30	342	81284.02	предоплата	оплачен	2025-10-09 00:00:00	2025-10-14 00:00:00	наличные	Платеж #342
343	P202500343	20	343	20153.48	постоплата	оплачен	2025-10-06 00:00:00	2025-10-12 00:00:00	наличные	Платеж #343
344	P202500344	11	344	68504.66	постоплата	оплачен	2025-12-05 00:00:00	2025-12-15 00:00:00	карта	Платеж #344
345	P202500345	42	345	44603.60	постоплата	ожидает_оплаты	2025-12-13 00:00:00	\N	безналичный	Платеж #345
346	P202500346	25	346	20591.99	постоплата	просрочен	2025-08-09 00:00:00	\N	наличные	Платеж #346
347	P202500347	9	347	57079.37	предоплата	оплачен	2025-09-15 00:00:00	2025-09-19 00:00:00	безналичный	Платеж #347
348	P202500348	7	348	92937.75	полная_оплата	оплачен	2025-11-04 00:00:00	2025-11-11 00:00:00	безналичный	Платеж #348
349	P202500349	16	349	48410.62	предоплата	оплачен	2025-10-23 00:00:00	2025-10-26 00:00:00	карта	Платеж #349
350	P202500350	5	350	88380.24	полная_оплата	оплачен	2025-10-23 00:00:00	2025-11-02 00:00:00	наличные	Платеж #350
351	P202500351	10	351	13093.59	полная_оплата	оплачен	2025-12-18 00:00:00	2025-12-28 00:00:00	карта	Платеж #351
352	P202500352	5	352	64006.94	постоплата	ожидает_оплаты	2025-11-19 00:00:00	\N	наличные	Платеж #352
353	P202500353	18	353	6062.69	предоплата	ожидает_оплаты	2026-01-08 00:00:00	\N	безналичный	Платеж #353
354	P202500354	46	354	143872.84	полная_оплата	оплачен	2026-01-20 00:00:00	2026-01-23 00:00:00	наличные	Платеж #354
355	P202500355	6	355	77896.60	полная_оплата	ожидает_оплаты	2025-09-28 00:00:00	\N	безналичный	Платеж #355
356	P202500356	26	356	57913.40	постоплата	ожидает_оплаты	2025-09-01 00:00:00	\N	карта	Платеж #356
357	P202500357	48	357	31906.43	постоплата	оплачен	2025-09-25 00:00:00	2025-10-05 00:00:00	безналичный	Платеж #357
358	P202500358	17	358	54594.83	предоплата	оплачен	2025-10-30 00:00:00	2025-11-05 00:00:00	наличные	Платеж #358
359	P202500359	6	359	103095.98	постоплата	оплачен	2025-10-21 00:00:00	2025-10-24 00:00:00	карта	Платеж #359
360	P202500360	38	360	48997.46	предоплата	оплачен	2025-09-12 00:00:00	2025-09-14 00:00:00	безналичный	Платеж #360
361	P202500361	3	361	23567.48	постоплата	ожидает_оплаты	2025-11-30 00:00:00	\N	карта	Платеж #361
362	P202500362	24	362	33895.92	полная_оплата	ожидает_оплаты	2025-09-11 00:00:00	\N	наличные	Платеж #362
363	P202500363	39	363	19484.01	постоплата	просрочен	2025-09-20 00:00:00	\N	карта	Платеж #363
364	P202500364	15	364	70629.03	полная_оплата	просрочен	2025-11-28 00:00:00	\N	безналичный	Платеж #364
365	P202500365	31	365	42037.70	предоплата	оплачен	2025-11-14 00:00:00	2025-11-23 00:00:00	наличные	Платеж #365
366	P202500366	2	366	31886.35	полная_оплата	оплачен	2025-11-21 00:00:00	2025-11-26 00:00:00	наличные	Платеж #366
367	P202500367	23	367	59324.09	полная_оплата	ожидает_оплаты	2025-08-09 00:00:00	\N	карта	Платеж #367
368	P202500368	2	368	139350.49	постоплата	оплачен	2025-11-19 00:00:00	2025-11-22 00:00:00	безналичный	Платеж #368
369	P202500369	34	369	108664.76	постоплата	ожидает_оплаты	2025-12-02 00:00:00	\N	наличные	Платеж #369
370	P202500370	32	370	148153.18	предоплата	просрочен	2025-12-05 00:00:00	\N	карта	Платеж #370
371	P202500371	11	371	148383.45	постоплата	оплачен	2026-01-12 00:00:00	2026-01-17 00:00:00	карта	Платеж #371
372	P202500372	2	372	146811.74	полная_оплата	ожидает_оплаты	2025-08-28 00:00:00	\N	безналичный	Платеж #372
373	P202500373	5	373	126231.03	предоплата	оплачен	2025-09-24 00:00:00	2025-09-27 00:00:00	наличные	Платеж #373
374	P202500374	11	374	77490.10	полная_оплата	ожидает_оплаты	2025-10-15 00:00:00	\N	безналичный	Платеж #374
375	P202500375	25	375	136455.24	предоплата	оплачен	2025-10-07 00:00:00	2025-10-17 00:00:00	безналичный	Платеж #375
376	P202500376	48	376	78780.11	постоплата	просрочен	2025-08-22 00:00:00	\N	безналичный	Платеж #376
377	P202500377	38	377	14074.84	полная_оплата	оплачен	2025-12-25 00:00:00	2025-12-29 00:00:00	безналичный	Платеж #377
378	P202500378	5	378	115088.82	полная_оплата	оплачен	2025-12-24 00:00:00	2025-12-28 00:00:00	карта	Платеж #378
379	P202500379	46	379	86243.65	постоплата	оплачен	2026-01-15 00:00:00	2026-01-20 00:00:00	безналичный	Платеж #379
380	P202500380	42	380	138799.41	предоплата	просрочен	2025-08-18 00:00:00	\N	карта	Платеж #380
381	P202500381	46	381	25204.12	предоплата	просрочен	2025-12-13 00:00:00	\N	безналичный	Платеж #381
382	P202500382	1	382	143199.78	постоплата	оплачен	2025-08-25 00:00:00	2025-09-02 00:00:00	наличные	Платеж #382
383	P202500383	23	383	113909.04	предоплата	ожидает_оплаты	2025-08-26 00:00:00	\N	безналичный	Платеж #383
384	P202500384	18	384	89074.18	предоплата	просрочен	2025-11-28 00:00:00	\N	наличные	Платеж #384
385	P202500385	50	385	90511.13	постоплата	просрочен	2025-12-01 00:00:00	\N	наличные	Платеж #385
386	P202500386	22	386	116180.99	постоплата	просрочен	2026-01-17 00:00:00	\N	безналичный	Платеж #386
387	P202500387	41	387	15684.90	предоплата	оплачен	2025-09-05 00:00:00	2025-09-05 00:00:00	карта	Платеж #387
388	P202500388	47	388	21367.00	постоплата	ожидает_оплаты	2025-12-07 00:00:00	\N	наличные	Платеж #388
389	P202500389	45	389	39998.23	постоплата	ожидает_оплаты	2026-01-09 00:00:00	\N	карта	Платеж #389
390	P202500390	23	390	77312.92	постоплата	просрочен	2025-08-19 00:00:00	\N	безналичный	Платеж #390
391	P202500391	48	391	86858.55	постоплата	оплачен	2025-08-28 00:00:00	2025-08-30 00:00:00	безналичный	Платеж #391
392	P202500392	7	392	21089.27	полная_оплата	оплачен	2025-12-06 00:00:00	2025-12-14 00:00:00	наличные	Платеж #392
393	P202500393	8	393	95294.65	полная_оплата	ожидает_оплаты	2025-08-02 00:00:00	\N	карта	Платеж #393
394	P202500394	29	394	20161.78	предоплата	просрочен	2025-10-21 00:00:00	\N	безналичный	Платеж #394
395	P202500395	35	395	73340.51	полная_оплата	оплачен	2025-09-06 00:00:00	2025-09-07 00:00:00	карта	Платеж #395
396	P202500396	48	396	77947.26	постоплата	оплачен	2025-11-06 00:00:00	2025-11-16 00:00:00	безналичный	Платеж #396
397	P202500397	10	397	12790.60	предоплата	просрочен	2025-08-01 00:00:00	\N	наличные	Платеж #397
398	P202500398	3	398	69952.91	полная_оплата	оплачен	2025-08-11 00:00:00	2025-08-17 00:00:00	безналичный	Платеж #398
399	P202500399	6	399	99717.57	предоплата	оплачен	2025-08-10 00:00:00	2025-08-11 00:00:00	безналичный	Платеж #399
400	P202500400	8	400	149079.71	предоплата	просрочен	2026-01-18 00:00:00	\N	карта	Платеж #400
401	P202500401	34	401	38765.14	полная_оплата	ожидает_оплаты	2025-11-03 00:00:00	\N	карта	Платеж #401
402	P202500402	9	402	110645.51	предоплата	ожидает_оплаты	2025-08-18 00:00:00	\N	безналичный	Платеж #402
403	P202500403	23	403	16177.14	полная_оплата	ожидает_оплаты	2026-01-04 00:00:00	\N	наличные	Платеж #403
404	P202500404	29	404	19302.43	постоплата	просрочен	2025-10-14 00:00:00	\N	карта	Платеж #404
405	P202500405	23	405	148011.96	постоплата	ожидает_оплаты	2025-10-17 00:00:00	\N	карта	Платеж #405
406	P202500406	6	406	119047.20	полная_оплата	оплачен	2025-09-04 00:00:00	2025-09-08 00:00:00	наличные	Платеж #406
407	P202500407	35	407	125122.43	постоплата	оплачен	2025-10-14 00:00:00	2025-10-20 00:00:00	безналичный	Платеж #407
408	P202500408	4	408	112849.02	постоплата	ожидает_оплаты	2025-12-11 00:00:00	\N	карта	Платеж #408
409	P202500409	19	409	9151.95	постоплата	оплачен	2025-08-06 00:00:00	2025-08-09 00:00:00	наличные	Платеж #409
410	P202500410	22	410	10897.63	предоплата	просрочен	2025-09-17 00:00:00	\N	наличные	Платеж #410
411	P202500411	7	411	50894.84	предоплата	оплачен	2025-08-01 00:00:00	2025-08-11 00:00:00	карта	Платеж #411
412	P202500412	31	412	58353.31	предоплата	ожидает_оплаты	2025-07-31 00:00:00	\N	карта	Платеж #412
413	P202500413	1	413	33010.32	полная_оплата	оплачен	2025-10-25 00:00:00	2025-11-04 00:00:00	наличные	Платеж #413
414	P202500414	35	414	24229.37	постоплата	просрочен	2026-01-04 00:00:00	\N	карта	Платеж #414
415	P202500415	22	415	12446.96	предоплата	оплачен	2025-10-01 00:00:00	2025-10-03 00:00:00	безналичный	Платеж #415
416	P202500416	14	416	77407.47	предоплата	ожидает_оплаты	2025-09-08 00:00:00	\N	безналичный	Платеж #416
417	P202500417	28	417	9175.66	постоплата	ожидает_оплаты	2025-09-08 00:00:00	\N	карта	Платеж #417
418	P202500418	29	418	12788.74	полная_оплата	оплачен	2025-09-24 00:00:00	2025-09-28 00:00:00	карта	Платеж #418
419	P202500419	50	419	102511.22	полная_оплата	ожидает_оплаты	2025-09-28 00:00:00	\N	наличные	Платеж #419
420	P202500420	6	420	41963.94	полная_оплата	ожидает_оплаты	2025-08-25 00:00:00	\N	карта	Платеж #420
421	P202500421	4	421	16706.89	предоплата	ожидает_оплаты	2026-01-19 00:00:00	\N	карта	Платеж #421
422	P202500422	34	422	70950.43	постоплата	оплачен	2025-11-23 00:00:00	2025-11-26 00:00:00	наличные	Платеж #422
423	P202500423	36	423	131407.90	полная_оплата	оплачен	2025-10-25 00:00:00	2025-10-28 00:00:00	безналичный	Платеж #423
424	P202500424	24	424	70518.71	полная_оплата	оплачен	2025-09-12 00:00:00	2025-09-13 00:00:00	безналичный	Платеж #424
425	P202500425	30	425	26751.97	постоплата	ожидает_оплаты	2025-12-25 00:00:00	\N	карта	Платеж #425
426	P202500426	31	426	92713.82	постоплата	ожидает_оплаты	2026-01-19 00:00:00	\N	карта	Платеж #426
427	P202500427	41	427	66276.82	предоплата	ожидает_оплаты	2025-12-19 00:00:00	\N	наличные	Платеж #427
428	P202500428	47	428	57074.37	предоплата	ожидает_оплаты	2025-09-14 00:00:00	\N	безналичный	Платеж #428
429	P202500429	45	429	20522.48	постоплата	просрочен	2025-10-14 00:00:00	\N	наличные	Платеж #429
430	P202500430	37	430	11730.77	постоплата	оплачен	2025-10-29 00:00:00	2025-11-06 00:00:00	безналичный	Платеж #430
431	P202500431	50	431	16674.87	постоплата	оплачен	2025-11-25 00:00:00	2025-11-29 00:00:00	карта	Платеж #431
432	P202500432	20	432	100384.10	предоплата	оплачен	2025-08-12 00:00:00	2025-08-19 00:00:00	наличные	Платеж #432
433	P202500433	10	433	144964.94	предоплата	оплачен	2025-08-10 00:00:00	2025-08-16 00:00:00	карта	Платеж #433
434	P202500434	9	434	114293.52	предоплата	оплачен	2025-08-28 00:00:00	2025-09-03 00:00:00	наличные	Платеж #434
435	P202500435	22	435	6569.45	постоплата	ожидает_оплаты	2025-09-17 00:00:00	\N	безналичный	Платеж #435
436	P202500436	38	436	55529.17	предоплата	оплачен	2026-01-07 00:00:00	2026-01-15 00:00:00	карта	Платеж #436
437	P202500437	4	437	149891.98	постоплата	ожидает_оплаты	2025-11-12 00:00:00	\N	наличные	Платеж #437
438	P202500438	10	438	91798.62	предоплата	оплачен	2026-01-03 00:00:00	2026-01-06 00:00:00	безналичный	Платеж #438
439	P202500439	10	439	67731.77	полная_оплата	оплачен	2025-11-06 00:00:00	2025-11-08 00:00:00	наличные	Платеж #439
440	P202500440	38	440	85868.40	постоплата	просрочен	2025-08-08 00:00:00	\N	безналичный	Платеж #440
441	P202500441	2	441	16466.59	постоплата	ожидает_оплаты	2025-08-11 00:00:00	\N	безналичный	Платеж #441
442	P202500442	13	442	117587.52	постоплата	просрочен	2025-10-22 00:00:00	\N	карта	Платеж #442
443	P202500443	43	443	107529.97	постоплата	оплачен	2025-08-01 00:00:00	2025-08-07 00:00:00	карта	Платеж #443
444	P202500444	24	444	88083.46	постоплата	оплачен	2025-10-19 00:00:00	2025-10-25 00:00:00	карта	Платеж #444
445	P202500445	40	445	24038.37	постоплата	просрочен	2025-08-19 00:00:00	\N	наличные	Платеж #445
446	P202500446	36	446	24470.18	предоплата	ожидает_оплаты	2025-09-15 00:00:00	\N	карта	Платеж #446
447	P202500447	34	447	117996.61	предоплата	оплачен	2025-09-18 00:00:00	2025-09-23 00:00:00	наличные	Платеж #447
448	P202500448	13	448	62879.30	постоплата	оплачен	2025-11-07 00:00:00	2025-11-16 00:00:00	безналичный	Платеж #448
449	P202500449	30	449	93784.20	предоплата	оплачен	2025-08-02 00:00:00	2025-08-09 00:00:00	карта	Платеж #449
450	P202500450	49	450	11317.62	постоплата	оплачен	2025-11-18 00:00:00	2025-11-20 00:00:00	безналичный	Платеж #450
451	P202500451	45	451	139468.97	полная_оплата	ожидает_оплаты	2025-09-19 00:00:00	\N	наличные	Платеж #451
452	P202500452	44	452	75199.97	предоплата	ожидает_оплаты	2025-08-25 00:00:00	\N	безналичный	Платеж #452
453	P202500453	2	453	26930.61	полная_оплата	просрочен	2025-08-28 00:00:00	\N	наличные	Платеж #453
454	P202500454	2	454	92695.55	полная_оплата	ожидает_оплаты	2025-09-30 00:00:00	\N	безналичный	Платеж #454
455	P202500455	12	455	126680.78	предоплата	оплачен	2025-12-18 00:00:00	2025-12-28 00:00:00	наличные	Платеж #455
456	P202500456	42	456	33306.37	постоплата	оплачен	2025-08-02 00:00:00	2025-08-04 00:00:00	наличные	Платеж #456
457	P202500457	44	457	23681.41	постоплата	оплачен	2025-12-15 00:00:00	2025-12-21 00:00:00	карта	Платеж #457
458	P202500458	20	458	105165.51	полная_оплата	оплачен	2025-12-10 00:00:00	2025-12-19 00:00:00	безналичный	Платеж #458
459	P202500459	48	459	73934.06	постоплата	ожидает_оплаты	2025-12-09 00:00:00	\N	безналичный	Платеж #459
460	P202500460	34	460	148846.59	предоплата	оплачен	2026-01-04 00:00:00	2026-01-06 00:00:00	карта	Платеж #460
461	P202500461	17	461	94868.67	постоплата	ожидает_оплаты	2025-09-28 00:00:00	\N	безналичный	Платеж #461
462	P202500462	7	462	39095.15	предоплата	оплачен	2025-08-26 00:00:00	2025-08-27 00:00:00	наличные	Платеж #462
463	P202500463	7	463	90661.56	постоплата	оплачен	2025-09-16 00:00:00	2025-09-22 00:00:00	наличные	Платеж #463
464	P202500464	12	464	127704.03	постоплата	просрочен	2025-07-30 00:00:00	\N	карта	Платеж #464
465	P202500465	49	465	137804.76	предоплата	ожидает_оплаты	2025-12-11 00:00:00	\N	наличные	Платеж #465
466	P202500466	48	466	78116.01	постоплата	просрочен	2025-09-16 00:00:00	\N	карта	Платеж #466
467	P202500467	1	467	148060.80	предоплата	оплачен	2025-11-01 00:00:00	2025-11-05 00:00:00	наличные	Платеж #467
468	P202500468	21	468	122673.68	полная_оплата	ожидает_оплаты	2025-09-17 00:00:00	\N	карта	Платеж #468
469	P202500469	45	469	15735.57	постоплата	оплачен	2025-08-25 00:00:00	2025-08-28 00:00:00	безналичный	Платеж #469
470	P202500470	50	470	8040.59	предоплата	оплачен	2025-08-01 00:00:00	2025-08-06 00:00:00	карта	Платеж #470
471	P202500471	12	471	76288.01	постоплата	оплачен	2025-09-26 00:00:00	2025-09-27 00:00:00	карта	Платеж #471
472	P202500472	19	472	81788.87	постоплата	оплачен	2025-08-24 00:00:00	2025-08-25 00:00:00	наличные	Платеж #472
473	P202500473	47	473	69618.47	постоплата	ожидает_оплаты	2026-01-05 00:00:00	\N	карта	Платеж #473
474	P202500474	32	474	84057.49	предоплата	ожидает_оплаты	2025-09-22 00:00:00	\N	карта	Платеж #474
475	P202500475	38	475	9060.42	постоплата	оплачен	2025-10-25 00:00:00	2025-10-28 00:00:00	наличные	Платеж #475
476	P202500476	42	476	7162.55	полная_оплата	просрочен	2025-09-19 00:00:00	\N	карта	Платеж #476
477	P202500477	45	477	148083.13	предоплата	просрочен	2025-08-03 00:00:00	\N	карта	Платеж #477
478	P202500478	33	478	105720.60	предоплата	ожидает_оплаты	2025-09-09 00:00:00	\N	безналичный	Платеж #478
479	P202500479	44	479	69137.06	полная_оплата	ожидает_оплаты	2025-08-05 00:00:00	\N	наличные	Платеж #479
480	P202500480	43	480	20395.23	полная_оплата	просрочен	2025-11-12 00:00:00	\N	безналичный	Платеж #480
481	P202500481	45	481	46709.93	постоплата	оплачен	2025-11-30 00:00:00	2025-11-30 00:00:00	наличные	Платеж #481
482	P202500482	14	482	78834.88	постоплата	ожидает_оплаты	2026-01-12 00:00:00	\N	наличные	Платеж #482
483	P202500483	34	483	65468.77	предоплата	оплачен	2025-12-29 00:00:00	2025-12-31 00:00:00	карта	Платеж #483
484	P202500484	9	484	136886.64	предоплата	оплачен	2026-01-12 00:00:00	2026-01-17 00:00:00	безналичный	Платеж #484
485	P202500485	40	485	93090.13	предоплата	оплачен	2026-01-15 00:00:00	2026-01-20 00:00:00	безналичный	Платеж #485
486	P202500486	6	486	9703.53	предоплата	просрочен	2025-12-08 00:00:00	\N	безналичный	Платеж #486
487	P202500487	1	487	63537.15	предоплата	просрочен	2025-10-10 00:00:00	\N	безналичный	Платеж #487
488	P202500488	50	488	68538.84	предоплата	просрочен	2026-01-01 00:00:00	\N	карта	Платеж #488
489	P202500489	38	489	127243.29	предоплата	оплачен	2025-10-22 00:00:00	2025-10-24 00:00:00	карта	Платеж #489
490	P202500490	39	490	48785.53	полная_оплата	оплачен	2025-11-24 00:00:00	2025-11-29 00:00:00	наличные	Платеж #490
491	P202500491	35	491	104384.33	полная_оплата	просрочен	2025-10-19 00:00:00	\N	наличные	Платеж #491
492	P202500492	48	492	135444.75	предоплата	просрочен	2025-11-20 00:00:00	\N	карта	Платеж #492
493	P202500493	8	493	30345.82	полная_оплата	оплачен	2025-11-27 00:00:00	2025-11-28 00:00:00	наличные	Платеж #493
494	P202500494	24	494	130878.83	предоплата	оплачен	2025-10-17 00:00:00	2025-10-25 00:00:00	карта	Платеж #494
495	P202500495	38	495	73365.48	постоплата	просрочен	2025-09-13 00:00:00	\N	карта	Платеж #495
496	P202500496	12	496	16352.42	постоплата	оплачен	2025-10-02 00:00:00	2025-10-09 00:00:00	карта	Платеж #496
497	P202500497	17	497	119900.86	предоплата	оплачен	2025-10-09 00:00:00	2025-10-17 00:00:00	карта	Платеж #497
498	P202500498	46	498	81508.81	предоплата	ожидает_оплаты	2025-09-11 00:00:00	\N	карта	Платеж #498
499	P202500499	31	499	94296.11	предоплата	оплачен	2025-12-12 00:00:00	2025-12-13 00:00:00	карта	Платеж #499
500	P202500500	29	500	47918.59	полная_оплата	оплачен	2025-11-01 00:00:00	2025-11-08 00:00:00	карта	Платеж #500
\.


--
-- Data for Name: расходы_топлива; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."расходы_топлива" ("ид_расход", "ид_средство", "дата_заправки", "объем_л", "стоимость_руб", "тип_топлива", "пробег_на_момент_заправки", "станция_заправки") FROM stdin;
301	11	2025-12-11 00:00:00	257.77	12148.58	бензин	464107	АЗС-91
302	4	2025-11-20 00:00:00	94.59	5163.91	дизель	82187	АЗС-28
303	65	2025-08-12 00:00:00	95.31	4677.77	дизель	248057	АЗС-40
304	95	2026-01-02 00:00:00	54.99	3089.13	дизель	142279	АЗС-27
305	61	2025-11-11 00:00:00	344.45	16525.20	дизель	454690	АЗС-16
306	26	2025-12-24 00:00:00	319.64	16163.95	дизель	447821	АЗС-8
307	48	2025-10-15 00:00:00	193.17	10166.64	дизель	288227	АЗС-23
308	68	2026-01-03 00:00:00	361.59	18746.85	бензин	123947	АЗС-100
309	61	2025-10-03 00:00:00	380.26	19761.49	дизель	311206	АЗС-49
310	68	2025-12-25 00:00:00	213.65	10934.25	дизель	102445	АЗС-13
311	21	2025-09-26 00:00:00	404.40	20002.22	дизель	188321	АЗС-44
312	85	2025-12-04 00:00:00	56.73	2946.01	дизель	293788	АЗС-75
313	85	2025-09-13 00:00:00	104.00	4938.90	дизель	259193	АЗС-63
314	1	2025-12-14 00:00:00	162.08	7633.88	дизель	439191	АЗС-68
315	37	2025-12-22 00:00:00	368.84	20019.30	дизель	201214	АЗС-44
316	21	2025-10-24 00:00:00	338.59	19471.48	дизель	308969	АЗС-85
317	96	2025-12-11 00:00:00	348.18	18479.62	бензин	475476	АЗС-81
318	26	2025-11-18 00:00:00	80.56	3672.53	дизель	451907	АЗС-22
319	16	2025-09-21 00:00:00	400.79	19057.16	бензин	364248	АЗС-45
320	53	2025-08-14 00:00:00	321.20	18394.55	бензин	368209	АЗС-53
321	61	2025-09-12 00:00:00	457.21	21683.54	дизель	418249	АЗС-100
322	67	2026-01-19 00:00:00	77.34	4455.14	бензин	290066	АЗС-30
323	99	2025-10-25 00:00:00	353.59	17500.54	бензин	180760	АЗС-81
324	21	2026-01-06 00:00:00	381.70	20666.92	дизель	243766	АЗС-5
325	90	2025-12-08 00:00:00	194.75	9798.99	бензин	156370	АЗС-39
326	78	2025-09-24 00:00:00	389.80	21827.65	дизель	192145	АЗС-22
327	46	2025-11-10 00:00:00	62.85	3568.28	дизель	122584	АЗС-62
328	13	2025-12-21 00:00:00	277.73	12831.94	дизель	157590	АЗС-57
329	7	2025-10-23 00:00:00	186.68	9301.29	бензин	424011	АЗС-44
330	92	2026-01-06 00:00:00	201.35	9817.80	бензин	69992	АЗС-71
331	39	2025-12-06 00:00:00	144.93	6533.55	дизель	381529	АЗС-35
332	61	2025-12-28 00:00:00	374.88	18226.24	бензин	303795	АЗС-66
333	4	2026-01-06 00:00:00	313.07	14647.79	бензин	98402	АЗС-91
334	63	2025-07-25 00:00:00	312.66	14974.94	дизель	415168	АЗС-1
335	65	2025-10-01 00:00:00	347.72	19827.33	дизель	284096	АЗС-40
336	19	2025-10-21 00:00:00	488.60	27200.32	дизель	349643	АЗС-31
337	29	2025-10-31 00:00:00	416.82	19976.18	дизель	154844	АЗС-99
338	95	2025-09-10 00:00:00	388.63	18842.01	дизель	455460	АЗС-54
339	92	2025-07-30 00:00:00	258.50	14159.09	дизель	335160	АЗС-34
340	89	2025-08-23 00:00:00	347.22	19513.63	бензин	370959	АЗС-36
341	70	2025-07-31 00:00:00	55.57	2704.60	дизель	173459	АЗС-33
342	73	2025-10-22 00:00:00	464.68	21736.89	дизель	109148	АЗС-1
343	37	2025-08-09 00:00:00	224.34	10743.31	дизель	83627	АЗС-10
344	13	2025-10-01 00:00:00	381.03	22086.76	дизель	163877	АЗС-10
345	68	2025-11-21 00:00:00	77.39	3633.23	бензин	331901	АЗС-90
346	85	2025-09-19 00:00:00	141.34	7190.25	дизель	224050	АЗС-80
347	87	2025-10-22 00:00:00	282.09	13288.69	бензин	365650	АЗС-50
348	23	2025-11-11 00:00:00	452.00	25534.78	дизель	109154	АЗС-71
349	16	2025-09-16 00:00:00	113.00	5733.58	дизель	418437	АЗС-32
350	75	2026-01-03 00:00:00	328.03	16301.00	дизель	405668	АЗС-62
351	80	2025-08-17 00:00:00	296.21	16174.96	бензин	262440	АЗС-26
352	76	2025-11-23 00:00:00	116.44	5839.53	дизель	252465	АЗС-99
353	70	2025-11-12 00:00:00	274.50	15721.94	дизель	436165	АЗС-98
354	68	2025-12-15 00:00:00	226.51	11617.18	бензин	233270	АЗС-33
355	99	2025-12-26 00:00:00	480.62	22846.95	дизель	188421	АЗС-70
356	65	2025-10-28 00:00:00	105.74	4776.37	бензин	452126	АЗС-5
357	50	2025-08-26 00:00:00	92.31	4849.87	бензин	496276	АЗС-76
358	50	2025-08-19 00:00:00	241.55	13889.47	дизель	418660	АЗС-100
359	77	2025-11-25 00:00:00	222.44	12021.39	бензин	244033	АЗС-15
360	16	2025-11-07 00:00:00	489.97	24445.71	бензин	417333	АЗС-32
361	51	2025-08-09 00:00:00	453.07	23286.23	бензин	156116	АЗС-100
362	35	2025-10-14 00:00:00	217.80	9944.69	бензин	107920	АЗС-11
363	51	2025-10-04 00:00:00	229.91	13039.98	дизель	82684	АЗС-66
364	42	2025-08-29 00:00:00	69.87	3906.24	бензин	268246	АЗС-23
365	70	2025-10-29 00:00:00	57.20	2869.02	дизель	363461	АЗС-77
366	87	2025-08-25 00:00:00	350.22	17932.26	дизель	417794	АЗС-18
367	77	2025-12-23 00:00:00	484.05	23659.51	бензин	414195	АЗС-2
368	48	2025-08-28 00:00:00	197.53	11256.63	дизель	404041	АЗС-34
369	89	2026-01-10 00:00:00	381.63	19117.12	дизель	259658	АЗС-47
370	92	2025-11-01 00:00:00	355.40	16828.50	дизель	468389	АЗС-20
371	69	2025-12-04 00:00:00	123.67	6152.18	бензин	199677	АЗС-29
372	88	2025-07-28 00:00:00	189.00	8884.24	бензин	390637	АЗС-57
373	100	2025-12-29 00:00:00	413.84	21911.41	дизель	241315	АЗС-19
374	72	2025-09-22 00:00:00	417.59	20006.41	бензин	253339	АЗС-77
375	42	2025-08-21 00:00:00	400.48	20108.13	бензин	248803	АЗС-78
376	81	2025-11-19 00:00:00	181.46	9915.44	бензин	202388	АЗС-77
377	51	2025-10-01 00:00:00	284.06	12930.62	дизель	75787	АЗС-79
378	74	2025-10-10 00:00:00	132.32	6965.98	дизель	398878	АЗС-33
379	30	2025-11-26 00:00:00	494.62	22738.97	дизель	462739	АЗС-60
380	80	2025-12-06 00:00:00	455.46	23400.56	бензин	477732	АЗС-2
381	88	2025-12-28 00:00:00	192.93	10002.64	дизель	162552	АЗС-38
382	65	2025-08-28 00:00:00	397.47	19756.46	бензин	150209	АЗС-46
383	24	2025-10-04 00:00:00	446.46	21434.68	дизель	296286	АЗС-53
384	71	2025-08-14 00:00:00	346.78	19406.70	дизель	232621	АЗС-27
385	65	2025-08-27 00:00:00	257.10	14618.41	бензин	258307	АЗС-58
386	19	2025-07-31 00:00:00	369.79	20211.96	дизель	125153	АЗС-36
387	60	2025-10-23 00:00:00	147.87	7351.42	бензин	395692	АЗС-7
388	2	2025-12-15 00:00:00	303.95	16066.56	бензин	233288	АЗС-28
389	60	2026-01-09 00:00:00	190.84	10887.74	дизель	337608	АЗС-69
390	81	2025-09-17 00:00:00	352.02	19714.19	бензин	440685	АЗС-34
391	26	2025-08-17 00:00:00	156.65	7674.08	бензин	221047	АЗС-92
392	29	2025-09-18 00:00:00	226.54	11480.82	бензин	227399	АЗС-67
393	96	2026-01-16 00:00:00	183.16	9486.27	дизель	390955	АЗС-25
394	40	2025-12-15 00:00:00	388.55	21177.43	дизель	206212	АЗС-96
395	24	2025-12-29 00:00:00	421.40	19345.72	дизель	174359	АЗС-66
396	92	2025-10-28 00:00:00	288.28	14272.34	бензин	231898	АЗС-82
397	27	2025-08-31 00:00:00	241.32	13364.80	бензин	68192	АЗС-56
398	68	2025-09-28 00:00:00	148.69	8351.65	бензин	277983	АЗС-83
399	8	2025-08-31 00:00:00	226.51	10364.67	бензин	328904	АЗС-67
400	8	2025-11-26 00:00:00	59.86	3337.10	бензин	259975	АЗС-20
401	14	2025-11-18 00:00:00	226.11	10879.65	дизель	235300	АЗС-68
402	6	2025-12-14 00:00:00	104.40	4877.52	дизель	108349	АЗС-39
403	27	2025-11-11 00:00:00	489.85	26795.01	дизель	380508	АЗС-50
404	47	2025-11-14 00:00:00	205.96	9658.99	бензин	229111	АЗС-7
405	8	2025-11-08 00:00:00	314.43	15524.68	дизель	251576	АЗС-99
406	50	2025-11-20 00:00:00	321.03	18057.19	дизель	393906	АЗС-89
407	1	2025-10-28 00:00:00	310.36	16477.24	бензин	336037	АЗС-75
408	19	2025-12-18 00:00:00	106.72	5692.09	бензин	142056	АЗС-18
409	47	2025-10-27 00:00:00	261.69	13931.84	бензин	416125	АЗС-56
410	57	2025-08-23 00:00:00	200.27	11010.79	дизель	225808	АЗС-23
411	88	2026-01-17 00:00:00	181.55	9901.95	дизель	60574	АЗС-28
412	52	2025-11-13 00:00:00	154.92	8849.30	дизель	179017	АЗС-89
413	97	2025-08-23 00:00:00	362.70	19061.18	дизель	134101	АЗС-81
414	20	2025-11-03 00:00:00	476.64	23686.10	дизель	283305	АЗС-10
415	63	2025-12-25 00:00:00	269.76	15616.84	дизель	162168	АЗС-78
416	37	2025-11-25 00:00:00	456.81	21513.17	бензин	429386	АЗС-69
417	51	2025-11-10 00:00:00	51.54	2521.75	бензин	327847	АЗС-52
418	16	2025-08-12 00:00:00	374.61	21674.79	бензин	65357	АЗС-65
419	77	2025-10-29 00:00:00	143.32	6578.96	бензин	247344	АЗС-76
420	5	2025-12-09 00:00:00	236.26	12046.02	дизель	492134	АЗС-61
421	50	2025-11-24 00:00:00	380.63	21052.60	дизель	327499	АЗС-33
422	49	2025-10-14 00:00:00	106.28	6043.89	дизель	309057	АЗС-73
423	65	2026-01-16 00:00:00	276.05	15507.08	дизель	489806	АЗС-99
424	23	2025-09-16 00:00:00	448.74	20761.30	бензин	161903	АЗС-5
425	22	2025-09-26 00:00:00	60.73	3098.56	дизель	266509	АЗС-79
426	59	2025-11-01 00:00:00	275.27	12735.47	дизель	89055	АЗС-12
427	78	2025-10-11 00:00:00	335.67	15499.00	дизель	322683	АЗС-62
428	70	2025-10-26 00:00:00	461.79	22562.48	дизель	192791	АЗС-78
429	76	2025-10-15 00:00:00	258.86	12374.57	дизель	157165	АЗС-71
430	39	2025-08-04 00:00:00	438.08	24338.68	бензин	166806	АЗС-98
431	84	2025-11-04 00:00:00	424.59	21570.09	бензин	274191	АЗС-15
432	25	2025-07-29 00:00:00	290.41	15443.03	бензин	485673	АЗС-66
433	55	2025-08-24 00:00:00	338.83	18341.72	дизель	330907	АЗС-31
434	10	2025-08-05 00:00:00	247.45	11562.33	бензин	325636	АЗС-61
435	44	2025-08-02 00:00:00	496.53	28368.04	дизель	123133	АЗС-44
436	48	2025-09-25 00:00:00	304.76	15836.83	дизель	245187	АЗС-3
437	4	2025-10-13 00:00:00	377.79	19125.08	бензин	287134	АЗС-98
438	29	2025-11-16 00:00:00	365.79	21213.69	дизель	322819	АЗС-42
439	85	2025-10-27 00:00:00	334.31	18620.69	бензин	334517	АЗС-17
440	8	2025-12-26 00:00:00	124.54	5776.92	дизель	383824	АЗС-24
441	5	2025-11-25 00:00:00	389.59	18158.37	дизель	427026	АЗС-85
442	60	2025-11-14 00:00:00	348.69	16605.76	бензин	205204	АЗС-96
443	46	2025-12-31 00:00:00	185.58	8721.85	дизель	377018	АЗС-14
444	72	2025-09-11 00:00:00	367.66	21042.90	дизель	67292	АЗС-1
445	11	2025-08-29 00:00:00	244.70	12463.01	дизель	51864	АЗС-10
446	59	2025-08-16 00:00:00	203.13	11500.45	дизель	449510	АЗС-67
447	90	2025-09-02 00:00:00	143.19	7997.96	дизель	456908	АЗС-36
448	96	2025-09-28 00:00:00	418.87	22034.30	бензин	264918	АЗС-67
449	75	2025-08-31 00:00:00	306.73	16913.91	дизель	342005	АЗС-89
450	4	2025-11-16 00:00:00	248.24	13631.91	дизель	481588	АЗС-94
451	18	2025-07-27 00:00:00	141.45	6395.06	бензин	394278	АЗС-26
452	56	2025-11-16 00:00:00	370.84	19581.73	дизель	263240	АЗС-76
453	30	2025-12-29 00:00:00	77.72	4353.21	дизель	312504	АЗС-31
454	25	2025-12-16 00:00:00	490.10	23807.08	бензин	156338	АЗС-21
455	40	2025-12-04 00:00:00	297.90	15937.01	дизель	214941	АЗС-80
456	15	2025-11-24 00:00:00	407.88	23635.95	дизель	454658	АЗС-78
457	53	2025-08-12 00:00:00	141.18	7437.21	бензин	238186	АЗС-44
458	2	2025-10-10 00:00:00	168.05	9037.15	дизель	50238	АЗС-99
459	100	2025-08-09 00:00:00	75.90	3664.08	дизель	132492	АЗС-41
460	15	2025-07-28 00:00:00	150.44	7641.04	дизель	344729	АЗС-29
461	2	2026-01-02 00:00:00	369.94	17299.59	бензин	346772	АЗС-79
462	35	2025-08-14 00:00:00	361.45	17947.20	дизель	97508	АЗС-39
463	21	2025-11-11 00:00:00	158.27	7509.55	дизель	293814	АЗС-67
464	56	2025-08-11 00:00:00	356.12	18690.60	дизель	148831	АЗС-51
465	50	2025-08-15 00:00:00	349.57	18410.34	бензин	133378	АЗС-23
466	1	2025-09-26 00:00:00	371.44	21395.80	бензин	260982	АЗС-69
467	42	2025-11-08 00:00:00	467.21	24463.04	бензин	384713	АЗС-21
468	80	2025-08-28 00:00:00	313.33	16947.45	дизель	121265	АЗС-80
469	31	2025-11-25 00:00:00	306.82	14024.29	бензин	69239	АЗС-17
470	5	2025-09-27 00:00:00	256.65	14376.83	дизель	111449	АЗС-76
471	53	2025-10-26 00:00:00	79.40	4381.73	дизель	172987	АЗС-25
472	32	2025-09-28 00:00:00	206.51	10389.99	бензин	389779	АЗС-8
473	24	2025-10-29 00:00:00	290.97	14446.45	бензин	381041	АЗС-7
474	19	2025-09-30 00:00:00	436.51	21941.73	бензин	136191	АЗС-5
475	18	2025-10-12 00:00:00	315.18	16640.74	дизель	398993	АЗС-78
476	53	2025-08-28 00:00:00	423.86	23113.47	дизель	357406	АЗС-67
477	62	2025-08-15 00:00:00	274.94	15587.38	дизель	230682	АЗС-13
478	23	2025-10-27 00:00:00	150.91	7613.00	дизель	495461	АЗС-64
479	53	2025-10-14 00:00:00	236.63	12043.13	дизель	207498	АЗС-33
480	50	2026-01-17 00:00:00	93.82	4605.02	дизель	280573	АЗС-52
481	94	2025-11-15 00:00:00	122.63	6358.51	дизель	357486	АЗС-46
482	81	2025-12-02 00:00:00	344.14	16908.40	бензин	219124	АЗС-61
483	51	2025-12-09 00:00:00	479.65	23087.11	дизель	57379	АЗС-7
484	41	2025-09-27 00:00:00	483.20	23955.42	дизель	176249	АЗС-20
485	23	2025-11-12 00:00:00	236.42	12946.07	дизель	75338	АЗС-24
486	32	2025-09-28 00:00:00	179.49	9090.34	дизель	448545	АЗС-55
487	45	2025-12-21 00:00:00	440.18	24850.44	дизель	66949	АЗС-76
488	28	2025-12-27 00:00:00	75.94	4199.82	дизель	171885	АЗС-95
489	81	2025-12-16 00:00:00	76.73	4013.22	дизель	258236	АЗС-27
490	56	2025-10-02 00:00:00	147.22	7174.90	бензин	485107	АЗС-64
491	29	2025-11-17 00:00:00	236.41	10732.47	дизель	479998	АЗС-6
492	37	2025-08-20 00:00:00	324.93	15452.74	бензин	66455	АЗС-11
493	53	2025-08-15 00:00:00	434.63	22127.55	дизель	234769	АЗС-58
494	72	2025-10-06 00:00:00	333.26	15244.91	дизель	231957	АЗС-29
495	4	2025-08-01 00:00:00	431.73	24122.36	дизель	367359	АЗС-62
496	28	2025-09-01 00:00:00	132.56	6711.97	бензин	480332	АЗС-15
497	35	2025-09-25 00:00:00	288.86	13359.92	дизель	480435	АЗС-14
498	78	2025-11-13 00:00:00	114.33	6459.89	дизель	255195	АЗС-12
499	54	2025-10-09 00:00:00	58.36	2704.96	дизель	319280	АЗС-97
500	75	2025-12-10 00:00:00	484.85	23899.82	бензин	305350	АЗС-57
501	4	2025-09-20 00:00:00	173.72	9105.88	бензин	154136	АЗС-66
502	39	2026-01-04 00:00:00	447.84	20212.89	дизель	479744	АЗС-34
503	16	2026-01-19 00:00:00	313.89	18139.67	бензин	187332	АЗС-71
504	50	2026-01-09 00:00:00	252.70	11926.78	дизель	167098	АЗС-94
505	53	2025-11-28 00:00:00	308.98	17104.61	бензин	417101	АЗС-3
506	47	2025-09-28 00:00:00	50.01	2808.45	бензин	389273	АЗС-28
507	81	2025-08-19 00:00:00	329.26	16225.71	бензин	368529	АЗС-23
508	81	2025-08-01 00:00:00	489.22	22067.63	дизель	495050	АЗС-62
509	81	2025-09-09 00:00:00	253.27	11568.64	бензин	462096	АЗС-94
510	3	2026-01-20 00:00:00	297.57	16367.29	бензин	174259	АЗС-14
511	51	2025-09-19 00:00:00	338.45	18044.40	дизель	140272	АЗС-27
512	76	2025-11-18 00:00:00	357.44	20384.05	дизель	258507	АЗС-64
513	87	2025-11-15 00:00:00	143.49	7368.26	дизель	176333	АЗС-86
514	57	2025-09-05 00:00:00	124.13	7071.16	бензин	146078	АЗС-45
515	96	2025-11-25 00:00:00	217.71	10241.86	дизель	325525	АЗС-32
516	20	2025-09-19 00:00:00	271.37	14473.19	дизель	50216	АЗС-32
517	14	2025-10-06 00:00:00	394.39	19127.14	бензин	389673	АЗС-59
518	74	2025-10-10 00:00:00	426.51	24423.62	дизель	280838	АЗС-52
519	32	2025-11-02 00:00:00	151.47	7447.69	дизель	334368	АЗС-78
520	91	2025-11-14 00:00:00	283.80	15575.96	бензин	217744	АЗС-71
521	64	2025-12-23 00:00:00	191.28	9258.50	бензин	104417	АЗС-85
522	4	2025-10-17 00:00:00	193.05	10965.42	дизель	274142	АЗС-23
523	56	2025-12-31 00:00:00	273.91	14191.94	дизель	479294	АЗС-45
524	82	2026-01-14 00:00:00	199.77	10073.64	бензин	100970	АЗС-11
525	62	2025-11-14 00:00:00	131.31	6521.26	дизель	131966	АЗС-61
526	89	2025-12-15 00:00:00	438.10	23029.76	дизель	187597	АЗС-93
527	42	2025-12-04 00:00:00	440.68	21394.79	бензин	341157	АЗС-38
528	71	2025-10-07 00:00:00	278.76	14424.03	дизель	126276	АЗС-2
529	100	2025-08-01 00:00:00	219.66	11797.08	дизель	481570	АЗС-84
530	24	2025-08-25 00:00:00	195.12	10737.98	бензин	377770	АЗС-36
531	1	2025-11-11 00:00:00	148.80	7250.03	бензин	272223	АЗС-12
532	73	2025-09-30 00:00:00	131.38	6812.59	дизель	301670	АЗС-32
533	26	2025-10-06 00:00:00	183.04	10246.23	дизель	311347	АЗС-2
534	77	2025-12-17 00:00:00	440.09	22748.27	дизель	230468	АЗС-89
535	40	2025-12-23 00:00:00	138.40	7470.58	дизель	294412	АЗС-77
536	2	2026-01-02 00:00:00	312.29	14600.42	дизель	299138	АЗС-100
537	24	2025-11-23 00:00:00	406.40	19826.64	дизель	140755	АЗС-69
538	13	2025-11-09 00:00:00	395.64	21035.77	дизель	93792	АЗС-22
539	50	2025-08-24 00:00:00	187.19	10307.75	бензин	103184	АЗС-77
540	27	2026-01-16 00:00:00	477.56	24338.44	дизель	241759	АЗС-66
541	64	2025-10-24 00:00:00	80.82	4413.46	дизель	361192	АЗС-28
542	90	2025-12-25 00:00:00	422.16	21772.20	дизель	381747	АЗС-61
543	67	2025-11-11 00:00:00	369.76	17640.30	дизель	144697	АЗС-3
544	59	2025-11-25 00:00:00	103.16	5181.84	дизель	263322	АЗС-28
545	80	2025-12-12 00:00:00	229.56	11356.99	дизель	293223	АЗС-32
546	83	2025-10-28 00:00:00	437.99	24517.39	дизель	400485	АЗС-31
547	4	2025-09-16 00:00:00	427.82	20067.58	дизель	170795	АЗС-25
548	56	2025-10-25 00:00:00	57.60	3307.17	бензин	211516	АЗС-80
549	58	2025-12-07 00:00:00	139.55	7805.84	дизель	239542	АЗС-97
550	32	2025-10-05 00:00:00	89.61	4257.49	дизель	356590	АЗС-51
551	22	2025-12-26 00:00:00	397.83	18909.87	бензин	137656	АЗС-64
552	40	2025-08-30 00:00:00	131.85	6315.86	дизель	80519	АЗС-68
553	75	2025-12-17 00:00:00	62.29	3137.35	бензин	130013	АЗС-5
554	3	2025-11-12 00:00:00	209.78	11010.12	дизель	227950	АЗС-23
555	34	2025-07-30 00:00:00	421.93	21212.64	дизель	330549	АЗС-99
556	11	2025-11-06 00:00:00	352.90	17004.48	дизель	261338	АЗС-99
557	36	2025-11-16 00:00:00	378.73	20162.61	дизель	119617	АЗС-55
558	30	2025-11-22 00:00:00	293.68	14819.67	бензин	205116	АЗС-79
559	35	2025-07-26 00:00:00	351.90	17008.79	дизель	207814	АЗС-2
560	50	2025-08-27 00:00:00	176.52	10194.06	дизель	276665	АЗС-49
561	36	2025-08-28 00:00:00	102.66	5653.62	дизель	93460	АЗС-86
562	71	2025-10-03 00:00:00	202.26	9854.58	дизель	326670	АЗС-98
563	28	2025-12-15 00:00:00	385.76	18578.45	дизель	306658	АЗС-47
564	100	2026-01-02 00:00:00	338.63	17940.17	дизель	117439	АЗС-96
565	99	2025-10-20 00:00:00	153.08	8098.17	дизель	478691	АЗС-31
566	60	2025-10-19 00:00:00	76.96	4384.36	бензин	72873	АЗС-23
567	94	2025-12-17 00:00:00	271.44	15696.96	дизель	474040	АЗС-49
568	94	2025-11-06 00:00:00	260.20	13114.05	дизель	188193	АЗС-85
569	95	2025-09-30 00:00:00	99.85	4806.59	дизель	123592	АЗС-98
570	31	2025-11-29 00:00:00	210.42	10026.77	бензин	348897	АЗС-98
571	64	2025-09-03 00:00:00	357.15	17503.69	бензин	431812	АЗС-91
572	6	2025-11-21 00:00:00	484.95	27036.82	дизель	416797	АЗС-96
573	28	2025-11-27 00:00:00	316.81	14980.10	дизель	109699	АЗС-68
574	8	2025-12-28 00:00:00	57.24	3013.44	бензин	410034	АЗС-30
575	49	2025-08-12 00:00:00	426.34	20576.38	дизель	379625	АЗС-97
576	20	2025-09-25 00:00:00	111.72	5820.52	дизель	96007	АЗС-50
577	57	2025-11-22 00:00:00	420.94	19401.57	дизель	190829	АЗС-25
578	23	2025-09-05 00:00:00	187.88	9348.07	дизель	148652	АЗС-72
579	15	2025-12-31 00:00:00	160.22	7616.45	бензин	172195	АЗС-69
580	25	2025-12-09 00:00:00	55.17	2625.54	бензин	250235	АЗС-28
581	64	2025-08-18 00:00:00	434.10	24670.68	бензин	84702	АЗС-49
582	13	2025-10-12 00:00:00	137.73	7060.75	дизель	343254	АЗС-6
583	56	2025-10-24 00:00:00	73.10	3441.47	дизель	112333	АЗС-79
584	3	2025-12-04 00:00:00	306.61	14041.45	дизель	220115	АЗС-3
585	29	2025-07-27 00:00:00	229.48	12750.22	дизель	437154	АЗС-25
586	68	2025-08-21 00:00:00	145.11	6937.83	дизель	186274	АЗС-8
587	91	2025-11-20 00:00:00	417.03	23408.34	дизель	68224	АЗС-16
588	81	2025-12-05 00:00:00	322.33	14595.59	дизель	394849	АЗС-34
589	22	2025-10-22 00:00:00	191.21	9079.53	дизель	113700	АЗС-41
590	85	2025-11-23 00:00:00	226.83	11234.30	дизель	87545	АЗС-10
591	82	2025-08-30 00:00:00	476.55	21727.22	дизель	128237	АЗС-49
592	31	2025-09-13 00:00:00	475.82	26736.70	бензин	483689	АЗС-64
593	28	2025-08-08 00:00:00	293.38	13720.10	дизель	410040	АЗС-36
594	43	2025-12-22 00:00:00	280.06	14570.24	дизель	387027	АЗС-98
595	9	2025-08-22 00:00:00	334.79	17081.69	дизель	325414	АЗС-10
596	63	2026-01-09 00:00:00	191.84	11088.34	бензин	348496	АЗС-17
597	44	2025-09-15 00:00:00	349.77	19117.10	дизель	445722	АЗС-28
598	69	2025-09-12 00:00:00	435.68	23059.48	бензин	150857	АЗС-73
599	73	2025-08-27 00:00:00	281.99	15769.24	дизель	355362	АЗС-82
600	46	2026-01-16 00:00:00	230.05	11421.49	бензин	130488	АЗС-9
\.


--
-- Data for Name: склады; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."склады" ("ид_склад", "название", "ид_город", "адрес_полный", "площадь_кв_м", "координаты_широта", "координаты_долгота", "телефон", "руководитель_фио", "дата_открытия", "вместимость_куб_м", "статус") FROM stdin;
21	Центральный склад Москва	1	г. Москва, МКАД 47-й км	5000.00	\N	\N	+74951234567	\N	2015-01-15	15000.00	работает
22	Склад "Северный" Москва	1	г. Москва, Дмитровское шоссе, д. 157	3000.00	\N	\N	+74951234568	\N	2018-06-20	9000.00	работает
23	Логистический центр СПб	2	г. СПб, Софийская ул., д. 14	4500.00	\N	\N	+78122345678	\N	2016-03-10	13500.00	работает
24	Склад "Сибирь" Новосибирск	3	г. Новосибирск, ул. Станционная, д. 62	3500.00	\N	\N	+73833456789	\N	2017-05-25	10500.00	работает
25	Распределительный центр Екатеринбург	4	г. Екатеринбург, Кольцовский тракт, д. 16	4000.00	\N	\N	+73434567890	\N	2016-09-15	12000.00	работает
26	Склад "Волга" Казань	5	г. Казань, пр. Победы, д. 208	2500.00	\N	\N	+78435678901	\N	2018-11-20	7500.00	работает
27	Логоцентр Нижний Новгород	6	г. Н.Новгород, Южное шоссе, д. 28	3200.00	\N	\N	+78316789012	\N	2017-02-18	9600.00	работает
28	Склад "Южный" Челябинск	7	г. Челябинск, Копейское шоссе, д. 64	2800.00	\N	\N	+73517890123	\N	2019-04-12	8400.00	работает
29	Распредцентр Самара	8	г. Самара, Московское шоссе, д. 290	3000.00	\N	\N	+78468901234	\N	2017-07-30	9000.00	работает
30	Склад "Сибирский" Омск	9	г. Омск, ул. 10 лет Октября, д. 195	2600.00	\N	\N	+73812012345	\N	2018-09-05	7800.00	работает
31	Логоцентр Ростов	10	г. Ростов-на-Дону, ул. Малиновского, д. 23б	3500.00	\N	\N	+78631123456	\N	2016-12-10	10500.00	работает
32	Склад "Урал" Уфа	11	г. Уфа, Индустриальное шоссе, д. 42	2900.00	\N	\N	+73472234567	\N	2017-10-25	8700.00	работает
33	Распредцентр Красноярск	12	г. Красноярск, ул. Северное шоссе, д. 17	3100.00	\N	\N	+73912345678	\N	2018-03-15	9300.00	работает
34	Склад "Центральный" Воронеж	13	г. Воронеж, ул. Остужева, д. 8	2700.00	\N	\N	+73472456789	\N	2019-01-20	8100.00	работает
35	Логоцентр Пермь	14	г. Пермь, Космонавтов шоссе, д. 111	3300.00	\N	\N	+73422567890	\N	2017-08-12	9900.00	работает
36	Склад "Волга" Волгоград	15	г. Волгоград, ул. Хиросимы, д. 18	2400.00	\N	\N	+78442678901	\N	2018-06-30	7200.00	работает
37	Распредцентр Краснодар	16	г. Краснодар, Тихорецкий тракт, д. 5	3600.00	\N	\N	+78612789012	\N	2016-11-18	10800.00	работает
38	Склад "Поволжье" Саратов	17	г. Саратов, ул. Большая Горная, д. 228	2500.00	\N	\N	+78452890123	\N	2019-02-25	7500.00	работает
39	Логоцентр Тюмень	18	г. Тюмень, Московский тракт, д. 149	2900.00	\N	\N	+73452901234	\N	2017-09-08	8700.00	работает
40	Склад "Автоград" Тольятти	19	г. Тольятти, Южное шоссе, д. 36	2200.00	\N	\N	+78482012345	\N	2018-12-15	6600.00	работает
\.


--
-- Data for Name: средство_и_маршруты; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."средство_и_маршруты" ("ид_средство_маршрут", "ид_средство", "ид_маршрут", "приоритет", "статус", "дата_начала_обслуживания", "дата_конца_обслуживания", "количество_рейсов", "средняя_скорость_км_ч", "общий_пробег_км") FROM stdin;
1	1	3	2	приостановлена	2025-02-04	\N	44	64.50	19703.00
2	1	23	4	активна	2024-05-05	\N	39	82.00	32461.00
3	2	28	3	активна	2025-02-23	\N	20	73.90	12791.00
4	2	18	4	приостановлена	2025-12-16	\N	11	73.70	41724.00
5	2	15	1	активна	2025-02-18	\N	7	68.40	24741.00
6	3	8	3	приостановлена	2025-08-09	\N	42	59.40	31587.00
7	3	15	5	активна	2024-08-30	\N	68	78.10	12882.00
8	4	40	3	завершена	2025-04-29	2025-09-13	42	74.60	48384.00
9	4	5	2	активна	2024-12-23	\N	63	57.40	47983.00
10	5	45	1	активна	2025-09-28	\N	65	52.60	11856.00
11	5	18	1	завершена	2025-08-19	2025-11-27	61	71.50	45793.00
12	5	16	5	приостановлена	2025-03-11	\N	90	66.40	17196.00
13	6	1	1	завершена	2024-08-07	2024-10-03	53	71.60	19294.00
14	6	44	5	активна	2024-03-13	\N	91	69.50	11142.00
15	7	45	3	завершена	2024-04-30	2024-10-26	36	65.00	11490.00
16	8	9	1	активна	2024-05-15	\N	7	56.60	46235.00
17	8	12	3	активна	2025-04-07	\N	72	60.20	49621.00
18	8	35	5	приостановлена	2025-04-24	\N	44	66.60	8560.00
19	9	24	1	завершена	2025-06-27	2025-10-07	35	50.00	37350.00
20	9	29	2	активна	2024-12-11	\N	7	54.90	43174.00
21	10	5	2	завершена	2024-10-14	2025-03-15	9	69.10	14737.00
22	11	29	1	приостановлена	2025-06-04	\N	90	61.00	25738.00
23	11	32	5	активна	2025-09-04	\N	61	78.70	13532.00
24	11	37	4	активна	2024-03-15	\N	95	70.30	13587.00
25	12	38	4	приостановлена	2024-04-01	\N	80	53.30	11794.00
26	12	50	4	приостановлена	2025-04-18	\N	91	74.20	44069.00
27	13	32	4	завершена	2025-08-20	2025-10-09	40	51.40	39480.00
28	13	25	2	активна	2025-01-18	\N	50	79.50	45851.00
29	14	14	4	активна	2024-08-06	\N	62	64.30	49176.00
30	14	32	4	активна	2024-03-02	\N	22	82.90	34878.00
31	14	7	1	приостановлена	2024-11-09	\N	60	74.90	41112.00
32	15	24	5	активна	2025-09-07	\N	67	50.10	14401.00
33	16	44	1	активна	2024-08-07	\N	91	61.20	7829.00
34	16	39	5	приостановлена	2024-09-07	\N	57	62.10	38327.00
35	16	36	4	завершена	2024-07-28	2024-12-08	53	54.30	15503.00
36	17	37	3	активна	2025-04-04	\N	13	84.70	7853.00
37	17	48	4	активна	2024-04-16	\N	22	51.80	11242.00
38	18	1	4	активна	2025-07-25	\N	92	71.00	8581.00
39	18	41	1	завершена	2025-10-11	2025-12-26	33	57.00	13517.00
40	18	31	1	приостановлена	2024-07-26	\N	30	60.30	48894.00
41	19	17	5	активна	2025-06-22	\N	62	52.20	48898.00
42	20	1	2	активна	2024-11-10	\N	5	63.90	12566.00
43	20	35	2	активна	2024-10-14	\N	11	75.80	13838.00
44	20	39	1	активна	2025-01-27	\N	90	83.10	29667.00
45	21	32	5	активна	2025-09-09	\N	44	75.40	8935.00
46	22	1	4	завершена	2024-09-20	2025-01-25	55	76.80	46288.00
47	23	2	2	завершена	2024-05-24	2024-08-05	78	68.90	18061.00
48	24	30	4	активна	2025-06-15	\N	31	55.90	39489.00
49	25	11	3	активна	2025-01-19	\N	72	79.10	27432.00
50	25	29	4	завершена	2025-05-31	2025-07-05	87	51.20	34838.00
51	26	15	3	активна	2025-06-24	\N	59	54.70	32719.00
52	27	19	1	активна	2024-04-07	\N	39	81.70	38440.00
53	27	50	3	активна	2024-04-21	\N	75	53.30	42174.00
54	27	37	1	активна	2025-11-10	\N	84	84.20	45980.00
55	28	45	5	приостановлена	2024-09-09	\N	72	74.30	35605.00
56	29	20	1	активна	2024-05-27	\N	18	75.50	27906.00
57	30	3	4	активна	2024-02-14	\N	32	59.20	35205.00
58	30	42	2	завершена	2025-04-26	2025-05-26	20	62.20	22132.00
59	30	39	2	активна	2025-05-18	\N	26	65.70	37958.00
60	31	44	1	завершена	2025-01-16	2025-04-25	18	75.50	23405.00
61	31	34	3	завершена	2024-07-22	2024-10-08	69	51.80	37268.00
62	32	21	2	приостановлена	2024-05-27	\N	48	70.30	8281.00
63	32	8	1	завершена	2025-10-22	2026-02-23	72	84.80	11191.00
64	32	14	4	активна	2024-12-19	\N	46	64.00	49335.00
65	33	42	5	приостановлена	2024-09-20	\N	29	82.60	9558.00
66	33	22	5	активна	2024-09-06	\N	21	80.40	9364.00
67	33	46	5	активна	2025-05-02	\N	44	77.00	21126.00
68	34	35	4	активна	2024-06-03	\N	91	74.10	48969.00
69	34	19	3	приостановлена	2024-02-17	\N	61	83.10	47659.00
70	35	12	1	приостановлена	2025-01-11	\N	55	79.80	46602.00
71	36	6	3	активна	2025-11-01	\N	58	78.20	28137.00
72	36	7	4	активна	2024-08-13	\N	23	76.60	31803.00
73	37	29	2	активна	2024-12-09	\N	82	69.20	45631.00
74	38	14	3	активна	2024-02-11	\N	34	79.90	10459.00
75	39	7	5	активна	2025-01-14	\N	76	50.40	21372.00
76	39	24	3	завершена	2025-01-30	2025-06-18	8	63.90	36276.00
77	39	50	5	завершена	2025-12-17	2026-04-21	13	80.80	15355.00
78	40	7	5	завершена	2025-09-30	2026-03-12	10	69.70	18286.00
79	41	18	1	активна	2024-07-22	\N	78	73.80	27272.00
80	41	14	3	активна	2024-03-31	\N	36	63.40	42543.00
81	41	31	1	активна	2024-06-14	\N	58	72.10	6954.00
82	42	18	4	активна	2025-11-24	\N	94	53.00	12415.00
83	42	12	4	активна	2025-09-11	\N	84	56.40	49202.00
84	42	5	5	активна	2025-11-29	\N	33	77.00	11600.00
85	43	21	2	завершена	2025-08-10	2025-09-22	64	66.80	30296.00
86	44	5	1	активна	2025-11-30	\N	47	64.30	44077.00
87	44	43	3	приостановлена	2025-09-29	\N	97	74.10	6687.00
88	45	38	5	активна	2024-07-23	\N	80	63.60	43506.00
89	46	12	3	завершена	2025-04-17	2025-05-29	48	59.50	28805.00
90	47	29	4	активна	2025-06-28	\N	26	52.60	13570.00
91	47	27	1	активна	2024-12-27	\N	9	77.60	46396.00
92	47	28	4	завершена	2025-01-27	2025-05-28	64	57.10	46776.00
93	48	19	5	активна	2024-12-11	\N	22	71.70	5326.00
94	48	5	4	активна	2024-11-11	\N	18	80.90	12114.00
95	48	20	1	завершена	2025-01-29	2025-06-13	18	54.60	6808.00
96	49	40	1	приостановлена	2025-12-12	\N	93	75.20	36942.00
97	50	44	5	приостановлена	2025-05-14	\N	50	75.70	24353.00
98	51	18	2	приостановлена	2024-06-12	\N	71	65.80	7197.00
99	52	34	4	завершена	2025-01-22	2025-05-20	48	60.50	39451.00
100	53	14	3	активна	2025-04-22	\N	90	76.30	39681.00
101	54	6	2	завершена	2024-09-07	2024-10-21	74	60.70	12733.00
102	55	6	5	активна	2025-05-30	\N	75	61.10	30450.00
103	55	11	5	приостановлена	2024-02-18	\N	30	54.60	40602.00
104	55	18	5	активна	2024-02-01	\N	33	77.30	45426.00
105	56	20	1	завершена	2024-03-10	2024-07-12	60	67.40	39695.00
106	57	44	3	завершена	2024-02-15	2024-03-27	51	59.00	40536.00
107	58	22	3	завершена	2024-06-21	2024-11-10	16	64.30	32228.00
108	59	8	5	активна	2024-08-16	\N	61	67.00	41819.00
109	59	18	1	приостановлена	2024-09-23	\N	24	57.80	41150.00
110	59	31	1	активна	2025-01-17	\N	92	69.70	23065.00
111	60	23	3	завершена	2025-10-11	2026-03-24	90	71.70	43006.00
112	60	3	1	активна	2025-10-20	\N	91	79.40	48344.00
113	61	38	3	активна	2025-12-10	\N	16	54.70	12846.00
114	61	6	2	активна	2025-12-16	\N	98	82.40	15334.00
115	61	31	5	завершена	2024-08-27	2025-01-03	89	57.10	25841.00
116	62	22	1	активна	2024-12-01	\N	30	69.60	34280.00
117	63	9	4	активна	2024-10-08	\N	80	83.30	41152.00
118	64	23	4	активна	2024-11-01	\N	79	77.10	15163.00
119	65	47	2	активна	2025-02-04	\N	77	62.40	37027.00
120	65	4	5	приостановлена	2024-09-15	\N	52	59.60	13950.00
121	66	22	5	завершена	2025-01-01	2025-03-02	65	76.10	21226.00
122	67	30	2	завершена	2025-02-10	2025-05-19	83	84.00	14887.00
123	67	48	2	активна	2024-12-17	\N	11	64.50	40873.00
124	67	20	4	активна	2025-06-12	\N	16	77.70	7851.00
125	68	23	2	завершена	2024-08-16	2024-12-19	99	55.90	5582.00
126	69	20	5	активна	2024-04-16	\N	44	76.40	17760.00
127	69	23	3	активна	2025-07-15	\N	70	52.30	36424.00
128	70	26	3	активна	2024-08-17	\N	15	61.60	36395.00
129	70	38	4	завершена	2025-03-26	2025-07-30	14	72.90	28575.00
130	71	29	5	активна	2025-06-22	\N	86	55.70	40513.00
131	72	5	5	завершена	2024-06-11	2024-07-27	71	63.00	12263.00
132	73	44	2	завершена	2025-01-01	2025-05-19	34	76.50	48360.00
133	73	24	5	активна	2024-07-25	\N	13	78.30	18029.00
134	74	9	3	приостановлена	2024-05-18	\N	71	55.40	7082.00
135	74	48	5	активна	2025-09-21	\N	61	79.70	20476.00
136	74	45	3	завершена	2025-12-19	2026-05-16	91	82.60	10993.00
137	75	21	2	приостановлена	2025-03-03	\N	76	68.10	24522.00
138	76	7	2	активна	2025-10-21	\N	18	74.60	24092.00
139	77	41	1	завершена	2025-03-20	2025-05-12	64	77.00	34097.00
140	77	34	5	завершена	2024-02-11	2024-06-29	94	51.20	28783.00
141	77	47	4	активна	2024-05-13	\N	20	50.30	33699.00
142	78	20	2	завершена	2024-02-26	2024-05-14	32	69.30	46927.00
143	79	2	1	завершена	2024-02-17	2024-07-23	14	72.90	37790.00
144	79	3	3	активна	2024-11-11	\N	51	81.00	42659.00
145	79	5	1	приостановлена	2025-02-01	\N	72	71.50	28517.00
146	80	2	4	приостановлена	2024-03-07	\N	49	60.80	20085.00
147	80	41	3	завершена	2025-09-29	2026-03-13	10	82.80	45184.00
148	80	44	1	активна	2024-03-19	\N	53	59.10	22778.00
149	81	41	3	активна	2024-06-09	\N	69	53.00	6040.00
150	81	2	3	завершена	2024-10-17	2025-01-01	39	79.80	22666.00
151	81	4	3	приостановлена	2025-12-15	\N	12	53.70	7618.00
152	82	42	2	активна	2025-10-20	\N	98	74.30	15354.00
153	82	1	4	приостановлена	2025-12-20	\N	20	58.90	11317.00
154	83	19	4	завершена	2025-03-24	2025-09-20	11	63.40	6886.00
155	83	8	5	приостановлена	2025-07-04	\N	11	61.20	43989.00
156	84	28	1	приостановлена	2025-08-22	\N	26	69.60	25502.00
157	85	39	1	активна	2024-10-22	\N	91	50.50	29040.00
158	86	42	4	активна	2025-04-25	\N	12	52.50	26046.00
159	87	11	1	активна	2024-02-19	\N	23	72.60	41925.00
160	88	26	3	завершена	2025-03-05	2025-04-16	57	71.20	6183.00
161	88	13	3	завершена	2024-11-04	2025-02-14	94	71.40	23944.00
162	88	14	1	активна	2025-10-23	\N	61	50.50	40685.00
163	89	31	2	приостановлена	2024-06-02	\N	37	71.30	43754.00
164	90	28	4	приостановлена	2025-07-10	\N	77	59.00	43017.00
165	91	37	3	завершена	2025-08-14	2025-10-05	77	54.50	29398.00
166	91	29	4	активна	2024-08-27	\N	69	80.20	32729.00
167	92	30	1	завершена	2025-06-02	2025-10-10	76	80.30	33174.00
168	92	12	1	активна	2024-03-24	\N	68	60.20	30364.00
169	92	5	1	завершена	2024-05-28	2024-08-17	49	62.50	19475.00
170	93	7	5	активна	2024-07-09	\N	91	75.70	27534.00
171	94	42	2	приостановлена	2024-06-28	\N	12	67.00	28675.00
172	95	5	5	завершена	2024-09-19	2024-12-15	28	57.10	48261.00
173	96	1	1	активна	2024-01-24	\N	82	79.40	12694.00
174	96	38	5	активна	2024-08-24	\N	32	52.50	9178.00
175	97	7	1	активна	2024-02-23	\N	63	84.50	28760.00
176	97	28	3	приостановлена	2025-09-08	\N	66	79.80	20326.00
177	97	8	4	приостановлена	2024-12-12	\N	17	56.70	46104.00
178	98	10	4	активна	2024-06-18	\N	73	72.50	17115.00
179	98	6	3	приостановлена	2024-02-02	\N	83	84.10	38873.00
180	99	3	1	приостановлена	2025-07-22	\N	49	57.10	41745.00
181	100	6	3	приостановлена	2025-07-29	\N	64	68.60	48362.00
182	100	1	2	завершена	2024-02-05	2024-06-25	51	64.60	5426.00
\.


--
-- Data for Name: статусы_заказов; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."статусы_заказов" ("ид_статус", "код_статуса", "наименование", "описание", "цвет_индикатора", "порядок_сортировки") FROM stdin;
1	новый	Новый заказ	Груз только что создан в системе	#3498db	1
2	принят	Принят в работу	Груз принят диспетчером	#f39c12	2
3	на_складе	На складе отправления	Груз находится на складе отправки	#9b59b6	3
4	в_пути	В пути	Груз в процессе транспортировки	#e67e22	4
5	на_складе_назначения	На складе назначения	Груз прибыл на склад назначения	#1abc9c	5
6	доставлен	Доставлен	Груз успешно доставлен получателю	#27ae60	6
7	отменен	Отменен	Доставка отменена	#e74c3c	7
\.


--
-- Data for Name: техническое_обслуживание; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."техническое_обслуживание" ("ид_то", "ид_средство", "дата_начала", "дата_окончания", "тип_обслуживания", "описание_работ", "стоимость_руб", "исполнитель", "статус") FROM stdin;
1	56	2025-02-08 00:00:00	\N	Ремонт	Ремонт	6312.95	СТО-4	запланировано
2	91	2025-07-21 00:00:00	2025-07-23 00:00:00	Диагностика	Диагностика	9262.23	СТО-3	выполнено
3	73	2025-10-26 00:00:00	2025-10-31 00:00:00	Диагностика	Диагностика	33046.39	СТО-10	выполнено
4	81	2025-07-17 00:00:00	\N	Плановое ТО	Плановое ТО	15793.51	СТО-1	запланировано
5	77	2025-12-24 00:00:00	\N	Ремонт	Ремонт	14555.98	СТО-1	в_процессе
6	95	2025-09-24 00:00:00	2025-09-26 00:00:00	Диагностика	Диагностика	6841.10	СТО-7	выполнено
7	80	2025-06-22 00:00:00	2025-06-27 00:00:00	Диагностика	Диагностика	49960.03	СТО-8	выполнено
8	37	2025-02-23 00:00:00	\N	Диагностика	Диагностика	24873.82	СТО-8	в_процессе
9	41	2025-10-08 00:00:00	2025-10-14 00:00:00	Плановое ТО	Плановое ТО	4192.05	СТО-9	выполнено
10	35	2025-10-18 00:00:00	2025-10-24 00:00:00	Диагностика	Диагностика	30318.20	СТО-8	выполнено
11	83	2025-09-22 00:00:00	\N	Диагностика	Диагностика	12832.83	СТО-3	в_процессе
12	49	2025-02-27 00:00:00	\N	Диагностика	Диагностика	31802.62	СТО-5	запланировано
13	67	2025-03-30 00:00:00	2025-04-01 00:00:00	Плановое ТО	Плановое ТО	40091.66	СТО-1	выполнено
14	8	2025-12-28 00:00:00	2025-12-31 00:00:00	Диагностика	Диагностика	10444.09	СТО-9	выполнено
15	100	2025-05-30 00:00:00	2025-06-06 00:00:00	Плановое ТО	Плановое ТО	19207.48	СТО-9	выполнено
16	77	2025-05-07 00:00:00	\N	Диагностика	Диагностика	29332.01	СТО-10	в_процессе
17	18	2025-05-17 00:00:00	2025-05-23 00:00:00	Плановое ТО	Плановое ТО	38015.33	СТО-8	выполнено
18	59	2025-09-23 00:00:00	2025-09-30 00:00:00	Диагностика	Диагностика	25343.20	СТО-4	выполнено
19	75	2025-11-27 00:00:00	\N	Ремонт	Ремонт	48959.84	СТО-8	запланировано
20	60	2025-05-17 00:00:00	\N	Диагностика	Диагностика	18545.78	СТО-10	в_процессе
21	1	2025-04-29 00:00:00	\N	Диагностика	Диагностика	39006.07	СТО-2	запланировано
22	21	2025-05-31 00:00:00	\N	Диагностика	Диагностика	18027.79	СТО-6	в_процессе
23	55	2025-03-13 00:00:00	\N	Диагностика	Диагностика	39777.65	СТО-4	запланировано
24	23	2025-02-07 00:00:00	2025-02-08 00:00:00	Плановое ТО	Плановое ТО	20229.08	СТО-10	выполнено
25	41	2025-10-03 00:00:00	2025-10-07 00:00:00	Ремонт	Ремонт	6997.66	СТО-8	выполнено
26	10	2025-11-03 00:00:00	2025-11-10 00:00:00	Ремонт	Ремонт	31463.46	СТО-9	выполнено
27	68	2025-04-11 00:00:00	2025-04-16 00:00:00	Ремонт	Ремонт	44754.08	СТО-9	выполнено
28	88	2025-04-25 00:00:00	2025-04-27 00:00:00	Плановое ТО	Плановое ТО	16886.74	СТО-4	выполнено
29	18	2025-05-06 00:00:00	\N	Ремонт	Ремонт	44169.78	СТО-6	запланировано
30	79	2026-01-12 00:00:00	\N	Диагностика	Диагностика	16455.36	СТО-7	в_процессе
31	41	2025-11-15 00:00:00	\N	Ремонт	Ремонт	5550.93	СТО-2	запланировано
32	82	2025-08-19 00:00:00	2025-08-23 00:00:00	Диагностика	Диагностика	22750.64	СТО-10	выполнено
33	2	2025-04-23 00:00:00	\N	Плановое ТО	Плановое ТО	7313.63	СТО-4	запланировано
34	80	2025-07-21 00:00:00	2025-07-25 00:00:00	Плановое ТО	Плановое ТО	39260.33	СТО-3	выполнено
35	82	2025-04-09 00:00:00	\N	Ремонт	Ремонт	34997.20	СТО-3	в_процессе
36	94	2025-07-08 00:00:00	2025-07-09 00:00:00	Ремонт	Ремонт	40595.52	СТО-3	выполнено
37	80	2025-07-26 00:00:00	\N	Диагностика	Диагностика	12574.52	СТО-6	запланировано
38	51	2026-01-11 00:00:00	2026-01-13 00:00:00	Плановое ТО	Плановое ТО	18744.47	СТО-5	выполнено
39	3	2025-03-12 00:00:00	\N	Ремонт	Ремонт	10478.61	СТО-7	запланировано
40	37	2025-08-22 00:00:00	2025-08-28 00:00:00	Диагностика	Диагностика	31305.38	СТО-5	выполнено
41	58	2025-07-07 00:00:00	2025-07-14 00:00:00	Диагностика	Диагностика	19924.98	СТО-9	выполнено
42	72	2025-04-28 00:00:00	2025-05-05 00:00:00	Диагностика	Диагностика	8569.23	СТО-8	выполнено
43	29	2025-03-12 00:00:00	\N	Диагностика	Диагностика	40080.30	СТО-6	в_процессе
44	64	2025-08-10 00:00:00	\N	Плановое ТО	Плановое ТО	18842.04	СТО-4	запланировано
45	73	2025-07-12 00:00:00	2025-07-13 00:00:00	Ремонт	Ремонт	34601.25	СТО-3	выполнено
46	10	2025-02-24 00:00:00	\N	Диагностика	Диагностика	42714.68	СТО-7	в_процессе
47	76	2025-10-06 00:00:00	2025-10-13 00:00:00	Ремонт	Ремонт	17173.01	СТО-2	выполнено
48	71	2025-08-17 00:00:00	\N	Плановое ТО	Плановое ТО	15204.13	СТО-2	запланировано
49	80	2025-11-18 00:00:00	2025-11-23 00:00:00	Ремонт	Ремонт	41146.58	СТО-7	выполнено
50	73	2025-09-06 00:00:00	\N	Диагностика	Диагностика	24977.83	СТО-2	запланировано
51	85	2025-06-20 00:00:00	\N	Диагностика	Диагностика	23312.18	СТО-1	в_процессе
52	9	2025-07-03 00:00:00	\N	Диагностика	Диагностика	7034.05	СТО-2	запланировано
53	82	2025-10-29 00:00:00	\N	Ремонт	Ремонт	24051.34	СТО-5	запланировано
54	94	2025-09-15 00:00:00	2025-09-20 00:00:00	Ремонт	Ремонт	31826.76	СТО-4	выполнено
55	6	2025-12-17 00:00:00	\N	Плановое ТО	Плановое ТО	10592.13	СТО-4	в_процессе
56	52	2025-01-26 00:00:00	2025-02-02 00:00:00	Ремонт	Ремонт	4395.19	СТО-5	выполнено
57	7	2025-09-06 00:00:00	2025-09-13 00:00:00	Плановое ТО	Плановое ТО	47866.75	СТО-7	выполнено
58	81	2025-10-19 00:00:00	\N	Диагностика	Диагностика	13331.35	СТО-4	запланировано
59	4	2025-11-27 00:00:00	2025-11-29 00:00:00	Ремонт	Ремонт	27515.24	СТО-9	выполнено
60	33	2025-05-26 00:00:00	2025-05-28 00:00:00	Ремонт	Ремонт	9508.18	СТО-8	выполнено
61	81	2025-02-23 00:00:00	2025-02-25 00:00:00	Плановое ТО	Плановое ТО	37390.97	СТО-6	выполнено
62	13	2025-05-25 00:00:00	\N	Плановое ТО	Плановое ТО	8382.04	СТО-9	в_процессе
63	67	2025-11-30 00:00:00	\N	Ремонт	Ремонт	5806.13	СТО-1	запланировано
64	75	2025-02-25 00:00:00	\N	Ремонт	Ремонт	42015.08	СТО-8	в_процессе
65	1	2025-08-01 00:00:00	2025-08-08 00:00:00	Ремонт	Ремонт	11138.11	СТО-5	выполнено
66	59	2025-09-14 00:00:00	2025-09-15 00:00:00	Плановое ТО	Плановое ТО	39121.66	СТО-8	выполнено
67	73	2025-08-11 00:00:00	2025-08-14 00:00:00	Ремонт	Ремонт	8290.79	СТО-4	выполнено
68	42	2025-07-08 00:00:00	\N	Плановое ТО	Плановое ТО	6631.78	СТО-5	запланировано
69	80	2025-08-10 00:00:00	2025-08-15 00:00:00	Плановое ТО	Плановое ТО	11424.03	СТО-8	выполнено
70	58	2025-11-20 00:00:00	\N	Ремонт	Ремонт	15946.12	СТО-4	запланировано
71	35	2025-02-08 00:00:00	\N	Диагностика	Диагностика	39189.63	СТО-5	в_процессе
72	25	2025-04-01 00:00:00	2025-04-07 00:00:00	Ремонт	Ремонт	4623.35	СТО-1	выполнено
73	46	2025-10-22 00:00:00	2025-10-26 00:00:00	Диагностика	Диагностика	4780.77	СТО-7	выполнено
74	93	2025-10-24 00:00:00	2025-10-30 00:00:00	Плановое ТО	Плановое ТО	4954.49	СТО-6	выполнено
75	33	2026-01-14 00:00:00	2026-01-19 00:00:00	Ремонт	Ремонт	4532.29	СТО-4	выполнено
76	9	2025-03-17 00:00:00	2025-03-18 00:00:00	Ремонт	Ремонт	26492.88	СТО-2	выполнено
77	1	2025-06-19 00:00:00	2025-06-22 00:00:00	Ремонт	Ремонт	42944.42	СТО-2	выполнено
78	69	2025-01-26 00:00:00	2025-02-01 00:00:00	Диагностика	Диагностика	49736.44	СТО-5	выполнено
79	1	2025-02-10 00:00:00	\N	Плановое ТО	Плановое ТО	43603.37	СТО-5	запланировано
80	62	2025-05-15 00:00:00	\N	Плановое ТО	Плановое ТО	38927.50	СТО-1	в_процессе
81	5	2025-06-30 00:00:00	2025-07-07 00:00:00	Плановое ТО	Плановое ТО	33936.62	СТО-3	выполнено
82	45	2025-10-27 00:00:00	2025-11-02 00:00:00	Плановое ТО	Плановое ТО	8274.13	СТО-1	выполнено
83	88	2025-11-04 00:00:00	\N	Ремонт	Ремонт	18624.40	СТО-2	в_процессе
84	31	2025-11-14 00:00:00	2025-11-17 00:00:00	Диагностика	Диагностика	17142.54	СТО-2	выполнено
85	23	2025-11-16 00:00:00	\N	Диагностика	Диагностика	39738.61	СТО-10	в_процессе
86	22	2025-10-26 00:00:00	2025-11-01 00:00:00	Ремонт	Ремонт	33932.74	СТО-2	выполнено
87	93	2025-06-10 00:00:00	2025-06-13 00:00:00	Плановое ТО	Плановое ТО	19558.24	СТО-7	выполнено
88	81	2025-05-30 00:00:00	2025-06-02 00:00:00	Ремонт	Ремонт	5466.90	СТО-1	выполнено
89	74	2025-02-20 00:00:00	\N	Диагностика	Диагностика	36219.23	СТО-4	запланировано
90	60	2025-03-13 00:00:00	\N	Диагностика	Диагностика	44014.33	СТО-4	запланировано
91	71	2026-01-01 00:00:00	\N	Плановое ТО	Плановое ТО	28912.77	СТО-10	в_процессе
92	70	2025-06-10 00:00:00	2025-06-11 00:00:00	Диагностика	Диагностика	6825.78	СТО-1	выполнено
93	95	2026-01-04 00:00:00	\N	Ремонт	Ремонт	15999.00	СТО-9	запланировано
94	90	2025-08-17 00:00:00	\N	Ремонт	Ремонт	44322.63	СТО-2	запланировано
95	43	2025-12-14 00:00:00	2025-12-17 00:00:00	Ремонт	Ремонт	40054.38	СТО-2	выполнено
96	83	2025-05-12 00:00:00	2025-05-19 00:00:00	Плановое ТО	Плановое ТО	24919.04	СТО-10	выполнено
97	73	2026-01-08 00:00:00	\N	Ремонт	Ремонт	36723.69	СТО-3	запланировано
98	9	2025-07-28 00:00:00	2025-07-31 00:00:00	Диагностика	Диагностика	4390.75	СТО-5	выполнено
99	42	2025-07-23 00:00:00	2025-07-30 00:00:00	Ремонт	Ремонт	47570.78	СТО-3	выполнено
100	48	2025-02-27 00:00:00	2025-02-28 00:00:00	Ремонт	Ремонт	34840.77	СТО-3	выполнено
101	17	2025-03-26 00:00:00	2025-03-28 00:00:00	Диагностика	Диагностика	23517.40	СТО-7	выполнено
102	91	2025-03-17 00:00:00	2025-03-21 00:00:00	Плановое ТО	Плановое ТО	49890.49	СТО-3	выполнено
103	36	2026-01-06 00:00:00	\N	Ремонт	Ремонт	27715.25	СТО-3	в_процессе
104	5	2025-06-12 00:00:00	\N	Ремонт	Ремонт	37577.35	СТО-8	в_процессе
105	90	2026-01-11 00:00:00	2026-01-17 00:00:00	Плановое ТО	Плановое ТО	48586.62	СТО-9	выполнено
106	33	2025-02-15 00:00:00	\N	Плановое ТО	Плановое ТО	48412.96	СТО-8	в_процессе
107	87	2025-09-26 00:00:00	2025-09-28 00:00:00	Ремонт	Ремонт	14653.88	СТО-9	выполнено
108	64	2025-07-19 00:00:00	2025-07-20 00:00:00	Диагностика	Диагностика	28567.46	СТО-8	выполнено
109	60	2025-03-22 00:00:00	2025-03-25 00:00:00	Плановое ТО	Плановое ТО	26404.11	СТО-9	выполнено
110	1	2025-10-01 00:00:00	\N	Диагностика	Диагностика	7295.78	СТО-9	в_процессе
111	29	2025-08-07 00:00:00	\N	Диагностика	Диагностика	24993.10	СТО-6	в_процессе
112	80	2025-05-24 00:00:00	2025-05-28 00:00:00	Ремонт	Ремонт	19178.18	СТО-10	выполнено
113	46	2025-04-26 00:00:00	\N	Ремонт	Ремонт	42493.47	СТО-6	в_процессе
114	79	2025-03-10 00:00:00	2025-03-16 00:00:00	Ремонт	Ремонт	7187.19	СТО-4	выполнено
115	80	2025-06-20 00:00:00	2025-06-21 00:00:00	Плановое ТО	Плановое ТО	27351.52	СТО-6	выполнено
116	84	2025-07-23 00:00:00	2025-07-27 00:00:00	Ремонт	Ремонт	15930.51	СТО-5	выполнено
117	57	2025-10-27 00:00:00	2025-11-03 00:00:00	Ремонт	Ремонт	36428.61	СТО-9	выполнено
118	16	2025-10-11 00:00:00	2025-10-12 00:00:00	Диагностика	Диагностика	12248.32	СТО-5	выполнено
119	72	2025-03-12 00:00:00	\N	Плановое ТО	Плановое ТО	46636.48	СТО-4	в_процессе
120	1	2025-05-12 00:00:00	2025-05-14 00:00:00	Диагностика	Диагностика	17933.94	СТО-8	выполнено
121	38	2025-07-03 00:00:00	\N	Ремонт	Ремонт	29760.10	СТО-7	в_процессе
122	88	2025-04-23 00:00:00	\N	Плановое ТО	Плановое ТО	47842.03	СТО-6	запланировано
123	94	2025-10-30 00:00:00	2025-11-06 00:00:00	Плановое ТО	Плановое ТО	20896.30	СТО-6	выполнено
124	23	2025-03-06 00:00:00	2025-03-10 00:00:00	Плановое ТО	Плановое ТО	5060.14	СТО-5	выполнено
125	66	2025-05-12 00:00:00	\N	Диагностика	Диагностика	13223.78	СТО-6	запланировано
126	97	2025-02-24 00:00:00	2025-02-27 00:00:00	Плановое ТО	Плановое ТО	4533.74	СТО-2	выполнено
127	85	2026-01-04 00:00:00	\N	Ремонт	Ремонт	5295.81	СТО-8	запланировано
128	62	2025-04-22 00:00:00	\N	Диагностика	Диагностика	12747.72	СТО-1	запланировано
129	83	2025-03-28 00:00:00	2025-03-31 00:00:00	Ремонт	Ремонт	25775.19	СТО-4	выполнено
130	55	2025-12-24 00:00:00	\N	Ремонт	Ремонт	20711.08	СТО-7	в_процессе
131	2	2025-07-14 00:00:00	2025-07-19 00:00:00	Ремонт	Ремонт	44390.30	СТО-10	выполнено
132	61	2025-02-08 00:00:00	\N	Плановое ТО	Плановое ТО	36543.56	СТО-3	в_процессе
133	89	2025-12-21 00:00:00	2025-12-23 00:00:00	Плановое ТО	Плановое ТО	31121.57	СТО-3	выполнено
134	32	2025-05-29 00:00:00	\N	Плановое ТО	Плановое ТО	46966.60	СТО-3	запланировано
135	34	2025-10-28 00:00:00	\N	Ремонт	Ремонт	6520.44	СТО-2	запланировано
136	38	2025-04-27 00:00:00	2025-04-30 00:00:00	Диагностика	Диагностика	38043.37	СТО-9	выполнено
137	69	2025-05-12 00:00:00	2025-05-13 00:00:00	Плановое ТО	Плановое ТО	36827.85	СТО-4	выполнено
138	10	2025-10-08 00:00:00	2025-10-14 00:00:00	Плановое ТО	Плановое ТО	33258.30	СТО-4	выполнено
139	84	2025-12-16 00:00:00	2025-12-22 00:00:00	Диагностика	Диагностика	8166.89	СТО-6	выполнено
140	71	2025-04-03 00:00:00	2025-04-05 00:00:00	Ремонт	Ремонт	15498.12	СТО-1	выполнено
141	83	2025-11-05 00:00:00	2025-11-07 00:00:00	Плановое ТО	Плановое ТО	48317.73	СТО-3	выполнено
142	79	2025-06-30 00:00:00	\N	Ремонт	Ремонт	23342.84	СТО-4	в_процессе
143	72	2025-03-14 00:00:00	\N	Ремонт	Ремонт	38831.58	СТО-10	запланировано
144	100	2025-04-18 00:00:00	2025-04-19 00:00:00	Ремонт	Ремонт	32358.67	СТО-3	выполнено
145	8	2025-04-20 00:00:00	2025-04-27 00:00:00	Ремонт	Ремонт	8630.62	СТО-9	выполнено
146	58	2025-01-30 00:00:00	2025-02-01 00:00:00	Плановое ТО	Плановое ТО	35263.45	СТО-2	выполнено
147	22	2025-06-09 00:00:00	\N	Диагностика	Диагностика	21236.14	СТО-8	запланировано
148	43	2025-04-10 00:00:00	2025-04-11 00:00:00	Диагностика	Диагностика	40837.81	СТО-7	выполнено
149	64	2025-08-14 00:00:00	2025-08-18 00:00:00	Плановое ТО	Плановое ТО	40697.72	СТО-3	выполнено
150	75	2025-11-02 00:00:00	2025-11-05 00:00:00	Плановое ТО	Плановое ТО	13047.99	СТО-10	выполнено
\.


--
-- Data for Name: типы_средств_доставки; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."типы_средств_доставки" ("ид_тип_средства", "наименование", "грузоподъемность_кг", "объем_куб_м", "топливо_тип", "дата_создания") FROM stdin;
21	Газель 3302 (тент)	1500.00	12.00	бензин	2026-01-21 19:43:43.936023
22	Газель Next (фургон)	1500.00	14.00	дизель	2026-01-21 19:43:43.936023
23	КАМАЗ 5320 (бортовой)	8000.00	30.00	дизель	2026-01-21 19:43:43.936023
24	КАМАЗ 65117 (самосвал)	15000.00	12.00	дизель	2026-01-21 19:43:43.936023
25	МАЗ 5440 (полуприцеп)	20000.00	82.00	дизель	2026-01-21 19:43:43.936023
26	МАЗ 6312 (рефрижератор)	10000.00	60.00	дизель	2026-01-21 19:43:43.936023
27	Hyundai Porter (будка)	1000.00	8.00	дизель	2026-01-21 19:43:43.936023
28	Isuzu ELF (изотерм)	3000.00	20.00	дизель	2026-01-21 19:43:43.936023
29	Volvo FH16 (тягач)	25000.00	90.00	дизель	2026-01-21 19:43:43.936023
30	Mercedes-Benz Sprinter	1200.00	11.00	дизель	2026-01-21 19:43:43.936023
\.


--
-- Data for Name: транспортные_средства; Type: TABLE DATA; Schema: public; Owner: logistics_admin
--

COPY public."транспортные_средства" ("ид_средство", "госномер", "ид_тип_средства", "ид_водитель", "год_выпуска", "марка", "модель", "цвет", "состояние", "дата_последнего_то", "статус", "дата_регистрации", "страховка_до", "пробег_км", "расход_топлива_л_100км", "стоимость_руб") FROM stdin;
102	Е775ЕЕ61	1	19	2023	Volvo	FH16	красный	удовлетворительное	2025-09-15	на_обслуживании	2019-12-22	2025-12-27	138409	24.80	3213320.80
103	А705КМ55	4	18	2019	МАЗ	6312	белый	удовлетворительное	2025-07-26	активен	2021-03-02	2026-06-24	217824	22.10	1587607.38
104	Х943ЕР78	7	\N	2016	Mercedes	Sprinter	черный	отличное	2025-09-25	на_обслуживании	2019-05-29	2027-01-12	109194	18.00	3151883.05
105	К630МВ66	1	17	2016	Volvo	FH16	красный	хорошее	2025-09-23	на_обслуживании	2020-05-07	2025-12-25	128314	32.60	1895393.11
106	Т674АА55	1	7	2017	КАМАЗ	5320	синий	хорошее	2025-11-02	активен	2022-12-20	2026-11-27	84724	31.40	2250246.63
107	Р311РХ52	10	\N	2022	Mercedes	Sprinter	черный	хорошее	2025-12-11	активен	2018-05-15	2026-09-15	237207	15.80	842989.32
108	М141АЕ63	8	\N	2024	МАЗ	6312	белый	хорошее	2025-01-25	активен	2020-03-14	2026-07-06	384235	20.90	3999622.10
109	Х943ХУ61	9	19	2024	МАЗ	5440	зеленый	удовлетворительное	2025-07-25	активен	2021-10-05	2026-04-21	426787	26.00	2022876.01
110	Р866НМ55	6	4	2025	Isuzu	ELF	белый	удовлетворительное	2025-12-06	активен	2023-07-26	2026-03-10	126430	27.40	1653378.12
111	Х159УА54	6	11	2015	Hyundai	Porter	серебристый	хорошее	2025-04-30	активен	2019-02-28	2026-09-08	434817	17.20	1115486.47
112	Н473ОХ63	4	12	2018	Hyundai	Porter	серебристый	отличное	2025-09-06	активен	2019-05-09	2026-06-22	220245	17.70	4118316.39
113	У940ТХ52	7	12	2023	Mercedes	Sprinter	черный	отличное	2025-02-17	активен	2018-04-29	2026-12-20	377005	26.50	2996527.73
114	Е134НО63	9	19	2021	КАМАЗ	5320	синий	хорошее	2025-04-07	активен	2023-09-24	2026-04-13	206537	21.70	4973872.06
115	У397ХК61	5	11	2021	Hyundai	Porter	серебристый	хорошее	2025-04-27	активен	2023-12-02	2026-07-05	359407	25.80	1533721.65
116	О671ОЕ54	6	21	2022	Isuzu	ELF	белый	удовлетворительное	2025-08-02	активен	2021-02-20	2026-04-23	369944	25.80	1176788.22
117	О238РР16	4	9	2016	Hyundai	Porter	серебристый	хорошее	2025-09-09	на_обслуживании	2020-05-23	2026-04-03	141171	31.50	3359776.76
118	У632АМ63	10	4	2018	Isuzu	ELF	белый	хорошее	2025-08-02	активен	2019-12-17	2026-11-09	58340	29.70	3699457.16
119	В149МС52	1	9	2015	КАМАЗ	65117	оранжевый	удовлетворительное	2025-10-14	активен	2018-06-19	2026-07-11	397906	33.20	3716758.99
120	Р733НН78	8	17	2015	Mercedes	Sprinter	черный	отличное	2025-07-12	активен	2020-11-05	2026-01-06	462112	26.60	2667393.14
121	Т374РС61	8	16	2017	МАЗ	6312	белый	отличное	2025-09-26	активен	2024-04-28	2026-06-18	356241	25.90	2297275.01
122	А349НА74	4	5	2017	МАЗ	5440	зеленый	хорошее	2025-09-18	активен	2024-02-05	2026-02-04	332569	26.30	2641951.71
123	М114РВ66	4	10	2015	ГАЗ	3302	белый	удовлетворительное	2025-05-10	активен	2018-02-08	2026-05-03	111359	26.10	1150255.30
124	К505УТ61	4	19	2023	МАЗ	5440	зеленый	отличное	2025-10-06	активен	2019-12-14	2026-09-05	288284	20.30	4190573.62
125	Т845ЕС77	1	2	2020	ГАЗ	Next	серый	хорошее	2025-05-04	на_обслуживании	2019-06-30	2026-12-18	227705	15.20	3969055.11
126	А243ОО66	10	1	2021	МАЗ	6312	белый	хорошее	2025-07-10	активен	2024-09-18	2026-10-18	442872	34.00	3170358.28
127	Е124ХУ55	7	24	2020	ГАЗ	Next	серый	отличное	2025-08-24	активен	2018-10-13	2026-12-23	316793	31.00	2856039.33
128	У775НТ54	10	5	2023	Hyundai	Porter	серебристый	хорошее	2025-10-19	на_обслуживании	2021-04-21	2026-11-17	244668	31.10	1033113.83
129	Е852АО63	3	18	2024	Isuzu	ELF	белый	удовлетворительное	2025-02-25	активен	2019-02-26	2026-04-08	171781	16.30	2759559.42
130	О419ОА16	4	20	2021	Isuzu	ELF	белый	отличное	2025-04-20	активен	2018-11-03	2026-11-20	400627	22.90	3716398.60
131	М771ТМ52	6	29	2016	МАЗ	5440	зеленый	отличное	2025-09-16	на_обслуживании	2018-06-01	2026-03-10	494299	23.80	1794617.08
132	У479ОА78	2	5	2018	Hyundai	Porter	серебристый	хорошее	2025-07-26	активен	2021-03-13	2026-09-12	391466	16.30	1095562.43
133	С300АР78	4	14	2022	Isuzu	ELF	белый	хорошее	2025-07-27	на_обслуживании	2020-12-22	2026-06-16	124763	26.90	649995.19
134	А340КХ78	7	2	2018	Volvo	FH16	красный	хорошее	2025-08-12	на_обслуживании	2019-09-26	2026-05-19	206078	29.20	4015730.92
135	Р755ОТ66	3	25	2020	МАЗ	6312	белый	хорошее	2025-09-21	активен	2024-09-20	2026-08-01	348715	21.00	1532443.19
136	Р309РС74	2	20	2023	ГАЗ	Next	серый	отличное	2025-06-13	на_обслуживании	2018-07-18	2026-08-05	330404	26.50	3896851.19
137	Н756ХУ55	6	7	2022	ГАЗ	3302	белый	хорошее	2025-09-04	активен	2023-02-17	2026-08-12	258509	25.80	3826454.23
138	Т192НВ54	9	\N	2022	Isuzu	ELF	белый	удовлетворительное	2025-03-16	активен	2024-10-21	2026-04-02	365507	16.70	2831992.37
139	Н548КА78	6	4	2018	ГАЗ	3302	белый	хорошее	2025-02-12	активен	2019-11-19	2026-05-14	235330	17.20	1983310.52
140	Т708СВ52	9	1	2025	КАМАЗ	5320	синий	удовлетворительное	2025-09-22	активен	2021-08-10	2026-12-03	272741	18.40	3619502.73
141	К471ОУ66	3	\N	2017	КАМАЗ	5320	синий	хорошее	2025-07-03	на_обслуживании	2019-04-24	2026-09-04	130108	27.40	1318832.22
142	С557ТВ54	8	25	2015	Volvo	FH16	красный	удовлетворительное	2025-10-08	активен	2019-07-10	2026-12-09	58155	15.70	518739.84
143	В169РМ78	3	30	2017	МАЗ	5440	зеленый	удовлетворительное	2025-10-25	активен	2020-06-28	2026-06-12	311943	25.20	3359765.45
144	Е169АН54	8	23	2019	Mercedes	Sprinter	черный	хорошее	2025-08-13	активен	2023-12-22	2026-08-17	402310	29.20	3252864.01
145	Е774УА52	3	\N	2019	Volvo	FH16	красный	удовлетворительное	2025-01-27	на_обслуживании	2020-04-21	2026-09-02	356480	30.30	2179612.50
146	У759ТР78	7	26	2025	ГАЗ	3302	белый	удовлетворительное	2025-04-15	активен	2022-12-29	2026-04-21	492894	34.60	1905924.41
147	В522ВТ66	6	20	2017	КАМАЗ	65117	оранжевый	удовлетворительное	2025-11-19	активен	2023-11-26	2026-01-05	499039	34.30	3258146.66
148	У807ОА78	8	15	2025	КАМАЗ	5320	синий	хорошее	2025-10-18	активен	2019-09-20	2026-01-04	184294	18.10	1072005.09
149	Н729РО52	7	5	2022	Isuzu	ELF	белый	удовлетворительное	2025-11-29	активен	2020-01-08	2026-01-21	344628	29.30	4546124.75
150	Е635НР66	1	11	2021	Isuzu	ELF	белый	отличное	2025-04-23	активен	2024-04-30	2026-11-06	434828	23.70	3334334.98
151	А782РН16	5	17	2019	ГАЗ	3302	белый	отличное	2025-12-22	активен	2018-06-02	2026-12-29	374039	19.30	2862352.19
152	Е448ЕС52	7	24	2022	КАМАЗ	5320	синий	хорошее	2025-12-22	активен	2019-06-16	2026-08-02	258755	22.20	1700331.51
153	Х394ХУ74	3	15	2019	Mercedes	Sprinter	черный	отличное	2025-06-04	активен	2023-10-13	2026-09-13	147856	25.20	2318458.81
154	В802ВХ66	5	29	2020	КАМАЗ	5320	синий	удовлетворительное	2025-12-04	активен	2020-03-24	2026-06-09	361156	31.00	4379944.87
155	У147НХ66	3	19	2018	Volvo	FH16	красный	удовлетворительное	2025-03-20	активен	2021-04-06	2026-09-02	80744	30.20	4584612.15
156	С169ТР66	2	27	2023	МАЗ	6312	белый	отличное	2025-05-18	активен	2023-12-16	2026-05-20	299529	34.00	2771645.57
157	Т131РМ61	1	\N	2023	Hyundai	Porter	серебристый	удовлетворительное	2025-08-25	активен	2021-03-04	2026-12-02	357107	17.50	674266.09
158	Н415ВВ78	8	20	2024	ГАЗ	Next	серый	хорошее	2025-12-04	активен	2019-09-10	2026-03-27	273902	32.90	3215541.57
159	О145УН55	1	4	2021	Mercedes	Sprinter	черный	удовлетворительное	2025-05-30	активен	2024-11-02	2025-12-26	323344	21.50	4564791.68
160	А797МХ54	4	18	2020	ГАЗ	Next	серый	отличное	2025-07-21	активен	2018-02-24	2026-06-03	425983	18.90	1753018.83
161	В924КВ78	6	26	2019	Hyundai	Porter	серебристый	отличное	2025-02-23	активен	2018-09-04	2026-07-30	239930	25.70	2345543.85
162	Р574МР55	3	4	2024	Hyundai	Porter	серебристый	удовлетворительное	2025-08-20	активен	2021-07-05	2026-06-11	60952	32.40	1634503.80
163	А482ЕЕ52	2	14	2018	Volvo	FH16	красный	удовлетворительное	2025-05-15	активен	2019-01-05	2026-11-14	190963	28.90	4101983.20
164	Р956РС77	3	8	2025	Hyundai	Porter	серебристый	удовлетворительное	2025-04-04	активен	2019-09-08	2026-05-31	240075	33.20	3048087.54
165	У626КА16	3	9	2023	КАМАЗ	65117	оранжевый	отличное	2025-03-11	активен	2019-07-09	2026-11-23	208426	33.50	3250838.44
166	Н951НА52	4	12	2021	Volvo	FH16	красный	удовлетворительное	2025-11-28	активен	2022-04-04	2026-12-02	113438	27.70	801105.25
167	О775ВУ66	4	26	2022	ГАЗ	Next	серый	удовлетворительное	2025-09-16	активен	2017-11-14	2026-06-24	81523	26.60	2181779.43
168	С745РУ54	2	20	2015	Volvo	FH16	красный	удовлетворительное	2025-11-20	активен	2022-06-18	2026-12-04	305370	33.00	1158432.31
169	О906ЕН74	5	5	2024	Isuzu	ELF	белый	удовлетворительное	2025-09-25	на_обслуживании	2021-07-15	2026-12-13	225364	25.10	4080590.84
170	С405КН74	7	17	2018	КАМАЗ	65117	оранжевый	удовлетворительное	2025-09-03	активен	2018-08-29	2026-09-18	264288	34.60	3857370.75
171	С901РО55	1	12	2018	ГАЗ	3302	белый	отличное	2025-03-10	активен	2021-05-29	2027-01-06	151701	22.50	2801625.87
172	У361НК63	1	\N	2024	КАМАЗ	5320	синий	отличное	2025-02-21	активен	2023-08-17	2026-06-18	135967	20.50	1707219.35
173	В336ОР63	2	15	2021	МАЗ	5440	зеленый	отличное	2025-05-04	активен	2024-10-18	2026-05-30	85321	18.60	1380758.21
174	О176СК63	6	10	2024	МАЗ	6312	белый	удовлетворительное	2025-02-19	на_обслуживании	2020-09-06	2026-11-20	267740	32.30	3814707.56
175	А389РУ61	1	19	2015	Hyundai	Porter	серебристый	хорошее	2025-03-11	активен	2024-01-08	2026-09-15	308331	18.20	689143.82
176	У961НУ54	8	30	2015	ГАЗ	3302	белый	отличное	2025-04-16	активен	2022-02-08	2026-02-17	107043	25.60	3157320.53
177	С972НС54	1	\N	2016	Isuzu	ELF	белый	удовлетворительное	2025-11-05	активен	2019-09-23	2026-01-17	384361	29.60	4646218.12
178	Х510МН74	10	15	2016	ГАЗ	Next	серый	отличное	2025-06-04	активен	2018-12-10	2026-08-08	282808	23.00	4001192.62
179	В251ВН16	5	27	2019	КАМАЗ	5320	синий	хорошее	2025-01-31	на_обслуживании	2020-07-12	2026-02-14	132598	22.00	3067742.92
180	Р391УС78	4	23	2023	МАЗ	6312	белый	удовлетворительное	2025-06-17	на_обслуживании	2018-12-04	2026-12-21	174796	15.80	2262177.39
181	Р686ЕН52	3	25	2017	ГАЗ	3302	белый	отличное	2025-06-07	на_обслуживании	2020-02-04	2026-01-29	190309	31.20	1414255.53
182	Н702РС52	10	16	2024	КАМАЗ	5320	синий	удовлетворительное	2025-12-10	активен	2019-08-28	2026-09-30	307616	22.50	4796509.99
183	У530НУ16	6	27	2016	КАМАЗ	5320	синий	удовлетворительное	2025-03-29	активен	2021-05-29	2026-02-20	278486	23.30	2866869.83
184	В130УХ78	4	25	2019	Volvo	FH16	красный	удовлетворительное	2025-03-14	активен	2021-10-27	2026-02-26	53693	32.50	2194962.05
185	О596ТО63	9	\N	2020	Mercedes	Sprinter	черный	отличное	2025-02-11	на_обслуживании	2019-10-20	2026-10-25	190804	26.90	3471207.01
186	Н475ЕС66	2	\N	2015	МАЗ	5440	зеленый	отличное	2025-03-09	активен	2023-09-13	2026-07-21	153888	19.60	2367148.81
187	У644АО63	1	20	2015	Volvo	FH16	красный	хорошее	2025-10-04	активен	2020-05-29	2026-04-15	386469	24.00	503903.99
188	Р633МТ77	10	22	2024	МАЗ	6312	белый	удовлетворительное	2025-06-09	активен	2021-12-08	2027-01-01	163014	23.30	2659237.97
189	Х655ОВ74	2	20	2016	Mercedes	Sprinter	черный	отличное	2025-11-01	на_обслуживании	2023-08-28	2026-11-04	215441	32.80	1465385.29
190	В900КХ55	4	6	2023	ГАЗ	Next	серый	отличное	2025-10-08	активен	2019-01-14	2026-06-17	402715	21.60	716110.30
191	Е468АЕ55	1	28	2024	КАМАЗ	65117	оранжевый	хорошее	2025-05-21	активен	2019-11-21	2026-10-29	116633	18.30	879413.57
192	Х480ХВ54	5	15	2018	МАЗ	5440	зеленый	хорошее	2025-11-16	активен	2021-05-11	2026-11-18	384353	31.90	3177797.10
193	Н806СО74	3	11	2015	Mercedes	Sprinter	черный	хорошее	2025-11-14	на_обслуживании	2020-06-11	2026-11-02	416761	24.30	3297652.73
194	С921ОЕ61	5	22	2024	КАМАЗ	65117	оранжевый	удовлетворительное	2025-05-06	активен	2020-12-23	2026-01-04	276560	24.70	1075668.56
195	А979ЕВ74	5	2	2019	КАМАЗ	5320	синий	отличное	2025-07-04	на_обслуживании	2024-08-26	2026-03-06	308957	23.40	2958340.55
196	У381СР74	2	\N	2019	МАЗ	5440	зеленый	отличное	2025-01-21	активен	2019-02-26	2026-02-15	367603	16.90	642254.11
197	Е897ТХ54	2	20	2023	МАЗ	5440	зеленый	удовлетворительное	2025-04-10	активен	2020-10-04	2026-04-01	224245	32.40	2627709.35
198	Н279СВ77	7	3	2019	Hyundai	Porter	серебристый	отличное	2025-09-19	на_обслуживании	2021-03-09	2026-02-11	440689	29.30	4030992.97
199	Н525УК52	4	19	2022	КАМАЗ	5320	синий	хорошее	2025-06-03	активен	2023-05-22	2026-02-18	149567	28.10	4117412.62
200	К415СС61	9	2	2025	КАМАЗ	65117	оранжевый	удовлетворительное	2025-09-09	активен	2021-09-05	2026-01-16	245816	17.80	3011543.01
201	В927УА54	2	18	2016	КАМАЗ	5320	синий	отличное	2025-10-22	активен	2017-11-28	2026-11-16	402059	22.80	1953308.54
\.


--
-- Name: seq_номер_груза; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."seq_номер_груза"', 1, false);


--
-- Name: seq_номер_платежа; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."seq_номер_платежа"', 1, false);


--
-- Name: водители_ид_водитель_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."водители_ид_водитель_seq"', 61, true);


--
-- Name: города_ид_город_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."города_ид_город_seq"', 25, true);


--
-- Name: груз_и_маршруты_ид_груз_маршрут_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."груз_и_маршруты_ид_груз_маршрут_seq"', 364, true);


--
-- Name: груз_и_средства_ид_груз_средство_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."груз_и_средства_ид_груз_средство_seq"', 414, true);


--
-- Name: грузы_ид_груз_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."грузы_ид_груз_seq"', 1000, true);


--
-- Name: история_статусов_ид_история_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."история_статусов_ид_история_seq"', 2944, true);


--
-- Name: клиенты_ид_клиент_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."клиенты_ид_клиент_seq"', 50, true);


--
-- Name: маршруты_ид_маршрут_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."маршруты_ид_маршрут_seq"', 50, true);


--
-- Name: остановки_маршрута_ид_остановка_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."остановки_маршрута_ид_остановка_seq"', 492, true);


--
-- Name: платежи_ид_платеж_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."платежи_ид_платеж_seq"', 500, true);


--
-- Name: расходы_топлива_ид_расход_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."расходы_топлива_ид_расход_seq"', 600, true);


--
-- Name: склады_ид_склад_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."склады_ид_склад_seq"', 40, true);


--
-- Name: средство_и_марш_ид_средство_мар_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."средство_и_марш_ид_средство_мар_seq"', 182, true);


--
-- Name: статусы_заказов_ид_статус_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."статусы_заказов_ид_статус_seq"', 7, true);


--
-- Name: техническое_обслуживание_ид_то_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."техническое_обслуживание_ид_то_seq"', 150, true);


--
-- Name: типы_средств_дос_ид_тип_средства_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."типы_средств_дос_ид_тип_средства_seq"', 30, true);


--
-- Name: транспортные_средст_ид_средство_seq; Type: SEQUENCE SET; Schema: public; Owner: logistics_admin
--

SELECT pg_catalog.setval('public."транспортные_средст_ид_средство_seq"', 201, true);


--
-- Name: груз_и_маршруты uk_груз_маршрут; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."груз_и_маршруты"
    ADD CONSTRAINT "uk_груз_маршрут" UNIQUE ("ид_груз", "ид_маршрут");


--
-- Name: груз_и_средства uk_груз_средство; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."груз_и_средства"
    ADD CONSTRAINT "uk_груз_средство" UNIQUE ("ид_груз", "ид_средство");


--
-- Name: остановки_маршрута uk_маршрут_порядок; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."остановки_маршрута"
    ADD CONSTRAINT "uk_маршрут_порядок" UNIQUE ("ид_маршрут", "порядковый_номер");


--
-- Name: средство_и_маршруты uk_средство_маршрут; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."средство_и_маршруты"
    ADD CONSTRAINT "uk_средство_маршрут" UNIQUE ("ид_средство", "ид_маршрут");


--
-- Name: водители водители_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."водители"
    ADD CONSTRAINT "водители_pkey" PRIMARY KEY ("ид_водитель");


--
-- Name: водители водители_номер_прав_key; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."водители"
    ADD CONSTRAINT "водители_номер_прав_key" UNIQUE ("номер_прав");


--
-- Name: города города_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."города"
    ADD CONSTRAINT "города_pkey" PRIMARY KEY ("ид_город");


--
-- Name: города города_название_key; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."города"
    ADD CONSTRAINT "города_название_key" UNIQUE ("название");


--
-- Name: груз_и_маршруты груз_и_маршруты_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."груз_и_маршруты"
    ADD CONSTRAINT "груз_и_маршруты_pkey" PRIMARY KEY ("ид_груз_маршрут");


--
-- Name: груз_и_средства груз_и_средства_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."груз_и_средства"
    ADD CONSTRAINT "груз_и_средства_pkey" PRIMARY KEY ("ид_груз_средство");


--
-- Name: грузы грузы_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."грузы"
    ADD CONSTRAINT "грузы_pkey" PRIMARY KEY ("ид_груз");


--
-- Name: грузы грузы_номер_груза_key; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."грузы"
    ADD CONSTRAINT "грузы_номер_груза_key" UNIQUE ("номер_груза");


--
-- Name: история_статусов история_статусов_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."история_статусов"
    ADD CONSTRAINT "история_статусов_pkey" PRIMARY KEY ("ид_история");


--
-- Name: клиенты клиенты_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."клиенты"
    ADD CONSTRAINT "клиенты_pkey" PRIMARY KEY ("ид_клиент");


--
-- Name: клиенты клиенты_название_key; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."клиенты"
    ADD CONSTRAINT "клиенты_название_key" UNIQUE ("название");


--
-- Name: маршруты маршруты_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."маршруты"
    ADD CONSTRAINT "маршруты_pkey" PRIMARY KEY ("ид_маршрут");


--
-- Name: маршруты маршруты_код_маршрута_key; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."маршруты"
    ADD CONSTRAINT "маршруты_код_маршрута_key" UNIQUE ("код_маршрута");


--
-- Name: маршруты маршруты_наименование_key; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."маршруты"
    ADD CONSTRAINT "маршруты_наименование_key" UNIQUE ("наименование");


--
-- Name: остановки_маршрута остановки_маршрута_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."остановки_маршрута"
    ADD CONSTRAINT "остановки_маршрута_pkey" PRIMARY KEY ("ид_остановка");


--
-- Name: платежи платежи_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."платежи"
    ADD CONSTRAINT "платежи_pkey" PRIMARY KEY ("ид_платеж");


--
-- Name: платежи платежи_номер_платежа_key; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."платежи"
    ADD CONSTRAINT "платежи_номер_платежа_key" UNIQUE ("номер_платежа");


--
-- Name: расходы_топлива расходы_топлива_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."расходы_топлива"
    ADD CONSTRAINT "расходы_топлива_pkey" PRIMARY KEY ("ид_расход");


--
-- Name: склады склады_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."склады"
    ADD CONSTRAINT "склады_pkey" PRIMARY KEY ("ид_склад");


--
-- Name: склады склады_название_key; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."склады"
    ADD CONSTRAINT "склады_название_key" UNIQUE ("название");


--
-- Name: средство_и_маршруты средство_и_маршруты_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."средство_и_маршруты"
    ADD CONSTRAINT "средство_и_маршруты_pkey" PRIMARY KEY ("ид_средство_маршрут");


--
-- Name: статусы_заказов статусы_заказов_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."статусы_заказов"
    ADD CONSTRAINT "статусы_заказов_pkey" PRIMARY KEY ("ид_статус");


--
-- Name: статусы_заказов статусы_заказов_код_статуса_key; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."статусы_заказов"
    ADD CONSTRAINT "статусы_заказов_код_статуса_key" UNIQUE ("код_статуса");


--
-- Name: техническое_обслуживание техническое_обслуживание_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."техническое_обслуживание"
    ADD CONSTRAINT "техническое_обслуживание_pkey" PRIMARY KEY ("ид_то");


--
-- Name: типы_средств_доставки типы_средств_доста_наименование_key; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."типы_средств_доставки"
    ADD CONSTRAINT "типы_средств_доста_наименование_key" UNIQUE ("наименование");


--
-- Name: типы_средств_доставки типы_средств_доставки_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."типы_средств_доставки"
    ADD CONSTRAINT "типы_средств_доставки_pkey" PRIMARY KEY ("ид_тип_средства");


--
-- Name: транспортные_средства транспортные_средства_pkey; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."транспортные_средства"
    ADD CONSTRAINT "транспортные_средства_pkey" PRIMARY KEY ("ид_средство");


--
-- Name: транспортные_средства транспортные_средства_госномер_key; Type: CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."транспортные_средства"
    ADD CONSTRAINT "транспортные_средства_госномер_key" UNIQUE ("госномер");


--
-- Name: idx_водители_прав; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_водители_прав" ON public."водители" USING btree ("номер_прав");


--
-- Name: idx_водители_статус; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_водители_статус" ON public."водители" USING btree ("статус");


--
-- Name: idx_водители_телефон; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_водители_телефон" ON public."водители" USING btree ("телефон");


--
-- Name: idx_водители_фио; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_водители_фио" ON public."водители" USING btree ("фамилия", "имя");


--
-- Name: idx_гм_груз; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_гм_груз" ON public."груз_и_маршруты" USING btree ("ид_груз");


--
-- Name: idx_гм_дата_начала; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_гм_дата_начала" ON public."груз_и_маршруты" USING btree ("дата_начала_маршрута");


--
-- Name: idx_гм_маршрут; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_гм_маршрут" ON public."груз_и_маршруты" USING btree ("ид_маршрут");


--
-- Name: idx_гм_статус; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_гм_статус" ON public."груз_и_маршруты" USING btree ("статус");


--
-- Name: idx_города_название; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_города_название" ON public."города" USING btree ("название");


--
-- Name: idx_города_регион; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_города_регион" ON public."города" USING btree ("регион");


--
-- Name: idx_грузы_дата_доставки; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_грузы_дата_доставки" ON public."грузы" USING btree ("дата_должна_прибыть");


--
-- Name: idx_грузы_дата_создания; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_грузы_дата_создания" ON public."грузы" USING btree ("дата_создания");


--
-- Name: idx_грузы_клиент; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_грузы_клиент" ON public."грузы" USING btree ("ид_клиент");


--
-- Name: idx_грузы_комбо_статус_дата; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_грузы_комбо_статус_дата" ON public."грузы" USING btree ("ид_статус", "дата_создания");


--
-- Name: idx_грузы_номер; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_грузы_номер" ON public."грузы" USING btree ("номер_груза");


--
-- Name: idx_грузы_склад_куда; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_грузы_склад_куда" ON public."грузы" USING btree ("ид_склад_куда");


--
-- Name: idx_грузы_склад_откуда; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_грузы_склад_откуда" ON public."грузы" USING btree ("ид_склад_откуда");


--
-- Name: idx_грузы_статус; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_грузы_статус" ON public."грузы" USING btree ("ид_статус");


--
-- Name: idx_грузы_хрупкий; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_грузы_хрупкий" ON public."грузы" USING btree ("хрупкий") WHERE ("хрупкий" = true);


--
-- Name: idx_гс_груз; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_гс_груз" ON public."груз_и_средства" USING btree ("ид_груз");


--
-- Name: idx_гс_дата_начала; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_гс_дата_начала" ON public."груз_и_средства" USING btree ("дата_начала");


--
-- Name: idx_гс_комбо; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_гс_комбо" ON public."груз_и_средства" USING btree ("ид_груз", "ид_средство", "статус");


--
-- Name: idx_гс_средство; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_гс_средство" ON public."груз_и_средства" USING btree ("ид_средство");


--
-- Name: idx_гс_статус; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_гс_статус" ON public."груз_и_средства" USING btree ("статус");


--
-- Name: idx_история_груз; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_история_груз" ON public."история_статусов" USING btree ("ид_груз");


--
-- Name: idx_история_дата; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_история_дата" ON public."история_статусов" USING btree ("дата_изменения");


--
-- Name: idx_история_пользователь; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_история_пользователь" ON public."история_статусов" USING btree ("ид_пользователь");


--
-- Name: idx_клиенты_email; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_клиенты_email" ON public."клиенты" USING btree ("электронная_почта");


--
-- Name: idx_клиенты_инн; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_клиенты_инн" ON public."клиенты" USING btree ("инн");


--
-- Name: idx_клиенты_название; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_клиенты_название" ON public."клиенты" USING btree ("название");


--
-- Name: idx_клиенты_статус; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_клиенты_статус" ON public."клиенты" USING btree ("статус");


--
-- Name: idx_клиенты_телефон; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_клиенты_телефон" ON public."клиенты" USING btree ("контактный_телефон");


--
-- Name: idx_маршруты_код; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_маршруты_код" ON public."маршруты" USING btree ("код_маршрута");


--
-- Name: idx_маршруты_наименование; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_маршруты_наименование" ON public."маршруты" USING btree ("наименование");


--
-- Name: idx_маршруты_статус; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_маршруты_статус" ON public."маршруты" USING btree ("статус");


--
-- Name: idx_маршруты_тип; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_маршруты_тип" ON public."маршруты" USING btree ("тип_маршрута");


--
-- Name: idx_остановки_город; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_остановки_город" ON public."остановки_маршрута" USING btree ("ид_город");


--
-- Name: idx_остановки_маршрут; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_остановки_маршрут" ON public."остановки_маршрута" USING btree ("ид_маршрут");


--
-- Name: idx_остановки_порядковый; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_остановки_порядковый" ON public."остановки_маршрута" USING btree ("порядковый_номер");


--
-- Name: idx_платежи_груз; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_платежи_груз" ON public."платежи" USING btree ("ид_груз");


--
-- Name: idx_платежи_дата; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_платежи_дата" ON public."платежи" USING btree ("дата_оплаты");


--
-- Name: idx_платежи_дата_создания; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_платежи_дата_создания" ON public."платежи" USING btree ("дата_создания");


--
-- Name: idx_платежи_клиент; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_платежи_клиент" ON public."платежи" USING btree ("ид_клиент");


--
-- Name: idx_платежи_номер; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_платежи_номер" ON public."платежи" USING btree ("номер_платежа");


--
-- Name: idx_платежи_статус; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_платежи_статус" ON public."платежи" USING btree ("статус_платежа");


--
-- Name: idx_расходы_дата; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_расходы_дата" ON public."расходы_топлива" USING btree ("дата_заправки");


--
-- Name: idx_расходы_средство; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_расходы_средство" ON public."расходы_топлива" USING btree ("ид_средство");


--
-- Name: idx_склады_город; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_склады_город" ON public."склады" USING btree ("ид_город");


--
-- Name: idx_склады_название; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_склады_название" ON public."склады" USING btree ("название");


--
-- Name: idx_склады_статус; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_склады_статус" ON public."склады" USING btree ("статус");


--
-- Name: idx_см_маршрут; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_см_маршрут" ON public."средство_и_маршруты" USING btree ("ид_маршрут");


--
-- Name: idx_см_приоритет; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_см_приоритет" ON public."средство_и_маршруты" USING btree ("приоритет");


--
-- Name: idx_см_средство; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_см_средство" ON public."средство_и_маршруты" USING btree ("ид_средство");


--
-- Name: idx_см_статус; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_см_статус" ON public."средство_и_маршруты" USING btree ("статус");


--
-- Name: idx_статусы_код; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_статусы_код" ON public."статусы_заказов" USING btree ("код_статуса");


--
-- Name: idx_статусы_порядок; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_статусы_порядок" ON public."статусы_заказов" USING btree ("порядок_сортировки");


--
-- Name: idx_типы_наименование; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_типы_наименование" ON public."типы_средств_доставки" USING btree ("наименование");


--
-- Name: idx_то_дата; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_то_дата" ON public."техническое_обслуживание" USING btree ("дата_начала");


--
-- Name: idx_то_средство; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_то_средство" ON public."техническое_обслуживание" USING btree ("ид_средство");


--
-- Name: idx_то_статус; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_то_статус" ON public."техническое_обслуживание" USING btree ("статус");


--
-- Name: idx_тс_водитель; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_тс_водитель" ON public."транспортные_средства" USING btree ("ид_водитель");


--
-- Name: idx_тс_госномер; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_тс_госномер" ON public."транспортные_средства" USING btree ("госномер");


--
-- Name: idx_тс_состояние; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_тс_состояние" ON public."транспортные_средства" USING btree ("состояние");


--
-- Name: idx_тс_статус; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_тс_статус" ON public."транспортные_средства" USING btree ("статус");


--
-- Name: idx_тс_тип; Type: INDEX; Schema: public; Owner: logistics_admin
--

CREATE INDEX "idx_тс_тип" ON public."транспортные_средства" USING btree ("ид_тип_средства");


--
-- Name: груз_и_маршруты fk_гм_груз; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."груз_и_маршруты"
    ADD CONSTRAINT "fk_гм_груз" FOREIGN KEY ("ид_груз") REFERENCES public."грузы"("ид_груз") ON DELETE CASCADE;


--
-- Name: груз_и_маршруты fk_гм_маршрут; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."груз_и_маршруты"
    ADD CONSTRAINT "fk_гм_маршрут" FOREIGN KEY ("ид_маршрут") REFERENCES public."маршруты"("ид_маршрут") ON DELETE RESTRICT;


--
-- Name: груз_и_маршруты fk_гм_остановка_конец; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."груз_и_маршруты"
    ADD CONSTRAINT "fk_гм_остановка_конец" FOREIGN KEY ("остановка_конец") REFERENCES public."остановки_маршрута"("ид_остановка") ON DELETE SET NULL;


--
-- Name: груз_и_маршруты fk_гм_остановка_начало; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."груз_и_маршруты"
    ADD CONSTRAINT "fk_гм_остановка_начало" FOREIGN KEY ("остановка_начало") REFERENCES public."остановки_маршрута"("ид_остановка") ON DELETE SET NULL;


--
-- Name: грузы fk_грузы_клиент; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."грузы"
    ADD CONSTRAINT "fk_грузы_клиент" FOREIGN KEY ("ид_клиент") REFERENCES public."клиенты"("ид_клиент") ON DELETE RESTRICT;


--
-- Name: грузы fk_грузы_склад_куда; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."грузы"
    ADD CONSTRAINT "fk_грузы_склад_куда" FOREIGN KEY ("ид_склад_куда") REFERENCES public."склады"("ид_склад") ON DELETE RESTRICT;


--
-- Name: грузы fk_грузы_склад_откуда; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."грузы"
    ADD CONSTRAINT "fk_грузы_склад_откуда" FOREIGN KEY ("ид_склад_откуда") REFERENCES public."склады"("ид_склад") ON DELETE RESTRICT;


--
-- Name: грузы fk_грузы_статус; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."грузы"
    ADD CONSTRAINT "fk_грузы_статус" FOREIGN KEY ("ид_статус") REFERENCES public."статусы_заказов"("ид_статус") ON DELETE RESTRICT;


--
-- Name: груз_и_средства fk_гс_груз; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."груз_и_средства"
    ADD CONSTRAINT "fk_гс_груз" FOREIGN KEY ("ид_груз") REFERENCES public."грузы"("ид_груз") ON DELETE CASCADE;


--
-- Name: груз_и_средства fk_гс_средство; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."груз_и_средства"
    ADD CONSTRAINT "fk_гс_средство" FOREIGN KEY ("ид_средство") REFERENCES public."транспортные_средства"("ид_средство") ON DELETE RESTRICT;


--
-- Name: история_статусов fk_история_груз; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."история_статусов"
    ADD CONSTRAINT "fk_история_груз" FOREIGN KEY ("ид_груз") REFERENCES public."грузы"("ид_груз") ON DELETE CASCADE;


--
-- Name: история_статусов fk_история_статус_новый; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."история_статусов"
    ADD CONSTRAINT "fk_история_статус_новый" FOREIGN KEY ("ид_статус_новый") REFERENCES public."статусы_заказов"("ид_статус") ON DELETE RESTRICT;


--
-- Name: история_статусов fk_история_статус_старый; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."история_статусов"
    ADD CONSTRAINT "fk_история_статус_старый" FOREIGN KEY ("ид_статус_старый") REFERENCES public."статусы_заказов"("ид_статус") ON DELETE RESTRICT;


--
-- Name: остановки_маршрута fk_остановки_город; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."остановки_маршрута"
    ADD CONSTRAINT "fk_остановки_город" FOREIGN KEY ("ид_город") REFERENCES public."города"("ид_город") ON DELETE RESTRICT;


--
-- Name: остановки_маршрута fk_остановки_маршрут; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."остановки_маршрута"
    ADD CONSTRAINT "fk_остановки_маршрут" FOREIGN KEY ("ид_маршрут") REFERENCES public."маршруты"("ид_маршрут") ON DELETE CASCADE;


--
-- Name: платежи fk_платежи_груз; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."платежи"
    ADD CONSTRAINT "fk_платежи_груз" FOREIGN KEY ("ид_груз") REFERENCES public."грузы"("ид_груз") ON DELETE SET NULL;


--
-- Name: платежи fk_платежи_клиент; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."платежи"
    ADD CONSTRAINT "fk_платежи_клиент" FOREIGN KEY ("ид_клиент") REFERENCES public."клиенты"("ид_клиент") ON DELETE RESTRICT;


--
-- Name: расходы_топлива fk_расходы_средство; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."расходы_топлива"
    ADD CONSTRAINT "fk_расходы_средство" FOREIGN KEY ("ид_средство") REFERENCES public."транспортные_средства"("ид_средство") ON DELETE RESTRICT;


--
-- Name: склады fk_склады_город; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."склады"
    ADD CONSTRAINT "fk_склады_город" FOREIGN KEY ("ид_город") REFERENCES public."города"("ид_город") ON DELETE RESTRICT;


--
-- Name: средство_и_маршруты fk_см_маршрут; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."средство_и_маршруты"
    ADD CONSTRAINT "fk_см_маршрут" FOREIGN KEY ("ид_маршрут") REFERENCES public."маршруты"("ид_маршрут") ON DELETE RESTRICT;


--
-- Name: средство_и_маршруты fk_см_средство; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."средство_и_маршруты"
    ADD CONSTRAINT "fk_см_средство" FOREIGN KEY ("ид_средство") REFERENCES public."транспортные_средства"("ид_средство") ON DELETE RESTRICT;


--
-- Name: техническое_обслуживание fk_то_средство; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."техническое_обслуживание"
    ADD CONSTRAINT "fk_то_средство" FOREIGN KEY ("ид_средство") REFERENCES public."транспортные_средства"("ид_средство") ON DELETE RESTRICT;


--
-- Name: транспортные_средства fk_тс_водитель; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."транспортные_средства"
    ADD CONSTRAINT "fk_тс_водитель" FOREIGN KEY ("ид_водитель") REFERENCES public."водители"("ид_водитель") ON DELETE SET NULL;


--
-- Name: транспортные_средства fk_тс_тип; Type: FK CONSTRAINT; Schema: public; Owner: logistics_admin
--

ALTER TABLE ONLY public."транспортные_средства"
    ADD CONSTRAINT "fk_тс_тип" FOREIGN KEY ("ид_тип_средства") REFERENCES public."типы_средств_доставки"("ид_тип_средства") ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict 2ilsRMVp6WTvrOQWsgArrJRhbQh6d4KMMW9rcGR3gGXNS1i5MG7Pz2i9Wl7eihS


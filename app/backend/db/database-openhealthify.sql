-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.0.5
-- PostgreSQL version: 15.0
-- Project Site: pgmodeler.io
-- Model Author: ---

-- Database creation must be performed outside a multi lined SQL file. 
-- These commands were put in this file only as a convenience.
-- 
-- object: openhealthify | type: DATABASE --
-- DROP DATABASE IF EXISTS openhealthify;
CREATE DATABASE openhealthify;
-- ddl-end --


-- object: public.profile | type: TABLE --
-- DROP TABLE IF EXISTS public.profile CASCADE;
CREATE TABLE public.profile (
	profile_id varchar(128) NOT NULL,
	name varchar(64) NOT NULL,
	date_of_birth date,
	location text,
	phone_no text,
	bio text,
	goals_id bigint,
	body_metrics_id bigint,
	CONSTRAINT profile_pk PRIMARY KEY (profile_id)
);
-- ddl-end --

-- object: public.body_metrics | type: TABLE --
-- DROP TABLE IF EXISTS public.body_metrics CASCADE;
CREATE TABLE public.body_metrics (
	body_metrics_id bigserial NOT NULL,
	height float,
	weight float,
	activity_id smallint,
	medical_conditions smallint[],
	maintenance_calories float,
	CONSTRAINT body_metrics_pk PRIMARY KEY (body_metrics_id)
);
-- ddl-end --

-- object: public.goals | type: TABLE --
-- DROP TABLE IF EXISTS public.goals CASCADE;
CREATE TABLE public.goals (
	goals_id bigserial NOT NULL,
	target_weight float,
	goal_pace float,
	CONSTRAINT goals_pk PRIMARY KEY (goals_id)
);
-- ddl-end --

-- object: goals_fk | type: CONSTRAINT --
-- ALTER TABLE public.profile DROP CONSTRAINT IF EXISTS goals_fk CASCADE;
ALTER TABLE public.profile ADD CONSTRAINT goals_fk FOREIGN KEY (goals_id)
REFERENCES public.goals (goals_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: profile_uq | type: CONSTRAINT --
-- ALTER TABLE public.profile DROP CONSTRAINT IF EXISTS profile_uq CASCADE;
ALTER TABLE public.profile ADD CONSTRAINT profile_uq UNIQUE (goals_id);
-- ddl-end --

-- object: body_metrics_fk | type: CONSTRAINT --
-- ALTER TABLE public.profile DROP CONSTRAINT IF EXISTS body_metrics_fk CASCADE;
ALTER TABLE public.profile ADD CONSTRAINT body_metrics_fk FOREIGN KEY (body_metrics_id)
REFERENCES public.body_metrics (body_metrics_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: profile_uq1 | type: CONSTRAINT --
-- ALTER TABLE public.profile DROP CONSTRAINT IF EXISTS profile_uq1 CASCADE;
ALTER TABLE public.profile ADD CONSTRAINT profile_uq1 UNIQUE (body_metrics_id);
-- ddl-end --

-- object: public.day_entry | type: TABLE --
-- DROP TABLE IF EXISTS public.day_entry CASCADE;
CREATE TABLE public.day_entry (
	entry_date date NOT NULL,
	profile_id varchar(128),
	day_entry_id bigserial NOT NULL,
	breakfast bigint,
	morning_snacks bigint,
	lunch bigint,
	evening_snacks bigint,
	dinner bigint,
	CONSTRAINT day_entry_pk PRIMARY KEY (day_entry_id)
);
-- ddl-end --

-- object: profile_fk | type: CONSTRAINT --
-- ALTER TABLE public.day_entry DROP CONSTRAINT IF EXISTS profile_fk CASCADE;
ALTER TABLE public.day_entry ADD CONSTRAINT profile_fk FOREIGN KEY (profile_id)
REFERENCES public.profile (profile_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: day_entry_uq | type: CONSTRAINT --
-- ALTER TABLE public.day_entry DROP CONSTRAINT IF EXISTS day_entry_uq CASCADE;
ALTER TABLE public.day_entry ADD CONSTRAINT day_entry_uq UNIQUE (profile_id);
-- ddl-end --

-- object: public.meal | type: TABLE --
-- DROP TABLE IF EXISTS public.meal CASCADE;
CREATE TABLE public.meal (
	meal_id bigserial NOT NULL,
	CONSTRAINT meal_pk PRIMARY KEY (meal_id)
);
-- ddl-end --

-- object: meal_fk | type: CONSTRAINT --
-- ALTER TABLE public.day_entry DROP CONSTRAINT IF EXISTS meal_fk CASCADE;
ALTER TABLE public.day_entry ADD CONSTRAINT meal_fk FOREIGN KEY (breakfast)
REFERENCES public.meal (meal_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: meal_fk1 | type: CONSTRAINT --
-- ALTER TABLE public.day_entry DROP CONSTRAINT IF EXISTS meal_fk1 CASCADE;
ALTER TABLE public.day_entry ADD CONSTRAINT meal_fk1 FOREIGN KEY (morning_snacks)
REFERENCES public.meal (meal_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: meal_fk2 | type: CONSTRAINT --
-- ALTER TABLE public.day_entry DROP CONSTRAINT IF EXISTS meal_fk2 CASCADE;
ALTER TABLE public.day_entry ADD CONSTRAINT meal_fk2 FOREIGN KEY (lunch)
REFERENCES public.meal (meal_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: meal_fk3 | type: CONSTRAINT --
-- ALTER TABLE public.day_entry DROP CONSTRAINT IF EXISTS meal_fk3 CASCADE;
ALTER TABLE public.day_entry ADD CONSTRAINT meal_fk3 FOREIGN KEY (evening_snacks)
REFERENCES public.meal (meal_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: meal_fk4 | type: CONSTRAINT --
-- ALTER TABLE public.day_entry DROP CONSTRAINT IF EXISTS meal_fk4 CASCADE;
ALTER TABLE public.day_entry ADD CONSTRAINT meal_fk4 FOREIGN KEY (dinner)
REFERENCES public.meal (meal_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.meal_detail | type: TABLE --
-- DROP TABLE IF EXISTS public.meal_detail CASCADE;
CREATE TABLE public.meal_detail (
	meal_detail_id bigserial NOT NULL,
	quantity float4,
	measure_id smallint,
	meal_id bigint,
	item_id bigint,
	CONSTRAINT meal_detail_pk PRIMARY KEY (meal_detail_id)
);
-- ddl-end --

-- object: meal_fk | type: CONSTRAINT --
-- ALTER TABLE public.meal_detail DROP CONSTRAINT IF EXISTS meal_fk CASCADE;
ALTER TABLE public.meal_detail ADD CONSTRAINT meal_fk FOREIGN KEY (meal_id)
REFERENCES public.meal (meal_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.item | type: TABLE --
-- DROP TABLE IF EXISTS public.item CASCADE;
CREATE TABLE public.item (
	item_id bigserial NOT NULL,
	name varchar(64),
	description varchar(500),
	protein float,
	carbohydrate float,
	fat float,
	micro_nutrients jsonb,
	category smallint,
	cuisine smallint,
	allowed_measures smallint[],
	is_recipe boolean,
	added_by varchar(128),
	CONSTRAINT item_pk PRIMARY KEY (item_id)
);
-- ddl-end --

-- object: item_fk | type: CONSTRAINT --
-- ALTER TABLE public.meal_detail DROP CONSTRAINT IF EXISTS item_fk CASCADE;
ALTER TABLE public.meal_detail ADD CONSTRAINT item_fk FOREIGN KEY (item_id)
REFERENCES public.item (item_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: profile_fk | type: CONSTRAINT --
-- ALTER TABLE public.item DROP CONSTRAINT IF EXISTS profile_fk CASCADE;
ALTER TABLE public.item ADD CONSTRAINT profile_fk FOREIGN KEY (added_by)
REFERENCES public.profile (profile_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.recipe_ingredients | type: TABLE --
-- DROP TABLE IF EXISTS public.recipe_ingredients CASCADE;
CREATE TABLE public.recipe_ingredients (
	priority smallint,
	quantity float,
	measure smallint,
	metadata jsonb,
	recipe_id bigint NOT NULL,
	ingredient_id bigint NOT NULL,
	CONSTRAINT recipe_ingredients_pk PRIMARY KEY (recipe_id,ingredient_id)
);
-- ddl-end --

-- object: item_fk | type: CONSTRAINT --
-- ALTER TABLE public.recipe_ingredients DROP CONSTRAINT IF EXISTS item_fk CASCADE;
ALTER TABLE public.recipe_ingredients ADD CONSTRAINT item_fk FOREIGN KEY (recipe_id)
REFERENCES public.item (item_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: recipe_ingredients_uq | type: CONSTRAINT --
-- ALTER TABLE public.recipe_ingredients DROP CONSTRAINT IF EXISTS recipe_ingredients_uq CASCADE;
ALTER TABLE public.recipe_ingredients ADD CONSTRAINT recipe_ingredients_uq UNIQUE (recipe_id);
-- ddl-end --

-- object: item_fk1 | type: CONSTRAINT --
-- ALTER TABLE public.recipe_ingredients DROP CONSTRAINT IF EXISTS item_fk1 CASCADE;
ALTER TABLE public.recipe_ingredients ADD CONSTRAINT item_fk1 FOREIGN KEY (ingredient_id)
REFERENCES public.item (item_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --



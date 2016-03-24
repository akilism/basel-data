-- import rows into table from tsv
COPY exports(country_of_export, y_code, waste_streams, annex_viii, un_class, h_code, characteristics, amount_exported, country_of_transit, country_of_destination, d_code, r_code, year) FROM '/Users/akilharris/projects/basel-convention/data/exports.tsv';


--counts of exports by country of export by year
select
	count(country_of_export) as count,
	sum(amount_exported) as total_amount,
	country_of_export,
	--country_of_destination,
	year
from
	exports
group by
	country_of_export,
	--country_of_destination,
	year
order by
	total_amount desc,
	--country_of_destination,
	year


--select * from exports limit 1

--a single export countries data for a given year.
select
	country_of_export,
	amount_exported,
	country_of_destination,
	year,
	y_code,
	cw.description,
	r_code,
	r.description,
	d_code,
	d.description
from
	exports e
left join
	controlled_wastes cw
on
	cw.code = e.y_code
left join
	recovery_operations r
on
	r.code = e.r_code
left join
	disposal_operations d
on
	d.code = e.d_code
where
	country_of_export = 'NL' and year = 2009
order by
	amount_exported desc


---
-- Hazardous Waste Totals By Year
---
select
	count(y_code) as count_y_code,
	sum(amount_exported) total_exported_tonnage,
	year,
	y_code,
	cw.description
from
	exports e
left join
	controlled_wastes cw
on
	cw.code = e.y_code
group by
	year,
	y_code,
	cw.description
order by
	year,
	total_exported_tonnage desc,
	y_code


---
-- Total Exports all waste types grouped by export country, import country and year
---
select
	count(country_of_export) as count,
	sum(amount_exported) as total_amount,
	c.country as export_country,
	cc.country as import_country,
	e.year
from
	exports e
left join
	country_codes c
on
	c.code = e.country_of_export
left join
	country_codes cc
on
	cc.code = e.country_of_destination
group by
	export_country,
	import_country,
	e.year
order by
	e.year,
	total_amount desc


--Total amount imported by country
select
	sum(amount_exported) as total_amount_imported,
	c.country
from
	exports e
left join
	country_codes c
on
	c.code = e.country_of_destination
group by
	c.country
order by
	total_amount_imported desc

--Total amount imported by country by year
select
	sum(amount_exported) as total_amount_imported,
	c.country,
	e.year
from
	exports e
left join
	country_codes c
on
	c.code = e.country_of_destination
group by
	e.year,
	c.country
order by
	e.year,
	total_amount_imported desc

--Total Amount exported by country
select
	sum(amount_exported) as total_amount_exported,
	c.country
from
	exports e
left join
	country_codes c
on
	c.code = e.country_of_export
group by
	c.country
order by
	total_amount_exported desc

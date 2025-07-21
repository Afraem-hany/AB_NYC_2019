select * from `ab_nyc_2019.1csv.csv` a1c ;
SELECT COUNT(*) from ab_nys_w a  ;
select * from ab_nyc_2019 ;
-- create work in table

create table ab_nys_w
like ab_nyc ;

insert into ab_nys_w 
select * from ab_nyc;

-- data cleaning 

-- first deallocate 
select id , count(*) as num_d
from ab_nys_w
group by id 
having num_d > 1
;

-- no doublecates 

-- secound nulls

SELECT * FROM ab_nys_w
WHERE 
    id IS NULL OR id = '' OR
    name IS NULL OR name = '' OR
    host_id IS NULL OR host_id = '' OR
    host_name IS NULL OR host_name = '' OR
    neighbourhood_group IS NULL OR neighbourhood_group = '' OR
    neighbourhood IS NULL OR neighbourhood = '' OR
    latitude IS NULL OR latitude = '' OR
    longitude IS NULL OR longitude = '' OR
    room_type IS NULL OR room_type = '' OR
    price IS NULL OR price = '' OR
    minimum_nights IS NULL OR minimum_nights = '' OR
    number_of_reviews IS NULL OR number_of_reviews = '' OR
    last_review IS NULL OR last_review = '' OR
    reviews_per_month IS NULL OR reviews_per_month = '' OR
    calculated_host_listings_count IS NULL OR calculated_host_listings_count = '' OR
    availability_365 IS NULL OR availability_365 = '';
    
-- no null values

SHOW COLUMNS FROM ab_nys_w;
DESCRIBE ab_nys_w;

-- we have problems in 'last_review' , reviews_per_month

-- fix last review 
select last_review ,
str_to_date(last_review , '%Y-%m-%d') as new_last_review
from ab_nys_w
WHERE 
    STR_TO_DATE(last_review, '%Y-%m-%d') IS not NULL 
    AND (last_review IS NOT NULL or last_review != '');
;

alter table ab_nys_w 
add column new_last_review date;

UPDATE ab_nys_w 
SET new_last_review = 
    CASE
        WHEN STR_TO_DATE(last_review, '%Y-%m-%d') IS NOT NULL THEN STR_TO_DATE(last_review, '%Y-%m-%d')
        WHEN STR_TO_DATE(last_review, '%m/%d/%Y') IS NOT NULL THEN STR_TO_DATE(last_review, '%m/%d/%Y')
        WHEN STR_TO_DATE(last_review, '%d-%m-%Y') IS NOT NULL THEN STR_TO_DATE(last_review, '%d-%m-%Y')
        ELSE NULL
    END
WHERE last_review IS NOT NULL AND last_review != '';

alter table ab_nys_w
drop column last_review;


-- fix reviews_per_month
describe ab_nys_w;

select reviews_per_month from ab_nys_w;

ALTER TABLE ab_nys_w ADD COLUMN temp_column DOUBLE;


UPDATE ab_nys_w 
SET temp_column = CASE
    WHEN reviews_per_month is null THEN 0
    ELSE CAST(reviews_per_month AS DOUBLE)
END;

ALTER TABLE  ab_nys_w
CHANGE COLUMN temp_column new_reviews_per_month double;

alter table ab_nys_w
drop column reviews_per_month;

select * from ab_nys_w;
-- the Inquiries






SELECT * 
FROM ab_nys_w
WHERE
    `name` IS NOT NULL AND `name` != '' AND
    host_id IS NOT NULL AND
    host_name IS NOT NULL AND
    neighbourhood_group IS NOT NULL AND
    neighbourhood IS NOT NULL AND 
    latitude IS NOT NULL AND
    longitude IS NOT NULL AND
    room_type IS NOT NULL AND
    price IS NOT NULL AND
    minimum_nights IS NOT NULL AND
    number_of_reviews IS NOT NULL AND
    new_last_review IS NOT NULL AND
    new_reviews_per_month IS NOT NULL AND
    calculated_host_listings_count IS NOT NULL AND
    availability_365 IS NOT NULL;


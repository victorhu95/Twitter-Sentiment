
/*Step 1 - Load Raw datafile*/
CREATE EXTERNAL TABLE IF NOT EXISTS `huvicto`.`twitter`
(`data` struct<`author_id`:  string,
`context_annotations`:
array<struct<`domain`: struct<`id`: string,
`name`: string, `description`: string,
`entity`: struct<`id`: string, `name`: string,
`description`: string>>>>,	 `created_at`:  string,
`geo`:  string, `tw_id`:  string, `lang`:  string,
`text`:  string>, `includes` struct<`users`:
array<struct<`id`: string, `location`: string,
`name`: string, `public_metrics`:
struct<`followers_count`: string,
`following_count`: string, `tweet_count`: string,
`listed_count`: string>, `username`: string>>,
`matching_rules`: array<struct<`id`: string,
`tag`: string>>>
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION  's3://huvicto/twitter_may2022/' ;

/*Step 2 - Create text file from raw data file*/
create table text as
SELECT
  data.author_id as author_id,
  cast(substr(data.created_at,1,10) as date) as created_dt,
  substr(data.created_at,12,20) as time,
  data.geo as geo,
  data.id as id,
  data.lang as lang,
  data.text as text,
  case when lower(data.text) like '%uber%' then 'Uber'
  when lower(data.text) like '%doordash%' then 'DoorDash'
  when lower(data.text) like '%skipthe%' then 'SkiptheDishes' end as tag
FROM
  banks
  order by 1;

/*Step 3 - Create domain file from raw data file*/

CREATE TABLE IF NOT EXISTS domain as
WITH domain_prep AS (
SELECT data.author_id as author_id, data.id as id,  domain
FROM banks
CROSS JOIN UNNEST(data.context_annotations) AS t(domain)
)
SELECT
  author_id,
  id as text_id,
  domain.domain.id as domain_id,
  domain.domain.name as name,
  domain.domain.description as description
FROM
  domain_prep
  order by 1;

/*Step 4 - Create domain file from raw data file*/
CREATE TABLE IF NOT EXISTS users as
WITH users_prep AS (
SELECT data.author_id as author_id, data.id as id,  users
FROM banks
CROSS JOIN UNNEST(includes.users) AS t(users)
)
select users.id, users.location, users.name,
users.public_metrics.followers_count,
users.public_metrics.following_count,
users.public_metrics.tweet_count,
users.public_metrics.listed_count,
users.username
from users_prep;

/*Step 5 - Load prediction */
CREATE EXTERNAL TABLE Prediction (
    `id` string,
    `created_at` STRING,
    `text` STRING,
    `lang` STRING,
    `vader_prediction` string,
    `textblob__Subjectivity` STRING,
    `textblob_Polarity` STRING,
    `textblob_Prediction` STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ("separatorChar" = ",", "escapeChar" = "\\")
LOCATION 's3://huvicto//Prediction_CSV/';

create table prediction2 as
select *, case when text like '%uber%'
then 'uber'
when text like '%door%' then 'doordash'
when text like '%skip%' then 'skipthedishes' end as tag
from prediction;





-- 1. Calculate and plot the ecdf of votes per question 
drop table if exists Q1; 
create table Q1 as
select 
  postid
, count(*) as votes
from votes
group by postid;

drop table if exists Q2Data;
create table Q2Data as
select a.postid, a.views,
ifnull(b.votes,0) as votes from 
(select distinct id as postid, 
ifnull(viewcount,0) as views
from posts ) a 
left outer join
(select postid,
count(*) as votes
from votes
group by postid) b
on a.postid=b.postid;

drop table if exists Q3data; 
create table Q3Data as
select ElapsedMins from 
(select distinct b.postid,b.id,
(strftime('%s',b.creationdate) - strftime('%s',a.creationdate))/60 as ElapsedMins
from posts a,
comments b
where a.id=b.postid)
where ElapsedMins > 0;

drop table if exists Q4Data; 
create table Q4Data as
select distinct id,
(strftime('%s',lastactivitydate) - strftime('%s',creationdate))/60 as ElapsedMins 
from posts 
order by id;

drop table if exists Q5Data; 
create table Q5Data as
select b.postid,
avg(length(b.text)) as Length_Comment,
avg(length(a.body)) as Length_Post
from posts a,
comments b
where a.id=b.postid
group by b.postid
order by b.postid;

drop table if exists Q6Data_a; 
create table Q6Data_a as
select owneruserid,
count(distinct id) as Num_Q
from posts
where owneruserid > 0
group by OwnerUserId
order by OwnerUserId;

drop table if exists Q6Data_b; 
create table Q6Data_b as
select owneruserid,
sum(ifnull(answerCount,0))/3 as Nbr_Ans
from posts
where owneruserid > 0
group by OwnerUserId
order by OwnerUserId;

drop table if exists Q6Data_c; 
create table Q6Data_c as
select distinct a.owneruserid,
a.Num_Q,
b.Nbr_Ans
from Q6Data_a a,
Q6Data_b b
where a.owneruserid=b.owneruserid
order by a.owneruserid;

drop table Q7data; 
create table Q7Data as
select distinct id,
ifnull(answercount,0) as answers
from posts
order by id;

-- 8. Does the hour of the day when a question is asked matter in terms of getting an answer? 

drop table if exists Q8_tmp; 
create table Q8_tmp as
select distinct id,
strftime('%H',creationdate) as Hour,
ifnull(AnswerCount,0) as Answers
from posts;


drop table if exists Q8Data; 
create table Q8Data as
select hour, avg(answers) as avgAns
from Q8_tmp
group by hour
order by hour;



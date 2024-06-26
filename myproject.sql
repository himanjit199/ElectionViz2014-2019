use data;
select * from constituency_wise_results_2019;
select * from constituency_wise_results_2014;
select * from din_states_codes;

-- DATA Cleaning PART : 

-- duplicate check
select distinct(pc_name) as pc_name from constituency_wise_results_2019 group by x.pc_name having x.count()>1;

select x.count(),x.pc_name from
(select distinct(pc_name) as pc_name from constituency_wise_results_2014) as x group by x.pc_name having x.count()>1;


-- for security execution 
SET SQL_SAFE_UPDATES = 0;

-- for update telengana with AP 
UPDATE constituency_wise_results_2014
SET state = 'Telangana'
WHERE  state = 'Andhra Pradesh';

-- adding year column 

ALTER TABLE constituency_wise_results_2019
ADD COLUMN year INT;
update constituency_wise_results_2019
set year = 2019;
ALTER TABLE constituency_wise_results_2014
ADD COLUMN year INT;
update constituency_wise_results_2014
set year = 2014;

ALTER TABLE constituency_wise_results_2019
ADD COLUMN year_new INT DEFAULT 2019;
UPDATE constituency_wise_results_2019
SET year = 2019;

--- answering the question :
-- 1 . highest turnout by pc_name 2014 

select x.pc_name ,round((x.total_votes_new/x.total_electors)*100,2) as turnout from
(select pc_name,sum(total_votes)as total_votes_new ,total_electors from constituency_wise_results_2014 group by pc_name,total_electors) as x order by (x.total_votes_new/x.total_electors)*100 desc limit 5;

select x.pc_name ,round((x.total_votes_new/x.total_electors)*100,2) as turnout from
(select pc_name,sum(total_votes)as total_votes_new ,total_electors from constituency_wise_results_2014 group by pc_name,total_electors) as x order by (x.total_votes_new/x.total_electors)*100 asc limit 5;

-- --2.highest turnout by pc_name 2019 

select x.pc_name ,round((x.total_votes_new/x.total_electors)*100,2) as turnout from
(select pc_name,sum(total_votes)as total_votes_new ,total_electors from constituency_wise_results_2019 group by pc_name,total_electors) as x order by (x.total_votes_new/x.total_electors)*100 desc limit 5;

select x.pc_name ,round((x.total_votes_new/x.total_electors)*100,2) as turnout from
(select pc_name,sum(total_votes)as total_votes_new ,total_electors from constituency_wise_results_2019 group by pc_name,total_electors) as x order by (x.total_votes_new/x.total_electors)*100 asc limit 5;

-- 3 . turnout ratio 2019 by state 
with cte as (
select sum(x.total_votes_new) as total_vote , sum(x.total_electors) as total_electors_state ,x.state from
(select state,sum(total_votes)as total_votes_new ,total_electors from constituency_wise_results_2019 group by state,total_electors) as x group by x.state )
select cte.state,(cte.total_vote/cte.total_electors_state)*100 as turnout  from cte order by (cte.total_vote/cte.total_electors_state)*100 desc limit 5;
with cte as 
(select sum(x.total_votes_new) as total_vote , sum(x.total_electors) as total_electors_state ,x.state from
(select state,sum(total_votes)as total_votes_new ,total_electors from constituency_wise_results_2019 group by state,total_electors) as x group by x.state )
select cte.state,(cte.total_vote/cte.total_electors_state)*100 as turnout  from cte order by (cte.total_vote/cte.total_electors_state)*100 asc limit 5;

-- turnout ratio 2014 by state 


with cte as 
(select sum(x.total_votes_new) as total_vote , sum(x.total_electors) as total_electors_state ,x.state from
(select state,sum(total_votes)as total_votes_new ,total_electors from constituency_wise_results_2014 group by state,total_electors) as x group by x.state )
select cte.state,(cte.total_vote/cte.total_electors_state)*100 as turnout  from cte order by (cte.total_vote/cte.total_electors_state)*100 asc limit 5;

with cte as 
(select sum(x.total_votes_new) as total_vote , sum(x.total_electors) as total_electors_state ,x.state from
(select state,sum(total_votes)as total_votes_new ,total_electors from constituency_wise_results_2014 group by state,total_electors) as x group by x.state )
select cte.state,(cte.total_vote/cte.total_electors_state)*100 as turnout  from cte order by (cte.total_vote/cte.total_electors_state)*100 desc limit 5;

-- question 3 

with cte as
(select a.pc_name,a.party,a.total_votes,a.year,  RANK() OVER(PARTITION BY  pc_name ORDER BY total_votes DESC) AS rank_by_vote from constituency_wise_results_2014 as a)
 select cte.pc_name,cte.party,cte.total_votes,cte.year,cte.rank_by_vote from cte where cte.rank_by_vote=1;
 with rank_new as 
(select pc_name,party,total_votes,year,  RANK() OVER(PARTITION BY  pc_name ORDER BY total_votes DESC) AS rank_by_votes from constituency_wise_results_2019 as b)
select rank_new.name,rank_new.party,rank_new.total_votes,rank_new.year from cte  where rank_new.rank_by_votes=1;
select y.pc_name,y.percent_vote,y.rank_ from
(select x.pc_name,x.percent_vote,rank()over(partition by x.pc_name order by x.percent_vote desc)as rank_ from
(with cte as 
(select sum(a.total_votes) as percentage ,a.pc_name from constituency_wise_results_2019 as a group by pc_name)
select b.total_votes,cte.percentage,cte.pc_name,b.total_votes/percentage as percent_vote from cte join  constituency_wise_results_2019 as b on cte.pc_name = b.pc_name) as x ) as y where y.rank_=1;

select * from rank2019_state;
select * from rank2014_state;
select * from votes;
with cte as 
(select a.pc_name,a.party from rank2019_state as a join rank2014_state as b on a.pc_name = b.pc_name and a.party=b.party)
select cte.pc_name,cte.party,round(a.percent_vote*100) as percent_votes from cte join votes as a on cte.pc_name=a.pc_name order by round(a.percent_vote*100) desc;

-- question 5  
 with cte as 
(select x.* from
(select pc_name,candidate as candidates,rank()over(partition by pc_name order by total_votes desc) as ranking,total_votes as total_1 from constituency_wise_results_2014) as x where x.ranking = 1) 
 
select p.candidates ,(p.total_1-p.total_votes) as difference_votes from
(select cte.candidates,x.candidate,cte.total_1,x.total_votes from 
(select x.* from
(select pc_name,candidate,rank()over(partition by pc_name order by total_votes desc) as ranking,total_votes from constituency_wise_results_2014) as x where x.ranking = 2 )as x join cte on x.pc_name=cte.pc_name) as p order by (p.total_1-p.total_votes) desc limit 5;

with cte as 
(select x.* from
(select pc_name,candidate as candidates,rank()over(partition by pc_name order by total_votes desc) as ranking,total_votes as total_1 from constituency_wise_results_2019) as x where x.ranking = 1) 
 
select p.candidates ,(p.total_1-p.total_votes) as difference_votes from
(select cte.candidates,x.candidate,cte.total_1,x.total_votes from 
(select x.* from
(select pc_name,candidate,rank()over(partition by pc_name order by total_votes desc) as ranking,total_votes from constituency_wise_results_2019) as x where x.ranking = 2 )as x join cte on x.pc_name=cte.pc_name) as p order by (p.total_1-p.total_votes) desc limit 5;

-- vote split national level(question 6)
select x.party,(x.total_votes_party_2014/(select sum(total_votes) from constituency_wise_results_2014))*100 as 2014_vote_split,
(x.total_votes_party_2019/(select sum(total_votes) from constituency_wise_results_2019))*100 as 2019_vote_split from
(select a.*,b.total_votes_party_2019 from 
(select party,sum(total_votes) as total_votes_party_2014 from constituency_wise_results_2014 group by party) a join
(select party,sum(total_votes) as total_votes_party_2019 from constituency_wise_results_2019 group by party) b on 
a.party=b.party) as x order by (x.total_votes_party_2019/(select sum(total_votes) from constituency_wise_results_2019))*100 desc;

-- vote split state level(question 7)


select a.*,b.total_votes_party_2019 from 
(select party,sum(total_votes) as total_votes_party_2014 from constituency_wise_results_2014 group by party) a join
(select party,sum(total_votes) as total_votes_party_2019 from constituency_wise_results_2019 group by party) b on 
a.party=b.party;

WITH state_totals AS (
    SELECT 
        state,
        SUM(total_votes) AS state_total_votes
    FROM 
        constituency_wise_results_2019
    GROUP BY 
        state
)
SELECT 
    cwr.state,
    cwr.party,
    SUM(cwr.total_votes) AS total_votes,
    (SUM(cwr.total_votes) * 100.0 / st.state_total_votes) AS percentage_of_state_votes
FROM 
    constituency_wise_results_2019 cwr
JOIN 
    state_totals st
ON 
    cwr.state = st.state
GROUP BY 
    cwr.state, 
    cwr.party, 
    st.state_total_votes
ORDER BY 
    cwr.state, 
    (SUM(cwr.total_votes) * 100.0 / st.state_total_votes) desc,cwr.party;
    
    WITH state_totals AS (
    SELECT 
        state,
        SUM(total_votes) AS state_total_votes
    FROM 
        constituency_wise_results_2014
    GROUP BY 
        state
)
SELECT 
    cwr.state,
    cwr.party,
    SUM(cwr.total_votes) AS total_votes,
    (SUM(cwr.total_votes) * 100.0 / st.state_total_votes) AS percentage_of_state_votes
FROM 
    constituency_wise_results_2014 cwr
JOIN 
    state_totals st
ON 
    cwr.state = st.state
GROUP BY 
    cwr.state, 
    cwr.party, 
    st.state_total_votes
ORDER BY 
    cwr.state, 
    (SUM(cwr.total_votes) * 100.0 / st.state_total_votes) desc,cwr.party;
 select * from split_2019;
select * from split_2014;
select a.state,a.party,a.total_votes as 2019_total_votes,b.total_votes as 2014_total_votes,a.percentage_of_state_votes as 2019_split_votes,b.percentage_of_state_votes as 2014_split_votes
from split_2019 as a join split_2014 as b on a.party=b.party and a.state =b.state order by a.state , a.percentage_of_state_votes desc ,b.percentage_of_state_votes desc;

-- List top 5 constituencies for two major national parties where they have gained vote share in 2019 as compared to 2014.

  WITH constituency_totals AS (
    SELECT 
        pc_name,
        SUM(total_votes) AS state_total_votes
    FROM 
        constituency_wise_results_2019
    GROUP BY 
        pc_name)
        
SELECT 
    cwr.pc_name,
    cwr.party,
    SUM(cwr.total_votes) AS total_votes,
    (SUM(cwr.total_votes) * 100.0 / st.state_total_votes) AS percentage_of_state_votes
FROM 
    constituency_wise_results_2019 cwr
JOIN 
    constituency_totals st
ON 
    cwr.pc_name = st.pc_name
where cwr.party in ('BJP','INC')    
GROUP BY 
    cwr.pc_name, 
    cwr.party, 
    st.state_total_votes 
   order by  
           cwr.pc_name;
   select * from vote_pc_2019;
   select * from vote_pc_2014;  
select  a.pc_name,a.party,(a.percentage_of_state_votes-b.percentage_of_state_votes) as gained from vote_pc_2014 as a join
vote_pc_2019 as b on a.pc_name = b.pc_name and a.party=b.party where (a.percentage_of_state_votes-b.percentage_of_state_votes)>0 and a.party = "INC"
order by (a.percentage_of_state_votes-b.percentage_of_state_votes) desc  limit 5; 
select  a.pc_name,a.party,(a.percentage_of_state_votes-b.percentage_of_state_votes) as gained from vote_pc_2014 as a join
vote_pc_2019 as b on a.pc_name = b.pc_name and a.party=b.party where (a.percentage_of_state_votes-b.percentage_of_state_votes)>0 and a.party = "BJP"
order by (a.percentage_of_state_votes-b.percentage_of_state_votes) desc  limit 5;

-- --lost vote share 
select  a.pc_name,a.party,(a.percentage_of_state_votes-b.percentage_of_state_votes) as lost from vote_pc_2014 as a join
vote_pc_2019 as b on a.pc_name = b.pc_name and a.party=b.party where (a.percentage_of_state_votes-b.percentage_of_state_votes)<0 and a.party = "INC"
order by (a.percentage_of_state_votes-b.percentage_of_state_votes) asc  limit 5;
select  a.pc_name,a.party,(a.percentage_of_state_votes-b.percentage_of_state_votes) as lost from vote_pc_2014 as a join
vote_pc_2019 as b on a.pc_name = b.pc_name and a.party=b.party where (a.percentage_of_state_votes-b.percentage_of_state_votes)<0 and a.party = "BJP"
order by (a.percentage_of_state_votes-b.percentage_of_state_votes) asc  limit 5;

select pc_name , sum(total_votes),total_electors,total_electors-sum(total_votes) from constituency_wise_results_2019 group by pc_name,total_electors;
select * from constituency_wise_results_2019; 
with state_party_votes as( SELECT 
        state,
        party,
        SUM(total_votes) AS party_total_votes
    FROM 
        constituency_wise_results_2019
    GROUP BY 
        state, party),
state_total_votes AS (
    SELECT 
        state,
        SUM(total_votes) AS state_total_votes
    FROM 
        constituency_wise_results_2019
    GROUP BY 
        state
),party_vote_share AS (
    SELECT 
        spv.state,
        spv.party,
        spv.party_total_votes,
        stv.state_total_votes,
        (spv.party_total_votes * 100.0 / stv.state_total_votes) AS vote_share
    FROM 
        state_party_votes spv
    JOIN 
        state_total_votes stv
    ON 
        spv.state = stv.state
),
elected_candidates AS (
    SELECT 
        state,
        pc_name,
        party,
        total_votes,
        candidate,
        rank()over(partition by pc_name order by total_votes desc) as rank_voter
    FROM 
        constituency_wise_results_2019
    
        
)
SELECT 
    ec.state,
    ec.pc_name,
    ec.party,
    ec.total_votes,
    pvs.vote_share,
    ec.candidate
FROM 
    elected_candidates ec
JOIN 
    party_vote_share pvs
ON 
    ec.state = pvs.state
AND 
    ec.party = pvs.party
WHERE 
    pvs.vote_share < 10
    and ec.rank_voter=1
ORDER BY 
    ec.state, ec.pc_name; 

-- question no 4 

WITH rank_2019 AS (
    SELECT 
        pc_name,
        party,
        total_votes,
        candidate,
        RANK() OVER (PARTITION BY pc_name ORDER BY total_votes DESC) AS rank_voter
    FROM 
        constituency_wise_results_2019
),
rank_2014 AS (
    SELECT 
        pc_name,
        party,
        total_votes,
        candidate,
        RANK() OVER (PARTITION BY pc_name ORDER BY total_votes DESC) AS rank_voter
    FROM 
        constituency_wise_results_2014
)
SELECT 
    r2019.pc_name,
    r2019.party AS party_2019,
    r2014.party AS party_2014,
    r2019.candidate AS candidate_2019,
    r2014.candidate AS candidate_2014,
    (r2019.total_votes - r2014.total_votes) as difference_votes
FROM 
    rank_2019 r2019
JOIN 
    rank_2014 r2014
ON 
    r2019.pc_name = r2014.pc_name
WHERE 
    r2019.rank_voter = 1
AND 
    r2014.rank_voter = 1
AND 
    r2019.party <> r2014.party
ORDER BY 
	(r2019.total_votes - r2014.total_votes) desc limit 10;  

   select * from constituency_wise_results_2019;
   select * from constituency_wise_results_2014;
   select x.pc_name ,round((x.total_votes_new/x.total_electors)*100,2) as turnout from
(select pc_name,sum(total_votes)as total_votes_new ,total_electors,sum(postal_votes) as postel_votes  from constituency_wise_results_2014 group by pc_name,total_electors,postal_votes) as x order by (x.total_votes_new/x.total_electors)*100 desc ;
select x.pc_name,sum(x.postel_votes) as total_postel,(x.total_votes_new/x.total_electors)*100 as turnout_ratio from
(select pc_name,sum(total_votes)as total_votes_new ,total_electors,sum(postal_votes) as postel_votes  from constituency_wise_results_2014 group by pc_name,total_electors,postal_votes) as x
group by x.pc_name,x.total_votes_new,x.total_electors ;
WITH cte AS (
    SELECT 
        state,
        SUM(total_votes) AS total_votes_new,
        SUM(total_electors) AS total_electors_state
    FROM 
        constituency_wise_results_2019
    GROUP BY 
        state
),
turnout_data AS (
    SELECT 
        state,
        (total_votes_new / total_electors_state) * 100 AS turnout
    FROM 
        cte
)
SELECT 
    b.State,
    a.Literacy,
    b.turnout
FROM 
    turnout_data AS b
JOIN 
    GOI AS a 
ON 
    a.states = b.state
    order by a.Literacy desc,  b.turnout desc;
















# Election Data Analysis: 2014 & 2019

 * # Project Overview
This project involves analyzing election commission data from the years 2014 and 2019. Using  SQLfor data extraction and transformation, and PowerBI for data visualization, we aim to uncover insights and trends from the election data. The project addresses various questions related to voter turnout, party performance, and electoral patterns.

 * # Data Cleaning
Data might contain constituencies spelling mismatches and some constituencies may be listed with identical names. Proper validation is required. In 2014, Andhra Pradesh underwent bifurcation. For simplicity, all constituencies from that year should be attributed to Telangana state. This includes constituencies such as Adilabad, Hyderabad, Warangal, etc., which should be considered part of Telangana rather than Andhra Pradesh for the year 2014.

*  # Data Transformation
Establish suitable dimension tables and primary keys to link the CSV files effectively.
Construct aggregate tables using append and groupby functions as needed to format the data appropriately for answering the queries.

 *  # Questions from the Available Data (Primary)

 * List top 5/bottom 5 constituencies of 2014 and 2019 in terms of voter turnout ratio.
* List top 5/bottom 5 states of 2014 and 2019 in terms of voter turnout ratio.
* Which constituencies have elected the same party for two consecutive elections? Rank them by % of votes to that winning party in 2019.
* Which constituencies have voted for different parties in two elections? List top 10 based on the difference (2019-2014) in winner vote percentage in two elections.
* Top 5 candidates based on margin difference with runners in 2014 and 2019.
* % Split of votes of parties between 2014 vs 2019 at the national level.
* % Split of votes of parties between 2014 vs 2019 at the state level.
* List top 5 constituencies for two major national parties where they have gained vote share in 2019 as compared to 2014.
* List top 5 constituencies for two major national parties where they have lost vote share in 2019 as compared to 2014.
* Which constituencies have elected candidates whose party has less than 10% vote share at the state level in 2019?

 # Further Analysis & Recommendations
  This will require additional research using secondary data:

 * Is there a correlation between postal votes % and voter turnout %?
* Is there any correlation between GDP of a state and voter turnout %?
* Is there any correlation between literacy % of a state and voter turnout %?
* Provide 3 recommendations on what the election commission/government can do to increase the voter turnout %.

# References
https://www.kaggle.com/datasets/siddheshmahajan/indias-gdp-statewise *  (For GDP of indian states)

https://www.kaggle.com/datasets/doncorleone92/govt-of-india-literacy-rate   * (For literacy rate of Indian states)

# Conclusion
The project aims to deliver actionable insights into electoral patterns and voter behavior by meticulously cleaning and transforming the data and addressing various analytical questions. The insights derived can inform policy decisions and strategies to enhance democratic participation in future elections.
# Repository Structure
* data/: Contains the raw and cleaned data files.
* scripts/: SQL scripts for data extraction and transformation.
* visualizations/: PowerBI dashboards and visualizations.
# visualization Link (dashboard)

* https://app.powerbi.com/groups/me/reports/0baa6d6e-e11a-4963-8039-cce2b06545f8/2d90c5cc86c85466dd58?experience=power-bi&bookmarkGuid=499119cb4d0ff1eb3a41
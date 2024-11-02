# Introduction
Dive into the data job market! Focusing on data analyst roles, this project explores  top-paying jobs,
in-demand skills, and / where high demand meets high salary in data analytics.
SQL queries? Check them out here:[project_sql folder](/project_sql/)

# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.
Data hails from my [SQL Coursel (https:/ lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential
skills.
### The questions I wanted to answer through my
SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?
# Tools I Used
For my deep dive into the data analyst job market,
I harnessed the power of several key tools:
- **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code**: My go-t for database management and executing SQL queries.
- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
# The 
Each query for this project aimed at investigating specific aspects of the data analyst job market.
Here's how I approached each question:
### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles? I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

``` sql
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    C.name AS Company_name
FROM 
    job_postings_fact AS J
LEFT JOIN company_dim AS C ON J.company_id = C.company_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location ='Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY 
        salary_year_avg DESC
LIMIT 10
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the
field.
- **Diverse Employers:** Companies Like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and Specializations within data analytics.

### 2. Top Paying Job Skills
``` sql
WITH top_paying_jobs as (
    SELECT 
        job_id,
        job_title,
        salary_year_avg,
        C.name AS Company_name

FROM 
    job_postings_fact AS J
LEFT JOIN 
    company_dim AS C ON J.company_id = C.company_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location ='Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM 
    top_paying_jobs
INNER JOIN 
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC
```

Here's the breakdown of the most demanded skills for data analysts in 2023, based or postings:
• SQL is leading with a bold count of 8.
• Python follows closely with a bold count of 7.
• Tableau is also highly sought after, with a bold count of 6.
• Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.
### 3. Top Demanded Skills
```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short ='Data Analyst' AND
    job_work_from_home = True
GROUP BY 
    skills
ORDER BY
     demand_count DESC
```

### 4. Top Paying Skills
```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS salary_avg
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short ='Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY
     salary_avg DESC
LIMIT 25
```
Here's a breakdown of the results for the top paying skills for a Data Analyst thats working from home...
-High Demand for Big Data & ML Skills: Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
-Software Development & Deployment Proficiency: Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
-Cloud Computing Expertise: Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

### 5. Optimal Skills
```sql
WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM 
        job_postings_fact
    INNER JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN 
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short ='Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY 
        skills_dim.skill_id

) , average_salary AS (
    SELECT 
        skills_job_dim.skill_id, 
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM 
        job_postings_fact
    INNER JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN 
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short ='Data Analyst' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY 
        skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM 
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25




- rewriting this same query more concisely
SELECT
    skills_dim.skill_id, 
    skills_dim.skills,
    COUNT (skills_job_dim.job_id) AS demand_count, 
    ROUND (AVG (job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT (skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC, 
    demand_count DESC
LIMIT 25;
```
The reason for these Query is to find the most optimal skills to learn aka it's in high demand and a high-paying Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis*/





# What i Learned
SQL Proficiency: Enhanced my skills in writing complex SQL queries and performing data manipulation effectively.

Data Analysis Techniques: Gained experience in extracting and analyzing meaningful information from large datasets.

Industry Insights: Developed a deeper understanding of industry trends, in-demand skills, and salary ranges for data analyst positions.

Data Visualization: Improved my ability to visualize data effectively to communicate insights.

Data-Driven Decision-Making: Reinforced the importance of using data to inform decisions in the job market and to shape career paths in analytics.

Real-World Application: Learned how to apply technical skills to solve real-world problems and derive actionable insights.

Data Manipulation: Learning how to insert, update, and delete data effectively and safely.

# Conclusion
This SQL project focused on analyzing a dataset of data analyst job postings, providing insights into industry trends, skills in demand, and salary ranges. Through this experience, I enhanced my skills in SQL query writing, data manipulation, and data visualization techniques. I gained a deeper understanding of how to extract meaningful information from large datasets and how to use SQL to inform decision-making in the job market. This project has not only sharpened my technical abilities but also reinforced the importance of data-driven insights in shaping career paths in the analytics field.

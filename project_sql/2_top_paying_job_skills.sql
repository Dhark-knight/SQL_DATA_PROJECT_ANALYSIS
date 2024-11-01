SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_yeaar_avg,
    job_posted_date
FROM 
    job_postings_factWITH top_paying_jobs as (
    SELECT 
    job_id,
    job_title,
    salary_year_avg,
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
)

SELECT 
    top_paying_jobs.*,
    skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
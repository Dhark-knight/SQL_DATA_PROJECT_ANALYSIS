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
-- national_monthly
SELECT month, SUM((att_t1+att_t2+att_oth+bk_t1+bk_t2+bk_oth)) AS attendances, SUM((o4_t1+o4_t2+o4_oth+o4bk_t1+o4bk_t2+o4bk_oth)) AS over_4hrs,
       ROUND(100.0*(SUM((att_t1+att_t2+att_oth+bk_t1+bk_t2+bk_oth))-SUM((o4_t1+o4_t2+o4_oth+o4bk_t1+o4bk_t2+o4bk_oth)))/SUM((att_t1+att_t2+att_oth+bk_t1+bk_t2+bk_oth)),1) AS pct_within_4hrs,
       ROUND(100.0*(SUM(att_t1+bk_t1)-SUM(o4_t1+o4bk_t1))/SUM(att_t1+bk_t1),1) AS type1_pct_within_4hrs,
       SUM(dta_12) AS waits_12hr_from_decision_to_admit,
       SUM(adm_t1+adm_t2+adm_oth+adm_other) AS emergency_admissions
FROM ae GROUP BY month ORDER BY month;

-- financial_year_summary
SELECT CASE WHEN CAST(strftime('%m',month) AS INT)>=4 THEN strftime('%Y',month) ELSE CAST(strftime('%Y',month)-1 AS TEXT) END AS fy_start,
       ROUND(SUM((att_t1+att_t2+att_oth+bk_t1+bk_t2+bk_oth))/1e6,2) AS attendances_m,
       ROUND(100.0*(SUM((att_t1+att_t2+att_oth+bk_t1+bk_t2+bk_oth))-SUM((o4_t1+o4_t2+o4_oth+o4bk_t1+o4bk_t2+o4bk_oth)))/SUM((att_t1+att_t2+att_oth+bk_t1+bk_t2+bk_oth)),1) AS pct_within_4hrs,
       SUM(dta_12) AS waits_12hr_dta
FROM ae GROUP BY fy_start ORDER BY fy_start;

-- region_latest_year
SELECT "Parent Org" AS region, ROUND(SUM((att_t1+att_t2+att_oth+bk_t1+bk_t2+bk_oth))/1e6,2) AS attendances_m,
       ROUND(100.0*(SUM((att_t1+att_t2+att_oth+bk_t1+bk_t2+bk_oth))-SUM((o4_t1+o4_t2+o4_oth+o4bk_t1+o4bk_t2+o4bk_oth)))/SUM((att_t1+att_t2+att_oth+bk_t1+bk_t2+bk_oth)),1) AS pct_within_4hrs,
       RANK() OVER (ORDER BY 1.0*SUM((o4_t1+o4_t2+o4_oth+o4bk_t1+o4bk_t2+o4bk_oth))/SUM((att_t1+att_t2+att_oth+bk_t1+bk_t2+bk_oth))) AS rank_best
FROM ae WHERE month >= '2025-04-01' GROUP BY region ORDER BY rank_best;

-- worst_type1_trusts_latest_year
WITH t AS (SELECT "Org name" AS trust, SUM(att_t1+bk_t1) AS t1_att, SUM(o4_t1+o4bk_t1) AS t1_o4
           FROM ae WHERE month >= '2025-04-01' GROUP BY trust HAVING SUM(att_t1+bk_t1) > 50000)
SELECT trust, t1_att AS type1_attendances, ROUND(100.0*(t1_att-t1_o4)/t1_att,1) AS type1_pct_within_4hrs
FROM t ORDER BY type1_pct_within_4hrs LIMIT 10;

-- leicester_vs_england
SELECT month,
  ROUND(100.0*(SUM(CASE WHEN "Org Code"='RWE' THEN (att_t1+att_t2+att_oth+bk_t1+bk_t2+bk_oth) END)-SUM(CASE WHEN "Org Code"='RWE' THEN (o4_t1+o4_t2+o4_oth+o4bk_t1+o4bk_t2+o4bk_oth) END))/SUM(CASE WHEN "Org Code"='RWE' THEN (att_t1+att_t2+att_oth+bk_t1+bk_t2+bk_oth) END),1) AS leicester_pct,
  ROUND(100.0*(SUM((att_t1+att_t2+att_oth+bk_t1+bk_t2+bk_oth))-SUM((o4_t1+o4_t2+o4_oth+o4bk_t1+o4bk_t2+o4bk_oth)))/SUM((att_t1+att_t2+att_oth+bk_t1+bk_t2+bk_oth)),1) AS england_pct
FROM ae GROUP BY month ORDER BY month;
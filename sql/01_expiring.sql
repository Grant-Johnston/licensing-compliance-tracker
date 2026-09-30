-- Active licenses expiring within 90 days
SELECT
  p.full_name,
  j.state_name,
  l.line_of_authority,
  l.expiration_date,
  DATEDIFF(l.expiration_date, CURDATE()) AS days_left,
  CASE
    WHEN DATEDIFF(l.expiration_date, CURDATE()) <= 30 THEN '0-30'
    WHEN DATEDIFF(l.expiration_date, CURDATE()) <= 60 THEN '31-60'
    ELSE '61-90'
  END AS bucket
FROM license l
JOIN producer p     ON l.producer_id = p.id
JOIN jurisdiction j ON l.state_code = j.state_code
WHERE l.status = 'active'
  AND p.status = 'active'
  AND l.expiration_date BETWEEN CURDATE() AND CURDATE() + INTERVAL 90 DAY
ORDER BY l.expiration_date;

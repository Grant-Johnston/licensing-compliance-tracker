-- License counts by state, split by condition
SELECT
  j.state_code,
  j.state_name,
  COUNT(l.id) AS total,
  SUM(l.status = 'active' AND l.expiration_date >= CURDATE()) AS in_force,
  SUM(l.status = 'active' AND l.expiration_date <  CURDATE()) AS lapsed,
  SUM(l.status = 'expired')                                   AS closed_out
FROM jurisdiction j
JOIN license l ON l.state_code = j.state_code
GROUP BY j.state_code, j.state_name
ORDER BY total DESC, j.state_name;

-- Licenses past their expiration date but still flagged as active
SELECT
  p.full_name,
  p.npn,
  p.status AS producer_status,
  j.state_name,
  l.line_of_authority,
  l.license_number,
  l.expiration_date,
  DATEDIFF(CURDATE(), l.expiration_date) AS days_lapsed
FROM license l
JOIN producer p     ON l.producer_id = p.id
JOIN jurisdiction j ON l.state_code = j.state_code
WHERE l.status = 'active'
AND l.expiration_date < CURDATE()
ORDER BY days_lapsed DESC;

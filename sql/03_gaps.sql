-- Active producers with no license on file at all
SELECT
  p.id, p.full_name, p.npn, p.hire_date
FROM producer p
LEFT JOIN license l ON l.producer_id = p.id
WHERE p.status = 'active'
  AND l.id IS NULL
ORDER BY p.hire_date;

-- Licensing states where there is no current coverage
SELECT
  j.state_code, j.state_name, j.ce_hours
FROM jurisdiction j
LEFT JOIN license l
       ON l.state_code = j.state_code
      AND l.status = 'active'
WHERE j.requires_license = 1
  AND l.id IS NULL
ORDER BY j.state_name;

-- Every producer with their license count, next expiry, and states
SELECT
  p.id,
  p.full_name,
  p.status,
  COUNT(l.id) AS licenses,
  MIN(CASE WHEN l.status = 'active' THEN l.expiration_date END) AS next_expiration,
  GROUP_CONCAT(DISTINCT l.state_code ORDER BY l.state_code SEPARATOR ' ') AS states
FROM producer p
LEFT JOIN license l ON l.producer_id = p.id
GROUP BY p.id, p.full_name, p.status
ORDER BY licenses ASC, p.full_name;

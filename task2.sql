SELECT id +1
FROM list l1
WHERE NOT EXISTS(
    SELECT id
    FROM list l2
    WHERE l2.id  = l1.id +1)
LIMIT 1;

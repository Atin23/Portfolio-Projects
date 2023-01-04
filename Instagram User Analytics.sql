/*
Instagram User Analytics
*/

-- Queries used: Subqueries, Joins, Aggregation, GROUP BY, Distinct and other functions required.


-- MARKETING
#############################################################################
-- 1) 5 oldest users of the Instagram
 
SELECT 
    username, created_at
FROM
    users
ORDER BY created_at
LIMIT 5;

#############################################################################
-- 2) Find the users who have never posted a single photo on Instagram

SELECT * FROM photos;
SELECT * FROM users;

SELECT 
    u.id, u.username
FROM
    users u
        LEFT JOIN
    photos p ON u.id = p.user_id
WHERE
    p.created_dat IS NULL;

#############################################################################
-- 3  The user with the most likes on a single photo

SELECT * FROM photos;
SELECT * FROM likes;

SELECT 
    p.user_id,
    u.username,
    l.photo_id,
    COUNT(l.photo_id) AS no_of_likes
FROM
    likes l
        JOIN
    photos p ON l.photo_id = p.id
        JOIN
    users u ON p.user_id = u.id
GROUP BY l.photo_id , p.user_id , u.username
ORDER BY COUNT(l.photo_id) DESC
LIMIT 1;


#############################################################################
-- 4)  Identify and suggest the top 5 most commonly used hashtags on the platform

SELECT * FROM tags;
SELECT * FROM photo_tags;

SELECT 
    t.id, t.tag_name, COUNT(pt.photo_id)
FROM
    tags t
        JOIN
    photo_tags pt 
    ON t.id = pt.tag_id
GROUP BY t.id , t.tag_name
ORDER BY COUNT(pt.photo_id) DESC
LIMIT 5;

#############################################################################
-- 5)  What day of the week do most users register on ?

SELECT 
    DAYNAME(created_at) AS DAY,
    COUNT(DAYNAME(created_at)) AS COUNT
FROM
    users
GROUP BY DAY
ORDER BY COUNT DESC
LIMIT 1;

#############################################################################
#############################################################################
#############################################################################
-- INVESTOR METRICS

-- 1) a)Provide how many times does average user posts on Instagram.
SELECT 
    ((SELECT 
            COUNT(*)
        FROM
            photos) / (SELECT 
            COUNT(DISTINCT u.id)
        FROM
            users u
                LEFT JOIN
            photos p ON u.id = p.user_id
        WHERE
            p.created_dat IS NOT NULL)) AS posts_by_avg_user;

-- 1) b)provide the total number of photos on Instagram/total number of users
SELECT ROUND((SELECT COUNT(*) FROM photos)/(SELECT COUNT(*)FROM users),2);


-- 2) BOT Accounts
SELECT 
    l.user_id, u.username, COUNT(l.photo_id) AS num
FROM
    likes l
        JOIN
    users u ON l.user_id = u.id
GROUP BY l.user_id
HAVING num = (SELECT 
        COUNT(*)
    FROM
        photos);
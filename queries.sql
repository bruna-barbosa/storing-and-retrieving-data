use doctor;

/*All queries are optimized since the execution time is always smaller than 0.1 seconds so it 
can't be classified as slow. We used always the indexes/foreign keys when doing the queries.*/ 

#1 
/*Since the execution time is 0.015 seconds we fell that this query is optimized*/
SELECT P.name, A.date, concat('Consulta de ',S.name) AS service
FROM appointment A
JOIN patient P
ON A.patient_health_number = P.health_number
JOIN doctor D
ON A.doctor_health_number = D.health_number
JOIN speciality_has_doctor SD
ON D.health_number = SD.doctor_health_number
JOIN speciality S
ON SD.speciality_slug = S.slug
WHERE A.date BETWEEN '2010-01-01' AND '2021-12-12';


#2 
/*The best was considered to be the top three clinic with the best ratings.
  About the otimization, since the execution time is 0.016 seconds we fell that this query is optimized as well*/
SELECT C.name, round(AVG(R.rating_clinic),1) AS Ratings 
FROM rating R
JOIN appointment A
ON R.rating_id = A.rating_id 
JOIN clinic C
ON C.clinic_id = A.clinic_clinic_id 
GROUP BY C.clinic_id
ORDER BY Ratings desc 
LIMIT 3;

#3 
/* This query is a bit more slow then the above ones, 0.031 seconds, although we need to take in consideration 
that are done many calculations which can take a bit more time.However we fell that this query is optimized*/
SELECT '01/2018 – 12/2021' AS PeriodOfSales, concat(ROUND(sum(I.price),2), '€') AS TotalSales, concat(ROUND(sum(I.price)/(year('2021-12-12')-year('2018-01-01')),2), '€')  AS YearlyAverage,  concat(ROUND(DATEDIFF('2021-12-12','2018-01-01')/30,0), '€')  AS MonthlyAverage
FROM appointment A
JOIN invoice I
ON I.appointment_appointment_id = A.appointment_id
WHERE A.date BETWEEN '2018-01-01' AND '2021-12-12';

#4
/* We fell that this query is optimized as well*/
SELECT C.zipcode AS Zipcode, C.name AS Name_of_Clinic, concat(ROUND(sum(I.price),2), '€')  AS TotalSales
FROM appointment A
JOIN invoice I
ON I.appointment_appointment_id = A.appointment_id
JOIN clinic C
ON C.clinic_id = A.clinic_clinic_id 
GROUP BY C.clinic_id;

#5 
/*As it's possible to see the clinic 'Clinica Antero de Quental' doesn't appear here since 
there is no appointments in this clinic yet.
About the otimization, we fell that this query is optimized as well since the execution time is 0.016 seconds*/
SELECT C.name AS City, ROUND(AVG(R.rating_appointment),1) AS Ratings 
FROM appointment A
JOIN clinic C
ON C.clinic_id = A.clinic_clinic_id 
JOIN rating R
ON R.rating_id  = A.rating_id 
GROUP BY C.clinic_id;

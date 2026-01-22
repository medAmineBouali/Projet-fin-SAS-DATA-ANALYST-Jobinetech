
-- Nombre de trajets dans chaque saisons
SELECT SUM("Nombre de trajets") as total_trajets, "Saison"
FROM london_bikes_final
GROUP BY "Saison";

-- Nombre de trajets sous chaque condition d'humidité
SELECT SUM("Nombre de trajets") as total_trajets,
        CASE
        WHEN "Humidité" < 0.3 THEN 'Very Dry'
        WHEN "Humidité" BETWEEN 0.3 AND 0.39 THEN 'Dry'
        WHEN "Humidité" BETWEEN 0.4 AND 0.59 THEN 'Comfortable'
        WHEN "Humidité" BETWEEN 0.6 AND 0.69 THEN 'Humid'
        ELSE 'Very Humid'
    END AS humidity_category
FROM london_bikes_final
GROUP BY humidity_category
ORDER BY total_trajets DESC;

-- Nombre de trajets par jour
SELECT SUM("Nombre de trajets") as total_trajets,
CASE
        WHEN EXTRACT(DOW from "timestamp") = 0 THEN 'Lundi'
        WHEN EXTRACT(DOW from "timestamp") = 1 THEN 'Mardi'
        WHEN EXTRACT(DOW from "timestamp") = 2 THEN 'Mercredi'
        WHEN EXTRACT(DOW from "timestamp") = 3 THEN 'Jeudi'
        WHEN EXTRACT(DOW from "timestamp") = 4 THEN 'Vendredi'
        WHEN EXTRACT(DOW from "timestamp") = 5 THEN 'Samedi'
        WHEN EXTRACT(DOW from "timestamp") = 6 THEN 'Dimanche'
    END AS jour_de_la_semaine,
EXTRACT(DOW from "timestamp") as id_jour
FROM london_bikes_final
GROUP BY id_jour
ORDER BY id_jour;

-- moyenne des nombres de trajets par jour
SELECT ROUND(AVG("Nombre de trajets"),2) as Moyenne_trajets,
DATE("timestamp") as jour
FROM london_bikes_final
GROUP BY jour
ORDER BY jour;

-- moyenne des nombres de trajets par jour de mois
SELECT ROUND(AVG("Nombre de trajets"),2) as Moyenne_trajets,
Extract(DAY from "timestamp") as jour
FROM london_bikes_final
GROUP BY jour
ORDER BY jour;

-- moyenne des nombres de trajets par jour d'année
SELECT ROUND(AVG("Nombre de trajets"),2) as Moyenne_trajets,
Extract(DOY from "timestamp") as jour
FROM london_bikes_final
GROUP BY jour
ORDER BY jour;


-- moyenne des nombres de trajets par heure de jour
SELECT ROUND(AVG("Nombre de trajets"),2) as Moyenne_trajets,
EXTRACT(HOUR from "timestamp") + 1 as heur
FROM london_bikes_final
GROUP BY heur
ORDER BY heur;

-- pour avoir les Heures ou les jours avec le plus de trajets
-- on fait ORDER BY Moyenne_trajets
-- et ajout limit N

-- exemple N = 5
SELECT ROUND(AVG("Nombre de trajets"),2) as Moyenne_trajets,
EXTRACT(HOUR from "timestamp") + 1 as heur
FROM london_bikes_final
GROUP BY heur
ORDER BY Moyenne_trajets desc
LIMIT 5;

-- comparaison entre la moyenne des trajets week-end vs semaine
SELECT ROUND(AVG("Nombre de trajets"),2) as Moyenne_trajets, is_weekend
FROM london_bikes_final
GROUP BY is_weekend
ORDER BY Moyenne_trajets desc;

-- Autres requettes

-- les 3 conditions metéo plus preferées pour faire des trajets
SELECT ROUND(AVG("Nombre de trajets"),2) as Moyenne_trajets,
"Météo"
FROM london_bikes_final
GROUP BY "Météo"
ORDER BY Moyenne_trajets desc
LIMIT 3;

-- comparaison entre la moyenne des trajets holiday vs non-holiday
SELECT ROUND(AVG("Nombre de trajets"),2) as Moyenne_trajets, is_holiday
FROM london_bikes_final
GROUP BY is_holiday
ORDER BY Moyenne_trajets desc;

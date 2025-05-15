
-- ======================================================================================
-- Base de données   : formation_numcity
-- Type              : MariaDB
-- Auteur            : Inoth (exercice de formation Merise)
-- Création          : 2025
-- Objectif          : Système évolutif pour recensement citoyen des lieux utiles à la ville
-- ======================================================================================

-- Nettoyage complet
DROP DATABASE IF EXISTS formation_numcity;
CREATE DATABASE formation_numcity;
USE formation_numcity;

-- ======================================================================================
-- Création des tables
-- ======================================================================================

-- Utilisateurs citoyens
CREATE TABLE utilisateur (
    id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mot_de_passe TEXT NOT NULL,
    date_inscription DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Zones de la ville
CREATE TABLE zone (
    id_zone INT AUTO_INCREMENT PRIMARY KEY,
    nom_zone VARCHAR(100) NOT NULL,
    description TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Points GPS définissant les contours d’une zone
CREATE TABLE point_gps (
    id_point INT AUTO_INCREMENT PRIMARY KEY,
    id_zone INT NOT NULL,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    FOREIGN KEY (id_zone) REFERENCES zone(id_zone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Lieux proposés par les citoyens
CREATE TABLE lieu (
    id_lieu INT AUTO_INCREMENT PRIMARY KEY,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    type_lieu ENUM('Parking vélo', 'Borne recharge rapide', 'Borne recharge lente', 'Autre') NOT NULL,
    zone_id INT,
    propose_par INT,
    modifier_par INT DEFAULT NULL,
    statut ENUM('en attente', 'validé', 'refusé') DEFAULT 'en attente',
    date_proposition DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (zone_id) REFERENCES zone(id_zone),
    FOREIGN KEY (propose_par) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY (modifier_par) REFERENCES utilisateur(id_utilisateur)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Équipements additionnels
CREATE TABLE equipement (
    id_equipement INT AUTO_INCREMENT PRIMARY KEY,
    nom_equipement VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Association Lieux ↔ Équipements (relation N:N)
CREATE TABLE lieu_equipement (
    id_lieu INT NOT NULL,
    id_equipement INT NOT NULL,
    PRIMARY KEY (id_lieu, id_equipement),
    FOREIGN KEY (id_lieu) REFERENCES lieu(id_lieu),
    FOREIGN KEY (id_equipement) REFERENCES equipement(id_equipement)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ======================================================================================
-- Insertion de données de test
-- ======================================================================================

-- Utilisateurs
INSERT INTO utilisateur (nom, email, mot_de_passe) VALUES
('Alice Dupont', 'alice@mail.com', 'hash1'),
('Bob Martin', 'bob@mail.com', 'hash2');

-- Zones
INSERT INTO zone (nom_zone, description) VALUES
('Centre-ville', 'Zone centrale urbaine'),
('Quartier Est', 'Zone résidentielle et calme');

-- Points GPS
INSERT INTO point_gps (id_zone, latitude, longitude) VALUES
(1, 45.7600, 4.8350),
(1, 45.7610, 4.8360),
(1, 45.7620, 4.8370),
(2, 45.7700, 4.8500),
(2, 45.7710, 4.8510);

-- Lieux
INSERT INTO lieu (latitude, longitude, type_lieu, zone_id, propose_par, modifier_par, statut) VALUES
(45.7605, 4.8355, 'Parking vélo', 1, 1, NULL, 'validé'),
(45.7615, 4.8365, 'Borne recharge rapide', 1, 2, 1, 'validé'),
(45.7705, 4.8505, 'Borne recharge lente', 2, 1, NULL, 'en attente');

-- Équipements
INSERT INTO equipement (nom_equipement) VALUES
('Compresseur pneus'),
('Toit abrité'),
('Caméra de sécurité');

-- Lien équipements ↔ lieux
INSERT INTO lieu_equipement (id_lieu, id_equipement) VALUES
(2, 1),
(2, 3),
(3, 2);

-- ======================================================================================
-- Vue pour exploitation : lieux validés et leurs équipements
-- ======================================================================================
CREATE OR REPLACE VIEW vue_lieux_valides_equipements AS
SELECT l.id_lieu, l.type_lieu, l.latitude, l.longitude, z.nom_zone,
       u.nom AS propose_par, u2.nom AS modifier_par,
       GROUP_CONCAT(e.nom_equipement SEPARATOR ', ') AS equipements
FROM lieu l
LEFT JOIN utilisateur u ON l.propose_par = u.id_utilisateur
LEFT JOIN utilisateur u2 ON l.modifier_par = u2.id_utilisateur
LEFT JOIN zone z ON l.zone_id = z.id_zone
LEFT JOIN lieu_equipement le ON l.id_lieu = le.id_lieu
LEFT JOIN equipement e ON le.id_equipement = e.id_equipement
WHERE l.statut = 'validé'
GROUP BY l.id_lieu;

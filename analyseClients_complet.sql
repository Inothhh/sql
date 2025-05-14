
-- ======================================================================================
-- Base de données   : analyseClients
-- Type              : MariaDB 10.x
-- Auteur            : l'ami
-- Création          : 2025
-- ======================================================================================

START TRANSACTION;

-- ======================================================================================
-- Suppression et création de la base de données
-- ======================================================================================
DROP DATABASE IF EXISTS analyseClients;
CREATE DATABASE analyseClients;
USE analyseClients;

-- ======================================================================================
-- Création des tables
-- ======================================================================================

CREATE TABLE clients (
    cliID INT NOT NULL AUTO_INCREMENT,
    cliNom VARCHAR(50) NOT NULL,
    cliEmail VARCHAR(100) NOT NULL UNIQUE,
    dateInscription DATE,
    CONSTRAINT PK_clients PRIMARY KEY (cliID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE produits (
    proID INT NOT NULL AUTO_INCREMENT,
    proNom VARCHAR(100) NOT NULL,
    categorie VARCHAR(50),
    prix DECIMAL(10,2),
    CONSTRAINT PK_produits PRIMARY KEY (proID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE transactions (
    traID INT NOT NULL AUTO_INCREMENT,
    cliID INT NOT NULL,
    proID INT NOT NULL,
    dateAchat DATE,
    quantite INT,
    montantTotal DECIMAL(10,2),
    CONSTRAINT PK_transactions PRIMARY KEY (traID),
    CONSTRAINT FK_transactions_clients FOREIGN KEY (cliID) REFERENCES clients(cliID),
    CONSTRAINT FK_transactions_produits FOREIGN KEY (proID) REFERENCES produits(proID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ======================================================================================
-- Insertion des enregistrements
-- ======================================================================================

INSERT INTO clients VALUES
    (NULL, 'Alice Dupont', 'alice@mail.com', '2022-01-15'),
    (NULL, 'Bob Martin', 'bob@mail.com', '2023-04-22'),
    (NULL, 'Claire Durand', 'claire@mail.com', '2023-11-03'),
    (NULL, 'David Lopez', 'david@mail.com', '2024-02-14'),
    (NULL, 'Emma Leroy', 'emma@mail.com', '2024-03-01');

INSERT INTO produits VALUES
    (NULL, 'Abonnement Premium', 'Service', 49.99),
    (NULL, 'Formation SQL', 'Cours', 99.00),
    (NULL, 'Pack Analyse Prédictive', 'Logiciel', 299.00),
    (NULL, 'Ebook Data Science', 'Livre', 29.99),
    (NULL, 'Atelier Python', 'Atelier', 79.00);

INSERT INTO transactions VALUES
    (NULL, 1, 1, '2023-05-10', 1, 49.99),
    (NULL, 1, 2, '2023-06-12', 1, 99.00),
    (NULL, 2, 3, '2024-01-07', 1, 299.00),
    (NULL, 3, 4, '2024-03-15', 1, 29.99),
    (NULL, 4, 1, '2024-03-20', 1, 49.99),
    (NULL, 5, 5, '2024-04-10', 2, 158.00),
    (NULL, 2, 5, '2024-04-11', 1, 79.00),
    (NULL, 3, 2, '2024-04-12', 1, 99.00),
    (NULL, 4, 3, '2024-04-13', 1, 299.00),
    (NULL, 5, 4, '2024-04-14', 1, 29.99);

-- ======================================================================================
-- Validation de la transaction
-- ======================================================================================
COMMIT;

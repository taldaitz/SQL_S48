CREATE DATABASE formation;

SHOW DATABASES;

USE formation;

SHOW TABLES;

DROP TABLE animal;
DROP TABLE espece;
DROP TABLE enclos;
DROP TABLE secteur;

CREATE TABLE animal (
	id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    date_de_naissance DATE,
    taille INT NOT NULL,
    poids INT NOT NULL
);

CREATE TABLE espece (
	id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    dangereux BOOLEAN,
    sensible BOOLEAN
);

CREATE TABLE enclos (
	id INT PRIMARY KEY AUTO_INCREMENT,
    numero INT NOT NULL,
    couvert BOOLEAN,
    horaire_ouverture TIME NOT NULL,
    horaire_fermeture TIME NOT NULL
);

CREATE TABLE secteur (
	id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL UNIQUE,
    ouvert BOOLEAN NOT NULL
);

ALTER TABLE animal
	ADD COLUMN espece_id INT NOT NULL,
	ADD COLUMN remarques TEXT NULL;
    
ALTER TABLE animal
	ADD COLUMN espece_id INT NOT NULL;
    
ALTER TABLE animal
	ADD COLUMN remarques TEXT NULL;
    
DESCRIBE animal;

ALTER TABLE animal
	ADD COLUMN enclos_id INT NOT NULL;
    
ALTER TABLE enclos
	ADD COLUMN secteur_id INT NOT NULL;

INSERT INTO secteur (nom, ouvert)
VALUES('Jungle', true);

INSERT INTO secteur (nom, ouvert)
VALUES ('Desert', false),
	('Montagne', true),
	('Foret', true)
;

DESCRIBE secteur;

INSERT INTO contact (prenom, nom, tel)
VALUES('Aldaitz', 'Thomas', '06123153156');

INSERT INTO enclos (numero,couvert,horaire_ouverture,horaire_fermeture,secteur_id)
VALUES (1, true,'09:00','15:00',1),
	(12, false,'08:00','17:00',3),
    (34, true,'10:00','14:00',4);

INSERT INTO espece(nom,dangereux,sensible)
		VALUES('girafe',false,true),
        ('marmotte',false,false);
        
INSERT INTO animal(nom,date_de_naissance,taille,poids,remarques,espece_id,enclos_id)
	VALUES('girafon','2022-12-25','300','200','trop beau',1,1),
		('gigi','2003-03-23','250','150','yeux bleus',1,1),
        ('milka','2023-01-01','30','07','gourmand',2,12);
        
UPDATE espece
SET dangereux = true
WHERE nom = 'girafe'
;


UPDATE animal
SET remarques =  CONCAT( remarques, ' - Vacciné le 27/11/2023')
WHERE id = 3;

UPDATE secteur
SET ouvert = false;

USE formation;

DESCRIBE full_order;


/*Ceci est un commentaire*/
SELECT * FROM full_order
WHERE id BETWEEN 113534 AND 113667
AND customer_firstname = 'Thomas';

/*-> Le nom, prénom et email des clients dont le prénom est "Julien"*/
SELECT customer_lastname, customer_firstname, customer_email
FROM full_order
WHERE customer_firstname = 'Julien';

/*-> Le nom, prénom et email des clients dont l'email termine par "@gmail.com"*/
SELECT customer_lastname, customer_firstname, customer_email
FROM full_order
WHERE customer_email LIKE '%@gmail.com';

/*-> toutes les commandes  non payées*/

SELECT * 
FROM full_order
WHERE is_paid = false;

/*-> toutes les commandes  payées mais non livré (sans date de livraison)*/
SELECT * 
FROM full_order
WHERE is_paid = true
AND shipment_date is null
;

/*-> toutes les commandes  livré hors de France (avec une date de livraison)*/
SELECT * 
FROM full_order
WHERE shipment_date is not null
AND shipment_country <> 'France'
;

/*-> toutes les commandes au montant de plus 8000€ ordonnées du plus grand
au plus petit*/

SELECT *
FROM full_order
WHERE amount > 8000
ORDER BY amount DESC;

/*-> La commande au montant le plus bas (une seule)*/

SELECT *
FROM full_order
ORDER BY amount LIMIT 1;

/*-> toutes les commandes réglé en Cash en 2022 livré en France dont 
le montant est inférieur à 5000 €**/

SELECT *
FROM full_order
WHERE payment_type = 'Cash'
AND YEAR(payment_date) = 2022
AND shipment_country = 'France'
AND amount < 5000 ;

/*-> toutes les commandes payés par carte OU payé aprés le 15/10/2021*/
SELECT *
FROM full_order
WHERE payment_type = 'Credit Card'
OR (payment_date > '2021-10-15' AND payment_type = 'Check');

/*-> les 3 dernières commandes envoyées en France*/
SELECT *
FROM full_order
WHERE shipment_country = 'France'
ORDER BY shipment_date DESC
LIMIT 3;


/*-> la somme des commandes non payés*/

SELECT ROUND(SUM(amount), 2) AS total_amount
FROM full_order
WHERE is_paid = false;

/*-> la moyenne des montants des commandes payés en cash*/
SELECT ROUND(AVG(amount), 2) AS Moyenne_Cash
FROM full_order
WHERE payment_type = 'Cash';

/*-> le nombre de client dont le nom est "Laporte"*/
SELECT COUNT(id)
FROM full_order
WHERE customer_lastname = 'Laporte'
;

/*-> Le nombre de jour Maximum entre la date de payment 
et la date de livraison -> DATEDIFF()*/

SELECT MAX(DATEDIFF(payment_date, shipment_date))
FROM full_order
;

/*Verif*/
SELECT payment_date, shipment_date, DATEDIFF(payment_date, shipment_date) AS nbDays
FROM full_order
ORDER BY nbDays DESC
;


/*-> Le délai moyen (en jour) de réglement d'une commande*/
SELECT AVG(DATEDIFF(payment_date, date))
FROM full_order
WHERE payment_date IS NOT NULL
;

/*Verif*/
SELECT payment_date, date, DATEDIFF(payment_date, date)
FROM full_order
WHERE payment_date IS NOT NULL
;

/*-> le nombre de commande payés en chèque sur 2021*/
SELECT COUNT(id)
FROM full_order
WHERE payment_type = 'Check'
AND YEAR(payment_date) = 2021
;

/*-> Le montant total des commandes par type de paiement*/
SELECT payment_type, ROUND(SUM(amount), 2) AS totalCommande
FROM full_order
WHERE payment_type is not null
GROUP BY payment_type;

/*-> La moyenne des montants des commandes par Pays*/
SELECT shipment_country, ROUND(AVG(amount),2) AS MoyenneMontant
FROM full_order
WHERE shipment_country is not null
GROUP BY shipment_country
ORDER BY MoyenneMontant DESC;

/*-> Par année la somme des commandes*/
SELECT YEAR(date) AS annee, ROUND(SUM(amount), 2)
FROM full_order
GROUP BY annee
ORDER BY annee
;

/*-> Liste des clients (nom, prénom) qui ont au moins deux commandes*/
SELECT customer_lastname, customer_firstname, COUNT(id)
FROM full_order
GROUP BY customer_lastname, customer_firstname
	HAVING COUNT(id) >= 2
ORDER BY customer_lastname, customer_firstname
;

SELECT * FROM animal;
SELECT * FROM espece;
SELECT * FROM enclos;

DELETE FROM espece WHERE id = 1;

SELECT animal.nom, espece.nom 
FROM animal, espece
WHERE espece_id = espece.id
;

SELECT *
FROM animal ani 
	LEFT JOIN espece esp ON ani.espece_id = esp.id
;


/*Création de contrainte d'intégrité*/

ALTER TABLE animal
ADD CONSTRAINT FK_animal_espece
FOREIGN KEY animal(espece_id)
REFERENCES espece(id) ON DELETE CASCADE
;

ALTER TABLE animal	
ADD CONSTRAINT FK_animal_enclos
FOREIGN KEY animal(enclos_id)
REFERENCES enclos(id);
 
ALTER TABLE enclos
ADD CONSTRAINT FK_enclos_secteur
FOREIGN KEY enclos(secteur_id)
REFERENCES secteur(id);




SELECT * FROM customer;
SELECT * FROM bill;
SELECT * FROM line_item;
SELECT * FROM product;
SELECT * FROM category;


/*-> Pour chaque client (nom, prénom) remonter le nombre de facture associé*/
SELECT firstname, lastname, COUNT(bill.id)
FROM customer
	JOIN bill ON customer.id = bill.customer_id
GROUP BY firstname, lastname
ORDER BY lastname, firstname
;

/*-> Pour chaque catégorie la moyenne des prix de produits associés*/

SELECT ca.id, ca.label, ROUND(AVG(pro.unit_price), 2) AS MoyennePrix
FROM category ca
	JOIN product pro ON ca.id = pro.category_id
GROUP BY ca.id
;


/*-> Pour Chaque produit la quantité commandée depuis le 01/01/2021 */
SELECT pro.name, SUM(li.quantity)
FROM product pro 
	LEFT JOIN line_item li ON pro.id = li.product_id 
    LEFT JOIN bill bil ON bil.id = li.bill_id
WHERE bil.date > '2021-01-01'
GROUP BY pro.id
ORDER BY pro.id
;


/*-> La liste des Facture (ref) qui ont plus de 2 produits différends commandé*/
SELECT ref, COUNT(product_id) AS nbProduct
FROM bill 
	JOIN line_item ON bill.id = line_item.bill_id
GROUP BY ref
	HAVING nbProduct > 2
ORDER BY ref
;



/*-> Pour chaque Facture afficher le montant total*/

SELECT ref, SUM(quantity * unit_price)
FROM bill	
	JOIN line_item ON bill.id = line_item.bill_id
    JOIN product ON product.id = line_item.product_id
GROUP BY ref
ORDER BY ref;


/*-> Pour chaque client compter le nombre de produit différents qu'il a commandé*/

SELECT customer.id, COUNT(product_id) 
FROM customer 
	JOIN bill ON customer.id = bill.customer_id
    JOIN line_item ON bill.id = line_item.bill_id
GROUP BY customer.id
;


/*-> pour chaque catégorie de produit la somme des facture payées*/

SELECT category.label, SUM(unit_price * quantity)
FROM product
	JOIN line_item ON line_item.product_id = product.id
    JOIN bill ON bill.id = line_item.bill_id
    JOIN category ON category.id = product.category_id
WHERE is_paid = true
GROUP BY category.id
ORDER by category.id
;


/*-> par Année de facture la moyenne d'age des clients*/
SELECT YEAR(date) AS Annee, ROUND(AVG(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())), 0) AS AgeMoyen
FROM customer
	JOIN bill ON bill.customer_id = customer.id
GROUP BY Annee
ORDER BY Annee;



/*-> les nom, prénom et num de tel des clients qui ont commandé des produits de 
camping ces deux dernières années.*/

SELECT lastname, firstname, phone_number
FROM customer
	JOIN bill on customer.id = bill.customer_id
    JOIN line_item ON line_item.bill_id = bill.id
    JOIN product ON line_item.product_id = product.id
    JOIN category ON category.id = product.category_id
WHERE label = 'Camping'
AND TIMESTAMPDIFF(YEAR, date, CURDATE()) <= 2
GROUP BY customer.id
ORDER BY lastname, firstname;


/*-> La moyenne d'age des consomateurs pour chaque catégorie de produit*/
SELECT category.label, ROUND(AVG(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())), 0) AS AgeMoyen
FROM customer
	JOIN bill on customer.id = bill.customer_id
    JOIN line_item ON line_item.bill_id = bill.id
    JOIN product ON line_item.product_id = product.id
    JOIN category ON category.id = product.category_id
GROUP BY category.id
ORDER BY category.label;


SELECT * FROM category
WHERE id NOT IN (22,
				24, 
                26, 
                28)
;


ALTER TABLE customer
	ADD COLUMN is_vip BOOL NULL;


SELECT customer_id
FROM bill 
	JOIN line_item ON line_item.bill_id = bill.id
    JOIN product ON line_item.product_id = product.id
GROUP BY customer_id
	HAVING SUM(quantity * unit_price) > 10000
;


UPDATE customer
SET is_vip = true
WHERE id IN (
	SELECT customer_id
	FROM bill 
		JOIN line_item ON line_item.bill_id = bill.id
		JOIN product ON line_item.product_id = product.id
	GROUP BY customer_id
		HAVING SUM(quantity * unit_price) > 10000
);




CREATE VIEW view_bill_with_amount AS
SELECT bill.*, SUM(quantity * unit_price) AS montant_fact
FROM bill	
	JOIN line_item ON line_item.bill_id = bill.id
    JOIN product ON line_item.product_id = product.id
GROUP BY bill.id
;

SELECT * FROM view_bill_with_amount;

SELECT lastname, firstname, SUM(montant_fact), COUNT(ref)
FROM customer 
	JOIN view_bill_with_amount ON customer.id = view_bill_with_amount.customer_id
GROUP BY customer.id
ORDER BY COUNT(ref) DESC
LIMIT 3;


SELECT lastname, firstname, montant_fact
FROM customer 
	JOIN view_bill_with_amount ON customer.id = view_bill_with_amount.customer_id
ORDER BY montant_fact DESC
LIMIT 3;


SELECT lastname, firstname, SUM(montant_fact)
FROM customer 
	JOIN view_bill_with_amount ON customer.id = view_bill_with_amount.customer_id
GROUP BY customer.id
ORDER BY SUM(montant_fact) DESC
LIMIT 3;


ALTER VIEW view_bill_with_amount AS
SELECT bill.*, SUM(quantity * unit_price) AS montant_fact
FROM bill	
	JOIN line_item ON line_item.bill_id = bill.id
    JOIN product ON line_item.product_id = product.id
GROUP BY bill.id
;


DELIMITER //
CREATE PROCEDURE testProcedure(nom varchar(50), prenom varchar(50))
BEGIN

	INSERT INTO customer (lastname, firstname, phone_number, date_of_birth, email)
    VALUES(nom, prenom, '062131351', '1985-04-28', 'taldaitz@dawan.fr');

END//

SELECT * FROM customer WHERE lastname = 'Aldaitz';

CALL testProcedure('Aldaitz', 'Guillaume');




SELECT AVG(montant_fact)
FROM view_bill_with_amount;

SELECT customer_id
	FROM bill 
		JOIN line_item ON line_item.bill_id = bill.id
		JOIN product ON line_item.product_id = product.id
	GROUP BY customer_id
		HAVING SUM(quantity * unit_price) > (SELECT AVG(montant_fact)
											FROM view_bill_with_amount);
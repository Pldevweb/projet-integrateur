/*********************************/
/* CRÉATION DE LA BASE DE DONNÉE */
/*********************************/

-- Si la base de donnée existe déjà, nous devons la supprimer
DROP DATABASE IF EXISTS dbproject;

-- Si la base de donnée n'existe pas, nous devons la créer
-- et lui attribuer utf8 en character set
CREATE DATABASE IF NOT EXISTS dbproject
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Nous appelons notre base de donnée pour l'utiliser
USE dbproject;

/*********************************/
/*      CRÉATION DES TABLES      */
/*********************************/

/*
	CRÉATION DE LA TABLE DES CATÉGORIES
	Celle-ci doit être créée en premier, car sa clé primaire
    est utilisée par les suivantes : la table des produits et la table des sous-catégories.
    
    POURQUOI UNE TABLE CATÉGORIES ?
    - Pour filtrer les recherches des clients
*/

CREATE TABLE tblCategories (
    idCategory INT NOT NULL AUTO_INCREMENT,
    categoryName VARCHAR(50) NOT NULL,
    PRIMARY KEY (idCategory)
);

/*
	CRÉATION DE LA TABLE DES SOUS-CATÉGORIES
	Celle-ci doit être créée en deuxième, car sa clé primaire
    est utilisée par la suivante : la table des produits.
    
    POURQUOI UNE TABLE SOUS-CATÉGORIES ?
    - Pour filtrer d'avantage les recherches des clients
    - Afin de simplifier la création de la page "Build my PC" (une seule composante par sous-catégorie permise)
*/

CREATE TABLE tblSubcategories (
    idSubcategory INT NOT NULL AUTO_INCREMENT,
    subcategoryName VARCHAR(50) NOT NULL,
    idCategory INT NOT NULL,
    PRIMARY KEY (idSubcategory),
    FOREIGN KEY (idCategory) REFERENCES tblCategories(idCategory)
);

/*
	CRÉATION DE LA TABLE DES UTILISATEURS
	- Celle-ci doit être créée en troisième, car sa clé primaire
    est utilisée par la suivante : la table des clients.

	POURQUOI UNE TABLE UTILISATEUR ?
    - Tout le monde peut s'inscrire sur notre site internet sans
    nécessairement acheter des produits.
    - Un utilisateur peut utiliser plusieurs adresses, plusieurs méthodes de paiement,
    voire même plusieurs noms et prénoms (si plusieurs membres d'un même foyer
    utilisent le même compte pour commander).
*/
    
CREATE TABLE tblUsers (
    idUser INT NOT NULL AUTO_INCREMENT,
    userName VARCHAR(25) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    passwordHash CHAR(60) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (idUser)
);

/*
	CRÉATION DE LA TABLE DES CLIENTS
	Celle-ci doit être créée en quatrième, car sa clé primaire
    est utilisée par la suivante : la table des commandes.
    
    POURQUOI UNE TABLE CLIENTS ?
    - Pour connaître le nom et prénom de l'acheteur, ainsi que l'adresse
    de livraison. Nous ajoutons le numéro de téléphone
    en cas de problème de livraison.
    - Le champ "apartmentNumber" peut être utilisé pour les numéros de suite, unité,
    immeuble, étage, etc... et il est facultatif en cas où l'adresse
    serait celle d'une maison.
    - Créer un enregistrement de la table "tblCustomers" est requis
    seulement si l'utilisateur désire acheter un ou des produit(s).
*/

CREATE TABLE tblCustomers (
    idCustomer INT NOT NULL AUTO_INCREMENT,
    idUser INT NOT NULL,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    apartmentNumber INT,
    city VARCHAR(50) NOT NULL,
    province VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    zipCode VARCHAR(20) NOT NULL,
    PRIMARY KEY (idCustomer),
    FOREIGN KEY (idUser) REFERENCES tblUsers(idUser)
);

/*
	CRÉATION DE LA TABLE DES PRODUITS
	Celle-ci doit être créée en cinquième, puisque sa clé primaire
    est utilisée par la suivante : la table des produits dans une commande client.
    
    POURQUOI UNE TABLE PRODUITS ?
    - Il s'agit du coeur de notre site internet. Ce sont les produits à vendre.
    - Les champs : nom du produit, l'image et catégorie sont essentiel pour aider
    l'identification d'un produit.
    - Les clients doivent connaître le prix du produit pour décider s'ils peuvent
    se permettre de l'acheter.
    - Le champ description peut aider les clients à comprendre les fonctionnalités
    et avantages du produit, ainsi qu'à aider leur décision de l'acheter.
*/

CREATE TABLE tblProducts (
    idProduct INT NOT NULL AUTO_INCREMENT,
    productName VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    idCategory INT NOT NULL,
    idSubcategory INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    image VARCHAR(255) NOT NULL,
    PRIMARY KEY (idProduct),
    FOREIGN KEY (idCategory) REFERENCES tblCategories(idCategory),
    FOREIGN KEY (idSubcategory) REFERENCES tblSubcategories(idSubcategory)
    );
    
/*
	CRÉATION DE LA TABLE DES COMMANDES
	Celle-ci doit être créée en sixième, car sa clé primaire
    est utilisée par la suivante : la table des produits.
    
    POURQUOI UNE TABLE COMMANDE ?
    - La table commande relie le client à sa commande détaillée
    (table de produits dans une commande client)
    - Elle possède également les détails concernant l'état de la commande,
    la date et son coût total.
*/

CREATE TABLE tblOrders (
    idOrder INT NOT NULL AUTO_INCREMENT,
    idCustomer INT NOT NULL,
    orderDate DATETIME NOT NULL,
    orderStatus VARCHAR(50) NOT NULL, -- envoyée, expédié, livraison reçue
    totalCost DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idOrder),
    FOREIGN KEY (idCustomer) REFERENCES tblCustomers(idCustomer)
);

/*
	CRÉATION DE LA TABLE DES PRODUITS DANS UNE COMMANDE
	Celle-ci doit être créée en dernier, car elle ne contient aucune clé
    primaire et elle utilise deux clés étrangères.
    
    POURQUOI UNE TABLE DES PRODUITS DANS UNE COMMANDE ?
    - Nous souhaitons ajouter plusieurs produits dans une même commande.
    Afin de respecter la troisième forme normale, nous devons créer un table
    qui servira à associer plusieurs id de produits à un seul id de commande.
    Cela n'est pas possible dans la table des commandes, puisque chaque
    idCommande doit être unique.
*/

CREATE TABLE tblOrderProducts (
    idOrder INT NOT NULL,
    idProduct INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (idOrder) REFERENCES tblOrders(idOrder),
    FOREIGN KEY (idProduct) REFERENCES tblProducts(idProduct)
);

/*********************************/
/* INSERTION DES ENREGISTREMENTS */
/*********************************/


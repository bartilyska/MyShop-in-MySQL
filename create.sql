CREATE TABLE Employees
(
	id INT  IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	surname VARCHAR(30) NOT NULL,
	position VARCHAR(255) CHECK (position IN ('kierownik', 'sprzedawca', 'ochroniarz','sprz¹tacz')) NOT NULL,
	contract_start DATE NOT NULL,
	contract_end DATE NOT NULL,/*potem moze check czy wieksza od start*/
	salary DECIMAL(10, 2) NOT NULL CHECK (salary > 0), 
	pesel CHAR(11) CHECK (pesel LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	gender CHAR(1) CHECK (gender IN('M','K')) NOT NULL,
	weekly_working_time INT DEFAULT 40 CHECK (weekly_working_time BETWEEN 20 AND 72),
	CONSTRAINT CheckContract CHECK(contract_end > contract_start)
);
CREATE UNIQUE INDEX Pesel
ON Employees(pesel)
WHERE pesel IS NOT NULL;
CREATE TABLE Working_hours 
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,/*ktos moze pracowac przez polnoc*/
    employee_id INT  REFERENCES Employees(id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	CONSTRAINT CheckValidTime CHECK (end_date > start_date)
);
CREATE TABLE Clients
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	surname VARCHAR(30), /*nie trzeba podac nazwiska*/
	phone_number CHAR(9) CHECK (phone_number LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	registration_date DATETIME DEFAULT GETDATE() NOT NULL ,
	status VARCHAR(15) CHECK ( status IN ('aktywny','wylogowany')) NOT NULL,
	gender CHAR(1) CHECK (gender IN('M','K')), /*mozna zalogowac sie bez podawania plci*/
);
CREATE TABLE Transactions
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    date DATETIME DEFAULT GETDATE() NOT NULL,
    overall_price DECIMAL(12, 2) CHECK (overall_price >= 0) NOT NULL,
    payment_method VARCHAR(10) CHECK(payment_method IN('karta','gotowka')) NOT NULL,
    cash_register_type VARCHAR(15) CHECK(cash_register_type IN('samoobs³ugowa','klasyczna')) NOT NULL,
    cash_register_number INT CHECK (cash_register_number BETWEEN 1 AND 5) NOT NULL, /*sklep ma do 5 kas kazdego typu */
    employee_id INT  REFERENCES Employees(id) ON DELETE SET NULL ON UPDATE CASCADE, /*moze byc puste przy samooblugowej*/
    client_id INT REFERENCES Clients(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT is_ok CHECK (
        (cash_register_type = 'samoobs³ugowa' AND employee_id IS NULL) OR 
        (cash_register_type = 'klasyczna')/*gdy zostanie usuniety to bedzie null*/
    )
);
CREATE TABLE Companies 
(
    krs CHAR(14) PRIMARY KEY,  
    name VARCHAR(100) NOT NULL,   
    country VARCHAR(50) NOT NULL,
    city VARCHAR(50),  
    main_type VARCHAR(50) NOT NULL
);
CREATE TABLE Suppliers 
(
    id INT IDENTITY(1,1) PRIMARY KEY,   
    name VARCHAR(30) NOT NULL,          
    surname VARCHAR(30) NOT NULL,       
    phone_number VARCHAR(9) CHECK (phone_number LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),          
    reliability_score INT CHECK (reliability_score BETWEEN 1 AND 10),
	company_krs CHAR(14) REFERENCES Companies(krs) ON DELETE CASCADE /*ON UPDATE CASCADE*/,
);
CREATE TABLE Deliveries
(
	id CHAR(18) PRIMARY KEY,/*unikalny ciag znakow dla dostawy*/  
	products_cost DECIMAL(15, 2) CHECK (products_cost >= 0) NOT NULL,
	transport_cost DECIMAL(15, 2) NOT NULL,
	status VARCHAR(20) CHECK(status IN('przygotowywana','dostarczono', 'oczekuje','anulowano')) NOT NULL,
	date_of_submission DATETIME,
	date_of_arrival DATETIME,
	everything_correct CHAR(3) CHECK(everything_correct IN('tak','nie')),
	comments VARCHAR (300),
	supplier_id INT REFERENCES Suppliers(id) ON DELETE CASCADE /*ON UPDATE CASCADE*/ NOT NULL,
	CONSTRAINT czy_ok CHECK (
        (status <> 'dostarczono' AND date_of_arrival IS NULL) OR(status = 'dostarczono' AND date_of_arrival IS NOT NULL AND date_of_submission < date_of_arrival)
    )
);
CREATE TABLE Products
(
    ean CHAR(13) PRIMARY KEY,          /*rzutowany kod kreskowy*/    
    name VARCHAR(50) NOT NULL,       
    type VARCHAR(100) NOT NULL,        /*gatunek produktu pieczywo itp*/
    unit_price DECIMAL(10, 2) NOT NULL, 
    amount_in_storage FLOAT NOT NULL,     /*dla tych na wage po przecinku*/
    vat DECIMAL(5, 2) CHECK(vat BETWEEN 0 AND 1) NOT NULL,         /*jako procent? najlepiej 5% 8% 23 % 0%*/
	company_krs CHAR(14) REFERENCES Companies(krs) ON DELETE SET NULL /*ON UPDATE CASCADE*/, /*z jakiej firmy*/
);
CREATE TABLE Delivery_products
(
	id INT IDENTITY(1,1) PRIMARY KEY,
    amount FLOAT NOT NULL, /*gdy jest produkt na wage to moze byc ulamek*/
    partial_cost DECIMAL(15, 2) NOT NULL,
	delivery_id CHAR(18) REFERENCES Deliveries(id) ON DELETE CASCADE  /*ON UPDATE CASCADE*/ NOT NULL,
	product_ean CHAR(13) REFERENCES Products(ean) ON DELETE SET NULL  /*ON UPDATE CASCADE*/,/*null gdy usuwane*/
);
CREATE TABLE Transaction_products
(
	id INT IDENTITY(1,1) PRIMARY KEY,
    amount FLOAT NOT NULL, /*gdy jest produkt na wage to ulamek*/
    partial_price DECIMAL(15, 2) NOT NULL,
	partial_vat DECIMAL(15,2) NOT NULL,
	transaction_number INT REFERENCES Transactions(id) ON DELETE CASCADE /*ON UPDATE CASCADE*/ NOT NULL,
	product_ean CHAR(13) REFERENCES Products(ean) ON DELETE SET NULL /*ON UPDATE CASCADE*/,
);
create schema crmproject;
use crmproject;

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Address TEXT,
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    Country VARCHAR(50),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create SalesOpportunities table
CREATE TABLE SalesOpportunities (
    OpportunityID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OpportunityName VARCHAR(100) NOT NULL,
    Description TEXT,
    Status ENUM('Open', 'In Progress', 'Closed - Won', 'Closed - Lost') NOT NULL,
    EstimatedValue DECIMAL(10, 2),
    CloseDate DATE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

-- Create Leads table
CREATE TABLE Leads (
    LeadID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Source VARCHAR(50),
    Status ENUM('New', 'Contacted', 'Qualified', 'Unqualified') NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create SupportTickets table
CREATE TABLE SupportTickets (
    TicketID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    Subject VARCHAR(100) NOT NULL,
    Description TEXT,
    Status ENUM('Open', 'In Progress', 'Resolved', 'Closed') NOT NULL,
    Priority ENUM('Low', 'Medium', 'High') NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

-- Create Campaigns table
CREATE TABLE Campaigns (
    CampaignID INT AUTO_INCREMENT PRIMARY KEY,
    CampaignName VARCHAR(100) NOT NULL,
    Description TEXT,
    StartDate DATE,
    EndDate DATE,
    Budget DECIMAL(10, 2),
    Status ENUM('Planning', 'Active', 'Completed', 'Cancelled') NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data into Customers
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address, City, State, ZipCode, Country) 
VALUES 
('John', 'Doe', 'john.doe@example.com', '555-1234', '123 Elm St', 'Springfield', 'IL', '62701', 'USA'),
('Jane', 'Smith', 'jane.smith@example.com', '555-5678', '456 Oak St', 'Lincoln', 'NE', '68508', 'USA'),
('Alice', 'Johnson', 'alice.johnson@example.com', '555-8765', '789 Pine St', 'Madison', 'WI', '53703', 'USA'),
('Bob', 'Brown', 'bob.brown@example.com', '555-4321', '101 Maple St', 'Columbus', 'OH', '43215', 'USA'),
('Carol', 'Davis', 'carol.davis@example.com', '555-6789', '202 Birch St', 'Denver', 'CO', '80202', 'USA');

-- Insert sample data into SalesOpportunities
INSERT INTO SalesOpportunities (CustomerID, OpportunityName, Description, Status, EstimatedValue, CloseDate) 
VALUES 
(1, 'New Product Launch', 'Opportunity to sell new product line.', 'Open', 12000.00, '2024-10-15'),
(2, 'Annual Service Contract', 'Renewal of annual service contract.', 'In Progress', 8000.00, '2024-11-30'),
(3, 'Software Upgrade', 'Upgrade existing software to latest version.', 'Closed - Won', 15000.00, '2024-09-01'),
(4, 'Consulting Services', 'Consulting services for new project.', 'Open', 5000.00, '2024-12-01'),
(5, 'Hardware Purchase', 'Sale of hardware components.', 'Closed - Lost', 2000.00, '2024-08-15');

-- Insert sample data into Leads
INSERT INTO Leads (FirstName, LastName, Email, Phone, Source, Status) 
VALUES 
('Emily', 'White', 'emily.white@example.com', '555-3456', 'Referral', 'New'),
('Michael', 'Green', 'michael.green@example.com', '555-7890', 'Trade Show', 'Contacted'),
('Sarah', 'Wilson', 'sarah.wilson@example.com', '555-2345', 'Website', 'Qualified'),
('David', 'Clark', 'david.clark@example.com', '555-6780', 'Social Media', 'Unqualified'),
('Laura', 'Lewis', 'laura.lewis@example.com', '555-9870', 'Advertisement', 'New');

-- Insert sample data into SupportTickets
INSERT INTO SupportTickets (CustomerID, Subject, Description, Status, Priority) 
VALUES 
(1, 'Login Issue', 'Customer unable to log in to the system.', 'In Progress', 'High'),
(2, 'Payment Discrepancy', 'Discrepancy in the payment received.', 'Open', 'Medium'),
(3, 'Installation Problem', 'Issue with installation of the product.', 'Resolved', 'High'),
(4, 'Feature Request', 'Request for new feature in the software.', 'Closed', 'Low'),
(5, 'Product Defect', 'Defect found in the purchased product.', 'In Progress', 'High');

-- Insert sample data into Campaigns
INSERT INTO Campaigns (CampaignName, Description, StartDate, EndDate, Budget, Status) 
VALUES 
('Winter Sale', 'Promotional campaign for winter clearance sale.', '2024-12-01', '2025-01-15', 25000.00, 'Active'),
('Spring Launch', 'Launch campaign for new spring collection.', '2024-03-01', '2024-05-31', 18000.00, 'Planning'),
('Summer Discounts', 'Summer discounts on selected products.', '2024-06-01', '2024-08-31', 22000.00, 'Active'),
('Holiday Specials', 'Holiday specials and festive offers.', '2024-11-01', '2024-12-31', 30000.00, 'Completed'),
('Back to School', 'Back-to-school promotions and discounts.', '2024-08-01', '2024-09-30', 15000.00, 'Cancelled');

select * from customers;
select * from SalesOpportunities;
select * from SupportTickets;
select * from Leads;
select * from Campaigns;

DELIMITER $$
create procedure customer_sales_status(
	 IN Status varchar(50)
)
BEGIN
	Select a.customerID,a.Firstname,a.Lastname,b.OpportunityName,b.Status 
    from customers as a INNER JOIN
    SalesOpportunities as b ON
    a.customerID = b.customerID where b.Status = Status;
END $$
DELIMITER ;

DELIMITER $$
create procedure customer_ticket_status(
	 IN Status varchar(50)
)
BEGIN
	Select a.customerID,a.Firstname,a.Lastname,b.Subject,b.Status 
    from customers as a INNER JOIN
    SupportTickets as b ON
    a.customerID = b.customerID where b.Status = Status;
END $$
DELIMITER ;

DELIMITER $$
create procedure customer_priority(
	 IN priority varchar(50)
)
BEGIN
	Select a.customerID,a.Firstname,a.Lastname,b.subject,b.priority,b.Status 
    from customers as a INNER JOIN
    SupportTickets as b ON
    a.customerID = b.customerID where b.priority = priority;
END $$
DELIMITER ;
drop procedure customer_priority;


DELIMITER $$
create procedure leads_status(
	 IN Status varchar(50)
)
BEGIN
	Select Firstname,Lastname,Source,Status 
    from Leads where Status = Status;
END $$
DELIMITER ;
drop procedure customer_priority;

CALL customer_sales_status('Open');
CALL customer_ticket_status('open');
CALL customer_priority('High');
CALL leads_Status('New');

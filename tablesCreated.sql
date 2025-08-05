
-- SQL Schema Creation Script for Simulated Banking Database

-- 1. Drop old schema (if it exists) and create a brand-new one
DROP DATABASE IF EXISTS bank;
CREATE DATABASE bank;
USE bank;

-- 2. customers table
CREATE TABLE customers (
  customer_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name     VARCHAR(50)    NOT NULL,
  last_name      VARCHAR(50)    NOT NULL,
  date_of_birth  DATE,
  gender         VARCHAR(10),
  email          VARCHAR(100)   UNIQUE,
  created_at     TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. accounts table
CREATE TABLE accounts (
  account_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  account_number VARCHAR(34)    NOT NULL UNIQUE,
  customer_id    INT UNSIGNED    NOT NULL,
  account_type   VARCHAR(20)     NOT NULL,  -- e.g. 'checking','savings','credit'
  balance        DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
  opened_date    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status         VARCHAR(20)     NOT NULL DEFAULT 'active',
  INDEX idx_accounts_customer (customer_id),
  CONSTRAINT fk_accounts_customer
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4. transactions table
CREATE TABLE transactions (
  transaction_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  account_id        INT UNSIGNED    NOT NULL,
  transaction_type  VARCHAR(20)     NOT NULL,  -- e.g. 'deposit','withdrawal','transfer'
  amount            DECIMAL(12,2)   NOT NULL CHECK (amount >= 0),
  transaction_date  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  description       TEXT,
  INDEX idx_trans_account (account_id),
  CONSTRAINT fk_transactions_account
    FOREIGN KEY (account_id)
    REFERENCES accounts(account_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. credit_scores table
CREATE TABLE credit_scores (
  credit_score_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  customer_id      INT UNSIGNED    NOT NULL,
  score            INT             NOT NULL CHECK (score BETWEEN 300 AND 850),
  recorded_date    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_scores_customer (customer_id),
  CONSTRAINT fk_scores_customer
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;
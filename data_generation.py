#!/usr/bin/env python3
"""
data_generation.py

Script to generate synthetic data for the simulated banking database.
Dependencies:
  - psycopg2-binary
  - Faker

Usage:
  pip install psycopg2-binary Faker
  python data_generation.py
"""

import psycopg2
from psycopg2.extras import execute_values
from faker import Faker
import random
from datetime import datetime, timedelta

# Initialize Faker
fake = Faker()

def generate_customers(n):
    customers = []
    for _ in range(n):
        first_name = fake.first_name()
        last_name = fake.last_name()
        date_of_birth = fake.date_of_birth(minimum_age=18, maximum_age=80)
        gender = random.choice(['Male', 'Female', 'Other'])
        email = fake.unique.email()
        created_at = fake.date_time_between(start_date='-2y', end_date='now')
        customers.append((first_name, last_name, date_of_birth, gender, email, created_at))
    return customers

def generate_accounts(customer_ids, n_per_customer=2):
    accounts = []
    for customer_id in customer_ids:
        for _ in range(n_per_customer):
            account_type = random.choice(['checking', 'savings', 'credit'])
            account_number = fake.bban()
            balance = round(random.uniform(0, 10000), 2)
            opened_date = fake.date_between(start_date='-2y', end_date='today')
            status = random.choice(['active', 'dormant', 'closed'])
            accounts.append((account_number, customer_id, account_type, balance, opened_date, status))
    return accounts

def generate_transactions(account_ids, total_transactions=10000):
    transactions = []
    for _ in range(total_transactions):
        account_id = random.choice(account_ids)
        transaction_type = random.choice(['deposit', 'withdrawal', 'transfer'])
        amount = round(random.uniform(1, 5000), 2)
        transaction_date = fake.date_time_between(start_date='-1y', end_date='now')
        description = fake.sentence(nb_words=6)
        transactions.append((account_id, transaction_type, amount, transaction_date, description))
    return transactions

def generate_credit_scores(customer_ids, months=12):
    credit_scores = []
    today = datetime.now().date()
    for customer_id in customer_ids:
        for i in range(months):
            score = random.randint(300, 850)
            recorded_date = today - timedelta(days=i*30)
            credit_scores.append((customer_id, score, recorded_date))
    return credit_scores

def main():
    # Update connection parameters as needed
    conn = psycopg2.connect(
        dbname="your_db",
        user="your_user",
        password="your_password",
        host="localhost",
        port="5432"
    )
    cur = conn.cursor()

    # Generate and insert customers
    customers = generate_customers(500)
    execute_values(cur,
                   "INSERT INTO customers (first_name, last_name, date_of_birth, gender, email, created_at) VALUES %s",
                   customers)
    conn.commit()

    # Retrieve customer IDs
    cur.execute("SELECT customer_id FROM customers")
    customer_ids = [row[0] for row in cur.fetchall()]

    # Generate and insert accounts
    accounts = generate_accounts(customer_ids, n_per_customer=2)
    execute_values(cur,
                   "INSERT INTO accounts (account_number, customer_id, account_type, balance, opened_date, status) VALUES %s",
                   accounts)
    conn.commit()

    # Retrieve account IDs
    cur.execute("SELECT account_id FROM accounts")
    account_ids = [row[0] for row in cur.fetchall()]

    # Generate and insert transactions
    transactions = generate_transactions(account_ids, total_transactions=10000)
    execute_values(cur,
                   "INSERT INTO transactions (account_id, transaction_type, amount, transaction_date, description) VALUES %s",
                   transactions)
    conn.commit()

    # Generate and insert credit scores
    credit_scores = generate_credit_scores(customer_ids, months=12)
    execute_values(cur,
                   "INSERT INTO credit_scores (customer_id, score, recorded_date) VALUES %s",
                   credit_scores)
    conn.commit()

    cur.close()
    conn.close()
    print("Data generation complete.")

if __name__ == "__main__":
    main()

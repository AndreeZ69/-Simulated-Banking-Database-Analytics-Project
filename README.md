# Simulated Banking Database & Analytics Project

## Project Overview
Designed and implemented a relational database that emulates customer and credit activity in a fictional banking environment. The system includes normalized data models, foreign key relationships, and queryable transactional data. Analytical SQL scripts derive actionable business insights from simulated transaction logs.

- **Role:** Data Engineer & Analyst  
- **Tools:** SQL (PostgreSQL/MySQL), Python, Faker, psycopg2, ERD design  
- **Status:** Portfolio Project (Self-directed)  
- **Duration:** ~1–2 weeks  

## Repository Structure
```
.
├── create_tables.sql         # SQL schema creation script
├── data_generation.py        # Python script to populate the database with synthetic data
├── analysis_queries.sql      # Sample SQL queries for analysis
└── README.md                 # Project overview and setup instructions
```

## Setup & Usage

1. **Create the database and tables**  
   ```bash
   psql -U <your_user> -d <your_db> -f create_tables.sql
   ```

2. **Install dependencies**  
   ```bash
   pip install psycopg2-binary Faker
   ```

3. **Generate synthetic data**  
   Update the connection parameters in `data_generation.py`, then run:  
   ```bash
   python data_generation.py
   ```

4. **Run analysis queries**  
   ```bash
   psql -U <your_user> -d <your_db> -f analysis_queries.sql
   ```

## Next Steps
- Integrate Python/Pandas for advanced analysis and visualizations.  
- Build a dashboard using Excel, Power BI, or Dash.  
- Extend the data model with additional entities (e.g., branches, loans, transactions metadata).  

---

*This project serves as a demonstration of database design, ETL automation, and analytical querying in a simulated banking context.*  

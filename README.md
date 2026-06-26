🏎️ Formula 1 Analytics Dashboard
📌 Project Overview

This project explores historical Formula 1 race data using SQL, Power BI, Power Query, and DAX to uncover insights into driver performance, constructor success, and racing trends over time.

The aim of this project was to simulate a real-world data analyst workflow by transforming raw data, writing analytical SQL queries, building an interactive Power BI dashboard, and presenting meaningful insights through data visualisation.

📂 Dataset

The dataset contains historical Formula 1 data, including:

Drivers
Constructors
Races
Circuits
Qualifying Results
Race Results

The data includes multiple decades of Formula 1 history, allowing for trend analysis and performance comparisons across seasons.

🛠️ Tools Used
PostgreSQL
pgAdmin 4
Power BI
Power Query
DAX
Git & GitHub
📊 Project Workflow
1. Data Preparation

The raw Formula 1 CSV files were imported into PostgreSQL where the data was structured into relational tables.

Tables included:

Drivers
Constructors
Results
Races
Qualifying
Circuits

Primary and foreign key relationships were maintained to create a relational database suitable for analytical querying.

2. SQL Analysis

SQL was used to answer business-style analytical questions using:

Joins
Aggregate Functions
GROUP BY
HAVING
Common Table Expressions (CTEs)
Window Functions
Subqueries

Example business questions included:

Which drivers have won the most Formula 1 races?
Which constructors have achieved the most victories?
Which drivers have scored the most championship points?
Which circuits have hosted the most races?
Which drivers gain the most positions during races?
Which seasons produced the greatest variety of race winners?
Which drivers have the highest win rate?
Which constructors have the best race win percentage?
Who were the top three drivers in each season?
3. Power Query

Power Query was used to clean and prepare the data before modelling.

Transformations included:

Creating full driver names
Correcting data types
Handling missing values
Removing errors
Preparing data for reporting
4. Data Model

A star-schema style model was created using relationships between:

Drivers
Constructors
Results
Races
Qualifying
Circuits

This enabled filtering and interactive analysis throughout the report.

5. DAX Measures

Several DAX measures were created, including:

Total Drivers
Total Constructors
Total Races
Total Points
Total Wins
Total Podiums
Win Rate
📈 Dashboard Features
Executive Dashboard

The main dashboard provides an overview of Formula 1 history, including:

KPI summary cards
Top drivers by wins
Top constructors by wins
Total races by season
Interactive driver and constructor filtering
Driver Analytics

A dedicated drill-through page provides detailed analysis for individual drivers.

Features include:

Total Wins
Total Podiums
Total Points
Win Rate
Points by Season
Wins by Season
Average Podiums by Season

Users can right-click a driver from the Executive Dashboard and drill through to a dedicated Driver Analytics page.

📚 Skills Demonstrated
SQL
Database querying
Table joins
CTEs
Window functions
Subqueries
Aggregations
Power BI
Dashboard design
Interactive filtering
Drill-through navigation
KPI cards
Data visualisation
Report layout
Power Query
Data cleaning
Data transformation
Data preparation
DAX
Measures
Aggregations
Percentage calculations
Business metrics
🚀 Key Learning Outcomes

This project strengthened my understanding of:

Relational database design
Writing analytical SQL queries
Building interactive Power BI dashboards
Data modelling
DAX calculations
Power Query transformations
Presenting analytical insights using data visualisation
📷 Dashboard Preview

<img width="977" height="552" alt="image" src="https://github.com/user-attachments/assets/692abaf1-187f-4f75-a23e-b2d5944fc27d" />
<img width="985" height="561" alt="image" src="https://github.com/user-attachments/assets/baa170a6-b24a-4b0b-8ac9-37b7bb08aa61" />



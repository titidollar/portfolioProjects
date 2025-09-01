# Data Cleaning in PostgreSql

## Description

In this project, we take raw housing data and transform it in SQL Server to make it usable for analysis. The dataset contains various inconsistencies, missing values, and formatting issues, which we clean and standardize to prepare for meaningful analysis.

## Project Objectives

- Standardize date formats for easier time-based analysis.

- Fill missing property addresses by cross-referencing duplicates.

- Split addresses into individual columns (Street, City) for better organization.

- Remove duplicate records to ensure data integrity.

- Prepare the dataset for further analytics or machine learning tasks.

## Technologies Used

PostgreSQl Server: for data storage and transformation, for writing queries, updates, and data manipulation scripts.

Features / Steps Performed

- Data Inspection: Explore raw housing data and identify issues.

- Standardize Dates: Convert inconsistent date formats to a standard DATE type.

- Fill Missing Values: Use COALESCE and self-joins to fill missing property addresses.

- Split Addresses: Break down full addresses into separate columns (Street, City).

- Remove Duplicates: Identify and delete duplicate rows based on key columns.

- Clean Data: Ensure consistency and prepare the data for analysis.

## Usage

Open PostgreSQL or any SQL client.

Run the provided SQL scripts (NashvilleHousing.sql) step by step.

After execution, the table will be cleaned, standardized, and ready for analysis.

## Project Outcome

A clean, standardized dataset of housing information.

Enhanced data quality for analytics or reporting purposes.

## Author

Thierry Djeutchou

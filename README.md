# COVID-19 Data Analysis and Vaccination Insights

This project contains SQL scripts and analysis on COVID-19 data to understand global trends, including total cases, deaths, vaccination progress, and death rates. The project primarily focuses on analyzing data from the `CovidDeaths` and `CovidVaccinations` tables.

## Project Overview

The goal of this project is to provide meaningful insights into the progression of the COVID-19 pandemic by utilizing SQL queries to extract and analyze data. Key analysis includes:

- Total cases and total deaths globally and by country.
- The percentage of the population affected by COVID-19.
- Death rates in relation to the total number of cases.
- Analysis of vaccination rates and their correlation with population data.
- Cumulative vaccination trends over time.

## Structure

- **CovidDeaths Table**: Contains data on COVID-19 cases and deaths, with columns such as `total_cases`, `new_cases`, `total_deaths`, and `population`.
- **CovidVaccinations Table**: Contains data on vaccinations, including `new_vaccinations` and `date` of vaccination records.

## Requirements

- SQL Server (or compatible database)
- Data for `CovidDeaths` and `CovidVaccinations` tables

## Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/covid-19-analysis.git
   cd covid-19-analysis

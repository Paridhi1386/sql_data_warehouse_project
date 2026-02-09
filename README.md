# sql_data_warehouse_project
Building a modern data warehouse with mysql including ETL  , Data Modeling and analytics

**Welcome to the Data Warehouse and Analytics Project repository!** 🚀

This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights.

**🏗️ Data Architecture**

The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers:



<img src="docs/Data archtmodel1.png" alt="Info Page" width="800" height="800">

1.Bronze Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.

2.Silver Layer: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.

3.Gold Layer: Houses business-ready data modeled into a star schema required for reporting and analytics.

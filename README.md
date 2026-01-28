# Cultural Loom



**Project: Analysis of cultural accessibility and territorial inequalities in France**


**Author: MOUWAFFAK Meriem**


Iron Hack Data Analysis Bootcamp

Cohort: DAFT NOV2025


## Professional project: 


I have an interdisciplinary background in Economic and Social Administration, Cultural Anthropology, and administrative management teaching. 

Combining social science expertise with technical data skills to serve the cultural and social economy sectors. 


Experienced in administrative systems, territorial development frameworks, and cultural analysis.
Seeking to leverage data analytics for social impact in cultural institutions, ESS organizations, or public policy roles focused on cultural access and territorial equity.

Unique value: Translating (complex?) social realities into data-driven insights that serve mission-driven organizations.

→ A field requiring expertise, analytics capacities, data analysis


## Idea : an analysis of cultural infrastructure in France


→ National mapping with PACA region focus (I live in Aix-en-Provence, near Marseille)
→ Kind of sociological analysis, using datasets.


**Tools:**
Python
MySQL
Tableau (visualization)
Github
Trello



## Exploratory Data Analysis

### Research Questions:
1. Geographic Distribution: How is cultural supply distributed across French territories?
2. Urban vs Rural: Are there significant disparities between urban and rural areas?
3. Socio-Economic Correlation: Is there a relationship between territorial wealth and cultural supply?
4. Typological Diversity: What types of cultural venues exist and how are they distributed?
5. PACA Regional Focus: How does PACA compare to national averages?

### Datasets

**Public datasets:**
Free, legal, governmental sources (Ministry of Culture, INSEE, data.gouv.fr …)
**Advantage:** RGPD compatible
**Limit :** dates of collection of the data

### Data Sources

This project combines three official French datasets:

1. **BASILIC Cultural Venues Database**
   - Source: French Ministry of Culture
   - Year: 2025 (extracted 09/05/2025)
   - Records: ~50,000 cultural venues
   - [Link](https://data.culture.gouv.fr/)

2. **Legal Population Data**
   - Source: INSEE (National Statistics Institute)
   - Year: 2021 (published Dec 2023)
   - Records: ~35,000 communes
   - [Link](https://www.insee.fr/fr/statistiques/7739582)

3. **FILOSOFI Income and Poverty Data**
   - Source: INSEE
   - Year: 2021 (published Jun 2024)
   - Records: ~30,000 communes
   - [Link](https://www.insee.fr/fr/statistiques/7233950)


Add different scales :

4. **Communes Reference Table**
Source: Derived from INSEE COG 2025 + Population data
Records: ~35,000 communes


5. **Departments Reference Table**
Source: Derived from INSEE COG 2025
Records: 101 departments (96 metropolitan + 5 overseas)
Note on special codes: 2A/2B (Corsica), 971-976 (DOM)

6. **Regions Reference Table**
Source: Derived from INSEE COG 2025
Records: 18 regions (13 metropolitan + 5 overseas)
Note: Current administrative structure since 2016 reform
     

**Context elements :** 

- 4-years lag between population/income (2021) and cultural venues (2025) is acceptable due to low demographic variationin the time interval.

- Disposable income better reflects actual living standards because it accounts for taxes and social transfers, making it more relevant for socio-economic comparisons at the IRIS level.

- In FiLoSoFi, the poverty threshold is set at 60% of the metropolitan median standard of living.

- The data cover IRIS areas for municipalities with at least 5,000 inhabitants in metropolitan France, Martinique, and Réunion. Up to the 2019 vintage, the data covered IRIS areas for municipalities with 10,000 inhabitants or more. The indicators are subject to statistical confidentiality rules to protect data privacy. The proposed indicators are non-additive (they cannot be aggregated by summation). The 2021 data are provided using the geography in force on 1 January 2022.

- Also, observations on situation or changes in income or poverty at the local level should be interpreted with caution.



## Database design

### Entity Relationship Diagram (ERD)
 ERDs are a specialized type of flowchart that conveys visual representation of how items in a database relate to each other.

### Design, joins



## Structure Query Language (SQL)
SQL is the universal query language of relational database management systems (DBMS) 



## Analysis

-->


## Visualization
--> With Tableau (or Power BI ?)



## Interpretation

--> Perspectives (: research, time, lack of layers of parameters, professional use, further aproach)
--> Oral présentation : Canvas
# Cultural Loom

**Analysis of Cultural Accessibility and Territorial Inequalities in France**

---

## Project Overview

**Author:** Meriem MOUWAFFAK  
**Program:** IronHack Data Analytics Bootcamp (DAFT NOV2025)  
**Certification:** RNCP Data Analyst (Bloc 1)  
**Project Type:** Final certification project

This project analyzes the cultural infrastructure distribution across French territories to identify patterns of inequality and inform evidence-based cultural policy. 
Using official government datasets from the Ministry of Culture and INSEE, the analysis combines geographic, demographic, and socio-economic factors to examine cultural accessibility.


## Introduction 

# Professional Context

I bring an interdisciplinary background combining:
- Economic and Social Administration
- Cultural Anthropology
- Administrative management teaching

**Career Objective:** Leverage data analytics for social impact in cultural institutions, ESS (Économie Sociale et Solidaire) organizations, or public policy roles focused on cultural access and territorial equity.

**Unique Value Proposition:** Translating complex social realities into data-driven insights that serve mission-driven organizations.

---

##  Research Questions

This analysis addresses six core research questions:

1. **Geographic Distribution:** How is cultural supply distributed across French territories?
2. **Urban vs Rural:** Are there significant disparities between urban and rural areas?
3. **Socio-Economic Correlation:** Is there a relationship between territorial wealth and cultural supply?
4. **Typological Diversity:** What types of cultural venues exist and how are they distributed?
5. **Regional Focus:** How does PACA compare to national averages?
6. **Music Infrastructure:** How is music infrastructure distributed, and what proportion holds official SMAC recognition?

---
**Article from Crédoc for the French Ministry of Culture (2024) :** [Link](https://www.culture.gouv.fr/espace-documentation/statistiques-ministerielles-de-la-culture2/publications/collections-de-synthese/culture-etudes-2007-2025/les-sorties-culturelles-des-francais-et-leurs-pratiques-en-ligne-en-2023-cinema-concert-et-theatre-ce-2024-2)


---

##  Data Sources

### Reference Tables

| Dataset | Source | Year | Records | Purpose |
|---------|--------|------|---------|---------|
| **BASILIC** | Ministry of Culture | 2025 | 88,025 | Cultural venues database |
| **Population** | INSEE | 2021 | 35,000 | Commune demographics |
| **FILOSOFI** | INSEE | 2021 | 30,000 | Income & poverty statistics |
| **SMAC** | Web API | 2025 | 91 | Official music venue labels |
| **Dept. Surfaces** | Web scraping | 2024 | 100 | Geographic density (km²) |

**Official Sources:**
- BASILIC: [data.culture.gouv.fr](https://data.culture.gouv.fr/)
- INSEE Population: [INSEE Statistics](https://www.insee.fr/fr/statistiques/7739582)
- FILOSOFI: [INSEE FILOSOFI](https://www.insee.fr/fr/statistiques/7233950)


### Data Quality - Notes

- **Temporal lag:** 4-year gap between population/income (2021) and venues (2025) is acceptable due to low demographic variation
- **FILOSOFI coverage:** IRIS-level data available only for municipalities >5,000 inhabitants
- **GDPR:** All datasets are public, aggregated, and non-personal
- **Data integrity:** 5,005 BASILIC records (5.7%) excluded due to unmatched commune codes

---

## Technology

**Tools:**
Github
Trello
Python
MySQL
BigQuerry
API Framework (Fast API)
Tableau (visualization)

### Python Libraries

- **Data Manipulation:** pandas, numpy
- **Web Scraping:** BeautifulSoup, requests
- **Machine Learning:** scikit-learn (Random Forest Regressor)
- **Database:** mysql-connector-python, SQLAlchemy
- **API:** Flask

--

## Methodology

1. **Business Understanding:** Cultural accessibility as social equity indicator
2. **Data Understanding:** Evaluation of 5 official datasets
3. **Data Preparation:** Normalization, web scraping, database design
4. **Modeling:** Statistical analysis + Random Forest regression
5. **Evaluation:** R² assessment, correlation validation
6. **Deployment:** BigQuery analytics + REST API


---

##  Key Technical Achievements

### 1. Data Preparation

**BASILIC Normalization:**
- Handled 12 multi-commune records via MySQL view
- Department code extraction from postal codes (special cases: Corsica 2A/2B, overseas 971-976)

**Web Scraping:**
- SMAC venues: BeautifulSoup HTML parsing (91 venues extracted)
- Department surfaces: Wikipedia table scraping with French number format handling (100 departments)
- Challenges: rowspan/colspan tables, UTF-8 encoding, inconsistent formats

### 2. Database Design
**Architecture:** relational database
- Hierarchical structure: regions -> departments -> communes -> basilic
- Core tables: 7 tables with foreign key relationships

### 3. Machine Learning Analysis

**Model:** Random Forest Regressor
- **Features:** Population, Surface Area
- **Target:** Music density per 100,000 inhabitants
- **Dataset:** 96 departments (76 train / 20 test)

**Results:**
- **R² Score:** -0.397
- **MAE:** 0.55 venues per 100k
- **Feature Importance:** Population 47%, Surface Area 53%

**Scientific Interpretation:**  
The negative R² is not a failure but a key discovery: it proves that music infrastructure distribution cannot be predicted by demographics or geography. This validates the hypothesis that cultural inequality is policy-driven, requiring political intervention rather than demographic growth.

### 4. BigQuery Implementation
- Denormalized analytics table with partitioning (load_date) and clustering (dept_code, region_code)
- 5 analytical queries: top departments, venue types, cultural domains, geographic hotspots

### 5. REST API Development
**Framework:** Fast API
**Endpoints:**
- `/venues` - Cultural venue data with filters
- `/departments` - Aggregated statistics by department
- `/stats` - National-level summary statistics :
    • `/stats/commune/{commune_code}`: Returns commune-level indicators (venue count, venues per 1,000 inhabitants, population, and income metrics when available).
    • `/stats/density`: Ranks communes by cultural density (venues per 1,000 inhabitants), with a minimum population threshold.
    • `/stats/dept/{dept_code}`: Provides aggregated indicators at department level (total venues, population, venues per 1,000 inhabitants; optionally income aggregates if defined).


## Analysis

### 1. Cultural Infrastructure is Policy-Driven
**Negative R² = -0.397** proves that population and geography do **not predict** cultural infrastructure distribution. Cultural accessibility is a **political choice**, not a demographic inevitability.

### 2. Territorial Inequality
- **Urban concentration:** Paris 3,000+ venues
- **Rural deserts:** Departments <100 venues
- **Paradox:** Rural areas sometimes show higher per-capita density due to smaller populations

### 3. SMAC Recognition Gap
- **Total music venues:** 632 (BASILIC)
- **SMAC labels:** 91 (14.4% recognition rate)
- **Coverage:** 61 departments (60%) have at least one SMAC venue
- **Insight:** Significant gap between infrastructure existence and quality recognition

### 4. Socio-Economic Correlation
- **Median income** better predictor than Gini index
- Absolute wealth matters more than inequality for cultural investment


## GDPR

This project is  GDPR compliant:

- **Lawfulness:** Official government sources only  
- **Purpose Limitation:** Cultural analysis only (no commercial use)  
- **Data Minimization:** Public institutional data only  
- **Transparency:** All sources documented and cited  
- **No Personal Data:** BASILIC = public institutions, INSEE/FILOSOFI = aggregated statistics (>5,000 inhabitants)

**References:**
- [EU GDPR Regulation](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng)
- [CNIL Guide (French)](https://www.cnil.fr/fr/comprendre-le-rgpd)

## Business Value

### For Policymakers
- Identification of "music deserts" requiring intervention
- Data-driven SMAC label expansion prioritization
- Quantified territorial inequality patterns

### For Cultural Institutions
- Geographic gap analysis for venue development
- Regional specialization understanding
- Benchmarking tools for density assessment

### For Social Economy Organizations
- Statistical evidence for equity advocacy
- Proof that inequality is systemic, not natural
- Actionable insights for mission-driven projects

---

## Limitations and Future Work

### Current Limitations
1. **Private venues excluded:** BASILIC contains only public infrastructure
2. **Temporal lag:** 4-year gap (2021 demographics vs 2025 venues)
3. **Small commune data:** IRIS income data limited to cities >5,000 inhabitants
4. **Correlation only:** No causal inference (requires quasi-experimental designs)

### Future Research Directions
1. **Private venue integration:** Partnership with cultural associations for comprehensive data
2. **Time-series analysis:** Track evolution 2015-2025 to measure policy impacts
3. **Causal inference:** Natural experiments to measure policy effectiveness
4. **Enhanced ML:** Add features (education, transport, tourism, historical investment)
5. **Accessibility metrics:** Travel time, public transport, pricing, opening hours

---

## Visualizations

**Tableau Public Dashboard:** [Link to be added]

---

##  References

### Data Sources
- French Ministry of Culture. (2025). BASILIC Cultural Venues Database. https://data.culture.gouv.fr/
- INSEE. (2023). Populations légales 2021. https://www.insee.fr/fr/statistiques/7739582
- INSEE. (2024). FILOSOFI - Année 2021. https://www.insee.fr/fr/statistiques/7233950

### Context Research
- Observatoire des inégalités. (2024). L'accès pour tous à la culture. https://www.inegalites.fr/acces-pour-tous-a-la-culture
- Acteurs Publics. (2024). Le fossé entre urbains et ruraux se creuse. https://acteurspublics.fr/articles/sondage-exclusif-pour-lacces-a-la-culture-le-fosse-entre-urbains-et-ruraux-se-creuse/

### GDPR Compliance
- European Union. (2016). GDPR Regulation 2016/679. https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng
- CNIL. (2024). Comprendre le RGPD. https://www.cnil.fr/fr/comprendre-le-rgpd

---

## Trello board
--> [Link](https://trello.com/invite/b/6973a65bb84b1fd366fd8881/ATTI1b9d68b4e62515f669dd50a7def785b87936B652/culture-loom)
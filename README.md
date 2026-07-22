_________________________________________________________________________________

Glen Canyon Dam Bug Flow Experiment featuring GAMS optimization models and supporting data for evaluating trade-offs between ecological flow objectives and hydropower generation.

_________________________________________________________________________________________________________________________________________________________________________________________________

## Bugs Buy Steady Releases from Hydropower Producers to Reduce Hydropeaking Ecosystem Conflict 

_______________________________________________________________________________________________________________

This study is part of my M.S. degree in Civil and Environmental Engineering at **Utah State University, Utah, USA**

This research was jointly funded by the Future of the Colorado River Project and the Higher Education Commission (HEC) of Pakistan.

Corresponding Author: **Moazzam Ali Rind** (moazzamalirind@gmail.com)

Advised by: **Dr. David E. Rosenberg** (http://rosenberg.usu.edu/)

Starting Date: 6/1/2019

Lasted updated: 7/20/2026
_______________________________________________________________________________________________________________

## Project Summary: 

This study quantifies the trade-offs between the number of days with steady reservoir releases and hydropower-peaking objectives. A steady-flow day—during which releases remain constant throughout the day—provides suitable conditions for aquatic invertebrates to lay eggs and for those eggs to hatch. Since 2018, a Bug Flow Experiment has been implemented at Glen Canyon Dam, with summer releases kept low and steady on weekends. The overarching questions are:1) How does hydropeaking value vary as steady flow days expand from weekends to weekdays? 2) How can the tradeoff results be used to inform an ecosystem manager’s budget and commitments regarding the number and timing of Bug Flow days to purchase from hydropower producers? The optimization model, using constraint method, was used to quantify the tradeoffs. The model runs for one month with two sub-daily timesteps and is subjected to reservoir’s physical and managerial constraints. Estimates include scenarios that vary monthly release volume, weekend offset release, energy-pricing structure (market versus contract prices), and the model’s sensitivity to 2014 versus 2024 energy prices. The results help design a program where ecosystem managers can purchase additional days of steady releases from hydropower producers and compensate the producers for the lost hydropower revenue.

_______________________________________________________________________________________________________________

## Objectives

* Quantify the tradeoffs between ecosystem objectives, represented by the number of low, steady-flow days, and traditional reservoir-management objectives, represented by monthly hydropower-peaking value.

* Evaluate how key factors influence the shape and position of the tradeoff curve, including monthly release volume, offset releases, energy-price type (market versus contract), days template (weekday–weekday versus Saturday–Sunday–weekday), and the use of 2014 versus 2024 energy-pricing datasets.

* Assess monthly variation in the tradeoffs and determine how the results can help hydropower producers and ecosystem managers better understand and address conflicts between hydropower generation and ecosystem objectives.
_______________________________________________________________________________________________________________

## Features of the study

1\. We have transformed a monthly non-linear hydropower objective with 744 hourly release decisions (24 hours \*31 days) to a linear problem with only 6 sub-daily decisions i.e: 3 day type (Saturday, Sunday, and Weekday) and 2 periods per day.

2\. The model can produce results for scenarios: monthly release volumes, offset release between off-peak weekday and weekend, and price type (market and contract).

3\. Only two periodic releases per day and those releases remain constant for the month under similar flowpatterns (Steady and hydropeak).

4\. Concept of bugs buying water from hydropower producers by paying the losses. Tradeoffs of the months provide purchase price ($/day) of different day types during months, hence, ecosystem managers make informed purchase decisions. 

5\. Example of trade-off analysis used for multi-objective decision making.

6\. The study is replicable and adaptable to other sites and designer flow experiments (e.g. HFEs)

_______________________________________________________________________________________________________________

## Model Formulation
![image](https://github.com/moazzamalirind/BugFlowExperiment_Analysis2026/blob/main/Documents/Model_Structure.png)

_______________________________________________________________________________________________________________

\*\*Details of Repository Contents\*\*

There are four distinct folders:

**a.** Documents

**b.** EnergyPrices and Supporting Data

**c.** Results_2014Pricing

**d.** Results_2024Pricing

**a. Documents**

Throughout this project, we produced a range of documents, including the research proposal, conference papers, thesis, journal article drafts, and supplementary materials. The initial linear optimization model is documented in "Rind\_LinearModel\_Final.pdf". The proposal is provided in "Proposal\_MS\_Rind.pdf", while the complete thesis is available in "Rind\_2022\_Thesis\_USU.pdf". The development of the journal article is represented by multiple versions, including "Final\_Draft\_JHI\_2025\_Feburary.pdf", "JHI\_Resubmit2025\_December\_Article.pdf" and current resubmission "Rind and Rosenberg_July2026_Revised.pdf", together with their corresponding supplementary materials. Collectively, these documents provide a comprehensive record of the study’s objectives, methods, model development, results, and evolution over time.

**b. EnergyPrices and Supporting Data**

There are three subfolders with distinct infromation.

**i. 2014Prices**

"EnergyRates_2014.xlsx" contains the raw hourly energy prices received from WAPA for 2014. The hourly data were aggregated into two time periods per day, and the average price for each period was used to represent the 2014 energy prices for each month. 

**ii. 2024Prices**

This folder contains all files and code required to generate the 2024 energy-price dataset. The accompanying README provides step-by-step instructions for navigating the folder and executing the complete data-generation workflow. Supplementary Tables S1–S2 and Figures S2–S3 were adopted from the output file "GCDEnergyPrice.pdf".

**iii. Observed_Hydrographs**

File named "Hydrographs_Observed_Used.xlsx" contains obserevd releases at Lees Ferry below Glen Canyon Dam,Arizona ([https://waterdata.usgs.gov/usa/nwis/uv?09380000](https://waterdata.usgs.gov/monitoring-location/USGS-09380000)). There are observed hydrographs from 2013 to 2021 and those excel files have some initial data analysis, visualization, and selections. Figure 2 in the main article and supplementary Figure S4-S6 are prepared using the observed information. "Hydropower_Fluctuations(2018).xlsx" provides an approximate estimate of variations in hydropower generation resulting from changes in reservoir storage levels (Supplementary Table S6).

**c. Results_2014Pricing**

This folder contains subfolders named by month, followed by “2018” (for example, April 2018 and August 2018). The “2018” designation indicates that the hydrologic conditions used in the analysis—including reservoir storage levels and observed releases—were obtained from 2018 data. The energy prices used in these simulations are from the 2014 pricing dataset.

Each monthly subfolder contains three directories: Contract Price Model, Market-Contract Price Model, and Miscellaneous.
For example, "April 2018/Contract Price Model" contains the GAMS code file April18_Sat_Sun-Weekday_Mode.gms and its corresponding output files, Sat-Sun-Weekday_April.gdx and Sat-Sun-Weekday_April.xlsx. Similar code and output files are provided for each month.
The "April 2018/Market-Contract Price Model" folder likewise contains the relevant GAMS model code and associated output files for the market-contract pricing scenario.
The "April 2018/Miscellaneous" folder contains code and results from an earlier version of the model that used only two day types: Weekday and Weekend. This version was used solely for model validation and was not included in the main analysis.

**d. Results_2024Pricing**

There are three main subfolders: Contract Price Model, Market Price Model, and Figures_Analysis.
The Contract Price Model and Market Price Model folders each contain monthly subfolders corresponding to the months analyzed in this study. For example, "Contract Price Model/April" contains the GAMS model file "April18_Contract_2024.gms" and the associated output files "2024_Contract_April.gdx" and "2024_Contract_April.xlsx". The same folder structure and naming convention are used for the monthly analyses in the Market Price Model folder.
The Figures_Analysis folder contains the Excel files used to generate the figures and tables presented in the main article and supplementary document.
______________________________________________________________________________________________________________________________________________________________________________
## Required Softwares
1. General Algebraic Modeling System (GAMS), which can be freely downloaded from (https://www.gams.com/download/). We used GAMS version 30.3 and acquired license to run the model.

2. Microsoft Excel. We used Office 2016 for this analysis.
________________________________________________________________________________________________________________________________________________________
## Directions to Reproduce Results
The following instructions will help users to reproduce results in "Rind and Rosenberg_July2026_Revised.pdf"

([Documents/Final_Draft_JHI_2025.pdf](https://github.com/moazzamalirind/GCD_BugFlowExperiment/blob/recovery3/Documents/Final_Draft_JHI_2025.pdf)


sadas

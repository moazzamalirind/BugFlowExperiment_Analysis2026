# BugFlowExperiment\_Analysis2026

Glen Canyon Dam Bug Flow Experiment featuring GAMS optimization models and supporting data for evaluating trade-offs between ecological flow objectives and hydropower generation.



\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

\## Bugs Buy Steady Releases from Hydropower Producers to Reduce Hydropeaking Ecosystem Conflict 

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_



This study is part of my M.S. degree in Civil and Environmental Engineering at \*\*Utah State University, Utah, USA\*\*



This research was jointly funded by the Future of the Colorado River Project and the Higher Education Commission (HEC) of Pakistan.



Corresponding Author: \*\*Moazzam Ali Rind\*\* (moazzamalirind@gmail.com)



Advised by: \*\*Dr. David E. Rosenberg\*\* (http://rosenberg.usu.edu/)



Starting Date: 6/1/2019



Lasted updated: 7/19/2026

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

\## Project Summary: 



This study quantifies the trade-offs between the number of days with steady reservoir releases and hydropower-peaking objectives. A steady-flow day—during which releases remain constant throughout the day—provides suitable conditions for aquatic invertebrates to lay eggs and for those eggs to hatch. Since 2018, a Bug Flow Experiment has been implemented at Glen Canyon Dam, with summer releases kept low and steady on weekends. The overarching questions are:1) How does hydropeaking value vary as steady flow days expand from weekends to weekdays? 2) How can the tradeoff results be used to inform an ecosystem manager’s budget and commitments regarding the number and timing of Bug Flow days to purchase from hydropower producers? The optimization model, using constraint method, was used to quantify the tradeoffs. The model runs for one month with two sub-daily timesteps and is subjected to reservoir’s physical and managerial constraints. Estimates include scenarios that vary monthly release volume, weekend offset release, energy-pricing structure (market versus contract prices), and the model’s sensitivity to 2014 versus 2024 energy prices. The results help design a program where ecosystem managers can purchase additional days of steady releases from hydropower producers and compensate the producers for the lost hydropower revenue.

___________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

\## Objectives

* Quantify the tradeoffs between ecosystem objectives, represented by the number of low, steady-flow days, and traditional reservoir-management objectives, represented by monthly hydropower-peaking value.



* Evaluate how key factors influence the shape and position of the tradeoff curve, including monthly release volume, offset releases, energy-price type (market versus contract), days template (weekday–weekday versus Saturday–Sunday–weekday), and the use of 2014 versus 2024 energy-pricing datasets.



* Assess monthly variation in the tradeoffs and determine how the results can help hydropower producers and ecosystem managers better understand and address conflicts between hydropower generation and ecosystem objectives.

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

\## Features of the study

1\. We have transformed a monthly non-linear hydropower objective with 744 hourly release decisions (24 hours \*31 days) to a linear problem with only 6 sub-daily decisions i.e: 3 day type (Saturday, Sunday, and Weekday) and 2 periods per day.



2\. The model can produce results for scenarios: monthly release volumes, offset release between off-peak weekday and weekend, and price type (market and contract).



3\. Only two periodic releases per day and those releases remain constant for the month under similar flowpatterns (Steady and hydropeak).



4\. Concept of bugs buying water from hydropower producers by paying the losses. Tradeoffs of the months provide purchase price ($/day) of different day types during months, hence, ecosystem managers make informed purchase decisions. 



5\. Example of trade-off analysis used for multi-objective decision making.



6\. The study is replicable and adaptable to other sites and designer flow experiments (e.g. HFEs)

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

\## Model Formulation

!\[image](https://github.com/moazzamalirind/BugFlowExperiment\_Analysis2026/Documents/Model_Structure.png)



\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

\*\*Details of Repository Contents\*\*



There are four distinct folders:

\*\*a.\*\* Documents

\*\*b.\*\* EnergyPrices

\*\*c.\*\* Results\_2014Pricing

\*\*d.\*\* Results\_2024Pricing



\*\*a.\*\* Documents



Throughout this project, we produced a range of documents, including the research proposal, conference papers, thesis, journal article drafts, and supplementary materials. The initial linear optimization model is documented in "Rind\_LinearModel\_Final.pdf". The proposal is provided in "Proposal\_MS\_Rind.pdf", while the complete thesis is available in "Rind\_2022\_Thesis\_USU.pdf". The development of the journal article is represented by multiple versions, including "Final\_Draft\_JHI\_2025\_Feburary.pdf" and the updated resubmission, "JHI\_Resubmit2025\_December\_Article.pdf", together with their corresponding supplementary materials. Collectively, these documents provide a comprehensive record of the study’s objectives, methods, model development, results, and evolution over time.



\*\*b.\*\* EnergyPrices










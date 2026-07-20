
$ontext
Title Optimization model for Glen Canyon Dam releases to favor Bugs population (June 2018)


###################################
Created By: Moazzam Ali Rind
Email: moazzamalirind@gmail.com

Created : 4/24/2019
Last updated: 7/24/2019

Description: Daily High flow & low flow release concept with an aim to minimize the difference between two daily flows.
             Whereas, the overall objective of the model is to get the daily flow release outer bound which is not only favourable for bugs
             but also accounts the hydropower objective to its best. Conversely, the total monthly release amount is maintained same as per colorado river compact .

######################################

$offtext

****Model code:

Set

          d             days in June
          p             time period during a day /pLow "Low flow period",pHigh "High flow period"/


*======================================
*Parameters
*======================================

PARAMETERS

Use_Sim(d,p)                  Binary parameter which will specify simulation energy prices for weekend (1=yes 0=no)
Price_vals(d,p)               Defined price value for simulation with respect to day and period of day ($ per MWh)

FStore                       Storing objective function values over different scenarios of f
XStore(d)                     Store Energy generated per day  (MWh per day)
RStore(d,p)                  Store Release values at extreme values over different scenarios with all equations intact(cfs)
initstorage                  Initial reservoir storage on 1st June 2018 (acre-ft)
maxstorage                   Reservoir capacity (acre-ft)
minstorage                   Minimum reservoir storage to maintain hydropower level(acre-ft)
Inflow(d)                    Inflow to reservoir (cfs)
observed_release(d,p)        observed release at April 2018 averaged over two timesteps (cfs)
maxRel                       Maximum release in a day d at any timeperiod p(cfs)
minRel                       Minimum release in a day d at any timeperiod p(cfs)
evap                         evaporation (ac-ft per day) Considered constant throughout the month
EnergyRate(p)                Energy revenue ($ per MWH) /pLow 24.56, pHigh 62.21/
Duration(p)                  Duration of period (hours)


;
Duration("pLow")= 8;
* low period weightage in a day(08 Hours or 11 by 24 i.e:0.33 of day)

Duration("pHigh")= 16;
*  High period weightage in a day( 13 Hours or 13 by 24 i.e:0.67 of day)

*===================================================
* Read data from Excel
*===================================================
$CALL GDXXRW.EXE input=June2018.xls output= Valid_June2018_0to8.gdx   par=observed_release rng=observed_new!A1:C32  set=d rng=day!A1 Rdim=1  par=Inflow rng=inflow!A1 Rdim=1  par=initstorage rng=initstorage!A1 Rdim=0  par=maxstorage rng=maxstorage!A1 Rdim=0   par=minstorage rng=minstorage!A1 Rdim=0  par=maxRel rng=maxRel!A1 Rdim=0 par=minRel rng=minRel!A1 Rdim=0  par=evap rng=evap!A1 Rdim=0

*Write the input Data into a GDX file
$GDXIN Valid_June2018_0to8.gdx

* parameters and input data from the GDX file into the model
$LOAD d
$LOAD inflow
$LOAD initstorage
$LOAD maxstorage
$LOAD minstorage
$LOAD maxRel
$LOAD minRel
$LOAD evap
$LOAD observed_release

*Close the GDX file
$GDXIN

Display d,inflow, initstorage, maxstorage, minstorage, maxRel, minRel, evap,p,Duration, observed_release;
*Levels,Scen,
*===============================================
SCALAR
factor_foracftperHr           conversion factor from cfs to ac-ft per hour (0.0014*60)/0.083/

Numdays                       Number of days in month/30/

Num_of_timesteps              Total Number of timesteps used /60/


VARIABLES

ObjectiveVal                     Objective functions calculation


Positive Variables
storage(d)                    reservoir storage on any day d (acre-ft)
release(d,p)                  reservoir release on any day d in any period p (cfs)
Energyrate_vari(d,p)          Rate of hydropower with respect to day and period of day ($ per MWH)
Energy_Gen(d,p)               Hydropower Generated at a each time step (MWH)
ReleaseVol(d,p)               volume of water released per time step(acre-ft)
Vol_monthlyrelease            Total volume of water released in the month
;


*Initialize
Use_Sim(d,p) = 0;
Price_vals(d,p)= 0;

*Set weekend days to 1
Use_Sim(d,p) $((ord(d)>= 2  and ord(d)<= 3)
                    OR(ord(d)>= 9 and ord(d)<= 10)
                   OR (ord(d)>=16 and ord(d)<=17)
                  OR (ord(d)>=23 and ord(d)<=24)
                  OR (ord(d)>=30 and ord(d)<=30)) = 1;
*Set weekend rate to low weekday price
Price_vals(d,p)$Use_Sim(d,p) = 24.56 ;



EQUATIONS
*AND CONSTRAINTS
EQ1__ResMassBal(d)           Reservoir mass balance (acre-ft)
EQ2__reqpowerstorage(d)      The minimum storage equivalent to reservoir level required for hydropower generation (acre-ft)
EQ3__maxstor(d)              Reservoir storage max (acre-ft)
EQ4__MaxR(d,p)               Max Release (cfs)
EQ5__MinR(d,p)               Min Release  (cfs)
EQ6_Energyrate(d,p)          Defination of Energy rate as per period of day and day of week ($ per MWH)
EQ7_FlowVolume(d,p)          volume of water released per time step (acre-ft)
EQ8__Monthtlyrel             Constraining Total monthly volume of water released in "June" as per WAPA information(acre-ft)
EQ12_EnergyGen(d,p)          Amount of energy generated in each time step (MWH)
EQ12a_EnergyGen_Max(d,p)     Maximum Energy Generation Limit of the Glen Caynon Dam(MW)for each Period
EQ13_EnergyRevenue           Total monthly Hydropower Revenue generated ($)
EQ15_ReleaseSim(d,p)         Setting release values as predefined for simulation(cfs)
EQ16_weekendprice(d,p)       Setting energy price for weekend to predefined value ($ per MWh)
;



*------------------------------------------------------------------------------*


EQ1__ResMassBal(d)..         storage(d) =e= initstorage$(ord(d)eq 1)+ storage(d-1)$(ord(d)gt 1)+ (inflow(d)*factor_foracftperHr*24)- sum(p,ReleaseVol(d,p))-evap;
EQ2__reqpowerstorage(d)..    storage(d) =g= minstorage;
EQ3__maxstor(d)..            storage(d)=l= maxstorage;
EQ4__MaxR(d,p)..             release(d,p)=l= maxRel ;
EQ5__MinR(d,p)..             release(d,p)=g= minRel;

EQ6_Energyrate(d,p)..        Energyrate_vari(d,p)=e= EnergyRate(p);
*Equation 6 is just making the energy rate same for all days. However in future we can change it as per different rates for different days.

EQ7_FlowVolume(d,p)..        ReleaseVol(d,p) =e= release(d,p)*factor_foracftperHr*Duration(p);
EQ8__Monthtlyrel..           sum(d,sum(p,ReleaseVol(d,p)))=e=Vol_monthlyrelease;
*EQ8_  constraining the overall monthly released volume..

*EQ12_EnergyGen(d,p)..                         Energy_Gen(d,p)=e= ((release(d,p)*Elev_Head *Efficiency)/factor_powerMW)*Duration(p);
*formula Source http://rivers.bee.oregonstate.edu/book/export/html/6

EQ12_EnergyGen(d,p)..                         Energy_Gen(d,p)=e= release(d,p)*Duration(p)*0.03715;
* Energy generation formula used in wapa Execl model..

EQ12a_EnergyGen_Max(d,p)..                    Energy_Gen(d,p)=l= 1320*Duration(p);
*Maximum Energy Generation capacity of GCD (MWH).. Source https://www.usbr.gov/uc/rm/crsp/gc/



EQ13_EnergyRevenue..                    ObjectiveVal=e= sum((d,p),Energy_Gen(d,p)*Energyrate_vari(d,p));
**EQ13_HyrdroPower objective


***************************************************
******Simulation part
***************************************************
*------------------------------------------------------------------------------*
EQ15_ReleaseSim(d,p)..              release(d,p)=e=observed_release(d,p);

EQ16_weekendprice(d,p)$Use_Sim(d,p)..           Energyrate_vari(d,p)=e= Price_vals(d,p);



MODEL validation   using  NLP /ALL/;

*release.L(d,p) = 1000;
*Avgrelease.L = 1000;
option Threads=6;
option optcr=0.001;
option NLP= BARON;

*  Solve the model
SOLVE validation USING NLP MAXIMIGING  ObjectiveVal;

* save the results for later use
   FStore= ObjectiveVal.L;
   RStore(d,p)= release.L(d,p);
   XStore(d) = sum(p,Energy_Gen.L(d,p));

* Dump all input data and results to a GAMS gdx file
Execute_Unload "Valid_June2018_0to8.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls Valid_June2018_0to8.gdx"




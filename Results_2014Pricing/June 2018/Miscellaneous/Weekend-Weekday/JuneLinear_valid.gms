
$ontext
Title Optimization model for Glen Canyon Dam releases to favor Bugs population. (June 2018)

###################################
Created By: Moazzam Ali Rind
Email: moazzamalirind@gmail.com

Created : 6/15/2020
Last updated: 10/13/2020

Description: This model was developed to qaunitfy the trade-off between number of steady low flow days and hydropower revenue objectives.
            The model has 2 periods per day (i.e. pHigh and plow) and runs for a month. we have used linear programming to solve the problem.
            All the structural and operational constraints applied here are uptodate.

######################################

$offtext

****Model code:

Set

          d                             days in June
          p                             time period during a day /pLow "Low flow period",pHigh "High flow period"/
          modpar                        Saving model parameter for each of the solutions for each of the scenario/ ModStat "Model Statistics", SolStat "Solve Statistics"/
;


*======================================
*Parameters
*======================================

PARAMETERS

FStore                            Storing objective function values

XStore_steady                  Store Energy Generated during steady flow days (MWH)
XStore_unsteady                 Store Energy Generated during unsteady flow days  (MWH)

RStore_steady(p)                 Store Release values during steady flow days for each period (cfs)
RStore_unsteady(p)               Store Release values during unsteady flow days for each period(cfs)

Sstore                            Store Storage Values (ac-ft)

ModelResults(modpar)               Model Results
*release(p)                         observed reservoir release during unsteady day at period p (cfs) /pLow 11363.14, pHigh 15738.38/
release(p)                         observed reservoir release during unsteady day at period p (cfs) /pLow 10840.07, pHigh 15738.38/
*Steady_Release                      Steady release value of the hydrograph /10433.23/
Steady_Release                      Steady release value of the hydrograph /10840.07/
**The release value used here is the average of observed bug flow releases during june 2018

initstorage                           Initial reservoir storage 1st June 2018 (acre-ft)
maxstorage                            Reservoir capacity (acre-ft)
minstorage                            Minimum reservoir storage to maintain hydropower level(acre-ft)
Inflow(d)                             Inflow to reservoir (cfs)
maxRel                                Maximum release in a day d at any timeperiod p(cfs)
minRel                                Minimum release in a day d at any timeperiod p(cfs)
evap                                  evaporation (ac-ft per day Considered constant throughout the month
*EnergyRate(p)                         Energy revenue on weekdays ($ per MWH) /pLow 24.5656, pHigh 63.2323/
EnergyRate(p)                         Energy revenue on weekdays ($ per MWH) /pLow 37.7002, pHigh 63.5172/
weekendRate(p)                        Energy revenue on weekends ($ per MWH) /pLow 37.7002, pHigh 37.7002/

Duration(p)                           Duration of period (hours)

Steady_Days                           The number of steady low flow days (observed in June of 2018)


;




Duration("pLow")= 8;
* low period weightage in a day(08 Hours or 8 by 24 i.e:0.33 of day)

Duration("pHigh")= 16;
*  High period weightage in a day( 16 Hours or 16 by 24 i.e:0.67 of day)

*===================================================
* Read data from Excel
*===================================================
$CALL GDXXRW.EXE input=June2018.xls output=linearjune.gdx set=d rng=day!A1 Rdim=1  par=Inflow rng=inflow!A1 Rdim=1  par=initstorage rng=initstorage!A1 Rdim=0  par=maxstorage rng=maxstorage!A1 Rdim=0   par=minstorage rng=minstorage!A1 Rdim=0  par=maxRel rng=maxRel!A1 Rdim=0 par=minRel rng=minRel!A1 Rdim=0  par=evap rng=evap!A1 Rdim=0

*Write the input Data into a GDX file
$GDXIN linearjune.gdx




* parameters and input data from the GDX file into the model
$LOAD d
$LOAD inflow
$LOAD initstorage
$LOAD maxstorage
$LOAD minstorage
$LOAD maxRel
$LOAD minRel
$LOAD evap


*Close the GDX file
$GDXIN

Display d,inflow, initstorage, maxstorage, minstorage, maxRel, minRel, evap, p, Duration;
*===============================================
SCALAR
Convert                       conversion factor from cfs to ac-ft per hour (0.0014*60)/0.084/
Totaldays                      Total number of days in the month/30/
weekdays                      Number of days in month/21/
weekends                       Number of weekend days in the month /9/
Num_of_timesteps              Total Number of timesteps used /60/
Daily_Ramprate                Allowable daily ramp rate (cfs)/8000/


VARIABLES

ObjectiveVal                   Objective functions calculation
storage                        reservoir storage at the end of the month (acre-ft)
Energy_Gen(p)                  Hydropower Generated for each timestep during unsteady flow days (MWH)
SteadyEn_Gen(p)                Hydropower Generated for each timestep during steady flow days (MWH)
Avail_Water                           Total Water available in the system during the month (June)
steady_Outflow                        Volume of water released in the steady low flow days (acre-ft)
unsteady_Outflow                      Volume of water released in the unsteay low flow days (acre-ft)
TotMonth_volume                        Total monthly volume (acre-ft)

;



EQUATIONS
*AND CONSTRAINTS

EQa_Inflow                   Total volume of Water available in the system during the month (acre-ft)
EQb_SteadyOutflow            Volume of Water released during the steady days (acre-ft)
EQc_UnSteadyOutflow          Volume of Water released during the unsteady days (acre-ft)

EQ1__ResMassBal              Reservoir mass balance (acre-ft)
EQ2__reqpowerstorage         The minimum storage equivalent to reservoir level required for hydropower generation (acre-ft)
EQ3__maxstor                 res storage max (acre-ft)
EQ4__MaxR(p)                 Max Release (cfs)
EQ5__MinR(p)                 Min Release  (cfs)
EQ6_Rampup_rate(p)           Constraining the daily ramp up rate between the timesteps(cfs)with in same day
EQ7__Monthtlyrel             Constraining Total monthly volume of water released in "June" as per WAPA information(acre-ft)
EQ8_SteadyEnergy(p)          Energy generated in each time step during steady flow days (MWH)
EQ9_EnergyGen(p)            Energy generated in each time step during unsteady flow days (MWH)
EQ10_EnergyGen_Max(p)        Maximum Energy Generation Limit of the Glen Caynon Dam(MW)
EQ11_EnergyRevenue           Total monthly Hydropower Revenue generated when number of steady low flow day are greater than number of weekend days($)
EQ12_Revenue                 Total monthly Hydropower Renvenue generated if number of steady flow days are equal or less than weekend days ($)
;

*------------------------------------------------------------------------------*


EQa_Inflow..                 Avail_Water =e= initstorage + sum(d,inflow(d)*Convert*sum(p,Duration(p)));
EQb_SteadyOutflow..          steady_Outflow =e= Steady_Release*sum(p,Duration(p))*Convert*Steady_Days;
EQc_UnSteadyOutflow..        unsteady_Outflow =e= sum(p,release(p)*Convert*Duration(p))*(Totaldays-Steady_Days);


EQ1__ResMassBal..           storage =e= Avail_Water-steady_Outflow-unsteady_Outflow-(evap*Totaldays);
EQ2__reqpowerstorage..      storage =g= minstorage;
EQ3__maxstor..              storage =l= maxstorage;

EQ4__MaxR(p)..              release(p)=l= maxRel;
EQ5__MinR(p)..              release(p)=g= minRel;
EQ6_Rampup_rate(p)..         release("pHigh")-release("pLow")=l=Daily_Ramprate;

*EQ7_  constraining the overall monthly released volume..
EQ7__Monthtlyrel..                         TotMonth_volume=e= steady_Outflow + unsteady_Outflow;


EQ8_SteadyEnergy(p)..                      SteadyEn_Gen(p)=e= Steady_Release*Duration(p)*0.03715;
* Energy generation formula used in wapa Execl model.

EQ9_EnergyGen(p)..                         Energy_Gen(p)=e= release(p)*Duration(p)*0.03715;
* Energy generation formula used in wapa Execl model..

EQ10_EnergyGen_Max(p)..                    Energy_Gen(p)=l= 1320*Duration(p);
*Maximum Energy Generation capacity of GCD (MWH).. Source https://www.usbr.gov/uc/rm/crsp/gc/

**EQ12_HyrdroPower objective                                                                                                   Energy generated from the period of low steady flow multiply by the energy rate and summed over the day (2 periods) in a day and multiply by the number of steady low flow days.
EQ11_EnergyRevenue..                         ObjectiveVal=e= sum(p,SteadyEn_Gen(p)*weekendRate(p))*weekends + sum(p,SteadyEn_Gen(p)*EnergyRate(p))*(Steady_Days-weekends)+ sum(p,Energy_Gen(p)*EnergyRate(p))*(Totaldays-Steady_Days);
* *This equation works for number of steady days greater than number of weekend days.

EQ12_Revenue..                             ObjectiveVal=e= sum(p,SteadyEn_Gen(p)*weekendRate(p))*(Steady_Days) + sum(p,Energy_Gen(p)*weekendRate(p))*(weekends - Steady_Days)+ sum(p,Energy_Gen(p)*EnergyRate(p))*(Totaldays-weekends);
*This equation works for number of steady days either equal or less than weekend days.  This equation price all the weekend days by weekned rate irrespective of whether its steady or hydropeaking day.


***************************************************
*------------------------------------------------------------------------------*
***************************************************
******Linearization Model
****************************************** ********

Steady_Days = 9;

MODEL Model1 Find value of hydropower revenue using LP/EQa_Inflow,EQb_SteadyOutflow,EQc_UnSteadyOutflow,EQ1__ResMassBal,EQ2__reqpowerstorage,EQ3__maxstor,EQ4__MaxR,EQ5__MinR,EQ6_Rampup_rate,EQ7__Monthtlyrel,EQ8_SteadyEnergy,EQ9_EnergyGen,EQ10_EnergyGen_Max,EQ11_EnergyRevenue/;
*this Model will work under scenarios when number of steady low bug flow days are greater than number of weekned days.

Model Model2 Find value of hydropower revenue using LP /EQa_Inflow,EQb_SteadyOutflow,EQc_UnSteadyOutflow,EQ1__ResMassBal,EQ2__reqpowerstorage,EQ3__maxstor,EQ4__MaxR,EQ5__MinR,EQ6_Rampup_rate,EQ7__Monthtlyrel,EQ8_SteadyEnergy,EQ9_EnergyGen,EQ10_EnergyGen_Max,EQ12_Revenue/;
*this Model will work under scenarios when number of steady low bug flow days are less than or equal to number of weekned days.



option reslim=20000;
option Threads=6;
option optcr=0.001;
option LP= BARON;


if  (Steady_Days > weekends,
     SOLVE Model1 USING LP maximize ObjectiveVal;
else SOLVE Model2 USING LP maximize ObjectiveVal;
);

FStore= ObjectiveVal.L;
XStore_steady= (Steady_Release*sum(p,Duration(p))*0.03715)*Steady_Days;
XStore_unsteady= sum(p,release(p)*Duration(p)*0.03715)*(Totaldays-Steady_Days);



*************************************************
   RStore_steady(p)= Steady_Release;

   RStore_unsteady(p)= release(p);

*********************************************************************

   Sstore=storage.L;



   ModelResults("SolStat")= Model2.solvestat;
   ModelResults("ModStat")= Model2.modelstat;

   DISPLAY FStore,XStore_steady,XStore_unsteady,RStore_steady,RStore_unsteady,Sstore;
   option clear=ObjectiveVal,clear=release,clear=Steady_Release;



*------------------------------------------------------------------------------*
* Dump all input data and results to a GAMS gdx file
Execute_Unload "linearjune.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls linearjune.gdx"


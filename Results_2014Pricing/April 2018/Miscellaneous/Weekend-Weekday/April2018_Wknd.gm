
$ontext
Title Optimization model for Glen Canyon Dam releases to favor Bugs population. (April 2018)

###################################
Created By: Moazzam Ali Rind
Email: moazzamalirind@gmail.com

Created : 6/15/2020
Last updated: 4/6/2021

Description: This model was developed to qaunitfy the trade-off between number of steady low flow days and hydropower revenue objectives.
            The model has 2 periods per day (i.e. pHigh and plow), two types of days (Weekend and Weekday), and runs for a month. we have used linear programming to solve the problem.
            All the structural and operational constraints applied here are uptodate.

######################################
$offtext

****Model code

Set

          d                             days in April
          p                             time period during a day /pLow "Low flow period",pHigh "High flow period"/
          tot_vol                       Total montly release volume (acre-ft)/V1*V5/
          modpar                        Saving model status for each of the scenario solution/ ModStat "Model Status", SolStat "Solve Status"/
          case                          Defining constrainted cases for number of low flow steady days /case1*case12/
          Wkn                           Scenarios to decide the change between off-peak release on weekday and weekend steady flows /H1*H4/
;


*======================================
*Parameters
*======================================

PARAMETERS

FStore(Wkn,tot_vol,case)                          Storing objective function values over different scenarios

XStore_steady(Wkn,tot_vol,case)                   Store Energy Generated during steady flow days over different cases (MWH)
XStore_unsteady(Wkn,tot_vol,case)                 Store Energy Generated during unsteady flow days over different cases (MWH)

RStore_steady(Wkn,tot_vol,case,p)                 Store Release values during steady flow days over different cases(cfs)
RStore_unsteady(Wkn,tot_vol,case,p)               Store Release values during unsteady flow days over different cases(cfs)

Sstore(Wkn,tot_vol,case)                          Store Storage Values over different cases(ac-ft)

ModelResults(Wkn,tot_vol,case,modpar)             Store solution status of the scenarios i.e. whether the solution found is optimal or not?
Mar_Ramp(Wkn,tot_vol,case,p)                      To save margninal values associted with the ramp rate.


initstorage                            Initial reservoir storage on 1st April 2018 (acre-ft)/12948951/
maxstorage                             Reservoir capacity (acre-ft)/25000000/
minstorage                             Minimum reservoir storage to maintain hydropower level(acre-ft) /8950000/
Inflow(d)                              Inflow to reservoir (cfs)
maxRel                                 Maximum release in a day d at any timeperiod p(cfs)/31500/
minRel                                 Minimum release in a day d at any timeperiod p(cfs)/8000/
evap(d)                                Evaporation (ac-ft per day)
EnergyRate(p)                         Energy prices on weekdays ($ per MWH) /pLow 38.24, pHigh 55.054/
weekendRate(p)                        Energy prices on weekends ($ per MWH) /pLow 38.24, pHigh 38.24/
Duration(p)                           Duration of period (hours)
Vol_monthlyrelease(tot_vol)           Different Total volumes of water to be released in the month i.e. April 2018 in presented case (acre-ft)/V1 700000,V2 800000,V3 900000,V4 1000000,V5 1100000/
TotMonth_volume                       To represent total monthly volume (acre-ft)
Steady_Days                           To represent the number of steady low flow days
Num_steady(case)                      Number of steady low flow days/case1 0, case2 4,case3 6, case4 7, case5 8, case6 9,case7 10,case8 12,case9 15,case10 20,case11 25,case12 30/
Weekend_Rel                           Additional release made on weekend incomparison to weekday off-peak release(cfs).
Diff_Release(Wkn)                     Differnce between off-peak weekday release and weekend release(cfs)/H1 0, H2 500, H3 750, H4 1000/
;


Duration("pLow")= 8;
* low period weightage in a day(08 Hours or 8 by 24 i.e:0.33 of day)

Duration("pHigh")= 16;
*  High period weightage in a day( 16 Hours or 16 by 24 i.e:0.67 of day)

*===================================================
* Read data from Excel
*===================================================
$CALL GDXXRW.EXE input=Input_April2018.xlsx output=April2018(Weekend).gdx set=d rng=day!A1 Rdim=1 par=Inflow rng=inflow!A1 Rdim=1  par=evap rng=Evaporation!A1 Rdim=1

*Write the input Data into a GDX file
$GDXIN April2018(Weekend).gdx

* loading parameters and input data from the GDX file into the model
$LOAD d
$LOAD inflow
$LOAD evap

*Close the GDX file
$GDXIN

Display d, inflow, evap, p, Duration;
*===============================================
SCALAR
Convert                       conversion factor from cfs to ac-ft per hour (0.0014*60)/0.083/
Totaldays                     Total number of days in the month/30/
weekdays                      Number of days in month/22/
weekends                       Number of weekend days in the month /8/
Num_of_timesteps              Total Number of timesteps used /60/
Daily_RelRange                Allowable daily release range (cfs)/8000/

*Here we are considering an arbitrary monthly calender with exact number of days as in real month but that considered month starts on monday.
*Which means there will be 4 Saturdays and 4 Sundays in the month. We are considering any holidays in the month.
*The real monthly calender can be easily used by changing the number of days of each day type, if required.

VARIABLES

ObjectiveVal                   Objective functions calculation
storage                        reservoir storage at the end of the month (acre-ft)
release(p)                     reservoir release on any unsteady day in any period p (cfs)
Energy_Gen(p)                  Hydropower Generated for each timestep during unsteady flow days (MWH)
SteadyEn_Gen(p)                Hydropower Generated for each timestep during steady flow days (MWH)
Steady_Release                 Minimum release value of the hydrograph

Avail_Water                    Total Water available in the system during the month (June)
steady_Outflow                 Volume of water released in the steady low flow days (acre-ft)
unsteady_Outflow               Volume of water released in the unsteay low flow days (acre-ft)

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
EQ6_Rel_Range(p)             Constraining the daily release range on a weekday (cfs per day)
EQ7__Monthtlyrel             Constraining Total monthly volume of water to be released (acre-ft)
EQ8_Steadyflow               Minimun release value within the hydrograph(cfs)
EQ9_SteadyEnergy(p)          Energy generated in each time step during steady flow days (MWH)
EQ10_EnergyGen(p)            Energy generated in each time step during unsteady flow days (MWH)
EQ11_EnergyGen_Max(p)        Maximum Energy Generation Limit of the Glen Caynon Dam(MW)
EQ12_EnergyRevenue           Total monthly Hydropower Revenue generated when number of steady low flow day are greater than number of weekend days($)
EQ13_Revenue                 Total monthly Hydropower Renvenue generated if number of steady flow days are equal or less than weekend days ($)
;

*------------------------------------------------------------------------------*


EQa_Inflow..                 Avail_Water =e= initstorage + sum(d,inflow(d)*Convert*sum(p,Duration(p)));
EQb_SteadyOutflow..          steady_Outflow =e= Steady_Release*sum(p,Duration(p))*Convert*Steady_Days;
EQc_UnSteadyOutflow..        unsteady_Outflow =e= sum(p,release(p)*Convert*Duration(p))*(Totaldays-Steady_Days);


EQ1__ResMassBal..           storage =e= Avail_Water-steady_Outflow-unsteady_Outflow-sum(d,evap(d));
EQ2__reqpowerstorage..      storage =g= minstorage;
EQ3__maxstor..              storage =l= maxstorage;

EQ4__MaxR(p)..              release(p)=l= maxRel;
EQ5__MinR(p)..              release(p)=g= minRel;
EQ6_Rel_Range(p)..          release("pHigh")-release("pLow")=l=Daily_RelRange;

*EQ7_  constraining the overall monthly released volume..
EQ7__Monthtlyrel..                         TotMonth_volume=e= steady_Outflow + unsteady_Outflow;

EQ8_Steadyflow..                           Steady_Release=e=release("pLow")+ Weekend_Rel;
* EQ8_  finds the minimimum release value from the hydrograph. This equation also takes care of ramprate bewtween unsteady high release and steady release.

EQ9_SteadyEnergy(p)..                      SteadyEn_Gen(p)=e= Steady_Release*Duration(p)*0.03715;
* Energy generation formula used in wapa Execl model.

EQ10_EnergyGen(p)..                         Energy_Gen(p)=e= release(p)*Duration(p)*0.03715;
* Energy generation formula used in wapa Execl model..

EQ11_EnergyGen_Max(p)..                    Energy_Gen(p)=l= 1320*Duration(p);
*Maximum Energy Generation capacity of GCD (MWH).. Source https://www.usbr.gov/uc/rm/crsp/gc/

EQ12_EnergyRevenue..                       ObjectiveVal=e= sum(p,SteadyEn_Gen(p)*weekendRate(p))*weekends + sum(p,SteadyEn_Gen(p)*EnergyRate(p))*(Steady_Days-weekends)+ sum(p,Energy_Gen(p)*EnergyRate(p))*(Totaldays-Steady_Days);
* *This equation works for number of steady days greater than number of weekend days.

EQ13_Revenue..                             ObjectiveVal=e= sum(p,SteadyEn_Gen(p)*weekendRate(p))*(Steady_Days) + sum(p,Energy_Gen(p)*weekendRate(p))*(weekends - Steady_Days)+ sum(p,Energy_Gen(p)*EnergyRate(p))*(Totaldays-weekends);
*This equation works for number of steady days either equal or less than weekend days.  This equation price all the weekend days by weekned rate irrespective of whether its steady or hydropeaking day.

*------------------------------------------------------------------------------*

***************************************************
******Linearization Model
****************************************** ********

MODEL Model1 Find value of hydropower revenue using LP/EQa_Inflow,EQb_SteadyOutflow,EQc_UnSteadyOutflow,EQ1__ResMassBal,EQ2__reqpowerstorage,EQ3__maxstor,EQ4__MaxR,EQ5__MinR,EQ6_Rel_Range,EQ7__Monthtlyrel,EQ8_Steadyflow,EQ9_SteadyEnergy,EQ10_EnergyGen,EQ11_EnergyGen_Max,EQ12_EnergyRevenue/;
*this Model will work under scenarios when number of steady low bug flow days are greater than number of weekned days.

*This line provides additional information in the .lst file. If you not aware of option file please comment it out or remove before running the model
*Model1.optfile = 1;

Model Model2 Find value of hydropower revenue using LP /EQa_Inflow,EQb_SteadyOutflow,EQc_UnSteadyOutflow,EQ1__ResMassBal,EQ2__reqpowerstorage,EQ3__maxstor,EQ4__MaxR,EQ5__MinR,EQ6_Rel_Range,EQ7__Monthtlyrel,EQ8_Steadyflow,EQ9_SteadyEnergy,EQ10_EnergyGen,EQ11_EnergyGen_Max,EQ13_Revenue/;
*this Model will work under scenarios when number of steady low bug flow days are less than or equal to number of weekned days.

*This line provides additional information in the .lst file. If you are not aware of option file please comment it out or remove before running the model
*Model2.optfile = 1;


*Looping over different additional weekend, total volume, and number of steay days scenarios
loop((Wkn,tot_vol,case),

option reslim=20000;
option Threads=6;
option optcr=0.001;
option LP= CPLEX;
release.L(p) = 10000;
Steady_Release.L= 8000;
   Weekend_Rel= Diff_Release(Wkn);
   TotMonth_volume = Vol_monthlyrelease(tot_vol);
   Steady_Days = Num_steady(case)+ EPS;

if  (Steady_Days > weekends,
     SOLVE Model1 USING LP maximize ObjectiveVal;
else SOLVE Model2 USING LP maximize ObjectiveVal;
);


* All the following lines of code are saving values for different parameters
   FStore(Wkn,tot_vol,case)= ObjectiveVal.L;
   XStore_steady(Wkn,tot_vol,case)= (Steady_Release.L*sum(p,Duration(p))*0.03715)*Num_steady(case);
   XStore_unsteady(Wkn,tot_vol,case)= sum(p,release.L(p)*Duration(p)*0.03715)*(Totaldays-Num_steady(case));
   RStore_steady(Wkn,tot_vol,"case1",p)= 0 + EPS;
*************************************************
   RStore_steady(Wkn,tot_vol,case,p)= Steady_Release.L;

   RStore_unsteady(Wkn,tot_vol,case,p)= release.L(p);
*********************************************************************

    RStore_unsteady(Wkn,tot_vol,"case12",p)= 0+ EPS ;

   Sstore(Wkn,tot_vol,case)=storage.L;

   ModelResults(Wkn,tot_vol,"case1","SolStat")= Model2.solvestat;
   ModelResults(Wkn,tot_vol,"case1","ModStat")= Model2.modelstat;
   ModelResults(Wkn,tot_vol,"case2","SolStat")= Model2.solvestat;
   ModelResults(Wkn,tot_vol,"case2","ModStat")= Model2.modelstat;
   ModelResults(Wkn,tot_vol,"case3","SolStat")= Model2.solvestat;
   ModelResults(Wkn,tot_vol,"case3","ModStat")= Model2.modelstat;
   ModelResults(Wkn,tot_vol,"case4","SolStat")= Model2.solvestat;
   ModelResults(Wkn,tot_vol,"case4","ModStat")= Model2.modelstat;
   ModelResults(Wkn,tot_vol,"case5","SolStat")= Model2.solvestat;
   ModelResults(Wkn,tot_vol,"case5","ModStat")= Model2.modelstat;

   ModelResults(Wkn,tot_vol,case,"SolStat")= Model1.solvestat;
   ModelResults(Wkn,tot_vol,case,"ModStat")= Model1.modelstat;

   Mar_Ramp(Wkn,tot_vol,case,p) = EQ6_Rel_Range.M(p)+ EPS;

   option clear=ObjectiveVal,clear=release,clear=Steady_Release;
);

   DISPLAY FStore,XStore_steady,XStore_unsteady,RStore_steady,RStore_unsteady,Sstore;

*------------------------------------------------------------------------------*

* Dump all input data and results to a GAMS gdx file
Execute_Unload "April2018(Weekend).gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls April2018(Weekend).gdx"

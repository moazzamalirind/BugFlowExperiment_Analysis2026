$ontext
Title Optimization model for Glen Canyon Dam releases to favor Bugs population. ( Saturday-Sunday-Weekday model Validation October 2018)

###################################
Created By: Moazzam Ali Rind
Email: moazzamalirind@gmail.com

Created : 4/6/2020

Description: This model was developed to qaunitfy the trade-off between number of steady low flow days and hydropower revenue objectives.
            The model has 2 periods per day (i.e. pHigh and plow) and runs for a month. we have used linear programming to solve the problem.
            All the structural and operational constraints applied here are uptodate.

######################################
$offtext

****Model code

Set
          d                             Types of Days involved in the model/Sunday, Saturday, Weekday/
          p                             Periods during a day /pLow "Low flow period",pHigh "High flow period"/
          modpar                        Saving model status for each of the scenario solution/ ModStat "Model Status", SolStat "Solve Status"/
;


*======================================
Parameters
*======================================

Initstorage                           Initial reservoir storage (e.g Storage in Powell on 1st October 2018) (acre-ft)/11016261/
* Storage data for lake Powell can be found at: http://lakepowell.water-data.com/index2.php

Inflow                                Average monthly Inflow to reservoir (cfs) /7757.81/
*Inflow data can be found at: http://lakepowell.water-data.com/index2.php

maxstorage                            Maximumn Reservoir capacity (acre-ft)/25000000/
minstorage                            Minimum reservoir storage to maintain hydropower level(acre-ft)/8950000/
maxRel                                Maximum release in a day d at any timeperiod p(cfs) /31500/
minRel                                Minimum release in a day d at any timeperiod p(cfs)/8000/
evap                                  Evaporation (ac-ft per Month) /30439/
*The evaporation data can be found at: https://www.usbr.gov/rsvrWater/HistoricalApp.html

Duration(p)                           Duration of period (hours)
TotMonth_volume                       To represent total monthly volume (acre-ft)

FStore                                Storing objective function values ($$)

XStore(d,p)                          Store Energy Generated during different periods on types of days (MWh)
RStore(d,p)                          Store Release values during different types of days (cfs)
Sstore                               Store Storage Values over different cases(ac-ft)

ModelResults(modpar)                 Store solution status of the scenarios i.e. whether the solution found is optimal or not?

Num_Days(d)                          Number of days for each day type/Sunday 4, Saturday 4, Weekday 23/
;

Duration("pLow")= 8;
* low period weightage in a day(08 Hours or 8 by 24 i.e:0.33 of day)

Duration("pHigh")= 16;
*  High period weightage in a day( 16 Hours or 16 by 24 i.e:0.67 of day)

Table Observed_Rel(d,p)"Releases (cfs) observed during October 2018"
                pLow      pHigh
Sunday        9038.24   9894.65
Saturday      9038.24   11357.42
Weekday       8872.3     11686.05 ;


Table Energy_Rate(d,p)"Price of MegaWatt hour during different days and within period p ($ per MWh)"
              pLow        pHigh
Sunday       47.17        47.17
Saturday     47.17        56.20
Weekday      47.17        65.24  ;



*===============================================
SCALAR
Convert                        Conversion factor from cfs to ac-ft per hour (0.0014*60)/0.083/
Daily_RelRange                 Allowable daily release range (cfs)/8000/
Totaldays                      Number of days in the month /31/
Saturdays                      number of saturdays/4/
Sundays                        number of Sundays/4/
Weekdays                       number of weekdays /23/

*===============================================
VARIABLES

ObjectiveVal                   Objective functions value ($)
storage                        Reservoir storage at the end of the month (acre-ft)
Released_vol                   Total water released during the month (ac-ft)

Positive Variables
Release(d,p)       Reservoir release on different day types and flow patterns durinng period p (cfs)
Energy_Gen(d,p)    Hydropower Generated within each timestep during different day types(MWh)
;
*===============================================

EQUATIONS

*Constraints
EQ1_ResMassBal                       Reservoir mass balance (acre-ft)
EQ2_reqpowerstorage                  The minimum storage required for hydropower generation(power pool storage) (acre-ft)
EQ3_maxstor                          Reservoir Max storage (acre-ft)
EQ4_MaxR(d,p)                        Max Release for any day type during any period p(cfs)
EQ5_MinR(d,p)                        Min Release for any day type with flows during any period p  (cfs)
EQ6_Rel_Range(d)                     Constraining the daily release range but it will not work (cfs per day)
EQ7_RelVolume                        Total volume from different types of day in the month (ac-ft)
EQ8_OffPeak_Release(d)               To make Off-peak period release during Saturday and Sunday equal (cfs)
EQ9_EnergyGen_Max(d,p)               Maximum Energy Generation Limit of the Glen Caynon Dam(MWh)
EQ10_EnergyGen(d,p)                  Energy generated in each period p during different day types (MWh)
*Objective Functions
EQ11_EnergyRevenue                   Total monthly Hydropower Revenue generated($)
EQ12_Simulation(d,p)                 Making releases equal to observed hydrograph releases (simulation)
;

*------------------------------------------------------------------------------*

*Mass Balance Equation
EQ1_ResMassBal..                               storage =e= Initstorage + (Inflow*Convert*sum(p,Duration(p))*Totaldays)- Released_vol - evap;
*                                                                          CFS * conversion factor from cfs to ac-ft/hr and multiplied by 24 (total duration in a day) then multiplied by total day in the month
*Physical Constraints
EQ2_reqpowerstorage..                          storage =g= minstorage;
EQ3_maxstor..                                  storage =l= maxstorage;

EQ4_MaxR(d,p)..                                Release(d,p)=l= maxRel;

EQ5_MinR(d,p)..                                Release(d,p)=g= minRel;

EQ6_Rel_Range(d)..                             Release(d,"pHigh")- Release(d,"pLow")=l=Daily_RelRange;

EQ7_RelVolume..                               Released_vol=e= sum(d,sum(p, Release(d,p)*Convert*Duration(p))*Num_Days(d));

*Managerial Constraints
EQ8_OffPeak_Release(d)..                    Release("Saturday","pLow") =e= Release("Sunday","pLow");
*This equation makes off-peak saturday equals to Sunday off-peak sunday...

EQ9_EnergyGen_Max(d,p)..                                          Energy_Gen(d,p)=l= 1320*Duration(p);
*Maximum Energy Generation capacity of GCD (MWH).. Source https://www.usbr.gov/uc/rm/crsp/gc
EQ10_EnergyGen(d,p)..                                              Energy_Gen(d,p)=e= Release(d,p)*Duration(p)*0.03715;
* Energy generation formula used in WAPA Execl model..

EQ11_EnergyRevenue..                                                ObjectiveVal=e= sum(d,sum(p,Energy_Gen(d,p)*Energy_Rate(d,p))*Num_Days(d));
*------------------------------------------------------------------------------*
*Simulation part
EQ12_Simulation(d,p)..                                                   Release(d,p)=e=Observed_Rel(d,p);

*__________________________________________________________________________________


MODEL Model1 Find value of hydropower revenue using LP/ALL/;
*This model is for all cases of steady flow days

*Select the linear solver to be used
option LP= CPLEX;

Solve Model1 using LP MAXIMIZE ObjectiveVal;

*----------------------------------------------------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------------------------
* All the following lines of code are saving values for different parameters

   FStore= ObjectiveVal.L;

* XStore store the energy generated (Mwh/day) during different types of days
*XStore(d)= sum (p,Energy_Gen.L(d,p))+ EPS;
   XStore(d,p) = Energy_Gen.L(d,p)+ EPS;

* RStore store the reservoir releases (cfs) during different types of days and scenarios.
   RStore(d,p)= Release.L(d,p)+ EPS;

*Sstore store the end of month reservoir storage (ac-ft)
   Sstore = storage.L;

*Saving the model status for different scenarios.
   ModelResults("SolStat")= Model1.solvestat;
   ModelResults("ModStat")= Model1.modelstat;

   option clear=ObjectiveVal,clear=Release,clear=Energy_Gen;


DISPLAY FStore,XStore,RStore,Sstore;

*------------------------------------------------------------------------------*

*Following part of code creates gdx and excel output file..

* Dump all input data and results to a GAMS gdx file
Execute_Unload "Valid_SatModel_October.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls Valid_SatModel_October.gdx"












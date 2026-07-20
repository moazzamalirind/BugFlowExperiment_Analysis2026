
$ontext
Title Optimization model for Glen Canyon Dam releases to favor Bugs population (March 2018)


###################################
Created By: Moazzam Ali Rind
Email: moazzamalirind@gmail.com

Created : 4/3/2021


Description: This model is designed to validate the Weekend-Weekday model at the hourly time scale. Since this a validation model, therefore, the hydrograph is input to the model.
             Which also means there is no release decision involved in this model. The aim of validation model is to simulate the observed hydrograph and estimate the hydropower revenue from the model.

######################################

$offtext

**** Hourly validation Model code:

Set

          d             days in March
          p             time periods during a day /p1*p24/
          modpar        Saving model parameter for each of the scenario/ ModStat "Model Status", SolStat "Solve Status"/


*======================================
*Parameters
*======================================

PARAMETERS

initstorage                  Initial reservoir storage on 1st March 2018 (acre-ft)/13335432/
maxstorage                   Reservoir capacity (acre-ft)/25000000/
minstorage                   Minimum reservoir storage to maintain hydropower level(acre-ft) /8950000/
Inflow(d)                    Inflow to reservoir (cfs)
observed_release(d,p)        observed release during March 2018 averaged over hourly timestep (cfs)
maxRel                       Maximum release in a day d at any timeperiod p(cfs)/31500/
minRel                       Minimum release in a day d at any timeperiod p(cfs)/8000/
evap                         evaporation (ac-ft per day). Evaporation is considered constant throughout the month/514/
EnergyRate(p)                Energy revenue ($ per MWH)

FStore                       Storing objective function value
Xstore(d)                    Storing energy generation(MWh per day)
ModelResults(modpar)         Store solution status of the scenarios i.e. whether the solution found is optimal or not?
RStore(d,p)                  Store Release values during each period (cfs)
Sstore(d)                    Store Storage Values (ac-ft)
;



*===================================================
* Read data from Excel
*===================================================
$CALL GDXXRW.EXE input=Input_March_2018.xlsx output= Validation_March2018(Hourly).gdx  par=observed_release rng=Observed_Release(Hr)!A1:Y32 par=EnergyRate rng=Rates!A1 Rdim=1  set=d rng=day!A1 Rdim=1  par=Inflow rng=inflow!A1 Rdim=1

*Write the input Data into a GDX file
$GDXIN Validation_March2018(Hourly).gdx

* parameters and input data from the GDX file into the model
$LOAD d
$LOAD inflow
$LOAD observed_release
$LOAD EnergyRate
*Close the GDX file
$GDXIN

Display d,inflow, p, EnergyRate, observed_release;
*===============================================
SCALAR
Convert                       conversion factor from cfs to ac-ft per hour (0.0014*60)/0.083/
*Totaldays                     Total number of days in the month/31/
*weekdays                      Number of days in month/22/
*weekends                      Number of weekend days in the month /9/
Daily_RelRange                Allowable daily release change range (cfs)/8000/
*Num_of_timesteps              Total Number of timesteps used /720/

VARIABLES
ObjectiveVal                   Objective function value

Positive Variables
storage(d)                    reservoir storage on any day d (acre-ft)
release(d,p)                  reservoir release on any day d in any period p (cfs)
Energy_Gen(d,p)               Hydropower Generated at a each time step (MWH)
ReleaseVol(d,p)               volume of water released per time step(acre-ft)
Vol_monthlyrelease            Total volume of water released in the month
;



EQUATIONS
*AND CONSTRAINTS

EQ1__ResMassBal(d)           Reservoir mass balance (acre-ft)
EQ2__reqpowerstorage(d)      The minimum storage equivalent to reservoir level required for hydropower generation (acre-ft)
EQ3__maxstor(d)              Reservoir storage max (acre-ft)
EQ4__MaxR(d,p)               Max Release (cfs)
EQ5__MinR(d,p)               Min Release (cfs)
EQ6_Rel_Range(d,p)           Constraining the daily release range on a weekday (cfs per day)
EQ7_FlowVolume(d,p)          volume of water released per time step (acre-ft)
EQ8__March_rel               Total monthly volume of water released(acre-ft)
EQ9_EnergyGen(d,p)           Amount of energy generated in each time step (MWH)
EQ10_EnergyGen_Max(d,p)      Maximum Energy Generation Limit of the Glen Caynon Dam(MWh)
EQ11_EnergyRevenue           Total monthly Hydropower Revenue generated
EQ12_ReleaseSim(d,p)         Setting release values as predefined for simulation(cfs)
;


*------------------------------------------------------------------------------*

EQ1__ResMassBal(d)..         storage(d) =e= initstorage$(ord(d)eq 1)+ storage(d-1)$(ord(d)gt 1)+ (inflow(d)*Convert*24)- sum(p,ReleaseVol(d,p))-evap;
EQ2__reqpowerstorage(d)..    storage(d) =g= minstorage;
EQ3__maxstor(d)..            storage(d)=l= maxstorage;
EQ4__MaxR(d,p)..             release(d,p)=l= maxRel ;
EQ5__MinR(d,p)..             release(d,p)=g= minRel;
EQ6_Rel_Range(d,p)..         release(d,p+1)-release(d,p)=l=Daily_RelRange;
EQ7_FlowVolume(d,p)..        ReleaseVol(d,p) =e= release(d,p)*Convert;
EQ8__March_rel..             sum(d,sum(p,ReleaseVol(d,p)))=e=Vol_monthlyrelease;
EQ9_EnergyGen(d,p)..         Energy_Gen(d,p)=e= release(d,p)*0.03715;
EQ10_EnergyGen_Max(d,p)..    Energy_Gen(d,p)=l= 1320;
*Maximum Energy Generation capacity of GCD (MWH).. Source https://www.usbr.gov/uc/rm/crsp/gc/

**EQ11_HyrdroPower objective
EQ11_EnergyRevenue..                           ObjectiveVal=e= sum((d,p),Energy_Gen(d,p)*EnergyRate(p));


***************************************************
******Simulation Model
****************************************** ********
*------------------------------------------------------------------------------*
*Eqauation 12 is making releases equal to observed release.
EQ12_ReleaseSim(d,p)..                 release(d,p)=e=observed_release(d,p);


* Define MODEL validation using the LP
MODEL validation Find extreme points by using  LP /ALL/;
*Solve the model
SOLVE validation USING LP MAXIMIGING ObjectiveVal;
FStore = ObjectiveVal.L;
ModelResults("ModStat")= validation.modelstat;
ModelResults("SolStat")= validation.solvestat;
RStore(d,p)= release.L(d,p);
Sstore(d)= storage.L(d);
Xstore(d)= sum(p,Energy_Gen.L(d,p));

DISPLAY FStore,RStore,Sstore,Xstore;

* Dump all input data and results to a GAMS gdx file
Execute_Unload "Validation_March2018(Hourly).gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls Validation_March2018(Hourly).gdx"




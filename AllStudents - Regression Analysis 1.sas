* Andrea Stancescu;
* St 499;
* logistic regression to determine variable importance on career plan (academia vs other);


x "cd C:\Classes\ST 499\SAS Analysis and Regression";
libname ST499 ".";

ods trace on;
ods pdf file='AllStudentsAnalysis.pdf';


ods pdf exclude all;

*import both of the excel files;
proc import file="C:\Classes\ST 499\SAS Analysis and Regression\All Students Entry Data Numbers.xlsx" 
            out=ST499.EntryNums 
            dbms=xlsx replace;
  getnames=YES;
run;

data st499.EntryNums(rename=(Satisfied_w_feedback_from_adviso = advfeed
                            Advisor_respects_my_opinions = advopn
                            I_feel_safe_voicing_feelings_to = advfeel
                            Rate_relationship_with_my_adviso = advrel
                            Department_is_welcoming = depwelc
                            Department_emphasizes_the_import = depdiv));
  set st499.EntryNums;
  if career_plans in ('Job in academia', 'Postdoc then job in academia') then career_plans='Academia';
  if career_plans in ('Job in industry or govt', 'Postdoc then job in industry or govt') then career_plans='Industry/Govt';
  if career_plans in ('Job in industry then in academia', 'Other') then career_plans='Other';
run;



proc import file="C:\Classes\ST 499\SAS Analysis and Regression\All Students Exit Data Numbers.xlsx" 
            out=ST499.ExitNums 
            dbms=xlsx replace;
  getnames=YES;
run;

data st499.ExitNums(rename=(Satisfied_w_feedback_from_adviso = advfeed
                            Advisor_respects_my_opinions = advopn
                            I_feel_safe_voicing_feelings_to = advfeel
                            Rate_relationship_with_my_adviso = advrel
                            Department_is_welcoming = depwelc
                            Department_emphasizes_the_import = depdiv));
  set st499.ExitNums;
  if career_plans in ('Job in academia', 'Postdoc then job in academia') then career_plans='Academia';
  if career_plans in ('Job in industry or govt', 'Postdoc then job in industry or govt') then career_plans='Industry/Govt';
  if career_plans in ('Job in industry then in academia', 'Other') then career_plans='Other';
run;






data st499.EntryNums;
  set st499.EntryNums;
  if career_plans = 'Academia' then career_plans=1;
  if career_plans = 'Industry/Govt' then career_plans=0;
  if career_plans = 'Other' then career_plans=0;
run;



data st499.ExitNums;
  set st499.ExitNums;
  if career_plans = 'Academia' then career_plans=1;
  if career_plans = 'Industry/Govt' then career_plans=0;
  if career_plans = 'Other' then career_plans=0;
run;





ods pdf exclude none;







*ANALYSIS;
*run logistic regression;

title 'Entry Career Plan Logistic Regression - All Students';
title2 'Find most significant variable to predict career plan at entrance';
proc logistic data=ST499.EntryNums descending;
  model Career_plans(event= '1') = advfeed
                                    advopn
                                    advfeel
                                    advrel
                                    depwelc
                                    depdiv/ selection=stepwise expb stb lackfit;
  output out = ST499.EntryNumsLogistic p=new;
  store entyrynums_logistic;
run;
title;



title 'Exit Career Plan Logistic Regression - All Students';
title2 'Find most significant variable to predict career plan at exit';
proc logistic data=ST499.ExitNums descending;
  model Career_plans(event= '1') = advfeed
                                    advopn
                                    advfeel
                                    advrel
                                    depwelc
                                    depdiv/ selection=stepwise expb stb lackfit;
  output out = ST499.ExitNumsLogistic p=new;
  store exitnums_logistic;
run;
title;





*logistic regression by university;


*NCSU;
title 'Entry Career Plan Logistic Regression - NCSU Students';
title2 'Find most significant variable to predict career plan at entrance';
proc logistic data=ST499.EntryNums descending;
  where University="NCSU";
  model Career_plans(event= '1') = advfeed
                                    advopn
                                    advfeel
                                    advrel
                                    depwelc
                                    depdiv/ selection=stepwise expb stb lackfit;
  output out = ST499.EntryNumsLogistic p=new;
  store entyrynums_logistic;
run;
title;


title 'Exit Career Plan Logistic Regression - NCSU Students ';
title2 'Find most significant variable to predict career plan at exit';
proc logistic data=ST499.ExitNums descending;
  where University = "NCSU";
  model Career_plans(event= '1') = advfeed
                                    advopn
                                    advfeel
                                    advrel
                                    depwelc
                                    depdiv/ selection=stepwise expb stb lackfit;
  output out = ST499.ExitNumsLogistic p=new;
  store exitnums_logistic;
run;
title;





* UNCC;
title 'Entry Career Plan Logistic Regression - UNCC Students';
title2 'Find most significant variable to predict career plan at entrance';
proc logistic data=ST499.EntryNums descending;
  where University="UNCC";
  model Career_plans(event= '1') = advfeed
                                    advopn
                                    advfeel
                                    advrel
                                    depwelc
                                    depdiv/ selection=stepwise expb stb lackfit;
  output out = ST499.EntryNumsLogistic p=new;
  store entyrynums_logistic;
run;
title;


title 'Exit Career Plan Logistic Regression - UNCC Students';
title2 'Find most significant variable to predict career plan at exit';
proc logistic data=ST499.ExitNums descending;
  where University = "UNCC";
  model Career_plans(event= '1') = advfeed
                                    advopn
                                    advfeel
                                    advrel
                                    depwelc
                                    depdiv/ selection=stepwise expb stb lackfit;
  output out = ST499.ExitNumsLogistic p=new;
  store exitnums_logistic;
run;
title;



*NCA&T;
title 'Entry Career Plan Logistic Regression - NCA&T Students';
title2 'Find most significant variable to predict career plan at entrance';
proc logistic data=ST499.EntryNums descending;
  where University = 'NCA&T';
  model Career_plans(event= '1') = advfeed
                                    advopn
                                    advfeel
                                    advrel
                                    depwelc
                                    depdiv/ selection=stepwise expb stb lackfit;
  output out = ST499.EntryNumsLogistic p=new;
  store entyrynums_logistic;
run;
title;


title 'Exit Career Plan Logistic Regression - NCA&T Students';
title2 'Find most significant variable to predict career plan at exit';
proc logistic data=ST499.ExitNums descending;
  where University = 'NCA&T';
  model Career_plans(event= '1') = advfeed
                                    advopn
                                    advfeel
                                    advrel
                                    depwelc
                                    depdiv/ selection=stepwise expb stb lackfit;
  output out = ST499.ExitNumsLogistic p=new;
  store exitnums_logistic;
run;
title;















*CONTINGENCY TABLES - check for covariance & multicollinearity among inputs / predictors;

title 'Multicollinearity among predictors for Entry Career plan';
proc reg data= ST499.EntryNums;
 model Career_plans = advfeed
                       advopn
                       advfeel
                       advrel
                       depwelc
                       depdiv/ vif;
run;
title;
*from the output we see that all 6 predictors have VIF < 10;


title 'Multicollinearity among predictors for Exit Career plan';
proc reg data= ST499.ExitNums;
 model Career_plans = advfeed
                       advopn
                       advfeel
                       advrel
                       depwelc
                       depdiv/ vif;
run;
title;
*from the output we see that all 6 predictors have VIF < 10;


* let's create a correlation matrix to find all pairwise correlations between the 6 predictors;
* if the correlation is close to +1 or -1 then we know that those 2 vars have a high cov / are highly correlated;
* this will result in some multi collinearity as we are seeing in the logistic regression models;
title 'correlation matrix for entry data predictors';
proc corr data=ST499.EntryNums;
    var advfeed
        advopn
        advfeel
        advrel
        depwelc
        depdiv;
run;
title;

title 'correlation matrix for exit data predictors';
proc corr data=ST499.ExitNums;
    var advfeed
        advopn
        advfeel
        advrel
        depwelc
        depdiv;
run;
title;

















*ANALYSIS pt 2;
*let's re-run  the logistic regression with only 2 predictors instead of the 6 highly correlated predictors ;

title 'Entry Career Plan Logistic Regression - All Universities';
title2 'Find most significant variable to predict career plan at entrance';
proc logistic data=ST499.EntryNums descending plots=EFFECT plots=ROC;
  model Career_plans(event= '1') = advrel
                                    depdiv/ selection=stepwise expb stb lackfit;
  output out = ST499.EntryNumsLogistic p=yhat;
  store entyrynums_logistic;
run;
title;

proc gplot data=ST499.EntryNumsLogistic ; /*generates logistic curve*/
  plot yhat*Career_plans;
run;

proc plm restore=entyrynums_logistic;
   effectplot;
run;




title 'Exit Career Plan Logistic Regression - All Universities';
title2 'Find most significant variable to predict career plan at exit';
proc logistic data=ST499.ExitNums descending plots=EFFECT plots=ROC;
  model Career_plans(event= '1') = advrel
                                    depdiv/ selection=stepwise expb stb lackfit;
  output out = ST499.ExitNumsLogistic p=yhat;
  store exitnums_logistic;
run;
title;

proc plm restore=exitnums_logistic;
   effectplot;
run;






* let's run the logistic regression to see how career plan relates to the time in program;

title 'Entry Career vs TimeInProgram - All Universities';
title2 'Find relationship between career plan and time in program at entrance';
proc logistic data=ST499.EntryNums descending plots=EFFECT plots=ROC;
  class timeinprogram;
  model Career_plans = TimeinProgram / selection=stepwise expb stb lackfit;
  output out = ST499.EntryNumsTime p=yhat;
  store entyrynums_time;
run;
title;

proc plm restore=entyrynums_time;
   effectplot;
run;




title 'Exit Career Plan vs TimeInProgram - All Universities';
title2 'Find relationship between career plan and time in program at exit';
proc logistic data=ST499.ExitNums descending plots=EFFECT plots=ROC;
  class timeinprogram;
  model Career_plans = TimeinProgram / selection=stepwise expb stb lackfit;
  output out = ST499.ExitNumsTime p=yhat;
  store exitnums_time;
run;
title;

proc plm restore=exitnums_time;
   effectplot;
run;

























ods pdf close;
ods trace off;
quit;

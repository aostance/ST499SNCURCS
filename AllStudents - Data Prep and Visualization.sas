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
 attrib advfeed label='Rate your satisfaction with feedback from your advisor'
         advopn label='Do you agree that your advisor respects your opinions?'
		 advfeel label='Do you feel safe voicing feelings to your advisor'
		 advrel label='Rate your relationship with your advisor'
		 depwelc label='Do you agree that your department is welcoming?'
		 depdiv label='Do you agree that your department emphasizes the importance of diversity?';
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
  attrib advfeed label='Rate your satisfaction with feedback from your advisor'
         advopn label='Do you agree that your advisor respects your opinions?'
		 advfeel label='Do you feel safe voicing feelings to your advisor'
		 advrel label='Rate your relationship with your advisor'
		 depwelc label='Do you agree that your department is welcoming?'
		 depdiv label='Do you agree that your department emphasizes the importance of diversity?';
  set st499.ExitNums;
  if career_plans in ('Job in academia', 'Postdoc then job in academia') then career_plans='Academia';
  if career_plans in ('Job in industry or govt', 'Postdoc then job in industry or govt') then career_plans='Industry/Govt';
  if career_plans in ('Job in industry then in academia', 'Other') then career_plans='Other';
run;





ods pdf exclude none;
title;


ods output cmh=st499.cmhentry;
PROC FREQ DATA = ST499.EntryNums ;
  TABLES (advfeed advopn advfeel advrel depwelc depdiv) * career_plans / NOROW NOCOL NOFREQ CHISQ CL cmh;
run;

title 'Entry: Measures of Associations - Predictors vs Response';
proc print data =st499.cmhentry(where=(statistic=1));
run;
title;



ods output cmh=st499.cmhexit;
PROC FREQ DATA = ST499.ExitNums ;
  TABLES (advfeed advopn advfeel advrel depwelc depdiv) * career_plans / NOROW NOCOL NOFREQ CHISQ CL cmh;
run;

title 'Exit: Measures of Associations - Predictors vs Response';
proc print data =st499.cmhexit(where=(statistic=1));
run;
title;


























*let's visualize just the 6 predictors were considering vs career plan;

data st499.entrynumsgraph;
  set st499.entrynums(keep=advfeed advopn advfeel advrel depwelc depdiv career_plans);
run;

proc sort data=st499.entrynumsgraph;
  by descending career_plans;
run;

proc transpose data=st499.entrynumsgraph out=st499.entrytranspose;
  by descending career_plans;
run;

data st499.entrytranspose;
  set st499.entrytranspose;
  new_col = sum(of _numeric_);
run;

title 'Entry: Career plan distribution over all 6 variables of interest';
proc sgplot data=st499.entrytranspose;
  vbar _label_  / response =new_col group=career_plans 
                  datalabel seglabel;
  xaxis label='Predictors/Questions';
  yaxis label='Count of Career Plan';
run;
title;




*repeat for exit data;
data st499.exitnumsgraph;
  set st499.exitnums(keep=advfeed advopn advfeel advrel depwelc depdiv career_plans);
run;

proc sort data=st499.exitnumsgraph;
  by descending career_plans;
run;

proc transpose data=st499.exitnumsgraph out=st499.exittranspose;
  by descending career_plans;
run;

data st499.exittranspose;
  set st499.exittranspose;
  new_col = sum(of _numeric_);
run;


title 'Exit: Career plan distribution over all 6 variables of interest';
proc sgplot data=st499.exittranspose;
  vbar _label_  / response =new_col group=career_plans 
                  datalabel seglabel;
  xaxis label='Predictors/Questions';
  yaxis label='Count of Career Plan';
run;
title;











ods pdf exclude all;


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




*view information about imported data sets;
title 'Metadata of Entry Data';
proc contents data=ST499.EntryNums varnum;
run;
title;

title 'Metadata of Exit Data';
proc contents data=ST499.ExitNums varnum;
run;
title;









ods pdf exclude none;


* frequency table of the target variable ("Career_plans");
title 'Entry Career Plans frequency';
proc freq data=ST499.EntryNums;
  table Career_plans;
run;
title;

title 'Exit Career Plans frequency';
proc freq data=ST499.ExitNums;
  table Career_plans;
run;
title;
*we see that category 1 decreases by about 2% after more than 3 years in the program;
*following, category 0 inreases by about 2% after more than 3 years in the program;









* contingency tables to find multicollinearity;
* we are interested in M^2 / "Mantel–Haenszel” or “Cochran–Mantel–Haenszel” statistic -- WE REQUEST THIS USING THE CMH OPTION IN SAS;
ods output cmh=st499.mantelstatfreqentry;
title 'contingency tables for 6 predictors entry data';
proc freq data=ST499.EntryNums order=formatted;
  tables advfeed*advopn
         advfeed*advfeel
		 advfeed*advrel
		 advfeed*depwelc
		 advfeed*depdiv
		 advopn*advfeel
		 advopn*advrel
		 advopn*depwelc
		 advopn*depdiv
		 advfeel*advrel
		 advfeel*depwelc
		 advfeel*depdiv
		 advrel*depwelc
		 advrel*depdiv
		 depwelc*depdiv / cmh chisq;
run;
title;

title 'Entry: Measures of Associations - Predictors';
proc print data =st499.mantelstatfreqentry(where=(statistic=1));
run;
title;





ods output cmh=st499.mantelstatfreqexit;
title 'contingency tables for 6 predictors exit data';
proc freq data=ST499.ExitNums order=formatted;
  tables advfeed*advopn
         advfeed*advfeel
		 advfeed*advrel
		 advfeed*depwelc
		 advfeed*depdiv
		 advopn*advfeel
		 advopn*advrel
		 advopn*depwelc
		 advopn*depdiv
		 advfeel*advrel
		 advfeel*depwelc
		 advfeel*depdiv
		 advrel*depwelc
		 advrel*depdiv
		 depwelc*depdiv / cmh chisq ;
run;
title;

title 'Exit: Measures of Associations - Predictors';
proc print data =st499.mantelstatfreqexit(where=(statistic=1));
run;
title;






ods pdf close;
ods trace off;
















ods pdf file='Measures of Associations.pdf';

title 'Entry: Measures of Associations - Predictors vs Response';
proc print data =st499.cmhentry(where=(statistic=1)) noobs;
run;
title;


title 'Exit: Measures of Associations - Predictors vs Response';
proc print data =st499.cmhexit(where=(statistic=1)) noobs;
run;
title;



title 'Entry: Measures of Associations - Predictors';
proc print data =st499.mantelstatfreqentry(where=(statistic=1)) noobs;
run;
title;

title 'Exit: Measures of Associations - Predictors';
proc print data =st499.mantelstatfreqexit(where=(statistic=1)) noobs;
run;
title;




ods pdf close;








quit;

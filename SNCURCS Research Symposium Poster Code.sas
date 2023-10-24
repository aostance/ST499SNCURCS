* Andrea Stancescu;
* St 499;
* SNCURCS poster code;


x "cd C:\Classes\ST 499\SAS Analysis and Regression";
libname ST499 ".";

ods trace on;





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
 attrib timeinprogram label='How much time have you been in your program'
         advfeed label='Satisfied with the quality and quantity of feedback from your advisor.'
         advopn label='Advisor respects your opinions and contributions'
		 advfeel label='You feel safe voicing your feelings to your advisor'
		 advrel label='Rate your relationship with your advisor'
		 depwelc label='Your department is a welcoming place to learn and work'
		 depdiv label='Your department emphasizes the importance of demographic diversity';
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
  attrib advfeed label='Satisfied with the quality and quantity of feedback from your advisor.'
         advopn label='Advisor respects your opinions and contributions'
		 advfeel label='You feel safe voicing your feelings to your advisor'
		 advrel label='Rate your relationship with your advisor'
		 depwelc label='Your department is a welcoming place to learn and work'
		 depdiv label='Your department emphasizes the importance of demographic diversity'
         timeinprogram label='How much time have you been in your program';
  set st499.ExitNums;
  if career_plans in ('Job in academia', 'Postdoc then job in academia') then career_plans='Academia';
  if career_plans in ('Job in industry or govt', 'Postdoc then job in industry or govt') then career_plans='Industry/Govt';
  if career_plans in ('Job in industry then in academia', 'Other') then career_plans='Other';
run;


title;












ods pdf file="SNCURCS output.pdf";
option nodate;
ods trace on;


ods pdf exclude none;
ods output kendallcorr=st499.entry1kendalltau;
title 'Correlation tables for 6 predictors - entry data';
proc corr data=ST499.EntryNums(where=(cohort in (1))) outk=st499.entry1kendall outs=st499.entry1spearman;
  var advfeed advopn advfeel advrel depwelc depdiv  ;
run;


ods pdf exclude none;
title 'Cohort 1 Entry: Measures of Associations - Predictors';
proc print data =st499.entry1kendalltau noobs;
  var advfeed advopn advfeel advrel depwelc depdiv  ;
  id variable label ;
run;
title;





ods pdf exclude none;
ods output kendallcorr=st499.entry2kendalltau;
title 'Correlation tables for 6 predictors - exit data';
proc corr data=ST499.EntryNums(where=(cohort in (2))) outk=st499.entry2kendall outs=st499.entry2spearman;
  var advfeed advopn advfeel advrel depwelc depdiv  ;
run;
title;

ods pdf exclude none;
title 'Cohort 2 Entry: Measures of Associations - Predictors';
proc print data =st499.entry1kendalltau noobs ;
  var advfeed advopn advfeel advrel depwelc depdiv ;
  id variable label;
run;
title;
























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







title 'COHORT 1 ENTRY REGN';
ods output ModelBuildingSummary = st499.log1entry;
proc logistic data=ST499.EntryNums(where=(cohort=1)) descending alpha=0.1 ;
  class department ;
  model Career_plans(event= '1') = department
                                    advfeed
                                    advopn
                                    advfeel
                                    advrel
                                    depwelc
                                    depdiv /  selection=stepwise include=1 expb stb lackfit slentry=0.1 slstay=0.1
                                              rsquare clodds=pl;
run;


title 'COHORT 1 ENTRY REGN';
proc report data=st499.log1entry;
run;

title;









title 'COHORT 2 ENTRY REGN';
ods output ModelBuildingSummary  = st499.log2entry;
proc logistic data=ST499.EntryNums(where=(cohort=2)) descending alpha=0.1 ;
  class department ;
  model Career_plans(event= '1') = department 
                                   advfeed
                                    advopn
                                    advfeel
                                    advrel
                                    depwelc
                                    depdiv /  selection=stepwise include=1 expb stb lackfit slentry=0.1 slstay=0.1 
                                              rsquare clodds=pl ;
run;


title 'COHORT 2 ENTRY REGN';
proc report data=st499.log2entry;
run;
title;










title 'COHORT 1 EXIT REGN';
ods output ModelBuildingSummary = st499.log1exit;
proc logistic data=ST499.ExitNums(where=(cohort=1)) descending alpha=0.1 ;
  class department;
  model Career_plans(event= '1') = department 
                                    advopn
                                    advfeel
                                    advrel
                                    depwelc
                                    depdiv /  selection=stepwise include=1 expb stb lackfit slentry=0.1 slstay=0.1 
                                              rsquare clodds=pl ;
run;


title 'COHORT 1 EXIT REGN';
proc report data=st499.log1exit;
run;
title;









title 'COHORT 2 EXIT REGN';
ods output ModelBuildingSummary = st499.log2exit;
proc logistic data=ST499.ExitNums(where=(cohort=2)) descending alpha=0.1 ;
  class department ;
  model Career_plans(event= '1') = department
                                    advfeed
                                    advopn
                                    advfeel
                                    advrel
                                    depwelc
                                    depdiv
                                    timeinprogram /  selection=stepwise include=1 expb stb lackfit slentry=0.1 slstay=0.1 
                                                     rsquare clodds=pl ;
run;


title 'COHORT 2 EXIT REGN';
proc report data=st499.log2exit;
run;
title;









*let's do a logistic regn for each of the individual 6 predictors;
%macro logperfactor(data, coh, pred);
ods exclude all; 
ods output ModelBuildingSummary = st499.logoutput;
proc logistic data=&data(where=(cohort=&coh)) descending alpha=0.15 ;
  class timeinprogram ;
  model Career_plans(event= '1') = &pred  /  selection=stepwise expb stb lackfit  ;
run;

ods exclude none;
title ' ' &data &coh' ';
proc report data=st499.logoutput;
run;
title;

%mend;

%logperfactor(ST499.entrynums, 1, advfeed);
%logperfactor(ST499.entrynums, 1, advopn);
%logperfactor(ST499.entrynums, 1, advfeel);
%logperfactor(ST499.entrynums, 1, advrel);
%logperfactor(ST499.entrynums, 1, depwelc);
%logperfactor(ST499.entrynums, 1, depdiv);



%logperfactor(ST499.entrynums, 2, advfeed);
%logperfactor(ST499.entrynums, 2, advopn);
%logperfactor(ST499.entrynums, 2, advfeel);
%logperfactor(ST499.entrynums, 2, advrel);
%logperfactor(ST499.entrynums, 2, depwelc);
%logperfactor(ST499.entrynums, 2, depdiv);


%logperfactor(ST499.exitnums, 1, advfeed);
%logperfactor(ST499.exitnums, 1, advopn);
%logperfactor(ST499.exitnums, 1, advfeel);
%logperfactor(ST499.exitnums, 1, advrel);
%logperfactor(ST499.exitnums, 1, depwelc);
%logperfactor(ST499.exitnums, 1, depdiv);


%logperfactor(ST499.exitnums, 2, advfeed);
%logperfactor(ST499.exitnums, 2, advopn);
%logperfactor(ST499.exitnums, 2, advfeel);
%logperfactor(ST499.exitnums, 2, advrel);
%logperfactor(ST499.exitnums, 2, depwelc);
%logperfactor(ST499.exitnums, 2, depdiv);

































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
  new_col = mean(of _numeric_);
run;

title 'Entry: Career plan distribution over all 6 variables of interest';
proc sgplot data=st499.entrytranspose;
  vbar _label_  / response =new_col group=career_plans 
                  datalabel seglabel;
  xaxis label='Predictors/Questions';
  yaxis label='Mean Student Rating';
run;
title;

title 'Entry Survey: Mean Question Rating over all 6 variables of interest';
proc sgplot data=st499.entrytranspose;
	styleattrs datasymbols=(trianglefilled circlefilled squarefilled);
    scatter x = _label_  y = new_col / group=career_plans NOMISSINGGROUP
                                       MARKERATTRS=(size=14pt)
                                       datalabel;
	xaxis label='Predictors/Questions';
	yaxis label='Mean Student Rating';
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
  new_col = mean(of _numeric_);
run;


title 'Exit: Career plan distribution over all 6 variables of interest';
proc sgplot data=st499.exittranspose;
  vbar _label_  / response =new_col group=career_plans 
                  datalabel seglabel;
  xaxis label='Predictors/Questions';
  yaxis label='Mean Student Rating';
run;
title;


title 'Exit Survey: Mean Question Rating over all 6 variables of interest';
proc sgplot data=st499.exittranspose;
    styleattrs datasymbols=(trianglefilled circlefilled squarefilled);
    scatter x = _label_  y = new_col / group=career_plans NOMISSINGGROUP
                                       MARKERATTRS=(size=12pt) datalabel;
	xaxis label='Predictors/Questions';
	yaxis label='Mean Student Rating';
run;
title;






















ods pdf close;
ods trace off;






quit;

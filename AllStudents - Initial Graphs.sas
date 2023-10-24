* Andrea Stancescu;
* St 499;
* logistic regression to determine variable importance on career plan (academia vs other);


x "cd C:\Classes\ST 499\SAS Analysis and Regression";
libname ST499 ".";

ods trace on;


*import both of the excel files;
proc import file="C:\Classes\ST 499\SAS Analysis and Regression\All Students Entry Data Words.xlsx" 
            out=ST499.EntryWords 
            dbms=xlsx replace;
  getnames=YES;
run;

data st499.EntryWords(rename=(Satisfied_w_feedback_from_adviso = advfeed
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
  set st499.EntryWords;
  if career_plans = 'Job in academia' then career_plans = '1. Job in academia';
  if career_plans = 'Postdoc then job in academia' then career_plans = '2. Postdoc then job in academia';
  if career_plans = 'Job in industry or govt' then career_plans = '3. Job in industry or govt';
  if career_plans = 'Postdoc then job in industry or govt' then career_plans = '4. Postdoc then job in industry/gvt';
  if career_plans = 'Job in industry then in academia' then career_plans = '5. Job in industry then in academia';
  if career_plans = 'Other' then career_plans = '6. Other';
  *if career_plans in ('Job in academia', 'Postdoc then job in academia') then career_plans='Academia';
  *if career_plans in ('Job in industry or govt', 'Postdoc then job in industry or govt') then career_plans='Industry/Govt';
  *if career_plans in ('Job in industry then in academia', 'Other') then career_plans='Other';
run;

proc sort data=st499.EntryWords(where=(cohort ne 0));
  by Cohort;
run;


proc import file="C:\Classes\ST 499\SAS Analysis and Regression\All Students Exit Data Words.xlsx" 
            out=ST499.ExitWords 
            dbms=xlsx replace;
 getnames=YES;
run;

data st499.ExitWords(rename=(Satisfied_w_feedback_from_adviso = advfeed
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
  set st499.ExitWords;
  if career_plans = 'Job in academia' then career_plans = '1. Job in academia';
  if career_plans = 'Postdoc then job in academia' then career_plans = '2. Postdoc then job in academia';
  if career_plans = 'Job in industry or govt' then career_plans = '3. Job in industry or govt';
  if career_plans = 'Postdoc then job in industry or govt' then career_plans = '4. Postdoc then job in industry/gvt';
  if career_plans = 'Job in industry then in academia' then career_plans = '5. Job in industry then in academia';
  if career_plans = 'Other' then career_plans = '6. Other';
  *if career_plans in ('Job in academia', 'Postdoc then job in academia') then career_plans='Academia';
  *if career_plans in ('Job in industry or govt', 'Postdoc then job in industry or govt') then career_plans='Industry/Govt';
  *if career_plans in ('Job in industry then in academia', 'Other') then career_plans='Other';
run;

proc sort data=st499.ExitWords(where=(cohort ne 0));
  by Cohort;
run;







%macro GenerateFeedbackCharts(outputfile, predictor, xlabel, axisvals);
  ods pdf file=&outputfile;

  %macro GenerateFeedbackTablesAndGraphs(data, outputfreq, charttitle);
    ods output CrossTabFreqs=&outputfreq;
	title &charttitle;
    proc freq data=&data;
      by cohort;
      tables &predictor*career_plans;
    run;
	title;

	data &outputfreq;
	  set &outputfreq;
	  percent = percent / 100;
	  format Percent PERCENT5.;
	run;

	ods graphic on;
    proc sgplot data=&outputfreq;
	  styleattrs datacolors = (cxb2182b cxef8a62 cxfddbc7 cxd1e5f0 cx67a9cf cx2166ac);
      by cohort;
      vbar &predictor / group=career_plans response=percent 
                     seglabel
                     datalabel
                     DATALABELATTRS=(Size=8);
      xaxis values=(&axisvals)
            label= &xlabel;
      yaxis label='Percent'
            grid;
      title &charttitle;
    run;
  %mend;

  %GenerateFeedbackTablesAndGraphs(st499.entrywords, st499.entryfreq, 'Entry: ' &xlabel);
  %GenerateFeedbackTablesAndGraphs(st499.exitwords, st499.exitfreq, 'Exit: ' &xlabel);

  ods output close;
  ods pdf close;
%mend;

%GenerateFeedbackCharts('AdvisorFeedbackTablesGraphs.pdf', advfeed, 'Rate your satisfaction with feedback from your advisor', 'Strongly agree' 'Agree' 'Neither agree nor disagree' 'Disagree' 'Strongly disagree');
%GenerateFeedbackCharts('AdvisorOpinionTablesGraphs.pdf', advopn, 'Do you agree that your advisor respects your opinions?', 'Strongly agree' 'Agree' 'Neither agree nor disagree' 'Disagree' 'Strongly disagree');
%GenerateFeedbackCharts('AdvisorSafetyTablesGraphs.pdf', advfeel, 'Do you feel safe voicing feelings to your advisor', 'Strongly agree' 'Agree' 'Neither agree nor disagree' 'Disagree' 'Strongly disagree');
%GenerateFeedbackCharts('AdvisorRelationshipTablesGraphs.pdf', advrel, 'Rate your relationship with your advisor', 'Excellent' 'Good' 'Fair' 'Satisfactory' 'Poor' 'Not applicable');
%GenerateFeedbackCharts('DepartmentWeclomingTablesGraphs.pdf', depwelc, 'Do you agree that your department is welcoming?', 'Strongly agree' 'Agree' 'Neither agree nor disagree' 'Disagree' 'Strongly disagree');
%GenerateFeedbackCharts('DepartmentDiversityTablesGraphs.pdf', depdiv, 'Do you agree that your department emphasizes the importance of diversity?', 'Strongly agree' 'Agree' 'Neither agree nor disagree' 'Disagree' 'Strongly disagree');
%GenerateFeedbackCharts('TimeinProgramTablesGraphs.pdf', TimeinProgram, 'How much time have you spent in your program?', '3 years or less' '>3 years');


















/*
ods pdf file='AdvisorFeedbackTablesGraphs.pdf';


ods output CrossTabFreqs=st499.entryfreq;
proc freq data=st499.entrywords;
  by cohort;
  tables advfeed*career_plans;
run;


proc sgplot data=st499.entryfreq ;
  by cohort;
  vbar advfeed / group=career_plans response=percent 
                 seglabel
                 datalabel
                 DATALABELATTRS=(Size=8); * stat=freq to get count or stat=percent to get relative frequency;
  xaxis values=('Strongly agree' 'Agree' 'Neither agree nor disagree' 'Disagree' 'Strongly disagree' )
        label= 'Rate your satisfaction with feedback from your advisor';
  yaxis label='Percent'
        grid ;
  title 'Entry: Satisfied with Advisor Feedback by Career Plan';
run;




ods output CrossTabFreqs=st499.exitfreq;
proc freq data=st499.exitwords;
  by cohort;
  tables advfeed*career_plans;
run;


proc sgplot data=st499.exitfreq ;
  by cohort;
  vbar advfeed / group=career_plans response=percent 
                 seglabel
                 datalabel
                 DATALABELATTRS=(Size=8); * stat=freq to get count or stat=percent to get relative frequency;
  xaxis values=('Strongly agree' 'Agree' 'Neither agree nor disagree' 'Disagree' 'Strongly disagree' )
        label= 'Rate your satisfaction with feedback from your advisor';
  yaxis label='Percent'
        grid ;
  title 'Exit: Satisfied with Advisor Feedback by Career Plan';
run;




ods output close;
ods pdf close;


*/

quit;

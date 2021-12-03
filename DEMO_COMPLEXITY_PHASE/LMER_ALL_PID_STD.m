function LMER_ALL_PID_STD
% Function to prepare the regression table for Linear Mixed-Effects Regression Model
% in R
% The metric variables are Zscored here
%
% Fran Hancock
% Dec 2021
% fran.hancock@kcl.ac.uk
%
%
% Function to investigate the relationships between time varying measures
% of CHI OCC HC and PID and the random effect of RUN
% 
%
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
%

Smax=5;
Rmax=4;
% speed_state=input('Which speed state');
% metric_state=input('which metric state');
n_subjects=20;
n_rows=5;
n_cols=2;


PAR='AAL116';
Cmax=Smax-1;

for run=1:Rmax
    P(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_FOR_stats'],'P'));
    LT(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_FOR_stats'],'LT'));
      
end


load AAL116_IPC_MODE_GStats_R2R3 % load MEAN_xxx

% TAU
% TAU - values of PHID
% TAU_TS - PHID at different integration timescales 1-700
% TAU_Tscale - Imtescale corresponing to max PHID for a subject
%
TAU=struct2array(load('TAU','TAU'));

%
% Prepare an array for the results
%
OCC(:,:,:)=P(:,1:n_subjects,Cmax,1);
DWELL(:,:)=LT(:,1:n_subjects,Cmax,1);

RUN1=repmat('RUN1' ,n_subjects,1);
RUN2=repmat('RUN2' ,n_subjects,1);
RUN3=repmat('RUN3' ,n_subjects,1);
RUN4=repmat('RUN4' ,n_subjects,1);

RUN=cat(1,RUN1,RUN2,RUN3,RUN4);

%
% Standardize the variables for each run
%
ZCHI=zscore(GLOBAL_CHI,0,2);
ZOCC=zscore(OCC,0,2);
ZDWELL=zscore(DWELL,0,2);
ZCENT=zscore(CENTROPY,0,2);
ZTAU=zscore(TAU,0,2);
ZMETA=zscore(MEAN_META,0,2);
ZSYNC=zscore(MEAN_SYNC,0,2);
ZSPEED=zscore(MEAN_SPEED,0,2);
ZPCC=zscore(GLOBAL_PCC,0,2);

CHI=reshape(ZCHI',[],1);
OCC=reshape(ZOCC',[],1);
DWELL=reshape(ZDWELL',[],1);
CENT=reshape(ZCENT',[],1);
TAU=reshape(ZTAU',[],1);
META=reshape(ZMETA',[],1);
SYNC=reshape(ZSYNC',[],1);
SPEED=reshape(ZSPEED',[],1);
PCC=reshape(ZPCC',[],1);

data_labels={ 'RUN','CHI', 'OCC','CENTROPY', 'DUR','META','SYNC','SPEED','PCC','PID'};
%
% Set up the regression table

regtable=table('Size',[Rmax*n_subjects numel(data_labels)],'VariableTypes',{'categorical','double','double','double','double','double','double','double','double','double'},'VariableNames',data_labels);
regtable.RUN=RUN;
regtable.CHI=CHI;
regtable.OCC=OCC;
regtable.CENTROPY=CENT;
regtable.PID=TAU;  
regtable.DUR=DWELL;
regtable.META=META;
regtable.SYNC=SYNC;
regtable.SPEED=SPEED;
regtable.PCC=PCC;

%
% Save the regression table for processing in R
%
writetable(regtable,['Regtable_STD.xlsx'])

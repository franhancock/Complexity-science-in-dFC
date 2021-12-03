function ANOVA_RM_Metrics_across_scans
%
% Function to compute repeated means ANOVA across all 4 scans in 3 parcellations
%
%
% Fran Hancock
% July 2021
% fran.hancock@kcl.ac.uk
%
%
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
% NOTE for BOXPLOT
%
% Set the position immediately after figure to get
% equally spaced boxes. Set height for CHI to make sure orders of magnitude differences
% do no make the boxes shorter
% set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
%
%

Smax=5;
Cmax=Smax-1;
N_subjects=20;

n_rows=6;
n_cols=5;

scan_labels={'Run1','Run2','Run3', 'Run4'};
state_labels={'\Phi_1','\Phi_2','\Phi_3', '\Phi_4', '\Phi_5'};
Rmax=4;


PAR='AAL116';
Parcellation =1;

for run=1:Rmax
    P(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_for_stats'], 'P'));
    LT(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_for_stats'], 'LT'));    
    META(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'RSN_META_ALL'));
    SYNC(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'RSN_SYNC_ALL'));
    MEAN_SPEED(run,:,:,:)=struct2array(load([PAR '_IPC_STATES_RUN' num2str(run)],'MEAN_SPEED'));
end

P5(:,:,:)=squeeze(P(:,:,Cmax,1:Smax));
LT5(:,:,:)=squeeze(LT(:,:,Cmax,1:Smax));
MEAN_SPEED5(:,:,:)=squeeze(MEAN_SPEED(:,:,Cmax,:));
META5(:,:,:)=squeeze(META(:,:,:,Cmax));
SYNC5(:,:,:)=squeeze(SYNC(:,:,:,Cmax));

%
% AAL116 - Now flip the rows for runs 2 and 4

P5(1,:,[4 5])=P5(1,:,[5 4]);
P5(3,:,[2 3])=P5(3,:,[3 2]);
P5(3,:,[4 5])=P5(3,:,[5 4]);

LT5(1,:,[4 5])=LT5(1,:,[5 4]);
LT5(3,:,[2 3])=LT5(3,:,[3 2]);
LT5(3,:,[4 5])=LT5(3,:,[5 4]);

MEAN_SPEED5(1,:,[4 5])=MEAN_SPEED5(1,:,[5 4]);
MEAN_SPEED5(3,:,[2 3])=MEAN_SPEED5(3,:,[3 2]);
MEAN_SPEED5(3,:,[4 5])=MEAN_SPEED5(4,:,[5 4]);


META5(1,:,[4 5])=META5(1,:,[5 4]);
META5(3,:,[2 3])=META5(3,:,[3 2]);
META5(3,:,[4 5])=META5(3,:,[5 4]);

SYNC5(1,:,[4 5])=SYNC5(1,:,[5 4]);
SYNC5(3,:,[2 3])=SYNC5(3,:,[3 2]);
SYNC5(3,:,[4 5])=SYNC5(3,:,[5 4]);

P=P5;
LT=LT5;
MEAN_SPEED=MEAN_SPEED5;
META=META5;
SYNC=SYNC5;


withinDsgn=table((1:4)','VariableNames',{'scan_labels'});

for s=1:Smax

    HistData=[P(:,:,s)]';
    
    t=table(HistData(:,1),HistData(:,2),HistData(:,3),HistData(:,4),'VariableNames',scan_labels);
%    withinDsgn=table((1:4)','VariableNames',{'scan_labels'});
    rm=fitrm(t,'Run1-Run4~1','WithinDesign',withinDsgn);
    spher_tbl=mauchly(rm);
    
    ran_tbl=ranova(rm);
    stats(1,s,1)=ran_tbl.DF(1);
    stats(1,s,2)=ran_tbl.DF(2);
    stats(1,s,3)=ran_tbl.F(1);

    if spher_tbl.pValue<0.05 % sphericity test failed - need to correct
        stats(1,s,4)=ran_tbl.pValueGG(1);
    else
        stats(1,s,4)=ran_tbl.pValue(1);            
    end
    
    stats(1,s,5)=spher_tbl.pValue(1);

end

for s=1:Smax

    HistData=[LT(:,:,s)]';
    
    t=table(HistData(:,1),HistData(:,2),HistData(:,3),HistData(:,4),'VariableNames',scan_labels);
    rm=fitrm(t,'Run1-Run4~1','WithinDesign',withinDsgn);
    spher_tbl=mauchly(rm);
    
    ran_tbl=ranova(rm);
    stats(2,s,1)=ran_tbl.DF(1);
    stats(2,s,2)=ran_tbl.DF(2);
    stats(2,s,3)=ran_tbl.F(1);

    if spher_tbl.pValue<0.05 % sphericity test failed - need to correct
        stats(2,s,4)=ran_tbl.pValueGG(1);
    else
        stats(2,s,4)=ran_tbl.pValue(1);            
    end
    
    stats(2,s,5)=spher_tbl.pValue(1);
    
end

 for s=1:Smax
    
    HistData=[META(:,:,s)]';           
    
    t=table(HistData(:,1),HistData(:,2),HistData(:,3),HistData(:,4),'VariableNames',scan_labels);
    rm=fitrm(t,'Run1-Run4~1','WithinDesign',withinDsgn);
    spher_tbl=mauchly(rm);
    
    ran_tbl=ranova(rm);
    stats(3,s,1)=ran_tbl.DF(1);
    stats(3,s,2)=ran_tbl.DF(2);
    stats(3,s,3)=ran_tbl.F(1);

    if spher_tbl.pValue<0.05 % sphericity test failed - need to correct
        stats(3,s,4)=ran_tbl.pValueGG(1);
    else
        stats(3,s,4)=ran_tbl.pValue(1);            
    end
    
    stats(3,s,5)=spher_tbl.pValue(1);


end

for s=1:Smax
    
    HistData=[SYNC(:,:,s)]';
   
    t=table(HistData(:,1),HistData(:,2),HistData(:,3),HistData(:,4),'VariableNames',scan_labels);
    rm=fitrm(t,'Run1-Run4~1','WithinDesign',withinDsgn);
    spher_tbl=mauchly(rm);
    
    ran_tbl=ranova(rm);
    stats(4,s,1)=ran_tbl.DF(1);
    stats(4,s,2)=ran_tbl.DF(2);
    stats(4,s,3)=ran_tbl.F(1);

    if spher_tbl.pValue<0.05 % sphericity test failed - need to correct
        stats(4,s,4)=ran_tbl.pValueGG(1);
    else
        stats(4,s,4)=ran_tbl.pValue(1);            
    end
    
    stats(4,s,5)=spher_tbl.pValue(1);
end

for s=1:Smax
    
    HistData=[MEAN_SPEED(:,:,s)]'; 
    
    t=table(HistData(:,1),HistData(:,2),HistData(:,3),HistData(:,4),'VariableNames',scan_labels);
    rm=fitrm(t,'Run1-Run4~1','WithinDesign',withinDsgn);
    spher_tbl=mauchly(rm);
    
    ran_tbl=ranova(rm);
    stats(5,s,1)=ran_tbl.DF(1);
    stats(5,s,2)=ran_tbl.DF(2);
    stats(5,s,3)=ran_tbl.F(1);

    if spher_tbl.pValue<0.05 % sphericity test failed - need to correct
        stats(5,s,4)=ran_tbl.pValueGG(1);
    else
        stats(5,s,4)=ran_tbl.pValue(1);            
    end
    
    stats(5,s,5)=spher_tbl.pValue(1);

    
end
save([PAR '_RANOVA_STATES'], 'stats')






    
    


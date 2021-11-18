function Compare_Mode_metrics
%
% Function to Compare the probabilities for all metric between all runs
% for 5 modes
% 
%
% Original Code
% Joana Cabral 
% 
% Adapted for test-retest study
% Fran Hancock
% July 2021
% fran.hancock@kcl.ac.uk
%
% For AAL116
% The order of the modes may differ with different number of subjects.
% Use figure 1. to sort the modes
% Reorder the MODES in runs 1 and 3 to match the order in 2 and 4
%
% Run 1: 1 2 3 5 4
% Run 2: 1 3 2 4 5
% Run 3: 1 3 2 5 4
% Run 4: 1 2 3 4 5
%
% NOTE: We do include Typical Speed calculations for this DEMO due to the
% size of the dPL matrices
%%%%%%%

global PAR
Smax=5;
Cmax=Smax-1;
Rmax=4; % number of runs

for run=1:Rmax
    P(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_for_stats'], 'P'));
    LT(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_for_stats'], 'LT'));    
    META(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'RSN_META_ALL'));
    SYNC(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'RSN_SYNC_ALL'));
 
end

P5(:,:,:)=squeeze(P(:,:,Cmax,1:Smax));
LT5(:,:,:)=squeeze(LT(:,:,Cmax,1:Smax));
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

META5(1,:,[4 5])=META5(1,:,[5 4]);
META5(3,:,[2 3])=META5(3,:,[3 2]);
META5(3,:,[4 5])=META5(3,:,[5 4]);

SYNC5(1,:,[4 5])=SYNC5(1,:,[5 4]);
SYNC5(3,:,[2 3])=SYNC5(3,:,[3 2]);
SYNC5(3,:,[4 5])=SYNC5(3,:,[5 4]);

P=P5;
LT=LT5;
META=META5;
SYNC=SYNC5;


P_pval=zeros(1);
LT_pval=zeros(1);

for r=1:Rmax+2  % 6 combinations

    switch r
        case 1
            c1=1;
            c2=2;
        case 2
            c1=1;
            c2=3;
        case 3
            c1=1;
            c2=4;
        case 4
            c1=2;
            c2=3;
        case 5
            c1=2;
            c2=4;
        case 6
            c1=3;
            c2=4;
    end

    disp(['Test Run' num2str(c1) ' and ' num2str(c2)])   

    for s=1:Smax

        % Compare Probabilities
        a=squeeze(P(c1,:,s));  
        b=squeeze(P(c2,:,s));  
        stats=permutation_htest_np_paired([a,b],[ones(1,numel(a)) 2*ones(1,numel(b))],1000,0.05,'ttest');
        P_pval(Cmax,s)=min(stats.pvals);

        % Compare Lifetimes
        a=squeeze(LT(c1,:,s)); 
        b=squeeze(LT(c2,:,s));  
        stats=permutation_htest_np_paired([a,b],[ones(1,numel(a)) 2*ones(1,numel(b))],1000,0.05,'ttest');
        LT_pval(Cmax,s)=min(stats.pvals);       

        % Compare META
        a=squeeze(META(c1,:,s));  
        b=squeeze(META(c2,:,s));  
        stats=permutation_htest_np_paired([a,b],[ones(1,numel(a)) 2*ones(1,numel(b))],1000,0.05,'ttest');
        META_pval(Cmax,s)=min(stats.pvals);            

        % Compare SYNC
        a=squeeze(SYNC(c1,:,s));  
        b=squeeze(SYNC(c2,:,s));  
        stats=permutation_htest_np_paired([a,b],[ones(1,numel(a)) 2*ones(1,numel(b))],1000,0.05,'ttest');
        SYNC_pval(Cmax,s)=min(stats.pvals);            

    end
    save([PAR '_IPC_MODE_Stats_R' num2str(c1) 'R' num2str(c2)], 'P_pval', 'LT_pval', 'META_pval', 'SYNC_pval',...
        'P','LT','META','SYNC')
end    

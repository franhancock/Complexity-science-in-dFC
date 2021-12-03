function Compare_Global_metrics
%
% Function to Compare the probabilities for all metric at a COHORT level
% across 4 runs and 5 modes
%
% META, SYNC,CHI,PHASE are mean values across n states
% MEAN_SPEED is across the complete system (state independent) 
% CENTROPY is the sum of the coalition entropies across n states
%
% GLOBAL SYNC needs to be the values' for the global mode
% in accordance with Wilde and Shanahan 2012
%
% Fran Hancock
% Sept 2021
% fran.hancock@kcl.ac.uk
%
%%%%%%%%%%%%%%%%%%%%%%%

Smax=5;
Cmax=Smax-1;
Rmax=4; % number of runs
n_subs=20;
PAR='AAL116';

for run=1:Rmax
    P(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_for_stats'], 'P'));
    LT(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_for_stats'], 'LT'));
    
    META(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'RSN_META_ALL'));
    SYNC(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'RSN_SYNC_ALL'));
    GLOBAL_CHI(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'GLOBAL_CHI'));
    CENTROPY(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'GLOBAL_CE'));
    GLOBAL_PCC(run,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'GLOBAL_PCC'));
    MEAN_SPEED(run,:,:,:)=struct2array(load([PAR '_IPC_RW_ALL_R' num2str(run)], 'GLOBAL_MEAN_SPEED'));
end


% Calculate the COHORT statistics - just mean and SEM

C_P(1:4,1:Smax)=mean(P(1:4,:,Cmax,1:Smax),2); % Cohort mean OCC
C_LT(1:4,1:Smax)=mean(LT(1:4,:,Cmax,1:Smax),2);

MEAN_META(1:4,:)=mean(META(1:4,:,:,Cmax),3);    % Calculate the mean meta for each subject
C_META(1:4)=mean(MEAN_META(1:4,:),2);
MEAN_SYNC(1:4,:)=mean(SYNC(1:4,:,1,Cmax),3);    % Calculate the mean SYNC for GLOBAL mode each subject 23.10.21
C_SYNC(1:4)=mean(MEAN_SYNC(1:4),2);
C_SPEED(1:4,:)=mean(MEAN_SPEED(1:4,:),2);

C_PCC(1:4,:)=mean(GLOBAL_PCC,2);
C_CENTROPY(1:4,:)=mean(CENTROPY,2);
C_CHI(1:4,:)=mean(GLOBAL_CHI,2);

TAU=struct2array(load('TAU'));
C_TAU(1:4,:)=mean(TAU,2);

for r=1:Rmax
    C_P_SEM(r,1:Smax)=std(squeeze(P(r,:,Cmax,1:Smax)),1)/sqrt(n_subs);
    C_LT_SEM(r,1:Smax)=std(squeeze(LT(r,:,Cmax,1:Smax)),1)/sqrt(n_subs);
    C_META_SEM(r,:)=std(MEAN_META(r,:))/sqrt(n_subs);
    C_SYNC_SEM(r,:)=std(MEAN_SYNC(r,:))/sqrt(n_subs);
    C_CHI_SEM(r,:)=std(GLOBAL_CHI(r,:))/sqrt(n_subs);
    C_PCC_SEM(r,:)=std(GLOBAL_PCC(r,:))/sqrt(n_subs);
    C_SPEED_SEM(r,:)=std(MEAN_SPEED(r,:))/sqrt(n_subs);
    C_CENTROPY_SEM(r,:)=std(CENTROPY(r,:))/sqrt(n_subs);
    C_TAU_SEM(r,:)=std(TAU(r,:))/sqrt(n_subs);
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for run=1:Rmax+2  % 6 combinations

    switch run
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

    disp(['Test Run INDIVIDUAL' num2str(c1) ' and ' num2str(c2)])   

  
        for s=1:Smax
            % Compare Probabilities
            a=squeeze(P(c1,:,Cmax,s));  
            b=squeeze(P(c2,:,Cmax,s));  
            stats=permutation_htest_np_paired([a,b],[ones(1,numel(a)) 2*ones(1,numel(b))],1000,0.05,'ttest');
            P_pval(Cmax,s)=min(stats.pvals);

            % Compare Lifetimes
            a=squeeze(LT(c1,:,Cmax,s)); 
            b=squeeze(LT(c2,:,Cmax,s));  
            stats=permutation_htest_np_paired([a,b],[ones(1,numel(a)) 2*ones(1,numel(b))],1000,0.05,'ttest');
            LT_pval(Cmax,s)=min(stats.pvals);       
        end
        % Compare META
        a=squeeze(MEAN_META(c1,:));  
        b=squeeze(MEAN_META(c2,:));  
        stats=permutation_htest_np_paired([a,b],[ones(1,numel(a)) 2*ones(1,numel(b))],1000,0.05,'ttest');
        META_pval=min(stats.pvals);            

        % Compare SYNC
        a=squeeze(MEAN_SYNC(c1,:));  
        b=squeeze(MEAN_SYNC(c2,:));  
        stats=permutation_htest_np_paired([a,b],[ones(1,numel(a)) 2*ones(1,numel(b))],1000,0.05,'ttest');
        SYNC_pval=min(stats.pvals);            

        % Compare CHI
        a=squeeze(GLOBAL_CHI(c1,:)); 
        b=squeeze(GLOBAL_CHI(c2,:)); 
        stats=permutation_htest_np_paired([a,b],[ones(1,numel(a)) 2*ones(1,numel(b))],1000,0.05,'ttest');
        CHI_pval=min(stats.pvals);     

        % Compare TYP SPEED
        a=squeeze(MEAN_SPEED(c1,:));  
        b=squeeze(MEAN_SPEED(c2,:)); 
        stats=permutation_htest_np_paired([a,b],[ones(1,numel(a)) 2*ones(1,numel(b))],1000,0.05,'ttest');
        MEAN_SPEED_pval=min(stats.pvals);            

        % Compare PCC
        a=squeeze(GLOBAL_PCC(c1,:)); 
        b=squeeze(GLOBAL_PCC(c2,:)); 
        stats=permutation_htest_np_paired([a,b],[ones(1,numel(a)) 2*ones(1,numel(b))],1000,0.05,'ttest');
        PCC_pval=min(stats.pvals);            

        % Compare CENTROPY
        a=squeeze(CENTROPY(c1,:)); 
        b=squeeze(CENTROPY(c2,:)); 
        stats=permutation_htest_np_paired([a,b],[ones(1,numel(a)) 2*ones(1,numel(b))],1000,0.05,'ttest');
        CENTROPY_pval=min(stats.pvals);            

        % Compare PHI-D 
        a=squeeze(TAU(c1,:)); 
        b=squeeze(TAU(c2,:)); 
        stats=permutation_htest_np_paired([a,b],[ones(1,numel(a)) 2*ones(1,numel(b))],1000,0.05,'ttest');
        TAU_pval=min(stats.pvals);            

    save([PAR '_IPC_MODE_GStats_R' num2str(c1) 'R' num2str(c2)], 'P_pval','LT_pval','META_pval', 'SYNC_pval', 'CHI_pval','MEAN_SPEED_pval', 'PCC_pval','CENTROPY_pval','TAU_pval',...
       'CENTROPY','MEAN_META','MEAN_SYNC','GLOBAL_CHI','MEAN_SPEED','GLOBAL_PCC', ...
       'C_P_SEM','C_LT_SEM','C_META', 'C_META_SEM', 'C_SYNC', 'C_SYNC_SEM','C_CHI','C_CHI_SEM','C_TAU','C_TAU_SEM','C_PCC','C_PCC_SEM','C_CENTROPY','C_CENTROPY_SEM','C_SPEED','C_SPEED_SEM') 
end    

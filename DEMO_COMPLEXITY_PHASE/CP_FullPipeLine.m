%%
% METHODS pipeline DEMO
%
%
% Fran Hancock
% November 2021
% fran.hancock@kcl.ac.uk
%
% All code to run the complete pipeline is available
% Random Walk and DFA analysis are available from their authors on Github
% 
% In this DEMO we used AAL parcelleated data from 20 HCPU100 subjects
% 
% We also use the AAL116 centroids represented in 10mm voxelspace for figure 1 as
% generating the Eignevectors in 10mm space requires significant
% computational resources
%
%
findpath=which('CP_FullPipeLine');
findpath=findpath(1:end-18);
mypath=findpath;    % set path to the code folder

status=mkdir('Figures');
%
% Set up the paths to the functions, libraries etc
%
%
addpath( genpath(mypath))
savepath /Users/HDF/Documents/MATLAB/pathdef.m

%
% set up the directories for the HCP nifti and the parcellated data
%
global HCP_MAT_DATA PAR;
HCP_MAT_DATA='HCPU100_20_MAT;
PAR='AAL116';

%%
%% BASIC LEiDA ANALYSIS
%%
%% 1 parcellate the data (parcellated data for 20 subjects in 4 runs provided)
%Parcellate 

%% 2 compute the leading eigenvectors
%LEiDA_data

%% 3. Cluster the eigenvectors
%LEiDA_cluster

%% 4. Compute duration and occurrence
%LEiDA_for_stats

%%
%% REPRESENT SPATIAL MODES IN 10mm voxel space
%%
%% 5. Get the LEiDA centroids in 10mm voxel space (we use this code to represent the AAL116 centroids in 10mm voxel space) Centroids are provided
% EigenVectors_10mmVoxelSpace 
% ViewEigenModes_from_LEiDA
 % get_centroids_LEiDA

%% 6. Make fig 1 (This requires a LOT of computational resources for the graphical representation. We supply fig1 for this dataset for reference)
%make_fig1

%%
%% EVALUATE RELIABILITY OF MODES
%%
%% 7. Compute ICC for 5 modes
%LEiDA_reliability

%%
%% COMPUTE THE METRICS
%%
%% 8. Compute phase synchrony metrics
 %Phase_sync_metrics

%% 9. Compute and save IPC FC matrices for dFC walk analysis
% Compute_IPC

%% 10. Calcuate the global reconfiguration speeed
%LEiDA_RW_GLOBAL

%% 11. Calculate mode reconfiguration speed
%LEiDA_RW_states

%% 12. Calculate DFA
% DFA_IPC

%% 13:Plot DFA results
% plot_Speed_DFA_AAL116_results

%% 14. Compute and plot random walk for a subject
% compute_random_walk

%% 15. Compute Integrated Information (Request PHhiID code from Pedro Mediano - TAU.mat provided should code be not available)
%Compute_PHI

%%
%% EVALUATE RELIABILTIY OF METRICS
%%
%% 16. Compare the reproducibility of metrics across runs
% Compare_Global_metrics

%% 17. Plot metric reliabilites
 % Bar_plot_metrics

 %% 18. Compare the mode-specific metrics (Permutation testing)
 % Compare_Mode_metrics

%% 19. Run repeared measures ANOVA on mode metrics acros 4 runs (ANOVA testing)
% ANOVA_RM_Metrics this needs to be independent ANOVA

%% 20. Extract significant differences (Output goes to screen and is also saved in AAL116_SIG_STATES_RM)
%Sig_RAnova_Metrics

%% 21. Plot mode-specific metric reliabilities
% Bar_plot_Mode_metrics

%%
%% Investigate relationships between the metrics
%%
%% 22. Spearman correlation between the metrics
 % Spearman_Corr (this code saves the data for corr_plot in R)

%% 23. Perform Linear Mixed Effect Regression (this code prepares the Regression table for processing in R)
 % LMER_ALL_PID_STD

%%
%% Plot time-varying metrics for any subject
%%
%% 24. Sample time-varying metrics single subject
LEiDA_TV_METRICS

 clear global HCP_MAT_DATA PAR








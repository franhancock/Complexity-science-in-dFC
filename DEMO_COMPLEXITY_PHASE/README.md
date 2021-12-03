# Complexity-science-in-dFC
Code to compute, assess, and plot dFC Metrics described in 'Metastability, fractal scaling, and synergistic information processing: what phase relationships reveal about intrinsic fMRI resting-state brain activity '

*******SYSTEM REQUIREMENTS:
MATLAB 2021b
spm12 (please download spm12 from here: https://www.fil.ion.ucl.ac.uk/spm/software/download/spmreg.php and set it under the known Matlab paths with Matlab --> Set path --> Add folder with subfolders).

*******INSTALLATION GUIDE:
It will be enough to download the code folder and set the Matlab path to the folder (Matlab --> Set path --> Add folder with subfolders)

*******INSTRUCTIONS FOR USE: 
How to run the software on your data

In CP_FullPipeLine.m 

point HCP_DATA to your post-processed subject nifti files

point HCP_MAT to where you wish to store your subjects' parcellated .mat files


CP_FullPipeLine.m will

%%
%% BASIC LEiDA ANALYSIS
%%
%% 1 parcellate the data (parcellated data for 20 subjects in 4 runs provided)
% Parcellate 

%% 2 compute the leading eigenvectors
LEiDA_data

%% 3. Cluster the eigenvectors
LEiDA_cluster

%% 4. Compute duration and occurrence
LEiDA_for_stats

%%
%% REPRESENT SPATIAL MODES IN 10mm voxel space
%%
%% 5. Get the LEiDA centroids in 10mm voxel space (we use this code to represent the AAL116 centroids in 10mm voxel space) Centroids are provided
  
 % get_centroids_LEiDA

%% 6. Make fig 1 (This requires a LOT of computational resources for the graphical representation. We supply fig1 for this dataset for reference)
make_fig1

%%
%% EVALUATE RELIABILITY OF MODES
%%
%% 7. Compute ICC for 5 modes
LEiDA_reliability

%%
%% COMPUTE THE METRICS
%%
%% 8. Compute phase synchrony metrics
 Phase_sync_metrics

%% 9. Compute and save IPC FC matrices for dFC walk analysis
Compute_IPC

%% 10. Calcuate the global reconfiguration speeed
LEiDA_RW_GLOBAL

%% 11. Calculate mode reconfiguration speed
LEiDA_RW_states

%% 12. Calculate DFA
DFA_IPC

%% 13:Plot DFA results
plot_DFA_AAL116_results

%% 14. Compute and plot random walk for a subject
compute_random_walk

%% 15. Compute Integrated Information (Request PHhiID code from Pedro Mediano)
Compute_PHI

%%
%% EVALUATE RELIABILTIY OF METRICS
%%
%% 16. Compare the reproducibility of metrics across runs
Compare_Global_metrics

%% 17. Plot metric reliabilites
 Bar_plot_metrics

 %% 18. Compare the mode-specific metrics (Permutation testing)
 Compare_Mode_metrics

%% 19. Run repeared measures ANOVA on mode metrics acros 4 runs (ANOVA testing)
ANOVA_RM_Metrics

%% 20. Extract significant differences (Output goes to screen and is also saved in AAL116_SIG_STATES_RM)
Sig_RAnova_Metrics

%% 21. Plot mode-specific metric reliabilities
Bar_plot_Mode_metrics

%%
%% Investigate relationships between the metrics
%%
%% 22. Spearman correlation between the metrics
Spearman_Corr

%% 23. Perform Linear Mixed Effect Regression (this code prepares the Regression table for processing in R)
 LMER_ALL_PID_STD

%%
%% Plot time-varying metrics for any subject
%%
%% 24. Sample time-varying metrics single subject
LEiDA_TV_METRICS
  

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
% We do not include the Random Walk and DFA calculations as the iPL
% matrices required for the calculations are very large
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
HCP_MAT_DATA='HCPU100_20_MAT';
PAR='AAL116';


%% 1 parcellate the data
% Parcellate 

%% 2 compute the leading eigenvectors
 LEiDA_data

%% 3. Cluster the eigenvectors
 LEiDA_cluster

%% 4. Compute duration and occurrence
 LEiDA_for_stats

%% 5. Get the LEiDA centroids in 10mm voxel space (we use this code to represent the AAL116 centroids in 10mm voxel space) Centroids are provided
  
 % get_centroids_LEiDA

%% 6. Make fig 1 (This requires a LOT of computational resources for the graphical representation. We supply fig1 for this dataset for reference)
 make_fig1

%% 7. Compute ICC for 5 modes
LEiDA_reliability

 %% 8. Compute phase synchrony metrics
 Phase_sync_metrics

%% 9. Compute Integrated Information (Request PHhiID code from Pedro Mediano)
 Compute_PHI

%% 10. Compare the reproducibility of metrics across scans
 Compare_Global_metrics

%% 11. Plot metric reliabilites
 Bar_plot_metrics

 %% 12. Compare the mode-specific metrics
Compare_Mode_metrics

%% 13. Plot mode-specific metric reliabilities
Bar_plot_Mode_metrics

%% 14. Perform Stepwise regression
PLOT_Step_Regression

%% 15. Run regression
Plot_Regression

%% 16. Sample time-varying metrics single subject
 LEiDA_TV_METRICS

 clear global HCP_MAT_DATA PAR








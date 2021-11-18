# Complexity-science-in-dFC
Code to compute, assess, and plot dFC Metrics described in 'Metastability, fractal scaling, and synergistic information processing: what phase relationships reveal about intrinsic fMRI resting-state brain activity '.
Demo code including processed data from 20 HCPU100 subjects in 4 runs.

*******SYSTEM REQUIREMENTS:
MATLAB 2021b
spm12 (please download spm12 from here: https://www.fil.ion.ucl.ac.uk/spm/software/download/spmreg.php and set it under the known Matlab paths with Matlab --> Set path --> Add folder with subfolders).

*******INSTALLATION GUIDE:
It will be enough to download the DEMO_COMPLEXITY_PHASE folder and set the Matlab path to the folder (Matlab --> Set path --> Add folder with subfolders)

*******INSTRUCTIONS FOR USE: 
How to run the software on your data

*******DEMO
In CP_FullPipeLine.m 

point HCP_DATA to your post-processed subject nifti files

point HCP_MAT to where you wish to store your subjects' parcellated .mat files


CP_FullPipeLine.m will

%% 1 parcellate the data (We have performed this for 20 HCPU100 subjects in 4 runs)
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

  

# Complexity-science-in-dFC
Code to compute, assess, and plot dFC Metrics described in 'Metastability, fractal scaling, and synergistic information processing: what phase relationships reveal about intrinsic fMRI resting-state brain activity '

*******SYSTEM REQUIREMENTS:
MATLAB 2021b

*******INSTALLATION GUIDE:
It will be enough to download the code folder and set the Matlab path to the folder (Matlab --> Set path --> Add folder with subfolders)

*******INSTRUCTIONS FOR USE: How to run the software on your data
In CP_FullPipeLine.m 
  point HCP_DATA to your post-processed subject nifti files
  point HCP_MAT to where you wish to store your subjects' parcellated .mat files

CP_FullPipeLine.m will

%% 1 parcellate the data
% Parcellate

%% 2 compute the leading eigenvectors
% LEiDA_data

%% 3. Cluster the eigenvectors
% LEiDA_cluster

%% 4. Compute duration and occurrence
% LEiDA_for_stats

%% 5. Get the LEiDA centroids in 10mm voxel space
% get_centroids_LEiDA

%% 6. Make fig 1
% make_fig1

%% 7. Compute phase synchrony metrics
% Phase_sync_metrics

%% 8. Compute Integrated Information
% Compute_PHI

%% 9. Compare the reproducibility of metrics across scans
% Compare_Global_metrics

%% 10. Plot metric reliabilites
% Bar_plot_metrics

%% 11. Run regression

% Plot_Regression

%% 12. Sample time-varying metrics single subject

% LEiDA_TV_METRICS
  

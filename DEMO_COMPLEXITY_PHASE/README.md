## Complexity-science-in-dFC
Code to compute, assess, and plot dFC Metrics described in 'Metastability, fractal scaling, and synergistic information processing: what phase relationships reveal about intrinsic fMRI resting-state brain activity '

*******SYSTEM REQUIREMENTS:
MATLAB 2021b
spm12 (please download spm12 from here: https://www.fil.ion.ucl.ac.uk/spm/software/download/spmreg.php and set it under the known Matlab paths with Matlab --> Set path --> Add folder with subfolders).
RStudio

*******INSTALLATION GUIDE:
It will be enough to download the code folder and set the Matlab path to the folder (Matlab --> Set path --> Add folder with subfolders)

*******INSTRUCTIONS FOR USE: 
How to run the software on your data

In CP_FullPipeLine.m 
* point HCP_DATA to your post-processed subject nifti files
* point HCP_MAT to where you wish to store your subjects' parcellated .mat files


CP_FullPipeLine.m will


**BASIC LEiDA ANALYSIS**

1. Parcellate the data (parcellated data for 20 subjects in 4 runs provided)
_Parcellate_ 

2. Compute the leading eigenvectors
_LEiDA_data_

3. Cluster the eigenvectors
_LEiDA_cluster_

4. Compute duration and occurrence
_LEiDA_for_stats_

**REPRESENT SPATIAL MODES IN 10mm voxel space**

5. Get the LEiDA centroids in 10mm voxel space (we use this code to represent the AAL116 centroids in 10mm voxel space) Centroids are provided
_get_centroids_LEiDA_

6. Make fig 1 (This requires a **LOT** of computational resources for the graphical representation. We supply fig1 for this dataset for reference)
_make_fig1_


**EVALUATE RELIABILITY OF MODES**

7. Compute ICC for 5 modes
_LEiDA_reliability_

**COMPUTE THE METRICS**

8. Compute phase synchrony metrics
_Phase_sync_metrics_

9. Compute and save IPC FC matrices for dFC walk analysis
_Compute_IPC_

10. Calcuate the global reconfiguration speeed
_LEiDA_RW_GLOBAL_

11. Calculate mode reconfiguration speed
_LEiDA_RW_states_

12. Calculate DFA
_DFA_IPC_

13. Plot DFA results
_plot_DFA_AAL116_results_

14. Compute and plot random walk for a subject
_compute_random_walk_

15. Compute Integrated Information (Request PHhiID code from Pedro Mediano)
_Compute_PHI_

**EVALUATE RELIABILTIY OF METRICS**

16. Compare the reproducibility of metrics across runs
_Compare_Global_metrics_

13.a
_plot_Speed_DFA_AAL116_results_

17. Plot metric reliabilites
_Bar_plot_metrics_

 18. Compare the mode-specific metrics (Permutation testing)
 _Compare_Mode_metrics_

19. Run repeared measures ANOVA on mode metrics acros 4 runs (ANOVA testing)
_ANOVA_RM_Metrics_

20. Extract significant differences (Output goes to screen and is also saved in AAL116_SIG_STATES_RM)
_Sig_RAnova_Metrics_

21. Plot mode-specific metric reliabilities
_Bar_plot_Mode_metrics_

**Investigate relationships between the metrics**

22. Spearman correlation between the metrics
_Spearman_Corr_

23. Perform Linear Mixed Effect Regression (this code prepares the Regression table for processing in R)
_LMER_ALL_PID_STD_

**Plot time-varying metrics for any subject**

24. Sample time-varying metrics single subject
_LEiDA_TV_METRICS_
  

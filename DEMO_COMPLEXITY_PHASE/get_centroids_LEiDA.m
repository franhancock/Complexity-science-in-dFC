function get_centroids_LEiDA

%
% Function to get 10mm eigenvectors associated with LAU centroids 
% Centroids
%
%
% Fran Hancock
% May 2021
% fran.hancock@kcl.ac.uk
%
%
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
%

brain_mask_file= 'EigVecs_Vox_all';

PAR='AAL116';

Num_states = 5;
for run=1:4

    switch run
                
        case 1
            load 'RUN1/MODE_RESULTS'; % generated with EigenVectors_10mmVoxelSpace_cluster
            load 'RUN1/Leida_Kmeans_results';
        case 2
            load 'RUN2/MODE_RESULTS'; % generated with EigenVectors_10mmVoxelSpace_cluster
            load 'RUN2/Leida_Kmeans_results';
        case 3
            load 'RUN3/MODE_RESULTS'; % generated with EigenVectors_10mmVoxelSpace_cluster
            load 'RUN3/Leida_Kmeans_results';
        case 4
            load 'RUN4/MODE_RESULTS'; % generated with EigenVectors_10mmVoxelSpace_cluster
            load 'RUN4/Leida_Kmeans_results';
     end


    % First get the mean Eigenvector for each state
    % - Get also the mean variability. The voxels with smaller variability will
    % be the ones that most consistently participate in each state

    load(['SUPPLIED_FILES/' brain_mask_file],'ind_voxels', 'Brain_Mask_low');

    % Mean_Vec=zeros(sz,k);
    Ctime=Kmeans_results{Num_states-1}.IDX;

    for k=1:Num_states
        %	calculate the std and mean of the eigenvectors for each cluster

        Vtps=[Ctime==k];
        Vecs=V1_all(Vtps,:);
        STD_vec(:,k)=std(Vecs,[],1);
        Mean_Vec(:,k)=mean(Vecs,1);
    end

    switch run
        case 1
            disp('Saving run 1')
            save(['RUN1/EigVecs_Vox_RUN1_' PAR  '.mat'],'Mean_Vec','STD_vec')

        case 2
            disp('Saving run 2')
            save(['RUN2/EigVecs_Vox_RUN2_' PAR  '.mat'],'Mean_Vec','STD_vec')

        case 3
            disp('Saving run 3')
            save(['RUN3/EigVecs_Vox_RUN3_' PAR '.mat'],'Mean_Vec','STD_vec')

        case 4
            disp('Saving run 4')
            save(['RUN4/EigVecs_Vox_RUN4_' PAR '.mat'],'Mean_Vec','STD_vec')

    end
    clear V1_all Time_sessions
end


function ViewEigenmodes_from_LEiDA

%
% Function to view the VOX 10mm eigenvectors projected onto the AAL90
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
addpath('/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/', genpath('/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/functions'), '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/static_data','/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/libraries');
savepath /Users/HDF/Documents/MATLAB/pathdef.m
static_path='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/static_data/';

brain_mask_file= 'EigVecs_Vox_all';

PAR='LAU';

Orient=input('Orientation Horizontal (1) or Side (2): ');
disp(' ')



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

    load(brain_mask_file,'ind_voxels', 'Brain_Mask_low');

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
            save(['RUN1/EigVecs_Vox_RUN1_' PAR  '.mat'],'Mean_Vec','STD_vec')

        case 2
            save(['RUN2/EigVecs_Vox_RUN2_' PAR  '.mat'],'Mean_Vec','STD_vec')

        case 3
            save(['RUN3/EigVecs_Vox_RUN3_' PAR '.mat'],'Mean_Vec','STD_vec')

        case 4
            save(['RUN4/EigVecs_Vox_RUN4_' PAR '.mat'],'Mean_Vec','STD_vec')

    end

    % Visualize BOLD phase EigenModes
    % load(['EigVecs_Vox_k' num2str(k) '.mat'],'ind_voxels','Brain_Mask_low')

    State_Volumes=zeros(Num_states,size(Brain_Mask_low,1),size(Brain_Mask_low,2),size(Brain_Mask_low,3)); % needed for anatomical view

    for Cluster=1:Num_states

        V_state=zeros(size(Brain_Mask_low));

        V_state(ind_voxels)=Mean_Vec(:,Cluster);

        State_Volumes(Cluster,:,:,:)=V_state; % needed for anatomical view

        V_state=imresize3(V_state,3);
        lim=max(abs(Mean_Vec(:,Cluster)));

    end

    %% Visualization on cortical slice
    switch Orient
        case 1
            interesting_slices=[120 100 80 40 ];
            plane='horizontal';
        case 2
            interesting_slices=[120 100 80 60 ];
            plane='side';
    end


    structural=niftiread([static_path 'mni.nii.gz']);

    if Orient==1
        plane='horizontal';
        n_rows=numel(interesting_slices);    
    else
        plane='side';
        n_rows=numel(interesting_slices)+2;    
    end

    % Cluster=Num_states;

    n_cols=Num_states*2;


    % Create a panel so that you can put a title on top that does not
    % overlap with the subplot titles sgtitle overlaps
    % 
    
    f = figure;
    p = uipanel('Parent',f,'BorderType','none'); 
    p.Title = (['                                                                                 ' PAR ' Independent Scan ' num2str(run) ' states projected into VOX10 Space'  ]);
    p.FontSize=24;
    p.FontWeight='bold';
    p.TitlePosition = 'lefttop';    
    p.FontWeight = 'bold';
    
    CL_idx=1;

    for Cluster=1:Num_states



        % colormap(jet)

        V_state=squeeze(State_Volumes(Cluster,:,:,:));

        V_state=imresize3(V_state,size(structural));
        lim=max(abs(Mean_Vec(:,Cluster)));

        slice=1;
        
        for slice_to_plot=interesting_slices

            % First plot the Anatomical Image underneath
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            subplot(n_rows,n_cols, (slice-1)*n_cols +CL_idx,'Parent',p)

            ax1=gca;

            if strcmp(plane,'horizontal')
                struc_slice=squeeze(structural(:,:,slice_to_plot))';
                State_slice=squeeze(V_state(:,:,slice_to_plot))';
            elseif strcmp(plane,'vertical')
                struc_slice=squeeze(structural(:,slice_to_plot,:))';
                State_slice=squeeze(V_state(:,slice_to_plot,:))';
            elseif strcmp(plane,'side')
                struc_slice=squeeze(structural(slice_to_plot,:,:))';
                State_slice=squeeze(V_state(slice_to_plot,:,:))';
            end

            imagesc(struc_slice)


            axis image       
            colormap(ax1,'gray')
            axis off
            axis xy

            imAlpha=(struc_slice>0).*0.5; %

            hold on
            ax2=axes('Parent',p);
            ax2.Position=ax1.Position;

            imagesc(State_slice,'AlphaData',imAlpha,[-lim lim])

            colormap(ax2,'jet')
            % colormap('jet')

            axis image
            axis off
            axis xy

           slice=slice+1;

           title(['Scan' num2str(run) ' S' num2str(Cluster) ' k' num2str(k) ' sl ' num2str(slice_to_plot) ],'FontSize',18)

        end
        CL_idx=CL_idx+1;

    end

    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    if Orient==1
        save_file=(['Figures/' PAR '_H_Anatom_CLuster_Scan' num2str(run)] );       
    else
        save_file=(['Figures/' PAR '_S_Anatom_CLuster_Scan' num2str(run)] );       
    end
    saveas(gcf,save_file,'jpg')
end


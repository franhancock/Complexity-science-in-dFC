function make_fig1
%
% Function to make fig1 for dFC Complexity paper
%
%
% Fran Hancock
% Nov 2021
% fran.hancock@kcl.ac.uk
%%
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
% 

brain_mask_file= 'EigVecs_Vox_all';

Smax=5;
Cmax=Smax-1; 
n_rows=10;
n_cols=8;
N_ba=116;
Rmax=4; % number of runs

structural=niftiread('mni.nii.gz');

% To reorder matrix plots
Order=[1:2:N_ba N_ba:-2:2];

load( brain_mask_file,'ind_voxels', 'Brain_Mask_low');
State_Volumes=zeros(Smax,size(Brain_Mask_low,1),size(Brain_Mask_low,2),size(Brain_Mask_low,3)); % needed for anatomical view
V_state=zeros(18,22,18);

Run(1,:)=struct2array(load('RUN1/LEiDA_Kmeans_results', 'Kmeans_results'));
Run(2,:)=struct2array(load('RUN2/LEiDA_Kmeans_results', 'Kmeans_results'));
Run(3,:)=struct2array(load('RUN3/LEiDA_Kmeans_results', 'Kmeans_results'));
Run(4,:)=struct2array(load('RUN4/LEiDA_Kmeans_results', 'Kmeans_results'));

Run_MV(1,:,:)=struct2array(load('RUN1/EigVecs_Vox_RUN1_AAL116.mat', 'Mean_Vec'));
Run_MV(2,:,:)=struct2array(load('RUN2/EigVecs_Vox_RUN2_AAL116.mat', 'Mean_Vec'));
Run_MV(3,:,:)=struct2array(load('RUN3/EigVecs_Vox_RUN3_AAL116.mat', 'Mean_Vec'));
Run_MV(4,:,:)=struct2array(load('RUN4/EigVecs_Vox_RUN4_AAL116.mat', 'Mean_Vec'));

for r=1:Rmax
    RunC(r,:,:)=Run{r,Cmax}.C';
    RunIdx(r,:)=squeeze(Run{r,Cmax}.IDX);
end

 
figure;
set(gcf, 'units','normalized','OuterPosition',[0 0 0.4 1]);
f = gcf;
p = uipanel('Parent',f,'BorderType','none'); 
p.FontSize=24;
p.FontWeight='bold';
p.AutoResizeChildren = 'off';



% set(gcf, 'units','normalized','outerposition',[.5 .5 1 1]);
R_idx=1;
%
 for r=1:Rmax
    V_state=zeros(size(Brain_Mask_low));
    C_idx=R_idx;

    for mode=1:Smax
    C_idx=R_idx; % reset the column index

        slice_to_plot=100;
        % Panel A
        % Plot the cluster centroids over the cortex 
        % Plot the centroids outerproduct (QR-Code)
       
        subplot(n_rows,n_cols,(mode-1)*n_cols*2+C_idx,'Parent',p)  
%        title(['Mode \psi_' num2str(mode) ' (' num2str(mean(RunIdx(r,:)==mode)*100,3) '%)' ])
        
        V=squeeze(RunC(r,:,:)); V=V';
        plot_nodes_in_cortex_AAL116(V(mode,:)); 
        axis off

 %       ylabel(['\bf\psi_' num2str(mode)], 'FontSize',18)
    
         C_idx=C_idx+1;
         
        subplot(n_rows,n_cols,(mode-1)*n_cols*2 + C_idx,'Parent',p)
        VVT=V(mode,:)'*V(mode,:);   
        imagesc(VVT(Order,Order)) 
        
        ax1=gca;
        colormap(ax1,jet)
        axis square
    %    title('Outer product') 
        ylabel('Brain area #')
        xlabel('Brain area #')
        colorbar
%        title(['\bfV_c_' num2str(mode) '.V^T_c_' num2str(mode)])

        C_idx=R_idx;
        
        % Panel B
        % Plot the centroid projected into Vox10 space 
        % Side and Horizontal
        
        subplot(n_rows,n_cols,(mode-1)*n_cols*2+ C_idx+n_cols,'Parent',p)      
        ax1=gca;
        
        V_state=zeros(18,22,18); % reinitialise V_state                
        V_state(ind_voxels)=Run_MV(r,:,mode)';

        State_Volumes(mode,:,:,:)=V_state; % needed for anatomical view
        V_state=imresize3(V_state,3);
        lim=max(abs(Run_MV(r,:,mode)));
        
        % plot side view anatomical 
        V_state=squeeze(State_Volumes(mode,:,:,:));
        V_state=imresize3(V_state,size(structural));
        if mode==3 && r ~= 3
            slice_to_plot=120;
        end
        if mode==2 && r == 3
            slice_to_plot=120;
        end
        struc_slice=squeeze(structural(slice_to_plot,:,:))';
        imagesc(struc_slice)
        axis image       
        axis off
        axis xy
        colormap(ax1,'gray')

        imAlpha=(struc_slice>0).*0.5; %
% 
        hold on
        if r==1
            pause(1.0)
        else
            pause(0.01)
        end
        ax2=axes('Parent',p);
        ax2.Position=ax1.Position;
        
        % plot side modes
       

        State_slice=squeeze(V_state(slice_to_plot,:,:))';
        imagesc(State_slice,'AlphaData',imAlpha,[-lim lim])
       
        axis image
        axis off
        axis xy
        colormap(ax2,'jet')
        hold on
        C_idx=C_idx+1;

        % Plot axial slice
        subplot(n_rows,n_cols,(mode-1)*n_cols*2 +C_idx+n_cols,'Parent',p)      
        ax1=gca;
        
        V_state=zeros(18,22,18); % reinitialise V_state        
        V_state(ind_voxels)=Run_MV(r,:,mode)';

        State_Volumes(mode,:,:,:)=V_state; % needed for anatomical view
        V_state=imresize3(V_state,3);
        lim=max(abs(Run_MV(r,:,mode)));
        
        % plot side view anatomical 
        V_state=squeeze(State_Volumes(mode,:,:,:));
        V_state=imresize3(V_state,size(structural));
        if mode==3 && r~=3
            slice_to_plot=40;
        end
        if mode==2 && r==3
            slice_to_plot=40;
        end
        struc_slice=squeeze(structural(:,:,slice_to_plot))';
        imagesc(struc_slice)
        axis image       

        axis off
        axis xy
        colormap(ax1,'gray')

        imAlpha=(struc_slice>0).*0.5; %

        hold on
        if r==1
            pause(1.0)
        else
            pause(0.01)
        end
        ax2=axes('Parent',p);
        ax2.Position=ax1.Position;
        
        % plot side modes
        
        State_slice=squeeze(V_state(:,:,slice_to_plot))';
        imagesc(State_slice,'AlphaData',imAlpha,[-lim lim])        
        axis image
        
        axis off
        axis xy  
        colormap(ax2,'jet')    
        hold on
      
    end  
    R_idx=R_idx+2;
end
set(p,'BackgroundColor','w')
saveas(gcf,'Figures/Figure1_ls','jpeg')


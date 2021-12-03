function compute_random_walk
%
% Function to plot the trajectory of a subject using t-distributed
% Stochastic Neighbour Embedding
%
%
% Fran Hancock
% Sept 2021
% fran.hancock@kcl.ac.uk
%
%
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
%

Smax=5;
S=input('Which subject 1-20 ');
run=input('Which run 1-4 ?');


Cmax=Smax-1;
Tmax=1200-2;
N_subs=99;
N_rows=1;
N_cols=2;
PAR='AAL116';

figure;

switch run
    case 1
	    MET_FOLDER='RUN1/';
    case 2
	    MET_FOLDER='RUN2/';
    case 3
	    MET_FOLDER='RUN3/';
    case 4
	    MET_FOLDER='RUN4/';
end	
load([MET_FOLDER 'LEiDA_Kmeans_results'],'Kmeans_results')
load([MET_FOLDER 'LEiDA_EigenVectors'],'Time_sessions', 'V1_all')
%
% Set up the trajectory colors
% 
cmap_time=winter(sum(Tmax));
%
% Set up the state colours
%
cmap=[ .7 .7 .7; 0 0 1 ; 1 0 0 ; 1 0.5 0;  0 1 1 ];
state_labels={'\psi_1';'\psi_2';'\psi_3';'\psi_4';'\psi_5'};
TR_labels={'0';' 100';' 200';' 300'; ' 400';' 500';' 600';' 700';' 800';' 900';'1000'};

States=Kmeans_results{Cmax}.IDX(Time_sessions==S);
for t=1:Tmax
    cmap_state(t,:)=cmap(States(:,t),:);
end

% 
% Now do scan 1
%
HiDim=V1_all(Time_sessions==S,:);

tic;

[SNE,loss]=tsne(HiDim,'Algorithm','exact','Distance','cosine','NumDimensions',3,'Perplexity',50,'LearnRate',2000,'Exaggeration',4); 

save([PAR '_SNE_Run' num2str(run) '_Subject' num2str(S)],'SNE', 'loss','cmap_state');

toc;


%%
%
% Now plot trajectory for time and for modes
%

SNE_LR=struct2array(load([PAR '_SNE_Run' num2str(run) '_Subject' num2str(S)],'SNE'));
cmap_state_LR=struct2array(load([PAR '_SNE_Run' num2str(run) '_Subject' num2str(S)],'cmap_state'));


%%%%%%%%%%%%%%%%% Time trajectory LR %%%%%%%%%%%%%%%%%%
subplot(N_rows,N_cols,1)
scatter3(SNE_LR(:,1),SNE_LR(:,2),SNE_LR(:,3),15,cmap_time,'filled');
view(3);

colormap(gca,cmap_time);
c=colorbar;
c.Ticks=[0:1/10:1200];
c.TickLabels=TR_labels;
c.Label.String='Time Slice';
c.Location='southoutside';

xlabel(['t-SNE #1 (a.u.)'])
ylabel(['t-SNE #2 (a.u.)'])
zlabel(['t-SNE #3 (a.u.)'])

%     title([PAR ' SNE Random walk Scan 1 for subject ' num2str(S) ', total ' num2str(Tmax) ' timepoints)'])
set(gca,'DataAspectRatio',[1 1 1],'Color','k','GridColor',[1 1 1],'LineWidth',1.0)

%%%%%%%%%%%%%%%%% State trajectory LR %%%%%%%%%%%%%%%%%%
subplot(N_rows,N_cols,2)
scatter3(SNE_LR(:,1),SNE_LR(:,2),SNE_LR(:,3),15,cmap_state_LR,'filled');
view(3);

colormap(gca,cmap(1:Smax,:));
c=colorbar;
c.Ticks=[0:1/Smax:Smax];
c.TickLabels=(state_labels(1:Smax));
c.TickLabels(Smax+1)={' '};
c.Label.String='Mode';
c.Location='southoutside';

xlabel(['t-SNE #1 (a.u.)'])
ylabel(['t-SNE #2 (a.u.)'])
zlabel(['t-SNE #3 (a.u.)'])
%    title([PAR ' SNE States visited Scan 1 for subject ' num2str(S) ', total ' num2str(Tmax) ' timepoints)'])
set(gca,'DataAspectRatio',[1 1 1],'Color','k','GridColor',[1 1 1],'LineWidth',1.0)

set(findall(gcf,'-property','FontSize'),'FontSize',14)
set(gcf, 'units','normalized','outerposition',[0 0 .4 .4],'color','w');
sgtitle([PAR sprintf(' LEiDA Random Walk Visualization \n  with t-SNE run %d subject %d \n',run,S)],'FontSize',24, 'FontWeight','bold')

saveas(gcf,['Figures/Random_Walks_Sub' num2str(S) '_run' num2str(run)],'jpeg')


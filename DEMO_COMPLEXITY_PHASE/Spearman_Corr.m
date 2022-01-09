function Spearman_Corr
% Function to compute the Spearman correlation between the metrics
%
%
% Fran Hancock
% Nov 2021
% fran.hancock@kcl.ac.uk
%
% Saves the regression tables for processing in R and
% outputs the matrices here in Matlab
% 
%
%%%%%%%

Smax=5;

% speed_state=input('Which speed state');
% metric_state=input('which metric state');
n_subjects=20;
n_rows=2;
n_cols=2;
C_idx=1;

Rmax=4;
Mmax=9;

PAR='AAL116';
Cmax=Smax-1;
C_idx=1;
figure;

for run=1:Rmax
    

    set(gcf, 'units','normalized','outerposition',[0 0 0.5 1]);
     
    load(['RUN' num2str(run) '/LEiDA_for_stats']);
    load AAL116_IPC_MODE_GStats_R2R3 % load MEAN_xxx

    % TAU
    % TAU - values of PHID
    % TAU_TS - PHID at different integration timescales 1-700
    % TAU_Tscale - Imtescale corresponing to max PHID for a subject
    %
    TAU=struct2array(load('TAU','TAU'));

    %
    % Prepare an array for the results
    %
    OCC(:,:)=P(1:n_subjects,Cmax,1);
    DWELL(:,:)=LT(1:n_subjects,Cmax,1);

    data_labels={ 'SYNC', 'CHI','META', 'OCC', 'DURATION', 'SPEED','PCC','CENTROPY', 'PID'};

    %
    % Set up the regression table

    regtable=table(MEAN_SYNC(run,:)', GLOBAL_CHI(run,:)', MEAN_META(run,:)',OCC, DWELL, MEAN_SPEED(run,:)', GLOBAL_PCC(run,:)', CENTROPY(run,:)', TAU(run,:)','VariableNames',data_labels);
    reg_var=table2array(regtable);
    %
    % Save the reg tables for processing in R - nicer graphics
    %
    writetable(regtable,['Regtable' num2str(run) '.xlsx'])

    corr_vals=corr(reg_var);
 
     %%%%%%%%%%%%%
    subplot(n_rows,n_cols,C_idx)
    cm=colormap(flipud(redbluecmap));

    imagesc(corr_vals,'AlphaData',0.8,[-1 1])

    for j1 = 1:Mmax
        for j2 = 1:Mmax
            caption = sprintf('%.2f', corr_vals(j1,j2));
            text(j2-0.35, j1, caption, 'FontSize', 15, 'Color', [0, 0, 0],'FontWeight','bold');
        end
    end
    xticks(1:1:9); xticklabels(data_labels)
    yticks(1:1:9); yticklabels(data_labels)
    xtickangle(45);
    
    set(gca,'FontSize',10,'FontWeight','bold','xaxisLocation','top')
    axis square

    title(['Run ' num2str(run) newline]) 
   % colorbar
    C_idx=C_idx+1;


end
set(findall(gcf,'-property','LineWidth'),'LineWidth',1)
set(findall(gcf,'-property','FontSize'),'FontSize',18)   
exportgraphics(gcf,['Figures/' PAR '_Spearman_Plots.jpeg'])


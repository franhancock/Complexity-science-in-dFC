function PLOT_Step_Regression
% Function to run and plot stepwise regression
%
%
% Fran Hancock
% Aug 2021
% fran.hancock@kcl.ac.uk
%
%
% Function to investigate the relationships between time varying measures
% of META, SYNC, CHI, coalition entropy and integrated information
%
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
%

Smax=5;
n_subjects=20;
n_rows=3;
n_cols=2;
Rmax=4;
global PAR

Cmax=Smax-1;

for run=1:Rmax
    C_idx=1;
    figure;
    set(gcf, 'units','normalized','outerposition',[0 0 0.5 1]);

    switch run 
        case 1
            load('RUN1/LEiDA_for_stats')
        case 2
            load('RUN2/LEiDA_for_stats')
        case 3
            load('RUN3/LEiDA_for_stats')
        case 4
            load('RUN4/LEiDA_for_stats')
    end        

    load AAL116_IPC_MODE_GStats_R1R2.mat
    
    TAU=struct2array(load('TAU','TAU'));

    %
    % Prepare an array for the results
    %
    OCC(:,:)=P(1:n_subjects,Cmax,1);
    DWELL(:,:)=LT(1:n_subjects,Cmax,1);

    tbl_names={'State','Response','Predictor','Multiplier','StdErr','tStat','pValue','RSq','RSqAdj','SumSq', 'DF', 'MS','F','FpVal'};
    data_labels={ 'SYNC', 'CHI','META', 'OCC', 'DURATION','PCC','CENTROPY', 'PID'};
    tbl_cols(1,1:14)=strings;

    %
    % Set up the regression table

    regtable=table(MEAN_SYNC(run,:)', GLOBAL_CHI(run,:)', MEAN_META(run,:)',OCC, DWELL, GLOBAL_PCC(run,:)', CENTROPY(run,:)', TAU(run,:)','VariableNames',data_labels);



     %%%%%%%%%%%%%
    subplot(n_rows,n_cols,[C_idx C_idx+1 C_idx+3])
    corrplot(regtable,'testR','on')
    RegModel=stepwiselm(regtable,'PEnter',0.05);
    % ridge_reg(regtable,data_labels); % Used to look at multicolinearity 
 %   stats=evalc('disp(RegModel)');

    cleanStats=formattedDisplayText(RegModel, "SuppressMarkup",true,"LineSpacing","compact",'NumericFormat','shortG');

    subplot(n_rows,n_cols,C_idx+4)
    plot(RegModel)
    
    subplot(n_rows,n_cols,C_idx+5)
    t=text(0,1,cleanStats,'interpreter','none',VerticalAlignment='top');
    t.FontSize=12;
    axis off

    % Save the text in a file since the formatting is screwed

    file=fullfile(['reg_run' num2str(run)]);
    fid=fopen(file,'w+');
    fprintf(fid,'%s',cleanStats)
    fclose(fid);


    set(findall(gcf,'-property','LineWidth'),'LineWidth',1)
    set(findall(gcf,'-property','FontSize'),'FontSize',14)

    exportgraphics(gcf,['Figures/' PAR '_step_reg_Plots_run' num2str(run) '.jpeg'])

end








    
    


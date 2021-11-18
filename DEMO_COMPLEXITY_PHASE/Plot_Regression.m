function Plot_Regression
% 
% Run multivariable linear regression on 4 metrics
%
% Fran Hancock
% Aug 2021
% fran.hancock@kcl.ac.uk
%
%
% Function to investigate the predictive relationships between time varying measures
% of OCC, CHI, Coalition Entropy for integrated Information 
%
%%%%%%%

Smax=5;
n_subjects=20;
n_rows=3;
n_cols=2;
global PAR

Cmax=Smax-1;

for run=1:4
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

    load AAL116_IPC_MODE_GStats_R2R3 % load MEAN_xxx
  
    TAU=struct2array(load('TAU'));

    %
    % Prepare an array for the results
    %
    OCC(:,:)=P(1:n_subjects,Cmax,1);
    DWELL(:,:)=LT(1:n_subjects,Cmax,1);

    tbl_names={'State','Response','Predictor','Multiplier','StdErr','tStat','pValue','RSq','RSqAdj','SumSq', 'DF', 'MS','F','FpVal'};
    data_labels={ 'CHI', 'OCC','CENTROPY','PID'};
    tbl_cols(1,1:14)=strings;

    %
    % Set up the regression table

    regtable=table( GLOBAL_CHI(run,:)',OCC, CENTROPY(run,:)',TAU(run,:)','VariableNames',data_labels);
    reg_var=table2array(regtable);


     %%%%%%%%%%%%%
    subplot(n_rows,n_cols,[C_idx C_idx+1 C_idx+3])
    corrplot(regtable,'testR','on')
    RegModel=fitlm(regtable);

    % ridge_reg(regtable,data_labels); % Used to look at multicolinearity 
 %   stats=evalc('disp(RegModel)');
%     CC=corrcoef(reg_var);
%     VIF=diag(inv(CC))';
%     Rsquared_i=1-(1./VIF);

    cleanStats=formattedDisplayText(RegModel, "SuppressMarkup",true,"LineSpacing","compact",'NumericFormat','shortG');

    subplot(n_rows,n_cols,C_idx+4)
    plot(RegModel)
    
    subplot(n_rows,n_cols,C_idx+5)
    t=text(0,1,cleanStats,'interpreter','none',VerticalAlignment='top');
    t.FontSize=12;
    axis off

    % Save the text in a file since the formatting is screwed

    file=fullfile(['mv_regression_run' num2str(run)]);
    fid=fopen(file,'w+');
    fprintf(fid,'%s',cleanStats);
    fclose(fid);


    set(findall(gcf,'-property','LineWidth'),'LineWidth',1)
    set(findall(gcf,'-property','FontSize'),'FontSize',14)

    exportgraphics(gcf,['Figures/' PAR '_mv_regression_Plots_run' num2str(run) '.jpeg'])

end








    
    


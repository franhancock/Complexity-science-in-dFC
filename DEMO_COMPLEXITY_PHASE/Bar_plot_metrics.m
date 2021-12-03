function Bar_plot_metrics

%
% Function to plot p values comapring conditions
%
% Using SUPERBAR
%
% Adapted for test-retest study
% Fran Hancock
% sept 2021
% fran.hancock@kcl.ac.uk
%
%
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
%

n_rows=7;
n_cols=2;
Rmax=4;

scan_labels={'Run 1','Run 2','Run 3', 'Run 4'};
box_style='traditional';

run_colors=[1 0 0; 0 1 0; 0 1 1 ; 1 0 1 ; 1 1 0; 0 1 1]/1.1;
%
% just to check the vectors affected
% Centroids from both scans were the 'same' so use LR D1
%
PAR='AAL116';

figure;
C_idx=1;

for r=1:Rmax+2
    switch r
        case 1
            load([PAR '_IPC_MODE_GStats_R1R2'])            
            title_txt='Run 1 Run 2';
            a=1;
            b=2;
         case 2
            load([PAR '_IPC_MODE_GStats_R1R3'])
            title_txt='Run 1 Run 3';
            a=1;
            b=3;
        case 3
            load([PAR '_IPC_MODE_GStats_R1R4'])
            title_txt='Run 1 Run 4';
            a=1;
            b=4;
        case 4
            load([PAR '_IPC_MODE_GStats_R2R3'])
            title_txt='Run 2 Run 3';
            a=2;
            b=3;
       case 5
            load([PAR '_IPC_MODE_GStats_R2R4'])
            title_txt='Run 2 Run 4';
            a=2;
            b=4;
        case 6
            load([PAR '_IPC_MODE_GStats_R3R4'])
            title_txt='Run 3 Run 4';
            hdist(r)=3;
            a=3;
            b=4;
    end  
    Probs_META(a,b)=META_pval;
    Probs_META(b,a)=META_pval;
    Probs_SYNC(a,b)=SYNC_pval;
    Probs_SYNC(b,a)=SYNC_pval;
    Probs_CHI(a,b)=CHI_pval;
    Probs_CHI(b,a)=CHI_pval;
    Probs_PCC(a,b)=PCC_pval;
    Probs_PCC(b,a)=PCC_pval;
    
    Probs_CENTROPY(a,b)=CENTROPY_pval;
    Probs_CENTROPY(b,a)=CENTROPY_pval;
 
    Probs_TAU(a,b)=TAU_pval;
    Probs_TAU(b,a)=TAU_pval;

    Probs_MEAN_SPEED(a,b)=MEAN_SPEED_pval;
    Probs_MEAN_SPEED(b,a)=MEAN_SPEED_pval;

end

for n=1:Rmax
    for p=1:Rmax
        if n==p
            Probs_META(n,p)= NaN;
            Probs_SYNC(n,p)= NaN;
            Probs_CHI(n,p)= NaN;
            Probs_MEAN_SPEED(n,p)= NaN;
            Probs_PCC(n,p)=NaN;
            Probs_CENTROPY(n,p)=NaN;
            Probs_TAU(n,p)=NaN;
        end
    end
end

%
%
clear [PAR '_IPC_MODE_GStats_R1R2'] [PAR '_IPC_MODE_GStats_R1R3'] [PAR '_IPC_MODE_GStats_R1R4'] [PAR '_IPC_MODE_GStats_R2R3'] [PAR '_IPC_MODE_GStats_R2R4'] [PAR '_IPC_MODE_GStats_R3R4'] 
TAU=struct2array(load('TAU'));


hAx=subplot(n_rows,n_cols,C_idx);

superbar([C_META(:,1) C_META(:,2) C_META(:,3) C_META(:,4)],'E',[C_META_SEM(1) C_META_SEM(2) C_META_SEM(3) C_META_SEM(4)],...
    'P', Probs_META,'BarFaceColor',run_colors,'PStarColor',[1 0 0],'PStarFontSize',32,...
    'PStarShowNS',false)
hold on
xticks([1 2 3 4])
xticklabels(scan_labels)
ylabel(' META')
hAx.YRuler.TickLabelFormat = '%.2f';

height=hAx.Position(4);
width=hAx.Position(3);
bottom=hAx.Position(2);

C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

HistData=[MEAN_META(1,:); MEAN_META(2,:); MEAN_META(3,:); MEAN_META(4,:)];        
bh=boxplot(HistData','Notch','on','Labels',scan_labels,'ColorGroup',[1 2 3 4],'PlotStyle',box_style,'Widths',0.3);
box on

set(bh,'LineWidth',1)

hAx.Position(4)=height;
hAx.Position(3)=width;
hAx.Position(2)=bottom;
start=hAx.Position(1);
hAx.YRuler.TickLabelFormat = '%.2f';

C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

superbar([C_SYNC(:,1) C_SYNC(:,2) C_SYNC(:,3) C_SYNC(:,4) ],'E',[C_SYNC_SEM(1) C_SYNC_SEM(2) C_SYNC_SEM(3) C_SYNC_SEM(4)],...
    'P', Probs_SYNC,'BarFaceColor',run_colors,'PStarColor',[1 0 0],'PStarFontSize',32,...
    'PStarShowNS',false)
hold on
xticks([1 2 3 4])
xticklabels(scan_labels)
ylabel('SYNC')
hAx.YRuler.TickLabelFormat = '%.2f';
bottom=hAx.Position(2);
C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

HistData=[MEAN_SYNC(1,:); MEAN_SYNC(2,:); MEAN_SYNC(3,:); MEAN_SYNC(4,:)];        
bh=boxplot(HistData','Notch','on','Labels',scan_labels,'ColorGroup',[1 2 3 4],'PlotStyle',box_style,'Widths',0.3);
box on
set(bh,'LineWidth',1)
hAx.Position(4)=height;
hAx.Position(3)=width;
hAx.Position(1)=start;
hAx.Position(2)=bottom;
hAx.YRuler.TickLabelFormat = '%.2f';
C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

superbar([C_CHI(1,:) C_CHI(2,:) C_CHI(3,:) C_CHI(4,:)],'E',[C_CHI_SEM(1) C_CHI_SEM(2) C_CHI_SEM(3) C_CHI_SEM(4)],...
    'P', Probs_CHI,'BarFaceColor',run_colors,'PStarColor',[1 0 0],'PStarFontSize',32,...
    'PStarShowNS',false)
hold on
xticks([1 2 3 4])
xticklabels(scan_labels)
ylabel('CHI')
hAx.YRuler.Exponent = -2;
hAx.YRuler.TickLabelFormat = '%.2f';
bottom=hAx.Position(2);
C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

HistData=[GLOBAL_CHI(1,:); GLOBAL_CHI(2,:); GLOBAL_CHI(3,:); GLOBAL_CHI(4,:)];        
bh=boxplot(HistData','Notch','on','Labels',scan_labels,'ColorGroup',[1 2 3 4],'PlotStyle',box_style,'Widths',0.3);
box on
set(bh,'LineWidth',1)

hAx.YRuler.Exponent = -2;
hAx.YRuler.TickLabelFormat = '%.2f';

hAx.Position(4)=height;
hAx.Position(3)=width;
hAx.Position(1)=start;
hAx.Position(2)=bottom;
C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

superbar([C_PCC(1,:) C_PCC(2,:) C_PCC(3,:) C_PCC(4,:)],'E',[C_PCC_SEM(1) C_PCC_SEM(2) C_PCC_SEM(3) C_PCC_SEM(4)],...
    'P', Probs_PCC,'BarFaceColor',run_colors,'PStarColor',[1 0 0],'PStarFontSize',32,...
    'PStarShowNS',false)
hold on
xticks([1 2 3 4])
xticklabels(scan_labels)
ylabel('PCC')
hAx.YRuler.Exponent = -1;
hAx.YRuler.TickLabelFormat = '%.2f';
bottom=hAx.Position(2);
C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

HistData=[GLOBAL_PCC(1,:); GLOBAL_PCC(2,:); GLOBAL_PCC(3,:); GLOBAL_PCC(4,:)];        
bh=boxplot(HistData','Notch','on','Labels',scan_labels,'ColorGroup',[1 2 3 4],'PlotStyle',box_style,'Widths',0.3);
box on
set(bh,'LineWidth',1)
hAx.Position(4)=height;
hAx.Position(3)=width;
hAx.Position(1)=start;
hAx.Position(2)=bottom;
hAx.YRuler.Exponent = -2;
hAx.YRuler.TickLabelFormat = '%.2f';

C_idx=C_idx+1;



hAx=subplot(n_rows,n_cols,C_idx);

superbar([C_CENTROPY(1,:) C_CENTROPY(2,:) C_CENTROPY(3,:) C_CENTROPY(4,:)],'E',[C_CENTROPY_SEM(1) C_CENTROPY_SEM(2) C_CENTROPY_SEM(3) C_CENTROPY_SEM(4)],...
    'P', Probs_CENTROPY,'BarFaceColor',run_colors,'PStarColor',[1 0 0],'PStarFontSize',32,...
    'PStarShowNS',false)
hold on
xticks([1 2 3 4])
xticklabels(scan_labels)
ylabel('H_c')
hAx.YRuler.TickLabelFormat = '%.2f';
bottom=hAx.Position(2);
C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

HistData=[CENTROPY(1,:); CENTROPY(2,:); CENTROPY(3,:); CENTROPY(4,:)];        
boxplot(HistData','Notch','on','Labels',scan_labels,'ColorGroup',[1 2 3 4],'PlotStyle',box_style,'Widths',0.3);
box on
hAx.Position(4)=height;
hAx.Position(3)=width;
hAx.Position(1)=start;
hAx.Position(2)=bottom;
hAx.YRuler.TickLabelFormat = '%.2f';
C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

superbar([C_TAU(1,:) C_TAU(2,:) C_TAU(3,:) C_TAU(4,:)],'E',[C_TAU_SEM(1) C_TAU_SEM(2) C_TAU_SEM(3) C_TAU_SEM(4)],...
    'P', Probs_TAU,'BarFaceColor',run_colors,'PStarColor',[1 0 0],'PStarFontSize',32,...
    'PStarShowNS',false)
hold on
xticks([1 2 3 4])
xticklabels(scan_labels)
ylabel('\Phi^R')
hAx.YRuler.TickLabelFormat = '%.2f';
bottom=hAx.Position(2);
C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

HistData=[TAU(1,:); TAU(2,:); TAU(3,:); TAU(4,:)];        
bh=boxplot(HistData','Notch','on','Labels',scan_labels,'ColorGroup',[1 2 3 4],'PlotStyle',box_style,'Widths',0.3);
box on
set(bh,'LineWidth',1)

hAx.Position(4)=height;
hAx.Position(3)=width;
hAx.Position(1)=start;
hAx.Position(2)=bottom;
hAx.YRuler.TickLabelFormat = '%.2f';
C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

superbar([C_SPEED(1,:) C_SPEED(2,:) C_SPEED(3,:) C_SPEED(4,:)],'E',[C_SPEED_SEM(1) C_SPEED_SEM(2) C_SPEED_SEM(3) C_SPEED_SEM(4)],...
    'P', Probs_MEAN_SPEED,'BarFaceColor',run_colors,'PStarColor',[1 0 0],'PStarFontSize',32,...
    'PStarShowNS',false)
hold on
xticks([1 2 3 4])
xticklabels(scan_labels)
ylabel('SPEED')
hAx.YRuler.Exponent = -2;
hAx.YRuler.TickLabelFormat = '%.2f';
bottom=hAx.Position(2);
C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

HistData=[MEAN_SPEED(1,:); MEAN_SPEED(2,:); MEAN_SPEED(3,:); MEAN_SPEED(4,:)];        
bh=boxplot(HistData','Notch','on','Labels',scan_labels,'ColorGroup',[1 2 3 4],'PlotStyle',box_style,'Widths',0.3);
box on
set(bh,'LineWidth',1)

hAx.Position(4)=height;
hAx.Position(3)=width;
hAx.Position(1)=start;
hAx.Position(2)=bottom;
hAx.YRuler.Exponent = -2;
hAx.YRuler.TickLabelFormat = '%.2f';


set(findall(gcf,'-property','FontWeight'),'FontWeight','bold')
set(findall(gcf,'-property','FontSize'),'FontSize',18)
sgtitle([PAR newline ],'FontSize',24, 'FontWeight','bold')

% set(gcf, 'units','normalized','outerposition',[0 0 .4 .75]);
 set(gcf, 'units','normalized','outerposition',[0 0 .3 1]);

exportgraphics(gcf,['Figures/Global_boxplots_' PAR '.jpeg'])


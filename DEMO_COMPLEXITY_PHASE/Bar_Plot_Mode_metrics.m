function Bar_Plot_Mode_metrics
%
%
% Using SUPERBAR
%
% Adapted for test-retest study
% Fran Hancock
% sept 2021
% fran.hancock@kcl.ac.uk
%
% Set the PStarThreshold to [0.01 0.001 0.0001] to account for multiple comparisons across 5 modes 
%%%%%%%

Smax=5;
Cmax=Smax-1;
n_rows=5;
n_cols=2;
global PAR

Rmax=4;
num_subjects=20;

scan_labels={'Run 1','Run 2','Run 3', 'Run 4'};
box_style='traditional';

run_colors=[1 0 0; 0 1 0; 0 1 1 ; 1 0 1 ; 1 1 0; 0 1 1]/1.1;

load([PAR '_IPC_MODE_Stats_R1R2'],'META', 'SYNC');

for mode=1:Smax
    
figure;
C_idx=1;

Probs=zeros(Rmax,Rmax);

for r=1:Rmax+2
    switch r
        case 1
            load([PAR '_IPC_MODE_Stats_R1R2'])            
            title_txt='Run 1 Run 2';
            a=1;
            b=2;
         case 2
            load([PAR '_IPC_MODE_Stats_R1R3'])
            title_txt='Run 1 Run 3';
            a=1;
            b=3;
        case 3
            load([PAR '_IPC_MODE_Stats_R1R4'])
            title_txt='Run 1 Run 4';
            a=1;
            b=4;
        case 4
            load([PAR '_IPC_MODE_Stats_R2R3'])
            title_txt='Run 2 Run 3';
            a=2;
            b=3;
       case 5
            load([PAR '_IPC_MODE_Stats_R2R4'])
            title_txt='Run 2 Run 4';
            a=2;
            b=4;
        case 6
            load([PAR '_IPC_MODE_Stats_R3R4'])
            title_txt='Run 3 Run 4';
            hdist(r)=3;
            a=3;
            b=4;
    end  
    
    Probs_P(a,b)=P_pval(Cmax,mode);
    Probs_P(b,a)=P_pval(Cmax,mode);
    Probs_LT(a,b)=LT_pval(Cmax,mode);
    Probs_LT(b,a)=LT_pval(Cmax,mode);

    Probs_META(a,b)=META_pval(Cmax,mode);
    Probs_META(b,a)=META_pval(Cmax,mode);
    Probs_SYNC(a,b)=SYNC_pval(Cmax,mode);
    Probs_SYNC(b,a)=SYNC_pval(Cmax,mode);

end

for n=1:Rmax
    for p=1:Rmax
        if n==p
            Probs_P(n,p)= NaN;
            Probs_LT(n,p)= NaN;
            Probs_META(n,p)= NaN;
            Probs_SYNC(n,p)= NaN;
        end
    end
end

%
% set the statistical significance
%


for r=1:Rmax

    SEM_P(r,:)=std(P(r,:,mode))/sqrt(num_subjects);
    SEM_LT(r,:)=std(LT(r,:,mode))/sqrt(num_subjects);
    SEM_META(r,:)=std(META(r,:,mode))/sqrt(num_subjects);
    SEM_SYNC(r,:)=std(SYNC(r,:,mode))/sqrt(num_subjects);
end

hAx=subplot(n_rows,n_cols,C_idx);

superbar([mean(P(1,:,mode)) mean(P(2,:,mode)) mean(P(3,:,mode)) mean(P(4,:,mode))],'E',[SEM_P(1) SEM_P(2) SEM_P(3) SEM_P(4)],...
    'P', Probs_P,'BarFaceColor',run_colors,'PStarColor',[1 0 0],'PStarFontSize',20,...
    'PStarShowNS',false,'PStarThreshold',[0.01 0.001 0.0001])
hold on
xticks([1 2 3 4])
xticklabels(scan_labels)
ylabel(['OCCURRENCE \psi_' num2str(mode)])

height=hAx.Position(4);
width=hAx.Position(3);
bottom=hAx.Position(2);
hAx.YRuler.TickLabelFormat = '%.2f';

C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

HistData=[P(1,:,mode); P(2,:,mode); P(3,:,mode); P(4,:,mode)];        
bh=boxplot(HistData','Notch','on','Labels',scan_labels,'ColorGroup',[1 2 3 4],'PlotStyle',box_style,'Widths',0.3);
box on
set(bh,'LineWidth',1)

start=hAx.Position(1);
hAx.Position(4)=height;
hAx.Position(3)=width;
hAx.Position(2)=bottom;
hAx.YRuler.TickLabelFormat = '%.2f';

C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

superbar([mean(LT(1,:,mode)) mean(LT(2,:,mode)) mean(LT(3,:,mode)) mean(LT(4,:,mode))],'E',[SEM_LT(1) SEM_LT(2) SEM_LT(3) SEM_LT(4)],...
    'P', Probs_LT,'BarFaceColor',run_colors,'PStarColor',[1 0 0],'PStarFontSize',20,...
    'PStarShowNS',false,'PStarThreshold',[0.01 0.001 0.0001])
hold on
xticks([1 2 3 4])
xticklabels(scan_labels)
ylabel(['DURATION \psi_' num2str(mode)])

bottom=hAx.Position(2);
switch mode
    case 1
        hAx.YRuler.TickLabelFormat = '%.1f';
    case 2
        hAx.YRuler.TickLabelFormat = '%.1f';
    case 3
        hAx.YRuler.TickLabelFormat = '%.1f';
    case 4
        hAx.YRuler.TickLabelFormat = '%.2f';
    case 5
        hAx.YRuler.TickLabelFormat = '%.2f';
end
C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

HistData=[LT(1,:,mode); LT(2,:,mode); LT(3,:,mode); LT(4,:,mode)];        
bh=boxplot(HistData','Notch','on','Labels',scan_labels,'ColorGroup',[1 2 3 4],'PlotStyle',box_style,'Widths',0.3);
box on
set(bh,'LineWidth',1)
hAx.Position(1)=start;
hAx.Position(4)=height;
hAx.Position(3)=width;
hAx.Position(2)=bottom;
switch mode
    case 1
        hAx.YRuler.TickLabelFormat = '%.1f';
    case 2
        hAx.YRuler.TickLabelFormat = '%.1f';
    case 3
        hAx.YRuler.TickLabelFormat = '%.1f';
    case 4
        hAx.YRuler.TickLabelFormat = '%.2f';
    case 5
        hAx.YRuler.TickLabelFormat = '%.2f';
end

C_idx=C_idx+1;


hAx=subplot(n_rows,n_cols,C_idx);

superbar([mean(META(1,:,mode)) mean(META(2,:,mode)) mean(META(3,:,mode)) mean(META(4,:,mode))],'E',[SEM_META(1) SEM_META(2) SEM_META(3) SEM_META(4)],...
    'P', Probs_META,'BarFaceColor',run_colors,'PStarColor',[1 0 0],'PStarFontSize',20,...
    'PStarShowNS',false,'PStarThreshold',[0.01 0.001 0.0001])
hold on
xticks([1 2 3 4])
xticklabels(scan_labels)
ylabel(['META \psi_' num2str(mode)])
bottom=hAx.Position(2);
hAx.YRuler.TickLabelFormat = '%.2f';
C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

HistData=[META(1,:,mode); META(2,:,mode); META(3,:,mode); META(4,:,mode)];        
bh=boxplot(HistData','Notch','on','Labels',scan_labels,'ColorGroup',[1 2 3 4],'PlotStyle',box_style,'Widths',0.3);
box on
set(bh,'LineWidth',1)

hAx.Position(4)=height;
hAx.Position(3)=width;
hAx.Position(2)=bottom;
hAx.Position(1)=start;
hAx.YRuler.TickLabelFormat = '%.2f';


C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

superbar([mean(SYNC(1,:,mode)) mean(SYNC(2,:,mode)) mean(SYNC(3,:,mode)) mean(SYNC(4,:,mode))],'E',[SEM_SYNC(1) SEM_SYNC(2) SEM_SYNC(3) SEM_SYNC(4)],...
    'P', Probs_SYNC,'BarFaceColor',run_colors,'PStarColor',[1 0 0],'PStarFontSize',20,...
    'PStarShowNS',false,'PStarThreshold',[0.01 0.001 0.0001])
hold on
xticks([1 2 3 4])
xticklabels(scan_labels)
ylabel(['SYNC \psi_' num2str(mode)])
bottom=hAx.Position(2);
hAx.YRuler.TickLabelFormat = '%.2f';
C_idx=C_idx+1;

hAx=subplot(n_rows,n_cols,C_idx);

HistData=[SYNC(1,:,mode); SYNC(2,:,mode); SYNC(3,:,mode); SYNC(4,:,mode)];        
bh=boxplot(HistData','Notch','on','Labels',scan_labels,'ColorGroup',[1 2 3 4],'PlotStyle',box_style,'Widths',0.3);
box on
set(bh,'LineWidth',1)

hAx.Position(4)=height;
hAx.Position(3)=width;
hAx.Position(2)=bottom;
hAx.Position(1)=start;
hAx.YRuler.TickLabelFormat = '%.2f';
C_idx=C_idx+1;


set(findall(gcf,'-property','FontSize'),'FontSize',14)
set(findall(gcf,'-property','FontWeight'),'FontWeight','bold')

set(gcf, 'units','normalized','outerposition',[0 0 .25 .5]);
saveas(gcf,['Figures/Figure3_' PAR '_MODE_' num2str(mode)],'jpeg')
end


function LEiDA_TV_METRICS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function to compute the Kuramoto order parameter, Synchronisation, and
% Metastability within and between 5 PL modes derived from AAL116 LEiDA
% anaysis
% Plot time varying metrics - KOP, Chimera,instantaneous Phase Coherence across Communities for a single subject
% Report the summary metrics OCC,META,CHI, PCC,
%  Coalition Entropy (Hc), PHI-IDR
%
% folowing Wilde & Shanahan 2012
% Fran Hancock
% May 2021
% fran.hancock@kcl.ac.uk
%
%
%%%%%%%

Smax=5;  
Cmax=Smax-1;
n_rows=9;
n_cols=Smax;
Tstart=500;
Tslices=250;
Tend=Tstart+Tslices;

global PAR
rc=2;

Subject=input('Which subject 1-20 ?: ');
figure
set(gcf, 'units','normalized','outerposition',[0 0 .5 1]);

for run=1:4
    
switch run
    case 1
        MET_FOLDER='RUN1/';
        load 'RUN1/LEiDA_KOP_ALL_RUN1'
    case 2
        MET_FOLDER='RUN2/';
        load 'RUN2/LEiDA_KOP_ALL_RUN2'
    case 3
        MET_FOLDER='RUN3/';
        load 'RUN3/LEiDA_KOP_ALL_RUN3'
    case 4
        MET_FOLDER='RUN4/';
        load 'RUN4/LEiDA_KOP_ALL_RUN4'
end

TAU=struct2array(load('TAU','TAU'));

Kmeans=struct2array(load([MET_FOLDER 'LEiDA_Kmeans_results'],'Kmeans_results')); 
load([MET_FOLDER 'LEiDA_EigenVectors']);
state_idx=Kmeans{Cmax}.IDX(Time_sessions==Subject);
clear Kmeans LEiDA_EigenVectors

%
% Now get the summary metrics for OCC and DWELL
%
load([MET_FOLDER 'LEiDA_for_stats'])
load(['AAL116_IPC_STATES_RUN' num2str(run)]);
load(['AAL116_IPC_RW_ALL_R' num2str(run)]);

P5=squeeze(P(Subject,Cmax,:));
LT5=squeeze(LT(Subject,Cmax,:));
MEAN_SPEED5=squeeze(MEAN_SPEED(Subject,Cmax,:));
META5=squeeze(RSN_META_ALL(Subject,:,Cmax));
SYNC5=squeeze(RSN_SYNC_ALL(Subject,:,Cmax));
%
% need to flip the modes
%


%
% AAL116 - Now flip the rows for runs 1 and 3
switch run
    case 1
        P5([4 5])=P5([5 4]);
        LT5([4 5])=LT5([5 4]);
        MEAN_SPEED([4 5])=MEAN_SPEED([5 4]);
        META5([4 5])=META5([5 4]);
        SYNC5([4 5])=SYNC5([5 4]);
    case 3

        P5([2 3])=P5([3 2]);
        P5([4 5])=P5([5 4]);
        
        LT5([2 3])=LT5([3 2]);
        LT5([4 5])=LT5([5 4]);

        MEAN_SPEED([2 3])=MEAN_SPEED([3 2]);
        MEAN_SPEED([4 5])=MEAN_SPEED([5 4]);

        META5([2 3])=META5([3 2]);
        META5([4 5])=META5([5 4]);
        
        SYNC5([2 3])=SYNC5([3 2]);
        SYNC5([4 5])=SYNC5([5 4]);
end
OCC=P5;
DWELL=LT5;
META=META5;
MEAN_SPEED=MEAN_SPEED5;
SYNC=SYNC5;
CE=GLOBAL_CE;
CHI=GLOBAL_CHI;


RSN_names = {'\psi_1','\psi_2','\psi_3','\psi_4','\psi_5','_G'};
cmap=[ 0.7 0.7 0.7; 0 0 1 ; 1 0 0 ; 1 0.5 0;  0 1 1; 0.4940 0.1840 0.5560];

if run==1 || run==2
subplot(n_rows,n_cols,[rc rc+1])

meta=mean(META,2);
ICN_sub=squeeze(ICN_OP_ALL(Subject,1,Cmax,Tstart:Tend));
x=1:numel(ICN_sub);
curve1= ICN_sub+meta;
curve2= ICN_sub-meta;

shade(x,curve1,x,curve2,'FillType',[1 2;2 1],'Color','none','FillColor','magenta');

hold on
p1=plot(squeeze(ICN_sub),'Linewidth',1.5,'Color',cmap(1,:));

ymax=1.1; % KOP max value
xlim([0 Tslices])

rt=Tstart;

for t=1:Tslices
    
    x=[t t+1 t+1 t];
   
    y=[-0.15 -0.15 ymax ymax];
    p=patch(x,y,'r');
    if run==2
        switch state_idx(rt)
            case 1
                reIdx=1;
            case 2
                reIdx=3;
            case 3
                reIdx=2;
            case 4
                reIdx=5;
            case 5
                reIdx=4;
        end
        set(p,'LineStyle','none','FaceColor',cmap(reIdx,:),'FaceAlpha',0.2);
    elseif run==4
         switch state_idx(rt)
            case 1
                reIdx=1;
            case 2
                 reIdx=3;
             case 3
                 reIdx=2;
             case 4
                 reIdx=4;
             case 5
                 reIdx=5;
         end
         set(p,'LineStyle','none','FaceColor',cmap(reIdx,:),'FaceAlpha',0.2);
    else
        set(p,'LineStyle','none','FaceColor',cmap(state_idx(rt),:),'FaceAlpha',0.2);
    end
    rt=rt+1;
end

title(['RUN ' num2str(run) newline 'Kuramoto Order Parameter & Metastability']);

subplot(n_rows,n_cols,[n_cols+rc n_cols+rc+1  ])

p1=plot(squeeze(ICN_CHI(Subject,Tstart:Tend)),'Linewidth',1.5,'Color',cmap(1,:));

ymax=max(ICN_CHI(Subject,:)); % Chimera max value
ylim([0 ymax])
xlim([0 Tslices])

rt=Tstart;

for t=1:Tslices
    x=[t t+1 t+1 t];
   
    y=[0 0 ymax ymax];
    p=patch(x,y,'r');
    %
    % correct for reordering in run 2 and 4
    %
        if run==2
        switch state_idx(rt)
            case 1
                reIdx=1;
            case 2
                reIdx=3;
            case 3
                reIdx=2;
            case 4
                reIdx=5;
            case 5
                reIdx=4;
        end
        set(p,'LineStyle','none','FaceColor',cmap(reIdx,:),'FaceAlpha',0.2);
    elseif run==4
         switch state_idx(rt)
            case 1
                reIdx=1;
            case 2
                 reIdx=3;
             case 3
                 reIdx=2;
             case 4
                 reIdx=4;
             case 5
                 reIdx=5;
         end
         set(p,'LineStyle','none','FaceColor',cmap(reIdx,:),'FaceAlpha',0.2);
    else
        set(p,'LineStyle','none','FaceColor',cmap(state_idx(rt),:),'FaceAlpha',0.2);
    end
    rt=rt+1;
end
title('Chimera');


subplot(n_rows,n_cols,[2*n_cols+rc 2*n_cols+rc+1])
hold on
p1=plot(squeeze(ICN_OP_ALL(Subject,1,Cmax,Tstart:Tend)),'Linewidth',1.5,'Color',cmap(1,:));
p2=plot(squeeze(ICN_OP_ALL(Subject,2,Cmax,Tstart:Tend)),'Linewidth',1.5,'Color',cmap(2,:));
p3=plot(squeeze(ICN_OP_ALL(Subject,3,Cmax,Tstart:Tend)),'Linewidth',1.5,'Color',cmap(3,:));
p4=plot(squeeze(ICN_OP_ALL(Subject,4,Cmax,Tstart:Tend)),'Linewidth',1.5,'Color',cmap(4,:));
p5=plot(squeeze(ICN_OP_ALL(Subject,5,Cmax,Tstart:Tend)),'Linewidth',1.5,'Color',cmap(5,:));

ymax=1; % KOP max value
xlim([0 Tslices])
rt=Tstart;

for t=1:Tslices
    x=[t t+1 t+1 t];
    y=[0 0 ymax ymax];
    p=patch(x,y,'r');
        if run==2
        switch state_idx(rt)
            case 1
                reIdx=1;
            case 2
                reIdx=3;
            case 3
                reIdx=2;
            case 4
                reIdx=5;
            case 5
                reIdx=4;
        end
        set(p,'LineStyle','none','FaceColor',cmap(reIdx,:),'FaceAlpha',0.2);
    elseif run==4
         switch state_idx(rt)
            case 1
                reIdx=1;
            case 2
                 reIdx=3;
             case 3
                 reIdx=2;
             case 4
                 reIdx=4;
             case 5
                 reIdx=5;
         end
         set(p,'LineStyle','none','FaceColor',cmap(reIdx,:),'FaceAlpha',0.2);
    else
        set(p,'LineStyle','none','FaceColor',cmap(state_idx(rt),:),'FaceAlpha',0.2);
    end
    rt=rt+1;
end
title('KOP in communitiies');

subplot(n_rows,n_cols,[3*n_cols+rc 3*n_cols+rc+1])

p1=plot(squeeze(INST_PCC(Subject,Tstart:Tend)),'Linewidth',1.5,'Color','r');
xlim([0 Tslices])
rt=Tstart;
ymax=max(INST_PCC(Subject,:)); % 


for t=1:Tslices
    x=[t t+1 t+1 t];
    y=[0 0 ymax ymax];
    p=patch(x,y,'r');
        if run==2
        switch state_idx(rt)
            case 1
                reIdx=1;
            case 2
                reIdx=3;
            case 3
                reIdx=2;
            case 4
                reIdx=5;
            case 5
                reIdx=4;
        end
        set(p,'LineStyle','none','FaceColor',cmap(reIdx,:),'FaceAlpha',0.2);
    elseif run==4
         switch state_idx(rt)
            case 1
                reIdx=1;
            case 2
                 reIdx=3;
             case 3
                 reIdx=2;
             case 4
                 reIdx=4;
             case 5
                 reIdx=5;
         end
         set(p,'LineStyle','none','FaceColor',cmap(reIdx,:),'FaceAlpha',0.2);
    else
        set(p,'LineStyle','none','FaceColor',cmap(state_idx(rt),:),'FaceAlpha',0.2);
    end
    rt=rt+1;
end

title('IPC');
ylabel(['RUN ' num2str(run)]);

% 
rc=rc+2;
end
%%%%%%%%%%%%%%%% Now the global metrics %%%%%%%%%

cmap=flip(cmap);
subplot(n_rows,n_cols, (3+run)*(n_cols)+1)

S_BAR= [ OCC(1:Smax)' 0];
S_BAR=flip(S_BAR);

b=barh(S_BAR,'FaceColor','flat');
for mode=1:Smax+1
    b.CData(mode,:)=cmap(mode,:);
end
if run==1
    title('OCCURRENCE');
end
xmax=max(OCC);
set(gca,'YTickLabel',flip(RSN_names(1:Smax+1)),'Fontsize',10)
ylabel(['RUN ' num2str(run)])

subplot(n_rows,n_cols, (3+run)*(n_cols)+2)

S_BAR= [ DWELL(1:Smax)' 0];
S_BAR=flip(S_BAR);

b=barh(S_BAR,'FaceColor','flat');
for mode=1:Smax+1
    b.CData(mode,:)=cmap(mode,:);
end
if run==1
    title('DURATION');
end
xmax=max(DWELL);
set(gca,'YTickLabel',flip(RSN_names(1:Smax+1)),'Fontsize',10)

subplot(n_rows,n_cols, (3+run)*(n_cols)+3)

% S_BAR= [squeeze(MEAN_SPEED(run,Subject,:))' GLOBAL_MEAN_SPEED_LR(:,Subject)];
S_BAR= [MEAN_SPEED' GLOBAL_MEAN_SPEED(:,Subject)'];

S_BAR=flip(S_BAR);

b=barh(S_BAR,'FaceColor','flat');
for mode=1:Smax+1
    b.CData(mode,:)=cmap(mode,:);
end
if run==1
    title('SPEED');
end
xmax=max(MEAN_SPEED);

xlim([0 xmax]);
set(gca,'YTickLabel',flip(RSN_names(1:Smax+1)),'Fontsize',10)

subplot(n_rows,n_cols, (3+run)*(n_cols)+4)
S_BAR= [ SYNC SYNC(1)];
S_BAR=flip(S_BAR);

b=barh(S_BAR,'FaceColor','flat');
for mode=1:Smax+1
    b.CData(mode,:)=cmap(mode,:);
end
if run==1
    title('SYNC');
end
xmax=max(SYNC);
xlim([0 xmax]);
set(gca,'YTickLabel',flip(RSN_names(1:Smax+1)),'Fontsize',10)

subplot(n_rows,n_cols, (3+run)*(n_cols)+5) 

S_BAR= [META mean(META,2)];
S_BAR=flip(S_BAR);

b=barh(S_BAR,'FaceColor','flat');
for mode=1:Smax+1
    b.CData(mode,:)=cmap(mode,:);
end
if run==1
    title('META')
end
xlim([0 0.3]);
set(gca,'YTickLabel',flip(RSN_names(1:Smax+1)),'Fontsize',10)


%
% Collect the global metrics over the 4 runs
%
CHI_ALL(run,:)=GLOBAL_CHI(Subject,:);
PCC_ALL(run,:)=GLOBAL_PCC(Subject,:);
CE_ALL(run,:)=CE(Subject);
META_ALL(run,:)=mean(META,2);

end % end of runs

%
% Plot these on new rows
%
run=1;
global_metrics={'Run 1','Run 2','Run 3','Run 4'};

subplot(n_rows,n_cols, (7+run)*(n_cols)+1)

S_BAR= [META_ALL];
S_BAR=flip(S_BAR);

b=barh(S_BAR,'FaceColor','flat');
b.CData=cmap(1,:);

title('META');
xmax=max(META_ALL);
set(gca,'YTickLabel',flip(global_metrics(:)),'Fontsize',10)

subplot(n_rows,n_cols, (7+run)*(n_cols)+2)

S_BAR= [CHI_ALL];
S_BAR=flip(S_BAR);

b=barh(S_BAR,'FaceColor','flat');
b.CData=cmap(1,:);

title('CHI');
xmax=max(CHI_ALL);
set(gca,'YTickLabel',flip(global_metrics(:)),'Fontsize',10)

% set(gca,'YTickLabel',' ','Fontsize',10)
%ylabel(['RUN ' num2str(run)])

subplot(n_rows,n_cols, (7+run)*(n_cols)+3) 

S_BAR= [ PCC_ALL];
S_BAR=flip(S_BAR);

b=barh(S_BAR,'FaceColor','flat');
b.CData=cmap(1,:);

title('PCC');

xlim([0 1]);
set(gca,'YTickLabel',flip(global_metrics(:)),'Fontsize',10)

subplot(n_rows,n_cols, (7+run)*(n_cols)+4) 

S_BAR= [CE_ALL];
S_BAR=flip(S_BAR);

b=barh(S_BAR,'FaceColor','flat');
b.CData=cmap(1,:);

title('H_c');

xlim([0 Smax]);
set(gca,'YTickLabel',flip(global_metrics(:)),'Fontsize',10)

subplot(n_rows,n_cols, (7+run)*(n_cols)+5) 

S_BAR= [TAU(1:4,Subject)];
S_BAR=flip(S_BAR);

b=barh(S_BAR,'FaceColor','flat');
b.CData=cmap(1,:);

title('\Phi^R');

xlim([0 1]);
set(gca,'YTickLabel',flip(global_metrics(:)),'Fontsize',10)


hold off
% set(gcf, 'units','normalized','outerposition',[0 0 .5 .75]);


set(findall(gcf,'-property','FontSize'),'FontSize',16)
save_file=(['Figures/' PAR  '_Metric_plots_subject_' num2str(Subject) ]);

sgtitle(['Phase-locking- and synchrony-based metrics in ' PAR ' Subject ' num2str(Subject) ' RUNs 1-4'],'FontWeight','b','Fontsize',20);
exportgraphics(gcf, [save_file '.tiff']);

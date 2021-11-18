function LEiDA_reliability
%
% Function to analyse the reliability between scans and across
% parcellations for 5 PL states
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

Smax=5;
Cmax=Smax-1; 
Rmax=4;
C_idx=1;
n_rows=2;
n_cols=3;


global PAR

Run(1,:)=struct2array(load(['RUN1/LEiDA_Kmeans_results'], 'Kmeans_results'));
Run(2,:)=struct2array(load(['RUN2/LEiDA_Kmeans_results'], 'Kmeans_results'));
Run(3,:)=struct2array(load(['RUN3/LEiDA_Kmeans_results'], 'Kmeans_results'));
Run(4,:)=struct2array(load(['RUN4/LEiDA_Kmeans_results'], 'Kmeans_results'));

for r=1:Rmax
    RunC(r,:,:)=Run{r,Cmax}.C';
end
    % Check the replicability of states across scans

AxesLimits = [0, 0, 0, 0, 0; 1, 1, 1, 1, 1]; % Axes limits [min axes limits; max axes limits]
AxesLabels = {'\psi_1', '\psi_2', '\psi_3', '\psi_4', '\psi_5'}; % Axes properties
ax_int=3;
ax_pre=2;
    
for s=1:Smax
    
   Run1=squeeze(RunC(1,:,:));
   Run2=squeeze(RunC(2,:,:));
   Run3=squeeze(RunC(3,:,:));
   Run4=squeeze(RunC(4,:,:));
   
   for p=1:Smax
       
        scan12_ICC(s,p)=ICC(1,'single',[Run1(:,s), Run2(:,p)]);
        scan13_ICC(s,p)=ICC(1,'single',[Run1(:,s), Run3(:,p)]);
        scan14_ICC(s,p)=ICC(1,'single',[Run1(:,s), Run4(:,p)]);

        scan23_ICC(s,p)=ICC(1,'single',[Run2(:,s), Run3(:,p)]);
        scan24_ICC(s,p)=ICC(1,'single',[Run2(:,s), Run4(:,p)]);

        scan34_ICC(s,p)=ICC(1,'single',[Run3(:,s), Run4(:,p)]);


   end
end

figure;
set(gcf, 'units','normalized','outerposition',[0 0 .5 .5]);

C_idx=1;
% Spider plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(n_rows,n_cols,C_idx)
colormap('Copper')
imagesc(scan12_ICC, [0 1])

for j1 = 1:Smax
    for j2 = 1:Smax
        caption = sprintf('%.2f', scan12_ICC(j1,j2));
        if scan12_ICC(j1,j2) <0
             caption = sprintf('  -');
        end
        text(j2-0.35, j1, caption, 'FontSize', 15, 'Color', [0, 0, 0],'FontWeight','bold');
    end
end
xticks(1:1:5); xticklabels(AxesLabels)
yticks(1:1:5); yticklabels(AxesLabels)
% xtickangle(45);ytickangle(45)

set(gca,'FontSize',10,'FontWeight','bold')
axis square
ylabel('Run 1')
xlabel('Run 2')
% axis off
title(['Run 1 Run 2 ICC '])
colorbar
C_idx=C_idx+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(n_rows,n_cols,C_idx)
colormap('Copper')
imagesc(scan13_ICC,[0 1])

for j1 = 1:Smax
    for j2 = 1:Smax
        caption = sprintf('%.2f', scan13_ICC(j1,j2));
        if scan13_ICC(j1,j2) <0
             caption = sprintf('  -');
        end
        text(j2-0.35, j1, caption, 'FontSize', 15, 'Color', [0,0,0],'FontWeight','bold');
    end
end
xticks(1:1:5); xticklabels(AxesLabels)
yticks(1:1:5); yticklabels(AxesLabels)
% xtickangle(45);ytickangle(45)
set(gca,'FontSize',20,'FontWeight','bold')
axis square
ylabel('Run 1')
xlabel('Run 3')
% axis off
title(['Run 1 Run 3 ICC '])
C_idx=C_idx+1;
colorbar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(n_rows,n_cols,C_idx)
colormap('Copper')
imagesc(scan14_ICC, [0 1])

for j1 = 1:Smax
    for j2 = 1:Smax
        caption = sprintf('%.2f', scan14_ICC(j1,j2));
        if scan14_ICC(j1,j2) <0
             caption = sprintf('  -');
        end
        text(j2-0.35, j1, caption, 'FontSize', 15, 'Color', [0,0,0],'FontWeight','bold');
    end
end
xticks(1:1:5); xticklabels(AxesLabels)
yticks(1:1:5); yticklabels(AxesLabels)
% xtickangle(45);ytickangle(45)
set(gca,'FontSize',20,'FontWeight','bold')
axis square
ylabel('Run 1')
xlabel('Run 4')
% axis off
title(['Run 1 Run 4 ICC '])
C_idx=C_idx+1;
colorbar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(n_rows,n_cols,C_idx)
colormap('Copper')
imagesc(scan23_ICC, [0 1])

for j1 = 1:Smax
    for j2 = 1:Smax
        caption = sprintf('%.2f', scan23_ICC(j1,j2));
        if scan23_ICC(j1,j2) <0
             caption = sprintf('  -');
        end
        text(j2-0.35, j1, caption, 'FontSize', 15, 'Color', [0,0,0],'FontWeight','bold');
    end
end
xticks(1:1:5); xticklabels(AxesLabels)
yticks(1:1:5); yticklabels(AxesLabels)
% xtickangle(45);ytickangle(45)
set(gca,'FontSize',20,'FontWeight','bold')
axis square
ylabel('Run 2')
xlabel('Run 3')
% axis off
title(['Run 2 Run 3 ICC '])
colorbar
C_idx=C_idx+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(n_rows,n_cols,C_idx)
colormap('Copper')
imagesc(scan24_ICC, [0 1])

for j1 = 1:Smax
    for j2 = 1:Smax
        caption = sprintf('%.2f', scan24_ICC(j1,j2));
        if scan24_ICC(j1,j2) <0
             caption = sprintf('  -');
        end
        text(j2-0.35, j1, caption, 'FontSize', 15, 'Color', [0,0,0],'FontWeight','bold');
    end
end
xticks(1:1:5); xticklabels(AxesLabels)
yticks(1:1:5); yticklabels(AxesLabels)
% xtickangle(45);ytickangle(45)
set(gca,'FontSize',20,'FontWeight','bold')
axis square
ylabel('Run 2')
xlabel('Run 4')
% axis off
title(['Run 2 Run 4 ICC '])
colorbar
C_idx=C_idx+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(n_rows,n_cols,C_idx)
colormap('Copper')
imagesc(scan34_ICC, [0 1])

for j1 = 1:Smax
    for j2 = 1:Smax
        caption = sprintf('%.2f', scan34_ICC(j1,j2));
        if scan34_ICC(j1,j2) <0
             caption = sprintf('  -');
        end
        text(j2-0.35, j1, caption, 'FontSize', 15, 'Color', [0,0,0],'FontWeight','bold');
    end
end
xticks(1:1:5); xticklabels(AxesLabels)
yticks(1:1:5); yticklabels(AxesLabels)
set(gca,'FontSize',20,'FontWeight','bold')
axis square
ylabel('Run 3')
xlabel('Run 4')
title(['Run 3 Run 4 ICC '])
colorbar

set(findall(gcf,'-property','FontSize'),'FontSize',20)

sgtitle([PAR ' ICC across runs'],'FontSize',24,'FontWeight','b')
exportgraphics(gcf,['Figures/' PAR '_Scan_reliability_matrix_ALL.tiff']);


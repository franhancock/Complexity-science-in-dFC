function plot_Speed_DFA_AAL116_results
%
% Function to plot an overview of the DFA results obtained with
% LEiDA_Test_linearity
%
%
% Fran Hancock
% July 2021
% fran.hancock@kcl.ac.uk
%
%
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
%

n_rows=2;
n_cols=3;
Rmax=4;


AAL116_results=struct2array(load('/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/IPC_AAL116/linear_results'));
load AAL116_IPC_MODE_GStats_R1R2 'MEAN_SPEED'

% Set up the variables for scatterhistogram
scan1(1:20)=1;
scan2(1:20)=2;
scan3(1:20)=3;
scan4(1:20)=4;


figure

subplot(n_rows,n_cols,[1 n_cols+1])
for run=1:Rmax
    pd=fitdist(squeeze(MEAN_SPEED(run,:))','Kernel');
    x=-0.01:0.0001:0.04;   % for sSPPEDS distributions
    y=pdf(pd,x);
    plot(x,y,'LineWidth',1.5);
    hold on
end

xlabel('V_{dFC}');
ylabel('Probability density V_{dFC}')
legend('Run 1','Run2', 'Run3','Run 4','Location','northwest')

title('GLOBAL Speed')
hold off


subplot(n_rows,n_cols,2)

for Run=1:4
    nonvalid=find(isnan(AAL116_results(Run,:)));
    linear_percent(Run)=(1-(size(nonvalid,2)/size(AAL116_results,2)))*100;
    sem(Run)=std(AAL116_results(Run,:),'omitnan')/(size(AAL116_results,2)-size(nonvalid,2)).^0.5;
    mean_DFA(Run)=mean(AAL116_results(Run,:),'omitnan');
end

b=bar(linear_percent);
b.FaceColor = 'flat';
b.CData(1,:) = [0 0.4470 0.7410];
b.CData(2,:) = [0.8500 0.3250 0.0980];
b.CData(3,:) = [0.9290 0.6940 0.1250];
b.CData(4,:) = [0.4940 0.1840 0.5560];


ytickformat('percentage')
ylabel('% of genuine subjects')
xticklabels({'Run 1','Run 2','Run 3', 'Run 4'})
xtickangle(45)
% title('AAL116')


subplot(n_rows,n_cols,5)
% barwitherr(sem',mean_DFA',1)

scatter(scan1,AAL116_results(1,:))
hold on
scatter(scan2,AAL116_results(2,:))
hold on
scatter(scan3,AAL116_results(3,:))
hold on
scatter(scan4,AAL116_results(4,:))
hold off

xlim([0 5])
xticks([1 2 3 4])
xticklabels({'Run 1','Run 2','Run 3', 'Run 4'})
xtickangle(45)
ylabel(' fGn DFA_\alpha')

subplot(n_rows,n_cols,[3 6])

for run=1:4
    pd=fitdist(AAL116_results(run,:)','Kernel');
    x=0:.01:1; % for DFA distribution
    y=pdf(pd,x);
    plot(x,y,'LineWidth',1.5);

hold on
end

title(['DFA \alpha over 1-4 runs']);
yticklabels([]);
xlabel('DFA  \alpha');
ylabel('Probability density')
xline(0.5,'--k')
legend({'Run 1','Run 2','Run 3', 'Run 4'},'Location','northwest')

% sgtitle('AAL116 IPC DFA_\alpha coefficients for genuine power law scaling')

set(gcf, 'units','normalized','outerposition',[0 0 0.25 .25]);

exportgraphics(gcf,'Figures/Speed_DFA_AAL116_all_scans.jpeg')

disp('wait here');
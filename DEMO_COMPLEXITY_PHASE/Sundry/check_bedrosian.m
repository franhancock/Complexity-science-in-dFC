function check_bedrosian
%
% function to check if the Bedrosian assumptions are violeted 
% for band pass filtering 0.01-0.08 and 0.04-0.07
%
% Pachaud et al., (2014)
% Consequences of non-respect of the Bedrosian theorem when demodulating
%
% Useful bandwidth Bphase =2(modulation index +1)*freq of modulation signal
% Modulation signal = Amplitude of the BOLD signal
%
PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPU100_SUNDRY/';

MAT_FOLDER='/Users/HDF/TESTDATA/HCPU100_AAL116_RL/';

addpath /Users/HDF/Dropbox/Fran/Academics/PhD/Matlab_World/modulationindex/

TR=0.72;
n_rows=3;
n_cols=2;
C_idx=1;

figure

%SUB=input('Enter subject from 1_99: ');
SUB=54;

Data_info=dir([MAT_FOLDER '*Sub*.mat']);

%disp(Data_info(SUB).name)

BOLD=struct2array(load([MAT_FOLDER Data_info(SUB).name]));

for i=1:size(BOLD)
        BOLD(i,:)=detrend(BOLD(i,:));
        ZBOLD(i,:)=BOLD(i,:)-mean(BOLD(i,:));
end

%
% First no band pass filtering
%

% Compute the analytical signal of the BOLD timeseries
%
ANYS_BOLD=mean(hilbert(BOLD),1);
AMPL_SIGN=abs(ANYS_BOLD);
PHASE_SIGN=angle(ANYS_BOLD);
%
% Compute the modulation index
%
ModIdx=modulationIndex(PHASE_SIGN',AMPL_SIGN');

w=size(BOLD,2);
tmax=w*TR;

freqZ = (0:w-1)/tmax;
freqZ = freqZ(1:round(end/2));

FullAutocorrMode=xcorr(ANYS_BOLD);
AutocorrMode=FullAutocorrMode(w:2*w-1);

FullPower = abs(fft(AutocorrMode));
Power = FullPower(:,1:floor(end/2));
[~,peak_p_a]=max(Power);
peak_f_a=freqZ(:,peak_p_a);
useful_bandwidth=2*(ModIdx+1)*peak_f_a;


subplot(n_rows,n_cols,C_idx);
    plot(freqZ(1:round(w/2)),Power(1:round(w/2)),'k','LineWidth',2,'color',[0.6350 0.0780 0.1840]);
    xlim([0.01 0.2]);
    max_txt=[' Max f_m = ' num2str(peak_f_a,'%.3f') ' Hz'];
    yline(max(Power),'--','LineWidth',2,'color',[0.6350 0.0780 0.1840],'label',max_txt,'LabelVerticalAlignment','bottom','labelHorizontalAlignment','center','FontWeight','bold')
    ylabel('Power Spectral Density')
    xlabel('frequency (Hz)')
    title('Modulation - unfiltered')
    C_idx=C_idx+1;
%
% get the min and mean freq of the phase carrier signal
%
FullAutocorrMode=xcorr(PHASE_SIGN);
AutocorrMode=FullAutocorrMode(w:2*w-1);

FullPower = abs(fft(AutocorrMode));
Power = FullPower(:,1:floor(end/2));
[~,low_p_pc]=min(Power);
low_f_pc=freqZ(:,low_p_pc);

subplot(n_rows,n_cols,C_idx);
    plot(freqZ(1:round(w/2)),Power(1:round(w/2)),'k','LineWidth',2,'color',[0.6350 0.0780 0.1840]);
    xlim([0.01 0.2]);
    ylim([2700 4000])
    ax = gca();
    ax.YRuler.Exponent = 3;  
    min_txt=['Min f_p = ' num2str(low_f_pc,'%.3f') ' Hz'];
    yline(min(Power),'--','LineWidth',2,'color',[0.6350 0.0780 0.1840],'label',min_txt,'LabelVerticalAlignment','bottom','labelHorizontalAlignment','center','FontWeight','bold')
    ylabel('Power Spectral Density')
    xlabel('frequency (Hz)')
    title('Carrier - unfiltered')
    C_idx=C_idx+1;

uf_peak_f_a=peak_f_a;
uf_ub=useful_bandwidth;
uf_low_f_p=low_f_pc;
uf_ModIdx=ModIdx;

disp(['Unfiltered: Max freq Amp = ' num2str(peak_f_a,'%.3f') ' Hz Modulation Index = ' num2str(ModIdx,'%.3f') ' Useful Bandwith = ' num2str(useful_bandwidth,'%.3f') ' Hz Lowest phase freq: ' num2str(low_f_pc,'%.3f') ' Hz' ])
 

%%%%%%%%%%%%%%% Band pass high and then low and find their bandwidth %%%%%%%%%%%%%%%%%
            
high_pass=0.01;     % Bands from Glerean but with fast TR
low_pass=0.08;

for n=1:size(BOLD,1)
   FBOLD(n,:)=bandpass(BOLD(n,:),[high_pass low_pass],1/TR);
end

ANYS_BOLD=mean(hilbert(FBOLD),1);
AMPL_SIGN=abs(ANYS_BOLD);
PHASE_SIGN=angle(ANYS_BOLD);
%
% Compute the modulation index
%
ModIdx=modulationIndex(PHASE_SIGN',AMPL_SIGN');

% find the max freq of the amplitude signal
%
FullAutocorrMode=xcorr(ANYS_BOLD);
AutocorrMode=FullAutocorrMode(w:2*w-1);

FullPower = abs(fft(AutocorrMode));
Power = FullPower(:,1:floor(end/2));
[~,peak_p_a]=max(Power);
peak_f_a=freqZ(:,peak_p_a);
useful_bandwidth=2*(ModIdx+1)*peak_f_a;

subplot(n_rows,n_cols,C_idx);
    plot(freqZ(1:round(w/2)),Power(1:round(w/2)),'k','LineWidth',2,'color',[0.4660 0.6740 0.1880]);
    xlim([0.01 0.2]);
    max_txt=['Max f_m = ' num2str(peak_f_a,'%.3f') ' Hz'];
    yline(max(Power),'--','LineWidth',2,'color',[0.4660 0.6740 0.1880],'label',max_txt,'LabelVerticalAlignment','bottom','labelHorizontalAlignment','center','FontWeight','bold')
    ylabel('Power Spectral Density')
    xlabel('frequency (Hz)')

    title('Modulation 0.01-0.08')

    C_idx=C_idx+1;

% find the max freq of the phase signal
%
FullAutocorrMode=xcorr(PHASE_SIGN);
AutocorrMode=FullAutocorrMode(w:2*w-1);

FullPower = abs(fft(AutocorrMode));
Power = FullPower(:,1:floor(end/2));
[~,low_p_pc]=min(Power);
low_f_pc=freqZ(:,low_p_pc);

subplot(n_rows,n_cols,C_idx);
    plot(freqZ(1:round(w/2)),Power(1:round(w/2)),'k','LineWidth',2,'color',[0.4660 0.6740 0.1880]);
    xlim([0.01 0.62]);
    ylim([2800 4000])
    ax = gca();
    ax.YRuler.Exponent = 3;  
    min_txt=['Min f_p = ' num2str(low_f_pc,'%.3f') ' Hz'];
    yline(min(Power),'--','LineWidth',2,'color',[0.4660 0.6740 0.1880],'label',min_txt,'LabelVerticalAlignment','bottom','labelHorizontalAlignment','center','FontWeight','bold')
    ylabel('Power Spectral Density')
    xlabel('frequency (Hz)')
    
    title('Carrier 0.01-0.08')
    C_idx=C_idx+1;
F_peak_f_a=peak_f_a;
F_ub=useful_bandwidth;
F_low_f_p=low_f_pc;
F_ModIdx=ModIdx;

disp(['0.01-0.08 : Max freq Amp = ' num2str(peak_f_a,'%.3f') ' Hz Modulation Index = ' num2str(ModIdx,'%.3f') ' Useful Bandwith = ' num2str(useful_bandwidth,'%.3f') ' Hz Lowest phase freq: ' num2str(low_f_pc,'%.3f') ' Hz' ])


%%%%%%%%%%%%%%% Band pass filter before getting the analtical signal %%%%%%%%%%%%%%%%%
            
high_pass=0.04;     % Bands from Glerean but with fast TR
low_pass=0.07;

for n=1:size(BOLD,1)
   GBOLD(n,:)=bandpass(BOLD(n,:),[high_pass low_pass],1/TR);
end

ANYS_BOLD=mean(hilbert(GBOLD),1);
AMPL_SIGN=abs(ANYS_BOLD);
PHASE_SIGN=angle(ANYS_BOLD);
%
% Compute the modulation index
%
ModIdx=modulationIndex(PHASE_SIGN',AMPL_SIGN');


% find the max freq of the amplitude signal
%
FullAutocorrMode=xcorr(ANYS_BOLD);
AutocorrMode=FullAutocorrMode(w:2*w-1);

FullPower = abs(fft(AutocorrMode));
Power = FullPower(:,1:floor(end/2));
[~,peak_p_a]=max(Power);
peak_f_a=freqZ(:,peak_p_a);
useful_bandwidth=2*(ModIdx+1)*peak_f_a;

subplot(n_rows,n_cols,C_idx);
    plot(freqZ(1:round(w/2)),Power(1:round(w/2)),'k','LineWidth',2,'color',[0 0.4470 0.7410]);
    xlim([0.01 0.2])
    max_txt=['Max f_m = ' num2str(peak_f_a,'%.3f') ' Hz'];
    yline(max(Power),'--','LineWidth',2,'color',[0 0.4470 0.7410],'label',max_txt,'LabelVerticalAlignment','bottom','labelHorizontalAlignment','center','FontWeight','bold')
    title('Modulation 0.04-0.07')
    ylabel('Power Spectral Density')
    xlabel('frequency (Hz)')
    C_idx=C_idx+1;

% find the max freq of the phase signal
%
FullAutocorrMode=xcorr(PHASE_SIGN);
AutocorrMode=FullAutocorrMode(w:2*w-1);

FullPower = abs(fft(AutocorrMode));
Power = FullPower(:,1:floor(end/2));

[~,low_p_pc]=min(Power);
low_f_pc=freqZ(:,low_p_pc);

subplot(n_rows,n_cols,C_idx);
    plot(freqZ(1:round(w/2)),Power(1:round(w/2)),'k','LineWidth',2,'color',[0 0.4470 0.7410]);
    xlim([0.01 0.2]);
    ylim([2800 4000])
    ax = gca();
    ax.YRuler.Exponent = 3;    
    min_txt=['Min f_p = ' num2str(low_f_pc,'%.3f') ' Hz'];
    yline(min(Power),'--','LineWidth',2,'color',[0 0.4470 0.7410],'label',min_txt,'LabelVerticalAlignment','bottom','labelHorizontalAlignment','center','FontWeight','bold')    
    ylabel('Power Spectral Density')
    xlabel('frequency (Hz)')
    title('Carrier 0.04-0.07')
    C_idx=C_idx+1;

G_peak_f_a=peak_f_a;
G_ub=useful_bandwidth;
G_low_f_p=low_f_pc;
G_ModIdx=ModIdx;

disp(['0.04-0.07 : Max freq Amp = ' num2str(peak_f_a,'%.3f') ' Hz Modulation Index = ' num2str(ModIdx,'%.3f') ' Useful Bandwith = ' num2str(useful_bandwidth,'%.3f') ' Hz Lowest phase freq: ' num2str(low_f_pc,'%.3f') ' Hz' ])

save BEDROSIAN uf_ModIdx uf_low_f_p uf_ub uf_peak_f_a F_ModIdx F_low_f_p F_ub F_peak_f_a G_ModIdx G_low_f_p G_ub G_peak_f_a 
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
set(findall(gcf,'-property','FontSize'),'FontSize',30)
saveas(gcf,'Figures/Bedrosian_examples','jpeg')


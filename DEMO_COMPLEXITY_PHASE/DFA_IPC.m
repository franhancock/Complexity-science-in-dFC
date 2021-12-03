function DFA_IPC
%
% Function to calculate the reconfiguration SPEED and fractal scaling
% coefficient alpha from Detrended Fluctuation Analysis computed on the
% Leading Eigenvectors of Phase Locking obtained through LEiDA
% 
%
% Fran Hancock
% fran.hancock@kcl.ac.uk
%
% Adapted from 
% 
% Code contributors:
% Demian Battaglia & Lukas M. Arbabyazd
% 
% Code testing: 
% Demian Battaglia, Lukas M. Arbabyazd, Diego Lombardo
% 
% Project responsibles:
% Demian Battaglia, Viktor Jirsa
% 
% Project consultants:
% Mira Didic, Olivier Blin
%
% Attempt to Use Ton & Daffertshofer code for DFA and model fitting
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
addpath /Users/HDF/Dropbox/Fran/Academics/PhD/Matlab_World/FluctuationAnalysis-master  % DFA tool


Num_subjects=20;

Tmax=1200-2;
Rmax=4;

PAR='AAL116';
linear_results=zeros(Rmax,Num_subjects);

for run=1:Rmax
   
    save_file=([ PAR '_IPC_RW_DFA_RUN' num2str(run)]);
    speeds=struct2array(load([PAR '_IPC_RW_ALL_R' num2str(run)], 'GLOBAL_SPEEDS'));

    %%%%%%%%%%%%%%%%% LR scan %%%%%%%%%%%%%%%

    parfor S=1:Num_subjects
       
        disp(['Calculating for subject ' num2str(S) ' state ' ]);
        y=speeds(S,:)';

        %
        % GLOBAL DFA coefficient
        %
        i=1; % just one test
        duration=Tmax/2;
        s=sprintf('DFA+ for Subject %g', num2str(S));

        fprintf('\nSubject %d: %s\n',S);
%          subplot(1,4,1);
%          pspectrum(y,fs); % this is just for plotting the power spectrum
%          title('power spectrum')

 %       figure;
 %       set(gcf,'Name',s,'Position',[50*i,300-50*i,1024,256]);

        %% convert fGn into fBm (or Gaussian noise into Brownian motion if H=0.5
       y=cumsum(y);    

         %% DFA including (Bayesian) non-parametric model selection - this suits all examples
      %  subplot(1,4,2);
        % define the fitting range

        % fullrange=[12,duration];

        interval2evaluate=[10,duration,20];
        interval2fit=interval2evaluate;   

        % run the analysis (including text & graphics report)
        % [alpha,details]=fluctuationAnalysis(y,interval2evaluate,interval2fit,'DFA+','verbose','graphic');
       [alpha,details]=fluctuationAnalysis(y,interval2evaluate,interval2fit,'DFA+','verbose');

        DFA_alpha=alpha;
        DFA_fluctuations=details.F;
      %  title('DFA+ over full range'); set(gca,'xlim',fullrange); drawnow;

        GLOBAL_DFA(S)=DFA_alpha;
        GLOBAL_FLUC(S,:)=DFA_fluctuations;

    end
        
    Non_Linear=find(isnan(GLOBAL_DFA));
    disp(['Number of non-linear states in all subjects  ' num2str(size(Non_Linear,2))]);
    MEAN_DFA=mean(GLOBAL_DFA,'omitnan');
    disp(MEAN_DFA)
    save( save_file, 'GLOBAL_DFA', 'GLOBAL_FLUC','MEAN_DFA');
    linear_results(run,:)=GLOBAL_DFA;
    clear GLOBAL_MEAN_SPEED
    clear GLOBAL_SPEEDS
    
end

save linear_results linear_results

linear_subjects=find(~isnan(mean(linear_results,1)));
linear_subjects=linear_subjects';
save AAL116_LINEAR_SUBS linear_subjects;

%% helper function for plotting the fft-based power spectrum
function [p,f]=pspectrum(y,fs)
% estimate the 'plain' power specturm using fft
N=size(y,1);
p=abs(fft(y/N)).^2;
nfft=size(y,1);
if rem(nfft,2) % nfft odd
    select = (1:(nfft+1)/2)';
else
    select = (1:nfft/2+1)'; % include DC AND Nyquist
end
% select the first half...
p=p(select,:);
f=(select-1)/(numel(select)-1)*(fs/2);

for k=1:size(p,2) % normalize every power spectrum
    p(:,k)=p(:,k)/trapz(f,p(:,k));
end
% compute the mean over trials
p=mean(p,2,'omitnan');

if nargout==0
    
    loglog(f,mean(p,2),'linewidth',2);

    xmin=floor(log10(min(f(f>0))));
    xmax=ceil(log10(max(f)));
    set(gca,'xlim',10.^[xmin,xmax],'xtick',10.^(xmin:1+((xmax-xmin)>5):xmax));

    grid on;
    if fs~=1, xlabel('f [Hz]'); else, xlabel('1/n'); end
    ylabel('p');

end



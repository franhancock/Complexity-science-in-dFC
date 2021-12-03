function Compute_IPC

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Compute the instantaneous phase locking (cosine phase diff)
% Save the matrices
%
% NOTE: You may have to run each run separately as the 2 large files
% Time_sessions and IPC_all do not seem to clear from memory despite
% calling 'clear'
%
% Fran Hancock
% Sept 2021
% fran.hancock@kcl.ac.uk
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
%
global  HCP_MAT_DATA;


% USER: ADJUST THIS SECTION TO YOUR DATASET
N_areas = 116; % Number of brain areas to consider from parcellation
Tmax=1200; % Number of TRs per scan (if different in each scan, set maximum)
TR=0.72;
Rmax=4;

N_subjects=20;
IPC_all=zeros(N_subjects*(Tmax-2),N_areas,N_areas); % 

for run=1:Rmax
    switch run
	    case 1
		    MAT_FOLDER = [HCP_MAT_DATA '_R1/'];
	    case 2
		    MAT_FOLDER = [HCP_MAT_DATA '_R2/'];
	    case 3
		    MAT_FOLDER = [HCP_MAT_DATA '_R3/'];
	    case 4
		    MAT_FOLDER = [HCP_MAT_DATA '_R4/'];
    end

	 save_file=(['LEiDA_IPC_RUN' num2str(run)]);

    %
    % Create empty variables to save patterns 
    % Define total number of scans that will be read
    Data_info=dir([MAT_FOLDER '*Sub*.mat']);
    total_scans=size(Data_info,1);
    
    Time_sessions=zeros(1,total_scans*(Tmax-2)); % to know the scan number 
    t_all=0; % Index of time (starts at 0 and will be updated until n_Sub*(Tmax-2)) - flh this was missing
    
    for sub=1:total_scans
        
        disp(Data_info(sub).name)
        
        % load BOLD signals in each scan
        signal = struct2array(load([MAT_FOLDER Data_info(sub).name]));
        
        %%%%%%%%%%%%%%% Band pass filter before getting the analtical signal %%%%%%%%%%%%%%%%%
        
        high_pass=0.01;     % Bands from Glerean but with fast TR
        low_pass=0.08;
    
        for n=1:size(signal,1)
            signal(n,:)=bandpass(signal(n,:),[high_pass low_pass],1/TR);
        end
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Get the BOLD phase using the Hilbert transform
        % save with the same name to save RAM space
        for seed=1:N_areas
            %ts=detrend(signal(seed,:)-mean(signal(seed,:)));
            ts=signal(seed,:);
            signal(seed,:) = angle(hilbert(ts));
        end

        for t=2:size(signal,2)-1

            iPC=cos(signal(:,t)-signal(:,t)');

            t_all=t_all+1;
            IPC_all(t_all,:,:)=iPC;
            Time_sessions(t_all)=sub;
        end
    end

    save(save_file,'IPC_all','Time_sessions','-v7.3') % cause its gonna be a really big file
    clear IPC_all
    clear Time_sessions
    disp(['IPC saved successfully as ' save_file])
    pause(5)
end

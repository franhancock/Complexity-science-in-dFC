function LEiDA_data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LEADING EIGENVECTOR DYNAMICS ANALYSIS
%
% This function preprocesses DMT  datasets for LEiDA
%
% - Reads the BOLD data from the folders
% - Computes the BOLD phases
% - Calculates the instantaneous BOLD synchronization matrix
% - Saves the instantaneous Leading Eigenvectors
%
% Saves the Leading_Eigenvectors and FCD matrices into LEiDA_data.mat
%
% Written by Joana Cabral, May 2016 (joanacabral@med.uminho.pt)
% Modified by Joana Cabral, November 2020
% Modified by Fran Hancock, November 2021
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N_areas = 116; % Number of brain areas to consider from parcellation
Tmax=1200; % Number of TRs per scan (if different in each scan, set maximum)
TR=0.72;
Rmax=4;
global HCP_MAT_DATA;

save_file='LEiDA_EigenVectors';

for run=1:Rmax

	switch run
	    case 1
		    MAT_FOLDER = [HCP_MAT_DATA '_R1/'];
		    status=mkdir('RUN1');
		    VEC_FOLDER='RUN1/';
	    case 2
		    MAT_FOLDER = [HCP_MAT_DATA '_R2/'];
		    status=mkdir('RUN2');
		    VEC_FOLDER='RUN2/';
    
	    case 3
		    MAT_FOLDER = [HCP_MAT_DATA '_R3/'];
		    status=mkdir('RUN3');
		    VEC_FOLDER='RUN3/';
	    case 4
		    MAT_FOLDER = [HCP_MAT_DATA '_R4/'];
		    status=mkdir('RUN4');
		    VEC_FOLDER='RUN4/';
	    end	
	
        %
        % Create empty variables to save patterns 
        % Define total number of scans that will be read
        Data_info=dir([MAT_FOLDER '*Sub*.mat']);
        total_scans=size(Data_info,1);
        
        V1_all=zeros(total_scans*(Tmax-2),N_areas); % Alerady in shape for the kmeans
        Time_sessions=zeros(1,total_scans*(Tmax-2)); % to know the scan number 
        t_all=0; % Index of time (starts at 0 and will be updated until n_Sub*(Tmax-2)) - flh this was missing
        
        for s=1:total_scans
            
            disp(Data_info(s).name)
            
            % load BOLD signals in each scan
            signal = struct2array(load([MAT_FOLDER Data_info(s).name]));
            
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
                
                [v1,~]=eigs(cos(signal(:,t)-signal(:,t)'),1);
                
                if sum(v1)>0
                    v1=-v1;
                end
                
                t_all=t_all+1;
                V1_all(t_all,:)=v1;
                Time_sessions(t_all)=s;
            end
        end
        
        
        % Reduce size in case some scans have less TRs than Tmax
        V1_all(t_all+1:end,:)=[];
        Time_sessions(:,t_all+1:end)=[];
        
        save([VEC_FOLDER save_file],'V1_all','Time_sessions')

        disp(['BOLD Phase Eigenvectors saved successfully as ' VEC_FOLDER save_file])
end
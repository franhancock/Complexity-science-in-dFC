function LEiDA_RW_states
%
% Function to investigate the speed, complexity and randomness of
% the individual LEiDA States
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
addpath /Users/HDF/Dropbox/Fran/Academics/PhD/Matlab_World/dFCwalk-main  % dFC random walk toolbox


Smax=5;
Cmax=Smax-1;
Tmax=1200-2;
Num_subjects=20;  

Rmax=4;
PAR='AAL116';
N_areas=116;
LEiDA_stream_3D=zeros(N_areas,N_areas,Tmax);

Proj_folder='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/';
Save_folder = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/IPC_AAL116/';

% load(['/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/LEiDA_2021_' PAR '_HCPUN100/LEiDA_Eigenvectors.mat']);
for run=1:4
    	switch run
	    case 1
		    MET_FOLDER='RUN1/';
	    case 2
		    MET_FOLDER='RUN2/';    
	    case 3
		    MET_FOLDER='RUN3/';
	    case 4
		    MET_FOLDER='RUN4/';
	    end	
	
        load([MET_FOLDER 'LEiDA_Kmeans_results'],'Kmeans_results')
    
    load(['LEiDA_IPC_RUN' num2str(run)])
    save_file=([PAR '_IPC_STATES_RUN' num2str(run)]);
    
   
    for S=1:Num_subjects
        disp(['Subject ' num2str(S)])
        for Cluster=1:Cmax

            N_states=Cluster+1;
            Centroids=Kmeans_results{Cluster}.C;

            for state=1:N_states

                % disp(['Doing cluster ' num2str(Cluster) '_and state ' num2str(state)])
                % get only the regions with positive centroids
                if state==1     % this is the global state and will have all negatives - it also returns the GLOBAL metrics

                    [~, ind_state]=find(Centroids(state,:));   % get the parcel index of positive eigenvectors

                else
                    [~, ind_state]=find(Centroids(state,:)>0);   % get the parcel index of positive eigenvectors
                end
                %
                % create the dFC Matrix for this subject
                %
                IPC_sub=zeros(Tmax,numel(ind_state),numel(ind_state));
                IPC_sub(:,:,:)=IPC_all(Time_sessions==S,ind_state,ind_state,:);


     %           LEiDA_V=IPC_all(Time_sessions==S,ind_state);
                LEiDA_stream_3D=zeros(numel(ind_state), numel(ind_state),Tmax);

                for t=1:Tmax
                    LEiDA_stream_3D(:,:,t)=IPC_sub(t,:,:);
                end
                LEiDA_stream_3D=squeeze(LEiDA_stream_3D);

                if size(LEiDA_stream_3D,3)==1  % cover the case where a state contains only one region/ICN
                    typSpeeds=0;
                    Speeds=0;
                else

                    LEiDA_stream_2D=Matrix2Vec(LEiDA_stream_3D);

                    [typSpeeds, Speeds] =dFC_Speeds(LEiDA_stream_2D);

                    SPEEDS(S,Cluster,state,:)=Speeds;
                    MEAN_SPEED(S,Cluster,state)=typSpeeds;

                end
            end
        end
    end
    save( save_file, 'SPEEDS', 'MEAN_SPEED');
    clear IPC_all
    clear Time_sessions
end


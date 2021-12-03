function LEiDA_RW_GLOBAL
%
% Function to calculate the reconfiguration SPEED  computed on the
% IPC of Phase Locking 
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
%
% Fran Hancock
% Sept 2021
% fran.hancock@kcl.ac.uk
%
%
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
%

addpath /Users/HDF/Dropbox/Fran/Academics/PhD/Matlab_World/dFCwalk-main  % dFC random walk toolbox

Num_subjects=20;  % 
Tmax=1200-2;
Rmax=4;


PAR='AAL116';
N_areas=116;

    
for run=3:Rmax

    save_file=([PAR '_IPC_RW_ALL_R' num2str(run) ]);
    LEiDA_stream_3D=zeros(N_areas,N_areas,Tmax);
    load([ 'LEiDA_IPC_RUN' num2str(run)])    

    for S=1:Num_subjects

        disp(['Calculating for subject ' num2str(S)]);

        %
        % GLOBAL SPEED OF RECONFIGURATION
        %

        IPC_sub(:,:,:)=squeeze(IPC_all(Time_sessions==S,:,:,:));
        for t=1:Tmax
            LEiDA_stream_3D(:,:,t)=IPC_sub(t,:,:);
        end

        LEiDA_stream_2D=Matrix2Vec(LEiDA_stream_3D);

        [typSpeeds, Speeds] =dFC_Speeds(LEiDA_stream_2D);

        GLOBAL_MEAN_SPEED(S)=typSpeeds;
        GLOBAL_SPEEDS(S,:)= Speeds;
    end
    clear IPC_all
    clear Time_sessions
    save( save_file, 'GLOBAL_MEAN_SPEED', 'GLOBAL_SPEEDS');
end




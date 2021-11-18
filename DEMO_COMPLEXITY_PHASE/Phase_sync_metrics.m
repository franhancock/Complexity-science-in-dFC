function Phase_sync_metrics


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LEADING EIGENVECTOR DYNAMICS ANALYSIS
%
%
% Function to compute the Kuramoto order parameter, Synchronisation, and
% Metastability when state is dominant derived from LAU LEiDA
% anaysis for all subjects
%
%
% Fran Hancock
% Nov 2021
% fran.hancock@kcl.ac.uk
%
%
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
%
global  HCP_MAT_DATA;

Tmax=1200; % Number of TRs per scan (if different in each scan, set maximum) first and last scan removed
TR=0.72;
N_areas=116; % LAU parcellation

Smax=5;
Cmax=Smax-1;
Rmax=4;

% cThreshold=0.8; % Coalition threshold
cThreshold=0.8; % Coalition threshold

for run=1:Rmax

	switch run
	    case 1
		    MAT_FOLDER = [HCP_MAT_DATA '_R1/'];
		    MET_FOLDER='RUN1/';
	    case 2
		    MAT_FOLDER = [HCP_MAT_DATA '_R2/'];
		    MET_FOLDER='RUN2/';
    
	    case 3
		    MAT_FOLDER = [HCP_MAT_DATA '_R3/'];
		    MET_FOLDER='RUN3/';
	    case 4
		    MAT_FOLDER = [HCP_MAT_DATA '_R4/'];
		    MET_FOLDER='RUN4/';
	    end	
	
        load([MET_FOLDER 'LEiDA_Kmeans_results'],'Kmeans_results')
        %
        % Create empty variables to save patterns 
        % Define total number of scans that will be read
        Data_info=dir([MAT_FOLDER '*Sub*.mat']);
        total_scans=size(Data_info,1);
        
        V1_all=zeros(total_scans*(Tmax-2),N_areas); % Alerady in shape for the kmeans
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
 
            %
            % calculate the KOP metrics for this subject
            % 

            % discard first and last signals
            tsignal(:,:)=signal(:,2:Tmax-1);
            for Cluster=1:Cmax
        
                Centroids=Kmeans_results{Cluster}.C;
                state_idx=Kmeans_results{Cluster}.IDX(Time_sessions==sub);
                Smax=size(Centroids,1);
        
                for state=1:Smax
                    % get only the regions with positive centroids
                    if state==1     % this is the global state and will have all negatives 
        
                        [~, ind_state]=find(Centroids(state,:));  
        
                    else
                        [~, ind_state]=find(Centroids(state,:)>0);   % get the parcel index of positive eigenvectors
                    end
        
        
                    ICN_OP(sub,state,:) = abs(sum(exp(1i*tsignal(ind_state,:)))/(numel(ind_state))); % abs(mean(sum of e itheta(t)))
                    ICN_PHASE(sub,state,:)=angle(sum(exp(1i*tsignal(ind_state,:))))/(numel(ind_state));
                    ICN_CC(sub,state,:)=ICN_OP(sub,state,:)>cThreshold; % Coalition configuration
                    
                    RSN_META(sub,state) = std(ICN_OP(sub,state,:));
                    RSN_SYNC(sub,state) = mean(ICN_OP(sub,state,:));  % mean for the state over time  

                    ICN_OP_ALL(sub,1:state,Cluster,:)=ICN_OP(sub,1:state,:);
                    ICN_PHASE_ALL(sub,1:state,Cluster,:)=ICN_PHASE(sub,1:state,:);
                    ICN_CC_ALL(sub,1:state,Cluster,:)=ICN_CC(sub,1:state,:);
                  
                    RSN_META_ALL(sub,1:state,Cluster)=RSN_META(sub,1:state);
                    RSN_SYNC_ALL(sub,1:state,Cluster)=RSN_SYNC(sub,1:state);
                
                end 

            end  
     
           %
           % now calculate CHI across the communities
           % 
           for t=1:Tmax-2
               ICN_CHI(sub,t,:)= var(ICN_OP_ALL(sub,:,Cmax,t)); % CHI index of the mean of this value
           end
           GLOBAL_CHI(sub,:)=mean(ICN_CHI(sub,:,:),2);
           
           %
           % now calculate the Instantaneous Phase coherence across communities
           % Wildie & Shanahan (2012)
           for t=1:Tmax-2
               ThresPhase=squeeze(ICN_CC_ALL(sub,:,Cmax,:)).*squeeze(ICN_PHASE_ALL(sub,:,Cmax,:));
               Pidx=find(ThresPhase(:,t));
               aboveThresh=size(Pidx,1);
               if aboveThresh==0
                   aboveThresh=1; % replace the NANs with zeros
               end
               if aboveThresh>1 % ie there is more than just one communitiy with high SYNC
                   INST_PCC(sub,t,:)=(abs(sum(exp(1i*ThresPhase(Pidx,t))))/aboveThresh); 
               else
                   INST_PCC(sub,t,:)=0; 
               end         
               end
           GLOBAL_PCC(sub,:)=mean(INST_PCC(sub,:,:),2);
           
           % Now calculate coalition entropy over the 2^5 possible coalitions
           
    
            CC=squeeze(ICN_CC_ALL(sub,:,Cmax,:));
    
            N_coal=size(CC,1); % number of communities
            N_time=size(CC,2); % number of timepoints
    
            all_coalitions=dec2bin(0:2^N_coal-1)' - '0';
    
            coal_prob=zeros(2^N_coal,1);
    
            for c=1:2^N_coal
                c_found=0;
                for t=1:N_time
                    c_idx=strfind(all_coalitions(:,c)',CC(:,t)');
                    if c_idx==1
                        c_found=c_found+1;
                    end
                end
                coal_prob(c,:)=c_found/N_time;
            end
    
            GLOBAL_CE(sub,:)=-sum(coal_prob(:).*log2(coal_prob(:)),'omitnan');

        end


        save([MET_FOLDER 'LEiDA_KOP_ALL_RUN' num2str(run) ], 'GLOBAL_CE',...
            'RSN_META_ALL', 'RSN_SYNC_ALL','GLOBAL_CHI','GLOBAL_CE','GLOBAL_PCC',...
            'ICN_OP_ALL','INST_PCC','ICN_CC_ALL','ICN_CHI');
         
        disp(['Kuramoto results saved successfully in ' MET_FOLDER ' as ' 'LEiDA_KOP_ALL_RUN' num2str(run)])

end
%%%%%%%%%%


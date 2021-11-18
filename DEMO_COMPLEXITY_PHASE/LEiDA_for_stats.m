function LEiDA_for_stats

%%%%%%%
%  
%  Code to analyze the LEiDA clustering results 
%  Calculates the occupancy of and Lifetimes of Clusters obtained for each K
%
%%%%%%%

Rmax=4;
Tmax = 1200;  
TR = 0.72;  

for run=1:Rmax

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
       
    load([MET_FOLDER 'LEiDA_Kmeans_results'],'Kmeans_results','rangeK')
    load([MET_FOLDER 'LEiDA_EigenVectors'],'Time_sessions')

    save_file = 'LEiDA_for_stats';

    n_Subjects=max(Time_sessions(:));
    
     %% Calculate the Occurrence and Lifetime of each state
                
    % For every fMRI scan calculate probability and lifetimes of each state c.
    P=zeros(n_Subjects,length(rangeK),rangeK(end));
    LT=zeros(n_Subjects,length(rangeK),rangeK(end));
    
    for k=1:length(rangeK)
        for s=1:n_Subjects
            
            % Select the time points representing this subject and task
            %T=(Time_all==s);        % this is an error flh
            T=(Time_sessions==s);
            Ctime=Kmeans_results{k}.IDX(T);
            
            for c=1:rangeK(k)
                % Probability
                P(s,k,c)=mean(Ctime==c);
                
                % Mean Lifetime
                Ctime_bin=Ctime==c;
                
                % Detect switches in and out of this state
                a=find(diff(Ctime_bin)==1);
                b=find(diff(Ctime_bin)==-1);
                
                % We discard the cases where state sarts or ends ON
                if length(b)>length(a)
                    b(1)=[];
                elseif length(a)>length(b)
                    a(end)=[];
                elseif  ~isempty(a) && ~isempty(b) && a(1)>b(1)
                    b(1)=[];
                    a(end)=[];
                end
                if ~isempty(a) && ~isempty(b)
                    C_Durations=b-a;
                else
                    C_Durations=0;
                end
                LT(s,k,c)=mean(C_Durations)*TR;
            end               
        end
    end
        
    save([MET_FOLDER save_file],'P','LT')
end

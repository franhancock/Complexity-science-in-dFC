function Sig_RAnova_Metrics
% Function to extract and store significant p for the metric across all 4 scans in 3 parcellations
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
% NOTE 
%

Mmax=5; % number of metrics
Smax=5;

metrics={'OCC','DURA','META','SYNC','SPEED'};

PAR='AAL116';
    
stats=load([PAR '_RANOVA_STATES']);
stats=stats.stats;

fprintf('\n------------------------------%s-----------------------------------------------------------------------',PAR)

for m=1:Mmax
    for s=1:Smax
       if  stats(m,s,4)< 0.05 % p values
            sig_stats(m,s,1)=stats(m,s,1); % df1
            sig_stats(m,s,2)=stats(m,s,2); % df2
            sig_stats(m,s,3)=stats(m,s,3); % F
            sig_stats(m,s,4)=stats(m,s,4); % p-value
            
            % values for fprintf
            met=string(metrics(m));

            df1=sig_stats(m,s,1);
            df2= sig_stats(m,s,2);
            F=sig_stats(m,s,3);
            p=sig_stats(m,s,4);
            
            if stats(m,s,5)<0.05
               GG='G-G corrected';
               fprintf('\nSignificant difference for %s in state %i F(%i,%i) =% .3f, p-value = %.3f, %s', met,s,df1,df2,F,p,GG)
            else             
               fprintf('\nSignificant difference for %s in state %i F(%i,%i) = %.3f, p-value = %.3f', met,s,df1,df2,F,p)
            end
          
       end 
    end
    
    fprintf('\n--------------------------------------------------------------------------------------------------------------')
end
        
save([PAR '_SIG_STATES_RM'], 'sig_stats')
  



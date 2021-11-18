function Compute_PHI
%
% Function to calculate the PhiID and PhiIDR
%
%
% Code provided by
%
% Pedro Mediano
% pam83@cam.ac.uk
% 
% 
% Mediano, P. A. M., Rosas, F. E., Farah, J. C., Shanahan, M., Bor, D., & Barrett, A. B. (2021). 
% Integrated information as a common signature of dynamical and information-processing complexity. 
% ArXiv:2106.10211 [Nlin, q-Bio]. http://arxiv.org/abs/2106.10211
%
%
% Fran Hancock
% Sept 2021
% fran.hancock@kcl.ac.uk
%
%
%%%%%%%
%

addpath /Users/HDF/Dropbox/Fran/Academics/PhD/Matlab_World/PhiID  % PHI toolbox
Smax=5;
Cmax=Smax-1;
Rmax=4;
n_subs=20;

TAUmax=550;


% load in the coalition configurations for all subjects
for run=1:Rmax
    CC_RUN(run,:,:,:,:)=struct2array(load(['RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'ICN_CC_ALL'));
end

for run=1:4
% try just for 1 subject
    for sub=1:n_subs
        disp(['Computing PHI for ' num2str(sub)])
        
        X=squeeze(CC_RUN(run,sub,:,Cmax,:));
        
        for tau=1:TAUmax
            
            A = PhiIDFullDiscrete(X, tau, 'MMI');

            phiCalc = infodynamics.measures.discrete.IntegratedInformationCalculatorDiscrete(2, Smax);
            phiCalc.setProperty('TAU', num2str(tau));
            phiCalc.initialise();
            phiCalc.setObservations(X');
            wmsphi = phiCalc.computeAverageLocalOfObservations();

            % Bias correction code
            mib = phiCalc.getMinimumInformationPartition();
            p1 = str2num(mib.get(0).toString()) + 1;
            p2 = str2num(mib.get(1).toString()) + 1;
            C = PTCorrection(X(:,1:end-tau), X(:,1+tau:end)) - PTCorrection(X(p1,1:end-tau), X(p1,1+tau:end)) - PTCorrection(X(p2,1:end-tau), X(p2,1+tau:end));            
            %%%%%%%%%%
            
            phir = wmsphi + A.rtr - C; % makes the correction
            FIDO(tau)=phir;
        end
        TAU(run,sub,:) =max(FIDO);
    end
end
save 'TAU' TAU




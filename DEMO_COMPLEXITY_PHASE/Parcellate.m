function Parcellate

%
% Function to 
% - Load BOLD data in MNI space
% - Load the AAL template
%
% Origianl code
% Joana Cabral 
% joana.cabral@med.uminho.pt
%
% Adapted Fran Hancock
% fran.hancock@kcl.ac.uk
%
% November 2021
%
%%%%%%%

global HCP_DATA HCP_MAT_DATA;

Parcellation='AAL116';
PAR='AAL116';

N_areas=116;
Rmax = 4; % number of fMRI runs
          
for run=1:Rmax
    switch run
        case 1
            status=mkdir([HCP_MAT_DATA '_R' num2str(run)]); % make the new directory
            save_folder=[HCP_MAT_DATA '_R' num2str(run) '/'];

            % Get the subject directory list
            names=dir([HCP_DATA '_RL/sub-*']);
            n_Subjects=size(names,1);

            V_Parcel=struct2array(load('ParcelsMNI2mm',['V_' Parcellation])); 
            sz=size(V_Parcel);
    
            for s=1:n_Subjects
               
                    file=dir([HCP_DATA '_RL/' names(s).name '/rfMRI_REST1_RL_hp2000_clean.nii.gz']);
                    if size(file,1)
                        
                        disp([' - Subject ' names(s).name])
                        disp([file.folder '/' file.name]);
                        
                        BOLD_MNI=niftiread([file.folder '/' file.name]);
                        T=size(BOLD_MNI,4);
            
                        BOLD_AAL=zeros(N_areas,T);
            
                        for n=1:N_areas
            
                            ind_voxels=find(V_Parcel==n);
            
                            for v=1:numel(ind_voxels)
                                [I1,I2,I3] = ind2sub(sz,ind_voxels(v));
                                
                                if ~isnan(BOLD_MNI(I1,I2,I3,1))
                                        BOLD_AAL(n,:)= BOLD_AAL(n,:) + squeeze(BOLD_MNI(I1,I2,I3,:))';
                               
                                end
                            end
                            BOLD_AAL(n,:)= BOLD_AAL(n,:)/numel(ind_voxels);
                            BOLD_AAL(n,:)=BOLD_AAL(n,:)-mean(BOLD_AAL(n,:));
            
                        end
                        save([save_folder names(s).name],'BOLD_AAL')
                        disp(s);
                    end              
            end

        case 2
            status=mkdir([HCP_MAT_DATA '_R' num2str(run)]); % make the new directory
            save_folder=[HCP_MAT_DATA '_R' num2str(run) '/'];

            % Get the subject directory list
            names=dir([HCP_DATA '/sub-*']);
            n_Subjects=size(names,1);

            V_Parcel=struct2array(load('ParcelsMNI2mm',['V_' Parcellation])); 
            sz=size(V_Parcel);
    
            for s=1:n_Subjects
               
                    file=dir([HCP_DATA '/' names(s).name '/rfMRI_REST1_LR_hp2000_clean.nii.gz']);
                    if size(file,1)
                        
                        disp([' - Subject ' names(s).name])
                        disp([file.folder '/' file.name]);
                        
                        BOLD_MNI=niftiread([file.folder '/' file.name]);
                        T=size(BOLD_MNI,4);
            
                        BOLD_AAL=zeros(N_areas,T);
            
                        for n=1:N_areas
            
                            ind_voxels=find(V_Parcel==n);
            
                            for v=1:numel(ind_voxels)
                                [I1,I2,I3] = ind2sub(sz,ind_voxels(v));
                                
                                if ~isnan(BOLD_MNI(I1,I2,I3,1))
                                        BOLD_AAL(n,:)= BOLD_AAL(n,:) + squeeze(BOLD_MNI(I1,I2,I3,:))';
                               
                                end
                            end
                            BOLD_AAL(n,:)= BOLD_AAL(n,:)/numel(ind_voxels);
                            BOLD_AAL(n,:)=BOLD_AAL(n,:)-mean(BOLD_AAL(n,:));
            
                        end
                        save([save_folder names(s).name],'BOLD_AAL')
                        disp(s);
                    end              
            end
        case 3
            status=mkdir([HCP_MAT_DATA '_R' num2str(run)]); % make the new directory
            save_folder=[HCP_MAT_DATA '_R' num2str(run) '/'];

            % Get the subject directory list
            names=dir([HCP_DATA '_LR_D2/sub-*']);
            n_Subjects=size(names,1);

            V_Parcel=struct2array(load('ParcelsMNI2mm',['V_' Parcellation])); 
            sz=size(V_Parcel);
    
            for s=1:n_Subjects
               
                    file=dir([HCP_DATA '_LR_D2/' names(s).name '/rfMRI_REST2_LR_hp2000_clean.nii.gz']);
                    if size(file,1)
                        
                        disp([' - Subject ' names(s).name])
                        disp([file.folder '/' file.name]);
                        
                        BOLD_MNI=niftiread([file.folder '/' file.name]);
                        T=size(BOLD_MNI,4);
            
                        BOLD_AAL=zeros(N_areas,T);
            
                        for n=1:N_areas
            
                            ind_voxels=find(V_Parcel==n);
            
                            for v=1:numel(ind_voxels)
                                [I1,I2,I3] = ind2sub(sz,ind_voxels(v));
                                
                                if ~isnan(BOLD_MNI(I1,I2,I3,1))
                                        BOLD_AAL(n,:)= BOLD_AAL(n,:) + squeeze(BOLD_MNI(I1,I2,I3,:))';
                               
                                end
                            end
                            BOLD_AAL(n,:)= BOLD_AAL(n,:)/numel(ind_voxels);
                            BOLD_AAL(n,:)=BOLD_AAL(n,:)-mean(BOLD_AAL(n,:));
            
                        end
                        save([save_folder names(s).name],'BOLD_AAL')
                        disp(s);
                    end              
            end

        case 4
           
            status=mkdir([HCP_MAT_DATA '_R' num2str(run)]); % make the new directory
            save_folder=[HCP_MAT_DATA '_R' num2str(run) '/'];

            % Get the subject directory list
            names=dir([HCP_DATA '_RL_D2/sub-*']);
            n_Subjects=size(names,1);

            V_Parcel=struct2array(load('ParcelsMNI2mm',['V_' Parcellation])); 
            sz=size(V_Parcel);
    
            for s=1:n_Subjects
               
                    file=dir([HCP_DATA '_RL_D2/' names(s).name '/rfMRI_REST2_RL_hp2000_clean.nii.gz']);
                    if size(file,1)
                        
                        disp([' - Subject ' names(s).name])
                        disp([file.folder '/' file.name]);
                        
                        BOLD_MNI=niftiread([file.folder '/' file.name]);
                        T=size(BOLD_MNI,4);
            
                        BOLD_AAL=zeros(N_areas,T);
            
                        for n=1:N_areas
            
                            ind_voxels=find(V_Parcel==n);
            
                            for v=1:numel(ind_voxels)
                                [I1,I2,I3] = ind2sub(sz,ind_voxels(v));
                                
                                if ~isnan(BOLD_MNI(I1,I2,I3,1))
                                        BOLD_AAL(n,:)= BOLD_AAL(n,:) + squeeze(BOLD_MNI(I1,I2,I3,:))';
                               
                                end
                            end
                            BOLD_AAL(n,:)= BOLD_AAL(n,:)/numel(ind_voxels);
                            BOLD_AAL(n,:)=BOLD_AAL(n,:)-mean(BOLD_AAL(n,:));
            
                        end
                        save([save_folder names(s).name],'BOLD_AAL')
                        disp(s);
                    end              
            end
    end
end

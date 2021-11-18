function plot_nodes_in_cortex_AAL116 (V)


%
% Set up the paths to static data, functions and libraries
%
addpath('/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/', genpath('/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/functions'), '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/static_data','/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/libraries');
savepath /Users/HDF/Documents/MATLAB/pathdef.m

static_path='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/static_data/';

hold on

% % PLOT CORTEX

Brain_Mask=niftiread([static_path 'MNI152_T1_2mm_brain_mask.nii']);
scortex=smooth3(Brain_Mask>0);
% First plot a transparent cortex
cortexpatch=patch(isosurface(scortex,0.1), 'FaceColor', [0.9 0.9 0.9], 'EdgeColor', 'none','FaceAlpha', 0.2);
reducepatch(cortexpatch,0.01);
isonormals(scortex,cortexpatch);

% PLOT NODES

% % Rescale V such that it ranges between -1 and 1
% V=V-min(V);
% V=2*(V/max(V));
% V=V-1;

V=V/max(abs(V));
V=round(V*100)/100; 

% center origin
ori=[65 45.5 35];

%load aalCOG2.txt - original but I don't have the file
load aal116_cog.txt
scale=5.5;
MNI_coord=scale*(aal116_cog/10);
clear aal116_cog

a=2.5;
[x,y,z] = sphere;
x=a*x;
y=a*y;
z=a*z;

ax1=gca;
colormap(ax1,jet)

ind_color=-1:0.01:1;
cmap=jet(numel(ind_color));

for n=1:length(V)
        surf(x+MNI_coord(n,2)+ori(1), y+MNI_coord(n,1)+ori(2),z+MNI_coord(n,3)+ori(3),'FaceColor',cmap(find(abs(ind_color-V(n))<0.01,1),:),'EdgeColor','none','FaceAlpha',0.7);
end
  
n_strong=find(V>0);
if numel(n_strong)>1
    u=1;
    
    for a=1:numel(n_strong)
        n=n_strong(a);
        for b=1:a
            p=n_strong(b);
            c1=[MNI_coord(n,2)+ori(1) MNI_coord(n,1)+ori(2) MNI_coord(n,3)+ori(3)];
            c2=[MNI_coord(p,2)+ori(1) MNI_coord(p,1)+ori(2) MNI_coord(p,3)+ori(3)];
            
            plot3([c1(1) c2(1)],[c1(2) c2(2)],[c1(3) c2(3)],'Color',[1 0.3 0.3]); %cmap(find(ind_colormap-(V(n)+V(p))/2>0,1),:)); 
            u=u+1;
        end
    end
end


% -------------------------------------------------------
% Setting image properties - light, material, angle
% -------------------------------------------------------
 
material dull
lighting gouraud
% Top view
%view(-90,90)
view(0,0)   % Side view
daspect([1 1 1])
camlight;
xlim([5 105])
ylim([5 85])
zlim([10 80])
axis off
axis equal
end


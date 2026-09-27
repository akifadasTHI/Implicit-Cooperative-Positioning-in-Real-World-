clc, clear, close all

% Upload GT object locations
pole_pos_gt = [45.50108154,  9.156037072,   173.1174671;
               45.50109129,	 9.156006105,   173.1543851;
               45.50110545,  9.156031612,	173.175395;
               45.50111518,	 9.155996097,	173.2422273;
               45.50113067,	 9.156019368,	173.2507174];

% Upload GT vehicle locations (w/ RTK)
load("C:\Users\akifa\OneDrive\Masaüstü\PhD\SPOKE9\Projects\C_ICP\Codes\nodes\_swiftnav_front_gps_pose.mat"); % gt of EZ
veh_gt_ez = data;

load("C:\Users\akifa\OneDrive\Masaüstü\PhD\SPOKE9\Projects\C_ICP\Codes\nodes\_swiftnav_rtk_gps_pose.mat"); % gt of B5
veh_gt_b5 = data;

% Upload measured vehicle locations
load("C:\Users\akifa\OneDrive\Masaüstü\PhD\SPOKE9\Projects\C_ICP\Codes\nodes\_swiftnav_no_gps_pose.mat"); % gt of B5
veh_meas_b5 = data;

load("C:\Users\akifa\OneDrive\Masaüstü\PhD\SPOKE9\Projects\C_ICP\Codes\nodes\_swiftnav_nicoli_gps_pose.mat"); % gt of B5
veh_meas_ez = data;

% Synchronize Measurements
time_meas_ez = [veh_meas_ez(:,5)+ veh_meas_ez(:,6)*1e-9, veh_meas_ez(:,1)];
time_meas_b5 = [veh_meas_b5(:,5)+ veh_meas_b5(:,6)*1e-9, veh_meas_b5(:,1)];
time_gt_ez = [veh_gt_ez(:,5)+ veh_gt_ez(:,6)*1e-9, veh_gt_ez(:,1)];
time_gt_b5 = [veh_gt_b5(:,5)+ veh_gt_b5(:,6)*1e-9, veh_gt_b5(:,1)];
[startTime, indStart]= max([time_meas_ez(1,1), time_meas_b5(1,1), time_gt_ez(1,1), time_gt_b5(1,1)]);
[EndTime, indEnd]= min([time_meas_ez(end,1), time_meas_b5(end,1), time_gt_ez(end,1), time_gt_b5(end,1)]);

time_meas_ez(find(time_meas_ez(:,1)<startTime), :) = []; time_meas_ez(find(time_meas_ez(:,1)>=EndTime), :) = [];
time_meas_b5(find(time_meas_b5(:,1)<startTime), :) = []; time_meas_b5(find(time_meas_b5(:,1)>=EndTime), :) = [];
time_gt_ez(find(time_gt_ez(:,1)<startTime), :) = []; time_gt_ez(find(time_gt_ez(:,1)>=EndTime), :) = [];
time_gt_b5(find(time_gt_b5(:,1)<startTime), :) = []; time_gt_b5(find(time_gt_b5(:,1)>=EndTime), :) = [];

% Consider meas_ez as referance
figure; hold on
plot(time_gt_b5(:,1));
plot(time_gt_ez(:,1));
plot(time_meas_b5(:,1));
plot(time_meas_ez(:,1));
legend("gt_b5", "gt_ez", "meas_b5", "meas_b5");

indSync_meas_b5 = find_closest(time_meas_ez(:,1), time_meas_b5(:,1));
indSync_gt_b5 = find_closest(time_meas_ez, time_gt_b5(:,1));
indSync_gt_ez = find_closest(time_meas_ez, time_gt_ez(:,1));

% match measurements taken at closest time instants
pose_meas_ez = veh_meas_ez(time_meas_ez(:,2)-min(time_meas_ez(:,2))+1,2:4);
pose_meas_b5 = veh_meas_b5(indSync_meas_b5, 2:4); 
pose_gt_b5 = veh_gt_b5(indSync_meas_b5, 2:4); 
pose_gt_ez = veh_gt_ez(indSync_meas_b5, 2:4); 

% Convert all to local coordinate system LLA2ENU
orig_lat = [min([min(pose_gt_ez(:,1)), min(pose_gt_b5(:,1)), ...
             min(pose_meas_ez(:,1)), min(pose_meas_b5(:,1)), ...
             min(pole_pos_gt(:,1))...
          ])];
orig_long = [min([min(pose_gt_ez(:,2)), min(pose_gt_b5(:,2)), ...
              min(pose_meas_ez(:,2)), min(pose_meas_b5(:,2)), ...
              min(pole_pos_gt(:,2))...
          ])];

orig_alt = [min([min(pose_gt_ez(:,3)), min(pose_gt_b5(:,3)), ...
              min(pose_meas_ez(:,3)), min(pose_meas_b5(:,3)), ...
              min(pole_pos_gt(:,3))...
          ])];

origin = [orig_lat, orig_long, orig_alt];
[veh_pos_meas_ez_x, veh_pos_meas_ez_y]= latlon2local(pose_meas_ez(:,1), pose_meas_ez(:,2), pose_meas_ez(:,3), origin);
[veh_pos_gt_ez_x, veh_pos_gt_ez_y]    = latlon2local(pose_gt_ez(:,1), pose_gt_ez(:,2), pose_gt_ez(:,3), origin);

[veh_pos_meas_b5_x, veh_pos_meas_b5_y]= latlon2local(pose_meas_b5(:,1), pose_meas_b5(:,2), pose_meas_b5(:,3), origin);
[veh_pos_gt_b5_x, veh_pos_gt_b5_y]    = latlon2local(pose_gt_b5(:,1), pose_gt_b5(:,2), pose_gt_b5(:,3), origin);

veh_pos_meas_ez = [veh_pos_meas_ez_x, veh_pos_meas_ez_y]; clear veh_pos_meas_ez_x veh_pos_meas_ez_y
veh_pos_gt_ez   = [veh_pos_gt_ez_x, veh_pos_gt_ez_y];     clear veh_pos_gt_ez_x veh_pos_gt_ez_y
veh_pos_meas_b5 = [veh_pos_meas_b5_x, veh_pos_meas_b5_y]; clear veh_pos_meas_b5_x veh_pos_meas_b5_y
veh_pos_gt_b5   = [veh_pos_gt_b5_x, veh_pos_gt_b5_y];     clear veh_pos_gt_b5_x veh_pos_gt_b5_y

veh_pos_gt(:,:,1) = veh_pos_gt_ez;
veh_pos_gt(:,:,2) = veh_pos_gt_b5;

veh_pos_meas(:,:,1) = veh_pos_meas_ez;
veh_pos_meas(:,:,2) = veh_pos_meas_b5;

clear veh_pos_gt_ez veh_pos_gt_b5 veh_pos_meas_ez veh_pos_gt_b5
load("C:\Users\akifa\OneDrive\Masaüstü\PhD\SPOKE9\Projects\C_ICP\Codes\yaw.mat")
% Fix position bias by hand 

figure
plot(veh_pos_gt(:,1), veh_pos_gt(:,2),'.')
hold on, grid minor
plot(veh_pos_meas(:,1), veh_pos_meas(:,2),'.')
plot(veh_pos_meas(:,1,2), veh_pos_meas(:,2,2),'.')
plot(veh_pos_gt(:,1,2), veh_pos_gt(:,2,2),'.')

veh_pos_meas(:,:,1) = veh_pos_meas(:,:,1) - 0.5*[cosd(13), sind(13)]; %60cm 
veh_pos_meas(:,:,2) = veh_pos_meas(:,:,2) - 1*[cosd(yawV(:,1)), sind(yawV(:,2))];

plot(veh_pos_meas(:,1,1), veh_pos_meas(:,2,1),'.',"Color",'r')
plot(veh_pos_meas(:,1,2), veh_pos_meas(:,2,2),'.',"Color",'r')
xlabel("[m]"); ylabel("[m]");
legend("EZ-GT",  "EZ-MEAS", "B5-MEAS", "B5-GT", "EZ-MEAS-FIXED","B5-MEAS-FIXED", "FontSize", 12, "Location", 'northwest')


rmse_pos = mean(sqrt((veh_pos_meas(:,1,1) - veh_pos_gt(:,1,1)).^2 + (veh_pos_meas(:,2,1) - veh_pos_gt(:,2,1)).^2))
rmse_pos = mean(sqrt((veh_pos_meas(:,1,2) - veh_pos_gt(:,1,2)).^2 + (veh_pos_meas(:,2,2) - veh_pos_gt(:,2,2)).^2))
% Convert Pole Positions 
[pole_pos_gt_x, pole_pos_gt_y]  = latlon2local(pole_pos_gt(:,1), pole_pos_gt(:,2), pole_pos_gt(:,3), origin);
pole_pos_gt = [pole_pos_gt_x, pole_pos_gt_y];
indices = [(1:size(time_meas_ez,1))', indSync_gt_ez', indSync_meas_b5', indSync_gt_b5'];


obj_gt = pole_pos_gt;
save("ext_pose_data.mat", "pole_pos_gt", "veh_pos_gt", "veh_pos_meas", "indices");
save("obj_gt.mat", "obj_gt");
save("origin.mat", "origin");

%% Synch Velocity 
load("C:\Users\akifa\OneDrive\Masaüstü\PhD\SPOKE9\Projects\C_ICP\Codes\nodes\_swiftnav_front_gps_vel_enu");
vel_ez = dataS;
load("C:\Users\akifa\OneDrive\Masaüstü\PhD\SPOKE9\Projects\C_ICP\Codes\nodes\_swiftnav_rtk_gps_vel_enu.mat");
vel_b5 = dataS; 
clear dataS

%% Synch Lidar Pointclouds
load("C:\Users\akifa\OneDrive\Masaüstü\PhD\SPOKE9\Projects\C_ICP\Codes\nodes\_hesai_pandar.mat");
lidar_b5 = lidar_time;
lidar_b5_time = double(lidar_b5(:,2)) + 1e-9 * double(lidar_b5(:,3));
load("C:\Users\akifa\OneDrive\Masaüstü\PhD\SPOKE9\Projects\C_ICP\Codes\nodes\_velodyne_front_velodyne_points.mat");
lidar_ez = lidar_time;
lidar_ez_time = double(lidar_ez(:,2)) + 1e-9 * double(lidar_ez(:,3));
clear lidar_time

indSynch_lidar{1} = find_closest(time_meas_ez, lidar_ez_time);
lidar_ez_time_fixed = lidar_ez_time(indSynch_lidar{1});
lidar_ez_time_sh =  lidar_ez_time_fixed - min(lidar_ez_time_fixed);
lidar_b5_time_sh =  lidar_b5_time - min(lidar_b5_time);
indSynch_lidar{2} = find_closest(lidar_ez_time_sh, lidar_b5_time_sh);

save("lidar_indices.mat", "indSynch_lidar");
%%
figure;
img = imread("C:\Users\akifa\OneDrive\Masaüstü\Thesis\_thesis\images\im_exp1.png");
image('CData',flip(img),'XData',[-18 57],'YData',[-14 21]); hold on
plot(veh_pos_meas(:,1,1),veh_pos_meas(:,2,1),'.','Color','r')
plot(veh_pos_meas(:,1,2),veh_pos_meas(:,2,2),'.','Color','r')
plot(veh_pos_gt(:,1,1),veh_pos_gt(:,2,1),'.','Color','g')
plot(veh_pos_gt(:,1,2),veh_pos_gt(:,2,2),'.','Color','g')
plot(pole_pos_gt(:,1), pole_pos_gt(:,2),'v', 'Color','b', 'MarkerFaceColor','auto');

%%
function [ind] = find_closest(a, b)
    j = 1;
    for i = 1: size(a,1)
        Lprev = 999;
        for k = j: size(b,1)
            L = abs(a(i,1) - b(k,1));
            if L > Lprev || (k == size(b,1)) 
                j = k-1;
                ind(i) = k-1; 
                break;
            else 
                Lprev = L;
            end
        end
    end
end
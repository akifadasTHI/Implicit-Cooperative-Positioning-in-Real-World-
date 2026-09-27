clc, close, clear 
load("trial3.mat")
load("trial3_rerun4.mat")

%% lla2enu
direct = "";
load( "swiftnav_duromag_gps_pose.mat");
gnss_duromag_lla = data; gnss_duromag_lla(find(gnss_duromag_lla(:,2) == 0),:) = nan; clear data
load( "swiftnav_front_gps_pose.mat");
gnss_rtk_lla = data; gnss_rtk_lla(find(gnss_rtk_lla(:,2) == 0),:) = nan; clear data
load( "swiftnav_nicoli_gps_pose.mat");
gnss_piksipar_lla = data; gnss_piksipar_lla(find(gnss_piksipar_lla(:,2) == 0),:) = nan; clear data


min_lat = min([min(gnss_duromag_lla(:,2)), min(gnss_rtk_lla(:,2)), min(gnss_piksipar_lla(:,2))]);
min_lon = min([min(gnss_duromag_lla(:,3)), min(gnss_rtk_lla(:,3)), min(gnss_piksipar_lla(:,3))]);
origin  = [min_lat, min_lon, 0];


[gnss_duromag_x, gnss_duromag_y]  = latlon2local(gnss_duromag_lla(:,2), gnss_duromag_lla(:,3), gnss_duromag_lla(:,4), origin); gnss_duromag = [gnss_duromag_x, gnss_duromag_y]; clear gnss_duromag_x gnss_duromag_y gnss_duromag_lla
[gnss_rtk_x, gnss_rtk_y]          = latlon2local(gnss_rtk_lla(:,2), gnss_rtk_lla(:,3), gnss_rtk_lla(:,4), origin);             gnss_rtk = [gnss_rtk_x, gnss_rtk_y]; clear gnss_rtk_x gnss_rtk_y gnss_rtk_lla
[gnss_piksipar_x, gnss_piksipar_y]= latlon2local(gnss_piksipar_lla(:,2), gnss_piksipar_lla(:,3), gnss_piksipar_lla(:,4), origin); gnss_piksipar = [gnss_piksipar_x, gnss_piksipar_y]; clear gnss_piksipar_x gnss_piksipar_y gnss_piksipar_lla


% Size Match 
min_size = min([size(gnss_piksipar,1), size(gnss_rtk,1) , size(gnss_duromag,1)]);
gnss_duromag  = gnss_duromag(1:min_size,:);
gnss_rtk      = gnss_rtk(1:min_size,:);
gnss_piksipar = gnss_piksipar(1:min_size,:);

% Calculate RMSE 
err_duromag = mean(sqrt(nansum((gnss_rtk - gnss_duromag).^2)/min_size));
err_piksipar = mean(sqrt(nansum((gnss_rtk - gnss_piksipar).^2)/min_size));

%% Visualize
figure;
plot(gnss_rtk(:,1), gnss_rtk(:,2), '.', 'Color','g'), hold on 
plot(gnss_duromag(:,1), gnss_duromag(:,2), '.', 'Color','b')
plot(gnss_piksipar(:,1), gnss_piksipar(:,2), '.', 'Color','r')
legend("RTK", "DuroPar", "PiksiMag"), grid minor
titleText = "RMSE: DuroPar  = " + num2str(err_duromag) + "m   PiksiMag  = " + num2str(err_piksipar) + " m";
title(titleText);
saveas(gcf, direct + "\overall_trajectories.jpg")
figure;
subplot(121)
plot(gnss_piksipar(:,1) - gnss_duromag(:,1)), title("Piksipar - Duromag -- X")
subplot(122)
plot(gnss_piksipar(:,2) - gnss_duromag(:,2)), title("Piksipar - Duromag -- Y")



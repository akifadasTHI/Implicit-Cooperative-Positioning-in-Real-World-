clc, clear, close all

%% Bias-Free Position Plot
load("C:\Users\akifa\OneDrive - Politecnico di Milano\Desktop\PhD\SPOKE9\Projects\1_C_ICP_FUSION\Codes\test1\nodesx\ext_pose_data.mat")
load("C:\Users\akifa\OneDrive - Politecnico di Milano\Desktop\PhD\SPOKE9\Projects\1_C_ICP_FUSION\Codes\test1\bias_free_b5g_pos.mat")

light_orange = [255 153 51]./255;
orange = [255 128 0]./255;

light_green = [153 255 153]./255;
green = [76 153 0]./255;

light_blue = [102 178 255]./255;
blue = [0 0 153]./255;

light_red = [255 102 102]./255;
red = [153 0 0]./255; 

u_bound = 1000;
l_bound = 300;

arrow_ind = [300, 700, 900];
figure
plot(veh_pos_meas(l_bound:u_bound,1,2),veh_pos_meas(l_bound:u_bound,2,2),'Color',red, 'LineWidth',2)
hold on
plot(positions_b5g_kf(1,l_bound:u_bound),positions_b5g_kf(2,l_bound:u_bound),'Color',orange, 'LineWidth',2)
plot(veh_pos_gt(l_bound:u_bound,1,2),veh_pos_gt(l_bound:u_bound,2,2),'Color', green, 'LineWidth',2)
for i = 1:length(arrow_ind)
    h = quiver(veh_pos_meas(arrow_ind(i),1,2),veh_pos_meas(arrow_ind(i),2,2),...
        positions_b5g_kf(1,arrow_ind(i))-veh_pos_meas(arrow_ind(i),1,2),...
        positions_b5g_kf(2,arrow_ind(i))-veh_pos_meas(arrow_ind(i),2,2),0);
    set(h,'LineWidth',2, 'Color', [0 0 0], 'Marker', 'o')
end
lg = legend("SPP", "Bias-Fixed", "RTK-corrected", "Bias");










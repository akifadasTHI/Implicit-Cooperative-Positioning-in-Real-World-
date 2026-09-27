clc, clear, close all

load 'test1\nodes\ext_pose_data.mat' veh_pos_meas
load("test1\nodes\_swiftnav_no_imu_good.mat")

SampleRate = 10;
decim = 1;

fuse = imufilter('SampleRate',SampleRate,'DecimationFactor',decim);
[orientation,angularVelocity] = fuse(LinearAcceleration,AngularVelocity);

yaw = zeros(size(orientation,1),1);
for i = 1:size(orientation)
    qq = compact(orientation(i));
    yaw_tait_bryan(i) = atan2(2.0*(qq(2)*qq(3) + qq(4)*qq(1)), qq(4)*qq(4) - qq(1)^2 - qq(2)^2 + qq(3)^2);
    qq(2) = 0; qq(4) = 0;
    mag = sqrt(qq(1)*qq(1) + qq(3)*qq(3));

    qq(1) = qq(1) / mag;
    qq(3) = qq(3) / mag;
    
    yaw(i) = 2*acosd(qq(1));
end



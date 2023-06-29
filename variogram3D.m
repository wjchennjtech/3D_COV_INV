function [h,gamma] = variogram3D(x,y,z,val,lag_distance,n_lag,lag_tolerance,azimuth,elevation,tolerance)
% x, y, z: coordinates of data points
% val: values of data points
% lag_distance: maximum distance between pairs of points to be included in the calculation
% lag_tolerance: tolerance for the distance between pairs of points
% azimuth: direction of the lag in degrees (0-360)
% elevation: elevation of the lag in degrees (-90-90)
% tolerance: tolerance for the angle between the lag direction and the specified azimuth and elevation

n_points = length(x);
h = [];
gamma = [];
for lag = linspace(0,lag_distance,n_lag)
    differences = [];
    for i = 1:n_points
        for j = 1:n_points
            distance = sqrt((x(i)-x(j))^2 + (y(i)-y(j))^2 + (z(i)-z(j))^2);
            if abs(distance-lag) <= lag_tolerance
                [angle_azimuth,angle_elevation,~] = cart2sph(x(j)-x(i),y(j)-y(i),z(j)-z(i));
                angle_azimuth = angle_azimuth * 180/pi;
                angle_elevation = angle_elevation * 180/pi;
                if angle_azimuth < 0
                    angle_azimuth = angle_azimuth + 360;
                end
                if abs(angle_azimuth-azimuth) <= tolerance && abs(angle_elevation-elevation) <= tolerance
                    differences = [differences,(val(i)-val(j))^2];
                end
            end
        end
    end
    if ~isempty(differences)
        h = [h,lag];
        gamma = [gamma,0.5*mean(differences)];
    end
end


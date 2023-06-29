function [Cp] = generate_cov_matrix(x,y,z,ax,ay,az,neggect,sill,azimuth,dip)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
azimuth = deg2rad(azimuth);
dip = deg2rad(dip);
R = [cos(azimuth)*cos(dip), sin(azimuth)*cos(dip), -sin(dip);...
     -sin(azimuth), cos(azimuth), 0;...
     cos(azimuth)*sin(dip), sin(azimuth)*sin(dip), cos(dip)];
 n_points = length(x);
C=sill;
Q=sill;
C0=neggect;
 for i=1:n_points
     coords(i,:)=[x(i),y(i),z(i)]*R;
 end
 for i=1:n_points
     for j=1+i:n_points
          h= sqrt((coords(i,1)-coords(j,1))^2 + (coords(i,2)-coords(j,2))^2 + (coords(i,3)-coords(j,3))^2);
          [alfa,theta,~] = cart2sph(coords(j,1)-coords(i,1),coords(j,2)-coords(i,2),coords(j,3)-coords(i,3));
          a = ax*ay*az/sqrt((ay*az*cos(alfa)*cos(theta))^2+(ax*az*cos(alfa)*sin(theta))^2+(ay*ax*sin(alfa))^2);
          yh = C0+(C-C0)*(1-exp(-3*((h./a)^2)));
         C_p = Q - yh;
         Cp(i,j) = C_p;
         Cp(j,i)=C_p;
     end
 end
end


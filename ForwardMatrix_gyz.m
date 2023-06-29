function [ ForwardMatrix ] = ForwardMatrix_gyz(ObsPoints, paramCoords)
%FORWARDMATRIX takes in the Observation point and the coordinates of the
%parmeters to generate the sensitivity matrix.
% Obs points are: x, y, z
% paramCoors are: in lower x, upper x, lower y, upper y, lower z, upper z

lengthObs = length(ObsPoints(:,1));
lengthParam = length(paramCoords(:,1));
ForwardMatrix = zeros(lengthObs, lengthParam);

for i = 1 : lengthObs
    for j = 1 : lengthParam
          xp=ObsPoints(i,1);
          yp=ObsPoints(i,2);
          zp=ObsPoints(i,3);
          x1=paramCoords(j,1);
          x2=paramCoords(j,2);
          y1=paramCoords(j,3);
          y2=paramCoords(j,4);
          z1=paramCoords(j,5);
          z2=paramCoords(j,6);                 
          ForwardMatrix(i,j) =gyz(xp,yp,zp,x1,x2,y1,y2,z1,z2,1);        
    end
end


end


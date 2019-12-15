function [ TotalSplineEnergy ] = CalculateSplineEnergy(SplinePoints, CompositeEnergy)
%UNT�TLED Summary of this function goes here
%   Detailed explanation goes here

[lengthOfSplineMatrix,b] = size(SplinePoints);
[y,x] = size(CompositeEnergy);
TotalSplineEnergy = 0;

XaxisOfCompositeEnergy = 1:1:x;
YaxisOfCompositeEnergy = 1:1:y;


for i=1: 1: lengthOfSplineMatrix
    
    %%% e�er spline noktalar� integer ise, enerjisini direkt topla
    if((mod(SplinePoints(i,1), 1) == 0 ) && (mod(SplinePoints(i,2), 1) == 0 ))
    TotalSplineEnergy = TotalSplineEnergy + CompositeEnergy(SplinePoints(i,1), SplinePoints(i,2));
    else %% e�er spline noktalar� tam say� de�ilse, bu noktalara tekabul eden enerji bilinear interpolation kullan�larak hesaplan�r.
        X1 = SplinePoints(i,1);
        Y1 = SplinePoints(i,2);
        
        InterpolatedEnergy = interp2(XaxisOfCompositeEnergy, YaxisOfCompositeEnergy, CompositeEnergy, X1, Y1);
        TotalSplineEnergy = TotalSplineEnergy + InterpolatedEnergy;
    end
    
end


end


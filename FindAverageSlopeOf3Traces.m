function [ AverageSlopeOf3Traces ] = FindAverageSlopeOf3Traces(slope1, slope2, slope3)
%UNT�TLED Summary of this function goes here
%   Detailed explanation goes here

AbsMean = (abs(slope1) + abs(slope2) + abs(slope3))/3;

if( slope1 > 0 && slope2 > 0 && slope3 >0 )% hepsi pozitifse ortalama al
    AverageSlopeOf3Traces = (slope1 + slope2 + slope3)/3;
elseif(slope1 < 0 && slope2 < 0 && slope3 < 0 )% hepsi  negatifse ortalama al
    AverageSlopeOf3Traces = (slope1 + slope2 + slope3)/3;
elseif(AbsMean > 20)% e�er sonsuz e�imin oldu�u (dik do�runun e�imi) noktan�n etraf�nda eksi ve art� e�imler varsa: �rn, -900, 900, -800
    AverageSlopeOf3Traces = AbsMean;
else% son ko�ul: i�inde - ve + i�aretli e�imler var fakat bunlar�n de�eri k���k. Mesela -2, 0, +2
    AverageSlopeOf3Traces = (slope1 + slope2 + slope3)/3;
end


end


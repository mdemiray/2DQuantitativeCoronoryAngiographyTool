function [ ModifiedTracePointsOnBiggerSpline ] = SearchForShortestDiameterWithCorrection(SmallerSpline, BiggerSpline, TracePointsOnSmallerSpline,TracePointsOnBiggerSpline )
%UNT�TLED Summary of this function goes here
%   Detailed explanation goes here


% size of SmallerSpline and BiggerSpline are same
% size of TracePointsOnSmallerSpline and TracePointsOnBiggerSpline are same

[a,b] = size(SmallerSpline);
[c,d] = size(TracePointsOnSmallerSpline);

% repeat for each trace
for i = 1:1:c
    pointOnSmallerSpline = TracePointsOnSmallerSpline(i,:);
    pointOnBiggerSpline = TracePointsOnBiggerSpline(i,:);
    
    % find the index of the point in the spline matrix
    
    for j=1:1:a
        
        if(pointOnBiggerSpline == BiggerSpline(j,:))
            pointIndex = j;
            break;
        end
        
    end
    
    
    % Arama penceresinin ba�lang�� ve biti� indeksleri set edilir.
    % yani arama penceresi geni�li�i set edilir...
    StartIndex = pointIndex - 80;
    StopIndex = pointIndex + 80;
    % bu indexlerin array indexi d���na ta�malar� durumu handle
    % edilmeli...yap�ld�..
    
    % e�er ba�lang�� ve biti� indexleri s�n�r d���ndaysa, s�n�r de�erlere
    % set et
    if(StartIndex < 1)
        StartIndex = 1;
    end
    
    if(StopIndex > a)
        StopIndex = a;
    end
    
    
    for k=StartIndex:1:StopIndex
        
        pointOnBiggerSpline = BiggerSpline(k,:);
        distance = FindDistanceBetweenTwoPoints(pointOnSmallerSpline, pointOnBiggerSpline);
        
        
        
        if(k == StartIndex) %ilk nokta i�in bulunan mesafeyi min mesafe olarak tut ve sonrakilerle kar��la�t�r.
            minDistance = distance;
            ShortestDistancePointOnBiggerSpline = BiggerSpline(k,:);
        elseif(distance < minDistance)
            minDistance = distance;
            % store the found point
            ShortestDistancePointOnBiggerSpline = BiggerSpline(k,:);
            
        end
        
        
        
        
    end
    
    ModifiedTracePointsOnBiggerSpline(i,:) = ShortestDistancePointOnBiggerSpline;
    
    
    
    
end



%%%%  after making min diameter search, we have to correct some traces
%%%%  whose slopes are different than the previous 3 slopeof traces.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%       CORRECTION PART      %%%%%%%%%%%%



[a,b] = size(ModifiedTracePointsOnBiggerSpline);

% find the slope of each traces to check and correct for any abnormality
for i=1:1:a
    slopeOfTraces(i) = FindSlopeOfTwoPoints(TracePointsOnSmallerSpline(i,:),ModifiedTracePointsOnBiggerSpline(i,:));
end

AbsMeanOfSlopes = mean(abs(slopeOfTraces));

 % BU threshold de�eri fixed oldu�u zaman, durumdan duruma threshold de�i�tirmek gerekiyor. Fix threshold yerine, mevcut tracelerin slope durumlar�na g�re adaptive set edilebilir.
 %  Adaptive threshold 
if(AbsMeanOfSlopes > 20)
    Threshold = 5;% tanjant�n 90 dereceye yak�n oldu�u durumlarda y�ksek e�im geliyor.
else
    Threshold = 0.01; % di�er durumlarda bu de�er test edilerek bulundu, her 10 noktada 1 trace �izildi�i durum
end


  
for i=2:1:a
    DiffInSlope(i-1) = abs(slopeOfTraces(i)) - abs(slopeOfTraces(i-1));
    DiffInSlopeMdfd(i-1) = abs(slopeOfTraces(i)) - abs(slopeOfTraces(i-1));
    
    if abs(DiffInSlope(i-1)) > Threshold% there is an abnormality here.
        % THEN make a corrcetion on this trace by looking at slope
        % similarity
        
        if(i>3)
            % calculate average slope of three traces
            %AverageSlopeOfLast3Traces = (abs(slopeOfTraces(i-1)) + abs(slopeOfTraces(i-2)) + abs(slopeOfTraces(i-3)))/3;
            %AverageSlopeOfLast3Traces = ((slopeOfTraces(i-1)) + (slopeOfTraces(i-2)) + (slopeOfTraces(i-3)))/3; % DENEME....Bu iki y�ntemdan daha iyisi bulunmal�..
            AverageSlopeOfLast3Traces = FindAverageSlopeOf3Traces(slopeOfTraces(i-1), slopeOfTraces(i-2), slopeOfTraces(i-3));
            NewTracePointOnBiggerSpline = SearchForSimilarSlopeSingleTrace( SmallerSpline, BiggerSpline, TracePointsOnSmallerSpline(i,:),ModifiedTracePointsOnBiggerSpline(i,:), AverageSlopeOfLast3Traces );
            % calculate the new slope and store it.
            
            ModifiedTracePointsOnBiggerSpline(i,:) = NewTracePointOnBiggerSpline;
            slopeOfTraces(i) = FindSlopeOfTwoPoints(TracePointsOnSmallerSpline(i,:), NewTracePointOnBiggerSpline);
            DiffInSlopeMdfd(i-1) = abs(slopeOfTraces(i)) - abs(slopeOfTraces(i-1));
        end
        
    end
    
end


AbsMeanOfSlopes = mean(abs(slopeOfTraces));



end


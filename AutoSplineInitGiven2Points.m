function [ RightSplineControlPoints, LeftSplineControlPoints, XYnoktaCiftleri, XmesafesiBuyuk, YmesafesiBuyuk ] = AutoSplineInitGiven2Points( FirstPoint, SecondPoint, CompositeEnergy, StepSize, ResolutionOfSearchStep, NumberOfControlPoints )
%UNT�TLED Summary of this function goes here
%   Detailed explanation goes here


[y,x] = size(CompositeEnergy);


XaxisOfCompositeEnergy = 1:1:x;
YaxisOfCompositeEnergy = 1:1:y;

%ResolutionOfSearchStep = 0.1;   % damar�n ortas�ndaki noktadan sa�a ve sola ka� pixellik adimlarla gidilece�ini g�sterir


%%%% Automatic Spline Initialization  %%%%%


%%% iki noktas� bilinen do�ru denklemi bulunur
slope = (SecondPoint(1,2) - FirstPoint(1,2))/ (SecondPoint(1,1) - FirstPoint(1,1));
n = FirstPoint(1,2) - (slope*FirstPoint(1,1));
% now we have the line eqn. as          "y = slope*x + n"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


DistanceInX = abs(FirstPoint(1,1) - SecondPoint(1,1));
DistanceInY = abs(FirstPoint(1,2) - SecondPoint(1,2));

XmesafesiBuyuk = false;
YmesafesiBuyuk = false;

if (DistanceInX > DistanceInY)
    %%% X deki mesafe daha uzunsa X de e�it aral�kl� noktalar belirlenir
    XmesafesiBuyuk = true;
    
    Xnoktalari = linspace(FirstPoint(1,1), SecondPoint(1,1), NumberOfControlPoints);    % 10(NumberOfControlPoints) tane nokta se�ilir
    
    % X noktalar�na kar��l�k gelen Y noktalar� bulunur
    for i=1:1:length(Xnoktalari)
        XYnoktaCiftleri(i,1) = Xnoktalari(i);       % X noktas�
        XYnoktaCiftleri(i,2) = slope*Xnoktalari(i) + n;     % Y noktas�
        
    end
    
    
    for i=2:1:length(Xnoktalari)
        [ slope2 , n2] = PerpendicularLineEquation2Pts(FirstPoint, XYnoktaCiftleri(i,:) );
        % eqn of the perpendicular line is    "y = slope2*x + n"
        
        %%% �imdi Y noktalar� �zerinde linspace yap�l�r (Right Spline)
        PerpendicularLineYpoints = XYnoktaCiftleri(i,2) : ResolutionOfSearchStep : XYnoktaCiftleri(i,2) + StepSize;
        PerpendicularLineXpoints = (PerpendicularLineYpoints - n2)/slope2;
        %%% �imdi D�K do�ru �zerinde bulunan bu nokta �iftlerinin enerji
        %%% de�erlerine bak�l�r
        
        
        max = interp2(XaxisOfCompositeEnergy, YaxisOfCompositeEnergy, CompositeEnergy, PerpendicularLineXpoints(1), PerpendicularLineYpoints(1)); % 2D interpolation yap�larak verilen noktan�n enerjisi bulunur.
        for j=1:1: length(PerpendicularLineYpoints)
            if( interp2(XaxisOfCompositeEnergy, YaxisOfCompositeEnergy, CompositeEnergy, PerpendicularLineXpoints(j), PerpendicularLineYpoints(j)) > max)
                %max = CompositeEnergy(PerpendicularLineXpoints(j), PerpendicularLineYpoints(j));
                max = interp2(XaxisOfCompositeEnergy, YaxisOfCompositeEnergy, CompositeEnergy, PerpendicularLineXpoints(j), PerpendicularLineYpoints(j));
                RightSplineControlPoints(i-1,:) = [PerpendicularLineXpoints(j), PerpendicularLineYpoints(j)];
                
            end
            
        end
        
        
        %%% �imdi Y noktalar� �zerinde linspace yap�l�r (Left Spline)
        PerpendicularLineYpoints = XYnoktaCiftleri(i,2) : -ResolutionOfSearchStep : XYnoktaCiftleri(i,2) - StepSize;
        PerpendicularLineXpoints = (PerpendicularLineYpoints - n2)/slope2;
        
        max = interp2(XaxisOfCompositeEnergy, YaxisOfCompositeEnergy, CompositeEnergy, PerpendicularLineXpoints(1), PerpendicularLineYpoints(1)); % 2D interpolation yap�larak verilen noktan�n enerjisi bulunur.
        for j=1:1: length(PerpendicularLineYpoints)
            if( interp2(XaxisOfCompositeEnergy, YaxisOfCompositeEnergy, CompositeEnergy, PerpendicularLineXpoints(j), PerpendicularLineYpoints(j)) > max)
                max = interp2(XaxisOfCompositeEnergy, YaxisOfCompositeEnergy, CompositeEnergy, PerpendicularLineXpoints(j), PerpendicularLineYpoints(j));
                %max = CompositeEnergy(PerpendicularLineXpoints(j), PerpendicularLineYpoints(j));
                LeftSplineControlPoints(i-1,:) = [PerpendicularLineXpoints(j), PerpendicularLineYpoints(j)];
                
            end
            
        end
        
        
        
        
        
        
        
        
        
        
    end
    
    
    
    
else %%% Y deki mesafe daha uzunsa Y de e�it aral�kl� noktalar belirlenir
    
    YmesafesiBuyuk = true;
    
    Ynoktalari = linspace(FirstPoint(1,2), SecondPoint(1,2), NumberOfControlPoints);    % 10(NumberOfControlPoints) tane nokta se�ilir
    
    % Y noktalar�na kar��l�k gelen X noktalar� bulunur
    for i=1:1:length(Ynoktalari)
        XYnoktaCiftleri(i,2) = Ynoktalari(i);       % Y noktas�
        XYnoktaCiftleri(i,1) = (Ynoktalari(i) - n)/slope;     % X noktas�
        
    end
    
    
    
    for i=2:1:length(Ynoktalari)
        [ slope2 , n2] = PerpendicularLineEquation2Pts(FirstPoint, XYnoktaCiftleri(i,:) );
        % eqn of the perpendicular line is    "y = slope2*x + n"
        
        %%% �imdi X noktalar� �zerinde linspace yap�l�r (Right Spline)
        PerpendicularLineXpoints = XYnoktaCiftleri(i,1) : +ResolutionOfSearchStep : XYnoktaCiftleri(i,1) + StepSize;
        PerpendicularLineYpoints =  slope2*PerpendicularLineXpoints + n2;
        %%% �imdi D�K do�ru �zerinde bulunan bu nokta �iftlerinin enerji
        %%% de�erlerine bak�l�r
        
        
        max = interp2(XaxisOfCompositeEnergy, YaxisOfCompositeEnergy, CompositeEnergy, PerpendicularLineXpoints(1), PerpendicularLineYpoints(1)); % 2D interpolation yap�larak verilen noktan�n enerjisi bulunur.
        for j=1:1: length(PerpendicularLineYpoints)
            if( interp2(XaxisOfCompositeEnergy, YaxisOfCompositeEnergy, CompositeEnergy, PerpendicularLineXpoints(j), PerpendicularLineYpoints(j)) > max)
                %max = CompositeEnergy(PerpendicularLineXpoints(j), PerpendicularLineYpoints(j));
                max = interp2(XaxisOfCompositeEnergy, YaxisOfCompositeEnergy, CompositeEnergy, PerpendicularLineXpoints(j), PerpendicularLineYpoints(j));
                RightSplineControlPoints(i-1,:) = [PerpendicularLineXpoints(j), PerpendicularLineYpoints(j)];
                
            end
            
        end
        
        
        %%% �imdi X noktalar� �zerinde linspace yap�l�r (Left Spline)
        PerpendicularLineXpoints = XYnoktaCiftleri(i,1) : -ResolutionOfSearchStep : XYnoktaCiftleri(i,1) - StepSize;
        %PerpendicularLineXpoints = XYnoktaCiftleri(i,1) - StepSize : ResolutionOfSearchStep : XYnoktaCiftleri(i,1) ;  % deneme
        PerpendicularLineYpoints = slope2*PerpendicularLineXpoints + n2;
        
        
        max = interp2(XaxisOfCompositeEnergy, YaxisOfCompositeEnergy, CompositeEnergy, PerpendicularLineXpoints(1), PerpendicularLineYpoints(1)); % 2D interpolation yap�larak verilen noktan�n enerjisi bulunur.
        for j=1:1: length(PerpendicularLineYpoints)
            if( interp2(XaxisOfCompositeEnergy, YaxisOfCompositeEnergy, CompositeEnergy, PerpendicularLineXpoints(j), PerpendicularLineYpoints(j)) > max)
                %max = CompositeEnergy(PerpendicularLineXpoints(j), PerpendicularLineYpoints(j));
                max = interp2(XaxisOfCompositeEnergy, YaxisOfCompositeEnergy, CompositeEnergy, PerpendicularLineXpoints(j), PerpendicularLineYpoints(j));
                LeftSplineControlPoints(i-1,:) = [PerpendicularLineXpoints(j), PerpendicularLineYpoints(j)];
                
            end
            
        end
        
       
    end
    
    
    
    
    
end



end


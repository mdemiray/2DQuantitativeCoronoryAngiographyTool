function [ CroppedIm ] = CropImage( Image )
%UNT�TLED Summary of this function goes here
%   Detailed explanation goes here

% matlab HARRIS corner detection algoritmas� kenarlardan k��e bulmas�n diye
% yap�l�yor
[NumberOfRows, NumberOfColumns] = size(Image);
Width = NumberOfColumns -9;
Height = NumberOfRows - 9;
CroppedIm = imcrop(Image, [5, 5,Width, Height]);



end


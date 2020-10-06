function y=squarewave(f, S, T, H)

% f-- the fundermental frequency
% S-- the sampling rate
% T-- the number of sampling points
% H-- the number of harmonics


for i=1:H
   for j=1:T
    t= j/S;
    y(2*i-1,j)=2*sin(2*pi*(i*f)*t);
    y(2*i,j)=2*cos(2*pi*(i*f)*t);
   end
end

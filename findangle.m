% function anglecom = angleconv(angle)
%    anglecom = 
lengthx = 54;
L = 42;
ly = [4 6 11 15 20 24 41];
lengthx(1:length(ly)) = lengthx(1);
angledir = [140 135 130 125 120 115 100];
theta = angle2(lengthx,ly);
plot(angledir,theta);
xlabel('length in [cm]');
ylabel('direction setting');
function angle2 = angle2(lx,ly)
    angle2 = atan(ly./lx);
    angle2 = angle2*180/pi
end
function angle = angle(xb,yb,xe,ye,L)
    deltax = xe-xb;
    deltay = ye-yb;
    angle = arctan((2*L*sin(2*arctan*(deltay/deltax))/(sqrt(deltax^2+deltay^2))));
end
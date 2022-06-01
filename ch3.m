function ch3= thresh(x,y)
a=5;
Ny=length(y);
Nx=length(x);
L= Ny-Nx+1;
Y=fft(y);
X=fft([x; zeros(Ny-Nx,1)]);
eps=max(abs(X))*0.04;
ii=find(abs(X)< eps);
H=Y./X;
for i=1:length(ii)
H(ii(i))=0;
end
hh=ifft(H);
hh1=ceil(length(hh)/2);
hhat=real(hh(1:hh1));
ch3=hhat;
end
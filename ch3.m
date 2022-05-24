function hhat=ch3(x,y,frac,L)
Ny=length(y) ;
X=fft(x,Ny) ;
Y=fft(y) ;
xpeak=abs(max(X));
eps=frac*xpeak;
mu=find(abs(X)<eps);
HHAT=(Y./X) ;
check=length(mu);
M=1;
while M<=check
HHAT(mu(M))=0;
M=M+1;
end
hhatpre=real(ifft(HHAT));
hhat=hhatpre(1:L) ;
end
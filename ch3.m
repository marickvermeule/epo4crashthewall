function hhat = ch3 ( x , y , f r a c , L)
Ny = length ( y ) ;
X = f f t ( x , Ny ) ;
Y = f f t ( y ) ;
xpeak = abs (max(X ) ) ;
eps = f r a c ∗xpeak ;
mu = f ind ( abs (X) < eps ) ;
HHAT = (Y. /X ) ;
check = length (mu ) ;
M = 1 ;
while M <= check
HHAT(mu(M) ) = 0 ;
M = M+1;
end
hh a tp re = rea l ( i f f t (HHAT) ) ;
hhat = hh a tp re ( 1 : L ) ;
end
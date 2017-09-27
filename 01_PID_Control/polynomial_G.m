
f=@(x) x.^3 + (1/T1 + 1/T2)* x.^2 + 1/(T1*T2) * x + I/(T1*T2)
solution=fzero(x.^3 + (1/T1 + 1/T2)* x.^2 + 1/(T1*T2) * x + I/(T1*T2));
 x=linspace(-50,50,100000);
 hold on 
 plot(x,f(x))
 plot([-50 50],[0 0])
 %%
 p = [1, (1/T1 + 1/T2), 1/(T1*T2), I/(T1*T2)];
 pli = roots(p)
 xx = 0:0.1:2000;
 ff = exp(real(pli(2)).*xx).*(sin(imag(pli(2)).*xx) + cos(imag(pli(2)).*xx));
 plot(xx, ff)
 %%
 p = [1, (1/T1 + 1/T2), (P+1)/(T1*T2)]%, I/(T1*T2)];
 pli = roots(p)
 xx = 0:0.1:200;
 ff = exp(real(pli(1)).*xx).*sin(imag(pli(1).*xx));
 plot(xx, ff)
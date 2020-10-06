 function y=bandp(xsum,f1,f3,fsl,fsh,Fs)
Wp=[2*(f1)/Fs 2*(f3)/Fs];
        Ws=[2*(fsl)/Fs 2*(fsh)/Fs];
        Rp=0.1;
        Rs=0.5;
        [n1,Wn]=cheb1ord(Wp,Ws,Rp,Rs);
        [b1,a1]=cheby1(n1,Rp,Wn);
        y=filter(b1,a1,xsum);
end

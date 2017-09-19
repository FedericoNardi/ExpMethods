
%--- Initiate channel for read and write ----
ai=analoginput('nidaq','dev1');
addchannel(ai,2:3);
ao=analogoutput('nidaq','dev1');  
addchannel(ao,0);

set(ai,'Samplerate',1000)                %configure  samplingrate  to 20kHz
set(ai,'SamplesPerTrigger',500)

set(ai.Channel(1), 'InputRange', [-0.05 0.05] )
set(ai.Channel(2), 'InputRange', [-10 10] )
   
v_in=zeros(2,1000);
v_in_ave=zeros(2,1);

% --- iniialize variables ---
samples=10000;  
T=zeros(1,samples);
V=zeros(1,samples);
cm=zeros(1,samples);
reftime=clock;
sfigure(60); %Silent version of figure
hold on;
for i=1:samples

    
  %--- Start sampling ---
   start(ai)                    %start sampling
   v_in=getdata(ai);
   v_in_ave=mean(v_in);
   temp=clock;
   c=etime(temp,reftime);
    
   %--- Calculate resitance in both thermistors t1 and t2 ----
   R1=1598400;
   
   V=v_in_ave(2);
   r_T=v_in_ave(1).*R1./(V-v_in_ave(1));
  
   
   %--- Calculate temperature ----
   A0=0.00128285;
   A1=0.000236664;
   A2=8.99037e-8;
   
   T1=1./(A0+log(r_T).*(A1+A2.*(log(r_T)).^2));

  
   %--- Store Temperature, preasure and time ---
   
   T(i)=T1';
   cm(i)=c';
   
   %--- Show data in window ---
   [i,c,T(i)-273.15]
  
   %--- Reset read and write processes ---
   stop([ai ao])  
   plot(c,T1,'.r')
   xlabel('Time (s)');
   ylabel('Temperature (K)');
   drawnow;
   hold on;
   
end 

save 2017-temp_check_1.mat

%--- Reset daq-card ---
putdata(ao,[0])
start(ao)
stop(ao)
daqreset
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
samples=12000;   % one samples = 0.65 sec
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
    
   %--- Calculate resitance in both thermistors t1 and ----
   R1=1598400;
   V=v_in_ave(2);
   r_T=v_in_ave(1).*R1./(V-v_in_ave(1));
     
   %--- Calculate temperature ----
   A0=0.00128285;
   A1=0.000236664;
   A2=8.99037e-8;
   
   T1=1./(A0+log(r_T).*(A1+A2.*(log(r_T)).^2));
 
   %--- Store Temperature and time ---
   T(i)=T1'; %measured temperature in Kelvin
   cm(i)=c'; %elapsed time
   
   E=2; %excitation level to Peltier in Volts
   if c>20
   E=0; %excitation level to Peltier in Volts
   end
   
   % the following is a safety loop
   if E<-4 E=-4;
   end
   if E>4 E=4;
   end
   
   %--- Write data to Peltier element ---
   putdata(ao,[E])
   %putdata(ao,0)      %que  the  data  in the  engine
   start(ao) 
   
   %--- Show data in window ---
   [i,c,T(i)-273.15,E]
   
   %--- Reset read and write processes ---
   stop([ai ao])  
   sfigure(60);
   title('PID Controll');
   xlabel('Time (s)');
   ylabel('Temperature (K)');
   plot(c,T1,'.r')
   hold on;
   drawnow;
end

save 2017-PID_Pulse.mat

%--- Reset daq-card ---
putdata(ao,[0])
start(ao)
stop(ao)
daqreset
reset_pid
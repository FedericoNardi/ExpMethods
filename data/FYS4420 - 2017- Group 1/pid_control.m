
%--- Initiate channel for read and write ----
ai=analoginput('nidaq','dev1');
addchannel(ai,2:3);
ao=analogoutput('nidaq','dev1');  
addchannel(ao,0);

set(ai,'Samplerate',1000)                %configure  samplingrate  to 20kHz
set(ai,'SamplesPerTrigger',500)

set(ai.Channel(1), 'InputRange', [-0.05 0.05] )
set(ai.Channel(2), 'InputRange', [-10 10] )
   
% v_in=zeros(2,1000);
% v_in_ave=zeros(2,1);
% --- Set system parameters ----
T1=2.943976795771564;
T2=1.250103778472516e+02;
H0=7.940000000000000;

% --- Calculate closed-loop parameters ---
P=(1/3)*((T1+T2)^2)/(T1*T2)-1;
I=(1/27)*((T1+T2)^3)/((T1*T2)^2);
%Kp=P/H0
Ki=I/H0
Kp=100
%Ki=0


% --- Set reference temperature ---
Treference=35; %Desired temperature in Celsius

% --- iniialize variables ---
samples=2000;   % one samples = 0.18 sec

Tref=zeros(1,samples);
T=zeros(1,samples);
V=zeros(1,samples);
cm=zeros(1,samples);
Em=zeros(1,samples);
TI=0;

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
   
   Tx=1./(A0+log(r_T).*(A1+A2.*(log(r_T)).^2));

  
   %--- Store Temperature, preasure and time ---
   
   T(i)=Tx';
   cm(i)=c';
   
   Tref=Treference+273.15; %Desired temperature in Kelvin
   
   %--- Calculate the excitation ---
   if i>1
      Terr=Tref-T(i);
      TI=TI+Terr*(cm(i)-cm(i-1));
   else
      Terr=0;
      TI=0;
   end    
   E=Kp*Terr+Ki*TI;
   Em(i)=E;
   
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
   [i,c,Tref-273.15,T(i)-273.15,E]
   
   %--- Reset read and write processes ---
   stop([ai ao])  
   sfigure(60);
   title('PID Controll');
   xlabel('Time (s)');
   ylabel('Temperature (K)');
   plot(c,Tx,'.r')
   hold on;
   drawnow;
 
end    

% title('PID Controll');
%    xlabel('Time (s)');
%    ylabel('Temperature (K)');
%    plot(cm(1:28),T(1:28),'r');
%    hold on
%    plot([cm(1) cm(28)],[Tref Tref])


  save 2017-PI-35-100kp.mat

%--- Reset daq-card ---
putdata(ao,[0])
start(ao)
stop(ao)
daqreset
reset_pid
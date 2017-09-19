%warning('off', 'daq:analogoutput:adaptorobsolete'); 
%------------- Reset DAQ card, AO=0 --------------%
ao=analogoutput('nidaq','dev1');  
addchannel(ao,0);
putdata(ao,[0])
start(ao)
stop(ao)
daqreset
%% PID Control
%% Temperature check
% Import data
path(path,'C:\Users\Federico\Documents\GitHub\ExpMethods\01_PID_Control');
load('tempcheck.mat');
% Plot
plot(tcheck.t,tcheck.T,'Linestyle','none','Marker','.',...
    'color','r');
% Calculate mean and std
Tm = mean(tcheck.T);
sigma_T = std(tcheck.T);
% Make a log
disp(sprintf('\n-------- TEMPERATURE CHECK --------'));
disp(sprintf('Average temperature: %d',Tm));
disp(sprintf('Temperature deviation: %d',sigma_T));
disp(sprintf('-----------------------------------\n'));

%% Step excitation
load('step.mat');
% Plot
plot(step.t,step.T,'Linestyle','none','Marker','.',...
    'color','r');
% Get H0 value
H0 = step.T(end-10) - step.T(1);
% Make a log
disp(sprintf('\n-------- STEP EXCITATION --------'));
disp(sprintf('H_0: %d',H0));
disp(sprintf('-----------------------------------\n'));

%% Pulse excitation
load('pulse.mat');
% Plot
plot(pulse.t,pulse.T,'Linestyle','none','Marker','.',...
    'color','r');
% Find maximum
[max, i] = max(pulse.T);
tp = pulse.t(i);
rp = pulse.T(i);




%% PID Control
%% Temperature check
% Import data
%path(path,'C:\Users\Federico\Documents\GitHub\ExpMethods\01_PID_Control');
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
close all
load('pulse.mat');
% Plot
plot(pulse.t,pulse.T,'Linestyle','none','Marker','.',...
    'color','r');
% Find maximum r(t) is the function
temp = pulse.T;
rp = max(temp);
index = find(temp == rp);
tp = pulse.t(index);
rp = pulse.T(index) - min(pulse.T(index));

%% derivative expression rp = H(0) ((exp(eps/T) - 1)exp(-tp/T))
% i want to find the root of
myfun = @(x,eps, rp, tp, H_0) (rp - H_0 * (exp(eps/x) - 1) * exp(- tp/x));  % parameterized function
% parameter
eps = 20;
H_0 = 7.943083;
tp = pulse.t(index);
rp = pulse.T(index) - min(pulse.T);
fun = @(x) myfun(x,eps, rp, tp, H_0);    % function of x alone
T1 = fzero(fun,3);
T2 = fzero(fun,125);
% plot
x=0:1:300;
hold on
plot(x,H_0 .* (exp(eps./x) - 1) .* exp(- tp./x));
plot([0 300],[rp rp])
% Make a log
disp(sprintf('\n-------- RESPONSE PARAMETERS --------'));
disp(sprintf('H_0: %d',H0));
disp(sprintf('T_1: %d',T1));
disp(sprintf('T_2: %d',T2));
disp(sprintf('-----------------------------------\n'));

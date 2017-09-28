%% PID Control
%% Temperature check
% Import data
%path(path,'C:\Users\Federico\Documents\GitHub\ExpMethods\01_PID_Control');
load('tempcheck.mat');
% Plot
plot(tcheck.t,tcheck.T,'Linestyle','none','Marker','.',...
    'color','r');
title('Temperature check','Interpreter','LateX','Fontsize',18);
xlabel('$t\quad [s]$','interpreter','latex','fontsize',15);
ylabel('$T\quad [K]$','interpreter','latex','fontsize',15);
set(gca,'TickLabelInterpreter','latex');
ll=legend(gca,'show','data');
set(ll,'interpreter','latex','fontsize',14,'location','southeast');
grid on;
set(gca, 'FontName', 'Times');
set(gca,'FontSize',14);
xlabel('t [s]');
ylabel('T [K]');

% Calculate mean and std
Tm = mean(tcheck.T);
sigma_T = std(tcheck.T);
% Make a log
fprintf('\n-------- TEMPERATURE CHECK --------\n');
fprintf('Average temperature: %d\n',Tm);
fprintf('Temperature deviation: %d\n',sigma_T);
fprintf('-----------------------------------\n\n');
print('t_check','-depsc')
%% Step excitation
load('step.mat');
% Plot
figure();
hold on;
plot(step.t,step.T,'Linestyle','none','Marker','.',...
    'color','r');
title('Step excitation','Interpreter','LateX','Fontsize',18);
xlabel('$t\quad [s]$','interpreter','latex','fontsize',15);
ylabel('$T\quad [K]$','interpreter','latex','fontsize',15);
set(gca,'TickLabelInterpreter','latex');
grid on;
ll=legend(gca,'show','data');
set(ll,'interpreter','latex','fontsize',14,'location','southeast');

%hold on;
% Get H0 value
H0 = mean(step.T(end-40:end)) - step.T(1);
delta_e=1;
%modelstep=delta_e*H0*(ones(size(step.t))-T1/(T1-T2)*exp(-(step.t)./T1)+T2/(T1-T2)*exp(-(step.t)./T2)) + min(step.T);
%plot(step.t, modelstep,'Linestyle','none','Marker','.',...
%    'color','b');
sigma=std(step.T(end-40:end))
% max value
asymptote = regressione_lineare(step.t(1,7000:7153),step.T(1,7000:7153), std(step.T(1,7000:7153)));
%plot(step.t, step.t.*asymptote.m+asymptote.b)
asym = step.t(end).*asymptote.m+asymptote.b;
print('step_p','-depsc')

%% Get H0 value
H0 = asym  - step.T(1);%step.T(end-10) - step.T(1);
delta_e=1;
%modelstep=delta_e*H0*(ones(size(step.t))-T1/(T1-T2)*exp(-(step.t)./T1)+T2/(T1-T2)*exp(-(step.t)./T2)) + min(step.T);
%plot(step.t, modelstep,'Linestyle','none','Marker','.',...
%    'color','b');
% Get H0 value
H0 = step.T(end-10) - step.T(1);
% Make a log
fprintf('\n-------- STEP EXCITATION --------\n');
fprintf('H_0:%d\n',H0);
fprintf('sigma[H_0]: %d\n',sigma);
fprintf('-----------------------------------\n\n');

%%Pulse excitation
close all
load('pulse.mat');
% Plot
plot(pulse.t,pulse.T,'Linestyle','none','Marker','.',...
    'color','r');
title('Pulse excitation','Interpreter','LateX','Fontsize',18);
xlabel('$t\quad [s]$','interpreter','latex','fontsize',15);
ylabel('$T\quad [K]$','interpreter','latex','fontsize',15);
set(gca,'TickLabelInterpreter','latex');
set(gca,'FontSize',14);
xlabel('t [s]');
ylabel('T [K]');
ll=legend(gca,'show','data');
set(ll,'interpreter','latex','fontsize',14,'location','northeast');
xlim([0 900]);
grid on;

hold on;
%print('pulse', '-depsc');

delta_e=1;
%modelstep2=delta_e*H0_m*(ones(size(pulse.t(1,1:33)))-T1_m/(T1_m-T2_m)*exp(-pulse.t(1,1:33)./T1_m)+T2_m/(T1_m-T2_m)*exp(-pulse.t(1,1:33)./T2_m)) + min(pulse.T);
%modelpulse=delta_e*H0_m/(T1_m-T2_m)*(T1_m*(exp(eps_m/T1_m)-1)*exp(-pulse.t(1,34:1535)/T1_m)-T2_m*(exp(eps_m/T2_m)-1)*exp(-pulse.t(1,34:1535)/T2_m))+ min(pulse.T);
%plot(pulse.t(1,1:33), modelstep2,'Linestyle','none','Marker','.',...
%    'color','b');
%plot(pulse.t(1,34:1535), modelpulse,'Linestyle','none','Marker','.',...
%    'color','b');
% Find maximum r(t) is the function
temp = pulse.T;
rp = max(temp);
index = find(temp == rp);
tp = pulse.t(index)
rp = pulse.T(index)
dr=0.5*(pulse.T(index-1)-pulse.T(index))
dt=0.5*(pulse.t(index+1)-pulse.t(index))
%% derivative expression rp = H(0) ((exp(eps/T) - 1)exp(-tp/T))
% i want to find the root of
myfun = @(x,eps, rp, tp, H_0) (rp - H_0 * (exp(eps/x) - 1) * exp(- tp/x));  % parameterized function
% parameter
eps = 20;
H0 = 7.9471;
tp = pulse.t(index);
rp = pulse.T(index) - min(pulse.T);
fun = @(x) myfun(x,eps, rp, tp, H0);    % function of x alone
T1 = fzero(fun,2.943);
T2 = fzero(fun,120);
dT1 = sqrt(dr^2 + sigma^2*exp(2*eps/T2))
%% plot derivative
x=0:1:300;
hold on;
xlim([0 150]);
ylim([-3.5 1.5]);
plot(x,rp*ones(size(x)) - H0 .* (exp(eps./x) - 1) .* exp(- tp./x));
plot(T1, 0,'Marker','x','Markersize',8,'color','r');
plot(T2, 0,'Marker','x','Markersize',8,'color','b');
plot([0 200],[0 0],'color',[0 0 0],'Linewidth',0.005);
title('Roots of $\Phi(T)$','Interpreter','LateX','Fontsize',18);
xlabel('$t\quad [s]$','interpreter','latex','fontsize',15);
ylabel('$T\quad [K]$','interpreter','latex','fontsize',15);
set(gca,'TickLabelInterpreter','latex');
set(gca,'FontSize',14);
xlabel('T [s]');
ylabel('$\Phi [K]$');
ll=legend(gca,'show','$\Phi(T)$','$T_1$','$T_2$');
set(ll,'interpreter','Latex','fontsize',14,'location','southeast');
grid on;

%% calculate P, I, k_p, k_i
P=(1/3)*((T1+T2)^2)/(T1*T2)-1;
I=(1/27)*((T1+T2)^3)/((T1*T2)^2);
Kp=P/H0;
Ki=I/H0;

%% PID control T=25
f2=figure();
load('PI_25C.mat');

p2=plot(cm(1,1:335),T(1,1:335),'linestyle', 'none', 'Marker','.',...
    'color','r');
tit=title('PI Control - T$=298.15$K');
set(tit,'Interpreter','LateX','Fontsize',18);
xlabel('$t\quad [s]$','interpreter','latex','fontsize',15);
ylabel('$T\quad [K]$','interpreter','latex','fontsize',15);
set(gca,'TickLabelInterpreter','latex');
xlim([0 210]);
grid on;
xlim([0 200])
set(gca,'FontSize',14);
ll=legend(gca,'show','data');
set(ll,'interpreter','latex','fontsize',14,'location','northeast');
hold on;
print('pid25', '-depsc');
%% 3 steps
f1=figure();
load('PI_3steps.mat');
p1=plot(cm(1,1:1483),T(1,1:1483),'linestyle', 'none', 'Marker','.',...
    'color','r');
title('PI Control - 3 steps','Interpreter','LateX','Fontsize',18);
xlabel('$t\quad [s]$','interpreter','latex','fontsize',15);
ylabel('$T\quad [K]$','interpreter','latex','fontsize',15);
xlim([0 1000]);
set(gca,'TickLabelInterpreter','latex');
grid on;
xlim([0 1000])
set(gca,'FontSize',14);
ll=legend(gca,'show','data');
set(ll,'interpreter','latex','fontsize',14,'location','southeast');
%hold on;
%print('pid3step', '-depsc');

%% T expected 35, sample rate 30, task 10
f1=figure();
load('PI_35expect_samplerate30.mat');
hold on;
p1=plot(cm(1,1:28),T(1,1:28),'linestyle', 'none', 'Marker','.',...
    'Markersize',8,'color','r');
hold on
plot([0 500],[273.15+35 273.15+35]);
title('PI control - longer sampling interval','Interpreter','LateX','Fontsize',18);
xlabel('$t\quad [s]$','interpreter','latex','fontsize',15);
ylabel('$T\quad [K]$','interpreter','latex','fontsize',15);
set(gca,'TickLabelInterpreter','latex');
grid on;
ll=legend(gca,'show','Data','$T = 308.15$K','location','northwest')
set(ll,'Interpreter','Latex','Fontsize',10);
plot([0 500],[308.15 308.15]);
set(gca,'FontSize',14);
hold on;
%print('long_sampling', '-depsc');


%% Kp=0
f1=figure();
load('I_35.mat');
hold on;
p1=plot(cm(1,1:1800),T(1,1:1800),'linestyle', 'none', 'Marker','.',...
    'color','r');
hold on
plot([0 1250],[273.15+35 273.15+35]);
title('I control ($K_p = 0$)','Interpreter','LateX','Fontsize',18);
xlabel('$t\quad [s]$','interpreter','latex','fontsize',15);
ylabel('$T\quad [K]$','interpreter','latex','fontsize',15);
set(gca,'TickLabelInterpreter','latex');
grid on
xlim([0 1250])
ll=legend(gca,'show','Data','$T=308.15$K');
set(ll,'Interpreter','Latex');
plot([0 1300],[308.15 308.15]);
xlim([0 1230])
set(gca,'FontSize',14);
hold on;
%print('I35', '-depsc');

%% Ki=0
f1=figure();
load('P_35.mat');
hold on;
p1=plot(cm(1,1:1049),T(1,1:1049),'linestyle', 'none', 'Marker','.',...
    'color','r');
hold on
plot([0 1250],[273.15+35 273.15+35]);
plot([0 1250],[307.63271 307.63271])
title('P control ($K_I = 0$)','Interpreter','LateX','Fontsize',18);
xlabel('$t\quad [s]$','interpreter','latex','fontsize',15);
ylabel('$T\quad [K]$','interpreter','latex','fontsize',15);
set(gca,'TickLabelInterpreter','latex');
grid on
xlim([0 700]);
xlim([0 670]);
plot([0 670],[308.15 308.15]);
ll=legend(gca,'show','Data','$T=308.15$K','$r_{model}(\infty)$');
set(ll,'Interpreter','Latex','Location','southeast');
set(gca,'FontSize',14);
hold on;
%print('P35', '-depsc');
%% Kp=100
f1=figure();
load('PI_35_100kp.mat');
hold on;
p1=plot(cm(1,1:612),T(1,1:612),'linestyle', 'none', 'Marker','.',...
    'color','r');
hold on
plot([0 1250],[273.15+35 273.15+35]);
title('PI control (optimal $K_I$, $K_P = 100$)','Interpreter','LateX','Fontsize',18);
xlabel('$t\quad [s]$','interpreter','latex','fontsize',15);
ylabel('$T\quad [K]$','interpreter','latex','fontsize',15);
set(gca,'TickLabelInterpreter','latex');
grid on
xlim([0 380]);
ll=legend(gca,'show','Data','$T=308.15$K');
set(ll,'Interpreter','Latex','Location','southeast');
xlim([0 375]);
set(gca,'FontSize',14);
hold on;
%print('P100', '-depsc');

H_0 = 7.943083;
tp = pulse.t(index);
rp = pulse.T(index) - min(pulse.T);
fun = @(x) myfun(x,eps, rp, tp, H_0);    % function of x alone
T1 = fzero(fun,3);
T2 = fzero(fun,125);


%% plot
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

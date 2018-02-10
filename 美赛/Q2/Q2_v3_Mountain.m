% 问题二2.1-自建模型
clc;close;clear;
%% 初始化
Pi = 20;      % 输入功率
Po = 127;   % 输出功率
delta = deg2rad(15);    % 仰角
N = [               % 各层电子密度
    2.5*10^9        % D层
    2*10^11         % E层
    ];
v = [
    5*10^6;    % D层
    10^5;          %E层
    ];
c = 3*10^8;
e = 1.60217662 * 10^(-19);  % 电量
hup = 150*10^3;
hdown = 60*10^3;
h = hup - hdown;       % 高度差
hmax = 200*10^3; % 最高高度
Nmax = 8*10^11; % 最大电子密度
R = 6371*10^3;      % 地球半径
m = 9.106*10^(-31);
fmax = sqrt((80.8*Nmax*(1+2*hmax/R))/(sin(delta)^2+2*hmax/R));      % 最大频率估算公式
f = 0.85*fmax;    % 工作频率
lamda = c /f;   % 波长
w = 2*pi*f;     % 工作角频率

%% 单次反射损耗计算
Lf = 20*log10(f/10^6);  % 工作

l = h/sin(delta);
a1 = (60*pi*N(1)*e^2*v(1))/(m*(w^2 + v(1)^2));        % D层吸收损耗
La1 = exp(-a1*l)*2;
a2 = (60*pi*N(2)*e^2*v(2))/(m*(w^2 + v(2)^2));        % E层吸收损耗
La2 = exp(-a2*l)*2;
La = La1+La2;
Le = 15.4;        % 12点

% 山地反射
% 初始化
er = 4;            % 相对介电常数
o = 10^-3;            % 海水电导率
ee = er+60*lamda*o*i;     % 海面复介电常数

RH = (sin(delta)-sqrt(ee - cos(delta)^2))/(sin(delta)+sqrt(ee-cos(delta)^2));
RV = (ee*sin(delta) - sqrt(ee - cos(delta)^2))/(ee*sin(delta)+sqrt(ee - cos(delta)^2));
R1 = (abs(RV)^2 + abs(RH)^2);
Lg = abs(10*log10(R1/2));


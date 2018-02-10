% 问题一-计算通过海平面反射最多有几跳
% 假设：数据统计均在白天,各层的电子密度均为常数
%% 电离层衰减
% 初始化
clear;clc;close all;
Pin = 100;      % 输入功率
S_N = 10;       % 信噪比
k = 1;
noise = 30;     % 噪声
for i = 5:2:60
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
    global f;
    f = 0.85*fmax;    % 工作频率
    lamda = c /f;   % 波长
    w = 2*pi*f;     % 工作角频率
    
    %% 损耗计算
    L0 =   32.45+ 20*log10(f/10^6)+ 20*log10(2*hup/10^3/sin(delta))   ; % 自由空间传播公式，r为km
    l = h/sin(delta);
    a1 = (60*pi*N(1)*e^2*v(1))/(m*(w^2 + v(1)^2));        % D层吸收损耗
    La1 = exp(-a1*l)*2;
    a2 = (60*pi*N(2)*e^2*v(2))/(m*(w^2 + v(2)^2));        % E层吸收损耗
    La2 = exp(-a2*l)*2;
    La = La1+La2;
    LgT = [
        18      %22-04
        16.6    %04-10
        15.4    %10-16
        16.6    %16-22
    ];
    Lg = LgT(3);        % 12点
    
    %% 地面平面衰减
    % 初始化
    er = 20;            % 相对介电常数
    o = 10^-2;            % 海水电导率
    ee = er+60*lamda*o*i;     % 海面复介电常数
    
    % 静态
    RH = (sin(delta)-sqrt(ee - cos(delta)^2))/(sin(delta)+sqrt(ee-cos(delta)^2));
    RV = (ee*sin(delta) - sqrt(ee - cos(delta)^2))/(ee*sin(delta)+sqrt(ee - cos(delta)^2));
    R1 = (abs(RV)^2 + abs(RH)^2);
    Lg_static = abs(10*log10(R1/2));
    
    L_Pin = 10*log10(Pin);
    
    x_static(k)=  L_Pin  - Lg_static -La;        % 单跳
    L_Po = 20*log10(noise/3/57735*10);     % 输出噪声分贝
    Po = 10^((L_Po-30)/10);             % 输出噪声功率w
    S = 10*Po;          % 输出信号功率
    L_s = 10*log10(S);
    
    total = L_Pin - Lg - L_s ;
    Sc = Lg_static+La+10;
    X(k) = floor(total/Sc);
    single_d = hup/sin(delta)*2;
    D (k) = single_d*(total/Sc)*cos(delta);
    k = k+1;
end
figure;
plot(5:2:60,X);
mean(D)
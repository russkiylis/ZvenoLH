R1 = 50e4;
R2 = 500e4;
R3 = 200e4;
R4 = 1e6;
C1 = 2e-6;
C2 = 0.033e-6;

K = 1./(R4.*C2);    % K для операционника с ООС

% Постоянные времени
T1 = R1.*C1;
T2 = R2.*C1;
T3 = R3.*C1;
T4 = (R2+R3).*C1;


W1 = {struct('Type', "Усил", 'K', K),...
    struct('Type', "Интегр")};

W2 = {struct('Type', "Усил", 'K', K),...
    struct('Type', "Интегр"),...
    struct('Type', "Апериод", 'T', T1)};

W3 = {struct('Type', "Усил", 'K', K),...
    struct('Type', "Интегр"),...
    struct('Type', "Апериод", 'T', T2)};

W4 = {struct('Type', "Усил", 'K', K),...
    struct('Type', "Интегр"),...
    struct('Type', "Апериод", 'T', T4),...
    struct('Type', "Форс", 'T', T3)};

% Генерация ЛХ
ZvenoLH(W1).showSumLH([1/64 40],[-6 63], [-200 30]);
ZvenoLH(W2).showSumLH([1/64 16],[-6 63], [-200 30]);
ZvenoLH(W3).showSumLH([1/64 16],[-6 63], [-200 30]);
ZvenoLH(W4).showSumLH([1/64 16],[-6 63], [-200 30]);

%% Параметры ПП
wsr = [32 5.5 1.8 3 5.5 7.5 9];
gamma = [90 10 5 75 85 89 90];
t_n = pi./wsr;

%% полюсы
syms p
eqn1 = p + K == 0;
eqn2 = p^2*T1 + p + K == 0;
eqn3 = p^2*T2 + p + K == 0;
eqn4 = p^2*T4+p+K*p*T3+K ==0;
polus1 = double(solve(eqn1));
polus2 = double(solve(eqn2));
polus3 = double(solve(eqn3));
polus4 = double(solve(eqn4));

figure('Name',"Полюсы САУ 1");
plot(real(polus1), imag(polus1), "p", LineWidth=4);
grid on;
ax = gca;
ax.XAxisLocation = "origin";
ax.YAxisLocation = "origin";
axis equal
axis tight
xlim([-40 40]);
ylim([-40 40]);
xlabel("Re");
ylabel("Im");
title("Полюсы САУ 1");

figure('Name',"Полюсы САУ 2");
plot(real(polus2), imag(polus2), "p", LineWidth=4);
grid on;
ax = gca;
ax.XAxisLocation = "origin";
ax.YAxisLocation = "origin";
axis equal
axis tight
xlim([-10 10]);
ylim([-10 10]);
xlabel("Re");
ylabel("Im");
title("Полюсы САУ 2");

figure('Name',"Полюсы САУ 3");
plot(real(polus3), imag(polus3), "p", LineWidth=4);
grid on;
ax = gca;
ax.XAxisLocation = "origin";
ax.YAxisLocation = "origin";
axis equal
axis tight
xlim([-10 10]);
ylim([-10 10]);
xlabel("Re");
ylabel("Im");
title("Полюсы САУ 3");

figure('Name',"Полюсы САУ 4");
plot(real(polus4), imag(polus4), "p", LineWidth=4);
grid on;
ax = gca;
ax.XAxisLocation = "origin";
ax.YAxisLocation = "origin";
axis equal
axis tight
xlim([-10 10]);
ylim([-10 10]);
xlabel("Re");
ylabel("Im");
title("Полюсы САУ 4");


%% сдвииги
T = [286 388 830 820 820 1000].*2;
delta = abs([188-226 204-132 680-570 710-790 610-530 920-820]);
gamma = 180 - (360.*(delta./T));
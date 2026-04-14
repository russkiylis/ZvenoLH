R1 = 500e4;
C1 = 0.01e-6;

R2 = 0.2e6;
R3 = 20e4;
C2 = 4e-6;

%% == Первый пункт - ЛХ линейных САУ ==
tau1 = R1*C1;
K1 = 1/tau1;

tau2 = R3*C2;
tau3 = (R3+R2)*C2;

W1 = {
    struct('Type',"Усил",'K',K1),...
    struct('Type',"Интегр")
};
W2 = {
    struct('Type',"Усил",'K',K1),...
    struct('Type',"Интегр"),...
    struct('Type',"Апериод",'T',tau3),...
    struct('Type',"Форс",'T',tau2)
};
W3 = {
    struct('Type',"Усил",'K',K1),...
    struct('Type',"Интегр"),...
    struct('Type',"Апериод",'T',tau3),...
    struct('Type',"Форс",'T',tau2),...
    struct('Type',"Апериод",'T',tau3),...
    struct('Type',"Форс",'T',tau2)
};

LH1 = ZvenoLH(W1);
LH2 = ZvenoLH(W2);
LH3 = ZvenoLH(W3);

LH1.showSumLH([1/16 16], [-20 50], [-200 30]);
LH2.showSumLH([1/16 16], [-20 50], [-200 30]);
LH3.showSumLH([1/16 16], [-20 50], [-200 30]);

%% == Второй пункт - годографы нелинейных САУ ==

% Годограф НЭ (реле с гистерезисом)
b = 1;
c = b;

a = linspace(b*1.00001, 10*b, 5000);  % амплитуда от b до ...
Re_NE = -pi/(4*c) * sqrt(a.^2 - b^2);
Im_NE = -pi*b/(4*c) * ones(size(a));  % константа


figure(name="Годографы, 1 тип");
a = gca;
hold on;
plot(real(LH1.PF), imag(LH1.PF), 'LineWidth', 2);
plot(Re_NE, Im_NE, 'r', 'LineWidth', 1.5);
xlabel('Re');
ylabel('Im');
title('Годографы, 1 тип');
axis equal;
xlim([-1.5 1.5]);
ylim([-2 1]);
a.XAxisLocation = "origin";
a.YAxisLocation = "origin";
grid on;
legend('W_л(jω)', '-1/W_{НЭ}(a)');

figure(name="Годографы, 2 тип");
a = gca;
hold on;
plot(real(LH2.PF), imag(LH2.PF), 'LineWidth', 2);
plot(Re_NE, Im_NE, 'r', 'LineWidth', 1.5);
xlabel('Re');
ylabel('Im');
title('Годографы, 2 тип');
axis equal;
xlim([-1.5 1.5]);
ylim([-2 1]);
a.XAxisLocation = "origin";
a.YAxisLocation = "origin";
grid on;
legend('W_л(jω)', '-1/W_{НЭ}(a)')

% Точка пересечения для типа 2
Re_cross = -0.0383;
Im_cross = -0.785;

% Находим ближайшую точку на годографе
dist = abs(LH2.PF - (Re_cross + 1j*Im_cross));
[~, idx] = min(dist);
w0 = LH2.omega(idx);
disp(w0);

figure(name="Годографы, 3 тип");
a = gca;
hold on;
plot(real(LH3.PF), imag(LH3.PF), 'LineWidth', 2);
plot(Re_NE, Im_NE, 'r', 'LineWidth', 1.5);
xlabel('Re');
ylabel('Im');
title('Годографы, 3 тип');
axis equal;
xlim([-1.5 1.5]);
ylim([-2 1]);
a.XAxisLocation = "origin";
a.YAxisLocation = "origin";
grid on;
legend('W_л(jω)', '-1/W_{НЭ}(a)')

% Точка пересечения для типа 3
Re_cross = -0.151;
Im_cross = -0.785;

% Находим ближайшую точку на годографе
dist = abs(LH2.PF - (Re_cross + 1j*Im_cross));
[~, idx] = min(dist);
w0 = LH2.omega(idx);
disp(w0);


%% == Третий пункт - ЛХ линеаризованных САУ ==
b = 1;
c = b;
sigma_x = [b/2 b 2*b 4*b];

K0 = (c./sigma_x).*sqrt(2./pi).*exp(-(b.^2)./(2.*sigma_x.^2));
disp(K0);

for k = 1:length(K0)
    W1K = [W1, struct('Type',"Усил",'K',K0(k))];
    W2K = [W2, struct('Type',"Усил",'K',K0(k))];
    W3K = [W3, struct('Type',"Усил",'K',K0(k))];

    LH1K = ZvenoLH(W1K);
    LH2K = ZvenoLH(W2K);
    LH3K = ZvenoLH(W3K);

    LH1K.showSumLH([1/16 16], [-20 50], [-200 30]);
    LH2K.showSumLH([1/16 16], [-20 50], [-200 30]);
    LH3K.showSumLH([1/16 16], [-20 50], [-200 30]);
end
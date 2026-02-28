% Пример работы генератора ЛХ

K = 6;
Ta = 0.5;
Tf = 0.125;

% Передаточная функция цепи, разбитая на соответствующие звенья
% Каждое звено представляет собой структуру, как ниже.
% Можно добавлять свои звенья или убирать те, которые не нужны
% Информация по звеньям есть в Readme
W = {struct('Type', "Усил", 'K', K),...
    struct('Type', "Интегр"),...
    struct('Type', "Диф"),...
    struct('Type', "Апериод", 'T', Ta),...
    struct('Type', "Форс", 'T', Tf)};

% Создание объекта класса ZvenoLH. В нём происходит вся магия. При создании
% мы засовываем туда передаточную функцию, которую создали сверху
zvenoGen = ZvenoLH(W);

% Из созданного объекта можно высовывать как ЛХ звеньев по отдельности, так
% и суммарные ЛХ
% Для начала отобразим ЛХ звеньев по отдельности. Делается это следующим
% образом
figure(name="Усилительное звено");  % Создаём фигуру (окошко где будут графики)
tiledlayout(1,2);   % Указываем, что в окошке будет два графика. (1,2) значит, что будет 1 строка и 2 столбца
ax = nexttile;  % Говорим, что сейчас будем работать с первым графиком. ах - информация об осях.

% Строим логарифмический график. zvenoGen.w - точки частот. zvenoGen.L{1} -
% точки ЛАХ.
semilogx(zvenoGen.w, zvenoGen.L{1}, 'LineWidth', 2);
title("ЛАХ усилительного звена");   % Добавляем заголовок
grid on;    % Добавляем сетку
xlabel("\omega");   % Подписываем ось x (ось y подписывается сама)

% Берём информацию об осях и редактируем их с помощью особой функции. С её
% помощью оси будут выглядеть так как на рисунках в учебнике. 1 означает
% что мы рисуем ЛАХ, 0 - что рисуем ЛФХ.
EssentialsPack.octavePlotCfg(ax, 1);


% Теперь работаем со вторым графиком по аналогии с предудущим, но теперь
% используем не zvenoGen.L{1}, а zvenoGen.Phi{1}
ax = nexttile;
semilogx(zvenoGen.w, zvenoGen.Phi{1}, 'LineWidth', 2);
title("ЛФХ усилительного звена");   % Добавляем заголовок
grid on;    % Добавляем сетку
xlabel("\omega");   % Подписываем ось x (ось y подписывается сама)
grid on;
EssentialsPack.octavePlotCfg(ax, 0);


% Далее по аналогии отобразим ЛХ оставшихся звеньев
figure(name="Интегрирующее звено");
tiledlayout(1,2);
ax = nexttile;
semilogx(zvenoGen.w, zvenoGen.L{2}, 'LineWidth', 2);
grid on;
title("ЛАХ интегрирующего звена");
grid on;
xlabel("\omega");
EssentialsPack.octavePlotCfg(ax, 1);
ax = nexttile;
semilogx(zvenoGen.w, zvenoGen.Phi{2}, 'LineWidth', 2);
grid on;
title("ЛФХ интегрирующего звена");
grid on;
xlabel("\omega");
EssentialsPack.octavePlotCfg(ax, 0);


figure(name="Дифференциирующее звено");
tiledlayout(1,2);
ax = nexttile;
semilogx(zvenoGen.w, zvenoGen.L{3}, 'LineWidth', 2);
grid on;
title("ЛАХ дифференциирующего звена");
grid on;
xlabel("\omega");
EssentialsPack.octavePlotCfg(ax, 1);
ax = nexttile;
semilogx(zvenoGen.w, zvenoGen.Phi{3}, 'LineWidth', 2);
grid on;
title("ЛФХ дифференциирующего звена");
grid on;
xlabel("\omega");
EssentialsPack.octavePlotCfg(ax, 0);


figure(name="Апериодическое звено");
tiledlayout(1,2);
ax = nexttile;
semilogx(zvenoGen.w, zvenoGen.L{4}, 'LineWidth', 2);
grid on;
title("ЛАХ апериодического звена");
grid on;
xlabel("\omega");
EssentialsPack.octavePlotCfg(ax, 1);
ax = nexttile;
semilogx(zvenoGen.w, zvenoGen.Phi{4}, 'LineWidth', 2);
grid on;
title("ЛФХ апериодического звена");
grid on;
xlabel("\omega")
EssentialsPack.octavePlotCfg(ax, 0);


figure(name="Форсирующее звено");
tiledlayout(1,2);
ax = nexttile;
semilogx(zvenoGen.w, zvenoGen.L{5}, 'LineWidth', 2);
grid on;
title("ЛАХ форсирущего звена");
grid on;
xlabel("\omega");
EssentialsPack.octavePlotCfg(ax, 1);
ax = nexttile;
semilogx(zvenoGen.w, zvenoGen.Phi{5}, 'LineWidth', 2);
grid on;
title("ЛФХ форсирущего звена");
grid on;
xlabel("\omega");
EssentialsPack.octavePlotCfg(ax, 0);


% Теперь нарисуем графики ЛХ суммы звеньев. Теперь мы обращаемся к
% zvenoGen.Lsum и zvenoGen.Phisum
figure(name="Много звеньев")
tiledlayout(1,2);
ax = nexttile;
semilogx(zvenoGen.w, zvenoGen.Lsum, 'LineWidth', 2);
grid on;
title("ЛАХ суммы звеньев");
grid on;
xlabel("\omega");
EssentialsPack.octavePlotCfg(ax, 1);
ax = nexttile;
semilogx(zvenoGen.w, zvenoGen.Phisum, 'LineWidth', 2);
grid on;
title("ЛФХ суммы звеньев");
grid on;
xlabel("\omega");
EssentialsPack.octavePlotCfg(ax, 0);
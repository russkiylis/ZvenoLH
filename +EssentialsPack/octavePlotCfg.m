function octavePlotCfg(axis, isA)
%octavePlotCfg Конфигурация графика в соответствии с октавным отображением
%(привет САУ)

    % Настройка оси X
    axis.XAxisLocation = 'origin';
    axis.XTick = [1/32 1/16 1/8 1/4 1/2 1 2 4 8 16 32];
    axis.XTickLabel = {'1/32','1/16','1/8','1/4','1/2','1','2','4','8','16','32'};
    xlim([1/32 32]);

    % Настройка оси Y
    if isA  % Если амплитуда
        axis.YAxis.Visible = "off";
        YAxisPos = 1;   % положение вертикальной оси
        xline(YAxisPos);
        yl = [-36 36];
        y_marks = yl(1):6:yl(2);
        axis.YTick = y_marks;
    else    % Если фаза
        axis.YAxis.Visible = "off";
        YAxisPos = 1;   % положение вертикальной оси
        xline(YAxisPos);
        yl = [-180 180];
        y_marks = yl(1):45:yl(2);
        axis.YTick = y_marks;
    end
    

    % Далее рисуем штрихи на новой оси OY
    tick_ratio = 0.05;  % Длина штриха
    
    for k = 1:length(y_marks)
        y = y_marks(k);
    
        if y >= yl(1) && y <= yl(2)
    
            % Штрих (горизонтальный)
            line([YAxisPos YAxisPos*(1+tick_ratio)], ...
                 [y y], ...
                 'Color','k','LineWidth',1);
    
            % Подпись
            if y ~= 0
                 text(YAxisPos*(1-1*tick_ratio), y, ...
                 num2str(y), ...
                 'HorizontalAlignment','right', ...
                 'VerticalAlignment','middle');
            else
                 text(YAxisPos*(1-1*tick_ratio), y+24*tick_ratio, ...
                 num2str(y), ...
                 'HorizontalAlignment','right', ...
                 'VerticalAlignment','middle');
            end
        end
    end
end
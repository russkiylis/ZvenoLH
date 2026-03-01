classdef ZvenoLH
    %ZvenoLH Строитель ЛХ по звеньям

    % W = {struct('Type', "Усил", 'K', K),...
    %     struct('Type', "Интегр"),...
    %     struct('Type', "Апериод", 'T', Ta),...
    %     struct('Type', "Форс", 'T', Tf)};

    properties 
        W % Список звеньев
        L % ЛАХ отдельных звеньев
        Phi % ЛФХ отдельных звеньев
        Lsum % Суммарная ЛАХ
        Phisum % Суммарная ЛФХ

        omega
        w_sr_vec
    end

    methods
        function obj = ZvenoLH(W)

            % Конструктор
            obj.W = W;
            obj.omega = linspace(1/64, 64, 50000);

            for i = 1:length(W)
                switch W{i}.Type
                    case "Усил"
                        K = W{i}.K;     % Коэффициент усиления
                        
                        obj.L{i} = ones(1,length(obj.omega)).*K;    % ЛАХ
                        obj.Phi{i} = zeros(1,length(obj.omega));    % ЛФХ

                    case "Интегр"
                        obj.L{i} = -mag2db(obj.omega);  % ЛАХ
                        obj.Phi{i} = -90.*ones(1,length(obj.omega));    % ЛФХ

                    case "Диф"
                        obj.L{i} = mag2db(obj.omega);   % ЛАХ
                        obj.Phi{i} = 90.*ones(1,length(obj.omega)); % ЛФХ

                    case "Апериод"
                        T = W{i}.T;     % Постоянная времени
                        w_sr = 1/T;     % Частота согласования
                        obj.w_sr_vec = [obj.w_sr_vec w_sr];

                        w_const = obj.omega(obj.omega < w_sr);  % Точки частот до частоты согласования
                        w_line = obj.omega(obj.omega >= w_sr);  % Точки частот после частоты согласования
                        obj.L{i} = [zeros(1,length(w_const)) mag2db(w_sr)-mag2db(w_line)];  % ЛАХ


                        w_aperiod = [1./(32*T) 1./(16*T) 1./(8*T) 1./(4*T) 1./(2*T) 1./T 2./T 4./T 8./T 16./T 32./T];
                        grad_aperiod = [0 -2 -5.625 -11.25 -22.5 -45 -67.5 -78.75 -84.375 -88 -90];

                        omegaSpline = obj.omega(obj.omega>=1/(32*T) & obj.omega<=32/T);
                        lengthBefore = length(obj.omega(obj.omega<1/(32*T)));
                        lengthAfter = length(obj.omega(obj.omega>32/T));

                        phi_spline = interp1(w_aperiod, grad_aperiod, omegaSpline, 'pchip'); % Интерполяция по точкам ЛФХ
                        phi_aperiod = [ones(1,lengthBefore).*grad_aperiod(1) phi_spline ones(1,lengthAfter).*grad_aperiod(length(grad_aperiod))];
                        obj.Phi{i} = phi_aperiod;  % ЛФХ

                    case "Форс"
                        T = W{i}.T;     % Постоянная времени
                        w_sr = 1/T;     % Частота согласования
                        obj.w_sr_vec = [obj.w_sr_vec w_sr];
                        
                        w_const = obj.omega(obj.omega < w_sr);  % Точки частот до частоты согласования
                        w_line = obj.omega(obj.omega >= w_sr);  % Точки частот после частоты согласования  
                        obj.L{i} = [zeros(1,length(w_const)) -mag2db(w_sr)+mag2db(w_line)];  % ЛАХ

                        w_fors = [1./(32*T) 1./(16*T) 1./(8*T) 1./(4*T) 1./(2*T) 1./T 2./T 4./T 8./T 16./T 32./T];
                        grad_fors = -[0 -2 -5.625 -11.25 -22.5 -45 -67.5 -78.75 -84.375 -88 -90];

                        omegaSpline = obj.omega(obj.omega>=1/(32*T) & obj.omega<=32/T);
                        lengthBefore = length(obj.omega(obj.omega<1/(32*T)));
                        lengthAfter = length(obj.omega(obj.omega>32/T));

                        phi_fors = interp1(w_fors, grad_fors, omegaSpline, 'pchip'); % Интерполяция по точкам ЛФХ
                        phi_fors = [ones(1,lengthBefore).*grad_fors(1) phi_fors ones(1,lengthAfter).*grad_fors(length(grad_fors))];
                        obj.Phi{i} = phi_fors;  % ЛФХ
                end

                % Суммирование звеьев
                obj.Lsum = sum(cell2mat(obj.L'),1);
                obj.Phisum = sum(cell2mat(obj.Phi'),1);

            end
        end
        function showZvenoLH(obj, index, xlimit, ylimitL, ylimitPhi)
            figure(name="Звено "+int2str(index));
            tiledlayout(1,2);
            ax = nexttile;
            semilogx(obj.omega, obj.L{index}, 'LineWidth', 2);
            grid on;
            title("ЛАХ звена "+int2str(index));
            grid on;
            xlabel("\omega");
            EssentialsPack.octavePlotCfg(ax, 1, xlimit, ylimitL);
            if ~isempty(obj.w_sr_vec)
                xline(obj.w_sr_vec, '--k', 'LineWidth', 0.5);
            end
            ax = nexttile;
            semilogx(obj.omega, obj.Phi{index}, 'LineWidth', 2);
            grid on;
            title("ЛФХ звена "+int2str(index));
            grid on;
            xlabel("\omega");
            EssentialsPack.octavePlotCfg(ax, 0, xlimit, ylimitPhi);
            if ~isempty(obj.w_sr_vec)
                xline(obj.w_sr_vec, '--k', 'LineWidth', 0.5);
            end
        end
        function showSumLH(obj, xlimit, ylimitL, ylimitPhi)
            figure(name="ЛХ передаточной функции")
            tiledlayout(1,2);
            ax = nexttile;
            semilogx(obj.omega, obj.Lsum, 'LineWidth', 2);
            grid on;
            title("ЛАХ передаточной функции");
            grid on;
            xlabel("\omega");
            EssentialsPack.octavePlotCfg(ax, 1, xlimit, ylimitL);
            if ~isempty(obj.w_sr_vec)
                xline(obj.w_sr_vec, '--k', 'LineWidth', 0.5);
            end
            ax = nexttile;
            semilogx(obj.omega, obj.Phisum, 'LineWidth', 2);
            grid on;
            title("ЛФХ передаточной функции");
            grid on;
            xlabel("\omega");
            EssentialsPack.octavePlotCfg(ax, 0, xlimit, ylimitPhi);
            if ~isempty(obj.w_sr_vec)
                xline(obj.w_sr_vec, '--k', 'LineWidth', 0.5);
            end
        end
    end
end
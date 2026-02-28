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

        w
    end

    methods
        function obj = ZvenoLH(W)
            % Конструктор
            obj.W = W;
            obj.w = linspace(1/32,32, 10000);

            for i = 1:length(W)
                switch W{i}.Type
                    case "Усил"
                        K = W{i}.K;     % Коэффициент усиления
                        
                        obj.L{i} = ones(1,length(obj.w)).*K;    % ЛАХ
                        obj.Phi{i} = zeros(1,length(obj.w));    % ЛФХ

                    case "Интегр"
                        obj.L{i} = -mag2db(obj.w);  % ЛАХ
                        obj.Phi{i} = -90.*ones(1,length(obj.w));    % ЛФХ

                    case "Диф"
                        obj.L{i} = mag2db(obj.w);   % ЛАХ
                        obj.Phi{i} = 90.*ones(1,length(obj.w)); % ЛФХ

                    case "Апериод"
                        T = W{i}.T;     % Постоянная времени
                        w_sr = 1/T;     % Частота согласования
                        
                        w_const = obj.w(obj.w < w_sr);  % Точки частот до частоты согласования
                        w_line = obj.w(obj.w >= w_sr);  % Точки частот после частоты согласования
                        
                        obj.L{i} = [zeros(1,length(w_const)) mag2db(w_sr)-mag2db(w_line)];  % ЛАХ
                        w_fors = [1./(32*T) 1./(16*T) 1./(8*T) 1./(4*T) 1./(2*T) 1./T 2./T 4./T 8./T 16./T 32./T];
                        grad_fors = [0 -2 -5.625 -11.25 -22.5 -45 -67.5 -78.75 -84.375 -88 -90];
                        phi_fors = interp1(w_fors, grad_fors, obj.w, 'spline'); % Интерполяция по точкам ЛФХ
                        obj.Phi{i} = phi_fors;  % ЛФХ

                    case "Форс"
                        T = W{i}.T;     % Постоянная времени
                        w_sr = 1/T;     % Частота согласования
                        
                        w_const = obj.w(obj.w < w_sr);  % Точки частот до частоты согласования
                        w_line = obj.w(obj.w >= w_sr);  % Точки частот после частоты согласования
                        
                        obj.L{i} = [zeros(1,length(w_const)) -mag2db(w_sr)+mag2db(w_line)];  % ЛАХ
                        w_fors = [1./(32*T) 1./(16*T) 1./(8*T) 1./(4*T) 1./(2*T) 1./T 2./T 4./T 8./T 16./T 32./T];
                        grad_fors = -[0 -2 -5.625 -11.25 -22.5 -45 -67.5 -78.75 -84.375 -88 -90];
                        phi_fors = interp1(w_fors, grad_fors, obj.w, 'spline'); % Интерполяция по точкам ЛФХ
                        obj.Phi{i} = phi_fors;  % ЛФХ

                end

                % Суммирование звеьев
                obj.Lsum = sum(cell2mat(obj.L'),1);
                obj.Phisum = sum(cell2mat(obj.Phi'),1);

            end
        end
    end
end
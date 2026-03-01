classdef testZvenoLH < matlab.unittest.TestCase

    methods (Test)
        % Test methods

        function testAmpl(testCase)
            K = mag2db(10.^(0.3));
            
            % Ta = 0.5;
            % Tf = 0.125;

            % W = {struct('Type', "Усил", 'K', K),...
            %     struct('Type', "Интегр"),...
            %     struct('Type', "Апериод", 'T', Ta),...
            %     struct('Type', "Форс", 'T', Tf)};
            
            W1 = {struct('Type', "Усил", 'K', K)};

            zvenoGen = ZvenoLH(W1);

            figure(name="Усилительное звено")
            tiledlayout(2,1);
            ax = nexttile;
            semilogx(zvenoGen.omega, zvenoGen.L{1}, 'LineWidth', 2);
            grid on;
            EssentialsPack.octavePlotCfg(ax, 1);

            ax = nexttile;
            semilogx(zvenoGen.omega, zvenoGen.Phi{1}, 'LineWidth', 2);
            grid on;
            EssentialsPack.octavePlotCfg(ax, 0);

        end

        function testIntegr(testCase)
            
            % Ta = 0.5;
            % Tf = 0.125;

            % W = {struct('Type', "Усил", 'K', K),...
            %     struct('Type', "Интегр"),...
            %     struct('Type', "Апериод", 'T', Ta),...
            %     struct('Type', "Форс", 'T', Tf)};
            
            W1 = {struct('Type', "Интегр")};
            
            zvenoGen = ZvenoLH(W1);

            figure(name="Интегрирующее звено")
            tiledlayout(2,1);
            ax = nexttile;
            semilogx(zvenoGen.omega, zvenoGen.L{1}, 'LineWidth', 2);
            grid on;
            EssentialsPack.octavePlotCfg(ax, 1);
            
            ax = nexttile;
            semilogx(zvenoGen.omega, zvenoGen.Phi{1}, 'LineWidth', 2);
            grid on;
            EssentialsPack.octavePlotCfg(ax, 0);
        end

        function testDiff(testCase)
            
            % Ta = 0.5;
            % Tf = 0.125;

            % W = {struct('Type', "Усил", 'K', K),...
            %     struct('Type', "Интегр"),...
            %     struct('Type', "Апериод", 'T', Ta),...
            %     struct('Type', "Форс", 'T', Tf)};
            
            W1 = {struct('Type', "Диф")};
            
            zvenoGen = ZvenoLH(W1);

            figure(name="Дифференциирующее звено")
            tiledlayout(2,1);
            ax = nexttile;
            semilogx(zvenoGen.omega, zvenoGen.L{1}, 'LineWidth', 2);
            grid on;
            EssentialsPack.octavePlotCfg(ax, 1);
            
            ax = nexttile;
            semilogx(zvenoGen.omega, zvenoGen.Phi{1}, 'LineWidth', 2);
            grid on;
            EssentialsPack.octavePlotCfg(ax, 0);

        end

        function testAperiod(testCase)
            
            Ta = 0.5;
            % Tf = 0.125;

            % W = {struct('Type', "Усил", 'K', K),...
            %     struct('Type', "Интегр"),...
            %     struct('Type', "Апериод", 'T', Ta),...
            %     struct('Type', "Форс", 'T', Tf)};
            
            W1 = {struct('Type', "Апериод", 'T', Ta)};
            
            zvenoGen = ZvenoLH(W1);

            figure(name="Апериодическое звено")
            tiledlayout(2,1);
            ax = nexttile;
            semilogx(zvenoGen.omega, zvenoGen.L{1}, 'LineWidth', 2);
            grid on;
            EssentialsPack.octavePlotCfg(ax, 1);
            
            ax = nexttile;
            semilogx(zvenoGen.omega, zvenoGen.Phi{1}, 'LineWidth', 2);
            grid on;
            EssentialsPack.octavePlotCfg(ax, 0);

        end

        function testFors(testCase)
            
            Tf = 0.5;
            % Tf = 0.125;

            % W = {struct('Type', "Усил", 'K', K),...
            %     struct('Type', "Интегр"),...
            %     struct('Type', "Апериод", 'T', Ta),...
            %     struct('Type', "Форс", 'T', Tf)};
            
            W1 = {struct('Type', "Форс", 'T', Tf)};
            
            zvenoGen = ZvenoLH(W1);

            figure(name="Форсирующее звено")
            tiledlayout(2,1);
            ax = nexttile;
            semilogx(zvenoGen.omega, zvenoGen.L{1}, 'LineWidth', 2);
            grid on;
            EssentialsPack.octavePlotCfg(ax, 1);
            
            ax = nexttile;
            semilogx(zvenoGen.omega, zvenoGen.Phi{1}, 'LineWidth', 2);
            grid on;
            EssentialsPack.octavePlotCfg(ax, 0);

        end

        function testFull(testCase)
            K = mag2db(10.^(0.3));
            Ta = 0.5;
            Tf = 0.125;

            W = {struct('Type', "Усил", 'K', K),...
                struct('Type', "Интегр"),...
                struct('Type', "Апериод", 'T', Ta),...
                struct('Type', "Форс", 'T', Tf)};
            
            zvenoGen = ZvenoLH(W);

            zvenoGen.showZvenoLH(1);
            zvenoGen.showZvenoLH(2);
            zvenoGen.showZvenoLH(3);
            zvenoGen.showZvenoLH(4);
            zvenoGen.showSumLH;

        end

        function octavesPlot(testCase)
            % Пример данных
            f = [1/8 1/4 1/2 1 2 4 8];      % октавы
            H = [0 -6 -12 -18 -24 -30 -36];  % амплитуда в дБ
            
            figure(name="Тест октавного графика")
            ax = axes;
            
            semilogx(f, H, 'LineWidth', 2);

            EssentialsPack.octavePlotCfg(ax,1);
            

           
        end
    end
       
end
K = 10;
Ta = 0.5;
Tf = 0.2;

W = {
    struct('Type',"Усил",'K',K),...
    struct('Type',"Интегр"),...
    struct('Type',"Апериод",'T',Ta),...
    struct('Type',"Форс",'T',Tf)
};

zvenoGen = ZvenoLH(W);

zvenoGen.showSumLH([1/4 64], [-55 20], [-200 30]);  % для вывода ЛХ всей цепи
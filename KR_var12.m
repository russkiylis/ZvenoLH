K = 6;
Ta = 2;
Tf = 4;
Tf1 = 1;

W = {
    struct('Type',"Усил",'K',K),...
    struct('Type',"Интегр"),...
    struct('Type',"Интегр"),...
    struct('Type',"Апериод",'T',Ta),...
    struct('Type',"Форс",'T',Tf),...
    struct('Type',"Форс",'T',Tf1)
};

LH = ZvenoLH(W);

LH.showSumLH([1/4 64], [-55 20], [-200 30]);  % для вывода ЛХ всей цепи
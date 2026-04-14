K = 10;
Ta = 0.5;
Tf = 0.2;

W = {
    struct('Type',"Усил",'K',K),...
    struct('Type',"Интегр"),...
    struct('Type',"Апериод",'T',Ta),...
    struct('Type',"Форс",'T',Tf)
};

W = {
    struct('Type',"Апериод",'T',0.0156),...
};

LH = ZvenoLH(W);

LH.showSumLH([1 1024], [-30 20], [-100 30]);  % для вывода ЛХ всей цепи
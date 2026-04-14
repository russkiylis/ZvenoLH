tau_nofb = 0.3217;
K_nofb = 23.56;
tau_fb = 0.032;
K_fb = 1./0.0495;
tau_check = 0.3217;
K_check = 23.56*10;

W_nofb = {
    struct('Type',"Усил",'K',K_nofb),...
    struct('Type',"Интегр"),...
    struct('Type',"Апериод",'T',tau_nofb)
};
W_fb = {
    struct('Type',"Усил",'K',K_fb),...
    struct('Type',"Интегр"),...
    struct('Type',"Апериод",'T',tau_fb)
};
W_check = {
    struct('Type',"Усил",'K',K_check),...
    struct('Type',"Интегр"),...
    struct('Type',"Апериод",'T',tau_check)
};

LH_nofb = ZvenoLH(W_nofb);
LH_fb = ZvenoLH(W_fb);
LH_check = ZvenoLH(W_check);

LH_nofb.showSumLH([1/2 128], [-20 50], [-200 30]);
LH_fb.showSumLH([1/2 128], [-20 50], [-200 30]);
LH_check.showSumLH([1/2 128], [-20 50], [-200 30]);
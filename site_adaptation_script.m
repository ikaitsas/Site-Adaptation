% ---- ERGASIA 3 - FA2 - SITE ADAPTATION ---- %

format longG
fsize=15;


% xrhsh least square line gia to adaptation

% prepei na vrw enan genikotero tropo gia na xwrizw ta training kai test
% data (p.x. sthn allagh xronou me for loop), ta indexes edw 
% antistoixoun  mono sto arxeio parakatw
% auto den tha htan provlhma an ta training kai test datasets dinontan 
% ksexrista vevaia


% -- VALE TO ARXEIO EDW -- %
t_able=readtable('4_Sede_Boqer_COMP_COR_2006_2007.txt');


% xwrismos training kai test data
table_tr=table(t_able{1:242,5},t_able{1:242,6});
table_tr.Properties.VariableNames={'GHIg_train','GHIsat_train'};
table_test=table(t_able{243:482,5},t_able{243:482,6});
table_test.Properties.VariableNames={'GHIg_test','GHIsat_test'};


% xwrismos kai orismos training kai testing kommatiwn
ghi_g_tr=table_tr{:,1}; 
ghi_sat_tr=table_tr{:,2}; 
ghi_g_test=table_test{:,1};
ghi_sat_test=table_test{:,2};


%% -- TRAINING -- %%


% elaxista tetragwna gia training xwris diorthwsh
lsq_mod_tr=polyfit(ghi_g_tr,ghi_sat_tr,1); % lsline syntelestes gia ghi sat & ghi g 

[~,~,~,~,stats_tr]=regress(ghi_sat_tr,ghi_g_tr); % r tetragwno gia training xwris diorthwsh
MBD_tr=mean(ghi_sat_tr-ghi_g_tr)
rMBD_tr=(100/length(ghi_g_tr))*(sum(ghi_sat_tr-ghi_g_tr)/mean(ghi_g_tr))
rfrf=mean(ghi_sat_tr-ghi_g_tr)*(100/mean(ghi_g_tr)); % aplousterh formoula tou parapanw
RMSD_tr=sqrt(mean((ghi_sat_tr-ghi_g_tr).^2))
rRMSD_tr=sqrt((1/length(ghi_g_tr))*(sum((ghi_sat_tr-ghi_g_tr).^2)))*(100/mean(ghi_g_tr))
ghgh=sqrt(mean((ghi_sat_tr-ghi_g_tr).^2))*(100/mean(ghi_g_tr)); % aplousterh formoula tou parapanw


% grafikh toy montelou - xwris diorthwsh - training
figure(1)
scatter(ghi_g_tr,ghi_sat_tr,10,'filled','r');
hold on
fplot(@(x) lsq_mod_tr(1)*x+lsq_mod_tr(2),'k','LineWidth',2);
hold on
fplot(@(x) x,'b','LineWidth',2,'LineStyle','--');
grid on
xlim([0 10])
ylim([0 10])
title('Training Dataset - No Correction')
xlabel('GHIg','Fontsize',fsize);
ylabel('GHIsat','Fontsize',fsize);
legend('GHIg-GHIsat Pair','Least Square Line','GHIsat=GHIg Line','Location','southeast')


% elaxista tetragwna gia training me diorthwsh metaksy sat timwn - xrhsimo
% gia testing phase
ghi_mod_tr_cor=ghi_sat_tr-((lsq_mod_tr(1)-1)*ghi_g_tr+lsq_mod_tr(2)); % ghi satellite corrected
lsq_mod_tr_cor=polyfit(ghi_sat_tr,ghi_mod_tr_cor,1); % lsline syntelestes gia correction metaksy sat timwn


% grafikh diorthwshs sat data - training - xrhsimo gia testing phase
figure(2)
scatter(ghi_sat_tr,ghi_mod_tr_cor,10,'filled','r');
hold on
fplot(@(x) lsq_mod_tr_cor(1)*x+lsq_mod_tr_cor(2),'k','LineWidth',2)
hold on
fplot(@(x) x,'b','LineWidth',2,'LineStyle','--');
grid on
xlim([0 10])
ylim([0 10])
title('Training Dataset - Relationship Between GHIsat & GHIsat,cor')
xlabel('GHIsat','Fontsize',fsize);
ylabel('GHIsat,cor','Fontsize',fsize);
legend('GHIsat-GHIsat,cor Pair','Least Square Line','GHIsat=GHIsat,cor Line','Location','southeast')


lsq_tr_cor=polyfit(ghi_g_tr,ghi_mod_tr_cor,1); % lsline syntelestes gia correction metaksy sat - g

[~,~,~,~,stats_tr_cor]=regress(ghi_mod_tr_cor,ghi_g_tr);
MBD_tr_cor=mean(ghi_mod_tr_cor-ghi_g_tr)
rMBD_tr_cor=(100/length(ghi_g_tr))*(sum(ghi_mod_tr_cor-ghi_g_tr)/mean(ghi_g_tr))
RMSD_tr_cor=sqrt(mean((ghi_mod_tr_cor-ghi_g_tr).^2))
rRMSD_tr_cor=sqrt((1/length(ghi_g_tr))*(sum((ghi_mod_tr_cor-ghi_g_tr).^2)))*(100/mean(ghi_g_tr))


% grafikh toy montelou - me diorthwsh - training
figure(3)
scatter(ghi_g_tr,ghi_mod_tr_cor,10,'filled','r');
hold on
fplot(@(x) lsq_tr_cor(1)*x+lsq_tr_cor(2),'k','LineWidth',2)
hold on
fplot(@(x) x,'b','LineWidth',2,'LineStyle','--');
grid on
xlim([0 10])
ylim([0 10])
title('Training Dataset - Applied Correction to GHIsat')
xlabel('GHIg','Fontsize',fsize);
ylabel('GHIsat,cor','Fontsize',fsize);
legend('GHIg-GHIsat,cor Pair','Least Square Line','GHIg=GHIsat,cor Line','Location','southeast')


%% -- TEST -- %%


% elaxista tetragwna gia test xwris diorthwsh
lsq_mod_test=polyfit(ghi_g_test,ghi_sat_test,1);   

[~,~,~,~,stats_test]=regress(ghi_sat_test,ghi_g_test);
MBD_test=mean(ghi_sat_test-ghi_g_test)
rMBD_test=(100/length(ghi_g_test))*(sum(ghi_sat_test-ghi_g_test)/mean(ghi_g_test))
RMSD_test=sqrt(mean((ghi_sat_test-ghi_g_test).^2))
rRMSD_test=sqrt((1/length(ghi_g_test))*(sum((ghi_sat_test-ghi_g_test).^2)))*(100/mean(ghi_g_test))


% grafikh toy montelou - xwris diorthwsh - test
figure(4)
scatter(ghi_g_test,ghi_sat_test,10,'filled','r');
hold on
fplot(@(x) lsq_mod_test(1)*x+lsq_mod_test(2),'k','LineWidth',2);
hold on
fplot(@(x) x,'b','LineWidth',2,'LineStyle','--');
grid on
xlim([0 10])
ylim([0 10])
title('Test Dataset - No Correction')
xlabel('GHIg','Fontsize',fsize);
ylabel('GHIsat','Fontsize',fsize);
legend('GHIg-GHIsat Pair','Least Square Line','GHIsat=GHIg Line','Location','southeast')


% elaxista tetragwna gia test me diorthwsh metaksy sat timwn 
lsq_mod_test_cor=polyfit(ghi_sat_tr,ghi_mod_tr_cor,1); % apo training
ghi_mod_test_cor=polyval(lsq_mod_test_cor,ghi_sat_test);


% grafikh diorthwshs sat data me vash to training - test 
figure(5)
scatter(ghi_sat_test,ghi_mod_test_cor,10,'filled','r');
hold on
fplot(@(x) lsq_mod_test_cor(1)*x+lsq_mod_test_cor(2),'k','LineWidth',2)
hold on
fplot(@(x) x,'b','LineWidth',2,'LineStyle','--');
grid on
xlim([0 10])
ylim([0 10])
title('Test Dataset - Relationship Between GHIsat & GHIsat,cor')
xlabel('GHIsat','Fontsize',fsize);
ylabel('GHIsat,cor','Fontsize',fsize);
legend('GHIsat-GHIsat,cor Pair','Least Square Line','GHIsat=GHIsat,cor Line','Location','southeast')


lsq_test_cor=polyfit(ghi_g_test,ghi_mod_test_cor,1); 

[~,~,~,~,stats_test_cor]=regress(ghi_mod_test_cor,ghi_g_test);
MBD_test_cor=mean(ghi_mod_test_cor-ghi_g_test)
rMBD_test_cor=(100/length(ghi_g_test))*(sum(ghi_mod_test_cor-ghi_g_test)/mean(ghi_g_test))
RMSD_test_cor=sqrt(mean((ghi_mod_test_cor-ghi_g_test).^2))
rRMSD_test_cor=sqrt((1/length(ghi_g_test))*(sum((ghi_mod_test_cor-ghi_g_test).^2)))*(100/mean(ghi_g_test))


% grafikh toy montelou - me diorthwsh - test -- AXRHSTH
figure(6)
scatter(ghi_g_test,ghi_mod_test_cor,10,'filled','r');
hold on
fplot(@(x) lsq_test_cor(1)*x+lsq_test_cor(2),'k','LineWidth',2)
hold on
fplot(@(x) x,'b','LineWidth',2,'LineStyle','--');
grid on
xlim([0 10])
ylim([0 10])
title('Test Dataset - Applied Correction to GHIsat')
xlabel('GHIg','Fontsize',fsize);
ylabel('GHIsat,cor','Fontsize',fsize);
legend('GHIg-GHIsat,cor Pair','Least Square Line','GHIg=GHIsat,cor Line','Location','southeast')


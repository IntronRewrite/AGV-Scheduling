clear
clc
close all
tic
%%初始化参数
load Pos;%位置矩阵
load X;%卸箱任务点及时间窗
load Y;%装箱任务点及时间窗
load Tlast;%AGV返回时间
m = size(Tlast,1);%AGV数目
tload = 120;%AGV装箱时间
v = 6;%AGV运行速度
pop = 100;%初始化种群数目
gg = 0.9;%代沟
pc = 0.9;%交叉概率
pm = 0.9;%变异概率
pr = 0.9; %逆转概率
pf = 1000000;%满载惩罚因子
pw = 10000;%重量惩罚因子
pql = 1000;%岸桥最早惩罚因子
pqr = 10000;%岸桥最晚惩罚因子
py = 1000;%场桥惩罚因子
maxgen = 200;%迭代次数
%%遗传算法
%%编码映射
Map = [X;Y];
X(:,1) = 1:size(X,1);
Y(:,1) = 1+size(X,1):size(X,1)+size(Y,1);
%%构造初始解
Chrom = InitPop(X,Y,m,pop);
%%计算适应度
FitnV = Fitness(Chrom,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
disp(['初始种群适应度：',num2str(FitnV(1,1))])
disp(['不满足场桥最晚时间的任务点个数：',num2str(FitnV(1,2)),' 不满足岸桥最晚时间的任务点个数：',num2str(FitnV(1,3))])
disp(['不满足场桥最早时间的任务点个数：',num2str(FitnV(1,4)),' 不满足岸桥最早时间的任务点个数：',num2str(FitnV(1,5))])
disp(['不满足满载任务点个数：',num2str(FitnV(1,6)),' 不满足重量限制任务点个数：',num2str(FitnV(1,7))]);
%%优化
gen = 1; %当前迭代次数
figure;
hold on;
box on
xlim([0,maxgen])
title('优化过程')
xlabel('迭代次数')
ylabel('当前最优值')
Path_GA = zeros(maxgen,1);
while gen<=maxgen
    %% 计算适应度
    FitnV = Fitness(Chrom,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
    Path_GA(gen) = min(FitnV(:,1));%选择最优个体保存
    %% 选择
    SelCh=Select(Chrom,FitnV,gg);
    %% 交叉操作
    SelCh=Recombin(SelCh,pc);
    %% 变异
    SelCh=Mutate(SelCh,pm);
    %% 逆转操作
    SelCh1=Reverse(SelCh,pr);
    %% 择优替换
    FitS1 = Fitness(SelCh1,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
    FitS = Fitness(SelCh,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
    FitS1 = FitS1(:,1);
    FitS = FitS(:,1);
    index=FitS1<FitS;
    SelCh(index,:)=SelCh1(index,:);
    %% 重插入子代的新种群
    Chrom=Reins(Chrom,SelCh,FitnV);
    %% 更新迭代次数
    gen=gen+1 ;
end
%% 输出结果
plot(Path_GA);
[~,index] = min(FitnV(:,1));
disp(['优化后种群适应度：',num2str(FitnV(1,1))])
disp(['不满足场桥最晚时间的任务点个数：',num2str(FitnV(1,2)),' 不满足岸桥最晚时间的任务点个数：',num2str(FitnV(1,3))])
disp(['不满足场桥最早时间的任务点个数：',num2str(FitnV(1,4)),' 不满足岸桥最早时间的任务点个数：',num2str(FitnV(1,5))])
disp(['不满足满载任务点个数：',num2str(FitnV(1,6)),' 不满足重量限制任务点个数：',num2str(FitnV(1,7))]);

caroads = Outputroads(Chrom(index,:),X,Y,Map,Tlast);
[time,~,~] = costime(caroads,X,Y,Map,Tlast,Pos,tload,v,pql,pqr,py);
disp(['总时间为：',num2str(time)])
toc

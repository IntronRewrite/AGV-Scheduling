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
pf = 1000000;%满载惩罚因子
pw = 10000;%重量惩罚因子
pql = 1000;%岸桥最早惩罚因子
pqr = 10000;%岸桥最晚惩罚因子
py = 1000;%场桥惩罚因子
maxgen = 200;%迭代次数
%%混合粒子
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
[value,index] = min(FitnV(:,1));
CurrentBest = Chrom;%当前个体最优
GlobalBest = Chrom(index,:);%全局最优
recordCB = inf*ones(1,pop);%个体最优记录
recordGB = value;%群体最优记录
New = Chrom;
%%优化
gen = 1; %当前迭代次数
figure;
hold on;
box on
xlim([0,maxgen])
title('优化过程')
xlabel('迭代次数')
ylabel('当前最优值')
Path_HSPO = zeros(maxgen,1);
while gen<=maxgen
    %% 计算适应度
    FitnV = Fitness(Chrom,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
    Path_HSPO(gen) = min(FitnV(:,1));
    for i = 1:pop
        if FitnV(i,1)<recordCB(i)
            recordCB(i) = FitnV(i,1);
            CurrentBest(i,:) = Chrom(i,:);
        end
        if FitnV(i,1)<recordGB
            recordGB = FitnV(i,1);
            GlobalBest = Chrom(i,:);
        end
    end
    New = Cross(New,CurrentBest);%个体交叉
    NewFit = Fitness(New,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
    for i = 1:pop
        if FitnV(i,1)>NewFit(i,1)
            Chrom(i,:) = New(i,:);
        end
    end
    New = CrossG(New,GlobalBest);%个体交叉
    NewFit = Fitness(New,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
    for i = 1:pop
        if FitnV(i,1)>NewFit(i,1)
            Chrom(i,:) = New(i,:);
        end
    end
    New = variation(New);
    NewFit = Fitness(Chrom,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
    for i = 1:pop
        if FitnV(i,1)>NewFit(i,1)
            Chrom(i,:) = New(i,:);
        end
    end
    %% 更新迭代次数
    gen=gen+1 ;
end
%% 输出结果
plot(Path_HSPO);
[~,index] = min(FitnV(:,1));
disp(['优化后种群适应度：',num2str(FitnV(1,1))])
disp(['不满足场桥最晚时间的任务点个数：',num2str(FitnV(1,2)),' 不满足岸桥最晚时间的任务点个数：',num2str(FitnV(1,3))])
disp(['不满足场桥最早时间的任务点个数：',num2str(FitnV(1,4)),' 不满足岸桥最早时间的任务点个数：',num2str(FitnV(1,5))])
disp(['不满足满载任务点个数：',num2str(FitnV(1,6)),' 不满足重量限制任务点个数：',num2str(FitnV(1,7))]);
caroads = Outputroads(Chrom(index,:),X,Y,Map,Tlast);
[time,~,~] = costime(caroads,X,Y,Map,Tlast,Pos,tload,v,pql,pqr,py);
disp(['总时间为：',num2str(time)])
toc
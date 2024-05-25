clear
clc
close all
tic
%%初始化参数
load('D:\遗传算法\模拟退火算法\Pos.mat');
load('D:\遗传算法\模拟退火算法\X.mat');
load('D:\遗传算法\模拟退火算法\Y.mat');
load('D:\遗传算法\模拟退火算法\Tlast.mat');
m = size(Tlast,1);%AGV数目
tload = 120;%AGV装箱时间
v = 6;%AGV运行速度
pop = 1;%初始化种群数目
pf = 1000000;%满载惩罚因子
pw = 10000;%重量惩罚因子
pql = 1000;%岸桥最早惩罚因子
pqr = 10000;%岸桥最晚惩罚因子
py = 1000;%场桥惩罚因子
maxgen = 200;%迭代次数
t0 = 2000;%初始温度
tend = 1e-3;%终止温度
loop = 200;%迭代次数 链长
tv = 0.95;%降温速率
%%模拟退火
%%编码映射
Map = [X;Y];
X(:,1) = 1:size(X,1);
Y(:,1) = 1+size(X,1):size(X,1)+size(Y,1);
%%构造初始解
S1 = InitPop(X,Y,m,pop);
[cow,rol] = size(S1);
%%计算适应度
FitnV = Fitness(S1,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
disp(['初始种群适应度：',num2str(FitnV(1,1))])
disp(['不满足场桥最晚时间的任务点个数：',num2str(FitnV(1,2)),' 不满足岸桥最晚时间的任务点个数：',num2str(FitnV(1,3))])
disp(['不满足场桥最早时间的任务点个数：',num2str(FitnV(1,4)),' 不满足岸桥最早时间的任务点个数：',num2str(FitnV(1,5))])
disp(['不满足满载任务点个数：',num2str(FitnV(1,6)),' 不满足重量限制任务点个数：',num2str(FitnV(1,7))]);
%%计算迭代次数
syms x;
time=ceil(double(solve(t0*(tv)^x == tend,x)));
count = 0;%迭代次数
Ans = zeros(time,1); %目标矩阵初始化
Track = zeros(time,rol); %每代最优路线矩阵初始化
bestans = ones(1,7);%保留最佳适应度值

%%优化
figure;
hold on;
box on
xlim([0,maxgen])
title('优化过程')
xlabel('迭代次数')
ylabel('当前最优值')

while t0>tend
    count = count + 1;
    temp = zeros(loop,rol+1);
    RR=zeros(loop,7);
    for k = 1:loop
        %%产生新解
        S = NewAnswer(S1);
        %% Metropolis法则判断是否接受新解
        FitS1 = Fitness(S1,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
        FitS = Fitness(S,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
        [S1,R] = Metropolis(FitS,FitS1,S,S1,t0);
        RR(k,:)=R;
        temp(k,:)= [S1 R(1)]; %记录下一路线的及其路程
    end
    [d0,index] = min(temp(:,end));%当前温度最优路线
    if count ==1 || d0<Ans(count-1)
        Ans(count)=d0;
        bestans = RR(index,:);
    else
        Ans(count)=Ans(count-1);
    end
    Track(count,:)=temp(index,1:end-1);%记录当前温度最优路线
    t0 = tv*t0;%降温
    %% 绘制收敛曲线
    plot(1:count, Ans(1:count));
    drawnow;
end
%% 输出结果
[~,index] = min(Ans(:,1));
disp('优化后种群适应度及详细情况：');
disp(['最佳适应度值：', num2str(bestans(1))]);
disp(['不满足场桥最晚时间的任务点个数：', num2str(bestans(2)), ' 不满足岸桥最晚时间的任务点个数：', num2str(bestans(3))]);
disp(['不满足场桥最早时间的任务点个数：', num2str(bestans(4)), ' 不满足岸桥最早时间的任务点个数：', num2str(bestans(5))]);
disp(['不满足满载任务点个数：', num2str(bestans(6)), ' 不满足重量限制任务点个数：', num2str(bestans(7))]);
caroads = Outputroads(Track(index,:),X,Y,Map,Tlast);
[time,~,~] = costime(caroads,X,Y,Map,Tlast,Pos,tload,v,pql,pqr,py);
disp(['总时间为：',num2str(time)])
toc

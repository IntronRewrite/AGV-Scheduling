clear
clc
close all
tic
%% 初始化参数
load Pos;% 位置矩阵
load X;% 卸箱任务点及时间窗
load Y;% 装箱任务点及时间窗
load Tlast;% AGV返回时间
m = size(Tlast,1);% AGV数目
tload = 120;% AGV装箱时间
v = 6;% AGV运行速度
pop = 100;% 初始化种群数目
gg = 0.9;% 代沟
pc = 0.9;% 交叉概率
pm = 0.9;% 变异概率
pr = 0.9; % 逆转概率
pf = 1000000;% 满载惩罚因子
pw = 10000;% 重量惩罚因子
pql = 1000;% 岸桥最早惩罚因子
pqr = 10000;% 岸桥最晚惩罚因子
py = 1000;% 场桥惩罚因子
maxgen = 200;% 迭代次数
num_experiments = 200; % 实验次数
Path_HSPO = inf(maxgen,1); % 存储最好的路径
total_points_unsatisfied = zeros(num_experiments, 7); % 存储每次实验中不满足条件的任务点个数
total_times = zeros(num_experiments, 1);% 存储每次实验中的总时间
for exp_index = 1:num_experiments
    %%HSPO
    %%编码映射
    Map = [X;Y];
    Xmat=X;
    Ymat=Y;
    Xmat(:,1) = 1:size(Xmat,1);
    Ymat(:,1) = 1+size(Xmat,1):size(Xmat,1)+size(Ymat,1);
    %%构造初始解
    Chrom = InitPop(Xmat,Ymat,m,pop);
    %%计算适应度
    FitnV = Fitness(Chrom,Pos,Xmat,Ymat,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
    Path = zeros(maxgen,1);
    [value,index] = min(FitnV(:,1));
    CurrentBest = Chrom;%当前个体最优
    GlobalBest = Chrom(index,:);%全局最优
    recordCB = inf*ones(1,pop);%个体最优记录
    recordGB = value;%群体最优记录
    New = Chrom;
    gen = 1; %当前迭代次数
    while gen<=maxgen
        %% 计算适应度
        FitnV = Fitness(Chrom,Pos,Xmat,Ymat,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
        Path(gen) = min(FitnV(:,1));
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
        NewFit = Fitness(New,Pos,Xmat,Ymat,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
        for i = 1:pop
            if FitnV(i,1)>NewFit(i,1)
                Chrom(i,:) = New(i,:);
            end
        end
        New = CrossG(New,GlobalBest);%个体交叉
        NewFit = Fitness(New,Pos,Xmat,Ymat,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
        for i = 1:pop
            if FitnV(i,1)>NewFit(i,1)
                Chrom(i,:) = New(i,:);
            end
        end
        New = variation(New);
        NewFit = Fitness(Chrom,Pos,Xmat,Ymat,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
        for i = 1:pop
            if FitnV(i,1)>NewFit(i,1)
                Chrom(i,:) = New(i,:);
            end
        end
        %% 更新迭代次数
        gen=gen+1 ;
    end
    if min(Path)<min(Path_HSPO)
        Path_HSPO=Path;
    end
    %% 统计不满足条件的任务点个数
    plot(Path);
    [~,index] = min(FitnV(:,1)); % 找到具有最小适应度值的染色体的索引
    total_points_unsatisfied(exp_index, :) = FitnV(index, 1:7); % 将该染色体的不满足条件的任务点个数存储到 total_points_unsatisfied 中
    %% 计算总时间并存储
    caroads = Outputroads(Chrom(index,:),Xmat,Ymat,Map,Tlast);
    [time,~,~] = costime(caroads,Xmat,Ymat,Map,Tlast,Pos,tload,v,pql,pqr,py);
    total_times(exp_index) = time;
end
%% 计算平均值
average_unsatisfied_points = mean(total_points_unsatisfied);
average_total_time = mean(total_times);
disp(['平均总时间：',num2str(average_total_time)])
disp(['优化后种群平均适应度：', num2str(average_unsatisfied_points(1))])
disp(['平均不满足满载限制任务点个数：', num2str(average_unsatisfied_points(6))])
disp(['平均不满足重量限制条件任务点个数：', num2str(average_unsatisfied_points(7))])
disp(['平均不满足岸桥最早时间的任务点个数：', num2str(average_unsatisfied_points(5))])
disp(['平均不满足岸桥最晚时间的任务点个数：', num2str(average_unsatisfied_points(3))])
disp(['平均不满足场桥最早时间的任务点个数：', num2str(average_unsatisfied_points(4))])
disp(['平均不满足场桥最晚时间的任务点个数：', num2str(average_unsatisfied_points(2))])
save('Path_HSPO.mat', 'Path_HSPO');
toc

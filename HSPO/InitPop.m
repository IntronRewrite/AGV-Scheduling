function Chrom = InitPop(X,Y,m,pop)
%%初始化种群 根据左时间窗插入
% 输入
% X 卸货区
% Y 装货区
% m 小车数目
% pop 种群数目

% 输出
% Chrom 种群初始解

Task=[X;Y];%任务点合并，按左时间窗排序
Task=sortrows(Task,2);
Task = Task(:,1)';
xlength = size(X,1); %卸箱个数
ylength = size(Y,1); %装箱个数
len = xlength + ylength + m - 1; %染色体长度
Chrom = zeros(pop,len); %初始化种群
cars = xlength + ylength + 1: xlength + ylength + m - 1;%AGV小车编号
for i = 1:pop
    Chrom(i,:) = [Task cars];%生成初始种群
end
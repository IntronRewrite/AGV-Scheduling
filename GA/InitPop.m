function Chrom = InitPop(X,Y,m,pop)
%%��ʼ����Ⱥ ������ʱ�䴰����
% ����
% X ж����
% Y װ����
% m С����Ŀ
% pop ��Ⱥ��Ŀ

% ���
% Chrom ��Ⱥ��ʼ��

Task=[X;Y];%�����ϲ�������ʱ�䴰����
Task=sortrows(Task,2);
Task = Task(:,1)';
xlength = size(X,1); %ж�����
ylength = size(Y,1); %װ�����
len = xlength + ylength + m - 1; %Ⱦɫ�峤��
Chrom = zeros(pop,len); %��ʼ����Ⱥ
cars = xlength + ylength + 1: xlength + ylength + m - 1;%AGVС�����
for i = 1:pop
    Chrom(i,:) = [Task cars];%���ɳ�ʼ��Ⱥ
end
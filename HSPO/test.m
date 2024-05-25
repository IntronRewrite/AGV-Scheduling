clear
clc
close all
tic
%%��ʼ������
load Pos;%λ�þ���
load X;%ж������㼰ʱ�䴰
load Y;%װ������㼰ʱ�䴰
load Tlast;%AGV����ʱ��
m = size(Tlast,1);%AGV��Ŀ
tload = 120;%AGVװ��ʱ��
v = 6;%AGV�����ٶ�
pop = 100;%��ʼ����Ⱥ��Ŀ
pf = 1000000;%���سͷ�����
pw = 10000;%�����ͷ�����
pql = 1000;%��������ͷ�����
pqr = 10000;%��������ͷ�����
py = 1000;%���ųͷ�����
maxgen = 200;%��������
%%�������
%%����ӳ��
Map = [X;Y];
X(:,1) = 1:size(X,1);
Y(:,1) = 1+size(X,1):size(X,1)+size(Y,1);
%%�����ʼ��
Chrom = InitPop(X,Y,m,pop);
%%������Ӧ��
FitnV = Fitness(Chrom,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
disp(['��ʼ��Ⱥ��Ӧ�ȣ�',num2str(FitnV(1,1))])
disp(['�����㳡������ʱ�������������',num2str(FitnV(1,2)),' �����㰶������ʱ�������������',num2str(FitnV(1,3))])
disp(['�����㳡������ʱ�������������',num2str(FitnV(1,4)),' �����㰶������ʱ�������������',num2str(FitnV(1,5))])
disp(['��������������������',num2str(FitnV(1,6)),' ������������������������',num2str(FitnV(1,7))]);
[value,index] = min(FitnV(:,1));
CurrentBest = Chrom;%��ǰ��������
GlobalBest = Chrom(index,:);%ȫ������
recordCB = inf*ones(1,pop);%�������ż�¼
recordGB = value;%Ⱥ�����ż�¼
New = Chrom;
%%�Ż�
gen = 1; %��ǰ��������
figure;
hold on;
box on
xlim([0,maxgen])
title('�Ż�����')
xlabel('��������')
ylabel('��ǰ����ֵ')
Path_HSPO = zeros(maxgen,1);
while gen<=maxgen
    %% ������Ӧ��
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
    New = Cross(New,CurrentBest);%���彻��
    NewFit = Fitness(New,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
    for i = 1:pop
        if FitnV(i,1)>NewFit(i,1)
            Chrom(i,:) = New(i,:);
        end
    end
    New = CrossG(New,GlobalBest);%���彻��
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
    %% ���µ�������
    gen=gen+1 ;
end
%% ������
plot(Path_HSPO);
[~,index] = min(FitnV(:,1));
disp(['�Ż�����Ⱥ��Ӧ�ȣ�',num2str(FitnV(1,1))])
disp(['�����㳡������ʱ�������������',num2str(FitnV(1,2)),' �����㰶������ʱ�������������',num2str(FitnV(1,3))])
disp(['�����㳡������ʱ�������������',num2str(FitnV(1,4)),' �����㰶������ʱ�������������',num2str(FitnV(1,5))])
disp(['��������������������',num2str(FitnV(1,6)),' ������������������������',num2str(FitnV(1,7))]);
caroads = Outputroads(Chrom(index,:),X,Y,Map,Tlast);
[time,~,~] = costime(caroads,X,Y,Map,Tlast,Pos,tload,v,pql,pqr,py);
disp(['��ʱ��Ϊ��',num2str(time)])
toc
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
gg = 0.9;%����
pc = 0.9;%�������
pm = 0.9;%�������
pr = 0.9; %��ת����
pf = 1000000;%���سͷ�����
pw = 10000;%�����ͷ�����
pql = 1000;%��������ͷ�����
pqr = 10000;%��������ͷ�����
py = 1000;%���ųͷ�����
maxgen = 200;%��������
%%�Ŵ��㷨
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
%%�Ż�
gen = 1; %��ǰ��������
figure;
hold on;
box on
xlim([0,maxgen])
title('�Ż�����')
xlabel('��������')
ylabel('��ǰ����ֵ')
Path_GA = zeros(maxgen,1);
while gen<=maxgen
    %% ������Ӧ��
    FitnV = Fitness(Chrom,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
    Path_GA(gen) = min(FitnV(:,1));%ѡ�����Ÿ��屣��
    %% ѡ��
    SelCh=Select(Chrom,FitnV,gg);
    %% �������
    SelCh=Recombin(SelCh,pc);
    %% ����
    SelCh=Mutate(SelCh,pm);
    %% ��ת����
    SelCh1=Reverse(SelCh,pr);
    %% �����滻
    FitS1 = Fitness(SelCh1,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
    FitS = Fitness(SelCh,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
    FitS1 = FitS1(:,1);
    FitS = FitS(:,1);
    index=FitS1<FitS;
    SelCh(index,:)=SelCh1(index,:);
    %% �ز����Ӵ�������Ⱥ
    Chrom=Reins(Chrom,SelCh,FitnV);
    %% ���µ�������
    gen=gen+1 ;
end
%% ������
plot(Path_GA);
[~,index] = min(FitnV(:,1));
disp(['�Ż�����Ⱥ��Ӧ�ȣ�',num2str(FitnV(1,1))])
disp(['�����㳡������ʱ�������������',num2str(FitnV(1,2)),' �����㰶������ʱ�������������',num2str(FitnV(1,3))])
disp(['�����㳡������ʱ�������������',num2str(FitnV(1,4)),' �����㰶������ʱ�������������',num2str(FitnV(1,5))])
disp(['��������������������',num2str(FitnV(1,6)),' ������������������������',num2str(FitnV(1,7))]);

caroads = Outputroads(Chrom(index,:),X,Y,Map,Tlast);
[time,~,~] = costime(caroads,X,Y,Map,Tlast,Pos,tload,v,pql,pqr,py);
disp(['��ʱ��Ϊ��',num2str(time)])
toc

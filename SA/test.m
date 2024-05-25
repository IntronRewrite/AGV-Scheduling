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
pop = 1;%��ʼ����Ⱥ��Ŀ
pf = 1000000;%���سͷ�����
pw = 10000;%�����ͷ�����
pql = 1000;%��������ͷ�����
pqr = 10000;%��������ͷ�����
py = 1000;%���ųͷ�����
maxgen = 200;%��������
t0 = 2000;%��ʼ�¶�
tend = 1e-3;%��ֹ�¶�
loop = 200;%�������� ����
tv = 0.95;%��������
%%ģ���˻�
%%����ӳ��
Map = [X;Y];
X(:,1) = 1:size(X,1);
Y(:,1) = 1+size(X,1):size(X,1)+size(Y,1);
%%�����ʼ��
S1 = InitPop(X,Y,m,pop);
[cow,rol] = size(S1);
%%������Ӧ��
FitnV = Fitness(S1,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
disp(['��ʼ��Ⱥ��Ӧ�ȣ�',num2str(FitnV(1,1))])
disp(['�����㳡������ʱ�������������',num2str(FitnV(1,2)),' �����㰶������ʱ�������������',num2str(FitnV(1,3))])
disp(['�����㳡������ʱ�������������',num2str(FitnV(1,4)),' �����㰶������ʱ�������������',num2str(FitnV(1,5))])
disp(['��������������������',num2str(FitnV(1,6)),' ������������������������',num2str(FitnV(1,7))]);
%%�����������
syms x;
time=ceil(double(solve(t0*(tv)^x == tend,x)));
count = 0;%��������
Path_SA = zeros(time,1); %Ŀ������ʼ��
Track = zeros(time,rol); %ÿ������·�߾����ʼ��
bestans = ones(1,7);%���������Ӧ��ֵ

%%�Ż�
figure;
hold on;
box on
xlim([0,maxgen])
title('�Ż�����')
xlabel('��������')
ylabel('��ǰ����ֵ')

while t0>tend
    count = count + 1;
    temp = zeros(loop,rol+1);
    RR=zeros(loop,7);
    for k = 1:loop
        %%�����½�
        S = NewAnswer(S1);
        %% Metropolis�����ж��Ƿ�����½�
        FitS1 = Fitness(S1,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
        FitS = Fitness(S,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v);
        [S1,R] = Metropolis(FitS,FitS1,S,S1,t0);
        RR(k,:)=R;
        temp(k,:)= [S1 R(1)]; %��¼��һ·�ߵļ���·��
    end
    [d0,index] = min(temp(:,end));%��ǰ�¶�����·��
    if count ==1 || d0<Path_SA(count-1)
        Path_SA(count)=d0;
        bestans = RR(index,:);
    else
        Path_SA(count)=Path_SA(count-1);
    end
    Track(count,:)=temp(index,1:end-1);%��¼��ǰ�¶�����·��
    t0 = tv*t0;%����
end
%% ������
plot(Path_SA);
[~,index] = min(Path_SA(:,1));
disp('�Ż�����Ⱥ��Ӧ�ȼ���ϸ�����');
disp(['�����Ӧ��ֵ��', num2str(bestans(1))]);
disp(['�����㳡������ʱ�������������', num2str(bestans(2)), ' �����㰶������ʱ�������������', num2str(bestans(3))]);
disp(['�����㳡������ʱ�������������', num2str(bestans(4)), ' �����㰶������ʱ�������������', num2str(bestans(5))]);
disp(['��������������������', num2str(bestans(6)), ' ������������������������', num2str(bestans(7))]);
caroads = Outputroads(Track(index,:),X,Y,Map,Tlast);
[time,~,~] = costime(caroads,X,Y,Map,Tlast,Pos,tload,v,pql,pqr,py);
disp(['��ʱ��Ϊ��',num2str(time)])
toc


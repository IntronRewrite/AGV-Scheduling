function X=NewAnswer(S1)
%% ����
% S1:��ǰ��
%% ���
% X���½�
N=length(S1);
X=S1;                
a=round(rand(1,2)*(N-1)+1); %�����������λ�� ��������
W=X(a(1));
X(a(1))=X(a(2));
X(a(2))=W;         %�õ�һ����·��
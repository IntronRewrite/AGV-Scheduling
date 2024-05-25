function X=NewAnswer(S1)
%% 输入
% S1:当前解
%% 输出
% X：新解
N=length(S1);
X=S1;                
a=round(rand(1,2)*(N-1)+1); %产生两个随机位置 用来交换
W=X(a(1));
X(a(1))=X(a(2));
X(a(2))=W;         %得到一个新路线
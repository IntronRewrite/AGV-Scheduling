function dis = distance(Pos,a,b)
%距离函数
%输入
%Pos 位置矩阵
%a b 任务点
%输出
%dis a b距离
dis = abs(Pos(a,1)-Pos(b,1))+abs(Pos(a,2)-Pos(b,2));
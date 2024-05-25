function [S,R] = Metropolis(FS,FS1,S,S1,T)
%% 输入
% FS： 原有解的适应度
% FS1: 扰动新解的适应度
% S:   原有解   
% S1:  新解
% T:   当前温度
%% 输出
% S：   下一个当前解
% R：   下一个当前解的路线距离

dC = FS(1) - FS1(1);
if dC<0
    R = FS;
elseif exp(-dC/T)>=rand
    R = FS;
else
    S = S1;
    R = FS1;
end
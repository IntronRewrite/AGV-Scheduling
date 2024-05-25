function [S,R] = Metropolis(FS,FS1,S,S1,T)
%% ����
% FS�� ԭ�н����Ӧ��
% FS1: �Ŷ��½����Ӧ��
% S:   ԭ�н�   
% S1:  �½�
% T:   ��ǰ�¶�
%% ���
% S��   ��һ����ǰ��
% R��   ��һ����ǰ���·�߾���

dC = FS(1) - FS1(1);
if dC<0
    R = FS;
elseif exp(-dC/T)>=rand
    R = FS;
else
    S = S1;
    R = FS1;
end
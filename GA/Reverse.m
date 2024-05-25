%% 进化逆转函数
% 输入
% SelCh 被选择的个体
% pr 逆转概率
% 输出
% SelCh1 进化逆转后的个体
function SelCh1 = Reverse(SelCh, pr)
[row, col] = size(SelCh);
SelCh1 = SelCh;
for i = 1:row
    % 根据概率决定是否进行逆转操作
    if rand() < pr
        % 随机选择两个位置
        r1 = randsrc(1, 1, [1:col]);  % 随机选择一个位置
        r2 = randsrc(1, 1, [1:col]);  % 随机选择另一个位置
        % 确保r1小于等于r2
        mininverse = min([r1 r2]);
        maxinverse = max([r1 r2]);
        % 将选定位置之间的部分逆转
        SelCh1(i, mininverse:maxinverse) = SelCh1(i, maxinverse:-1:mininverse);
    end
end

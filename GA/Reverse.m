%% ������ת����
% ����
% SelCh ��ѡ��ĸ���
% pr ��ת����
% ���
% SelCh1 ������ת��ĸ���
function SelCh1 = Reverse(SelCh, pr)
[row, col] = size(SelCh);
SelCh1 = SelCh;
for i = 1:row
    % ���ݸ��ʾ����Ƿ������ת����
    if rand() < pr
        % ���ѡ������λ��
        r1 = randsrc(1, 1, [1:col]);  % ���ѡ��һ��λ��
        r2 = randsrc(1, 1, [1:col]);  % ���ѡ����һ��λ��
        % ȷ��r1С�ڵ���r2
        mininverse = min([r1 r2]);
        maxinverse = max([r1 r2]);
        % ��ѡ��λ��֮��Ĳ�����ת
        SelCh1(i, mininverse:maxinverse) = SelCh1(i, maxinverse:-1:mininverse);
    end
end

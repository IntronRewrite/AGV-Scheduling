function caroads = deroad(Chrom,lengthx,lengthy,rowcar)
%%Ⱦɫ��ֽ�С��·��
%����
%Chrom Ⱦɫ��
%lengthx ж��������
%lengthy װ��������
%rowcar С����Ŀ
%���
%caroads С������·��
carindex = find(Chrom>lengthx+lengthy);%�ҵ�С����Ⱦɫ���е�λ��
caroads = cell(rowcar,1);%С��·��
for j = 1:rowcar%�ֽ�ÿ��С����·��
    if j==1 || j==rowcar
        if j==1
            thefirst = 1;
            thelast = carindex(j)-1;
        else
            thefirst = carindex(j-1)+1;
            thelast = lengthx + lengthy + rowcar - 1;
        end
    else
        thefirst = carindex(j-1)+1;
        thelast = carindex(j)-1;
    end
    if thefirst<=thelast
        caroads{j}=Chrom(thefirst:thelast);
    end
end
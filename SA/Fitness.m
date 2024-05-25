function Fit = Fitness(Chrom,Pos,X,Y,Map,Tlast,pf,pw,pql,pqr,py,tload,v)
%%计算种群适应度 采用惩罚函数
%输入
%Chrom 种群
%Pos 坐标点
%X 卸箱区及时间窗
%Y 装箱区及时间窗
%Map 映射函数
%Tlast 小车最晚时间
%pa "重进重出"惩罚因子
%pb 岸桥惩罚因子
%pload 场桥惩罚因子
%tload 装载时间
%v AGV行驶速度
%输出
%Fit 种群适应度
rowcar = size(Tlast,1);%agv个数
rowchrom = size(Chrom,1);%染色体数目
lengthx = size(X,1);%卸箱个数
lengthy = size(Y,1);%装箱个数
Fit = zeros(rowchrom,7);%适应度值初始化

for i = 1:rowchrom
    caroads = deroad(Chrom(i,:),lengthx,lengthy,rowcar);%编码分解出各小车路径
    [runtime,wrongtime,wrongcountyl,wrongcountyr,wrongcountql,wrongcountqr] = costime(caroads,X,Y,Map,Tlast,Pos,tload,v,pql,pqr,py);%计算个体车辆运行时间 时间窗惩罚值 不满足岸桥时间窗个数 不满足场桥时间窗个数 
    unlilo = unloadinloadout(caroads,X,Y);%计算不合符重进重出的情况
    overweight= overwcount(caroads,X,Y,Tlast);
    Fit(i,1) = runtime+wrongtime+unlilo*pf+overweight*pw;
    Fit(i,2) = wrongcountyr;
    Fit(i,3) = wrongcountqr;
    Fit(i,4) = wrongcountyl;
    Fit(i,5) = wrongcountql;
    Fit(i,6) = unlilo;
    Fit(i,7) = overweight;
end
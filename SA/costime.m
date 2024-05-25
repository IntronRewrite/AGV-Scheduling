function [runtime,wrongtime,wrongcountyl,wrongcountyr,wrongcountql,wrongcountqr] = costime(caroads,X,Y,Map,Tlast,Pos,tload,v,pql,pqr,py)
%%计算各路径小车运行时间和
%输入
%caroads 小车运行轨迹
%X 卸货区
%Y 装货区
%Map 映射函数
%tload 装载时间
%Tlast 最晚返回时间
%Pos 距离矩阵
%v 小车行驶速度
%pql 最早岸桥惩罚因子
%pqr 最晚岸桥惩罚因子
%pyd 场桥惩罚因子
%输出
%runtime 小车运行时间
%wrongtime 小车不符合时间窗次数
%wrongcountyl 调度过程中不符合场桥时间窗的次数
%wrongcountyl 调度过程中不符合岸桥时间窗的次数

wrongtime = 0;%惩罚时间
wrongcountyl = 0;
wrongcountyr = 0;%初始化岸桥出错次数
wrongcountql = 0;
wrongcountqr = 0;
runtime = 0;%初始化运行时间
rowcar = size(caroads,1);%AGV数目
Tlqx = X(:,2);%到达岸桥卸箱任务点最早时间
Trqx = X(:,3);%到达岸桥卸箱任务点最晚时间
Tlyx = X(:,4);%到达场桥卸箱任务点最早时间
Tryx = X(:,5);%到达场桥卸箱任务点最晚时间
Tlyy = Y(:,2);%到达场桥装箱任务点最早时间
Tryy = Y(:,3);%到达场桥装箱任务点最晚时间
Tlqy = Y(:,4);%到达岸桥装箱任务点最早时间
Trqy = Y(:,5);%到达岸桥装箱任务点最晚时间
Map = Map(:,1);
X = X(:,1);
Y = Y(:,1);
for i = 1:rowcar
    roads = caroads{i};
    if isempty(roads)%判断非空
        continue
    end
    len = size(roads,2);%计算路径任务点个数
    time = 0;%计算该路径运行时间
    for j = 1:len
        if j==1%如果是第一个任务点
            if ismember(roads(j),X)%如果是卸箱任务点
                time = Tlqx(roads(j));%任务开始时间是第一个箱子的装载时间
                tlyx = Tlyx(X==roads(j));%规定到达堆场的左时间窗
                trun = distance(Pos,1,Map(roads(j)))/v;%从岸桥到堆场的运输时间
                if time + trun < tlyx%如果装载时间+运输时间早于规定到达堆场的左时间窗
                    wrongtime = wrongtime + (tlyx-time-trun)*py;
                    wrongcountyl = wrongcountyl + 1;
                    time = tlyx;%则需要等待
                else
                    time = time + trun;%否则按照到达时间点计算
                    tryx = Tryx(X==roads(j));%规定的右时间窗
                    if time > tryx%此时需要判断是否超出规定到达堆场的右时间窗限制
                        wrongtime = wrongtime + (time-tryx)*py;
                        wrongcountyr = wrongcountyr + 1;
                    end
                end
            else %否则是装箱任务点
                trun = distance(Pos,1,Map(roads(j)))/v;%首先需要从岸桥运输到场桥
                time = trun;
                tlyy = Tlyy(Y==roads(j));%规定到达堆场的左时间窗
                tryy = Tryy(Y==roads(j));%规定到达堆场的右时间窗
                if time < tlyy %如果到达时间早于规定堆场左时间窗
                    wrongtime = wrongtime + (tlyy-time)*py;
                    wrongcountyl = wrongcountyl + 1;
                    time = tlyy;%则需要等待
                else
                    if time > tryy %否则到达后需要判断是否超出规定到达堆场的右时间窗限制
                        wrongtime = wrongtime + (time-tryy)*py;
                        wrongcountyr = wrongcountyr + 1;
                    end
                end
                time = time + tload + trun;%装载并运输回集装箱
                tlqy = Tlqy(Y==roads(j));%规定到达岸桥的左时间窗
                trqy = Trqy(Y==roads(j));%规定到达岸桥的右时间窗
                if time < tlqy %如果到达时间早于规定岸桥左时间窗
                    wrongtime = wrongtime +(tlqy-time)*pql;
                    wrongcountql = wrongcountql + 1;
                    time = tlqy;%则需要等待
                else
                    if time > trqy %否则到达后需要判断是否超出规定到达岸桥的右时间窗限制
                        wrongtime = wrongtime + pqr;
                        wrongcountqr = wrongcountqr + 1;
                    end
                end
            end
        else %如果不是第一个任务点，则需要根据前驱任务点判断当前任务点如何执行
             %如果是 卸箱任务点 其前面是 装箱任务点 则直接在岸桥装载新的集装箱; 其前面是 卸箱任务点 则需要先返回岸桥
             %如果是 装箱任务点 其前面是 卸箱任务点 则需要移动到该点处; 其前面是装箱任务点 则需要从岸桥移动到该点处
             if ismember(roads(j),X) %如果是卸箱任务点
                if ismember(roads(j-1),X) %连续卸箱
                    time = time + distance(Pos,Map(roads(j-1)),1)/v;%需先返回岸桥
                end
                %前一任务点是装箱任务点则不需要返回岸桥
                tlqx = Tlqx(X==roads(j)); %卸箱任务点在岸桥的左时间窗
                trqx = Trqx(X==roads(j)); %卸箱任务点在岸桥的右时间窗
                tlyx = Tlyx(X==roads(j)); %卸箱任务点在堆场的左时间窗
                tryx = Tryx(X==roads(j)); %卸箱任务点在堆场的右时间窗
                if time < tlqx 
                    wrongtime = wrongtime +(tlqx-time)*pql;
                    wrongcountql = wrongcountql + 1;
                    time = tlqx;%如果早需要等待
                else
                    if time > trqx %否则需要判断是否超出规定到达岸桥的右时间窗限制
                        wrongtime = wrongtime + pqr;
                        wrongcountqr = wrongcountqr + 1;
                    end
                end
                time = time + tload;%从船舶装箱
                time = time + distance(Pos,Map(roads(j)),1)/v;%运输到堆场时间
                if time < tlyx %如果早于到达堆场规定左时间窗需要等待
                    wrongtime = wrongtime + (tlyx-time)*py;
                    wrongcountyl = wrongcountyl + 1;
                    time = tlyx;
                else   
                    if time > tryx %否则需要判断是否超出规定到达场桥的右时间窗限制
                        wrongtime = wrongtime + (time-tryx)*py;
                        wrongcountyr = wrongcountyr + 1;
                    end
                end
             else%如果是装箱任务点
                if ismember(roads(j-1),X) %如果上一个点卸箱
                    time = time + distance(Pos,Map(roads(j-1)),Map(roads(j)))/v;%需先从上一堆场移动到该点处
                else %如果上一点装箱
                    time = time + distance(Pos,1,Map(roads(j)))/v;%需先从岸桥移动到该点处
                end 
                tlqy = Tlqy(Y==roads(j)); %装箱任务点在岸桥的左时间窗
                trqy = Trqy(Y==roads(j)); %装箱任务点在岸桥的右时间窗
                tlyy = Tlyy(Y==roads(j)); %装箱任务点在堆场的左时间窗
                tryy = Tryy(Y==roads(j)); %装箱任务点在堆场的右时间窗
                if time < tlyy %早到达堆场
                    wrongtime = wrongtime + (tlyy-time)*py;
                    wrongcountyl = wrongcountyl + 1;
                    time = tlyy;
                else
                    if time > tryy %否则需要判断和右时间窗的关系
                        wrongtime = wrongtime + (time-tryy)*py;
                        wrongcountyr = wrongcountyr + 1;
                    end
                end
                time = tload + time;%堆场装箱
                time = time + distance(Pos,Map(roads(j)),1)/v;%运输到堆场时间
                if time < tlqy %如果早于到达堆场规定左时间窗需要等待
                    wrongtime = wrongtime +(tlqy-time)*pql;
                    wrongcountql = wrongcountql + 1;
                    time = tlqy;
                else
                    if time > trqy %否则需要判断是否超出规定到达岸桥的右时间窗限制
                        wrongtime = wrongtime + pqr;
                        wrongcountqr = wrongcountqr + 1;
                    end
                end
             end
        end
    end
    %最后返回任务点单独判断
    if ismember(roads(end),X)
        time = time + distance(Pos,1,Map(roads(end)))/v;
    end
    if time > Tlast(i)
        wrongcountqr = wrongcountqr + 1;
        wrongtime = wrongtime + pqr;
    end
    runtime = max(runtime,time);
end
function [runtime,wrongtime,wrongcountyl,wrongcountyr,wrongcountql,wrongcountqr] = costime(caroads,X,Y,Map,Tlast,Pos,tload,v,pql,pqr,py)
%%�����·��С������ʱ���
%����
%caroads С�����й켣
%X ж����
%Y װ����
%Map ӳ�亯��
%tload װ��ʱ��
%Tlast ������ʱ��
%Pos �������
%v С����ʻ�ٶ�
%pql ���簶�ųͷ�����
%pqr �����ųͷ�����
%pyd ���ųͷ�����
%���
%runtime С������ʱ��
%wrongtime С��������ʱ�䴰����
%wrongcountyl ���ȹ����в����ϳ���ʱ�䴰�Ĵ���
%wrongcountyl ���ȹ����в����ϰ���ʱ�䴰�Ĵ���

wrongtime = 0;%�ͷ�ʱ��
wrongcountyl = 0;
wrongcountyr = 0;%��ʼ�����ų������
wrongcountql = 0;
wrongcountqr = 0;
runtime = 0;%��ʼ������ʱ��
rowcar = size(caroads,1);%AGV��Ŀ
Tlqx = X(:,2);%���ﰶ��ж�����������ʱ��
Trqx = X(:,3);%���ﰶ��ж�����������ʱ��
Tlyx = X(:,4);%���ﳡ��ж�����������ʱ��
Tryx = X(:,5);%���ﳡ��ж�����������ʱ��
Tlyy = Y(:,2);%���ﳡ��װ�����������ʱ��
Tryy = Y(:,3);%���ﳡ��װ�����������ʱ��
Tlqy = Y(:,4);%���ﰶ��װ�����������ʱ��
Trqy = Y(:,5);%���ﰶ��װ�����������ʱ��
Map = Map(:,1);
X = X(:,1);
Y = Y(:,1);
for i = 1:rowcar
    roads = caroads{i};
    if isempty(roads)%�жϷǿ�
        continue
    end
    len = size(roads,2);%����·����������
    time = 0;%�����·������ʱ��
    for j = 1:len
        if j==1%����ǵ�һ�������
            if ismember(roads(j),X)%�����ж�������
                time = Tlqx(roads(j));%����ʼʱ���ǵ�һ�����ӵ�װ��ʱ��
                tlyx = Tlyx(X==roads(j));%�涨����ѳ�����ʱ�䴰
                trun = distance(Pos,1,Map(roads(j)))/v;%�Ӱ��ŵ��ѳ�������ʱ��
                if time + trun < tlyx%���װ��ʱ��+����ʱ�����ڹ涨����ѳ�����ʱ�䴰
                    wrongtime = wrongtime + (tlyx-time-trun)*py;
                    wrongcountyl = wrongcountyl + 1;
                    time = tlyx;%����Ҫ�ȴ�
                else
                    time = time + trun;%�����յ���ʱ������
                    tryx = Tryx(X==roads(j));%�涨����ʱ�䴰
                    if time > tryx%��ʱ��Ҫ�ж��Ƿ񳬳��涨����ѳ�����ʱ�䴰����
                        wrongtime = wrongtime + (time-tryx)*py;
                        wrongcountyr = wrongcountyr + 1;
                    end
                end
            else %������װ�������
                trun = distance(Pos,1,Map(roads(j)))/v;%������Ҫ�Ӱ������䵽����
                time = trun;
                tlyy = Tlyy(Y==roads(j));%�涨����ѳ�����ʱ�䴰
                tryy = Tryy(Y==roads(j));%�涨����ѳ�����ʱ�䴰
                if time < tlyy %�������ʱ�����ڹ涨�ѳ���ʱ�䴰
                    wrongtime = wrongtime + (tlyy-time)*py;
                    wrongcountyl = wrongcountyl + 1;
                    time = tlyy;%����Ҫ�ȴ�
                else
                    if time > tryy %���򵽴����Ҫ�ж��Ƿ񳬳��涨����ѳ�����ʱ�䴰����
                        wrongtime = wrongtime + (time-tryy)*py;
                        wrongcountyr = wrongcountyr + 1;
                    end
                end
                time = time + tload + trun;%װ�ز�����ؼ�װ��
                tlqy = Tlqy(Y==roads(j));%�涨���ﰶ�ŵ���ʱ�䴰
                trqy = Trqy(Y==roads(j));%�涨���ﰶ�ŵ���ʱ�䴰
                if time < tlqy %�������ʱ�����ڹ涨������ʱ�䴰
                    wrongtime = wrongtime +(tlqy-time)*pql;
                    wrongcountql = wrongcountql + 1;
                    time = tlqy;%����Ҫ�ȴ�
                else
                    if time > trqy %���򵽴����Ҫ�ж��Ƿ񳬳��涨���ﰶ�ŵ���ʱ�䴰����
                        wrongtime = wrongtime + pqr;
                        wrongcountqr = wrongcountqr + 1;
                    end
                end
            end
        else %������ǵ�һ������㣬����Ҫ����ǰ��������жϵ�ǰ��������ִ��
             %����� ж������� ��ǰ���� װ������� ��ֱ���ڰ���װ���µļ�װ��; ��ǰ���� ж������� ����Ҫ�ȷ��ذ���
             %����� װ������� ��ǰ���� ж������� ����Ҫ�ƶ����õ㴦; ��ǰ����װ������� ����Ҫ�Ӱ����ƶ����õ㴦
             if ismember(roads(j),X) %�����ж�������
                if ismember(roads(j-1),X) %����ж��
                    time = time + distance(Pos,Map(roads(j-1)),1)/v;%���ȷ��ذ���
                end
                %ǰһ�������װ�����������Ҫ���ذ���
                tlqx = Tlqx(X==roads(j)); %ж��������ڰ��ŵ���ʱ�䴰
                trqx = Trqx(X==roads(j)); %ж��������ڰ��ŵ���ʱ�䴰
                tlyx = Tlyx(X==roads(j)); %ж��������ڶѳ�����ʱ�䴰
                tryx = Tryx(X==roads(j)); %ж��������ڶѳ�����ʱ�䴰
                if time < tlqx 
                    wrongtime = wrongtime +(tlqx-time)*pql;
                    wrongcountql = wrongcountql + 1;
                    time = tlqx;%�������Ҫ�ȴ�
                else
                    if time > trqx %������Ҫ�ж��Ƿ񳬳��涨���ﰶ�ŵ���ʱ�䴰����
                        wrongtime = wrongtime + pqr;
                        wrongcountqr = wrongcountqr + 1;
                    end
                end
                time = time + tload;%�Ӵ���װ��
                time = time + distance(Pos,Map(roads(j)),1)/v;%���䵽�ѳ�ʱ��
                if time < tlyx %������ڵ���ѳ��涨��ʱ�䴰��Ҫ�ȴ�
                    wrongtime = wrongtime + (tlyx-time)*py;
                    wrongcountyl = wrongcountyl + 1;
                    time = tlyx;
                else   
                    if time > tryx %������Ҫ�ж��Ƿ񳬳��涨���ﳡ�ŵ���ʱ�䴰����
                        wrongtime = wrongtime + (time-tryx)*py;
                        wrongcountyr = wrongcountyr + 1;
                    end
                end
             else%�����װ�������
                if ismember(roads(j-1),X) %�����һ����ж��
                    time = time + distance(Pos,Map(roads(j-1)),Map(roads(j)))/v;%���ȴ���һ�ѳ��ƶ����õ㴦
                else %�����һ��װ��
                    time = time + distance(Pos,1,Map(roads(j)))/v;%���ȴӰ����ƶ����õ㴦
                end 
                tlqy = Tlqy(Y==roads(j)); %װ��������ڰ��ŵ���ʱ�䴰
                trqy = Trqy(Y==roads(j)); %װ��������ڰ��ŵ���ʱ�䴰
                tlyy = Tlyy(Y==roads(j)); %װ��������ڶѳ�����ʱ�䴰
                tryy = Tryy(Y==roads(j)); %װ��������ڶѳ�����ʱ�䴰
                if time < tlyy %�絽��ѳ�
                    wrongtime = wrongtime + (tlyy-time)*py;
                    wrongcountyl = wrongcountyl + 1;
                    time = tlyy;
                else
                    if time > tryy %������Ҫ�жϺ���ʱ�䴰�Ĺ�ϵ
                        wrongtime = wrongtime + (time-tryy)*py;
                        wrongcountyr = wrongcountyr + 1;
                    end
                end
                time = tload + time;%�ѳ�װ��
                time = time + distance(Pos,Map(roads(j)),1)/v;%���䵽�ѳ�ʱ��
                if time < tlqy %������ڵ���ѳ��涨��ʱ�䴰��Ҫ�ȴ�
                    wrongtime = wrongtime +(tlqy-time)*pql;
                    wrongcountql = wrongcountql + 1;
                    time = tlqy;
                else
                    if time > trqy %������Ҫ�ж��Ƿ񳬳��涨���ﰶ�ŵ���ʱ�䴰����
                        wrongtime = wrongtime + pqr;
                        wrongcountqr = wrongcountqr + 1;
                    end
                end
             end
        end
    end
    %��󷵻�����㵥���ж�
    if ismember(roads(end),X)
        time = time + distance(Pos,1,Map(roads(end)))/v;
    end
    if time > Tlast(i)
        wrongcountqr = wrongcountqr + 1;
        wrongtime = wrongtime + pqr;
    end
    runtime = max(runtime,time);
end
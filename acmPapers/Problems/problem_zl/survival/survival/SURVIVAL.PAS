{$A+,B-,D-,E+,F-,G+,I-,L-,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y-}
{$M 65520,0,655360}

program Survival;

uses Zoology;

type TXStates= array[0..200] of longint;
     TStates = array[0..100] of ^TXStates;	     { ��¼һ���׶�״̬[Y��X]�Ķ�ά���� }
var xy:array[0..1] of TStates;			     { ������������ڽ׶� }

    range:array[0..1] of record			     { ���������׶��п���״̬�ı߽�ֵ }
                               minx,maxx:integer;
                               miny,maxy:integer;
                         end;
    a,b,c,d:real;
    x0,y0,alpha,beta:integer;
    n:integer;
    l:longint;

var fin,fout:text;		{ ��������ļ� }

procedure init;			{ �������ݣ���ʼ����0 �׶ε�״̬ }
var i,j:integer;
begin
     assign(fin,'input.009');
     assign(fout,'output.009');
     reset(fin);
     rewrite(fout);
     readln(fin,a,b,c,d,x0,y0,alpha,beta,n,l);
     for i:=0 to 100 do
     begin
          new(xy[0][i]);
          new(xy[1][i]);
          for j:=0 to 200 do xy[0][i]^[j]:=-1;
     end;
     xy[0][y0]^[x0]:=0;
     range[0].minx:=x0;          range[0].maxx:=x0;
     range[0].miny:=y0;          range[0].maxy:=y0;
end;

function max(a,b:integer):integer;		{ ��������������֮�нϴ�� }
begin
     if a<b then max:=b else max:=a;
end;

var nu:longint;				{ ���ڼ�¼���Ӫ����ֵ }

procedure work;				{ ������ }
var month,i,j,id,id2:integer;

    maxkx,maxky,kx,ky:integer;

begin
     for month:=0 to n-1 do		{ monthΪ��ǰ���ƵĽ׶��� }
     begin
		{ ���㵱ǰ�������׶εĴ���λ�� }
          id:=month mod 2;              id2:=(month+1)mod 2;

		{ ��ʼ����һ�׶ε�����״̬ }
          for i:=0 to 100 do for j:=0 to 200 do xy[id2][i]^[j]:=-1;
          with range[id2] do
          begin
               minx:=200;       maxx:=-1;
               miny:=200;       maxy:=-1;
          end;

          for j:=range[id].miny to range[id].maxy do
              for i:=range[id].minx to range[id].maxx do
                  if xy[id][j]^[i]<>-1 then	{ ö�ٵ�ǰ�׶ε����п���״̬ }
                  begin
                       ZInit(a,b,c,d,i,j);
                       ZProcess(0,0,maxkx,maxky);
                       for ky:=max(0,(L-alpha*maxkx)div beta) to maxky do
                           for kx:=max(0,(L-beta*ky)div alpha) to maxkx do
                               if (alpha*kx+beta*ky>=L) and  { ö�����п��еĲ�׽�ƻ�kx��ky }
				  (xy[id2][maxky-ky]^[maxkx-kx]<xy[id][j]^[i]+alpha*kx+beta*ky)
                               then
                               begin
					{ ������ŵĵ��ƽ�� }
                                    xy[id2][maxky-ky]^[maxkx-kx]:=xy[id][j]^[i]+alpha*kx+beta*ky;

                                    with range[id2] do	{ ��¼�߽� }
                                    begin
                                         if maxky-ky<miny then miny:=maxky-ky;
                                         if maxky-ky>maxy then maxy:=maxky-ky;
                                         if maxkx-kx<minx then minx:=maxkx-kx;
                                         if maxkx-kx>maxx then maxx:=maxkx-kx;
                                    end;
                               end;
                  end;
          if range[id2].maxx=-1 then	{ �����һ�׶���û�еõ����е�״̬ }
          begin nu:=-1; exit; end;	{ �޽⣬�˳� }
     end;

	{ �ڵ�n���׶ε�״̬��Ѱ�����Ž� }
     id:=n mod 2;               nu:=0;
     for i:=range[id].miny to range[id].maxy do
         for j:=range[id].minx to range[id].maxx do
             if xy[id][i]^[j]>nu then nu:=xy[id][i]^[j];
end;

procedure over;		{ ������ر��ļ� }
begin
     writeln(fout,nu);
     close(fin);
     close(fout);
end;

{ ������ }
begin
     init;
     work;
     over;
end.
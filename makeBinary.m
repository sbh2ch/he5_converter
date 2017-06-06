close all; clear all;
%%%%%%%%%%%%%%%   CONFIG    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yy = '2016';
mm = '07';
dd = '09';
hh = '01';
data_fname='C:\mat\'; %%%%%%%%%%%%%%%%원본 he5 파일위치 사용자 PC환경에 맞게 잡아야함.%%%%%%%%%%%%%
output_path='C:\mat\output\'; %%%%%%%%%%%%%%%%출력위치 원하는 위치에 잡아야함.%%%%%%%%%%%%%%%
strStartX       = '0';	%시작 x좌표 (현재 동해로 설정되어있음)  
strStartY       = '0';	%시작 y좌표 (현재 동해로 설정되어있음)
strLenX         = '5680';	%X length
strLenY         = '5560';	%Y length
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strBandNameFlag     = '/HDFEOS/GRIDS/Image Data/Data Fields/FLAG Image Pixel Values';
strBandNameTss     = '/HDFEOS/GRIDS/Image Data/Data Fields/TSS Image Pixel Values';
strBandNameCdom     = '/HDFEOS/GRIDS/Image Data/Data Fields/CDOM Image Pixel Values';
strBandNameChl     = '/HDFEOS/GRIDS/Image Data/Data Fields/CHL Image Pixel Values';
strBandNameMask = '/HDFEOS/GRIDS/Image Data/Data Fields/CHL Image Pixel Values';
strHe5Lon       = 'C:\mat\GociLonLat\COMS_GOCI_L2P_GA_20110524031644.LON.he5'; %%%%%%%%%%%%%%%%%%%%%%%파일 사용자 PC환경에 맞게 잡아야함.%%%%%%%%%%%%%%
strHe5Lat       = 'C:\mat\GociLonLat\COMS_GOCI_L2P_GA_20110524031644.LAT.he5'; %%%%%%%%%%%%%%%%%%%%%%%파일 사용자 PC환경에 맞게 잡아야함.%%%%%%%%%%%%%%
bandNameLon = '/HDFEOS/GRIDS/Image Data/Data Fields/Longitude Image Pixel Values';
bandNameLat = '/HDFEOS/GRIDS/Image Data/Data Fields/Latitude Image Pixel Values';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% he5 파일이름 및 밴드이름 설정
 strHe5InputFlag = strcat(data_fname,'COMS_GOCI_L2A_GA_', yy, mm, dd, hh, '*.he5');
 ddir=dir(strHe5InputFlag);
 disp( strcat('[matlab]startX:',strStartX, ', startY:', strStartY, ', lenX:', strLenX, ', lenY:', strLenY, ' will be converted to ascii..') );


%기본 설정

filename=getfield(ddir(1), 'name');



d2DLon      = double( h5read( strHe5Lon, bandNameLon ) );
d2DLat      = double( h5read( strHe5Lat, bandNameLat ) );


% he5 읽기

d2DGociFlag = double( h5read( strcat(data_fname,'', filename), strBandNameFlag ) );
d2DGociTss  = double( h5read( strcat(data_fname,'', filename),  strBandNameTss  ) );
d2DGociCdom = double( h5read( strcat(data_fname,'', filename), strBandNameCdom ) );
d2DGociChl  = double( h5read( strcat(data_fname,'', filename),  strBandNameChl  ) );
d2DGociMask = double( h5read( strcat(data_fname,'', filename), strBandNameMask ) );

%%Original%%

tot = [];
totArray = a(2301:3300, 2301:3300);
pcolor(totArray); shading interp;

%%1/10 Code%%

addX = 1000;
addY = 1000;
for yy=0:4
for xx=0:4
    
    
    startX = xx*addX +301;
    startY = yy*addY +301;
    endX = startX + addX -1;
    endY = startY + addY -1;
    tot = [];
    disp(strcat(num2str(startX), '->',num2str(endX),' @@ ',num2str(startY),'->',num2str(endY)));
    testCnt=0;
    for idxY=startY:10:endY
    for idxX=startX:10:endX
        val = a(idxX,idxY);
        tot = [tot, val];
        
    end
    testCnt= testCnt+1;
   
    
    end
    if xx==2 && yy==2
        disp(strcat(num2str(startX), '->',num2str(endX),' @@@@@@@@@ ',num2str(startY),'->',num2str(endY)));
        test22 = tot;
        test22FirstReshpae = reshape(tot, 100, 100);
        
        pcolor(test22FirstReshpae);
    end
    disp(strcat('cnt is : ',num2str(testCnt)));
    fileID = fopen(strcat('c:\mat\output\',num2str(xx),num2str(yy),'test.pos'),'wt');	% 
    fprintf(fileID,'%f\n',tot);
    fclose(fileID);
  

end
end

%%Median Code%%

addX = 1000;
addY = 1000;
for yy=0:4
for xx=0:4
    
    
    startX = xx*addX +301;
    startY = yy*addY +301;
    endX = startX + addX -1;
    endY = startY + addY -1;
    tot = [];
    disp(strcat(num2str(startX), '->',num2str(endX),' @@ ',num2str(startY),'->',num2str(endY)));
    testCnt=0;
    
    for idxY=startY:10:endY
    for idxX=startX:10:endX
        medTot = [];
        startMedX = idxX;
        endMedX = idxX + 10;
        startMedY = idxY;
        endMedY = idxY + 10;
        for medX = startMedX:endMedX
        for medY = startMedY:1:endMedY
            medTot = [medTot, a(medX, medY)];
        end
        end
        val = median(medTot);
        tot = [tot, val];
        medTot=[];
        
    end
    testCnt= testCnt+1;
   
    
    end
    if xx==2 && yy==2
        test22 = tot;
        test22FirstReshpae = reshape(tot, 100, 100);        
        pcolor(test22FirstReshpae);
    end
    disp(strcat('cnt is : ',num2str(testCnt)));
    fileID = fopen(strcat('c:\mat\output\',num2str(xx),num2str(yy),'test.pos'),'wt');	% 
    fprintf(fileID,'%f\n',tot);
    fclose(fileID);
  

end
end


%%Mean Code%%

addX = 1000;
addY = 1000;
for yy=0:4
for xx=0:4
    
    
    startX = xx*addX +301;
    startY = yy*addY +301;
    endX = startX + addX -1;
    endY = startY + addY -1;
    tot = [];
    disp(strcat(num2str(startX), '->',num2str(endX),' @@ ',num2str(startY),'->',num2str(endY)));
    testCnt=0;
    
    for idxY=startY:10:endY
    for idxX=startX:10:endX
        medTot = [];
        startMedX = idxX;
        endMedX = idxX + 9;
        startMedY = idxY;
        endMedY = idxY + 9;
        for medX = startMedX:endMedX
        for medY = startMedY:1:endMedY
            medTot = [medTot, a(medX, medY)];
        end
        end
        val = nanmean(medTot);
        index  = find(isnan(medTot));
        if length(index) > 30
            val = NaN;
        end
        tot = [tot, val];
        
    end
    testCnt= testCnt+1;
  
   
    end
    if xx==2 && yy==2
        test22 = tot;
        test22FirstReshpae = reshape(tot, 100, 100);        
        pcolor(test22FirstReshpae);
    end
    disp(strcat('cnt is : ',num2str(testCnt)));
    fileID = fopen(strcat('c:\mat\output\',num2str(xx),num2str(yy),'test.pos'),'wt');	% 
    fprintf(fileID,'%f\n',tot);
    fclose(fileID);
  

end
end

a=d2DGociCdom;
index=find(a==-999);
a(index)=NaN;
pcolor(a); shading interp;
aa=rot90(a, -1);
pcolor(aa); shading interp;
aa=rot90(a, 1);
pcolor(aa); shading interp;

for y=1:6:1417
for x=1:6:1393
    val = d2DGociCdom(x,y);
    
    tot = [tot, val];
end
end

tot = [];
for x=1:6:5676
for y=1:6:5556
    val = d2DGociCdom(x,y);
    tot = [tot, val];
end
end

clear d2DGociFlag d2DGociTss d2DGociCdom d2DGociChl d2DLon d2DLat iStartX iStartY iLenX iLenY x y;

% 아스키로 저장
% 우선 1차원 배열로 reshape
d1DGociSubFlag     = reshape(d2DGociSubFlag,     1, []);
d1DGociSubTss      = reshape(d2DGociSubTss,      1, []);
d1DGociSubCdom     = reshape(d2DGociSubCdom,     1, []);
d1DGociSubChl      = reshape(d2DGociSubChl,      1, []);
d1DGociMaskSub = reshape(d2DGociMaskSub, 1, []);
d1DLonSub  = reshape(d2DLonSub,  1, []);
d1DLatSub  = reshape(d2DLatSub,  1, []);
d1DX       = reshape(d2DX     ,  1, []);
d1DY       = reshape(d2DY     ,  1, []);
clear d2DGociSubFlag d2DGociSubTss d2DGociSubCdom d2DGociSubChl d2DGociMaskSub d2DLonSub d2DLatSub d2DX d2DY;

% -999 fill value 제거
len = length( d1DGociMaskSub );
cnt = 1;

for i=1:len
    if d1DGociMaskSub(i) ~= -999

        d1DGociSubFlagWithoutFill(cnt) = d1DGociSubFlag(i);
        d1DGociSubTssWithoutFill(cnt)  = d1DGociSubTss(i);
        d1DGociSubCdomWithoutFill(cnt) = d1DGociSubCdom(i);
        d1DGociSubChlWithoutFill(cnt)  = d1DGociSubChl(i);
        d1DLonSubWithoutFill(cnt)  = d1DLonSub(i);
        d1DLatSubWithoutFill(cnt)  = d1DLatSub(i);
        d1DXWithoutFill(cnt)       = d1DX(i);
        d1DYWithoutFill(cnt)       = d1DY(i);
        cnt = cnt + 1;
    end
end

if cnt == 1
    d1DGociSubFlagWithoutFill(cnt) = NaN;
    d1DGociSubTssWithoutFill(cnt)  = NaN;
    d1DGociSubCdomWithoutFill(cnt) = NaN;
    d1DGociSubChlWithoutFill(cnt)  = NaN;
    d1DLonSubWithoutFill(cnt)  = NaN;
    d1DLatSubWithoutFill(cnt)  = NaN;
    d1DXWithoutFill(cnt)       = NaN;
    d1DYWithoutFill(cnt)       = NaN;
end

disp( strcat('cnt: ', num2str(cnt) ) );
clear d1DGociSubFlag d1DGociSubTss d1DGociSubCdom d1DGociSubChl d1DGociMaskSub d1DLonSub d1DLatSub d1DX d1DY cnt;


d3Ddata = [d1DXWithoutFill; d1DYWithoutFill; d1DLonSubWithoutFill; d1DLatSubWithoutFill; ...
           d1DGociSubTssWithoutFill; d1DGociSubCdomWithoutFill; d1DGociSubChlWithoutFill; d1DGociSubFlagWithoutFill];
clear d1DXWithoutFill d1DYWithoutFill d1DLonSubWithoutFill d1DLatSubWithoutFill ...
      d1DGociSubFlagWithoutFill d1DGociSubTssWithoutFill d1DGociSubCdomWithoutFill d1DGociSubChlWithoutFill;

% '/HDFEOS/GRIDS/Image Data/Data Fields/--- Image Pixel Values'에서
% Image Pixel Value만 분리해 내기 위해
i1DidxStart = findstr(strBandNameFlag, '/');
leni1DidxStart = length(i1DidxStart);
idxStart = i1DidxStart(leni1DidxStart);
idxEnd = length(strBandNameFlag);
strBandNameShort=strBandNameFlag(idxStart+1:idxEnd);

% COMS_GOCI_L2A_GA_20150507041642.FLAG.he5 만 분리해 내기 위해
i1DidxStart = findstr(strHe5InputFlag, '\');
leni1DidxStart = length(i1DidxStart);
idxStart = i1DidxStart(leni1DidxStart);
idxEnd = length(strHe5InputFlag);
strHe5InputShort=strcat(strHe5InputFlag(idxStart+1:idxEnd-4),'.FLAG.he5');
clear i1DidxStart leni1DidxStart idxStart idxEnd d1DX d1DY;

fileID = fopen('tester.txt','wt');	% 


fprintf(fileID,'%d\t%d\t%f\t%f\t%f\t%f\t%f\t%f\n',d3Ddata);
fclose(fileID);

clear fileID len d3Ddata strHe5InputShort strBandNameShort;

disp( strcat('[matlab]', strHe5InputFlag, ' is sucessfully converted...') );

res = 1;

tot = [];
for idxY=1:10:5000
for idxX=1:10:5000
    val = a(idxX, idxY);
    tot = [tot, val];
end
end
totalReshape = reshape(tot, 500, 500);
pcolor(totalReshape);

addX = 1000;
addY = 1000;
for yy=0:4
for xx=0:4
    
    
    startX = xx*addX +301;
    startY = yy*addY +301;
    endX = startX + addX -1;
    endY = startY + addY -1;
    tot = [];
    disp(strcat(num2str(startX), '->',num2str(endX),' @@ ',num2str(startY),'->',num2str(endY)));
    testCnt=0;
    for idxY=startY:10:endY
    for idxX=startX:10:endX
        val = a(idxX,idxY);
        tot = [tot, val];
        
    end
    testCnt= testCnt+1;
   
    
    end
    if xx==2 && yy==2
        test22 = tot;
        test22FirstReshpae = reshape(tot, 100, 100);
        
        b = fliplr( test22FirstReshpae );
        b = rot90 ( b, -1 );
        
        pcolor(b); shading interp;
    end
    disp(strcat('cnt is : ',num2str(testCnt)));
    fileID = fopen(strcat('c:\mat\output\',num2str(xx),num2str(yy),'test.pos'),'wt');	% 
    fprintf(fileID,'%f\n',tot);
    fclose(fileID);
  

end
end


          
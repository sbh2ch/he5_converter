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

% NaN 제거
a=d2DGociChl;
index=find(a==-999);
a(index)=NaN;
index=find(a>7);
a(index)=NaN;

% pcolor(a); shading interp;
%%Original%%

tot = [];
totArray = a(301:400, 301:400);
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
        val = nanmedian(medTot);
        index  = find(isnan(medTot));
        if length(index) > 60
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
        if length(index) > 50
            val = NaN;
        end
        tot = [tot, val];
        
    end
    testCnt= testCnt+1;
    end
    disp(strcat('cnt is : ',num2str(testCnt)));
    fileID = fopen(strcat('c:\mat\output\',num2str(xx),num2str(yy),'test.pos'),'wt');	% 
    fprintf(fileID,'%f\n',tot);
    fclose(fileID);
  

end
end

%%6x6 Code%%

addX = 800;
addY = 800;
for yy=0:5
for xx=0:5
    
    
    startX = xx*addX +301;
    startY = yy*addY +301;
    endX = startX + addX -1;
    endY = startY + addY -1;
    tot = [];
    disp(strcat(num2str(startX), '->',num2str(endX),' @@ ',num2str(startY),'->',num2str(endY)));
    testCnt=0;
    
    for idxX=startX:8:endX
    for idxY=startY:8:endY
        medTot = [];
        startMedX = idxX;
        endMedX = idxX + 7;
        startMedY = idxY;
        endMedY = idxY + 7;
        for medX = startMedX:endMedX
        for medY = startMedY:endMedY
            medTot = [medTot, a(medX, medY)];
        end
        end
        val = nanmean(medTot);
        index  = find(isnan(medTot));
        if length(index) > 40
            val = NaN;
        end
        tot = [tot, val];
        
    end
    testCnt= testCnt+1;
    end

    disp(strcat('cnt is : ',num2str(testCnt)));
    fileID = fopen(strcat('c:\mat\output\6\',num2str(xx),'-',num2str(yy),'.db'),'wt');	% 
    fprintf(fileID,'%f\n',tot);
    fclose(fileID);
  

end
end


%%12x12 Code%%

addX = 400;
addY = 400;
for yy=0:11
for xx=0:11
    
    
    startX = xx*addX +301;
    startY = yy*addY +301;
    endX = startX + addX -1;
    endY = startY + addY -1;
    tot = [];
    disp(strcat(num2str(startX), '->',num2str(endX),' @@ ',num2str(startY),'->',num2str(endY)));
    testCnt=0;
    
    for idxX=startX:4:endX
    for idxY=startY:4:endY
        medTot = [];
        startMedX = idxX;
        endMedX = idxX + 3;
        startMedY = idxY;
        endMedY = idxY + 3;
        for medX = startMedX:endMedX
        for medY = startMedY:endMedY
            medTot = [medTot, a(medX, medY)];
        end
        end
        val = nanmean(medTot);
        index  = find(isnan(medTot));
        if length(index) > 10
            val = NaN;
        end
        tot = [tot, val];
        
    end
    testCnt= testCnt+1;
    end
    disp(strcat('cnt is : ',num2str(testCnt)));
    fileID = fopen(strcat('c:\mat\output\4\',num2str(xx),'-',num2str(yy),'.db'),'wt');	% 
    fprintf(fileID,'%f\n',tot);
    fclose(fileID);
  

end
end

%%25x25 Code%%

addX = 200;
addY = 200;
for yy=0:24
for xx=0:24
    
    
    startX = xx*addX +301;
    startY = yy*addY +301;
    endX = startX + addX -1;
    endY = startY + addY -1;
    tot = [];
    disp(strcat(num2str(startX), '->',num2str(endX),' @@ ',num2str(startY),'->',num2str(endY)));
    testCnt=0;
    
    for idxX=startX:2:endX
    for idxY=startY:2:endY
        medTot = [];
        startMedX = idxX;
        endMedX = idxX + 1;
        startMedY = idxY;
        endMedY = idxY + 1;
        for medX = startMedX:endMedX
        for medY = startMedY:endMedY
            medTot = [medTot, a(medX, medY)];
        end
        end
        val = nanmean(medTot);
        index  = find(isnan(medTot));
        tot = [tot, val];
        
    end
    testCnt= testCnt+1;
    end
    disp(strcat('cnt is : ',num2str(testCnt)));
    fileID = fopen(strcat('c:\mat\output\5\',num2str(xx),'-',num2str(yy),'.db'),'wt');	% 
    fprintf(fileID,'%f\n',tot);
    fclose(fileID);
  

end
end

%%50x50 Code%%

addX = 100;
addY = 100;
for yy=0:49
for xx=0:49
    
    
    startX = xx*addX +301;
    startY = yy*addY +301;
    endX = startX + addX -1;
    endY = startY + addY -1;
    tot = [];
    disp(strcat(num2str(startX), '->',num2str(endX),' @@ ',num2str(startY),'->',num2str(endY)));
    testCnt=0;
    
    for idxX=startX:endX
    for idxY=startY:endY
        val = a(idxX, idxY);
        tot = [tot, val];        
    end
    testCnt= testCnt+1;   
    end
    disp(strcat('cnt is : ',num2str(testCnt)));
    fileID = fopen(strcat('c:\mat\output\6\',num2str(xx),'-',num2str(yy),'.db'),'wt');	% 
    fprintf(fileID,'%f\n',tot);
    fclose(fileID);
end
end

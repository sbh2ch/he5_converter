function exitcode = makeLatLon(yy,mm,dd,hh,type,inputName, strStartX, strEndX, strStartY, strEndY, driverPath)
%%%%%%%%%%%%%%%   CONFIG    %%%%%%%%%%%%%%%%%%%%%%%%%%
currentTime = clock;
year = num2str(currentTime(1));
month = num2str(currentTime(2));
day = num2str(currentTime(3));
path = strcat('c:\output\goci\',year,'\',month,'\',day);
mkdir(path);
outputName = [path,'\',inputName,'_',yy,mm,dd,hh,'.',type,'.he5'];
data_fname=[driverPath,'COMS\GOCI\1.0\',yy,'\',mm,'\',dd,'\L2\']; %%%%%%%%%%%%%%%%원본 he5 파일위치 사용자 PC환경에 맞게 잡아야함.
%%%%%%%%%%%%%%%%%%%%%%%%            DON'T TOUCH            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strBandName     = ['/HDFEOS/GRIDS/Image Data/Data Fields/', type ,' Image Pixel Values'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% he5 파일이름 및 밴드이름 설정
 strHe5InputFlag = strcat(data_fname,'COMS_GOCI_L2A_GA_', yy, mm, dd, hh, '*.',type,'.he5');
 ddir=dir(strHe5InputFlag);

 
%기본 설정

filename=getfield(ddir(1), 'name');

% he5 읽기
d2DGoci = double( h5read( strcat(data_fname,'', filename), strBandName ) );

numStartX = str2num(strStartX)+300;
numStartY = str2num(strStartY)+300;
numEndX = str2num(strEndX)+300;
numEndY = str2num(strEndY)+300;

%%Convert%%
totArray = d2DGoci(numStartX:numEndX, numStartY:numEndY);
%pcolor(totArray); shading interp;

h5create(outputName,strBandName, [numEndX-numStartX+1,numEndY-numStartY+1]);
h5write(outputName, strBandName, totArray);

    exitcode = 0;

%%%%%%%%%%%%%%%   CONFIG    %%%%%%%%%%%%%%%%%%%%%%%%%%
yy = '2017';
mm = '03';
dd = '03';
hh = '01';

type = 'CDOM';
inputName = '170621XXXXXX';
outputName = [inputName,'_',yy,mm,dd,hh,type,'.he5'];
data_fname=['T:\COMS\GOCI\1.0\',yy,'\',mm,'\',dd,'\L2\']; %%%%%%%%%%%%%%%%원본 he5 파일위치 사용자 PC환경에 맞게 잡아야함.
strStartX       = '1549';	%시작 x좌표   
strEndX         = '1910';	%X length
strStartY       = '1900';	%시작 y좌표 
strEndY         = '2165';	%Y length
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

% pcolor(a); shading interp;

%%Convert%%
totArray = d2DGoci(300:5299, 300:5299);
%pcolor(totArray); shading interp;

h5create(outputName,strBandName, [5000,5000]);
h5write(outputName, strBandName, totArray);
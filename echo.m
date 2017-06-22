
%%%%%%%%%%%%%%%   CONFIG    %%%%%%%%%%%%%%%%%%%%%%%%%%
yy = '2017';
mm = '03';
dd = '03';
hh = '01';

type = 'CDOM';
inputName = '170621XXXXXX';
outputName = [inputName,'_',yy,mm,dd,hh,type,'.he5'];
data_fname=['T:\COMS\GOCI\1.0\',yy,'\',mm,'\',dd,'\L2\']; %%%%%%%%%%%%%%%%���� he5 ������ġ ����� PCȯ�濡 �°� ��ƾ���.
strStartX       = '1549';	%���� x��ǥ   
strEndX         = '1910';	%X length
strStartY       = '1900';	%���� y��ǥ 
strEndY         = '2165';	%Y length
%%%%%%%%%%%%%%%%%%%%%%%%            DON'T TOUCH            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strBandName     = ['/HDFEOS/GRIDS/Image Data/Data Fields/', type ,' Image Pixel Values'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% he5 �����̸� �� ����̸� ����
 strHe5InputFlag = strcat(data_fname,'COMS_GOCI_L2A_GA_', yy, mm, dd, hh, '*.',type,'.he5');
 ddir=dir(strHe5InputFlag);

%�⺻ ����

filename=getfield(ddir(1), 'name');

% he5 �б�
d2DGoci = double( h5read( strcat(data_fname,'', filename), strBandName ) );

% pcolor(a); shading interp;

%%Convert%%
totArray = d2DGoci(300:5299, 300:5299);
%pcolor(totArray); shading interp;

h5create(outputName,strBandName, [5000,5000]);
h5write(outputName, strBandName, totArray);
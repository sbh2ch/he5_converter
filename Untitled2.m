close all; clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_fname=['W:\COMS\GOCI\1.0\2016\'];
WORK_DIR = 'C:\Users\00\Desktop\matlab_he5_read\S.Y.Kim\';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


cd(WORK_DIR);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
strStartX       = '2320';	%시작 x좌표
strStartY       = '1360';	%시작 y좌표
strLenX         = '2275';	%X length
strLenY         = '1467';	%Y length
%%%%%%%%%%%%%%%%%%%%%%%%%%%
year=2016;   %년도 설정
yy=num2str(year, '%4.4i');
for month=7:12  %월 설정 start : end
    mm=num2str(month, '%2.2i');
    if month==1| 3| 5| 7 | 8 | 10 | 12   % 월설정 detail
        end_day=31;
    elseif month==2
        end_dat=28;
    else
        end_day=30;
    end
    
    for day=1:end_day  %날짜 설정
        dd=num2str(day, '%2.2i');
        
        for hour=00:07
            hh=num2str(hour, '%2.2i');
            % he5 파일이름 및 밴드이름 설정
             strHe5InputFlag = strcat(data_fname, mm, '\', dd, '\L2\COMS_GOCI_L2A_GA_', yy, mm, dd, hh, '*.he5');
             ddir=dir(strHe5InputFlag);
             disp( strcat('[matlab]startX:',strStartX, ', startY:', strStartY, ', lenX:', strLenX, ', lenY:', strLenY, ' will be converted to ascii..') );

            
	%기본 설정
            for i=1:length(ddir)
                filename=getfield(ddir(i), 'name');
                if strcmp(filename(33:35), 'he5')==0
                else
                   
                    strBandNameFlag     = '/HDFEOS/GRIDS/Image Data/Data Fields/FLAG Image Pixel Values';
                    strBandNameTss     = '/HDFEOS/GRIDS/Image Data/Data Fields/TSS Image Pixel Values';
                    strBandNameCdom     = '/HDFEOS/GRIDS/Image Data/Data Fields/CDOM Image Pixel Values';
                    strBandNameChl     = '/HDFEOS/GRIDS/Image Data/Data Fields/CHL Image Pixel Values';
                    strBandNameMask = '/HDFEOS/GRIDS/Image Data/Data Fields/CHL Image Pixel Values';
                    
                    strHe5Lon       = 'C:\Users\00\Desktop\matlab_he5_read\GociLonLat\COMS_GOCI_L2P_GA_20110524031644.LON.he5';
                    strHe5Lat       = 'C:\Users\00\Desktop\matlab_he5_read\GociLonLat\COMS_GOCI_L2P_GA_20110524031644.LAT.he5';

                    bandNameLon = '/HDFEOS/GRIDS/Image Data/Data Fields/Longitude Image Pixel Values';
                    bandNameLat = '/HDFEOS/GRIDS/Image Data/Data Fields/Latitude Image Pixel Values';
                    d2DLon      = double( h5read( strHe5Lon, bandNameLon ) );
                    d2DLat      = double( h5read( strHe5Lat, bandNameLat ) );
                    clear bandNameLon bandNameLat;
                    
                    
                    % he5 읽기
                                        
                    d2DGociFlag = double( h5read( strcat(data_fname, mm, '\', dd, '\L2\', filename), strBandNameFlag ) );
                    d2DGociTss  = double( h5read( strcat(data_fname, mm, '\', dd, '\L2\', filename),  strBandNameTss  ) );
                    d2DGociCdom = double( h5read( strcat(data_fname, mm, '\', dd, '\L2\', filename), strBandNameCdom ) );
                    d2DGociChl  = double( h5read( strcat(data_fname, mm, '\', dd, '\L2\', filename),  strBandNameChl  ) );
                    d2DGociMask = double( h5read( strcat(data_fname, mm, '\', dd, '\L2\', filename), strBandNameMask ) );
                    
                    % 남북방향으로 조정
                    d2DGociFlag = rot90 ( d2DGociFlag, -1 );
                    d2DGociFlag = fliplr( d2DGociFlag );
                    d2DGociTss  = rot90 ( d2DGociTss, -1 );
                    d2DGociTss  = fliplr( d2DGociTss );
                    d2DGociCdom = rot90 ( d2DGociCdom, -1 );
                    d2DGociCdom = fliplr( d2DGociCdom );
                    d2DGociChl  = rot90 ( d2DGociChl, -1 );
                    d2DGociChl  = fliplr( d2DGociChl );
                    d2DGociMask = rot90 ( d2DGociMask, -1 );
                    d2DGociMask = fliplr( d2DGociMask );
                    d2DLon = rot90 ( d2DLon, -1 );
                    d2DLon = fliplr( d2DLon );
                    d2DLat = rot90 ( d2DLat, -1 );
                    d2DLat = fliplr( d2DLat );
                    
                    
                    % NaN 값 제거
                    iStartX = str2num( strStartX ) + 1;
                    iStartY = str2num( strStartY ) + 1;
                    iLenX   = str2num( strLenX );
                    iLenY   = str2num( strLenY );

                    d2DGociSubFlag = d2DGociFlag    (iStartY:iStartY+iLenY-1, iStartX:iStartX+iLenX-1);
                    d2DGociSubTss  = d2DGociTss    (iStartY:iStartY+iLenY-1, iStartX:iStartX+iLenX-1);
                    d2DGociSubCdom = d2DGociCdom    (iStartY:iStartY+iLenY-1, iStartX:iStartX+iLenX-1);
                    d2DGociSubChl  = d2DGociChl    (iStartY:iStartY+iLenY-1, iStartX:iStartX+iLenX-1);
                    d2DGociMaskSub = d2DGociMask(iStartY:iStartY+iLenY-1, iStartX:iStartX+iLenX-1);
                    d2DLonSub  = d2DLon (iStartY:iStartY+iLenY-1, iStartX:iStartX+iLenX-1);
                    d2DLatSub  = d2DLat (iStartY:iStartY+iLenY-1, iStartX:iStartX+iLenX-1);

                    d2DX = zeros( iLenY, iLenX );
                    d2DY = zeros( iLenY, iLenX );
                    for y=1:iLenY
                    for x=1:iLenX
                        d2DX( y, x ) = x + iStartX - 2;
                        d2DY( y, x ) = y + iStartY - 2;
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

                    %d3Ddata = [d1DX; d1DY; d1DLonSub; d1DLatSub; d1DGociSub];
                    d3Ddata = [d1DXWithoutFill; d1DYWithoutFill; d1DLonSubWithoutFill; d1DLatSubWithoutFill; ...
                               d1DGociSubTssWithoutFill; d1DGociSubCdomWithoutFill; d1DGociSubChlWithoutFill; d1DGociSubFlagWithoutFill];
                    clear d1DXWithoutFill d1DYWithoutFill d1DLonSubWithoutFill d1DLatSubWithoutFill ...
                          d1DGociSubFlagWithoutFill d1DGociSubTssWithoutFill d1DGociSubCdomWithoutFill d1DGociSubChlWithoutFill;

                    % '/HDFEOS/GRIDS/Image Data/Data Fields/TSS Image Pixel Values'에서 /TSS
                    % Image Pixel Value만 분리해 내기 위해
                    i1DidxStart = findstr(strBandNameFlag, '/');
                    leni1DidxStart = length(i1DidxStart);
                    idxStart = i1DidxStart(leni1DidxStart);
                    idxEnd = length(strBandNameFlag);
                    strBandNameShort=strBandNameFlag(idxStart+1:idxEnd);


                    % 'D:\Matlab2012\He5ToAscii\COMS_GOCI_L2A_GA_20150507041642.TSS.he5'에서
                    % COMS_GOCI_L2A_GA_20150507041642.TSS.he5 만 분리해 내기 위해
                    i1DidxStart = findstr(strHe5InputFlag, '\');
                    leni1DidxStart = length(i1DidxStart);
                    idxStart = i1DidxStart(leni1DidxStart);
                    idxEnd = length(strHe5InputFlag);
                    strHe5InputShort=strcat(strHe5InputFlag(idxStart+1:idxEnd-4),'.FLAG.he5');
                    clear i1DidxStart leni1DidxStart idxStart idxEnd d1DX d1DY;

                    %strTxtOutput    = 'C:\Users\00\Desktop\',strHe5InputFlag(idxStart+1:idxEnd),'.txt';
                   
                    fileID = fopen(strcat(strcat('C:\Users\00\Desktop\output\'), strcat(filename(1:length(filename)-4),'.FLAG.he5'),'.txt'),'wt');	% 
                    fprintf(fileID,'#DataSet=%s\n',  strcat(filename(1:length(filename)-4),'.FLAG.he5'));
                    fprintf(fileID,'#DataImage=%s\n', strBandNameShort);
                    fprintf(fileID,'#Description=px py lon lat TSS CDOM Chl Flag \n');
                    fprintf(fileID,'#Fill Value = -999\n');

                    fprintf(fileID,'%d\t%d\t%f\t%f\t%f\t%f\t%f\t%f\n',d3Ddata);
                    fclose(fileID);

                    clear fileID len d3Ddata strHe5InputShort strBandNameShort;

                    disp( strcat('[matlab]', strHe5InputFlag, ' is sucessfully converted...') );

                    res = 1;
                end
            end
        end
    end
end
            
            
            





% 표출
%figure,
%imagesc(dData);



%temp1 = dData(1621, 3034)
%temp2 = dData(1622, 3035)

%fprintf(fileID,'%f\t%f\n',temp1, temp2);

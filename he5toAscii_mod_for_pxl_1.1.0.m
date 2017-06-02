close all; clear all;
%%%%%%%%%%%%%%%   CONFIG    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
year=2011;   %�⵵ ���� (example 2011)
startMonth      = 1;        %���� �� (Ư�� �� ���� ���� �� 1)
endMonth        = 12;       %���� �� (Ư�� �� ���� ���� �� 12)
startDay        = 1;        %���� �� (Ư�� �� ���� ���� �� 1)
endDay          = -1;        %���� �� (Ư�� �� ���� ���� �� -1)
startHour       = 0;       %���� �ð� (Ư�� �ð� ���� ���� �� 0)
endHour         = 7;       %���� �ð� (Ư�� �ð� ���� ���� �� 7)
yy=num2str(year, '%4.4i');
log_path = 'C:\Users\00\Desktop\log.txt';   %%%%%%%%%%%%%%%%��ȯ ���н� �߻� �α�
data_fname=['C:\Users\00\Desktop\',yy,'\']; %%%%%%%%%%%%%%%%���� he5 ������ġ PCȯ�濡 �°� ��ƾ���.%%%%%%%%%%%%%
output_path='C:\Users\00\Desktop\output\'; %%%%%%%%%%%%%%%%�����ġ ���ϴ� ��ġ�� ��ƾ���.%%%%%%%%%%%%%%%
strStartX       = '2320';	%���� x��ǥ (���� ���ط� �����Ǿ�����)  
strStartY       = '1359';	%���� y��ǥ (���� ���ط� �����Ǿ�����)
strLenX         = '1000';	%X length
strLenY         = '1000';	%Y length
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strBandNameFlag     = '/HDFEOS/GRIDS/Image Data/Data Fields/FLAG Image Pixel Values';
strBandNameTss     = '/HDFEOS/GRIDS/Image Data/Data Fields/TSS Image Pixel Values';
strBandNameCdom     = '/HDFEOS/GRIDS/Image Data/Data Fields/CDOM Image Pixel Values';
strBandNameChl     = '/HDFEOS/GRIDS/Image Data/Data Fields/CHL Image Pixel Values';
strBandNameMask = '/HDFEOS/GRIDS/Image Data/Data Fields/CHL Image Pixel Values';
bandNameLon = '/HDFEOS/GRIDS/Image Data/Data Fields/Longitude Image Pixel Values';
bandNameLat = '/HDFEOS/GRIDS/Image Data/Data Fields/Latitude Image Pixel Values';
strHe5Lon       = 'C:\Users\00\Desktop\matlab_he5_read\GociLonLat\COMS_GOCI_L2P_GA_20110524031644.LON.he5'; %%%%%%%%%%%%%%%%%%%%%%%������ġ�� �°� ��ƾ���.%%%%%%%%%%%%%%
strHe5Lat       = 'C:\Users\00\Desktop\matlab_he5_read\GociLonLat\COMS_GOCI_L2P_GA_20110524031644.LAT.he5'; %%%%%%%%%%%%%%%%%%%%%%%������ġ�� �°� ��ƾ���.%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�⺻ ����
d2DLon      = double( h5read( strHe5Lon, bandNameLon ) );
d2DLat      = double( h5read( strHe5Lat, bandNameLat ) );
% ���Ϲ������� ����
d2DLon = rot90 ( d2DLon, -1 );
d2DLon = fliplr( d2DLon );
d2DLat = rot90 ( d2DLat, -1 );
d2DLat = fliplr( d2DLat );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for month=startMonth:endMonth  %�� ���� start : end
    mm=num2str(month, '%2.2i');
    if month==1| 3| 5| 7 | 8 | 10 | 12
        end_day=31;
    elseif month==2
        if mod(year,4) == 0
            end_day = 29;
        else
            end_day = 28;
        end
    else
        end_day=30;
    end
    
    if(endDay < 0)
        endDay = end_day; 
    end
    
    for day=startDay:endDay  %��¥ ����
        dd=num2str(day, '%2.2i');
        
        
        for hour=startHour:endHour
            hh=num2str(hour, '%2.2i');
            % he5 �����̸� �� ����̸� ����
             strHe5InputFlag = strcat(data_fname, mm, '\', dd, '\L2\COMS_GOCI_L2A_GA_', yy, mm, dd, hh, '*.he5');
            
             
             disp( strcat('[matlab]startX:',strStartX, ', startY:', strStartY, ', lenX:', strLenX, ', lenY:', strLenY, ' will be converted to ascii..') );

            
            

            % ���ϸ� ����ִ� ��¥
            strDate     = strcat(yy, mm, dd, hh);

            % �� pxl ������ �̸�

            strFlagName = strcat(data_fname, mm, '\', dd, '\GOCI_', strDate, '*_Flag.pxl');
            strCDOMName = strcat(data_fname, mm, '\', dd, '\GOCI_', strDate, '*_CDOM.pxl');
            strChlName  = strcat(data_fname, mm, '\', dd, '\GOCI_', strDate, '*_Chl.pxl' );
            strTSSName  = strcat(data_fname, mm, '\', dd, '\GOCI_', strDate, '*_TSS.pxl' );
            strMaskName = strcat(data_fname, mm, '\', dd, '\GOCI_', strDate, '*_Chl.pxl' );
            
            dir_Flag=dir(strFlagName);
            dir_Cdom = dir(strCDOMName);
            dir_Chl= dir(strChlName);
            dir_Tss= dir(strTSSName);
            
            %%% ���� �ҷ����� ���н� ó���ڵ�
            if(size(dir_Flag,1)==0 || size(dir_Cdom , 1)==0 || size(dir_Chl , 1)==0 || size(dir_Tss , 1)==0 )
                disp(strcat(strDate, ' error occured'));
                fileID2 = fopen(log_path, 'at');
                fprintf(fileID2,'#Error DataSet=%s\n',  strDate );
                fclose(fileID2);
                continue;
            end
           
            hourMin = strcat(dir_Cdom.name(length(dir_Cdom.name)-12:length(dir_Cdom.name)-9)); %%%%%���ϸ� �ʿ��� �ú����� ����
            filename = strcat('COMS_GOCI_L2A_GA_', strDate, hourMin, '.FLAG.he5.txt');
            % �� pxl ���� �б�
            strPrecisionF = 'float'; %�ڷ�����
            strPrecisionI = 'int32'; %�ڷ�����

            
           
            dir_Mask= dir(strMaskName);

            % Flag
            FlagName = strcat(data_fname, mm, '\', dd, '\',  dir_Flag.name);
            fid     = fopen( FlagName );
            d2DGociFlag = fread(fid, [5567 5685], strPrecisionI);
            fclose(fid);

            % CDOM

            fid     = fopen( strcat(data_fname, mm, '\', dd, '\',  dir_Cdom.name) );
            d2DGociCdom = fread(fid, [5567 5685], strPrecisionF);
            fclose(fid);

            % Chl
            fid     = fopen( strcat(data_fname, mm, '\', dd, '\',  dir_Chl.name) );
            d2DGociChl = fread(fid, [5567 5685], strPrecisionF);
            fclose(fid);

            % TSS
            fid     = fopen( strcat(data_fname, mm, '\', dd, '\',  dir_Tss.name) );
            d2DGociTss = fread(fid, [5567 5685], strPrecisionF);
            fclose(fid);

            % Mask
            fid     = fopen( strcat(data_fname, mm, '\', dd, '\',  dir_Mask.name) );
            d2DGociMask = fread(fid, [5567 5685], strPrecisionF);
            fclose(fid);


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



            % NaN �� ����
            iStartX = str2num( strStartX ) + 1;
            iStartY = str2num( strStartY ) + 1;
            iLenX   = str2num( strLenX );
            iLenY   = str2num( strLenY );

            d2DGociSubFlag = d2DGociFlag   (iStartY:iStartY+iLenY-1, iStartX:iStartX+iLenX-1);
            d2DGociSubTss  = d2DGociTss    (iStartY:iStartY+iLenY-1, iStartX:iStartX+iLenX-1);
            d2DGociSubCdom = d2DGociCdom   (iStartY:iStartY+iLenY-1, iStartX:iStartX+iLenX-1);
            d2DGociSubChl  = d2DGociChl    (iStartY:iStartY+iLenY-1, iStartX:iStartX+iLenX-1);
            d2DGociMaskSub = d2DGociMask   (iStartY:iStartY+iLenY-1, iStartX:iStartX+iLenX-1);
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
            clear d2DGociFlag d2DGociTss d2DGociCdom d2DGociChl iStartX iStartY iLenX iLenY x y;

            % �ƽ�Ű�� ����
            % �켱 1���� �迭�� reshape
            d1DGociSubFlag     = reshape(d2DGociSubFlag, 1, []);
            d1DGociSubTss      = reshape(d2DGociSubTss,  1, []);
            d1DGociSubCdom     = reshape(d2DGociSubCdom, 1, []);
            d1DGociSubChl      = reshape(d2DGociSubChl,  1, []);
            d1DGociMaskSub     = reshape(d2DGociMaskSub, 1, []);
            d1DLonSub          = reshape(d2DLonSub,      1, []);
            d1DLatSub          = reshape(d2DLatSub,      1, []);
            d1DX               = reshape(d2DX     ,      1, []);
            d1DY               = reshape(d2DY     ,      1, []);
            clear d2DGociSubFlag d2DGociSubTss d2DGociSubCdom d2DGociSubChl d2DGociMaskSub d2DLonSub d2DLatSub d2DX d2DY;

            % -999 fill value ����
            len = length( d1DGociMaskSub );
            cnt = 1;

            for i=1:len
                %if d1DGociMaskSub(i) ~= -999
                %if d1DGociMaskSub(i) ~= -999.9
                if d1DGociMaskSub(i) > 0

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

            %Nan ����
            d1DGociSubFlagWithoutFill(d1DGociSubFlagWithoutFill<0) = NaN;
            d1DGociSubTssWithoutFill(d1DGociSubTssWithoutFill<0)  = NaN;
            d1DGociSubCdomWithoutFill(d1DGociSubCdomWithoutFill<0) = NaN;
            d1DGociSubChlWithoutFill(d1DGociSubChlWithoutFill<0)  = NaN;


            disp( strcat('cnt: ', num2str(cnt) ) );
            clear d1DGociSubFlag d1DGociSubTss d1DGociSubCdom d1DGociSubChl d1DGociMaskSub d1DLonSub d1DLatSub d1DX d1DY cnt;


            d3Ddata = [d1DXWithoutFill; d1DYWithoutFill; d1DLonSubWithoutFill; d1DLatSubWithoutFill; ...
                       d1DGociSubTssWithoutFill; d1DGociSubCdomWithoutFill; d1DGociSubChlWithoutFill; d1DGociSubFlagWithoutFill];
            clear d1DXWithoutFill d1DYWithoutFill d1DLonSubWithoutFill d1DLatSubWithoutFill ...
                  d1DGociSubFlagWithoutFill d1DGociSubTssWithoutFill d1DGociSubCdomWithoutFill d1DGociSubChlWithoutFill;

            % '/HDFEOS/GRIDS/Image Data/Data Fields/--- Image Pixel Values'����
            % Image Pixel Value�� �и��� ���� ����
            i1DidxStart = findstr(strBandNameFlag, '/');
            leni1DidxStart = length(i1DidxStart);
            idxStart = i1DidxStart(leni1DidxStart);
            idxEnd = length(strBandNameFlag);
            strBandNameShort=strBandNameFlag(idxStart+1:idxEnd);

            % COMS_GOCI_L2A_GA_20150507041642.FLAG.he5 �� �и��� ���� ����
            i1DidxStart = findstr(strHe5InputFlag, '\');
            leni1DidxStart = length(i1DidxStart);
            idxStart = i1DidxStart(leni1DidxStart);
            idxEnd = length(strHe5InputFlag);
            strHe5InputShort=strcat(strHe5InputFlag(idxStart+1:idxEnd-4),hourMin,'.FLAG.he5');
            clear i1DidxStart leni1DidxStart idxStart idxEnd d1DX d1DY;

            fileID = fopen(strcat(strcat(output_path), strcat(filename(1:length(filename)-4)),'.txt'),'wt');	% 
            fprintf(fileID,'#DataSet=%s\n',  strcat(filename(1:length(filename)-4) ));
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
            
            
          
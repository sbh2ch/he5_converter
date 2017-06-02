clear all, close all;
inputPath = ['A:\genViewData\data\'];
etcPath = ['A:\genViewData\etc\'];
outputPath = ['A:\genViewData\result\'];
storagePath = ['A:\genViewData\storage\'];
dir_CHL = dir([inputPath 'COMS_GOCI_L2A*CHL.he5']);
dir_FLAG = dir([inputPath 'COMS_GOCI_L2A*FLAG.he5']);



fileNameTxt_recentMonth = strcat(outputPath, 'recentMonth_CHL.txt');
fileNameTxt_total = strcat(storagePath, 'total_CHL.txt');

fileName_Land = strcat(etcPath, 'Land.JPG');
fileName_FlagLand = strcat(etcPath, 'Flag.JPG');

fileName_colormapCHL = 'CHL_Colormap';
fullpath_colormapCHL =  strcat(etcPath, fileName_colormapCHL);
load(fullpath_colormapCHL, 'mycmap');
colormap = mycmap;
colormap = interp1(linspace(0,1,64), colormap, linspace(0,1, 256)); % 64 ->256 RGB

Land = imread([fileName_Land]);
FlagLand = imread([fileName_FlagLand]);
FlagLand = FlagLand(1:5685,1:5567);


before_Date     = '';
current_Date    = '';
before_Month    = '';
current_Month   = '';
dayCount        = 0;
dayFileCount    = 0;                    
compositeFileCount  = 3;

create_CHLFileCount = 0;                                                    % 생성된 CHL 자료 수 

% [width, height] = size(FLAG_04)
width  = 5567;
height = 5685;
size   = width * height;
x_base1 = 1877, y_base1 = 3537;
x_base2 = 1787, y_base2 = 3139;
x_base3 = 1855, y_base3 = 2356;
x_base4 = 2619, y_base4 = 2285;

% Flag 정의
FlagToMask = 0;
FLAG_CLOUDMASK = 0;
FLAG_LAND = 1;
FLAG_DARK_PXL = 16;
FLAG_CLOUD_EDGE = 18;
FLAG_BRIGHT_ADJACENCY = 19;
FLAG_CONTM_PXL_WARN = 20;
FLAG_CHL_FAIL = 23;
FLAG_SPECTR_WRONG = 26;
FlagToMask = bitor(FlagToMask, bitshift(1, FLAG_CLOUDMASK));
FlagToMask = bitor(FlagToMask, bitshift(1, FLAG_LAND));
FlagToMask = bitor(FlagToMask, bitshift(1, FLAG_DARK_PXL));
FlagToMask = bitor(FlagToMask, bitshift(1, FLAG_CLOUD_EDGE));
FlagToMask = bitor(FlagToMask, bitshift(1, FLAG_BRIGHT_ADJACENCY));
FlagToMask = bitor(FlagToMask, bitshift(1, FLAG_CONTM_PXL_WARN));
FlagToMask = bitor(FlagToMask, bitshift(1, FLAG_CHL_FAIL));
FlagToMask = bitor(FlagToMask, bitshift(1, FLAG_SPECTR_WRONG));

% 1. 가장 최근 날짜 처리
fileNumber =  length(dir_CHL)-2 ;

% 파일명 설정
fileName_CHL_02= dir_CHL(fileNumber).name;
fileName_CHL_03= dir_CHL(fileNumber+1).name;
fileName_CHL_04= dir_CHL(fileNumber+2).name;
fileName_FLAG_02= dir_FLAG(fileNumber).name;
fileName_FLAG_03= dir_FLAG(fileNumber+1).name;
fileName_FLAG_04= dir_FLAG(fileNumber+2).name;
% 절대경로 포함한 파일명 설정
fullpath_fileName_CHL_02 =  strcat(inputPath, fileName_CHL_02);
fullpath_fileName_CHL_03 =  strcat(inputPath, fileName_CHL_03);
fullpath_fileName_CHL_04 =  strcat(inputPath, fileName_CHL_04);
fullpath_fileName_FLAG_02 =  strcat(inputPath, fileName_FLAG_02);
fullpath_fileName_FLAG_03 =  strcat(inputPath, fileName_FLAG_03);
fullpath_fileName_FLAG_04 =  strcat(inputPath, fileName_FLAG_04);

% 현재 처리중인 파일의 날짜
syear   = fileName_CHL_02(18:21);                                           %% 문자열
smonth  = fileName_CHL_02(22:23);
sday    = fileName_CHL_02(24:25);
year    = str2num(syear);                                                   %% 정수
month   = str2num(smonth);
day     = str2num(sday);

% 2-1. recentMonth를 불러옴
ftext = fopen(fileNameTxt_recentMonth, 'r');
txt_recentMonth= fscanf(ftext,'%d %d %d %f %f %f %f',[7, inf]);
txt_recentMonth = txt_recentMonth';
fclose(ftext);

% 2-2. 새로운 파일인지 판단
if txt_recentMonth(length(txt_recentMonth), 3) ~= day
   % CHL -  3 hours(02~04) composite
else
    error('입력 자료가 새로 들어오지 않았습니다.');
end

% 3. CHL - Composite 3 hours
% He5 파일 읽기
CHL_02 = h5read(fullpath_fileName_CHL_02, '/HDFEOS/GRIDS/Image Data/Data Fields/CHL Image Pixel Values');
CHL_03 = h5read(fullpath_fileName_CHL_03, '/HDFEOS/GRIDS/Image Data/Data Fields/CHL Image Pixel Values');
CHL_04 = h5read(fullpath_fileName_CHL_04, '/HDFEOS/GRIDS/Image Data/Data Fields/CHL Image Pixel Values');
FLAG_02 = h5read(fullpath_fileName_FLAG_02, '/HDFEOS/GRIDS/Image Data/Data Fields/FLAG Image Pixel Values');
FLAG_03 = h5read(fullpath_fileName_FLAG_03, '/HDFEOS/GRIDS/Image Data/Data Fields/FLAG Image Pixel Values');
FLAG_04 = h5read(fullpath_fileName_FLAG_04, '/HDFEOS/GRIDS/Image Data/Data Fields/FLAG Image Pixel Values');

% 행렬 치환
CHL_02 = CHL_02';
CHL_03 = CHL_03';
CHL_04 = CHL_04';
FLAG_02 = FLAG_02';
FLAG_03 = FLAG_03';
FLAG_04 = FLAG_04';

% 플래그 처리
indexFlag=find(bitand(FLAG_02, FlagToMask) > 0);
CHL_02(indexFlag) = NaN;
indexFlag=find(bitand(FLAG_03, FlagToMask) > 0);
CHL_03(indexFlag) = NaN;
indexFlag=find(bitand(FLAG_04, FlagToMask) > 0);
CHL_04(indexFlag) = NaN;
clear indexFlag;
clear FLAG_02 FLAG_03 FLAG_04;


% -999 -> Nan
indexNan=find(CHL_02==-999);
CHL_02(indexNan) = NaN;
indexNan=find(CHL_03==-999);
CHL_03(indexNan) = NaN;
indexNan=find(CHL_04==-999);
CHL_04(indexNan) = NaN;   
clear indxeNan;

%     figure(1), imshow(CHL_02);
%     figure(2), imshow(CHL_03);
%     figure(3), imshow(CHL_04);

CHL_02 =  medfilt2(CHL_02, [3 3]);
CHL_03 =  medfilt2(CHL_03, [3 3]);
CHL_04 =  medfilt2(CHL_04, [3 3]);
% 02~04시 CHL를 하나의 3차원 배열로 합함
sum_CHL = single(zeros(height, width, 3));
sum_CHL(:,:,1) = CHL_02;
sum_CHL(:,:,2) = CHL_03;
sum_CHL(:,:,3) = CHL_04;
clear CHL_02 CHL_03 CHL_04;

% 02~04시 CHL를 Nan-mean 함
composite_CHL = nanmean(sum_CHL,3);
%     figure(4), imshow(composite_CHL);
clear sum_CHL;

% 5 이상인 값들 -> 5
indexMax=find(composite_CHL > 5);
composite_CHL(indexMax) = 4.9;
clear indexMax;

% 기지별 자료 저장
composite_CHL_base1 = composite_CHL(y_base1, x_base1);
composite_CHL_base2 = composite_CHL(y_base2, x_base2);
composite_CHL_base3 = composite_CHL(y_base3, x_base3);
composite_CHL_base4 = composite_CHL(y_base4, x_base4);  
composite_CHL_base1 = round(composite_CHL_base1*10)/10;
composite_CHL_base2 = round(composite_CHL_base2*10)/10;
composite_CHL_base3 = round(composite_CHL_base3*10)/10;
composite_CHL_base4 = round(composite_CHL_base4*10)/10;

% 정수형 처리 x -> 실수형 데이터
if composite_CHL_base1 == 1
    composite_CHL_base1 = 0.9;
end
if composite_CHL_base2 == 1
    composite_CHL_base2 = 0.9;
end
if composite_CHL_base3 == 1
    composite_CHL_base3 = 0.9;
end
if composite_CHL_base4 == 1
    composite_CHL_base4 = 0.9;
end

if composite_CHL_base1 == 2
    composite_CHL_base1 = 1.9;
end
if composite_CHL_base2 == 2
    composite_CHL_base2 = 1.9;
end
if composite_CHL_base3 == 2
    composite_CHL_base3 = 1.9;
end
if composite_CHL_base4 == 2
    composite_CHL_base4 = 1.9;
end

if composite_CHL_base1 == 3
    composite_CHL_base1 = 2.9;
end
if composite_CHL_base2 == 3
    composite_CHL_base2 = 2.9;
end
if composite_CHL_base3 == 3
    composite_CHL_base3 = 2.9;
end
if composite_CHL_base4 == 3
    composite_CHL_base4 = 2.9;
end

if composite_CHL_base1 == 4
    composite_CHL_base1 = 3.9;
end
if composite_CHL_base2 == 4
    composite_CHL_base2 = 3.9;
end
if composite_CHL_base3 == 4
    composite_CHL_base3 = 3.9;
end
if composite_CHL_base4 == 4
composite_CHL_base4  = 3.9;
end

if composite_CHL_base1 == 5
    composite_CHL_base1 = 4.9;
end
if composite_CHL_base2 == 5
    composite_CHL_base2 = 4.9;
end
if composite_CHL_base3 == 5
    composite_CHL_base3 = 4.9;
end
if composite_CHL_base4 == 5
composite_CHL_base4 = 4.9;
end
    
% 기지별 CHL 값이 0일 경우 Nan 삽임 (web의 경우 null 삽입,
if composite_CHL_base1 <= 0
    base1 = NaN;
else
     base1 = composite_CHL_base1;
end

if composite_CHL_base2 <= 0
    base2 = NaN;
else
     base2 = composite_CHL_base2;
end

if composite_CHL_base3 <= 0
    base3 = NaN;
else
     base3 = composite_CHL_base3;
end

if composite_CHL_base4 <= 0
    base4 = NaN;
else
     base4 = composite_CHL_base4;
end

% 6-1. 컴포짓 CHL - RGB 자료 생성
composite_CHL = composite_CHL * 255 / 5;
composite_CHL = fix(composite_CHL);
composite_CHL = uint8(composite_CHL);   
composite_indCHL = gray2ind(composite_CHL,255);  

% 중간값 필터 적용
composite_indCHL = medfilt2(composite_indCHL, [10 10]);
figure(4), imshow(composite_indCHL);                    % 지우면 처리에 이상이 생김
composite_rgbCHL = ind2rgb(composite_indCHL, colormap);
% figure(5), imshow(composite_rgbCHL);
composite_rgbCHL = uint8(fix(composite_rgbCHL * 255));
clear composite_indCHL; close all;

remove_rValue = composite_rgbCHL(1, 1, 1);
remove_bValue = composite_rgbCHL(1, 1, 3);
for y = 1:height
    for x = 1:width
         if (composite_rgbCHL(y,x,1) == remove_rValue && composite_rgbCHL(y,x,2) == 0 && composite_rgbCHL(y,x,3) == remove_bValue)
             composite_rgbCHL(y,x,1) = 0;
             composite_rgbCHL(y,x,3) = 0;
         end
    end
end
% figure(5), imshow(composite_rgbCHL);
indexFlagLand = find(FlagLand == 242);
composite_rgbCHL(indexFlagLand) = Land(indexFlagLand);
composite_rgbCHL(size+indexFlagLand) = Land(size+indexFlagLand);
composite_rgbCHL(2*size+indexFlagLand) = Land(2*size+indexFlagLand);


fileNameCHL_Full = strcat(fileName_CHL_02(18:25), '_3h_composite_CHL.JPG');  
imwrite(composite_rgbCHL, [storagePath fileNameCHL_Full], 'JPG');

% CHL Local 생성
composite_rgbCHL_Local = zeros(4000, 4000, 3);
composite_rgbCHL_Local = uint8(composite_rgbCHL_Local);

for y = 1000:4999
    for x = 500:4499
        composite_rgbCHL_Local(y-999,x-499,1) = composite_rgbCHL(y,x,1);
        composite_rgbCHL_Local(y-999,x-499,2) = composite_rgbCHL(y,x,2);
        composite_rgbCHL_Local(y-999,x-499,3) = composite_rgbCHL(y,x,3);
    end       
end

% 6-2. CHL Day 순서 조정
fileNameCHL_Local_Day1 = 'CHL_Local_Day1.JPG';
fileNameCHL_Local_Day2 = 'CHL_Local_Day2.JPG';
fileNameCHL_Local_Day3 = 'CHL_Local_Day3.JPG';
fileNameCHL_Local_Day4 = 'CHL_Local_Day4.JPG';
fileNameCHL_Local_Day5 = 'CHL_Local_Day5.JPG';
fileNameCHL_Local_Day6 = 'CHL_Local_Day6.JPG';
fileNameCHL_Local_Day7 = 'CHL_Local_Day7.JPG';

% 파일날짜 한자리씩 앞으로 당김
CHL_Day2 = imread([outputPath fileNameCHL_Local_Day2]);
imwrite(CHL_Day2, [outputPath fileNameCHL_Local_Day1], 'JPG');
CHL_Day3 = imread([outputPath fileNameCHL_Local_Day3]);
imwrite(CHL_Day3, [outputPath fileNameCHL_Local_Day2], 'JPG');
CHL_Day4 = imread([outputPath fileNameCHL_Local_Day4]);
imwrite(CHL_Day4, [outputPath fileNameCHL_Local_Day3], 'JPG');
CHL_Day5 = imread([outputPath fileNameCHL_Local_Day5]);
imwrite(CHL_Day5, [outputPath fileNameCHL_Local_Day4], 'JPG');
CHL_Day6 = imread([outputPath fileNameCHL_Local_Day6]);
imwrite(CHL_Day6, [outputPath fileNameCHL_Local_Day5], 'JPG');
CHL_Day7 = imread([outputPath fileNameCHL_Local_Day7]);
imwrite(CHL_Day7, [outputPath fileNameCHL_Local_Day6], 'JPG');

% 오늘날짜를 Day7에 저장
imwrite(composite_rgbCHL_Local, [outputPath fileNameCHL_Local_Day7], 'JPG');
composite_rgbCHL_Local = imread([outputPath fileNameCHL_Local_Day7]);
composite_rgbCHL_Local_resize = imresize(composite_rgbCHL_Local, [720 720]);
imwrite(composite_rgbCHL_Local_resize, [outputPath fileNameCHL_Local_Day7]);
clear RGB_Local;
clear RGB_Local_resize;



% 4-1. recentMonth를 불러옴
ftext = fopen(fileNameTxt_recentMonth, 'r');
txt_recentMonth= fscanf(ftext,'%d %d %d %f %f %f %f',[7, inf]);
txt_recentMonth = txt_recentMonth';
fclose(ftext);

% currentMonth -> month로 갱신/year에 추가, year 첫월삭제/갱신, 그리고 currentMonth 갱신
          
% 4-3. recentMonth 데이터 추가
ftext = fopen(fileNameTxt_recentMonth, 'a');
fprintf(ftext, '%d %d %d %s %s %s %s\n', year, month, day, base1, base2, base3, base4);
fclose(ftext);

% 4-4. 최근 30일 데이터에 있는 가장 오래된 1일 데이터 삭제
ftext = fopen(fileNameTxt_recentMonth, 'r+');
txt_recentMonth= fscanf(ftext,'%d %d %d %f %f %f %f',[7, inf]);
txt_recentMonth = txt_recentMonth';
txt_recentMonth(1,:) = [];
fclose(ftext);

% 4-5. 최근 30일 CHL 갱신
ftext = fopen(fileNameTxt_recentMonth, 'w');
fprintf(ftext, '%d %d %d %s %s %s %s\n', txt_recentMonth');
fclose(ftext);

% total에 오늘 데이터를 추가
ftext = fopen(fileNameTxt_total, 'a');
fprintf(ftext, '%d %d %d %s %s %s %s\n', year, month, day, base1, base2, base3, base4);
fclose(ftext);



%     Month 그래프 자료 생성

%     month CHL 데이터를 읽어옴
ftext = fopen(fileNameTxt_recentMonth, 'r');
txt_month= fscanf(ftext,'%d %d %d %f %f %f %f',[7, inf]);
fclose(ftext);

%     기지별 클로로필 농도값 벡터
xx = 1:30;
y1 = txt_month(4,:);
y2 = txt_month(5,:);
y3 = txt_month(6,:);
y4 = txt_month(7,:);

%     Nan이 아닌 클로로필 농도값 벡 추출
indexNan_y1 = ~isnan(y1);
indexNan_y2 = ~isnan(y2);
indexNan_y3 = ~isnan(y3);
indexNan_y4 = ~isnan(y4);
notNan_x1 = xx(indexNan_y1);
notNan_x2 = xx(indexNan_y2);
notNan_x3 = xx(indexNan_y3);
notNan_x4 = xx(indexNan_y4);
notNan_y1 = y1(indexNan_y1);
notNan_y2 = y2(indexNan_y2);
notNan_y3 = y3(indexNan_y3);
notNan_y4 = y4(indexNan_y4);

month_fig = figure('pos',[1500 800 800 400]);
hold on; grid on; axis([0 31 0 5]);
set(gcf, 'Color', [0.016    0.023    0.035])
set(gca, 'Color', [0.016    0.023    0.035], 'XColor', 'w', 'YColor','w', 'FontSize',20); 
set(gca, 'LooseInset', get(gca, 'TightInset'));
    
if (isempty(notNan_y1) ~= 1)
    interp_x1 = [min(notNan_x1) : (max(notNan_x1)-min(notNan_x1))/1000 : max(notNan_x1)];
    interp_y1 = interp1(notNan_x1, notNan_y1, interp_x1 , 'cubic');
    plot(notNan_x1, notNan_y1, 'r.', 'MarkerSize', 24);
    plot(interp_x1, interp_y1, 'r-', 'linewidth', 2);
end

if (isempty(notNan_y2) ~= 1)
    interp_x2 = [min(notNan_x2) : (max(notNan_x2)-min(notNan_x2))/1000 : max(notNan_x2)];
    interp_y2 = interp1(notNan_x2, notNan_y2, interp_x2 , 'cubic');
    plot(notNan_x2, notNan_y2, '.', 'color', [0.9100    0.5500    0.0000], 'MarkerSize',24);
    plot(interp_x2, interp_y2, '-','color', [0.9100    0.5500    0.0000], 'linewidth', 2);
end

if (isempty(notNan_y3) ~= 1)
    interp_x3 = [min(notNan_x3) : (max(notNan_x3)-min(notNan_x3))/1000 : max(notNan_x3)];
    interp_y3 = interp1(notNan_x3, notNan_y3, interp_x3 , 'cubic');
    plot(notNan_x3, notNan_y3, 'g.', 'MarkerSize', 24);
    plot(interp_x3, interp_y3, 'g-', 'linewidth', 2);
end

if (isempty(notNan_y4) ~= 1)
    interp_x4 = [min(notNan_x4) : (max(notNan_x4)-min(notNan_x4))/1000 : max(notNan_x4)];
    interp_y4 = interp1(notNan_x4, notNan_y4, interp_x4 , 'cubic');
    plot(notNan_x4, notNan_y4, 'b.', 'MarkerSize', 24);
    plot(interp_x4, interp_y4, 'b-', 'linewidth', 2);
end


interp_x1 = [min(notNan_x1) : (max(notNan_x1)-min(notNan_x1))/1000 : max(notNan_x1)];
interp_x2 = [min(notNan_x2) : (max(notNan_x2)-min(notNan_x2))/1000 : max(notNan_x2)];
interp_x3 = [min(notNan_x3) : (max(notNan_x3)-min(notNan_x3))/1000 : max(notNan_x3)];
interp_x4 = [min(notNan_x4) : (max(notNan_x4)-min(notNan_x4))/1000 : max(notNan_x4)];
interp_y1 = interp1(notNan_x1, notNan_y1, interp_x1 , 'cubic');
interp_y2 = interp1(notNan_x2, notNan_y2, interp_x2 , 'cubic');
interp_y3 = interp1(notNan_x3, notNan_y3, interp_x3 , 'cubic');
interp_y4 = interp1(notNan_x4, notNan_y4, interp_x4 , 'cubic');

month_fig = figure('pos',[1500 800 800 400]);
plot(notNan_x1, notNan_y1, 'r.', 'MarkerSize', 24);
hold on; grid on; axis([0 31 0 5]);
plot(interp_x1, interp_y1, 'r-', 'linewidth', 2);
set(gcf, 'Color', [0.016    0.023    0.035])
set(gca, 'Color', [0.016    0.023    0.035], 'XColor', 'w', 'YColor','w', 'FontSize',20); 
plot(notNan_x2, notNan_y2, '.', 'color', [0.9100    0.5500    0.0000], 'MarkerSize',24);
plot(interp_x2, interp_y2, '-','color', [0.9100    0.5500    0.0000], 'linewidth', 2);
plot(notNan_x3, notNan_y3, 'g.', 'MarkerSize', 24);
plot(interp_x3, interp_y3, 'g-', 'linewidth', 2);
plot(notNan_x4, notNan_y4, 'b.', 'MarkerSize', 24);
plot(interp_x4, interp_y4, 'b-', 'linewidth', 2);
set(gca, 'LooseInset', get(gca, 'TightInset'));
    
% 파일날짜 한자리씩 앞으로 당김
fileNameMonthGraph__Day1 = 'month_graph_day1.png';
fileNameMonthGraph__Day2 = 'month_graph_day2.png';
fileNameMonthGraph__Day3 = 'month_graph_day3.png';
fileNameMonthGraph__Day4 = 'month_graph_day4.png';
fileNameMonthGraph__Day5 = 'month_graph_day5.png';
fileNameMonthGraph__Day6 = 'month_graph_day6.png';
fileNameMonthGraph__Day7 = 'month_graph_day7.png';

monthGraph_Day2 = imread([outputPath fileNameMonthGraph__Day2]);
imwrite(monthGraph_Day2, [outputPath fileNameMonthGraph__Day1], 'png');
monthGraph_Day3 = imread([outputPath fileNameMonthGraph__Day3]);
imwrite(monthGraph_Day3, [outputPath fileNameMonthGraph__Day2], 'png');
monthGraph_Day4 = imread([outputPath fileNameMonthGraph__Day4]);
imwrite(monthGraph_Day4, [outputPath fileNameMonthGraph__Day3], 'png');
monthGraph_Day5 = imread([outputPath fileNameMonthGraph__Day5]);
imwrite(monthGraph_Day5, [outputPath fileNameMonthGraph__Day4], 'png');
monthGraph_Day6 = imread([outputPath fileNameMonthGraph__Day6]);
imwrite(monthGraph_Day6, [outputPath fileNameMonthGraph__Day5], 'png');
monthGraph_Day7 = imread([outputPath fileNameMonthGraph__Day7]);
imwrite(monthGraph_Day7, [outputPath fileNameMonthGraph__Day6], 'png');

% 파일 저장
set(gcf, 'InvertHardCopy', 'off');   
saveas(month_fig, [outputPath fileNameMonthGraph__Day7], 'png')

quit
%label
tic;
mkdir 0;
mkdir 1;
mkdir 2;
mkdir error;
A = readtable('data_info.csv');
index_0 = find(A.Negative);
Negative_ID = A.FileID(index_0);
index_1 = find(A.Typical);
Typical_ID = A.FileID(index_1);
index_2 = find(A.Atypical);
Atypical_ID = A.FileID(index_2);

% Get folder list
datapath = fullfile(pwd,'data','data','train');
dinfo = dir(datapath);
dirFlags = [dinfo.isdir];
dinfo = dinfo(dirFlags);
dinfo(ismember( {dinfo.name}, {'.', '..'})) = [];

% preprocessing
filelocation = {};
files = {};
for i=1:length(dinfo)
    dinfo2 = dir(fullfile(datapath,dinfo(i).name));
    filelocation{i} = fullfile(datapath,dinfo(i).name,dinfo2(3).name);
    dinfo3 = dir(filelocation{i});
    files{i} = dinfo3(3).name;
    dcm = dicomread(fullfile(filelocation{i},files{i}));
    dcm = im2uint8(dcm);
    % denoise
    dcm_denoise = imbilatfilt(dcm);
    % noamalize contrast
    dcm_eq = histeq(dcm);
    % backdetect
    backdetect = 0;
    high = fix(length(dcm_eq(:,1))/10);
    wide = fix(length(dcm_eq(1,:))/10);
    if mean(dcm_eq(:,end-wide+1:end),'all') > 127
        backdetect = backdetect + 1;
    end
    if mean(dcm_eq(:,1:wide),'all') > 127
        backdetect = backdetect + 1;
    end
    if mean(dcm_eq(1:high,:),'all') > 127
        backdetect = backdetect + 1;
    end
    if mean(dcm_eq(:,end-high+1:end),'all') < 127
        backdetect = backdetect + 1;
    end
    if backdetect > 2
        dcm_eq = 255-dcm_eq;
    end
        
    dcm_resize = imresize(dcm,[224 224]);
    dcm_denoise_resize = imresize(dcm_denoise,[224 224]);
    dcm_eq_resize = imresize(dcm_eq,[224 224]);
    output = cat(3,dcm_eq_resize,dcm_resize,dcm_denoise_resize);
    %output = cat(3,dcm_eq_resize,dcm_eq_resize,dcm_eq_resize);
    if sum(contains(files{i},Negative_ID)) == 1
        dicomwrite(output,[pwd,'\0\',files{i}]);
    elseif sum(contains(files{i},Typical_ID)) == 1
        dicomwrite(output,[pwd,'\1\',files{i}]);
    elseif sum(contains(files{i},Atypical_ID)) == 1
        dicomwrite(output,[pwd,'\2\',files{i}]);
    else
        dicomwrite(output,[pwd,'\error\',files{i}]);
    end
end
toc;
%{
d = dir(pwd);
d(ismember( {d.name}, {'.', '..'})) = [];

for j=0:4
figure;
    for i=1:30
        subplot(5,6,i)
        imshow(d(j*30+i).name)
    end
end
%}

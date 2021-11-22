tic;
mkdir valid;

% Get folder list
datapath = fullfile(pwd,'data','data','valid');
dinfo = dir(datapath);
dirFlags = [dinfo.isdir];
dinfo = dinfo(dirFlags);
dinfo(ismember( {dinfo.name}, {'.', '..'})) = [];

% preprocessing
filelocation = {};
files = {};
for i=1:length(dinfo)
    dinfo2 = dir(fullfile(datapath,dinfo(i).name)); %second level
    filelocation{i} = fullfile(datapath,dinfo(i).name,dinfo2(3).name);
    dinfo3 = dir(filelocation{i});
    files{i} = dinfo3(3).name;
    dcm = dicomread(fullfile(filelocation{i},files{i}));
    dcm = im2uint8(dcm);
    % noamalize contrast
    dcm_eq = histeq(dcm);
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
    dcm_eq_resize = imresize(dcm_eq,[224 224]);
    output = cat(3,dcm_eq_resize,dcm_eq_resize,dcm_eq_resize);
    dicomwrite(output,[pwd,'\valid\',files{i}]);
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

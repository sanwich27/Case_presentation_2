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
    % denoise
    dcm_denoise = imbilatfilt(dcm);
    % noamalize contrast
    dcm_eq = histeq(dcm);
    % Code for Transfer Learning Model
    dcm_resize = imresize(dcm,[224 224]);
    dcm_denoise_resize = imresize(dcm_denoise,[224 224]);
    dcm_eq_resize = imresize(dcm_eq,[224 224]);
    output = cat(3,dcm_eq_resize,dcm_resize,dcm_denoise_resize);
    %output = cat(3,dcm_eq_resize,dcm_eq_resize,dcm_eq_resize);
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

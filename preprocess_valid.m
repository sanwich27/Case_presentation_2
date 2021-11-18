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
    % denoise
    dcm_denoise = imbilatfilt(dcm);
    % noamalize contrast
    dcm_eq = histeq(dcm);
    % Code for Transfer Learning Model
    dcm_resize = imresize(dcm,[227 227]);
    dcm_denoise_resize = imresize(dcm_denoise,[227 227]);
    dcm_eq_resize = imresize(dcm_eq,[227 227]);
    output = cat(3,dcm_eq_resize,dcm_resize,dcm_denoise_resize);
    dicomwrite(output,[pwd,'\valid\',files{i}]);
end
toc;


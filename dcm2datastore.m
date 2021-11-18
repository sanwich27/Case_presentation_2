function imds = dcm2datastore(datapath,file_ext,label_option)

% Get folder list
dinfo = dir(datapath);
dirFlags = [dinfo.isdir];
dinfo = dinfo(dirFlags);
dinfo(ismember( {dinfo.name}, {'.', '..','data','error','valid'})) = [];

% Create image datastore using foldername and input file extension
filelocation = {};
for i=1:length(dinfo)
    filelocation{i} = [datapath '\' dinfo(i).name]; 
end

imds = imageDatastore(filelocation,'FileExtensions',file_ext,'LabelSource','foldernames','ReadFcn',@dicomread);

end

function imds = dcm2datastore_valid(datapath,file_ext,label_option)

% Create image datastore using foldername and input file extension
filelocation = {};
filelocation = fullfile(datapath,'valid'); 

imds = imageDatastore(filelocation,'FileExtensions',file_ext,'LabelSource','none','ReadFcn',@dicomread);
%imds = imageDatastore(filelocation,'FileExtensions',file_ext,'LabelSource','none','ReadFcn',@dicompreprocess);

end

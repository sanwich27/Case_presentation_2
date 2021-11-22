%% Transfer Learning

%% Load Pretrained Network
net = googlenet;

%% Check Input Image Size
inputSize = net.Layers(1).InputSize

%% Prepare Data
imds = dcm2datastore(pwd,'.dcm',0);
labelCount = countEachLabel(imds);
labelCount = labelCount.Count;
min_labelCount = min(labelCount);
train_ratio = 0.7;
numTrainFiles = fix(min_labelCount*train_ratio);
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandScale', [1 1.2], ...
    'RandXTranslation',[-20 20], ...
    'RandYTranslation',[-20 20], ...
    'RandRotation',[-20 20])
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain,'DataAugmentation',imageAugmenter);

%% Replace Final Layers
numClasses = numel(categories(imdsTrain.Labels));
lgraph = layerGraph(net);
newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
lgraph = replaceLayer(lgraph,'loss3-classifier',newLearnableLayer);
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,'output',newClassLayer);

%% Specify Training Options
options = trainingOptions('sgdm', ...
    'MiniBatchSize',32, ...
    'MaxEpochs',20, ...
    'InitialLearnRate',1e-3, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',4, ...
    'L2Regularization',0.1,...    
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');

%% Start Training Transfer Network
tic;
netTransfer = trainNetwork(imdsTrain,lgraph,options);
toc;
%% Generate validation result
imds_output = dcm2datastore_valid(pwd,'.dcm',0);
YPred = classify(netTransfer,imds_output);
B = readtable('sample_submission.csv');
Negative_ID_output = imds_output.Files(find(YPred==categorical(0)));
Typical_ID_output = imds_output.Files(find(YPred==categorical(1)));
Atypical_ID_output = imds_output.Files(find(YPred==categorical(2)));
for i = 1:length(B.FileID)
    Negative = sum(contains(Negative_ID_output,B.FileID(i)));
    Typical = sum(contains(Typical_ID_output,B.FileID(i)));
    Atypical = sum(contains(Atypical_ID_output,B.FileID(i)));
    if Negative == 1
        B.Type(i) = cellstr("Negative") ;
    elseif Typical == 1
        B.Type(i) = cellstr("Typical") ;
    elseif Atypical == 1
        B.Type(i) = cellstr("Atypical") ;
    else 
        B.Type(i) = cellstr("Undefined") ;
    end    
end
writetable(B,'sample_submission_prac.csv')
%% save model
testing = netTransfer;
save testing

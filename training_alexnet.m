%% Transfer Learning

%% Load Pretrained Network
net = alexnet;

%% Analyze Pretrained Network
analyzeNetwork(net)

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

%% Replace Final Layers
layersTransfer = net.Layers(1:end-3);
numClasses = numel(categories(imdsTrain.Labels))

layers = [
   layersTransfer
   fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
   softmaxLayer
   classificationLayer];

%% Specify Training Options
options = trainingOptions('sgdm', ...
    'MiniBatchSize',8, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');

%% Start Training Transfer Network
tic;
netTransfer = trainNetwork(imdsTrain,layers,options);
toc;
%% save model
alex_course = netTransfer;
save alexnet_48
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
%% DeepNetworkDesigner
deepNetworkDesigner

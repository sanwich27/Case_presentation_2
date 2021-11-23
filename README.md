# Case Presentation 2 of YM_3 Fighters of Digit Medicine

Team member: Tsai, W.X., Liu, X.Y., Li, B.Y., Ting, Y.C.

### [Task](https://www.kaggle.com/c/digital-medicine-2021-case-presentation-2/leaderboard)  
Topic: COVID-19 Detection (to classify the typical / atypical pneumonia)  

![Task](https://github.com/sanwich27/Case_presentation_2/blob/main/task.jpg)  

Prerequisite
-----
Environment: Matlab R2021a  
prerequisite toolbox: image processing toolbox, deep learning toolbox  

Usage
-----
Put the data folder downloaded on kaggle into all .m files (5 in total) in this repository to work
-  data: digital-medicine-2021-case-presentation-2
-  The paths of all programs to read files are hard-coded, please make sure that no additional folders are added to this layer before execution  

Process
-----
Step 1. run preprocess.m  
Step 2. run preprocess_valid.m  
Step 3. run training_googlenet.m   
  
Illustrate:  
-----
Preprocess: Step 1 & Step 2
- Step 1 and Step 2 pre-process the image to generate the files needed to train the model

Training model: Step 3
- After training, sample_submission_prac.csv will be output as the result of the prediction of validation data
- The pretrained model used by training_googlenet.m is [googlenet]
(https://www.mathworks.com/help/deeplearning/ref/googlenet.html)

1. [hyperparameter](https://www.mathworks.com/help/deeplearning/ref/trainingoptions.html):  
- MiniBatchSize: 32  
- MaxEpochs: 20  
- InitialLearnRate: 1e-3  
- LearnRateSchedule: piecewise  
- LearnRateDropPeriod: 4  
- L2Regularization: 0.1      
2. [data augmentation](https://www.mathworks.com/help/deeplearning/ref/imagedataaugmenter.html):  
- RandXReflection: true
- RandScale: [1 1.2]
- RandXTranslation: [-20 20]
- RandYTranslation: [-20 20]
- RandRotation: [-20 20])  


Experiment results
------------
Public Leaderboard: 0.54285

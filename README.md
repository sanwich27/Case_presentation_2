# Case_presentation_2

### [task](https://www.kaggle.com/c/digital-medicine-2021-case-presentation-2/leaderboard)  
Topic: COVID-19 Detection (to classify the typical / atypical pneumonia)  

![task](https://github.com/sanwich27/Case_presentation_2/blob/main/task.jpg)  

本次程式運作環境: matlab R2021a  
prerequisite toolbox: image processing toolbox, deep learning toolbox  

將本repository中所有 .m 檔(共 5 個)放入 kaggle 上下載下來的 data folder 即可運作 (/digital-medicine-2021-case-presentation-2)
所有程式讀取檔案的路徑都是寫死的，請確保在本層沒有新增額外的資料夾  

流程:  
Step 1. run preprocess.m  
Step 2. run preprocess_valid.m  
Step 3. run training_googlenet.m   
  
說明:  
Step 1 及 Step 2 對影像進行前處理，用來產生欲訓練 model 所需的檔案；Step 3用來訓練 model  
其中 training_googlenet.m 所使用的 pretrained model 是 [googlenet](https://www.mathworks.com/help/deeplearning/ref/googlenet.html)
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

結果:  
Public Leaderboard: 0.54285

# Case_presentation_2

### [task](https://www.kaggle.com/c/digital-medicine-2021-case-presentation-2/leaderboard)  
Topic: COVID-19 Detection (to classify the typical / atypical pneumonia)  
![task](https://github.com/sanwich27/Case_presentation_2/blob/main/task.jpg)  

本次程式運作環境: matlab R2021a  
prerequisite toolbox: image processing toolbox, deep learning toolbox  

將以下流程所需的檔案放在與data資料夾、data_info.csv、sample_submission.csv同一層即可運作  
所有程式讀取檔案的路徑都是寫死的，請確保在本層沒有新增額外的資料夾  

流程:
Step 1. run preprocess.m  
Step 2. run preprocess_valid.m  
Step 3. run training_googlenet.m   
  
說明:Step 1及Step 2對影像進行前處理，用來產生欲訓練model所需的檔案；Step 3用來訓練model

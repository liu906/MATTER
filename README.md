# MATTER
MATTER is framework that aims to consistent comparisons of defect prediction models.

MATTER is developmented and tested under: 
R-4.2.1   
RStudio 2022.07.1+554 "Spotted Wakerobin" Release (7872775ebddc40635780ca1ed238934c3345c5de, 2022-07-22) for Windows   

### Three main features of MATTER
- **SQA-effort alignment.** compare multiple defect prediction models under the same available code inspection effort or context switch effort 
- **baseline model ONE.** a baseline model "ONE" for defect prediction  
- **Novel indicators.** implementation for traditional (recall, MCC, G1, G2, AUC, PF, etc.) and novel performance indicators (ROI, eIFA).     

### Usage of MATTER
1. To get prediction results of baseline model ONE on specific datasets,run `./run_ONE.r`  
2. To compute performance indicators of compared models under aligned SQA-effort thresholds `./r_scirpt/computeIndicatorFromDetailResult.r`  

Required input format of prediction results of compared models:    

| sloc  | predictedValue | predictLabel | actualBugLabel |
| ------------- | ------------- |
| numeric  | numeric  | binary  | binary  |



----
                    
### Implementations of models 
in `./baseline-models/`

| model  | code folder  | main language |publication|
| :---------| :------------ |:---------------:| -----:|
| Bellwether | `./baseline-models/Bellwether`      | python2.x | Herbold |
| CLA | `./baseline-models/CLA`       |    Java     |  62 |
| Amasaki15-NB | `./baseline-models/Crosspare`   | Java        |  59   |
|CamargoCruz09-NB | `./baseline-models/Crosspare`   | Java        |  59   |
| Peters15-NB | `./baseline-models/Crosspare`   | Java        |  59   |
| CamargoCruz09-DT | `./baseline-models/Crosspare`   | Java        |  59   |
| Turhan09-DT | `./baseline-models/Crosspare`   | Java       |  59   |
| Watanabe08-DT | `./baseline-models/Crosspare`   | Java       |  59   |
| Menzies11-RF | `./baseline-models/Crosspare`   | Java       |  59   |
| EASC_NE | `./baseline-models/Crosspare`   | Java       |  59   |
| EASC_E | `./baseline-models/Crosspare`   | Java       |  59   |
| SC | `./baseline-models/SC`   | R      |  59   |
| ManualDown | `./baseline-models/other`      | Python3.x | 3 |
| ManualUp | `./baseline-models/other`      | Python3.x | 3 |
| FCM | `./baseline-models/other`      | Python3.x | 3 |

---

###Datasets
in `./dataset/nominal/dataset.7z`

| Dataset  | #project  |#releases |
| :------------ |:---------------:| -----:|
| AEEEM      | 5 | 5 |
| ALLJURECZKO      |    31     |  62 |
| IND-JLMIV+R-1Y_change59 | 38        |  59   |
| MA-SZZ-2020      | 5 | 50 |
| ReLink      | 3 | 3 |

----



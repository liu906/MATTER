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
1. To config the datasets, evaluated models, the path of origin prediction results in your evaluation experiments, modify:    
 `./config.r`    
 
 Note: prediction result files of compared models need to contain at least four columns below so that MATTER can evaluated in under specific SQA-effort:
 
 
 | sloc  | predictedValue | predictLabel | actualBugLabel |
 | :-------- | :---------- | :----------- | :----------|
 | numeric  | numeric  | binary  | binary  |

2. To get prediction results of baseline model ONE on specific datasets,run:  
   `./run_ONE.r`  
   
3. To compute performance indicators of compared models under aligned SQA-effort thresholds, run:   
 `./r_scirpt/computeIndicatorFromDetailResult.r` 
   - parameter threshold==-1 means compute indicators by the default classficiation cutoff of model
   - parameter 0<=threshold<=1 means compute indicators under aligned threshold * 100% PII (percentage of instances inspected)
   - parameter 1<threshold<=100 means compute indicators under aligned threshold% PCI (percentage of code inspected)



----
                    
### Implementations of models 
in `./baseline-models/`

| model  | code folder  | language |DOI|
| :---------| :------------ |:---------------:| -----:|
| Bellwether | `./baseline-models/Bellwether`      | python2.x | 10.1109/TSE.2018.2821670 |
| CLA | `./baseline-models/CLA`       |    Java     |  10.1109/ASE.2015.56 |
| Amasaki15-NB | `./baseline-models/Crosspare`   | Java        |  10.1109/TSE.2017.2724538   |
|CamargoCruz09-NB | `./baseline-models/Crosspare`   | Java        |  10.1109/TSE.2017.2724538   |
| Peters15-NB | `./baseline-models/Crosspare`   | Java        |  10.1109/TSE.2017.2724538   |
| CamargoCruz09-DT | `./baseline-models/Crosspare`   | Java        |  10.1109/TSE.2017.2724538  |
| Turhan09-DT | `./baseline-models/Crosspare`   | Java       |  10.1109/TSE.2017.2724538   |
| Watanabe08-DT | `./baseline-models/Crosspare`   | Java       |  10.1109/TSE.2017.2724538   |
| Menzies11-RF | `./baseline-models/Crosspare`   | Java       |  10.1109/TSE.2017.2724538   |
| EASC_NE | `./baseline-models/Crosspare`   | Java       |  10.1109/TSE.2019.2939303   |
| EASC_E | `./baseline-models/Crosspare`   | Java       |  10.1109/TSE.2019.2939303  |
| SC | `./baseline-models/SC`   | R      |  10.1145/2884781.2884839   |
| ManualDown | `./baseline-models/other`      | Python3.x | 10.1145/3183339 |
| ManualUp | `./baseline-models/other`      | Python3.x | 10.1145/3183339 |
| FCM | `./baseline-models/other`      | Python3.x | 10.1016/j.infsof.2020.106287 |

---

### Datasets
in `./dataset/nominal/dataset.7z`

| Dataset  | #project  |#releases |
| :------------ |:---------------:| -----:|
| AEEEM      | 5 | 5 |
| ALLJURECZKO      |    31     |  62 |
| IND-JLMIV+R-1Y_change59 | 38        |  59   |
| MA-SZZ-2020      | 5 | 50 |
| ReLink      | 3 | 3 |

----
### Scripts and results of RQs in paper
- To get results of RQ1
- To get results of RQ2
- To get results of RQ3
- To get results of RQ4
-  To get results of Discussion1
-  To get results of Discussion2




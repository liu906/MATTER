setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
source("../performance.r")
source('run.r')
root = 'result/new_rq2/'
baselines = c('ALLJURECZKO-ant-1.3',
              'ALLJURECZKO-ant-1.4',
              'ALLJURECZKO-ant-1.5',
              'ALLJURECZKO-ant-1.6',
              'ALLJURECZKO-ant-1.7',
              'ALLJURECZKO-camel-1.0',
              'ALLJURECZKO-camel-1.2',
              'ALLJURECZKO-camel-1.4',
              'ALLJURECZKO-camel-1.6',
              'ALLJURECZKO-ivy-1.1',
              'ALLJURECZKO-ivy-1.4',
              'ALLJURECZKO-ivy-2.0',
              'ALLJURECZKO-jedit-3.2',
              'ALLJURECZKO-jedit-4.0',
              'ALLJURECZKO-jedit-4.1',
              'ALLJURECZKO-jedit-4.2',
              'ALLJURECZKO-jedit-4.3',
              'ALLJURECZKO-log4j-1.0',
              'ALLJURECZKO-log4j-1.1',
              'ALLJURECZKO-log4j-1.2',
              'ALLJURECZKO-lucene-2.0',
              'ALLJURECZKO-lucene-2.2',
              'ALLJURECZKO-lucene-2.4',
              'ALLJURECZKO-poi-1.5',
              'ALLJURECZKO-poi-2.0',
              'ALLJURECZKO-poi-2.5',
              'ALLJURECZKO-poi-3.0',
              'ALLJURECZKO-synapse-1.0',
              'ALLJURECZKO-synapse-1.1',
              'ALLJURECZKO-synapse-1.2',
              'ALLJURECZKO-velocity-1.4',
              'ALLJURECZKO-velocity-1.5',
              'ALLJURECZKO-velocity-1.6',
              'ALLJURECZKO-xalan-2.4',
              'ALLJURECZKO-xalan-2.5',
              'ALLJURECZKO-xalan-2.6',
              'ALLJURECZKO-xalan-2.7',
              'ALLJURECZKO-xerces-1.0',
              'ALLJURECZKO-xerces-1.2',
              'ALLJURECZKO-xerces-1.3',
              'ALLJURECZKO-xerces-1.4')
baseline_paths = file.path(root,baselines)

run(baselines,
    baseline_paths,threshold = -1,
    profix = 'EASC_NE',res_path = file.path('result','new_rq2'),
    datasets=0)


run(baselines,
    baseline_paths,threshold = 20,
    profix = 'EASC_NE',res_path = file.path('result','new_rq2'),
    datasets=0)

run(baselines,
    baseline_paths,threshold = 0.2,
    profix = 'EASC_NE',res_path = file.path('result','new_rq2'),
    datasets=0)

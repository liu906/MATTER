from preprocess.split import get_split
import pandas as pd
from collections import Counter
import math
from evaluate.metric import Metric
import numpy as np
import os
import sys
import warnings
from preprocess.normalization import *

if not sys.warnoptions:
    warnings.simplefilter("ignore")



class ManualUp():
    def __init__(self, threshold=0.2, rank_strategy='worst'):
        """

        :param threshold: default value is 0.2
        """
        self.threshold = threshold
        self.rank_strategy = rank_strategy

    def rank(self, test):
        if self.rank_strategy == 'worst':
            test = test.sort_values(['sloc', 'bug'], ascending=(True, True))
        else:
            test = test.sort_values(['sloc', 'bug'], ascending=(True, False))

        front = test.iloc[0:int(len(test) * self.threshold), :]
        back = test.iloc[int(len(test) * self.threshold):len(test), :]
        front['y_predict'] = 'T'
        back['y_predict'] = 'F'
        test = pd.concat([front, back], ignore_index=False)
        self.test = test


class ManualDown():
    def __init__(self, threshold=0.5, rank_strategy='worst'):
        """

        :param threshold: default value is 0.5
        """
        self.threshold = threshold
        self.rank_strategy = rank_strategy

    def rank(self, test):
        if self.rank_strategy == 'worst':
            test = test.sort_values(['sloc', 'bug'], ascending=(False, True))
        else:
            test = test.sort_values(['sloc', 'bug'], ascending=(False, False))

        front = test.iloc[0:int(len(test) * self.threshold), :]
        back = test.iloc[int(len(test) * self.threshold):len(test), :]
        front['y_predict'] = 'T'
        back['y_predict'] = 'F'
        test = pd.concat([front, back], ignore_index=False)
        self.test = test
        return self.test




class pManualDown(tUCS):
    def rank(self, test):
        # print('cutoff is ', self.cutoff)
        test = test.sort_values(['sloc', 'bug'], ascending=(False, True))
        sloc = np.array(test['sloc']).cumsum()
        if self.method == 'SSC':
            tmp_cutoff = 0
            while tmp_cutoff < len(sloc) and sloc[tmp_cutoff] <= sloc[-1] * self.cutoff:
                tmp_cutoff = tmp_cutoff + 1

            self.cutoff = tmp_cutoff


        level1 = test.iloc[0: self.cutoff, :]
        level2 = test.iloc[self.cutoff:len(test), :]
        level1['y_predict'] = 'T'
        level2['y_predict'] = 'F'
        test = pd.concat([level1, level2], ignore_index=False)

        self.test = test

import skfuzzy as fuzz

class FCM():
    def __init__(self):
        pass
    def rank(self,test):
        data = np.transpose(test.drop(['bug'], axis=1).to_numpy())
        # u is predict score. the higher the u[?,idx] the more defect prone
        cntr, u, u0, d, jm, p, fpc = fuzz.cmeans(data=data, c=2, m=2, error=1e-20, maxiter=1000, seed=0)

        if sum(u[0] > u[1]) > 0.5 * len(u[0]):
            flag = 1
        else:
            flag = 0
        predict_proba = u[flag]
        y_predict = ['T' if u[flag][idx] > u[abs(flag - 1)][idx] else 'F' for idx in range(len(u[0]))]
        test['y_predict'] = y_predict
        test['predict_proba'] = predict_proba
        # self.test = test.sort_values(['predict_proba', 'sloc', 'bug'], ascending=(False, True, True))
        self.test = test.sort_values(['y_predict', 'sloc', 'bug'], ascending=(False, True, True))



import random
class FSOMs():
    def __init__(self, n_neuron=2, m=2, learning_rate=0.7, n_iteration=200):
        """

        :param n_neuron: 2, represent defective and non-defective
        :param m: greater than 1 and represent the fuzzifier
        """
        self.n_neuron = n_neuron
        self.m = m
        self.learning_rate = learning_rate
        self.n_iteration = n_iteration
        # TODO

        # self.cutoff = cutoff
        # self.method = method

    def neighborhood_function(self, t):
        return 1 - (t * 1.0 / self.n_iteration)

    def weight_initialization(self):
        self.neuron_weight = []
        for i in range(self.n_neuron):

            self.neuron_weight.append([random.random() for i in range(self.n_feature)])

    def get_distance(self, x, y):

        return np.linalg.norm(np.array(x) - np.array(y))


    def membership_degrees_computation(self):
        self.membership_matrix = []
        for i in range(self.n_neuron):
            row_membership_matrix = []
            for index, row in self.X.iterrows():
                u_ik = 0
                for j in range(self.n_neuron):
                    u_ik += (self.get_distance(row.values.tolist(), self.neuron_weight[i]) / self.get_distance(
                        row.values.tolist(), self.neuron_weight[j])) ** (2.0 / (self.m - 1))
                u_ik = 1.0 / u_ik
                row_membership_matrix.append(u_ik)
            self.membership_matrix.append(row_membership_matrix)

    def update(self):
        idx_random_instance = random.randrange(self.n_instance)

        max_distance = -1
        max_idx = -1
        for j in range(self.n_neuron):
            for i in range(self.n_feature):
                delta_weight_ji = self.learning_rate * self.neighborhood_function(j) * (
                            self.X.iloc[idx_random_instance, j] - self.neuron_weight[j][i]) * (
                                              self.membership_matrix[j][idx_random_instance] ** self.m)
                self.neuron_weight[j][i] += delta_weight_ji


    def rank(self,test):
        # pre-process
        self.n_instance = test.shape[0]
        self.n_feature = test.shape[1] - 1
        self.X = test.drop(['bug'], axis=1)
        self.y = ['F' if item == 0 else 'T' for item in test.loc[:, 'bug']]
        self.X = pd.DataFrame(min_max_scale(self.X))
        # weight initialization
        self.weight_initialization()

        for item in range(self.n_iteration):
            # membership degrees computation
            self.membership_degrees_computation()
            # update weights of neuron
            self.update()
        u = np.array(self.membership_matrix)

        if sum(u[0] > u[1]) > 0.5 * len(u[0]):
            flag = 1
        else:
            flag = 0
        predict_proba = u[flag]
        y_predict = ['T' if u[flag][idx] > u[abs(flag - 1)][idx] else 'F' for idx in range(len(u[0]))]
        print(Counter(y_predict))
        test['y_predict'] = y_predict
        test['predict_proba'] = predict_proba
        self.test = test.sort_values(['predict_proba', 'sloc', 'bug'], ascending=(False, True, True))


class pFCM(tUCS):

    def rank(self,test):
        data = np.transpose(test.drop(['bug'], axis=1).to_numpy())
        # u is predict score. the higher the u[?,idx] the more defect prone
        cntr, u, u0, d, jm, p, fpc = fuzz.cmeans(data=data, c=2, m=2, error=1e-20, maxiter=1000, seed=0)
        print('p = ',p)
        if sum(u[0] > u[1]) > 0.5 * len(u[0]):
            flag = 1
        else:
            flag = 0
        predict_proba = u[flag]
        y_predict = ['T' if u[flag][idx] > u[abs(flag - 1)][idx] else 'F' for idx in range(len(u[0]))]
        test['y_predict'] = y_predict
        test['predict_proba'] = predict_proba
        test = test.sort_values(['predict_proba', 'sloc', 'bug'], ascending=(False, True, True))

        sloc = np.array(test['sloc']).cumsum()
        if self.method == 'SSC':
            tmp_cutoff = 0
            while tmp_cutoff < len(sloc) and sloc[tmp_cutoff] <= sloc[-1] * self.cutoff:
                tmp_cutoff = tmp_cutoff + 1
            self.cutoff = tmp_cutoff
        level1 = test.iloc[0: self.cutoff, :]
        level2 = test.iloc[self.cutoff:len(test), :]
        level1['y_predict'] = 'T'
        level2['y_predict'] = 'F'
        test = pd.concat([level1, level2], ignore_index=False)

        self.test = test



def test_FCM():
    path = "../data_Herbold/AEEEM/eclipse/AEEEM-eclipse.csv"
    # path = "C:\\Users\\Lau\\OneDrive\\UCS2\\UCS\\data_Herbold\\AEEEM\\lucene\\AEEEM-lucene.csv"
    # path = "C:\\Users\\Lau\\OneDrive\\UCS2\\UCS\\data_Herbold\\MDP\\MC1\\MDP-MC1.csv"
    # path = "C:\\Users\\Lau\\OneDrive\\UCS2\\UCS\\data_Herbold\\ALLJURECZKO\\ant\\ALLJURECZKO-ant-1.4.csv"
    df = pd.read_csv(path)
    fcm = FCM()
    fcm.rank(df)

def test_FSOMs():
    # path = "C:\\Users\\Lau\\OneDrive\\UCS2\\UCS\\data_Herbold\\AEEEM\\eclipse\\AEEEM-eclipse.csv"
    # path = "C:\\Users\\Lau\\OneDrive\\UCS2\\UCS\\data_Herbold\\AEEEM\\lucene\\AEEEM-lucene.csv"
    # path = "C:\\Users\\Lau\\OneDrive\\UCS2\\UCS\\data_Herbold\\MDP\\MC1\\MDP-MC1.csv"
    # path = "C:\\Users\\Lau\\OneDrive\\UCS2\\UCS\\data_Herbold\\ALLJURECZKO\\ant\\ALLJURECZKO-ant-1.4.csv"
    path = "../data_Herbold/ALLJURECZKO/ant/ALLJURECZKO-ant-1.4.csv"
    df = pd.read_csv(path)
    fsom = FSOMs()
    fsom.rank(df)
    print(fsom.test)

def test(dataset):
    pair = get_split(dataset, scenario='cpdp')
    for test_path, trains_path in pair.items():
        # print('test on :', test_path.split('\\')[-1])
        train_df = pd.concat([pd.read_csv(train_path) for train_path in trains_path], ignore_index=True)
        test_df = pd.read_csv(test_path)
        max_popt = -1
        best_x, best_y, best_first = 0, 0, 0
        for x in range(1, 9, 1):
            for y in range(1, 10 - x, 1):
                for first in ['L1', 'L3']:
                    clf = UCS2(x*1.0/10, y*1.0/10, rank_strategy='worst', first=first)
                    clf.rank(test_df)
                    ranked_test = clf.test
                    list_of_metrics = Metric().get_metrics(ranked_test)
        #             if f1 > max_popt:
        #                 max_popt = f1
        #                 best_x = x
        #                 best_y = y
        #                 best_first = first
        # print('best combination, x:', best_x, ' y:', best_y, 'first:', best_first)


def test2(dataset='jira',scenario='cpdp',order='111'):
    pair = get_split(dataset, scenario=scenario)
    print('x\t', 'y\t', 'first\t', 'f1\t', 'AUC\t', 'AP\t', 'RR\t', 'er\t', 'ri\t', 'Popt\t', 'ACC\t', 'AUCEC\t', 'PCI\t')
    res = []
    for x in range(0, 100, 20):
        for y in range(5, 105 - x, 20):
            for first in ['L1', 'L3']:
                if x == 0 and first == 'L3':
                    continue
                tp, fp, tn, fn, f1, AUC, AP, RR, er, ri, Popt, ACC, AUCEC, PCI = [], [], [], [], [], [], [], [], [], [], [], [], [], []
                res_df = pd.DataFrame(columns=Metric().get_list_of_metric_names())

                for test_path, trains_path in pair.items():
                    # print('test on :', test_path.split('\\')[-1])
                    train_df = pd.concat([pd.read_csv(train_path) for train_path in trains_path], ignore_index=True)
                    test_df = pd.read_csv(test_path)
                    if 'sloc' not in test_df:
                        print(test_path)

                    clf = UCS2(x * 1.0 / 100, y * 1.0 / 100, rank_strategy='worst', first=first, order=order)
                    clf.rank(test_df)
                    ranked_test = clf.test
                    # tp_, fp_, tn_, fn_, f1_, AUC_, AP_, RR_, er_, ri_, Popt_, ACC_, AUCEC_, PCI_ = get_metrics(ranked_test)

                    list_of_metrics = Metric().get_metrics(ranked_test)
                    list_of_metrics2 = Metric(ranked_test).all_metrics()
                    print('list_of_metrics \n', list_of_metrics)
                    print('list_of_metrics2 \n', list_of_metrics2)
                    res_df.loc[len(res_df)] = list_of_metrics


                # print(res_df.mean().to_list())
                res.append([x,  y,  first] + res_df.mean().to_list())
    res = pd.DataFrame(res, columns=['x', 'y', 'first'] + Metric().get_list_of_metric_names())
    path = './result/' + dataset + '/' + dataset + '_' + scenario + '_' + 'UCS2' + '_' + order + '.csv'
    res.to_csv(path, index=False)
    print('result saved in ', path)


def test3():
    for x in range(1, 9, 1):
        for y in range(1, 10 - x, 1):
            print(x,y)



if __name__ == '__main__':
    os.chdir("../")
    # test_FCM()
    test_FSOMs()
    # 创建两个线程

    # _thread.start_new_thread(multi, ('Thread-1', 'jureczko', 'spv', '000',))
    # _thread.start_new_thread(multi, ('Thread-2', 'jureczko', 'spv', '001',))
    # _thread.start_new_thread(multi, ('Thread-3', 'jureczko', 'spv', '010',))

    # test2(dataset='jira', scenario='spv')
    # test4(dataset='jira', scenario='spv',order='111')
    # test2(dataset='jira', scenario='cpdp', order='111')
    # test2(dataset='jureczko_withFileNameAndsloc', scenario='spv', order='000')
    # test2(dataset='jureczko_withFileNameAndsloc', scenario='spv', order='001')
    # test2(dataset='jureczko_withFileNameAndsloc', scenario='spv', order='010')
    # test2(dataset='jureczko_withFileNameAndsloc', scenario='spv', order='011')
    # test2(dataset='jureczko_withFileNameAndsloc', scenario='spv', order='100')
    # test2(dataset='jureczko_withFileNameAndsloc', scenario='spv', order='101')
    # test2(dataset='jureczko_withFileNameAndsloc', scenario='spv', order='110')
    # test2(dataset='jureczko_withFileNameAndsloc', scenario='spv', order='111')


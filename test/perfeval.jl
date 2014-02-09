
using MLBase
using Base.Test

import StatsBase
import StatsBase: harmmean 

## correctrate & errorrate

a = [1, 1, 1, 2, 2, 2, 3, 3]
b = [1, 1, 2, 2, 2, 3, 3, 3]

@test correctrate(a, b) == 0.75
@test errorrate(a, b) == 0.25

## ROCNums

r = ROCNums{Int}(
    100, # p == tp + fn
    200, # n == tn + fp
    80,  # tp
    150, # tn
    50,  # fp
    20)  # fn

@test true_positive(r) == 80
@test true_negative(r) == 150
@test false_positive(r) == 50
@test false_negative(r) == 20

@test true_positive_rate(r) == 0.80
@test true_negative_rate(r) == 0.75
@test false_positive_rate(r) == 0.25
@test false_negative_rate(r) == 0.20

@test recall(r) == 0.80
@test precision(r) == (8/13)
@test_approx_eq f1score(r) harmmean([recall(r), precision(r)])


## auxiliary: find_thresbin & lin_threshold

ts = [2, 4, 6, 8]
ft = [MLBase.find_thresbin(i, ts) for i = 1:9]
@test isa(ft, Vector{Int})
@test ft == [1, 2, 2, 3, 3, 4, 4, 5, 5]

@test MLBase.lin_thresholds([1, 5], 5, Forward) == 1.0:1.0:5.0
@test MLBase.lin_thresholds([1, 5], 5, Reverse) == 5.0:-1.0:1.0


## roc (for single threshold)

gt = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2]
pr = [0, 0, 1, 0, 0, 1, 1, 0, 1, 2, 2, 2, 2, 0, 1]

r0 = ROCNums{Int}(10, 5, 6, 4, 1, 2)
@test roc(gt, pr) == r0

gt = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1]
ss = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1]

@test roc(gt, ss, 0.25) == ROCNums{Int}(6, 5, 6, 2, 3, 0)
@test roc(gt, ss, 0.55) == ROCNums{Int}(6, 5, 6, 5, 0, 0)
@test roc(gt, ss, 0.75) == ROCNums{Int}(6, 5, 4, 5, 0, 2)

gt = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2]
pr = [1, 1, 1, 2, 2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 1]
ss = [0.2, 0.2, 0.2, 0.3, 0.3, 0.6, 0.6, 0.6, 0.6, 0.6, 0.8, 0.8, 0.8, 0.8, 0.8]

@test roc(gt, pr, ss, 0.00) == ROCNums{Int}(10, 5, 8, 0, 5, 0)
@test roc(gt, pr, ss, 0.25) == ROCNums{Int}(10, 5, 8, 3, 2, 0)
@test roc(gt, pr, ss, 0.50) == ROCNums{Int}(10, 5, 8, 5, 0, 0)
@test roc(gt, pr, ss, 0.75) == ROCNums{Int}(10, 5, 4, 5, 0, 5)
@test roc(gt, pr, ss, 1.00) == ROCNums{Int}(10, 5, 0, 5, 0, 10)


## roc

gt = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1]
ss = [1., 2., 3., 4., 5., 4., 5., 6., 7., 8., 9.]

r2 = ROCNums{Int}(6, 5, 6, 1, 4, 0)
r4 = ROCNums{Int}(6, 5, 6, 3, 2, 0)
r6 = ROCNums{Int}(6, 5, 4, 5, 0, 2)

@test roc(gt, ss, 2.0, Forward) == r2
@test roc(gt, ss, 4.0, Forward) == r4
@test roc(gt, ss, 6.0, Forward) == r6

@test roc(gt, ss, [2.0, 4.0, 6.0], Forward) == [r2, r4, r6]
@test roc(gt, ss, [2.0, 4.0, 6.0]) == [r2, r4, r6]

@test roc(gt, ss, 5) == roc(gt, ss, [1., 3., 5., 7., 9.])
@test roc(gt, ss) == roc(gt, ss, 100)

gt = [1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
ss = [1., 2., 3., 4., 5., 4., 5., 6., 7., 8., 9.]

r2 = ROCNums{Int}(5, 6, 2, 6, 0, 3)
r4 = ROCNums{Int}(5, 6, 4, 5, 1, 1)
r6 = ROCNums{Int}(5, 6, 5, 3, 3, 0)

@test roc(gt, ss, 2.0, Reverse) == r2
@test roc(gt, ss, 4.0, Reverse) == r4
@test roc(gt, ss, 6.0, Reverse) == r6

@test roc(gt, ss, [6.0, 4.0, 2.0], Reverse) == [r6, r4, r2]

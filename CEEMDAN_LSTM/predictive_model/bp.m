tic;
%% 导入数据（不改）
clc;
clear all;
%  rng(05);
data = load('a.mat');
%% 加载
data = data.a';
lag=1;

%% 划分测试、训练
% numTimeStepsTrain = floor(0.6*numel(data));
% numTimeStepsVal = floor(0.8*numel(data));

numTimeStepsTrain = floor(0.7*numel(data));
numTimeStepsVal = floor(0.85*numel(data));

% numTimeStepsTrain = floor(0.8*numel(data));
% numTimeStepsVal = floor(0.9*numel(data));

dataTrain = data(1:numTimeStepsTrain);
dataVal = data(numTimeStepsTrain+1:numTimeStepsVal);
dataTest = data(numTimeStepsVal+1:end);

%% 归一化
max_d = max(dataTrain);
min_d = min(dataTrain);
dataTrainStandardized = (dataTrain - min_d) / (max_d-min_d);
dataValStandardized = (dataVal - min_d) / (max_d-min_d);
dataTestStandardized=(dataTest - min_d) / (max_d-min_d);

for i=1:lag
    XTrain(i,:) = dataTrainStandardized(i:end-lag-1+i);
end
YTrain = dataTrainStandardized(lag+1:end);

for i=1:lag
    XVal(i,:) = dataValStandardized(i:end-lag-1+i);
end
YVal = dataValStandardized(lag+1:end);

for i=1:lag
    XTest(i,:) = dataTestStandardized(i:end-lag-1+i);
end
YTest = dataTestStandardized(lag+1:end);

%% BP网络训练（改超参数）
net=newff(XTrain,YTrain,10);%修改节点（数字），当设置两层则改为如[10 5]格式
net.trainParam.epochs=100;%修改训练次数，从50开始
net.trainParam.lr=0.001;%修改学习率，一般从0.1、0.05、0.01、0.005修改
net.trainParam.max_fail=10;%设置早停，一般改10~20
net.trainParam.goal=1e-7;%不改
%网络训练
net=train(net,XTrain,YTrain);

%% BP网络预测（不改）
YPred0 = sim(net,XTrain);
YPred0 = (max_d-min_d)*YPred0 +min_d;
YTrain = (max_d-min_d)*YTrain +min_d;
rmse0  = sqrt(mean((YPred0-YTrain).^2));
R20    = 1 - norm(YTrain-YPred0)^2/norm( YTrain - mean( YTrain))^2

YPred1=sim(net,XVal);
YPred1 = (max_d-min_d)*YPred1 +min_d;
YVal = (max_d-min_d)*YVal +min_d;
rmse1 = sqrt(mean((YPred1-YVal).^2));
R21 = 1 - norm(YVal-YPred1)^2/norm( YVal - mean( YVal))^2


YPred=sim(net,XTest);
YPred = (max_d-min_d)*YPred +min_d;
YTest = (max_d-min_d)*YTest +min_d;
rmse = sqrt(mean((YPred-YTest).^2));
R2 = 1 - norm(YTest-YPred)^2/norm( YTest - mean( YTest))^2

%% 作图
% figure
% subplot(2,1,1)
% plot(YTest)
% hold on
% plot(YPred,'.-')
% hold off
% legend(["Observed" "Predicted"])
% ylabel("Cases")
% title("Forecast with Updates")
% 
% subplot(2,1,2)
% stem(YPred - YTest)
% xlabel("Month")
% ylabel("Error")
% title("RMSE = " + rmse)
% YPred=YPred';
% YTest=YTest';

toc
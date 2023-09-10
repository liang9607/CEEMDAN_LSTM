tic;
clc;
clear all;
%  rng(10);
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

%%
numFeatures = lag;
numResponses = 1;
numHiddenUnits = 60;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
%     lstmLayer(20)
    %dropoutLayer(0.1)
    fullyConnectedLayer(numResponses)
    regressionLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',500, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.01, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',40, ...
    'LearnRateDropFactor',0.2, ...
   'Plots','training-progress', ...
   'Verbose',0);

%   'Plots','training-progress', ...
net = trainNetwork(XTrain,YTrain,layers,options);

net = resetState(net);
net = predictAndUpdateState(net,XTrain);

YPred0 = [];
numTimeStepsTest0 = length(XTrain);
for i = 1:numTimeStepsTest0
    [net,YPred0(i)] = predictAndUpdateState(net,XTrain(:,i),'ExecutionEnvironment','cpu');
end
YTrain = (max_d-min_d)*YTrain +min_d;
YPred0 = (max_d-min_d)*YPred0 +min_d;

rmse0 = sqrt(mean((YPred0-YTrain).^2))
smape1 = mean(abs(YTrain - YPred0)./(0.5*(abs(YTrain)+abs(YPred0))))*100
R20 = 1 - norm(YTrain-YPred0)^2/norm( YTrain - mean( YTrain))^2



YPred1 = [];
numTimeStepsTest1 = length(XVal);
for i = 1:numTimeStepsTest1
    [net,YPred1(i)] = predictAndUpdateState(net,XVal(:,i),'ExecutionEnvironment','cpu');
end
YVal = (max_d-min_d)*YVal +min_d;
YPred1 = (max_d-min_d)*YPred1 +min_d;

rmse1 = sqrt(mean((YPred1-YVal).^2))
smape1 = mean(abs(YVal - YPred1)./(0.5*(abs(YVal)+abs(YPred1))))*100
R21 = 1 - norm(YVal-YPred1)^2/norm( YVal - mean( YVal))^2

YPred = [];
numTimeStepsTest = length(XTest);
for i = 1:numTimeStepsTest
    [net,YPred(i)] = predictAndUpdateState(net,XTest(:,i),'ExecutionEnvironment','cpu');
end

YTest = (max_d-min_d)*YTest +min_d;
YPred = (max_d-min_d)*YPred +min_d;

rmse = sqrt(mean((YPred-YTest).^2));
smape = mean(abs(YTest - YPred)./(0.5*(abs(YTest)+abs(YPred))))*100;
R2 = 1 - norm(YTest-YPred)^2/norm( YTest - mean( YTest))^2

% %% 作图
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
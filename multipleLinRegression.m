function multipleLinRegression( data )
%This function calculates results for mutivariable linear regression
%Paula Conn, 2016

%-Linear regression on all data except class and year
X=data(:,2:6);
Y=data(:,7);
n=length(X);

%Split data 65% training
indexTrain=randperm(size(X,1),475);
indexTest=1:size(X,1);
indexTest(indexTrain)=[]; 
trainX=X(indexTrain,:);
trainY=Y(indexTrain);
testX=X(indexTest, :);
testY=Y(indexTest);

%Fit model on all the data
lmModel=fitlm(trainX,trainY,'linear','RobustOpts','on');
fprintf('\nMultivariate Linear Regression on All Data\n----------------------\n');
disp(lmModel);
ypred=predict(lmModel,testX);

%Plot differences in predicted values (scatter perfect on line=perfect corr)
figure(2)
hold on
subplot(2,1,1)
plot(ypred,testY,'o') 
ylabel('Predicted Y-Values');
xlabel('Original Y Values of All Test Data');
hold on
linearModel=polyfit(ypred,testY,1);
plot(ypred,polyval(linearModel,ypred,'r-'));
hold on
title('Comparison of Predicted-Y and Y-Original');

%-Linear regression on top 3 only, as previously cal. in the LR function
sumSSE=0;
x1=data(:,3);
x2=data(:,5);
x3=data(:,6);
X=horzcat(x1,x2,x3);
n=length(X);

%Use 65% again for traning, split up the data 
trainX=X(indexTrain,:);
trainY=Y(indexTrain);
testX=X(indexTest, :);
testY=Y(indexTest);

%Fit model on top three
fprintf('\nTop 3 Multivariate Linear Model\n------------------------------\n');
fprintf('x1=Acid \nx2=Dissipation \nx3=Color\n');
lmModel=fitlm(trainX,trainY,'linear','RobustOpts','on');
disp(lmModel);
ypred=predict(lmModel,testX);
yn=length(ypred);
MSE1=(sum((ypred-testY).^2))/yn;

%Plot the data
subplot(2,1,2)
plot(ypred,testY,'o') 
ylabel('Predicted Y-Values');
xlabel('Original Y Values of Top Three Test Data');
hold on
linearModel=polyfit(ypred,testY,1);
plot(ypred,polyval(linearModel,ypred,'r-'));

%-Apply K-fold to evaluate error accuracy
chunk = 10;                 
allIndex = randperm(n);    
grouping = ceil(n/chunk);  
allIndex = reshape([allIndex NaN(1,chunk*grouping-n)],chunk,grouping);

figure(3)
hold on
for p=1:chunk
    %Sample new set of training and testing data
    testIndx = allIndex(p,:); 
    trainIdx = setdiff(1:n,testIndx); 
    trainX=X(trainIdx,:);
    trainY=Y(trainIdx);
    testX=X(testIndx, :);
    testY=Y(testIndx);
    
    %Fit a model to the data
    lmModel=fitlm(trainX,trainY,'linear','RobustOpts','on');
    ypred=predict(lmModel,testX);
    
    %Calculate associated errors
    SSE2=sum((ypred-testY).^2);
    MSE2(p)=SSE2/grouping;
    
    %Plot the data to compate each cycle
    subplot(5,5,p)
    plot(ypred,testY,'o')
    ylabel('Predicted Y');
    xlabel('Original Y');
    hold on
    linearModel=polyfit(ypred,testY,1);
    plot(ypred,polyval(linearModel,ypred,'r-'));
end
title('Comparison of Predicted-Y and Y-Original by Each K-Fold')

%Print results
fprintf('\nK-Fold Model vs. Top 3 Model\n------------------------------\n');
fprintf('Mean Squared Errors Original (top 3)= %.2f\n\n',MSE1);

SEM = std(MSE2)/sqrt(length(MSE2));
tscore = tinv([0.025  0.975],length(MSE2)-1);
CI = mean(MSE2) + tscore*SEM;
fprintf('95%% CI for Mean Squared Errors K-fold= [%.2f, %.2f]\n',CI(1,1),CI(1,2));
fprintf('Root mean sum of errors k-fold= %.2f\n',sqrt(sum(MSE2)/chunk));
fprintf('Number of bins/folds k-fold= %.0f\n',chunk);
fprintf('Total observations per bin/fold k-fold= %.0f\n\n',grouping);
end



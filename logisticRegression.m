function logisticRegression(plotTitles, nominalData, data )
%This function calculates results for logistic regression
%Paula Garcia, 2016

%Generate the categories
classCat=nominalData(:,8);
X=horzcat(data(:,2:7));
Y=nominal(classCat);
Y=double(Y);

fprintf('\nCORRELATION VALUES WITH CLASS\n-----------------------------------\n')

%Find correlated values
for i=2:7
    Xcorr=data(:,i);
    rho = corrcoef([Xcorr Y]);
    fprintf('Class and %s\tr= %.2f\n',plotTitles{i},rho(2,1));
end

%-Fit multinomial model to all the data
fprintf('\nMultinomial All Sample vs. Top 3\n-----------------------------------\n')
[B1,dev1,stats1]=mnrfit(X,Y,'model','nominal','interactions','on');
[pihat1, dlow1, hi1]=mnrval(B1,X,stats1,'model','nominal','interactions','on');
% B1 %prints coefficients
fprintf('Estimated Dispersion of all sample: %.2f, df=%.2f\n', stats1.sfit,stats1.dfe);
SSR1=sum((stats1.resid).^2);
fprintf('Sum of squared residuals of all sample, per class: %.2f, %.2f, %.2f, %.2f\n\n',SSR1(1,1), SSR1(1,2),SSR1(1,3),SSR1(1,4));
%-Only select top correlated values
x1=data(:,3);
x2=data(:,6);
x3=data(:,7);
X2=horzcat(x1,x2,x3);

%Fit multinomial model to top three
warning('off','all') 
[B2,dev2,stats2]=mnrfit(X2,Y,'model','nominal','interactions','on');
[pihat2, dlow2, hi2]=mnrval(B2,X2,stats2,'model','nominal','interactions','on');
LL=pihat2-dlow2;
UL=pihat2+hi2;
% B2 %print coefficients
SSR2=sum((stats2.resid).^2);
fprintf('Estimated Dispersion of top 3: %.2f, df=%.2f\n', stats2.sfit,stats2.dfe);
fprintf('Sum of squared residuals of all sample, per class: %.2f, %.2f, %.2f, %.2f\n',SSR2(1,1), SSR2(1,2),SSR2(1,3),SSR2(1,4));

figure(4)
hold on
for i=1:3
    % Plot results
     subplot(3,1,i)
     plot(X2(:,i),Y,'o');
     hold on  
     xlabel(' input');
    ylabel('Class Classification')
end
end


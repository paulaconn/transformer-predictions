function linearRegression
%This function calculates r values and simple linear regression
%Paula Garcia, 2016

  fid = fopen('IF1-FEB22-detailed.csv','r');   
  originalData = cell(100,1);  
  formattedData=[];
  linearEquation=[];
  row = 1;
  nextLine = fgetl(fid);
  
  %-Read the original data in cell format b/c of variable types
  while ~isequal(nextLine,-1)
    originalData{row} = nextLine;  
    row = row+1;         
    nextLine = fgetl(fid);            
  end
  fclose(fid);    
  %Filter the cells: remove empty cells and last three unused rows
  %Filter the contents from individual cell formatting and empty delimiters
  originalData = originalData(3:row-1);
  for index = 1:row-3;             
    lineData = textscan(originalData{index},'%s',... 
                        'Delimiter',',');           
    lineData = lineData{1}; 
    if strcmp(originalData{index}(end),',');  
      lineData{end+1} = '';
    end
    originalData(index,1:numel(lineData)) = lineData;
    lineData=lineData(1:7).';
    %Change valid values to format double for calculations (1-7 are valid)
    lineDataDouble=[];
    lineDataDouble(1,1:7)= str2double(lineData(1,1:7));
    formattedData(index,1:numel(lineDataDouble)) = lineDataDouble;
  end
  %-Calculate the correlation coefficient, Y=Tension comp(X)
   Y=(formattedData(:,7));
   plotTitles={'Year','Water','Acid','Voltage','Dissipate','Colour','Tension'};
   fprintf('\nCORRELATION VALUES WITH TENSION\n-----------------------------------\n')
   
   figure(1)
   hold on
   for i=1:6
     X=(formattedData(:,i));
     %Fit a model to the data
     linearModel=polyfit(X,Y,1);
     linearEquation(i,1:2) = polyfit(X,Y,1);
     %Plot the data
     subplot(3,3,i)
     plot(X,Y,'o')
     title(strcat(plotTitles{i},' & Tension'));
     ylabel('Interfacial Tension');
     xlabel(plotTitles{i});
     hold on
     plot(X,polyval(linearModel,X),'r-');
     
     %Calculate correlation coefficient
     rho = corrcoef([X Y]);
     fprintf('Tension and %s \t r= %6.2f\n',plotTitles{i},rho(2,1));
     
     %Assess the significance of the most correlated models
     if i==3|i==5||i==6
         lmSummary=fitlm(X,Y,'linear');
         %disp(lmSummary); %uncomment this and one below to view
     end
     %fprintf('--\n');
   end
   
   %Apply multiple regression analysis on top three and all the data
   multipleLinRegression(formattedData);
   %Calculate top three & logistic regression for top three and all the data
   logisticRegression(plotTitles, originalData,formattedData);
end


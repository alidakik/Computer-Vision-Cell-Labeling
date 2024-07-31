function createExcelWithObjectInfo(originalImage, excelFilename)
    
    [counts,x] = imhist(originalImage,16);
    T = otsuthresh(counts);
    BW = imbinarize(originalImage,T);
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%ATTENTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % fill the gaps
    % there is one layer has been removed and never got it back so the objects 
    % don't conflict, so to not get the area wrong I'm calculting  
    % the layer of 1-pixel width around each object and adding it to 
    % the calculated area
    
    SE = strel("sphere",1);
    BW = imerode(BW,SE);
    BW = imdilate(BW, SE);
    BW = imerode(BW,SE);
    BW = imdilate(BW, SE);
    BW = imerode(BW,SE);
    BW = imerode(BW,SE);
    BW = imdilate(BW, SE);
    
    % BW = My_fill(BW);
    BW = bwmorph(BW,'majority');

    
    
    [count ,labeledMatrix] = My_Labeling(BW);


    
    uniqueLabels = unique(labeledMatrix(:));
    uniqueLabels(uniqueLabels == 0) = []; 
    
    
    objectIDs = [];
    numPixels = [];
    meanBrightness = [];
    
    for i = 1:length(uniqueLabels)
        label = uniqueLabels(i);

        objectPixels = (labeledMatrix == label);

        numPixel = sum(objectPixels(:));
        radius = sqrt(numPixel / pi);
        perimeter = round(2 * pi * radius);
        area = numPixel + perimeter;

        numPixels = [numPixels; area];

        meanBrightness = [meanBrightness; mean(originalImage(objectPixels))];
        objectIDs = [objectIDs; label];
    end
    
    T = table(objectIDs, numPixels, meanBrightness, ...
        'VariableNames', {'ObjectID', 'Area', 'MeanBrightness'});
    
    writetable(T, excelFilename);
    fprintf('Excel file "%s" created successfully.\n', excelFilename);
end

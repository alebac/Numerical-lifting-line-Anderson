function [ database ] = readFile(fileName)
% FILEREAD reads data from file, it is created to read aerodynamic
% airfoil data from text files.

% Open file
fileID = fopen(fileName,'r');

% % Neglect the title lines
% for i = 1:titleLines
%     fgetl(fileID);
% end

% Create the format specifier with which the data will be read
formatSpec = '%f %f';

% Dimensions of the matrix in which data will be stored
sizeDatabase = [2, Inf];

% Read data
database = fscanf(fileID,formatSpec,sizeDatabase);

% Close file
fclose(fileID);

end
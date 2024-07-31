clc, clear , close all;

I = imread("Cells.tif");

createExcelWithObjectInfo(I, 'output.xlsx');
function compile_pascal_eval(cls,dets, testset, year, numworkers)
% Script to create executable for pascal_eval.
% Parameters during execution:
% 	cls		: evaluation class.
%	dets		: detections.
%	year		: year to evaluate against.
% 	suffix 		: suffix for saving (pascal_eval)
%	outpath		: .mat file to save [ap,pred,recall] to.

startup;
% Adding the paths to the executables.

ds = load(dets,'-mat');
suffix='';
numworkers = str2num(numworkers);

myCluster = parcluster('local');
myCluster.NumWorkers = numworkers;
symbols = ['a':'z' 'A':'Z'];
MAX_ST_LENGTH = 10;
stLength = randi(MAX_ST_LENGTH);
nums = randi(numel(symbols),[1 stLength]);
x = symbols (nums);
saveAsProfile(myCluster,x);
matlabpool('open',x,numworkers);
matlabpool size
tic;
output = pascal_eval(cls,ds, testset, year, suffix); 
toc;
matlabpool('close',x,numworkers);

out_path = strcat(dets,'.eval.mat');

save(out_path,'output');
%Save the output to a .mat file.

end

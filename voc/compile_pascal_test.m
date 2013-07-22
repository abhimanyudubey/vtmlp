function compile_pascal_test(model_path, testset, year, numworkers)
% Script to create executable for pascal_train.
% Parameters during execution:
% 	model_path	: Path to model. 
%	out_path	: Path to save output.
%	testset		: Test set data.
% 	year		: Year of test data to use.
%	suffix		: Suffix for pascal_test.
startup;
% Adding the paths to the executables.
suffix='';

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
load(model_path,'-mat');
% Loads model from .mat file.

ds = pascal_test(model, testset, year, suffix); 

ds

matlabpool('close',x,numworkers);

out_path = strcat(model_path,'.detections.mat');
save(out_path,'ds');


%Save the output to a .mat file.


end

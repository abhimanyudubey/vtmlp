function compile_pascal_train(out_path, cls, n, numworkers)

note='deployed';
numworkers = str2num(numworkers);
opts = str2num(opts);
n  = str2num(n);

if isdeployed
	if opts == 1
	addpath(genpath('~/voc-release5/VOC2007/'));
	elseif opts == 2
		addpath(genpath('~/voc-release5/VOC2007/VOCdevkit/VOC2007'));
	end
end

if numworkers ~= 0



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
model = pascal_train(cls, n, note);
% Evaluates model.
toc;
save(out_path,'model');
%Save the model to a .mat file.
matlabpool('close',x,numworkers);

end

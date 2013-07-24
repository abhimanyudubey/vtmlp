% MATLAB Script to create executable for pascal_train.
% Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
% Virginia Polytechnic Institute and State University, 2013.
% Parameters during execution:
%	out_path	: Path to save output.
%	cls			: The class which has to be trained. (pascal_train)
% 	n			: The number of aspect ratio clusters to use. (pascal_train)
%	numworkers	: Number of workers in matlabpool to be created. If 0, no matlabpool is created.

function compile_pascal_train(out_path, cls, n, numworkers, varargin)
	startup;
	%Preprocessing all variables taken in, all are strings. Adding note 'deployed' for all deployed calls.
	note='deployed';
	numworkers = str2num(numworkers);
	n  = str2num(n);

	%If numworkers = 0, do not start matlabpool (launching individual jobs on Amazon EC2.)
	if numworkers ~= 0
		%Creating a custom matlabpool profile from local, with a random name to avoid clashes.
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
		%Prints size of matlabpool, should be equal to numworkers if matlabpool is created correctly.
	end

	tStart = tic;
	nvarargs = length(varargin);
	if nvarargs == 6
		[annoPath, imgPath, imgsetPath, clsimgsetPath, clsresPath, detresPath] = varargin; 
		model = pascal_train(cls, n, note, annoPath, imgPath, imgsetPath, clsimgsetPath, clsresPath, detresPath);
	else
		model = pascal_train(cls, n, note);
	end
	% Evaluates model.
	tStop = toc(tStart);
	%Save time of entire evaluation.

	save(out_path,'model');
	%Save the model to a .mat file.

	timepath = strcat(out_path,'.time.txt');
	save(timepath,'tStop','-ascii');
	%Saving the run time to a text file with the same name as the out_path.

	if numworkers ~= 0
		%If the matlabpool is created, closing it.
		matlabpool('close',x,numworkers);
	end
end

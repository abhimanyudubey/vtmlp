%Accompanying MATLAB script for generating time and speedup plots for parallelization experiments. 
%Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
%Virginia Polytechnic Institute and State University, 2013.
function generate_plot_script(filename)
	data = load(filename);
	datasize = size(data);
	nrows= datasize(1);
	limit=2*data(nrows,1)-data(nrows-1,1);
	data_comp = zeros(nrows,limit);
	compfile = strcat(filename,'.data.log.txt');
	fstr='';
	for i=1:limit,
		fstr=strcat(fstr,'%f');
	end
	data_comp = load(compfile);
	%Loaded files from input.
	f = figure;
	cpsize = size(data_comp);
	cprows = cpsize(1);
	cpcols = cpsize(2);
	comptimes = zeros(cprows);
	%Initialise loop variables and empty vectors.
	for i=1:cprows,
		nonzeros=0;
		sum=0;
		for j=1:cpcols,
			if ~isequal(0,data_comp(i,j))
				nonzeros=nonzeros+1;
			end
			sum=sum+data_comp(i,j);
		end
		sum=sum/data(i,1);
		comptimes(i)=sum;
	end
	%Added individual computational times and stored them in comptimes.
	%Computing the individual times and speedups now.
	timemat = zeros(cprows,4);
	speedupmat = zeros(cprows,4);
	INIT_TIME_TOTAL = data(1,2)*60+data(1,3);
	INIT_TIME_COMP = data_comp(1);
	INIT_TIME_COMM = INIT_TIME_TOTAL - INIT_TIME_COMP;
	%Set the initial times to calculate speedups relative to.
	for i=1:cprows,
		timemat(i,1)=data(i,1);
		speedupmat(i,1)=data(i,1);
		%Stored no of cores/processes.
		timemat(i,2)=data(i,2)*60+data(i,3);
		speedupmat(i,2)=INIT_TIME_TOTAL/timemat(i,2);
		%Stored total time and speedup.
		timemat(i,3)=data_comp(i);
		speedupmat(i,3)=INIT_TIME_COMP/data_comp(i);
		%Stored computation time and speedup.
		timemat(i,4)=timemat(i,2)-timemat(i,3);
		speedupmat(i,4)=INIT_TIME_COMM/timemat(i,4);
		%Stored communication time and speedup.
	end
	%Plotting the graphs to a file.
	subplot(1,2,1);
	h = plot(data(:,1),[timemat(:,2) timemat(:,3) timemat(:,4)]);
	legend('Total Time','Computation Time','Communication Time');
	xlabel('No. of running cores/processes');
	ylabel('Time taken for complete execution');
	title('Time Plot');
	%Plotted the time graph.
	subplot(1,2,2);
	h = plot(data(:,1),[speedupmat(:,1) speedupmat(:,2) speedupmat(:,3) speedupmat(:,4)]);
	legend('Linear Speedup','Total Speedup','Computation Speedup','Communication Speedup');
	xlabel('No. of running cores/processes');
	ylabel('Speedup Achieved');
	title('Speedup Plot');
	%Plotted the speedup graph.
	set(gcf,'units','points','position',[10,10,800,600])
	outname=strcat(filename,'.jpg');
	saveas(f, outname);
	%Saved graph to file.
end


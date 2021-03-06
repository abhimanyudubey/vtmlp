#!/bin/bash
#Script to generate timing plots for GraphLab built applications with increasing parallelization.
#Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
#Virginia Polytechnic Institute and State University, 2013.
#Parameters: $1 = mode name. $2 = name of executable. $3 = executable options (variables, etc.) $4 = initial #cores $5 = final #cores, #6 = step increment in #cores.

CDIR=$(pwd)

#Obtain Options
OPTS=$3

#Obtain Inital Count
COUNT=$4

if [ $1 = 'help' ]; then
	echo "Script to generate timing plot of execution of application with increasing number of cores.
Sample input:
./generate-plot.sh <mode of execution> <path/to/executable> <options and variables> <initial #cores> <final #cores> <step increment>
Mode of execution:

	parallel: 	Increases number of threads one by one by adjusting the --ncpus factor
	distribute:	Uses mpiexec to run and adjusts n keeping --ncpus constant and #threads per core/machine as 1.
	sgerun:		Uses Sun Grid Engine to distribute, to be run on a cluster with SGE installed.

Options and variables should be entered within double quotes.
Example:

./generate-plot.sh parallel dd \"--graph abcd.uai --maxiter 500\" 2 60 4"

else
echo "Plotting execution graph of $2 with increasing Amazon EC2 machines..."
#Output file for logs.
OUTFILE=$(date +%Y%m%d-%H%M%S)-$2-$1-$4-$5.log
mkdir $OUTFILE-log
while [ $COUNT -lt $5 ]
do
	#Directory created with logs for each file with filename as number of cores.
	FILENAME=$OUTFILE-log/$COUNT.log
	echo "Running iteration number $COUNT...."
	echo "To see running log open $FILENAME..."

	#Parallel running setting (using multiple threads on the same computer, running on different cores)
	if [ $1 = 'parallel' ]; then 
		echo Command: ./$2 $OPTS --ncpus $COUNT
		( time ./$2 $OPTS --ncpus $COUNT) &> $FILENAME
	else

		#Uses OpenMPI/MPICH2 to parallelize, with each process executing only one thread to limit processor's per core usage to 1.
		if [ $1 = 'distribute' ]; then
			echo Command: mpiexec -n $COUNT env "OMP_NUM_THREADS=1" ./$2 $OPTS --ncpus 1
			(time mpiexec -n $COUNT env "OMP_NUM_THREADS=1" ./$2 $OPTS --ncpus 1 ) &> $FILENAME
		else

			#Uses the Sun Grid Engine to parallelize by submitting jobs to different computers using mpiexec.
			if [ $1 = 'sgerun' ]; then
				echo Command: qsub -b y -cwd -pe orte $COUNT time mpirun ./$2 $OPTS
				(qsub -b y -cwd -pe orte $COUNT time mpirun ./$2 $OPTS ) &> $FILENAME
			fi
		fi
	fi 


	TIMEVAR=$(grep real $FILENAME)
	echo $FILENAME

	#Obtain communication times from global logger (in case of GraphLab)
	COMMTIME=$(grep 'Compute Balance' $FILENAME)
	echo "$COUNT $TIMEVAR" >> $OUTFILE
	ZEROS=""

	#Loop to add extra zeros to make MATLAB compatible input file.
	NCPP=$COUNT
	if [ $2 = 'distribute' ]; then
		while [ $NCPP -lt $5 ]
		do
			if [ "$ZEROS" = "" ]; then
				ZEROS="0"
			else
				ZEROS="$ZEROS 0"
			fi
			NCPP=$(( $NCPP + 1 ))
		done
	fi
	echo "$COMMTIME$ZEROS" >> $OUTFILE.data.log.txt
	COUNT=$(( $COUNT + $6 ))
done
	sed -i "s/real//" $OUTFILE
	sed -i "s/m/\t/" $OUTFILE
	sed -i "s/s//" $OUTFILE
	sed -i "s/INFO:     synchronous_engine.hpp(start:1391): Compute Balance: //" $OUTFILE.data.log.txt
	sed -i "s/\n/ /" $OUTFILE.data.log.txt
	sed -i "s/  / /" $OUTFILE.data.log.txt

#Generating MATLAB image if MATLAB available.
if hash matlab 2>/dev/null; then
	TEMP_IMG=$RANDOM$RANDOM
	cp $OUTFILE $TEMP_IMG.txt
	cp $OUTFILE.data.log.txt $TEMP_IMG.txt.data.log.txt
	matlab -nosplash -nodisplay -r "format LONG; generate_plot_script('$TEMP_IMG.txt'); exit"
	mv $TEMP_IMG.txt.jpg $OUTFILE.jpg
	rm -f $TEMP_IMG.txt.data.log.txt
else
	echo "No MATLAB detected; cannot generate plot. Check log for execution values."
fi
fi

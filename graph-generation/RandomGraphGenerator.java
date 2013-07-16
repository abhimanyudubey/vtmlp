/* Java script to generate Graph Files to be used for PageRank algorithm.
 * Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
 * Virginia Polytechnic Institute and State University, 2013. */
import java.io.*;
public class RandomGraphGenerator {
	public static void main(String args[])throws IOException{
		PrintWriter out = new PrintWriter("/Users/Abhimanyu/scratch/input.txt");
		//Output file path.
		int uLim = (int) (Math.random()*500000 + 500000);
		//uLim = component1*probability + fixed component 2. Maximum upper limit on nodes = component1+component2.
		for(int i=0; i < uLim; i++){
			int iter = (int) (Math.random()*500 + 400);
			//iter = average number of edges per nodes, generated randomly. minimum is comp2, maximum is comp1+comp2.
			out.print(i+" ");
			for(int j=0;j< iter; j++){
				int edge = (int) (Math.random()*uLim);
				if(edge != i)
					out.print(edge+" ");
			}
			out.println();
		}
	}
}

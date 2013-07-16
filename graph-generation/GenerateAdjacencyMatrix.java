/* Java script to generate adjacency matrix for any UAI Type Energy File.
 * Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
 * Virginia Polytechnic Institute and State University, 2013. */
import java.io.*;
import java.util.Scanner;
public class GenerateAdjacencyMatrix {
	public static void main(String args[])throws IOException{
		Scanner in = new Scanner(new FileReader(args[0]));
		//Location of source UAI File.
		in.next();
		int nnodes = in.nextInt();
		int[] cards = new int[nnodes];
		for(int i=0; i<nnodes;i++){
			cards[i]=in.nextInt();
		}
		int nfacts = in.nextInt();
		int[][] adj_matrix = new int[nfacts][nnodes];
		for(int i=0;i<adj_matrix.length;i++){
			for(int j=0;j<adj_matrix[0].length;j++){
				adj_matrix[i][j]=0;
			}
		}
		for(int i=0;i<nfacts;i++){
			int temp1 = in.nextInt();
			for(int j=0;j<temp1;j++){
				int id2=in.nextInt();
				adj_matrix[i][id2]+=1;
			}
		}
		for(int i=0;i<adj_matrix.length;i++){
			int deg=0;
			for(int j=0;j<adj_matrix[0].length;j++){
				deg+=adj_matrix[i][j];
			}
			System.out.println(i+" "+deg);
		}
	}
}

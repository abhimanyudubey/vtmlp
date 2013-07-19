/* Java script to generate UAI Files with unary and pairwise factors to be used for distributed dual decomposition.
 * Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
 * Virginia Polytechnic Institute and State University, 2013. */
import java.io.*;
import java.util.ArrayList;
import java.util.Hashtable;
public class UAIFileGenerator_PairWise {
	public static void main(String args[])throws IOException{
		PrintWriter out = new PrintWriter(args[0]);
		//Destination for output file.
		out.println("MARKOV");
		int nVars = Integer.parseInt(args[1]);
		//number of variables in UAI.<Edit>
		out.println(nVars);
		int cardLimit = 11;
		//maximum cardinality for any variable present.
		int cards[] = new int[nVars];
		for(int i=0;i<nVars;i++){
			cards[i]=(int) (2+Math.random()*(cardLimit-2));
			out.print(cards[i]+" ");
		}
		out.println();
		int maxDegree = 2;
		//This code generates only 1 degree and 2 degree cliques.
		
		//added a density factor for varying sparsity in the graph.
		double density = 0.3;
		
		Hashtable<double[],int[]> facs = new Hashtable<double[],int[]>();

		for(int k=0;k<Integer.parseInt(args[2]);k++){
			int i=(int)(Math.random()*nVars), j=(int)(Math.random()*nVars);
			double sum=i+j,product=i*j,t2[] ={sum,product};
				if(Math.random()<density && !facs.contains(t2) && i!=j ){
					int[] t = {i,j};
					facs.put(t2, t);
				}
		}
		ArrayList<int[]> facsn = new ArrayList<int[]>(facs.values());
		long tot = nVars + facs.size();
		out.println(tot);
		
		for(int i=0;i<nVars;i++){
			out.println("1 "+i);
		}
		
		for(int i=0;i<facsn.size();i++) {
			int t[] = facsn.get(i);
			out.println("2 "+t[0]+" "+t[1]);
		}
		//Completed the preamble generation.
		
		out.println();
		for(int i=0;i<nVars;i++){
			out.println(cards[i]);
			float sum=0;
			for(int j=0;j<cards[i]-1;j++){
				float tr = (float) (Math.random()*(1-sum));
				sum+=tr;
				out.print(tr+" ");	
			}
			out.println(1-sum+"\n");
		}
		
		for(int kk=0;kk<facsn.size();kk++) {
			int[] mat=facsn.get(kk);
			int i=mat[0],j=mat[1];
			int cardprod = cards[i]*cards[j];
			out.println(cardprod);
			for(int k=0;k<cards[i];k++){
				float sum=0;
				for(int l=0;l<cards[j]-1;l++){
					float tr = (float) (Math.random()*(1-sum));						
					sum+=tr;
					out.print(tr+" ");
				}
				out.println(1-sum);
			}
			out.println();
		}
		out.close();
	}
}
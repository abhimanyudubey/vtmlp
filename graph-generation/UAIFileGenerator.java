/* Java script to generate UAI Files with unary and pairwise factors to be used for distributed dual decomposition.
 * Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
 * Virginia Polytechnic Institute and State University, 2013. */
import java.io.*;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.concurrent.ConcurrentHashMap;
public class UAIFileGenerator {
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
		double density = 0.1;
		
		ConcurrentHashMap<double[],int[]> facs = new ConcurrentHashMap<double[],int[]>();
		long tot = nVars + Long.parseLong(args[2]);
		out.println(tot);
		
		for(int i=0;i<nVars;i++){
			out.println("1 "+i);
		}

		for(int k=0;k<Integer.parseInt(args[2]);k++){
			int i=(int)(Math.random()*nVars), j=(int)(Math.random()*nVars);
			double sum=i+j,product=i*j,t2[] ={sum,product};
				if(!facs.contains(t2) && i!=j ){
					int[] t = {i,j};
					out.println("2 "+t[0]+" "+t[1]);
					facs.put(t2, t);
					System.out.println("put item "+k);
				}
		}
		ArrayList<int[]> facsn = new ArrayList<int[]>(facs.values());
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
			System.out.println("added factor table "+kk);
			out.println();
		}
		out.close();
	}
}

/* Java script to generate UAI Files with unary and pairwise factors to be used for distributed dual decomposition.
 * Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
 * Virginia Polytechnic Institute and State University, 2013. */
import java.io.*;
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
			cards[i]=10;
			out.print(cards[i]+" ");
		}
		out.println();
		
		int nEdge = Integer.parseInt(args[2]);
		long tot = nVars + ((nVars-100)*nEdge);
		out.println(tot);

		long actual=0;
		for(int i=0;i<nVars;i++){
			out.println("1 "+i);
			actual++;
			System.out.println("adding unary preamble "+i);
		}
		
		for(long k=0;k<nVars-100;k++){
			long index=k+1;
			for(long l=0;l<nEdge;l++) {
				long other_vertex = index +(int)((nVars-index)*(Math.random()*0.5));
				out.println("2 "+k+" "+other_vertex);
				System.out.println("adding binary preamble "+l+" of "+k);
				index=other_vertex;
				actual++;
			}
		}
		System.out.println(actual);
		
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
			System.out.println("adding unary function table "+i);
			actual--;
		}
		
		for(long kk=0;kk<nVars-100;kk++) {
			for(int k=0;k<nEdge;k++){
				out.println(100);
				for(int ck=0;ck<10;ck++){
					float sum=0;
					for(int l=0;l<9;l++){
						float tr = (float) (Math.random()*(1-sum));						
						sum+=tr;
						out.print(tr+" ");
					}
					out.println(1-sum);
				}
				actual--;
				out.println();
			}
			System.out.println("added factor table "+kk);
		}
		out.println();
		System.out.println(actual);
		out.close();
	}
}
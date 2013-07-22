/* Java script to generate UAI Files with unary and pairwise factors to be used for distributed dual decomposition.
 * Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
 * Virginia Polytechnic Institute and State University, 2013. */
import java.io.*;
public class UAIFileGenerator {
	public static void main(String args[])throws IOException{
		PrintWriter out = new PrintWriter(args[0]);
		PrintWriter outtable = new PrintWriter(args[0].concat("table.uai"));
		//Destination for output file.
		out.println("MARKOV");
		int nVars = Integer.parseInt(args[1]);
		//number of variables in UAI.<Edit>
		out.println(nVars);
		int cards[] = new int[nVars];
		for(int i=0;i<nVars;i++){
			cards[i]=10;
			out.print(cards[i]+" ");
		}
		out.println();
		
		long tot = nVars + Long.parseLong(args[2]);
		out.println(tot);
		
		for(int i=0;i<nVars;i++){
			out.println("1 "+i);
			outtable.println(cards[i]);float sum=0;
			for(int j=0;j<cards[i]-1;j++){
				float tr = (float) (Math.random()*(1-sum));
				sum+=tr;
				outtable.print(tr+" ");	
			}
			outtable.println(1-sum+"\n");
		}
		
		int faclimit = Integer.parseInt(args[2]);
		for(int k=0;k<faclimit-100;k++){
			int[] factors = new int[10];
			int lim=k+1;
			for(int i=0;i<10;i++) {
				factors[i]=(int)(Math.random()*(faclimit-lim)*(0.5)+lim);
				lim=factors[i]+1;
				out.println("2 "+k+" "+factors[i]);
				outtable.println("100");
				for(int ck=0;ck<10;ck++){
					float sum=0;
					for(int l=0;l<10;l++){
						float tr = (float) (Math.random()*(1-sum));						
						sum+=tr;
						outtable.print(tr+" ");
					}
					outtable.println(1-sum);
				}
				System.out.println("added factor table "+i+" for "+k);
				outtable.println();
			}
		}
		
		out.println();
		out.close();
		outtable.close();
	}
}

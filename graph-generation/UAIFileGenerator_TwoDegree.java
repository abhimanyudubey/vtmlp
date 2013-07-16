/* Java script to generate UAI Files with only 2-Degree and 1-Degree cliques to be used for distributed dual decomposition.
 * Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
 * Virginia Polytechnic Institute and State University, 2013. */
import java.io.*;
public class UAIFileGenerator_TwoDegree {
	public static void main(String args[])throws IOException{
		PrintWriter out = new PrintWriter(args[0]);
		//Destination for output file.
		out.println("MARKOV");
		int nVars = 1500;
		//number of variables in UAI.<Edit>
		out.println(nVars);
		int cardLimit = 8;
		//maximum cardinality for any variable present.
		int cards[] = new int[nVars];
		for(int i=0;i<nVars;i++){
			cards[i]=(int) (2+Math.random()*(cardLimit-2));
			out.print(cards[i]+" ");
		}
		out.println();
		int maxDegree = 2;
		//This code generates only 1 degree and 2 degree cliques.
		long nCliques = 0, temp=0;
		double tempsum=1;
		while(temp<maxDegree){
			tempsum/=(temp+1);
			tempsum*=(nVars-temp);
			nCliques+= tempsum;
			temp++;
		}
		//Generated maxCliques.
		out.println(nCliques);
		for(int i=0;i<nVars;i++){
			out.println("1 "+i);
		}
		for(int i=0;i<nVars;i++){
			for(int j=i+1;j<nVars;j++){
				out.println("2 "+i+" "+j);
			}
		}
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
		for(int i=0;i<nVars;i++){
			for(int j=i+1;j<nVars;j++){
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
		}
		out.close();
	}
}
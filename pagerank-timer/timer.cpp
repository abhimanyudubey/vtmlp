//Pagerank Timer App, written in CPP using GraphLab API to measure parallelization extent in a distributed environment.
//Written by Abhimanyu Dubey for Dr. Batra's Machine Learning and Perception Laboratory.
//Virginia Polytechnic Institute and State University, 2013.

#include <graphlab.hpp>
#include <time.h>
#include <sys/resource.h>
#include <string>
#include <getopt.h>
struct Options 
{
    int maxiter;
    // Default values
    Options():
    maxiter(10)
    {}
};

Options opts;

struct nodedata {
		float timevalue;
		float pagerank;
		nodedata():timevalue(0.0),pagerank(0.0) {}
		
		void save(graphlab::oarchive& oarc) const {
      			oarc << timevalue << pagerank;
    		}
    		void load(graphlab::iarchive& iarc) {
     			iarc >> timevalue >> pagerank;
    		}
	};

typedef graphlab::distributed_graph<nodedata, graphlab::empty> graph_type;

float GLOBAL_TOTAL;
//Stores the sum of all times globally.

bool line_parser(graph_type& graph, const std::string& filename, const std::string& textline){
	std::stringstream strm(textline);
	graphlab::vertex_id_type vid;
	strm >> vid;
	graph.add_vertex(vid, nodedata());
	
	while(1){
		graphlab::vertex_id_type other_vertex;
		strm >> other_vertex;
		if ( strm.fail()) break;
		graph.add_edge(vid, other_vertex);
	}
}

//The main vertex program.
class node_program: public graphlab::ivertex_program<graph_type, float>, public graphlab::IS_POD_TYPE {
	private:
	bool perform_scatter;
	
	public:
	edge_dir_type gather_edges(icontext_type& context, const vertex_type& vertex) const {
    		return graphlab::IN_EDGES;
	}
	float gather(icontext_type& context, const vertex_type& vertex, edge_type& edge) const {
    		return edge.source().data().pagerank / edge.source().num_out_edges();
 	}  
 	void apply(icontext_type& context, vertex_type& vertex, const gather_type& total) {
 		struct timeval tim;
 		//The struct which will contain the time data from getrusage()
 		struct rusage ru;
 		//The struct which will get the resource usage from getrusage()
 		
    		float newval = total * 0.85 + 0.15;
   			float prevval = vertex.data().pagerank;
    		vertex.data().pagerank = newval;
    		perform_scatter = (context.iteration()<opts.maxiter);
    		
    		getrusage(RUSAGE_SELF, &ru);
    		tim = ru.ru_stime;
    		// ru_stime returns the system CPU time used.
    		
    		vertex.data().timevalue = (float)tim.tv_sec * 1000000.0 + (float)tim.tv_usec;
    		//std::cout << vertex.data().timevalue <<"\n";
    		//Storing and displaying the time used for the distributed mode. For parallel mode, the program will call multiple threadS,
    		//so will have to replace RUSAGE_SELF by RUSAGE_THREAD.
  	}
  	edge_dir_type scatter_edges(icontext_type& context, const vertex_type& vertex) const {
    		if (perform_scatter) return graphlab::OUT_EDGES;
    		else return graphlab::NO_EDGES;
  	}
	void scatter(icontext_type& context, const vertex_type& vertex,edge_type& edge) const {
    		context.signal(edge.target());
  	}
};

int main(int argc, char** argv) {
    global_logger().set_log_level(LOG_INFO);
    global_logger().set_log_to_console(true);
	graphlab::mpi_tools::init(argc, argv);
	graphlab::distributed_control dc;
	
	const std::string des = "PageRank";
	graphlab::command_line_options clopts(des);
    clopts.attach_option("maxiter", opts.maxiter,
                         "The maximum no. of DD iterations.");
	
	graph_type graph (dc, clopts);
	graph.load("input.txt", line_parser);
	
    if(!clopts.parse(argc, argv)) 
    {
        return clopts.is_set("help")? EXIT_SUCCESS : EXIT_FAILURE;
    }
    
	graphlab::mpi_tools::finalize();
	graphlab::omni_engine<node_program> engine(dc, graph, "sync", clopts);
  	engine.signal_all();
  	engine.start();
  	//engine.add_vertex_aggregator<float>("time_sum", get_node_time, print_time);
  	//engine.aggregate_periodic("time_sum", 2);
}
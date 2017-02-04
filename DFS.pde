import java.util.HashMap;
public Graph getDFS(Graph graph, Vertex a){
    HashMap<Vertex, Boolean> visitedMap = new HashMap<Vertex, Boolean>();
    for(Vertex v : graph.getVertexSet())
      visitedMap.put(v, false);
    visitedMap.put(a, true); //mark vertex as visited
    Graph dfs= getSubGraphDFS(a, graph, visitedMap);
    if(dfs != null && dfs.getVertexSet().size() == graph.getVertexSet().size())
      return dfs;
    return null; //failed to generate graph
  }
  
  public Graph getSubGraphDFS(Vertex root, Graph graph, HashMap<Vertex, Boolean> visitedMap){
  
    Graph dfs = new Graph();
    
    for(Edge e: graph.getAdjacentEdges(root)){ //for each adjacent edge
       if(!visitedMap.get(e.getDest())){ //if dest is not visited
         visitedMap.put(e.getDest(), true); //mark vertex as visited
         dfs.addGraph(getSubGraphDFS(e.getDest(),graph, visitedMap)) ;  //add to traversal queue
         dfs.addEdge(e.getSource(),e.getDest(),e.getWeight());   
        }
      }
     return dfs;

  }
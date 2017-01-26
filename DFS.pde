import java.util.HashMap;
public UndirectedGraph getDFS(UndirectedGraph graph, Vertex a){
    HashMap<Vertex, Boolean> visitedMap = new HashMap<Vertex, Boolean>();
    for(Vertex v : graph.getVertexSet())
      visitedMap.put(v, false);
    visitedMap.put(a, true); //mark vertex as visited
    UndirectedGraph dfs= getSubGraphDFS(a, graph, visitedMap);
    if(dfs != null && dfs.getVertexSet().size() == graph.getVertexSet().size())
      return dfs;
    return null; //failed to generate graph
  }
  
  public UndirectedGraph getSubGraphDFS(Vertex root, UndirectedGraph graph, HashMap<Vertex, Boolean> visitedMap){
  
    UndirectedGraph bfs = new UndirectedGraph();
    
    for(Edge e: graph.getAdjacentEdges(root)){ //for each adjacent edge
       if(!visitedMap.get(e.getDest())){ //if dest is not visited
         visitedMap.put(e.getDest(), true); //mark vertex as visited
         bfs.addGraph(getSubGraphDFS(e.getDest(),graph, visitedMap)) ;  //add to traversal queue
         bfs.addEdge(e.getSource(),e.getDest(),e.getWeight());   
        }
      }
    return bfs;
  }
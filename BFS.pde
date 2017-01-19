public UndirectedGraph getBFS(UndirectedGraph graph, Vertex a){
    UndirectedGraph bfs = new UndirectedGraph();
    HashMap<Vertex, Boolean> visitedMap = new HashMap<Vertex, Boolean>();
    Set<HashMap.Entry<Vertex,TreeSet<Edge>>> entrySet =graph.entrySet();
    for(HashMap.Entry<Vertex,TreeSet<Edge>> entry : entrySet)
      visitedMap.put(entry.getKey(), false);
    LinkedList<Vertex> q = new LinkedList<Vertex>();
    q.add(a); //visit a
    visitedMap.put(a, true);
    while(!q.isEmpty()){
      Vertex c = q.getLast();
      q.removeLast();
      for(Edge e: graph.getAdjacentEdges(c)){ //for each adjacent edge
       if(!visitedMap.get(e.getDest())){ //if dest is not visited
         visitedMap.put(e.getDest(), true); //mark vertex as visited
         q.addFirst(e.getDest());  //add to traversal queue
         bfs.addEdge(e.getSource(),e.getDest(),e.weight);   
        }
       }
      } 
    return bfs;
  }
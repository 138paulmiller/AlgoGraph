    
public HashMap<Vertex,UndirectedGraph> getShortestPaths(UndirectedGraph graph, Vertex initial){
  HashMap<Vertex,UndirectedGraph>  paths = new HashMap<Vertex, UndirectedGraph>();
  TreeSet<Vertex> q = new TreeSet<Vertex>();
  HashMap<Vertex, Integer> dist = new HashMap<Vertex, Integer>();;
  HashMap<Vertex, Edge> prev  = new HashMap<Vertex, Edge>(); //previous vertex for vertex's shortest path,
  for(Vertex v : graph.getVertexSet()){ //adds vertices in graphs given vertex order
    dist.put(v,Integer.MAX_VALUE-1);
    prev.put(v,null);
    q.add(v);
  }//for each vertex
  dist.put(initial, 0);
  print("\nInitializeded structures ");

  while(!q.isEmpty()){
    //fin min vertex, if equal the first vertex to have lowest is assigned as min
    Vertex min = null;
    for(Vertex v : q){
      if(min == null) min=v;
      int diff = dist.get(v) - dist.get(min);
        if(diff < 0)
          min = v; //assign new min
    }
    //u is min
    q.remove(min); //remove meaning visited
    for(Edge edge : graph.getAdjacentEdges(min)){
      int newDist = dist.get(min) + edge.getWeight(); //get distance from u to v
      if(newDist < dist.get(edge.getDest())){ //if new distance is smaller than current distance to v
          dist.put(edge.getDest(), newDist);
          prev.put(edge.getDest(),edge);
      }
    }//end for adjacent edges              
  }//end while q ! empty
  for(HashMap.Entry entry : dist.entrySet()){ //for each vertex
    print("\nVertex : " + ((Vertex)entry.getKey()).getText() + " Dist: " + dist.get((Vertex)entry.getKey()) + " - " );
    paths.put((Vertex)entry.getKey(), new UndirectedGraph());
    Vertex a = (Vertex)entry.getKey();
    Edge e = prev.get(a);
    while(e != null){
      print("  " + e.getSource().getText());
      paths.get((Vertex)entry.getKey()).addEdge(e.getSource(), e.getDest(), e.getWeight());
      e = prev.get(e.getSource());
    }
  }
  return paths;
}

public UndirectedGraph getShortestPath(UndirectedGraph graph,Vertex start, Vertex end){
  return getShortestPaths(graph, start).get(end);
 
}
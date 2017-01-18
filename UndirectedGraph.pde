import java.util.LinkedList;
import java.util.LinkedList;
class UndirectedGraph{
  public UndirectedGraph(){
    edgeSet = new LinkedList<Edge>();
    vertexSet = new LinkedList<Vertex>();
  }
  public void addVertex(Vertex a){
     if(!vertexSet.contains(a))
       vertexSet.add(a);
  }
  public void addEdge(Vertex a,Vertex b, float weight){
   Edge e = new Edge(a,b,weight);
    if(!edgeSet.contains(e)){
      addVertex(a);
      a.addNeighbor(b);
      addVertex(b);
      b.addNeighbor(a);
      edgeSet.add(e);
    }
  }
  public Edge getEdge(Vertex a,Vertex b){
   for(Edge e : edgeSet){
    if((e.a == a && e.b == b) || (e.b == a && e.a == b) ){
      return e;
    }
   }
   return null;
  }
  public void draw(){
     
     for(Edge e : edgeSet)
       e.draw();
     for(Vertex v : vertexSet)
       v.draw();
     
  }
  public LinkedList<Vertex> getVertexSet(){
    return vertexSet;
  }
  public UndirectedGraph getBFS(){
    Vertex a = vertexSet.getFirst();
    UndirectedGraph bfs = new UndirectedGraph();
    HashMap<Vertex, Boolean> visitedMap = new HashMap<Vertex, Boolean>();
    for(Vertex v : vertexSet)
      visitedMap.put(v, false);
    LinkedList<Vertex> q = new LinkedList<Vertex>();
    q.add(a); //visit a
    visitedMap.put(a, true);
    while(!q.isEmpty()){
      Vertex c = q.getLast();
      q.removeLast();
      for(Vertex n: c.getNeighbors()){ //for each neighbor
       if(!visitedMap.get(n)){ //if not visited
         visitedMap.put(n, true); //mark vertex as visited
         q.addFirst(n);  //add to traversal queue
         Edge e = getEdge(c,n);
         if(e != null)
                bfs.addEdge(e.a,e.b,e.weight);
         else
           print("BFS: Error finding Edge for (Vertex,Neighbor");
       }
      } 
    }
    return bfs;
  }
  LinkedList<Edge> edgeSet;
  LinkedList<Vertex> vertexSet;
}
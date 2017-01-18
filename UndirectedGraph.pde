import java.util.Set;
import java.util.LinkedList;
import java.util.TreeSet;
class UndirectedGraph{
  public UndirectedGraph(){
    edgeMap = new HashMap<Vertex,TreeSet<Edge>> ();
  }
  public void addVertex(Vertex a){
     if(!edgeMap.containsKey(a)){
       edgeMap.put(a, new TreeSet<Edge>());
     }
  }
  public void addEdge(Vertex source,Vertex dest, int weight){
   Edge e = new Edge(source,dest,weight);
   Edge eComp = new Edge(dest, source,weight);
   addVertex(source);      
    addVertex(dest);//tries to add if not in
    if(!edgeMap.get(source).contains(e) && !edgeMap.get(dest).contains(e)){
      edgeMap.get(source).add(e);
      edgeMap.get(dest).add(eComp);

    }
  }
  
  public void draw(){
     
    for(HashMap.Entry<Vertex,TreeSet<Edge>> entry : edgeMap.entrySet()){
      TreeSet<Edge> adjacentEdges  = entry.getValue();
     for(Edge e : adjacentEdges){
       e.draw();
     }
    }
    for(Vertex v: getVertexSet())
      v.draw();
  }
  public Set<Vertex> getVertexSet(){
   return edgeMap.keySet(); 
  }
  public Set<HashMap.Entry<Vertex,TreeSet<Edge>>> entrySet(){
    return edgeMap.entrySet();
  }
  public TreeSet<Edge> getAdjacentEdges(Vertex v){
     TreeSet<Edge> set = edgeMap.get(v); 
     return set;
  }
  HashMap<Vertex,TreeSet<Edge>> edgeMap;
}
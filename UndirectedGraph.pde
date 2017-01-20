import java.util.Set;
import java.util.LinkedList;
import java.util.TreeSet;
import java.util.Collections;

class UndirectedGraph{
  public UndirectedGraph(){
    edgeMap = new HashMap<Vertex,TreeSet<Edge>> ();
  }
  public UndirectedGraph(UndirectedGraph other){
    edgeMap = other.edgeMap;
  }
  public void addVertex(Vertex a){
     if(!edgeMap.containsKey(a)){
       edgeMap.put(a, new TreeSet<Edge>());
     }
  }
  public void addGraph(UndirectedGraph graph){
    edgeMap.putAll(graph.edgeMap);
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
     for(Edge e :  entry.getValue()){
       e.draw();
     }
    }
    for(Vertex v: getVertexSet())
      v.draw();
  }
  public ArrayList<Vertex> getVertexSet(){
    ArrayList<Vertex> sortList=  new ArrayList(edgeMap.keySet());
    Collections.sort(sortList);
    return sortList;
  }
  
  public ArrayList<Edge> getAdjacentEdges(Vertex v){
     ArrayList<Edge> sortList = new ArrayList<Edge>(edgeMap.get(v)); 
     Collections.sort(sortList);
     return sortList;
  }
  public void clear(){
     edgeMap.clear(); 
  }
  HashMap<Vertex,TreeSet<Edge>> edgeMap;
}
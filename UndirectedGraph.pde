import java.util.Set;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.TreeSet;
import java.util.Collections;

class UndirectedGraph{
  public UndirectedGraph(){
    edgeMap = new HashMap<Vertex,TreeSet<Edge>> ();
    drawVertices = drawEdges = true;
  }
  public UndirectedGraph(UndirectedGraph other){
    edgeMap = other.edgeMap;
    drawVertices = other.drawVertices;
        drawEdges = other.drawEdges;

    
  }
  public void addVertex(Vertex a){
     if(a != null && !edgeMap.containsKey(a)){
       edgeMap.put(a, new TreeSet<Edge>());
     }
  }
  public void addGraph(UndirectedGraph graph){
    edgeMap.putAll(graph.edgeMap);
  }
  public void addEdge(Vertex source,Vertex dest, int weight){
    if(source == null && dest == null) return;
   Edge e = new Edge(source,dest,weight);
   Edge eComp = new Edge(dest, source,weight);
   addVertex(source);      
    addVertex(dest);//tries to add if not in
    if(!edgeMap.get(source).contains(e) && !edgeMap.get(dest).contains(e)){
      edgeMap.get(source).add(e);
      edgeMap.get(dest).add(eComp);

    }
  }
  public void setDrawVertices(boolean drawVertices){
    this.drawVertices = drawVertices;
  }
  public void setDrawEdges(boolean drawEdges){
    this.drawEdges = drawEdges;
  }
  public void setHighlightEdges(boolean isHighlighted){
   for(Edge e:getEdgeSet())
     e.setHighlight(isHighlighted);
  }
  public void setHighlightVertices(boolean isHighlighted){
   for(Vertex v: getVertexSet())
     v.setHighlight(isHighlighted);
  }
  public Vertex getVertex(String id){
    for(Vertex v: getVertexSet()){
     if(String.valueOf(v.getID()) == id)
       return v;
    }
    return null;
  }
  public void draw(){
     
    if(drawEdges)
       for(Edge e : getEdgeSet())
         e.draw();

    if(drawVertices)
      for(Vertex v: getVertexSet())
        v.draw();
  }
  public ArrayList<Vertex> getVertexSet(){
    ArrayList<Vertex> sortList=  new ArrayList(edgeMap.keySet());
    Collections.sort(sortList);
    return sortList;
  }
  public Edge getEdge(Vertex source, Vertex dest){
    TreeSet<Edge> edgeSet = edgeMap.get(source);
    boolean found = false;
    Edge e  = null;
    Iterator it = edgeSet.iterator();
    while(it.hasNext() && !found){
      e= (Edge)it.next();
      if(e.getSource() == source && e.getDest() == dest){
        found  =true;
      } 
    }
    if(found)
    return e;
    else  
    return null;
  }
  public void updateEdgeWeight(Vertex source, Vertex dest, int weight){
    TreeSet<Edge>sourceEdgeSet = edgeMap.get(source);
    TreeSet<Edge>destEdgeSet = edgeMap.get(dest);

    boolean found = false;
    Edge e = null;
    Iterator it = sourceEdgeSet.iterator();
    while(it.hasNext() && !found){
      e= (Edge)it.next();
      if(e.getDest() == dest){
          e.setWeight(weight);
          found = true;
      }
    }
    found = false;
    //update destinations edges
    it = destEdgeSet.iterator();
    while(it.hasNext() && !found){
      e= (Edge)it.next();
      if(e.getDest() == source){
          e.setWeight(weight);
          found = true;
      }
    }
  }
  public ArrayList<Edge> getAdjacentEdges(Vertex v){
     ArrayList<Edge> sortList = new ArrayList<Edge>(edgeMap.get(v)); 
     Collections.sort(sortList);
     return sortList;
  }
  public ArrayList<Edge> getEdgeSet(){
    ArrayList<Edge> sortList = new ArrayList<Edge>();
    for(Vertex v : getVertexSet())
     sortList.addAll(edgeMap.get(v)); 
   Collections.sort(sortList);
   return sortList;
  }
  public void clear(){
     edgeMap.clear(); 
  }
  HashMap<Vertex,TreeSet<Edge>> edgeMap;
  boolean drawVertices, drawEdges;
}
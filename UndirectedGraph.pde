import java.util.Set;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.TreeSet;
import java.util.Collections;

class UndirectedGraph{
  public UndirectedGraph(){
    vertexAdjacencyMap = new HashMap<Vertex,TreeSet<Edge>> ();
    drawVertices = drawEdges = true;
  }
  public UndirectedGraph(UndirectedGraph other){
    vertexAdjacencyMap = other.vertexAdjacencyMap;
    drawVertices = other.drawVertices;
        drawEdges = other.drawEdges;

    
  }
  public void addVertex(Vertex a){
     if(a != null && !vertexAdjacencyMap.containsKey(a)){
       vertexAdjacencyMap.put(a, new TreeSet<Edge>());
     }
  }
  public void addGraph(UndirectedGraph graph){
    vertexAdjacencyMap.putAll(graph.vertexAdjacencyMap);
  }
  public void addEdge(Vertex source,Vertex dest, int weight){
    if(source == null && dest == null) return;
   Edge e = new Edge(source,dest,weight);
   Edge eComp = new Edge(dest, source,weight);
   addVertex(source);      
    addVertex(dest);//tries to add if not in
    if(!vertexAdjacencyMap.get(source).contains(e) && !vertexAdjacencyMap.get(dest).contains(e)){
      vertexAdjacencyMap.get(source).add(e);
      vertexAdjacencyMap.get(dest).add(eComp);

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
  public void drawEdges(){
     
    if(drawEdges)
       for(Edge e : getEdgeSet())
         e.draw();
  }
  public void drawVertices(){

    if(drawVertices)
      for(Vertex v: getVertexSet())
        v.draw();
  }
  public ArrayList<Vertex> getVertexSet(){
    ArrayList<Vertex> sortList=  new ArrayList(vertexAdjacencyMap.keySet());
    Collections.sort(sortList);
    return sortList;
  }
  public Edge getEdge(Vertex source, Vertex dest){
    TreeSet<Edge> edgeSet = vertexAdjacencyMap.get(source);
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
    TreeSet<Edge>sourceEdgeSet = vertexAdjacencyMap.get(source);
    TreeSet<Edge>destEdgeSet = vertexAdjacencyMap.get(dest);

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
     ArrayList<Edge> sortList = new ArrayList<Edge>(vertexAdjacencyMap.get(v)); 
     Collections.sort(sortList);
     return sortList;
  }
  public ArrayList<Edge> getEdgeSet(){
    ArrayList<Edge> sortList = new ArrayList<Edge>();
    for(Vertex v : getVertexSet())
     sortList.addAll(vertexAdjacencyMap.get(v)); 
   Collections.sort(sortList);
   return sortList;
  }
  public void clear(){
     vertexAdjacencyMap.clear(); 
  }
  HashMap<Vertex,TreeSet<Edge>> vertexAdjacencyMap;
  boolean drawVertices, drawEdges;
}
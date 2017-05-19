import java.util.Set;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.TreeSet;
import java.util.Collections;

class Graph{
  public Graph(){
    vertexAdjacencyMap = new HashMap<Vertex,TreeSet<Edge>> ();
    drawVertices = drawEdges = true;
    directed = false; 
    weighted = true;
  }
  public Graph(Graph other){
    vertexAdjacencyMap = other.vertexAdjacencyMap;
    drawVertices = other.drawVertices;
    drawEdges = other.drawEdges;
    weighted = other.weighted;
    directed = other.directed;
    setLabelInterface(other.labelInterface);

  }
  public void addVertex(Vertex a){
     if(a != null && !vertexAdjacencyMap.containsKey(a)){
       if(labelInterface!= null)a.setInterface(labelInterface); 
       vertexAdjacencyMap.put(a, new TreeSet<Edge>());
     }
  }
  public void addGraph(Graph graph){
    vertexAdjacencyMap.putAll(graph.vertexAdjacencyMap);
  }
  public void addEdge(Vertex source,Vertex dest, int weight){
   Edge e = getEdge(source, dest);
   Edge eComp = getEdge(dest, source);
   addVertex(source);      
    addVertex(dest);//tries to add if not in
    if(!directed){
      if((e != null && eComp != null)){
        //update
          e.setWeight(weight);
          eComp.setWeight(weight);
      }else{
        e =  new Edge(source,dest,weight);
        eComp =  new Edge(dest, source,weight);
        e.setInterface(labelInterface);
        eComp.setInterface(labelInterface);
        vertexAdjacencyMap.get(source).add(e);
        vertexAdjacencyMap.get(dest).add(eComp);
      }
    }
  }
  public void setDrawVertices(boolean drawVertices){
    this.drawVertices = drawVertices;
  }
  public void setDrawEdges(boolean drawEdges){
    this.drawEdges = drawEdges;
  }
  public void setWeighted(boolean isWeighted){
    this.weighted = isWeighted;
  }
  public void setDirected(boolean isDirected){
    this.directed = isDirected;
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
  public boolean isDrawVertices()
  {
    return drawVertices;
  }
  public boolean isDrawEdges()
  {
    return drawEdges;
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
  public int getVertexCount(){
      return (new ArrayList(vertexAdjacencyMap.keySet())).size();

  }
  public Edge getEdge(Vertex source, Vertex dest){
    if(source == null || dest == null) return null;
    TreeSet<Edge> edgeSet = vertexAdjacencyMap.get(source);
    if(edgeSet == null) return null;
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
  public void setLabelInterface( LabelInterface labelInterface){
    if(labelInterface != null){
     this.labelInterface = labelInterface;
      for(Edge e: getEdgeSet())
        e.setInterface(labelInterface); 
      for(Vertex v: getVertexSet())
        v.setInterface(labelInterface); 
    }
 }
 public LabelInterface getInterface(){
   return labelInterface;
 }
  LabelInterface labelInterface;
  HashMap<Vertex,TreeSet<Edge>> vertexAdjacencyMap;
  boolean drawVertices, drawEdges;
  boolean directed, weighted;
}
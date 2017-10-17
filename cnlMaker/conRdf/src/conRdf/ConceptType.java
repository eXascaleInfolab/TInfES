package conRdf;

import java.util.ArrayList;

public class ConceptType {
	public int typeId;
	
	public String typeName;
	
	public ArrayList<Integer> instanceIds;
	
	public ConceptType(int id, String name)
	{
		this.typeId = id;
		
		this.typeName = name;
		
		this.instanceIds = new ArrayList<Integer>();
	}
}

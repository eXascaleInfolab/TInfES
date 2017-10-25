package conRdf;
import java.io.Serializable;
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 *
 * @author kenza Kellou-Menouer
 */

public class Instance implements Serializable {
	public int instanceIds;
    public String  instanceNames;
//    public String rdfTypes ;
    public ArrayList<String> typeNames;
   // public ArrayList<AbstractMap.SimpleEntry<String, String>> typeValues;
    
    
    public  Instance(int instanceIds, String instanceNames, String typeNames) {
    	this.instanceIds=instanceIds;
    	this.instanceNames=instanceNames;
    	//this.typeValues = new ArrayList<AbstractMap.SimpleEntry<String, String>>();
    	//this.typeValues.add(new AbstractMap.SimpleEntry<String, String>(rdfTypes, typeNames));
    	//this.rdfTypes=rdfTypes;
    	this.typeNames = new ArrayList<String>();
    	this.typeNames.add(typeNames);
    	//this.typeNames=typeNames;
		
	}
    
   

	public int getIds(){
    	return instanceIds;
    }

    public String getInstanceNames(){
    	return instanceNames;
    }
    
//    public String getRdfTypes(){
//    	return rdfTypes;
//    }
//    
//    public String getTypeNames(){
//    	return typeNames;
//    }
    
    }
    
   
    
    


package conRdf;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.List;

import conRdf.Instance;
import conRdf.Partition;

public class main {
	public static Partition partition=new Partition();
    public static void main(String[] args) throws IOException {
FileExits();
System.out.println(partition.listObjets.get(0).instanceIds);
createRdfN4("./EnumeratedData.txt");
createTypesFile("./types.txt");
createTypeIds("./Ids.txt");
createIdUri("./Idsuris.txt");
System.out.println(partition.listObjets);
System.out.println("Done!");

}
    
    
    //Read the N3Dataset file, then filter all the triples if the have <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> or not
    //afterwards It saves all the Instances in partition.Objects and all the types in listTypes
public static void readDataSet(String N3DataSet) throws IOException {
	
	int id =0 ;
	int maxId = -1;
	int typeId = 0;
	ArrayList<Instance> instances = new ArrayList<Instance>();
	ArrayList<ConceptType> listTypes = new ArrayList<ConceptType>();

	String[] data = readLines(N3DataSet);
	
	for (String line : data){
		String[] s = line.split(" ");
		
		if (s.length<3) continue;
		if (!s[1].contains("<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>")) continue;
		
		int typeIndex = -1;
		
		for (ConceptType type : listTypes)
		{
			if (type.typeName.trim().contains(s[2].trim()))
			{
				typeIndex = listTypes.indexOf(type);

				break;
			}
		}
		
		if (typeIndex == -1) 
		{
			ConceptType newType =new ConceptType(++typeId, s[2]); 
			listTypes.add(newType);
			typeIndex = listTypes.indexOf(newType);
			
		}

		id = -1;
		int index = -1;
		for(Instance tempInstance : instances)
		{
			if (tempInstance.instanceNames.trim().contains(s[0].trim()))
			{
				id = tempInstance.instanceIds;
				index = instances.indexOf(tempInstance);

				break;
			}
		}
		

		if (id>=0)
		{				

		Instance tempInstance = instances.get(index);
		
		tempInstance.typeNames.add(s[2]);
		
		instances.set(index, tempInstance);
		}
		else if (id ==-1 ) 
		{	

			id = ++maxId;
			instances.add(new Instance(id, s[0], s[2]));


		}
		
	    ConceptType tempType = listTypes.get(typeIndex);
	    
	    tempType.instanceIds.add(id);
	    
	    listTypes.set(typeIndex, tempType);
		
	}
	
	partition.listObjets = instances;
	
	partition.listTypes = listTypes;
}
    

//Take the list of Object that we have from previous step and Enumurate and write them in EnumeratedData.txt
public static void createRdfN4(String path) throws IOException {
        
        
	  FileWriter fw = new FileWriter(path, true);
	    try (BufferedWriter output = new BufferedWriter(fw)) {
	    		    	

	    	
	    	
	    	String ligne = "";
	    	       
	    	for(Instance instance : partition.listObjets)
	    	{
	    		for(String type : instance.typeNames)
	    		{
		    		int i = partition.listObjets.indexOf(instance);
		    		int j = instance.typeNames.indexOf(type);
		    		ligne =  (i>0 || j>0?"\n":"")+ instance.instanceIds+" "+instance.instanceNames;
		    		ligne += " " +"<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>" + " " + type ;
		            output.write(ligne, 0, ligne.length());

	    		}
	    	}
	          
	        output.flush();
	    }
	       
	   
	   
	   }

public static void createIdUri(String path) throws IOException {
    
    
	  FileWriter fw = new FileWriter(path, true);
	    try (BufferedWriter output = new BufferedWriter(fw)) {
	    		    	

	    	
	    	
	    	String ligne = "";
	    	       
	    	for(Instance instance : partition.listObjets)
	    	{
		    		int i = partition.listObjets.indexOf(instance);
		    		ligne =  (i>0?"\n":"")+ instance.instanceIds+" "+instance.instanceNames;
		            output.write(ligne, 0, ligne.length());

	    		
	    	}
	          
	        output.flush();
	    }
	       
	   
	   
	   }


//The Name of the Types exist in our Dataset. and Write them in Types.txt
public static void createTypesFile(String typesFile) throws IOException {
    
    
	  FileWriter fw = new FileWriter(typesFile, true);
	    try (BufferedWriter output = new BufferedWriter(fw)) {
	    		    		    	
	    	
	    	String ligne = "";
	    	       
	    	for(ConceptType type : partition.listTypes)
	    	{
		    		int i = partition.listTypes.indexOf(type);
		    		ligne =  (i>0?"\n":"")+ type.typeName;
		            output.write(ligne, 0, ligne.length());

	    		
	    	}
	          
	        output.flush();
	    }
	       
   
	   
   }


//Method to Group By the Instance Ids  and write them in Ids.txt
public static void createTypeIds(String instanceIds ) throws IOException {
    	       
		  FileWriter fwIds = new FileWriter(instanceIds, true);
		    try (BufferedWriter output = new BufferedWriter(fwIds)) {
		    		    		    	
		    	
		    	String ligne = "";
		    	       
		    	for(ConceptType type : partition.listTypes)
		    	{
			    		int i = partition.listTypes.indexOf(type);
			    		String ids = "";
			    		for(Integer id : type.instanceIds)
			    		{
			    			int idIndex = type.instanceIds.indexOf(id);
			    			ids += (idIndex == 0? "":" ") + id;
			    		}
			    		ligne =  (i>0?"\n":"")+ ids;
			            output.write(ligne, 0, ligne.length());

		    		
		    	}
		          
		        output.flush();
		    }	   
	   
 }

public static String[] readLines(String filename) throws IOException {
    FileReader fileReader = new FileReader(filename);
    BufferedReader bufferedReader = new BufferedReader(fileReader);
    List<String> lines = new ArrayList<String>();
    String line = null;
    while ((line = bufferedReader.readLine()) != null) {
        lines.add(line);
    }
    bufferedReader.close();
    return lines.toArray(new String[lines.size()]);
}



//Method to read the path of our input Dataset and also check if exits any output results from previous execution, it delete those files. 
public static void FileExits() throws IOException {
    
    
	String fileToDeleteEnumeratedData = "./EnumeratedData.txt";
	String fileToDeletetypes = "./types.txt";
	String fileToDeleteIds = "./Ids.txt";
	String fileToDeleteIdsuris = "./Idsuris.txt";

	File fileEnumeratedData=new File(fileToDeleteEnumeratedData);
	File filetypes=new File(fileToDeletetypes);
	File fileIds=new File(fileToDeleteIds);
	File fileIdsuris=new File(fileToDeleteIdsuris);

	if (fileEnumeratedData.exists()){
   fileEnumeratedData.delete();}
	
	if (filetypes.exists()){
		filetypes.delete();}
	
	if (fileIds.exists()){
		fileIds.delete();}
	
	if (fileIdsuris.exists()){
		fileIdsuris.delete();}
	
	
	//Reading the N3 Dataset Path
	    		 BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
	    	    System.out.print("Enter the PATH of your Dataset: ");
	    	        String dataPath = br.readLine();    	
	    	readDataSet(dataPath);
	    	
	    }
	   

}
	

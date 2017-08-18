package GTgenerator;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.ParseException;
import java.util.*;
import java.util.Map.Entry;





public class main {
	static TreeMap<String, InstancePropertiesIsTyped> instanceListPropertiesTreeMap = new TreeMap<String, InstancePropertiesIsTyped>();
	static TreeMap<String, List<Integer>> listOfTypes = new TreeMap<String, List<Integer>>();

	static int noTotalOccurances = 0; 
	public static void main(String[] args) throws Exception {
		
		 BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
 	     System.out.print("Enter the PATH of your First Dataset: ");
 	     String dataPath1 = br.readLine();    	
 	     readDataSet1(dataPath1);
		

	  }
	
	public static void readDataSet1(String N3DataSet) throws IOException {
	
    FileReader fileReader = new FileReader(N3DataSet);
    BufferedReader bufferedReader = new BufferedReader(fileReader);
    //List<String> lines = new ArrayList<String>();
    String line = null;
    int id=-1;
    while ((line = bufferedReader.readLine()) != null) {
        //lines.add(line);
		String[] s = line.split(" ");
		if (s.length<3) continue;
		String instancemapKey = s[0];
		String instanceTypeValue=s[2];
		List<Integer> typeIds = new ArrayList<Integer>();
		if (s[1].contains("<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>")) 
			{
				InstancePropertiesIsTyped instancePropertiesTypeName = null;
				if (instanceListPropertiesTreeMap.get(instancemapKey)== null){
					instancePropertiesTypeName = new InstancePropertiesIsTyped("", true,++id);
					if (listOfTypes.get(instanceTypeValue)==null)
					{
						typeIds.add(instancePropertiesTypeName.id);
						listOfTypes.put(instanceTypeValue, typeIds);
					}
					else if (listOfTypes.get(instanceTypeValue)!=null)
					{
						typeIds= listOfTypes.get(instanceTypeValue);
						typeIds.add(instancePropertiesTypeName.id);
						listOfTypes.put(instanceTypeValue, typeIds);

					}
				}
				else if (instanceListPropertiesTreeMap.get(instancemapKey)!=null)
				{
					instancePropertiesTypeName = instanceListPropertiesTreeMap.get(instancemapKey);
					
					instancePropertiesTypeName.isTyped = true;
					
					if (listOfTypes.get(instanceTypeValue)==null)
					{
						typeIds.add(instancePropertiesTypeName.id);
						listOfTypes.put(instanceTypeValue, typeIds);
					}
					else if (listOfTypes.get(instanceTypeValue)!=null)
					{
						typeIds= listOfTypes.get(instanceTypeValue);
						
						if (!typeIds.contains(instancePropertiesTypeName.id)) typeIds.add(instancePropertiesTypeName.id);
						listOfTypes.put(instanceTypeValue, typeIds);

					}
				}
				instanceListPropertiesTreeMap.put(instancemapKey,instancePropertiesTypeName);
				continue;
			}
		
		noTotalOccurances++;
		//insert to the instanceListProperties Treemap
		InstancePropertiesIsTyped instanceProperties = null;
		if (instanceListPropertiesTreeMap.get(instancemapKey)== null){
			instanceProperties = new InstancePropertiesIsTyped(s[1], false,++id);
		}
		else if (instanceListPropertiesTreeMap.get(instancemapKey)!=null)
		{
			instanceProperties = instanceListPropertiesTreeMap.get(instancemapKey);
			
			instanceProperties.propertySet.add(s[1]);
		}
		
		instanceListPropertiesTreeMap.put(instancemapKey,instanceProperties);
		
		    	
    }
    bufferedReader.close();
    System.out.println("listOfTypes = "+listOfTypes);
    FileWriter fw = new FileWriter("./GTids.txt", true);
	    BufferedWriter output = new BufferedWriter(fw);
	    List<Integer> idsPerType = new ArrayList<>();
	    String r ="";
	    
		Set<Map.Entry<String, List<Integer>>>entrySet = listOfTypes.entrySet();
		for (Entry<String, List<Integer>> typename: entrySet){
			r += r == ""? "" : "\n";
			idsPerType = typename.getValue();
			for (int i = 0; i<idsPerType.size(); i++) {
				r+= idsPerType.get(i) +" ";

		}
			//r += "\n";
		}
		
	    	output.write(r);
	    	output.flush();
	    	//C:\Users\rosha\OneDrive\Documents\db\museum

	
}
	


	
	//Readlines Function is used to read the input file line by line 
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
  
		
		
}

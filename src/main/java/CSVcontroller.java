import java.io.*;
import java.util.ArrayList;

class CSVController {

    ArrayList<String[]> records = new ArrayList();

    public CSVController(String fileName){
        readFile(fileName);
    }

    private void readFile(String fileName) {
        try (BufferedReader br = new BufferedReader(new FileReader(fileName))) {

            String sCurrentLine;
            while ((sCurrentLine = br.readLine()) != null) {
                String[] record =sCurrentLine.split(",");
                records.add(record);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void writeFile(String fileName) {
        File outputFile = new File(fileName);

        try {
            FileWriter writer = new FileWriter(outputFile);
            String line = "";
            for(String[] record : records) {
                for(int i = 0 ; i < record.length ; i ++){
                    line += record[i] + ",";
                }
                line = line.substring(0,line.length()-1);
                writer.write(line + "\n");
            }
            writer.close();
        } catch (IOException error) {
            System.out.println("Error while writing!");
        }
    }
}

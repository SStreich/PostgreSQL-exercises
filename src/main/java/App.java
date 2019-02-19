import java.sql.SQLException;
import java.util.ArrayList;

public class App {

    public static void main(String[] args) throws SQLException {
        CSVController csvController = new CSVController("src/main/resources/music-data-159680.csv");
        ArrayList<String[]> records = csvController.getRecords();
        NewRecord newRecord = new NewRecord();
        int i = 0;

        for (String[] record : records) {
             newRecord.addNewRecord(record[0], record[1], record[2], record[3], record[4]);
            System.out.println(i++);
        }

    }
}

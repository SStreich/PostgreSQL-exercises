import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DAO {
    Connection con = ConnectionProvider.getConnection();


    void addSong(String song, String artist) throws SQLException {
        ResultSet resultSet = getSongResultSet(song, artist);

        if (!checkIfResultExists(resultSet)) {
            PreparedStatement prepInsert = con.prepareStatement("INSERT INTO song(name, album) VALUES ('?' , '?')");
            prepInsert.setString(1, song);
            prepInsert.setString(2, artist);

            prepInsert.executeUpdate();

        }
    }


    void addAlbum(String album, String artist, String year) throws SQLException {
        ResultSet resultSet = getSongResultSet(album, artist);


        if (!checkIfResultExists(resultSet)) {
            PreparedStatement prepInsert = con.prepareStatement("INSERT INTO album(name, year) VALUES ('?', '?', '?')");
            prepInsert.setString(1, album);
            prepInsert.setString(2, artist);
            prepInsert.setString(3, year);

            prepInsert.executeUpdate();
        }
    }

    void addGenre(String genre) throws SQLException {
        ResultSet resultSet = getRecordResultSet("genre", genre);

        if (!checkIfResultExists(resultSet)) {

                PreparedStatement prepInsert = con.prepareStatement("INSERT INTO genre(name) VALUES ('?')");
            prepInsert.setString(1, genre);

            prepInsert.executeUpdate();
        }
    }

    void addArtist(String artist) throws SQLException {
        ResultSet resultSet = getRecordResultSet("artist", artist);

        if (!checkIfResultExists(resultSet)) {
            PreparedStatement prepInsert = con.prepareStatement("INSERT INTO artist(name) VALUES ('?')");
            prepInsert.setString(1, artist);

            prepInsert.executeUpdate();
        }
    }



    private ResultSet getSongResultSet(String song, String artist) throws SQLException {
        PreparedStatement prepSelect = con.prepareStatement("SELECT song.song_id FROM song" +
                "  INNER JOIN artist_song ON artist_song.song_id = song.song_id" +
                "  INNER JOIN artist ON artist_song.artist_id = artist.artist_id" +
                "  WHERE song.name = '?' AND artist.name = '?';");
        prepSelect.setString(1, song);
        prepSelect.setString(2, artist);

        return prepSelect.executeQuery();
    }

    private ResultSet getAlbumResultSet(String album, String artist) throws SQLException {
        PreparedStatement prepSelect = con.prepareStatement("SELECT album.album_id FROM album" +
                "  INNER JOIN artist_album ON artist_album.album_id = album.album_id" +
                "  INNER JOIN artist ON artist_album.artist_id = artist.artist_id" +
                "  WHERE album.name = '?' AND artist.name = '?';");
        prepSelect.setString(1, album);
        prepSelect.setString(2, artist);

        return prepSelect.executeQuery();
    }

    private ResultSet getRecordResultSet(String tableName, String name) throws SQLException {
        PreparedStatement prepSelect = con.prepareStatement("SELECT ?_id FROM ? WHERE name = '?'");

        prepSelect.setString(1, tableName);
        prepSelect.setString(2, name);

        return prepSelect.executeQuery();
    }


    private boolean checkIfResultExists(ResultSet resultSet) throws SQLException {
        return resultSet.next();
    }

}

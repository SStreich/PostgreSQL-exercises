import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DAO {
    private Connection con = ConnectionProvider.getConnection();

    void addSong(String song, String artist, int album_id) throws SQLException {
       // ResultSet resultSet = getSongResultSet(song, artist);

       // if (!checkIfResultExists(resultSet)) {

            PreparedStatement prepInsert = con.prepareStatement("INSERT INTO song(name, album_id) VALUES (? , ?)" +
                    "ON CONFLICT DO NOTHING");
            prepInsert.setString(1, song);
            prepInsert.setInt(2, album_id);

            prepInsert.executeUpdate();
        //}
    }

    void addToArtist_Song(int artist_id, int song_id) throws SQLException {

        PreparedStatement prepInsert = con.prepareStatement("INSERT INTO artist_song(artist_id, song_id) VALUES (? , ?)" +
                                                            "ON CONFLICT DO NOTHING");
        prepInsert.setInt(1, artist_id);
        prepInsert.setInt(2, song_id);

        prepInsert.executeUpdate();
    }


    void addAlbum(String album, String artist, String year) throws SQLException {
        ResultSet resultSet = getSongResultSet(album, artist);


        if (!checkIfResultExists(resultSet)) {

            PreparedStatement prepInsert = con.prepareStatement("INSERT INTO album(name, year) VALUES (?, ?)" +
                    "ON CONFLICT DO NOTHING");
            prepInsert.setString(1, album);
            prepInsert.setString(2, year);

            prepInsert.executeUpdate();
        }
    }

     void addToArtist_Album(int artist_id, int album_id) throws SQLException {
        PreparedStatement prepInsert = con.prepareStatement("INSERT INTO artist_album(artist_id, album_id) VALUES (? , ?) " +
                                                                "ON CONFLICT DO NOTHING");
        prepInsert.setInt(1, artist_id);
        prepInsert.setInt(2, album_id);

        prepInsert.executeUpdate();
    }

    void addGenre(String genre) throws SQLException {
        ResultSet resultSet = getRecordResultSet("genre", genre);

        if (!checkIfResultExists(resultSet)) {

            PreparedStatement prepInsert = con.prepareStatement("INSERT INTO genre(name) VALUES (?)" +
                    "ON CONFLICT DO NOTHING");
            prepInsert.setString(1, genre);

            prepInsert.executeUpdate();
        }
    }

     void addToSong_Genre(int song_id, int genre_id) throws SQLException {
        PreparedStatement prepInsert = con.prepareStatement("INSERT INTO song_genre(song_id, genre_id) VALUES (? , ?)" +
                                                                "ON CONFLICT DO NOTHING");
        prepInsert.setInt(1, song_id);
        prepInsert.setInt(2, genre_id);

        prepInsert.executeUpdate();
    }

    void addArtist(String artist) throws SQLException {
        ResultSet resultSet = getRecordResultSet("artist", artist);

        if (!checkIfResultExists(resultSet)) {
            PreparedStatement prepInsert = con.prepareStatement("INSERT INTO artist(name) VALUES (?)" +
                    "ON CONFLICT DO NOTHING");
            prepInsert.setString(1, artist);

            prepInsert.executeUpdate();
        }
    }

     ResultSet getSongResultSet(String song, String artist) throws SQLException {
        PreparedStatement prepSelect = con.prepareStatement("SELECT song.song_id FROM song" +
                "  INNER JOIN artist_song ON artist_song.song_id = song.song_id" +
                "  INNER JOIN artist ON artist_song.artist_id = artist.artist_id" +
                "  WHERE song.name = ? AND artist.name = ?;");
        prepSelect.setString(1, song);
        prepSelect.setString(2, artist);

        return prepSelect.executeQuery();
    }

     ResultSet getAlbumResultSet(String album, String artist) throws SQLException {
        PreparedStatement prepSelect = con.prepareStatement("SELECT album.album_id FROM album" +
                "  INNER JOIN artist_album ON artist_album.album_id = album.album_id" +
                "  INNER JOIN artist ON artist_album.artist_id = artist.artist_id" +
                "  WHERE album.name = ? AND artist.name = ?;");
        prepSelect.setString(1, album);
        prepSelect.setString(2, artist);

        return prepSelect.executeQuery();
    }

     ResultSet getRecordResultSet(String tableName, String name) throws SQLException {
        String string = String.format("SELECT %s_id FROM %s WHERE name = ?", tableName, tableName);
        PreparedStatement prepSelect = con.prepareStatement(string);

        prepSelect.setString(1, name);

        return prepSelect.executeQuery();
    }

    private boolean checkIfResultExists(ResultSet resultSet) throws SQLException {
        return resultSet.next();
    }

    public int getRecordId(String tableName, String name, String columnLabel) throws SQLException {
        ResultSet resultSet = this.getRecordResultSet(tableName, name);
        if(resultSet.next()) {
            return resultSet.getInt(columnLabel);
        } else {
            return 1;
        }
    }
}

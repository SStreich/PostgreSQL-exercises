import java.sql.*;

public class DAO {
    Connection con  = ConnectionProvider.getConnection();

    void createRecordsIfNotExist(String song, String artist, String album, String year, String genre, String user, String playlist) throws SQLException {
        addArtist(artist);
        addGenre(genre);
        addAlbum(album, artist, year);
        addSong(song, artist);
    }


    private void addSong(String song, String artist) throws SQLException {
        if(!checkIfSongExists(song,artist)) {
            PreparedStatement prepInsert = con.prepareStatement("INSERT INTO song(name, album) VALUES ('?' , '?')");
            prepInsert.setString(1, song);
            prepInsert.setString(2, artist);

            prepInsert.executeUpdate();
        }
    }


    private void addGenre(String genre) throws SQLException {
        if(!checkIfRecordExistis("genre", genre)) {
            PreparedStatement prepInsert = con.prepareStatement("INSERT INTO genre(name) VALUES ('?')");
            prepInsert.setString(1, genre);

            prepInsert.executeUpdate();
        }
    }

    private void addArtist(String artist) throws SQLException {
        if(!checkIfRecordExistis("artist", artist)) {
            PreparedStatement prepInsert = con.prepareStatement("INSERT INTO artist(name) VALUES ('?')");
            prepInsert.setString(1, artist);

            prepInsert.executeUpdate();
        }
    }

    private void addAlbum(String album, String artist, String year) throws SQLException {
        if(!checkIfAlbumExists(album, artist)) {
            PreparedStatement prepInsert = con.prepareStatement("INSERT INTO album(name, year) VALUES ('?', '?', '?')");
            prepInsert.setString(1, album);
            prepInsert.setString(2, artist);
            prepInsert.setString(3, year);

            prepInsert.executeUpdate();
        }
    }

    private ResultSet getSongID(String song, String artist) throws SQLException {
        PreparedStatement prepSelect = con.prepareStatement("SELECT song.song_id FROM song" +
                "  INNER JOIN artist_song ON artist_song.song_id = song.song_id" +
                "  INNER JOIN artist ON artist_song.artist_id = artist.artist_id" +
                "  WHERE song.name = '?' AND artist.name = '?';");
        prepSelect.setString(1, song);
        prepSelect.setString(2, artist);

        return prepSelect.executeQuery();
    }


    private boolean checkIfSongExists(String song, String artist) throws SQLException {
        return getSongID(song, artist).next();
    }

    private boolean checkIfAlbumExists(String album, String artist) throws SQLException {
        PreparedStatement prepSelect = con.prepareStatement("SELECT album.album_id FROM album" +
                "  INNER JOIN artist_album ON artist_album.album_id = album.album_id" +
                "  INNER JOIN artist ON artist_album.artist_id = artist.artist_id" +
                "  WHERE album.name = '?' AND artist.name = '?';");
        prepSelect.setString(1, album);
        prepSelect.setString(2, artist);

        ResultSet resultSet = prepSelect.executeQuery();

        return resultSet.next();
    }

    private boolean checkIfRecordExistis(String tableName, String name) throws SQLException {
        PreparedStatement prepSelect = con.prepareStatement("SELECT ?_id FROM ? WHERE name = '?'");

        prepSelect.setString(1, tableName);
        prepSelect.setString(2, name);

        ResultSet resultSet = prepSelect.executeQuery();

        return resultSet.next();
    }








    private int getAlbumId(String album, int artistId)throws SQLException {
        PreparedStatement prepSelect = con.prepareStatement("SELECT album_id FROM artist_album WHERE artist_id = ?");
        prepSelect.setString(1, String.valueOf(artistId));
        ResultSet resultSet = prepSelect.executeQuery();

        if (!resultSet.next()) {
            insertIntoColumn("album", album);
            resultSet = prepSelect.executeQuery();
        }
        return resultSet.getInt("album_id");
    }

    private int (String tableName, String name) throws SQLException {
        PreparedStatement prepSelect = con.prepareStatement("SELECT ?_id FROM ? WHERE name = ?");
        prepSelect.setString(1, tableName);
        prepSelect.setString(2, tableName);
        prepSelect.setString(3, name);

        ResultSet resultSet = prepSelect.executeQuery();

        if(!resultSet.next()) {
            insertIntoColumn(tableName, name);
            resultSet = prepSelect.executeQuery();
        }

        return
    }

    //For artist, genre
    private Integer getRecordId(String tableName, String name) throws SQLException {
        PreparedStatement prepSelect = con.prepareStatement("SELECT ?_id FROM ? WHERE name = ?");
        prepSelect.setString(1, tableName);
        prepSelect.setString(2, tableName);
        prepSelect.setString(3, name);

        ResultSet resultSet = prepSelect.executeQuery();

        if(resultSet.next()) {
            return resultSet.getInt(tableName + "_id");
        } else {
            return null;
        }

    }


    private void insertIntoColumn(String tableName, String name) throws SQLException {
        PreparedStatement prepInsert = con.prepareStatement("INSERT INTO " + tableName + "(name) VALUES ?");
        prepInsert.setString(1, name);
        prepInsert.executeUpdate();
    }

//    private void insertCompositeColumn(String columnName, String table1, String table2, String name1, String name2) throws SQLException {
//        PreparedStatement prepInsert = con.prepareStatement("INSERT INTO " + columnName + "(" + table1 + "," + table2 + " + column2 + "(name) VALUES ?, ?");
//        prepInsert.setString(1, name1);
//        prepInsert.setString(2, name2);
//        prepInsert.executeUpdate();
//    }
}

import java.sql.*;

public class NewRecord {
    DAO dao = new DAO();

    void addNewRecord(String song, String artist, String album, String year, String genre) throws SQLException {
        dao.addArtist(artist);
        dao.addGenre(genre);
        dao.addAlbum(album, artist, year);
        dao.addSong(song, artist);
    }
}
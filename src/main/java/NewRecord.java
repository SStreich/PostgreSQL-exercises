import java.sql.*;

public class NewRecord {
    DAO dao = new DAO();

    void addNewRecord(String song, String artist, String album, String year, String genre) throws SQLException {

        dao.addArtist(artist);
        int artist_id = dao.getRecordResultSet("artist", artist).getInt(0);

        dao.addGenre(genre);
        int genre_id = dao.getRecordResultSet("genre", genre).getInt(0);

        dao.addAlbum(album, artist, year);
        int album_id = dao.getAlbumResultSet(album, artist).getInt(0);

        dao.addSong(song, artist, album_id);
        int song_id = dao.getSongResultSet(song, artist).getInt(0);

        dao.addToArtist_Album(artist_id, album_id);
        dao.addToArtist_Song(artist_id, song_id);
        dao.addToSong_Genre(song_id, genre_id);
    }
}
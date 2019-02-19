import java.sql.*;

public class NewRecord {
    DAO dao = new DAO();
    //static int artist_id = 1;
    static int album_id = 1;
    static int song_id = 1;
    static int genre_id = 1;

    void addNewRecord(String song, String album, String artist, String genre, String year) throws SQLException {

        dao.addArtist(artist);
        int artist_id = dao.getRecordId("artist", artist, "artist_id");

        dao.addGenre(genre);
        int genre_id = dao.getRecordId("genre", genre, "genre_id");

        dao.addAlbum(album, artist, year);
        int album_id = dao.getRecordId("album", album, "album_id");
        dao.addToArtist_Album(artist_id, album_id);


        dao.addSong(song, artist, album_id);
        int song_id = dao.getRecordId("song", song, "song_id");

        dao.addToArtist_Song(artist_id, song_id);
        dao.addToSong_Genre(song_id, genre_id);
    }
}
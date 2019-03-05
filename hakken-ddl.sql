-- 1
CREATE TABLE IF NOT EXISTS account (
  account_id SERIAL PRIMARY KEY,
  name VARCHAR(70) NOT NULL,
  password VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL
);

-- 2
CREATE TABLE IF NOT EXISTS  artist (
  artist_id SERIAL PRIMARY KEY,
  name VARCHAR(999) NOT NULL
);

-- 3
CREATE TABLE IF NOT EXISTS album (
  album_id SERIAL PRIMARY KEY,
  name VARCHAR(990) NOT NULL ,
  year VARCHAR(30)
);

-- 4
CREATE TABLE IF NOT EXISTS song (
  song_id SERIAL PRIMARY KEY,
  name VARCHAR(990) NOT NULL,
  album_id INT,
  listens INT DEFAULT 0
);

-- 5
CREATE TABLE IF NOT EXISTS playlist (
  playlist_id SERIAL PRIMARY KEY,
  name VARCHAR(70) NOT NULL,
  owner_id INTEGER NOT NULL
);

-- 6
CREATE TABLE IF NOT EXISTS genre (
  genre_id SERIAL PRIMARY KEY,
  name VARCHAR(70) UNIQUE NOT NULL
);

-- 7
CREATE TABLE IF NOT EXISTS song_genre (
  song_id INTEGER NOT NULL REFERENCES song,
  genre_id INTEGER NOT NULL REFERENCES genre,
  PRIMARY KEY (song_id, genre_id)
);

-- 8
CREATE TABLE IF NOT EXISTS song_playlist (
  song_id INTEGER NOT NULL REFERENCES song,
  playlist_id INTEGER NOT NULL REFERENCES playlist,
  PRIMARY KEY (song_id, playlist_id)
);

-- 9
CREATE TABLE IF NOT EXISTS artist_song (
  artist_id INTEGER NOT NULL REFERENCES artist,
  song_id INTEGER NOT NULL REFERENCES song,
  PRIMARY KEY (artist_id, song_id)
);

-- 10
CREATE TABLE IF NOT EXISTS artist_album (
  artist_id INTEGER NOT NULL REFERENCES artist,
  album_id INTEGER NOT NULL REFERENCES album,
  PRIMARY KEY (artist_id, album_id)
);

CREATE OR REPLACE VIEW top_songs AS
  SELECT * FROM song
    ORDER BY listens DESC
    LIMIT 10;

DROP TRIGGER IF EXISTS set_year
  ON public.album;

DROP TRIGGER IF EXISTS assign_playlists
  ON public.playlist;

DROP FUNCTION IF EXISTS assign_playlists();

CREATE OR REPLACE FUNCTION set_year() RETURNS trigger AS $set_0_value_empty$
   BEGIN
    IF NEW.year = '0' THEN
       NEW.year := '';
    END IF;
    RETURN NEW;
   END;
$set_0_value_empty$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION assign_playlists() RETURNS trigger AS $assign_playlists$
BEGIN
     INSERT INTO account_playlist(account_id, playlist_id)
     VALUES (NEW.owner_id, NEW.playlist_id);
    RETURN NEW;
END;
  $assign_playlists$ LANGUAGE plpgsql;

CREATE TRIGGER set_year BEFORE INSERT OR UPDATE ON album
   FOR EACH ROW EXECUTE PROCEDURE set_year();

CREATE TRIGGER assign_playlists AFTER INSERT OR UPDATE ON playlist
  FOR EACH ROW EXECUTE PROCEDURE assign_playlists();

CREATE INDEX IF NOT EXISTS song_name ON song USING spgist(name);



CREATE INDEX IF NOT EXISTS album_year on album(year DESC);


CREATE OR REPLACE FUNCTION incrementListens(songID INT) RETURNS void AS $incrementListens$
  BEGIN
    UPDATE song SET listens = listens + 1
    WHERE song.song_id = songID;
  END;
$incrementListens$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION addToUserPlayedPlaylist(accountID INTEGER, songID INTEGER)
RETURNS void AS $addToUserPlayedPlaylist$
  BEGIN
    INSERT INTO song_playlist (song_id, playlist_id)
    VALUES (songID,
            (SELECT playlist_id FROM playlist
            WHERE owner_id = accountID
            ORDER BY playlist_id
            ASC LIMIT 1)
            );
  END;
$addToUserPlayedPlaylist$ LANGUAGE plpgsql;


CREATE OR REPLACE VIEW v_rockSongs AS
SELECT song.name as Title, album.name as Album, song.listens as Listens
  FROM song
    inner join song_genre on song.song_id = song_genre.song_id
    inner join genre on song_genre.genre_id = genre.genre_id
    inner join album on song.album_id = album.album_id
  WHERE genre.name = 'rock';


CREATE OR REPLACE FUNCTION handlePlaylistSize() RETURNS TRIGGER
AS $handlePlaylistSize$
  BEGIN
    IF (SELECT count(playlist_id) FROM song_playlist
    WHERE playlist_id = NEW.playlist_id) > 100 THEN
        DELETE FROM song_playlist WHERE song_id IN
                                      (SELECT song_id FROM song_playlist
                                      WHERE playlist_id = NEW.playlist_id
                                      ORDER BY song_playlist.playlist_id ASC
                                      LIMIT 1) AND playlist_id = NEW.playlist_id;
    END IF;
  RETURN new;
END;
$handlePlaylistSize$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS handlePlaylistSize ON song_playlist;


CREATE TRIGGER handlePlaylistSize AFTER INSERT ON song_playlist
  FOR EACH ROW EXECUTE PROCEDURE handlePlaylistSize();

CREATE OR REPLACE FUNCTION getPlaylistId(accountId int) RETURNS integer
AS
$getPlaylistId$
BEGIN
  RETURN (SELECT playlist_id FROM playlist WHERE owner_id = accountId ORDER BY playlist_id ASC LIMIT 1);
END;
$getPlaylistId$
  LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getGenreName(songId int) RETURNS text
AS
$getGenreName$
BEGIN
  RETURN (SELECT genre.name
          FROM genre
                 INNER JOIN song_genre
                            ON genre.genre_id = song_genre.genre_id
          WHERE song_id = songId);
END;
$getGenreName$
  LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getGenreID(songId int) RETURNS int
AS
$getGenreName$
BEGIN
  RETURN (SELECT genre.genre_id
          FROM genre
                 INNER JOIN song_genre
                            ON genre.genre_id = song_genre.genre_id
          WHERE song_id = songId);
END;
$getGenreName$
  LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getAllSongIDs(playlistId int) RETURNS setof int
AS
$getAllsongs$
BEGIN
  RETURN QUERY SELECT song_id FROM song_playlist WHERE playlist_id = playlistId;
  IF NOT found THEN
    RAISE NOTICE 'No songs found in playlist';
  END IF;

END;
$getAllsongs$
  LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getAllGenresNamesInPlaylist(playlistId int) RETURNS setof text
AS
$allGenresInPlaylist$
DECLARE
  song integer;
BEGIN
  FOR song IN SELECT song_id FROM song_playlist WHERE playlist_id = playlistId
    LOOP
      RETURN NEXT (SELECT genre.name
                   FROM genre
                          INNER JOIN song_genre ON genre.genre_id = song_genre.genre_id
                   WHERE song_id = song);
    END LOOP;
END;
$allGenresInPlaylist$
  LANGUAGE plpgsql;


CREATE VIEW top_20_artists AS
SELECT artist.name AS artist, album.name AS album, sum(song.listens) total_listens
FROM artist
       INNER JOIN artist_album ON artist.artist_id = artist_album.artist_id
       INNER JOIN album ON album.album_id = artist_album.album_id
       INNER JOIN song ON song.album_id = album.album_id
GROUP BY song.listens, artist.name, album.name
ORDER BY song.listens DESC
LIMIT 20;


CREATE FUNCTION incrementlistens_privatePlaylist() RETURNS trigger AS
$listens$
DECLARE
  newSongId  int;
  playListID int;
  ownerID    int;
BEGIN
  newSongId := new.song_id;
  playListID := new.playlist_id;
  ownerID := (SELECT owner_id FROM playlist WHERE owner_id == playListID);

  UPDATE song
  SET listens = listens + 1
  WHERE song.song_id = newSongId;

END;
$listens$
  LANGUAGE plpgsql;
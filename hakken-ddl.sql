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
CREATE TABLE IF NOT EXISTS account_playlist (
  account_id INTEGER NOT NULL REFERENCES account,
  playlist_id INTEGER NOT NULL REFERENCES playlist,
  PRIMARY KEY (account_id, playlist_id)
);

-- 8
CREATE TABLE IF NOT EXISTS song_genre (
  song_id INTEGER NOT NULL REFERENCES song,
  genre_id INTEGER NOT NULL REFERENCES genre,
  PRIMARY KEY (song_id, genre_id)
);

-- 9
CREATE TABLE IF NOT EXISTS song_playlist (
  song_id INTEGER NOT NULL REFERENCES song,
  playlist_id INTEGER NOT NULL REFERENCES playlist,
  PRIMARY KEY (song_id, playlist_id)
);

-- 10
CREATE TABLE IF NOT EXISTS artist_song (
  artist_id INTEGER NOT NULL REFERENCES artist,
  song_id INTEGER NOT NULL REFERENCES song,
  PRIMARY KEY (artist_id, song_id)
);

-- 11
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




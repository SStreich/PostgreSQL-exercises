-- 1
CREATE TABLE account (
  account_id SERIAL PRIMARY KEY,
  name VARCHAR(70) NOT NULL,
  password VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL
);

-- 2
CREATE TABLE artist (
  artist_id SERIAL PRIMARY KEY,
  name VARCHAR(999) NOT NULL
);

-- 3
CREATE TABLE album (
  album_id SERIAL PRIMARY KEY,
  name VARCHAR(990) NOT NULL ,
  year VARCHAR(30)
);

-- 4
CREATE TABLE song (
  song_id SERIAL PRIMARY KEY,
  name VARCHAR(990) NOT NULL,
  album_id INT,
  listens INT DEFAULT 0
);

-- 5
CREATE TABLE playlist (
  playlist_id SERIAL PRIMARY KEY,
  name VARCHAR(70) NOT NULL,
  owner_id INTEGER NOT NULL
);

-- 6
CREATE TABLE genre (
  genre_id SERIAL PRIMARY KEY,
  name VARCHAR(70) UNIQUE NOT NULL
);

-- 7
CREATE TABLE account_playlist (
  account_id INTEGER NOT NULL REFERENCES account,
  playlist_id INTEGER NOT NULL REFERENCES playlist,
  PRIMARY KEY (account_id, playlist_id)
);

-- 8
CREATE TABLE song_genre (
  song_id INTEGER NOT NULL REFERENCES song,
  genre_id INTEGER NOT NULL REFERENCES genre,
  PRIMARY KEY (song_id, genre_id)
);

-- 9
CREATE TABLE song_playlist (
  song_id INTEGER NOT NULL REFERENCES song,
  playlist_id INTEGER NOT NULL REFERENCES playlist,
  PRIMARY KEY (song_id, playlist_id)
);

-- 10
CREATE TABLE artist_song (
  artist_id INTEGER NOT NULL REFERENCES artist,
  song_id INTEGER NOT NULL REFERENCES song,
  PRIMARY KEY (artist_id, song_id)
);

-- 11
CREATE TABLE artist_album (
  artist_id INTEGER NOT NULL REFERENCES artist,
  album_id INTEGER NOT NULL REFERENCES album,
  PRIMARY KEY (artist_id, album_id)
);

CREATE OR REPLACE VIEW top_songs AS
  SELECT * FROM song
    ORDER BY listens DESC
    LIMIT 10;

 CREATE OR REPLACE FUNCTION set_year() RETURNS trigger AS $set_0_value_as_null$
   BEGIN
    IF NEW.year = '0' THEN
       NEW.year := '';
    END IF;
    RETURN NEW;
   END;
   $set_0_value_as_null$ LANGUAGE plpgsql;


 CREATE TRIGGER set_year BEFORE INSERT OR UPDATE ON album
   FOR EACH ROW EXECUTE PROCEDURE set_year();




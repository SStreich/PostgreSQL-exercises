-- 1
CREATE TABLE account (
  account_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  password VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL
);

-- 2
CREATE TABLE artist (
  artist_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

-- 3
CREATE TABLE album (
  album_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL ,
  year INT
);

-- 4
CREATE TABLE song (
  song_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  album VARCHAR(50),
  listens INT DEFAULT 0
);

-- 5
CREATE TABLE playlist (
  playlist_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  owner_id INTEGER NOT NULL ,
  private boolean DEFAULT true
);

-- 6
CREATE TABLE genre (
  genre_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
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

CREATE OR REPLACE FUNCTION add_album() RETURNS trigger AS $update_top_songs$
  BEGIN
    IF NEW.album NOT IN (SELECT name FROM public.album) THEN
      INSERT INTO public.album(name) VALUES (NEW.album);
      RETURN new;
  END IF;
  RETURN new;
  END;
  $update_top_songs$ LANGUAGE plpgsql;

CREATE TRIGGER add_album AFTER INSERT OR UPDATE ON song
  FOR EACH ROW EXECUTE PROCEDURE add_album();

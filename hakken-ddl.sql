-- 1
CREATE TABLE account (
  account_id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  password VARCHAR(50),
  email VARCHAR(50)
);

-- 2
CREATE TABLE artist (
  artist_id SERIAL PRIMARY KEY,
  name VARCHAR(50)
);

-- 3
CREATE TABLE album (
  album_id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  year INT
);

-- 4
CREATE TABLE song (
  song_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  album INT REFERENCES album(album_id),
  listens INT
);

-- 5
CREATE TABLE playlist (
  playlist_id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  owner_id INTEGER,
  private boolean
);

-- 6
CREATE TABLE genre (
  genre_id SERIAL PRIMARY KEY,
  name VARCHAR(50)
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

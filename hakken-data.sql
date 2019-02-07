create table account
(
  account_id serial not null
    constraint account_pkey
      primary key,
  name       varchar(50),
  password   varchar(50),
  email      varchar(50)
);

alter table account
  owner to postgres;

INSERT INTO public.account (account_id, name, password, email) VALUES (3005, 'beniz', 'bedziehash', 'beniz@fufu@gego.ru');
INSERT INTO public.account (account_id, name, password, email) VALUES (3006, 'Fafull', 'tutajtez', 'faflut@fulfa.fa');
INSERT INTO public.account (account_id, name, password, email) VALUES (3007, 'Watashiwa', 'wszedzebedze', 'shigosan@guku.jp');
INSERT INTO public.account (account_id, name, password, email) VALUES (0, 'admin', 'admin', 'admin@admin.admin');
create table account_playlist
(
  account_id  integer not null
    constraint account_playlist_account_id_fkey
      references account,
  playlist_id integer not null,
  constraint account_playlist_pkey
    primary key (account_id, playlist_id)
);

alter table account_playlist
  owner to postgres;

INSERT INTO public.account_playlist (account_id, playlist_id) VALUES (0, 1);
create table album
(
  album_id serial not null
    constraint album_pkey
      primary key,
  name     varchar(50),
  year     integer
);

alter table album
  owner to postgres;

INSERT INTO public.album (album_id, name, year) VALUES (1, 'Organic Halucinosis', 2006);
INSERT INTO public.album (album_id, name, year) VALUES (2, 'The Dark Side of the Moon', 1973);
INSERT INTO public.album (album_id, name, year) VALUES (3, 'Justified', 2002);
INSERT INTO public.album (album_id, name, year) VALUES (4, 'Litany', 2000);
create table artist
(
  artist_id serial not null
    constraint artist_pkey
      primary key,
  name      varchar(50)
);

alter table artist
  owner to postgres;

INSERT INTO public.artist (artist_id, name) VALUES (1, 'Decapitated');
INSERT INTO public.artist (artist_id, name) VALUES (2, 'Pink Floyd');
INSERT INTO public.artist (artist_id, name) VALUES (3, 'Justin Timberlake');
INSERT INTO public.artist (artist_id, name) VALUES (4, 'Vader');
create table artist_album
(
  artist_id integer not null
    constraint artist_album_artist_id_fkey
      references artist,
  album_id  integer not null
    constraint artist_album_album_id_fkey
      references album,
  constraint artist_album_pkey
    primary key (artist_id, album_id)
);

alter table artist_album
  owner to postgres;

INSERT INTO public.artist_album (artist_id, album_id) VALUES (1, 1);
INSERT INTO public.artist_album (artist_id, album_id) VALUES (2, 2);
INSERT INTO public.artist_album (artist_id, album_id) VALUES (3, 3);
INSERT INTO public.artist_album (artist_id, album_id) VALUES (4, 4);
create table artist_song
(
  artist_id integer not null
    constraint artist_song_artist_id_fkey
      references artist,
  song_id   integer not null
    constraint artist_song_song_id_fkey
      references song,
  constraint artist_song_pkey
    primary key (artist_id, song_id)
);

alter table artist_song
  owner to postgres;

INSERT INTO public.artist_song (artist_id, song_id) VALUES (1, 1);
INSERT INTO public.artist_song (artist_id, song_id) VALUES (1, 6);
INSERT INTO public.artist_song (artist_id, song_id) VALUES (1, 7);
INSERT INTO public.artist_song (artist_id, song_id) VALUES (1, 8);
INSERT INTO public.artist_song (artist_id, song_id) VALUES (2, 2);
INSERT INTO public.artist_song (artist_id, song_id) VALUES (3, 3);
INSERT INTO public.artist_song (artist_id, song_id) VALUES (4, 4);
INSERT INTO public.artist_song (artist_id, song_id) VALUES (4, 5);
create table genre
(
  genre_id serial not null
    constraint genre_pkey
      primary key,
  name     varchar(50)
);

alter table genre
  owner to postgres;

INSERT INTO public.genre (genre_id, name) VALUES (1, 'metal');
INSERT INTO public.genre (genre_id, name) VALUES (2, 'rock');
INSERT INTO public.genre (genre_id, name) VALUES (3, 'pop');
create table playlist
(
  playlist_id serial not null
    constraint playlist_pkey
      primary key,
  owner_id    integer,
  name        varchar(50),
  private     boolean
);

alter table playlist
  owner to postgres;

INSERT INTO public.playlist (playlist_id, owner_id, name, private) VALUES (0, 0, 'default', false);
INSERT INTO public.playlist (playlist_id, owner_id, name, private) VALUES (2, 1, 'metal', true);
create table song
(
  song_id serial not null
    constraint song_pkey
      primary key,
  name    varchar(50),
  listens integer
);

alter table song
  owner to postgres;

INSERT INTO public.song (song_id, name, listens) VALUES (1, 'Post Organic', 0);
INSERT INTO public.song (song_id, name, listens) VALUES (2, 'Time', 0);
INSERT INTO public.song (song_id, name, listens) VALUES (3, 'Cry Me a River', 0);
INSERT INTO public.song (song_id, name, listens) VALUES (4, 'Litany', 0);
INSERT INTO public.song (song_id, name, listens) VALUES (5, 'Wings', 0);
INSERT INTO public.song (song_id, name, listens) VALUES (6, 'A Poem About an Old Prison Man', 0);
INSERT INTO public.song (song_id, name, listens) VALUES (7, 'Day 69', 0);
INSERT INTO public.song (song_id, name, listens) VALUES (8, 'Invisible Control', 0);
create table song_genre
(
  song_id  integer not null
    constraint song_genre_song_id_fkey
      references song,
  genre_id integer not null
    constraint song_genre_genre_id_fkey
      references genre,
  constraint song_genre_pkey
    primary key (song_id, genre_id)
);

alter table song_genre
  owner to postgres;

INSERT INTO public.song_genre (song_id, genre_id) VALUES (1, 1);
INSERT INTO public.song_genre (song_id, genre_id) VALUES (4, 1);
INSERT INTO public.song_genre (song_id, genre_id) VALUES (5, 1);
INSERT INTO public.song_genre (song_id, genre_id) VALUES (6, 1);
INSERT INTO public.song_genre (song_id, genre_id) VALUES (7, 1);
INSERT INTO public.song_genre (song_id, genre_id) VALUES (8, 1);
INSERT INTO public.song_genre (song_id, genre_id) VALUES (2, 2);
INSERT INTO public.song_genre (song_id, genre_id) VALUES (3, 3);
create table song_playlist
(
  song_id     integer not null
    constraint song_playlist_song_id_fkey
      references song,
  playlist_id integer not null,
  constraint song_playlist_pkey
    primary key (song_id, playlist_id)
);

alter table song_playlist
  owner to postgres;

INSERT INTO public.song_playlist (song_id, playlist_id) VALUES (1, 0);
INSERT INTO public.song_playlist (song_id, playlist_id) VALUES (2, 0);
INSERT INTO public.song_playlist (song_id, playlist_id) VALUES (3, 0);
INSERT INTO public.song_playlist (song_id, playlist_id) VALUES (4, 0);
INSERT INTO public.song_playlist (song_id, playlist_id) VALUES (5, 0);
INSERT INTO public.song_playlist (song_id, playlist_id) VALUES (6, 0);
INSERT INTO public.song_playlist (song_id, playlist_id) VALUES (7, 0);
INSERT INTO public.song_playlist (song_id, playlist_id) VALUES (8, 0);
INSERT INTO public.song_playlist (song_id, playlist_id) VALUES (1, 1);
INSERT INTO public.song_playlist (song_id, playlist_id) VALUES (4, 1);
INSERT INTO public.song_playlist (song_id, playlist_id) VALUES (5, 1);
INSERT INTO public.song_playlist (song_id, playlist_id) VALUES (6, 1);
INSERT INTO public.song_playlist (song_id, playlist_id) VALUES (7, 1);
INSERT INTO public.song_playlist (song_id, playlist_id) VALUES (8, 1);
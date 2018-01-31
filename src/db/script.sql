
CREATE TABLE IF NOT EXISTS SOURCES (
  url TEXT PRIMARY KEY
);


CREATE TABLE IF NOT EXISTS ALBUMS (
    album TEXT PRIMARY KEY,
    addDate DATE
);

CREATE TABLE IF NOT EXISTS TAGS (
    tag TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS IMAGES (
    url TEXT PRIMARY KEY,
    sources_url TEXT NOT NULL,
    title TEXT NOT NULL,
    rate INTEGER NOT NULL,
    fav INTEGER NOT NULL,
    color TEXT,
    note TEXT,
    addDate DATE,
    picDate DATE,
    place DATE,
    format TEXT,

    FOREIGN KEY(sources_url) REFERENCES SOURCES(url)
);

CREATE TABLE IF NOT EXISTS IMAGES_TAGS (
    tag TEXT NOT NULL,
    url VARCHAR(150) NOT NULL,

    FOREIGN KEY(tag) REFERENCES TAGS(tag),
    FOREIGN KEY(url) REFERENCES IMAGES(url)
);

CREATE TABLE IF NOT EXISTS IMAGES_ALBUMS (
    album TEXT NOT NULL,
    url TEXT NOT NULL,
    addDate DATE,

    FOREIGN KEY(album) REFERENCES ALBUMS(album),
    FOREIGN KEY(url) REFERENCES IMAGES(url)
);
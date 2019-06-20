# Complete the DB Schema

# Write the SQL queries to answer these questions:

#   List all customers (name + email), ordered alphabetically (no extra information)
#   List tracks (Name + Composer) of the Classical playlist
#   List the 10 artists mostly listed in all playlists
#   List the tracks which have been purchased at least twice,
#   ordered by number of purchases
require "sqlite3"

db = 'chinook.sqlite'
db = SQLite3::Database.new(db)


def customers(db)
  db.execute("SELECT first_name, email FROM customers ORDER BY 1")
end

def classical_tracks(db)
  db.execute("SELECT tracks.name, tracks.composer
              FROM tracks
              JOIN playlist_tracks ON tracks.id = playlist_tracks.track_id
              JOIN playlists ON playlists.id = playlist_tracks.playlist_id
              WHERE playlists.name = 'Classical'")
end

def top_ten(db)
  db.execute(
    "SELECT artists.name, COUNT(*) AS occurrences
    FROM artists
    JOIN albums ON artists.id = albums.artist_id
    JOIN tracks ON albums.id = tracks.album_id
    JOIN playlist_tracks ON tracks.id = playlist_tracks.track_id
    JOIN playlists ON playlist_tracks.playlist_id = playlists.id
    GROUP BY artists.name
    ORDER BY occurrences DESC
    LIMIT 10"
  )
end

def purchases(db)
  db.execute(
    "SELECT tracks.name, tracks.composer, COUNT(*) AS purchases
    FROM tracks
    JOIN invoice_lines ON tracks.id = invoice_lines.track_id
    GROUP BY tracks.name
    HAVING purchases >= 2
    ORDER BY purchases DESC"
    )
end


# p customers(db)
# p classical_tracks(db)
# p top_ten(db)
p purchases(db)

cask "spotify-now-playing" do
  version "0.7.0"
  sha256 "3771b0a35b87264f387fbd591c50fd20554508692d3060d0ddce536aac23d17c"

  url "https:github.comdavicorreiajrspotify-now-playingreleasesdownloadv#{version}spotify-now-playing-#{version}.dmg"
  name "Spotify - now playing"
  homepage "https:github.comdavicorreiajrspotify-now-playing"

  app "Spotify - now playing.app"

  zap trash: [
    "~LibraryLogsSpotify - now playing",
    "~LibraryPreferencescom.electron.spotify-now-playing.plist",
  ]
end
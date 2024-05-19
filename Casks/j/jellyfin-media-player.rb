cask "jellyfin-media-player" do
  arch arm: "AppleSilicon", intel: "Intel"

  version "1.10.1"
  sha256 arm:   "254c2c877ffd248366b200c15c92a97d768e002993dfe870c19f5c1db7389ab3",
         intel: "5806bd43601a67f901e9c4a72d8a540d880c2dcef4792df6fd4d46b74082bf9d"

  url "https:github.comjellyfinjellyfin-media-playerreleasesdownloadv#{version}JellyfinMediaPlayer-#{version}-#{arch}.dmg",
      verified: "github.comjellyfinjellyfin-media-player"
  name "Jellyfin Media Player"
  desc "Jellyfin desktop client"
  homepage "https:jellyfin.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Jellyfin Media Player.app"

  zap trash: [
    "~LibraryApplication SupportJellyfin Media Player",
    "~LibraryCachesJellyfin Media Player",
    "~LibraryLogsJellyfin Media Player",
    "~LibraryPreferencesorg.jellyfin.Jellyfin Media Player.plist",
    "~LibrarySaved Application Statetv.jellyfin.player.savedState",
  ]
end
cask "jellyfin-media-player" do
  version "1.9.1"
  sha256 "6ed5f5c1489c177de45f46fdbeefee8cc9eee7faff75d03e3840f522849674d2"

  url "https:github.comjellyfinjellyfin-media-playerreleasesdownloadv#{version}JellyfinMediaPlayer-#{version}-macos-notarized.dmg",
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
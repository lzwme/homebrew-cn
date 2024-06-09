cask "jellyfin-media-player" do
  arch arm: "AppleSilicon", intel: "Intel"

  version "1.11.1"
  sha256 arm:   "6d5478a7eb457c0c842e3b4265f254d9504fe8e4c8bc5e49e59bf8c68d3cdfcd",
         intel: "2683c358606d8b3196c890759331a29f204438e53408640429e832ca3d92ffe0"

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
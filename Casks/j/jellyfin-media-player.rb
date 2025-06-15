cask "jellyfin-media-player" do
  version "1.12.0"

  on_ventura :or_older do
    # Monterey and Ventura require Rosetta on Apple Silicon
    arch arm: "Intel", intel: "Intel"

    sha256 "f6a75747c1234c929c968599cc927cfb27a0c00dfa9db9198d5b22b3090c4d34"

    caveats do
      requires_rosetta
    end
  end
  on_sonoma :or_newer do
    arch arm: "AppleSilicon", intel: "Intel"

    sha256 arm:   "272412af869f5278b93c16cda2657de3cda50e595a68a1c062b8dff5e40980bc",
           intel: "f6a75747c1234c929c968599cc927cfb27a0c00dfa9db9198d5b22b3090c4d34"
  end

  url "https:github.comjellyfinjellyfin-media-playerreleasesdownloadv#{version}JellyfinMediaPlayer-#{version}-#{arch}.dmg",
      verified: "github.comjellyfinjellyfin-media-player"
  name "Jellyfin Media Player"
  desc "Jellyfin desktop client"
  homepage "https:jellyfin.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :monterey"

  app "Jellyfin Media Player.app"

  zap trash: [
    "~LibraryApplication SupportJellyfin Media Player",
    "~LibraryCachesJellyfin Media Player",
    "~LibraryLogsJellyfin Media Player",
    "~LibraryPreferencesorg.jellyfin.Jellyfin Media Player.plist",
    "~LibrarySaved Application Statetv.jellyfin.player.savedState",
  ]
end
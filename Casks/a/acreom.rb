cask "acreom" do
  arch arm: "-arm64"

  version "1.16.0"
  sha256 arm:   "46b22c0d8997164e516f999683846f0d3e53feb401dad39834221fae7dae9464",
         intel: "46ef247d1c02d6b24680260a0a1d2f78c8ffe1f519340e0ac04fbdb597b66ba9"

  url "https:github.comAcreomreleasesreleasesdownloadv#{version}acreom-#{version}#{arch}.dmg",
      verified: "github.comAcreomreleases"
  name "acreom"
  desc "Personal knowledge base for developers"
  homepage "https:acreom.com"

  depends_on macos: ">= :high_sierra"

  app "acreom.app"

  zap trash: [
    "~LibraryApplication Supportacreom",
    "~LibraryLogsacreom",
    "~LibraryPreferencescom.acreom.acreom-desktop.plist",
    "~LibrarySaved Application Statecom.acreom.acreom-desktop.savedState",
  ]
end
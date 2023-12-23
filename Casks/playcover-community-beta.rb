cask "playcover-community-beta" do
  version "3.0.0-beta.2"
  sha256 "48a57cecc3a3c7e9af69e795706af3b9c729e46a6eea2e363eaa8628c5f12791"

  url "https:github.comPlayCoverPlayCoverreleasesdownload#{version}PlayCover_#{version}.dmg"
  name "PlayCover"
  desc "Sideload iOS apps and games"
  homepage "https:github.comPlayCoverPlayCover"

  livecheck do
    url :url
    regex((\d+(?:\.\d+)+[._-]beta(\.\d+)?)i)
  end

  auto_updates true
  conflicts_with cask: "playcover-community"
  depends_on arch: :arm64
  depends_on macos: ">= :monterey"

  app "PlayCover.app"

  zap trash: [
    "~LibraryApplication Supportio.playcover.PlayCover",
    "~LibraryCachesio.playcover.PlayCover",
    "~LibraryContainersio.playcover.PlayCover",
    "~LibraryFrameworksPlayTools.framework",
    "~LibraryPreferencesio.playcover.PlayCover.plist",
    "~LibrarySaved Application Stateio.playcover.PlayCover.savedState",
  ]
end
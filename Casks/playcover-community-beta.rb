cask "playcover-community-beta" do
  version "3.0.0-beta.1"
  sha256 "0f7c40d2654f9a70e52901fc4de910719090bd8ffb7b9fdd1caa1f0f2dc87628"

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
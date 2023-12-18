cask "playcover-community" do
  version "2.0.5"
  sha256 "d360235072d161d5e3da96e9c0e8cf5e7e1d63042a356f02230380e61947757a"

  url "https:github.comPlayCoverPlayCoverreleasesdownload#{version}PlayCover_#{version}.dmg"
  name "PlayCover"
  desc "Sideload iOS apps and games"
  homepage "https:github.comPlayCoverPlayCover"

  auto_updates true
  conflicts_with cask: "homebrewcask-versionsplaycover-community-beta"
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
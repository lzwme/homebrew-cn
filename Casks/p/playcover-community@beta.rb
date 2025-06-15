cask "playcover-community@beta" do
  version "3.0.0-beta.2"
  sha256 "d20d5d50085f248143e9eaaab2c65156aae461e90bdb32e50a751b58e15b4555"

  url "https:github.comPlayCoverPlayCoverreleasesdownload#{version}PlayCover_#{version}.dmg"
  name "PlayCover"
  desc "Sideload iOS apps and games"
  homepage "https:github.comPlayCoverPlayCover"

  livecheck do
    url :url
    regex((\d+(?:\.\d+)+[._-]beta(\.\d+)?)i)
  end

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-05-01", because: :unsigned

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
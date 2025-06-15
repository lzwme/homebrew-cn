cask "playcover-community" do
  version "3.1.0"
  sha256 "5c3a291827f4802f665daf5c33a6bfe6ef0df2c6dff3f9e554db6514176196e7"

  url "https:github.comPlayCoverPlayCoverreleasesdownload#{version}PlayCover_#{version}.dmg"
  name "PlayCover"
  desc "Sideload iOS apps and games"
  homepage "https:github.comPlayCoverPlayCover"

  livecheck do
    url "https:raw.githubusercontent.comPlayCoverPlayCoverupdateappcast.xml"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  conflicts_with cask: "playcover-community@beta"
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
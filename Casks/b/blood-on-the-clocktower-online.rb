cask "blood-on-the-clocktower-online" do
  arch arm: "aarch64", intel: "x64"

  version "3.44.1"
  sha256 arm:   "34bb6b9bdb386f81f32b797a0d1fb4fcc1988b94ff51a564182b3808d4cc159b",
         intel: "e6074df6a429968db8f49790a824106639fa437ef3acbc7f2db50631dfc1df77"

  url "https:github.comThePandemoniumInstitutebotc-releasereleasesdownloadv#{version}Blood.on.the.Clocktower.Online_#{version}_#{arch}.dmg",
      verified: "github.comThePandemoniumInstitutebotc-release"
  name "Blood on the Clocktower Online"
  desc "Client for the game Blood on the Clocktower"
  homepage "https:bloodontheclocktower.com"

  depends_on macos: ">= :high_sierra"

  app "Blood on the Clocktower Online.app"

  zap trash: [
    "~LibraryApplication Supportbotc-app",
    "~LibraryApplication Supportcom.thepandemoniuminstitute.botc.app",
    "~LibraryCachescom.thepandemoniuminstitute.botc.app",
    "~LibrarySaved Application Statecom.thepandemoniuminstitute.botc.app.savedState",
    "~LibraryWebKitcom.thepandemoniuminstitute.botc.app",
  ]
end
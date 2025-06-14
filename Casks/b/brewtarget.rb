cask "brewtarget" do
  version "4.1.2"
  sha256 "dcfa62c1f24c352b96b1ab5b9e015f50f2f312275484e388e73f641e2c92ed4b"

  url "https:github.comBrewtargetbrewtargetreleasesdownloadv#{version}brewtarget_#{version}_MacOS.dmg",
      verified: "github.comBrewtargetbrewtarget"
  name "brewtarget"
  desc "Beer recipe creation tool"
  homepage "https:www.brewtarget.beer"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "brewtarget_#{version}_MacOS.app"

  zap trash: [
    "~LibraryPreferencesbrewtarget",
    "~LibraryPreferencescom.brewtarget.Brewtarget.plist",
    "~LibrarySaved Application Statecom.brewtarget.Brewtarget.savedState",
  ]
end
cask "brewtarget" do
  version "4.0.17"
  sha256 "2d7dcc5ec784289d7e46c44e49d0df51fabad0d21a9c1cd6b327cb7697a3fb0c"

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
cask "lemonlime" do
  version "0.3.4.4"
  sha256 "f5c129a4e0e9e22966c9afcba4ead477f58255a65149097b4305599cc54ec8e0"

  url "https:github.comProject-LemonLimeProject_LemonLimereleasesdownload#{version}lemon-Release.dmg"
  name "lemonlime"
  desc "Tiny judging environment for OI contest based on Lemon + LemonPlus"
  homepage "https:github.comProject-LemonLimeProject_LemonLime"

  app "lemon.app"

  zap trash: [
    "~DocumentsProject_LemonLime",
    "~LibraryPreferencescom.github.lemonlime.plist",
    "~LibraryPreferencescom.lemonlime.lemon.plist",
    "~LibrarySaved Application Statecom.github.lemonlime.savedState",
  ]
end
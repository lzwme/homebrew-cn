cask "brewtarget" do
  version "4.0.0"
  sha256 "45cc7b0157f7d05c3a4ef3d3b69e3913a081d6ddffe4e83d4e35a18958827b37"

  url "https:github.comBrewtargetbrewtargetreleasesdownloadv#{version}brewtarget_#{version}.dmg"
  name "brewtarget"
  desc "Beer recipe creation tool"
  homepage "https:github.comBrewtargetbrewtarget"

  app "brewtarget_#{version}.app"

  zap trash: [
    "~LibraryPreferencesbrewtarget",
    "~LibraryPreferencescom.brewtarget.Brewtarget.plist",
    "~LibrarySaved Application Statecom.brewtarget.Brewtarget.savedState",
  ]
end
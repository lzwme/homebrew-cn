cask "brewtarget" do
  version "4.0.11"
  sha256 "670128fc271b8c96b5538bad4fe3d2d55464d3914b8723b4911ff59e86c31c95"

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
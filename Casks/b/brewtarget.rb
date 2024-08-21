cask "brewtarget" do
  version "4.0.2"
  sha256 "84d4c7bde5856f1c3b05f3ded5fdf4f8d7bbe3616a73a47ef8af773aca4ff279"

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
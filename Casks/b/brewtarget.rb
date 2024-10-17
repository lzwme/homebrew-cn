cask "brewtarget" do
  version "4.0.7"
  sha256 "dea5a4e7509c7fb5810c02a704a8a3fb765245c8a71f813173318f9ef305309a"

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
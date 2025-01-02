cask "brewtarget" do
  version "4.0.15"
  sha256 "1c8b0eaa0be89b5708ff3d24b75e9e736e93d58cf4cbb7521d655b9438a359f9"

  url "https:github.comBrewtargetbrewtargetreleasesdownloadv#{version}brewtarget_#{version}_MacOS.dmg",
      verified: "github.comBrewtargetbrewtarget"
  name "brewtarget"
  desc "Beer recipe creation tool"
  homepage "https:www.brewtarget.beer"

  app "brewtarget_#{version}_MacOS.app"

  zap trash: [
    "~LibraryPreferencesbrewtarget",
    "~LibraryPreferencescom.brewtarget.Brewtarget.plist",
    "~LibrarySaved Application Statecom.brewtarget.Brewtarget.savedState",
  ]
end
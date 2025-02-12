cask "brewtarget" do
  version "4.0.16"
  sha256 "d056aea8393929ac9f3c8913a6b17901847ace98358ed18b7877c0acf3990f95"

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
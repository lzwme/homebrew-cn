cask "brewtarget" do
  version "4.1.0"
  sha256 "54a1771b4e13762c5c31c3e367bb94d62855106bd074f2c8a1f126f7db9c9ccb"

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
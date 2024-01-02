cask "flying-carpet" do
  version "8.0.1"
  sha256 "8002868545273069959a3343146212bbf16587e9727dcd8dbd604e160caa983f"

  url "https:github.comspiegltFlyingCarpetreleasesdownloadv#{version}macOS_FlyingCarpet_#{version}_universal.dmg"
  name "Flying Carpet"
  desc "File transfer over ad-hoc wifi"
  homepage "https:github.comspiegltflyingcarpet"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "FlyingCarpet.app"

  zap trash: [
    "~LibraryCachesdev.spiegl",
    "~LibraryPreferencescom.yourcompany.flyingcarpet.plist",
    "~LibraryPreferencesdev.spiegl.plist",
    "~LibrarySaved Application Statecom.yourcompany.flyingcarpet.savedState",
    "~LibrarySaved Application Statedev.spiegl.savedState",
    "~LibraryWebKitdev.spiegl",
  ]
end
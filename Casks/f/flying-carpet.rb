cask "flying-carpet" do
  version "8.0"
  sha256 "66f1ca862c28fb5a4b3c35a03d2f9e57b2a4d551b2b5e8cc7d0218f93b30c3c3"

  url "https:github.comspiegltFlyingCarpetreleasesdownloadv#{version}macOS_FlyingCarpet_#{version}.0_universal.dmg"
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
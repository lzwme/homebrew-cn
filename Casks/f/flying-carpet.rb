cask "flying-carpet" do
  version "7.1"
  sha256 "f9c3a2ee3328ef92688c51f84e5f6b2495fd8497626ade634b2359becc467bf0"

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
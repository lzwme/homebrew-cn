cask "only-switch" do
  version "2.5.6"
  sha256 "4472026c40f7b0bad13fa70aa679a537e5ae6ec8db026d4f6926c285338e335b"

  url "https:github.comjacklandrinOnlySwitchreleasesdownloadrelease_#{version}OnlySwitch.dmg"
  name "OnlySwitch"
  desc "System and utility switches"
  homepage "https:github.comjacklandrinOnlySwitch"

  livecheck do
    url "https:jacklandrin.github.ioappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Only Switch.app"

  zap trash: [
    "~LibraryApplication SupportOnlySwitch",
    "~LibraryCachesjacklandrin.OnlySwitch",
    "~LibraryOnlySwitch",
    "~LibraryPreferencesjacklandrin.OnlySwitch.plist",
  ]
end
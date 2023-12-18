cask "only-switch" do
  version "2.4.6"
  sha256 "4518af66f72f3524127ea9945d40bd0c58ff0aff010df11c1620a85f10becb94"

  url "https:github.comjacklandrinOnlySwitchreleasesdownloadrelease_#{version}OnlySwitch.dmg"
  name "OnlySwitch"
  desc "System and utility switches"
  homepage "https:github.comjacklandrinOnlySwitch"

  livecheck do
    url :url
    regex(release[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "Only Switch.app"

  zap trash: [
    "~LibraryApplication SupportOnlySwitch",
    "~LibraryCachesjacklandrin.OnlySwitch",
    "~LibraryOnlySwitch",
    "~LibraryPreferencesjacklandrin.OnlySwitch.plist",
  ]
end
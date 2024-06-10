cask "only-switch" do
  version "2.5.2"
  sha256 "169e4c71d7a63443b4375949669c15e683da3c2f8af885f916eb62162b43be44"

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
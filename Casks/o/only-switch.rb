cask "only-switch" do
  version "2.5.3"
  sha256 "662422e16f1f1a89f47962709cfe8b04c9ea1d85f29d9f7a59878e6cd1f71910"

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
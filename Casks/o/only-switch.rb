cask "only-switch" do
  version "2.5.5"
  sha256 "4473085f4a41809cbf2282e43fe5d98dd5434489eaf467b85ea7bc588516fcfa"

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
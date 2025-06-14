cask "gswitch" do
  version "1.9.7"
  sha256 "5d212c1bd39f6bfae588797fa09b959051dc4eefd26ec05fbd26b798125b976a"

  url "https:github.comCodySchrankgSwitchreleasesdownload#{version}gSwitch.zip",
      verified: "github.comCodySchrankgSwitch"
  name "gSwitch"
  desc "Set which graphics card to use"
  homepage "https:codyschrank.github.iogSwitch"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "gSwitch.app"

  zap trash: [
    "~LibraryCachesgSwitch",
    "~LibraryPreferencescom.CodySchrank.gSwitch.plist",
  ]

  caveats do
    requires_rosetta
  end
end
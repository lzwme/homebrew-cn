cask "autopkgr" do
  version "1.6.1"
  sha256 "598aa227ef544d37b7f964c1352e6f2d955fc5a8127cc2a708e7bc02af2cc7f0"

  url "https:github.comlindegroupautopkgrreleasesdownloadv#{version}AutoPkgr-#{version}.dmg",
      verified: "github.comlindegroupautopkgr"
  name "AutoPkgr"
  desc "Install and configure AutoPkg"
  homepage "https:www.lindegroup.comautopkgr"

  livecheck do
    url "https:raw.githubusercontent.comlindegroupautopkgrappcastappcast.xml"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "AutoPkgr.app"

  zap trash: [
    "~LibraryApplication SupportAutoPkgr",
    "~LibraryCachescom.lindegroup.AutoPkgr",
    "~LibraryHTTPStoragescom.lindegroup.AutoPkgr",
    "~LibraryHTTPStoragescom.lindegroup.AutoPkgr.binarycookies",
    "~LibraryPreferencescom.lindegroup.AutoPkgr.plist",
  ]

  caveats do
    requires_rosetta
  end
end
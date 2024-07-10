cask "autopkgr" do
  version "1.6.1"
  sha256 "598aa227ef544d37b7f964c1352e6f2d955fc5a8127cc2a708e7bc02af2cc7f0"

  url "https:github.comlindegroupautopkgrreleasesdownloadv#{version}AutoPkgr-#{version}.dmg",
      verified: "github.comlindegroupautopkgr"
  name "AutoPkgr"
  desc "Install and configure AutoPkg"
  homepage "https:www.lindegroup.comautopkgr"

  depends_on macos: ">= :high_sierra"

  app "AutoPkgr.app"

  caveats do
    requires_rosetta
  end
end
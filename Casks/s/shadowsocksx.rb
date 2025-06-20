cask "shadowsocksx" do
  version "2.6.3"
  sha256 "f0e263dd1d74b0b6977389f2b8b28c524bceccbc5ad24ca8a8164b92ede1c45a"

  url "https:github.comshadowsocksshadowsocks-iOSreleasesdownload#{version}ShadowsocksX-#{version}.dmg"
  name "ShadowsocksX"
  desc "Removed according to regulations"
  homepage "https:github.comshadowsocksshadowsocks-iOSwikiShadowsocks-for-OSX-Help"

  no_autobump! because: :requires_manual_review

  conflicts_with cask: "shadowsocksx-ng-r"

  app "ShadowsocksX.app"

  caveats do
    requires_rosetta
  end
end
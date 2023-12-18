cask "shadowsocksx-ng" do
  version "1.10.2"
  sha256 "e4d0388d40c86db70c8bb8c0950207845a4e33217010b811aac1d1562762502e"

  url "https:github.comshadowsocksShadowsocksX-NGreleasesdownloadv#{version}ShadowsocksX-NG.dmg"
  name "ShadowsocksX-NG"
  desc "Tunneling proxy"
  homepage "https:github.comshadowsocksShadowsocksX-NG"

  conflicts_with cask: "shadowsocksx"
  depends_on macos: ">= :sierra"

  app "ShadowsocksX-NG.app"

  uninstall delete:    "LibraryApplication SupportShadowsocksX-NG",
            launchctl: [
              "com.qiuyuzhou.shadowsocksX-NG.http",
              "com.qiuyuzhou.shadowsocksX-NG.kcptun",
              "com.qiuyuzhou.shadowsocksX-NG.local",
              "com.qiuyuzhou.ShadowsocksX-NG.LaunchHelper",
            ],
            quit:      "com.qiuyuzhou.ShadowsocksX-NG",
            script:    {
              executable: "#{appdir}ShadowsocksX-NG.appContentsResourcesproxy_conf_helper",
              args:       ["--mode", "off"],
              sudo:       true,
            }

  zap trash: [
    "~.ShadowsocksX-NG",
    "~LibraryApplication SupportShadowsocksX-NG",
    "~LibraryCachescom.qiuyuzhou.ShadowsocksX-NG",
    "~LibraryPreferencescom.qiuyuzhou.ShadowsocksX-NG.plist",
  ]
end
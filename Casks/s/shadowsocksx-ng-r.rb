cask "shadowsocksx-ng-r" do
  version "1.4.4-r8-resigning"
  sha256 "9353980f35f78a9d16951f28d036f5647a2f5a5c1a79f6480cc4b2852bc77e57"

  url "https:github.comqinyuhangShadowsocksX-NG-Rreleasesdownload#{version}ShadowsocksX-NG-R8.dmg"
  name "ShadowsocksX-NG-R"
  desc "Next Generation of ShadowsocksX"
  homepage "https:github.comqinyuhangShadowsocksX-NG-R"

  no_autobump! because: :requires_manual_review

  conflicts_with cask: "shadowsocksx"
  depends_on macos: ">= :el_capitan"

  app "ShadowsocksX-NG-R8.app"

  postflight do
    system_command "#{appdir}ShadowsocksX-NG-R8.appContentsResourcesinstall_helper.sh"
  end

  uninstall launchctl: [
              "com.qiuyuzhou.shadowsocksX-NG.http",
              "com.qiuyuzhou.shadowsocksX-NG.kcptun",
              "com.qiuyuzhou.ShadowsocksX-NG.LaunchHelper",
              "com.qiuyuzhou.shadowsocksX-NG.local",
            ],
            quit:      "com.qiuyuzhou.ShadowsocksX-NG",
            script:    {
              executable: "LibraryApplication SupportShadowsocksX-NGproxy_conf_helper",
              args:       ["--mode", "off"],
            },
            delete:    "LibraryApplication SupportShadowsocksX-NG"

  zap trash: [
    "~.ShadowsocksX-NG",
    "~LibraryApplication SupportShadowsocksX-NG",
    "~LibraryCachescom.qiuyuzhou.ShadowsocksX-NG",
    "~LibraryPreferencescom.qiuyuzhou.ShadowsocksX-NG.plist",
  ]

  caveats do
    requires_rosetta
  end
end
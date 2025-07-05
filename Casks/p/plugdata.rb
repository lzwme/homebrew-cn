cask "plugdata" do
  version "0.9.1"
  sha256 "ae45c3a214e56035b6aa663a92919de4d2f5b4b316778194436749a5fdbbc1b6"

  url "https://ghfast.top/https://github.com/plugdata-team/plugdata/releases/download/v#{version}/plugdata-macOS-Universal.pkg",
      verified: "github.com/plugdata-team/plugdata/"
  name "PlugData"
  desc "Plugin wrapper for PureData"
  homepage "https://plugdata.org/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  conflicts_with cask: "plugdata@nightly"

  pkg "plugdata-macOS-Universal.pkg"

  uninstall pkgutil: [
    "com.plugdata.app.pkg.plugdata",
    "com.plugdata.au.pkg.plugdata",
    "com.plugdata.clap.pkg.plugdata",
    "com.plugdata.lv2.pkg.plugdata",
    "com.plugdata.vst3.pkg.plugdata",
  ]

  zap trash: [
    "~/Library/Application Support/PlugData.settings",
    "~/Library/Caches/com.PlugData.PlugDataStandalone",
    "~/Library/Caches/PlugData",
    "~/Library/HTTPStorages/com.PlugData.PlugDataStandalone",
    "~/Library/PlugData",
    "~/Library/Preferences/com.PlugData.PlugDataStandalone.plist",
  ]
end
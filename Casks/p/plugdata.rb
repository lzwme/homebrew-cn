cask "plugdata" do
  version "0.8.1"
  sha256 "1678c721422c94b2278e336b88afb066f9853564b1766ecd1ac56c16e190509d"

  url "https://ghproxy.com/https://github.com/timothyschoen/PlugData/releases/download/v#{version}/plugdata-macOS-Universal.pkg"
  name "PlugData"
  desc "Plugin wrapper for PureData"
  homepage "https://github.com/timothyschoen/PlugData"

  auto_updates true

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
    "~/Library/Caches/PlugData",
    "~/Library/Caches/com.PlugData.PlugDataStandalone",
    "~/Library/HTTPStorages/com.PlugData.PlugDataStandalone",
    "~/Library/PlugData",
    "~/Library/Preferences/com.PlugData.PlugDataStandalone.plist",
  ]
end
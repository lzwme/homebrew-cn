cask "plugdata" do
  version "0.8.2"
  sha256 "9507f316d36593f5ca13b15eda26640279b71dd2bd383030d0a18b4fa9120864"

  url "https:github.comtimothyschoenPlugDatareleasesdownloadv#{version}plugdata-macOS-Universal.pkg"
  name "PlugData"
  desc "Plugin wrapper for PureData"
  homepage "https:github.comtimothyschoenPlugData"

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
    "~LibraryApplication SupportPlugData.settings",
    "~LibraryCachesPlugData",
    "~LibraryCachescom.PlugData.PlugDataStandalone",
    "~LibraryHTTPStoragescom.PlugData.PlugDataStandalone",
    "~LibraryPlugData",
    "~LibraryPreferencescom.PlugData.PlugDataStandalone.plist",
  ]
end
cask "plugdata" do
  version "0.8.3"
  sha256 "f1dc46b31d6ded4c6ab578fd00ab57faa666eec69ec79c5daf565c4a6b2a9be3"

  url "https:github.comtimothyschoenPlugDatareleasesdownloadv#{version}plugdata-macOS-Universal.pkg"
  name "PlugData"
  desc "Plugin wrapper for PureData"
  homepage "https:github.comtimothyschoenPlugData"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

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
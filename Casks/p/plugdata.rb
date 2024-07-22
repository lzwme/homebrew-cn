cask "plugdata" do
  version "0.9.0"
  sha256 "8d90e6c6c9671a5f48263c77ec61d256d29f8e58fa0f99ad8f246a541e6ef703"

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
    "~LibraryCachescom.PlugData.PlugDataStandalone",
    "~LibraryCachesPlugData",
    "~LibraryHTTPStoragescom.PlugData.PlugDataStandalone",
    "~LibraryPlugData",
    "~LibraryPreferencescom.PlugData.PlugDataStandalone.plist",
  ]
end
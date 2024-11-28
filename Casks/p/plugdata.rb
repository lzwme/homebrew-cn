cask "plugdata" do
  version "0.9.1"
  sha256 "ae45c3a214e56035b6aa663a92919de4d2f5b4b316778194436749a5fdbbc1b6"

  url "https:github.complugdata-teamplugdatareleasesdownloadv#{version}plugdata-macOS-Universal.pkg",
      verified: "github.complugdata-teamplugdata"
  name "PlugData"
  desc "Plugin wrapper for PureData"
  homepage "https:plugdata.org"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

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
    "~LibraryApplication SupportPlugData.settings",
    "~LibraryCachescom.PlugData.PlugDataStandalone",
    "~LibraryCachesPlugData",
    "~LibraryHTTPStoragescom.PlugData.PlugDataStandalone",
    "~LibraryPlugData",
    "~LibraryPreferencescom.PlugData.PlugDataStandalone.plist",
  ]
end
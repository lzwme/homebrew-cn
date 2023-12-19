cask "easydict" do
  version "2.4.1"
  sha256 "64bfbfb5419ddabb7aae023b70576a9f6a6f26d1eb0cb7628998e732182f9e1e"

  url "https:github.comtisfengEasydictreleasesdownload#{version}Easydict.dmg"
  name "Easydict"
  desc "Dictionary and translator app"
  homepage "https:github.comtisfengEasydict"

  auto_updates true

  app "Easydict.app"

  zap trash: [
    "~LibraryApplication Supportcom.izual.Easydict",
    "~LibraryCachescom.izual.Easydict",
    "~LibraryCachescom.plausiblelabs.crashreporter.datacom.izual.Easydict",
    "~LibraryHTTPStoragescom.izual.Easydict",
    "~LibraryHTTPStoragescom.izual.Easydict.binarycookies",
    "~LibraryPreferencescom.izual.Easydict.plist",
    "~LibraryWebKitcom.izual.Easydict",
  ]
end
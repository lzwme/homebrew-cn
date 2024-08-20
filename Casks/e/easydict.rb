cask "easydict" do
  version "2.8.1"
  sha256 "355a8c74c5d633dc81ecabe2f566c82604a5e2d39b23c751d8cc9e05282c7e28"

  url "https:github.comtisfengEasydictreleasesdownload#{version}Easydict.dmg"
  name "Easydict"
  desc "Dictionary and translator app"
  homepage "https:github.comtisfengEasydict"

  auto_updates true
  depends_on macos: ">= :big_sur"

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
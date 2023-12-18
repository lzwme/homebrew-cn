cask "easydict" do
  version "2.3.0"
  sha256 "a26eed80b45cd3c8210cf4b4e534c65ffd1f2443b1dfd6692fe624cc2eb7ad09"

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
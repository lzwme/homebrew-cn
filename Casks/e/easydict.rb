cask "easydict" do
  version "2.6.0"
  sha256 "0fe4c1e76c21fa3017a1a72176a858ebe64bfe86d9a894dd6a04fc2bcb01f8af"

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
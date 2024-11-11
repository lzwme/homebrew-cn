cask "easydict" do
  version "2.10.1"
  sha256 "8178edd24b8dd9424b41905cc3b74789f3b424d7818683c10ef3d179d1298ce3"

  url "https:github.comtisfengEasydictreleasesdownload#{version}Easydict.dmg"
  name "Easydict"
  desc "Dictionary and translator app"
  homepage "https:github.comtisfengEasydict"

  livecheck do
    url :url
    strategy :github_latest
  end

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
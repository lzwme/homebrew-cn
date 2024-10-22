cask "cork" do
  version "1.4.6.1"
  sha256 "1299c1815bbae120312b7eaf031feb48bcb1b5f2c21ccde2c445a9323eebd4dc"

  url "https:github.comburesdvCorkreleasesdownloadv#{version}Cork.zip",
      verified: "github.comburesdvCork"
  name "Cork"
  desc "GUI companion app for Homebrew"
  homepage "https:www.corkmac.app"

  depends_on macos: ">= :ventura"

  app "Cork.app"

  zap trash: [
    "~DocumentsCork",
    "~LibraryCachescom.davidbures.cork",
    "~LibraryHTTPStoragescom.davidbures.cork",
    "~LibraryPreferencescom.davidbures.cork.plist",
    "~LibrarySaved Application Statecom.davidbures.cork.savedState",
  ]
end
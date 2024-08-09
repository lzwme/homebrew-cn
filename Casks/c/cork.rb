cask "cork" do
  version "1.4.4.2"
  sha256 "b1b64b87ce202e844397a2f6935e7b5bb2029df21da7b2a30c2a06de1ac6dc67"

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
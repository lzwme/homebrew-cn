cask "cork" do
  version "1.4.5.2"
  sha256 "98cd7cd6b37ec170f62c08859aa0c8d49510cf4dfcccbd077b63e2356f756cc4"

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
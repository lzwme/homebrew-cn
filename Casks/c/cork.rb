cask "cork" do
  version "1.5.1"
  sha256 "29a29e14cb1b60366466065b263e1a64c22a28e6c625be3fe14fc472a6ae7dc1"

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
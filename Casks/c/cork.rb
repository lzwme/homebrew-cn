cask "cork" do
  version "1.4.5"
  sha256 "f4d51f0afc50406f9b9eb55bd777dbb0235f6f0fe507ed5f27cd71b8e10e79ca"

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
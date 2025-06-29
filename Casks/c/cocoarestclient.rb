cask "cocoarestclient" do
  version "1.4.7"
  sha256 "8e974818e5b77e6e4291acbe09d439c3c17b01c23e48d2272f7817e2d18e9968"

  url "https:github.commmattozzicocoa-rest-clientreleasesdownload#{version}CocoaRestClient-#{version}.dmg",
      verified: "github.commmattozzicocoa-rest-client"
  name "CocoaRestClient"
  desc "App for testing HTTPREST endpoints"
  homepage "https:mmattozzi.github.iococoa-rest-client"

  livecheck do
    url "https:mmattozzi.github.iococoa-rest-clientappcast.xml"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :mojave"

  app "CocoaRestClient.app"

  zap trash: [
    "~LibraryApplication SupportCocoaRestClient",
    "~LibraryHTTPStoragesorg.restlesscode.cocoarestclient",
    "~LibraryPreferencesorg.restlesscode.cocoarestclient.plist",
    "~LibrarySaved Application Stateorg.restlesscode.cocoarestclient.savedState",
  ]
end
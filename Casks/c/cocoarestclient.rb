cask "cocoarestclient" do
  version "1.4.7"
  sha256 "8e974818e5b77e6e4291acbe09d439c3c17b01c23e48d2272f7817e2d18e9968"

  url "https://ghfast.top/https://github.com/mmattozzi/cocoa-rest-client/releases/download/#{version}/CocoaRestClient-#{version}.dmg",
      verified: "github.com/mmattozzi/cocoa-rest-client/"
  name "CocoaRestClient"
  desc "App for testing HTTP/REST endpoints"
  homepage "https://mmattozzi.github.io/cocoa-rest-client/"

  livecheck do
    url "https://mmattozzi.github.io/cocoa-rest-client/appcast.xml"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :mojave"

  app "CocoaRestClient.app"

  zap trash: [
    "~/Library/Application Support/CocoaRestClient",
    "~/Library/HTTPStorages/org.restlesscode.cocoarestclient",
    "~/Library/Preferences/org.restlesscode.cocoarestclient.plist",
    "~/Library/Saved Application State/org.restlesscode.cocoarestclient.savedState",
  ]
end
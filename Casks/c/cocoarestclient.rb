cask "cocoarestclient" do
  version "1.4.7"
  sha256 "8e974818e5b77e6e4291acbe09d439c3c17b01c23e48d2272f7817e2d18e9968"

  url "https:github.commmattozzicocoa-rest-clientreleasesdownload#{version}CocoaRestClient-#{version}.dmg",
      verified: "github.commmattozzicocoa-rest-client"
  name "CocoaRestClient"
  desc "App for testing HTTPREST endpoints"
  homepage "https:mmattozzi.github.iococoa-rest-client"

  depends_on macos: ">= :mojave"

  app "CocoaRestClient.app"
end
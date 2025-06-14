cask "dteoh-devdocs" do
  version "0.7.0"
  sha256 "3355a10fa94f4eea3693620cb9403b4a5d51c5bfa9f91bc592d9fd65f59024da"

  url "https:github.comdteohdevdocs-macosreleasesdownloadv#{version}DevDocs.zip"
  name "DevDocs"
  desc "API documentation viewer"
  homepage "https:github.comdteohdevdocs-macos"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "DevDocs.app"

  zap trash: [
    "~LibraryCachescom.dteoh.devdocs-macos",
    "~LibraryCookiescom.dteoh.devdocs-macos.binarycookies",
    "~LibraryPreferencescom.dteoh.devdocs-macos.plist",
    "~LibraryWebKitcom.dteoh.devdocs-macos",
  ]
end
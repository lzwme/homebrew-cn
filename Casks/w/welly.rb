cask "welly" do
  version "3.2.0"
  sha256 "504219867e8ceb625d51fc25c7d3e7488db1eca4877a8734aca5bb9494d5f695"

  url "https:github.comclyangwellyreleasesdownload#{version}Welly.v.#{version}.zip"
  name "Welly"
  desc "BBS client"
  homepage "https:github.comclyangwelly"

  auto_updates true

  app "Welly.app"

  zap trash: [
    "~LibraryApplication SupportWelly",
    "~LibraryCachesWelly",
    "~LibraryCachesorg.net9.Welly",
    "~LibraryCookiesorg.net9.Welly.binarycookies",
    "~LibraryPreferencesorg.net9.Welly.plist",
  ]
end
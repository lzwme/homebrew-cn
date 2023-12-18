cask "gfxcardstatus" do
  version "2.5"
  sha256 "70d94cbf5d691c9530e974b5512a106e0bf532ab345fd911199928b8b11a3688"

  url "https:github.comcodykriegergfxCardStatusreleasesdownloadv#{version}gfxCardStatus-#{version}.zip",
      verified: "github.comcodykriegergfxCardStatus"
  name "gfxCardStatus"
  desc "Menu bar app to monitor graphics card usage"
  homepage "https:gfx.io"

  livecheck do
    url "https:gfx.ioappcast.xml"
    strategy :sparkle, &:short_version
  end

  app "gfxCardStatus.app"

  zap trash: [
    "~LibraryCachescom.codykrieger.gfxCardStatus",
    "~LibraryCookiescom.codykrieger.gfxCardStatus.binarycookies",
    "~LibraryPreferencescom.codykrieger.gfxCardStatus-Preferences.plist",
    "~LibraryPreferencescom.codykrieger.gfxCardStatus.plist",
  ]
end
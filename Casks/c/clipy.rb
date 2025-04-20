cask "clipy" do
  version "1.2.1"
  sha256 "dfbb66ce3135fbaa2d64eaeea99a63e63485e322c9746045a1098b1696a1ecd5"

  url "https:github.comClipyClipyreleasesdownload#{version}Clipy_#{version}.dmg",
      verified: "github.comClipyClipy"
  name "Clipy"
  desc "Clipboard extension app"
  homepage "https:clipy-app.com"

  livecheck do
    url "https:clipy-app.comappcast.xml"
    strategy :sparkle
  end

  auto_updates true

  app "Clipy.app"

  uninstall quit: "com.clipy-app.Clipy"

  zap trash: [
    "~LibraryApplication SupportClipy",
    "~LibraryApplication Supportcom.clipy-app.Clipy",
    "~LibraryCachescom.clipy-app.Clipy",
    "~LibraryCachescom.crashlytics.datacom.clipy-app.Clipy",
    "~LibraryCachesio.fabric.sdk.mac.datacom.clipy-app.Clipy",
    "~LibraryCookiescom.clipy-app.Clipy.binarycookies",
    "~LibraryPreferencescom.clipy-app.Clipy.plist",
  ]

  caveats do
    requires_rosetta
  end
end
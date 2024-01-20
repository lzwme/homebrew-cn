cask "onlyoffice" do
  arch arm: "arm", intel: "x86_64"

  version "7.5.1"
  sha256 arm:   "99f10cd3da1d797d03fb6da34e90c1695fa35411c999ded1390105ca846088f6",
         intel: "daf7c8500801665eb5369900ff77e60d0e4c8cfc99e023d59dc8583a4f0d7c54"

  url "https:github.comONLYOFFICEDesktopEditorsreleasesdownloadv#{version}ONLYOFFICE-#{arch}.dmg",
      verified: "github.comONLYOFFICEDesktopEditors"
  name "ONLYOFFICE"
  desc "Document editor"
  homepage "https:www.onlyoffice.com"

  livecheck do
    url :url
    regex((\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "ONLYOFFICE.app"

  zap trash: [
    "~LibraryApplication Supportasc.onlyoffice.ONLYOFFICE",
    "~LibraryPreferencesasc.onlyoffice.ONLYOFFICE.plist",
    "~LibraryPreferencesasc.onlyoffice.editors-helper-renderer.plist",
  ]
end
cask "onlyoffice" do
  arch arm: "arm", intel: "x86_64"

  version "8.2.0"
  sha256 arm:   "eb32bd0b17971b8ad2eca5cbea8554b08e6395bfe37d5d5194902b520dd69213",
         intel: "5c25589c0d18950b88aaff06ce476fa5e662ece3bdf15904b0e519277a3240b2"

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
    "~LibraryPreferencesasc.onlyoffice.editors-helper-renderer.plist",
    "~LibraryPreferencesasc.onlyoffice.ONLYOFFICE.plist",
  ]
end
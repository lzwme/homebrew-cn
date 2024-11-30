cask "onlyoffice" do
  arch arm: "arm", intel: "x86_64"

  version "8.2.2"
  sha256 arm:   "58c429492292872c44260afaccd45cbfa92aa2cc2851dd00b2e5e4317d5e3cd1",
         intel: "8b9d33e4d97276ebd027dc19036defa61bce92668ca61bd5f31148160bb5adf0"

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
cask "onlyoffice" do
  arch arm: "arm", intel: "x86_64"

  version "8.0.1"
  sha256 arm:   "a8b94cbbd8c5140fb4ad54aefe128985bdad1eb791917acaa32fbb3c9036e168",
         intel: "b8cbb67ac65d63c017a8551af41c1dc77f892b0b9f2356a0f461fb5adee04c54"

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
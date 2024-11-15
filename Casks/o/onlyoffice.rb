cask "onlyoffice" do
  arch arm: "arm", intel: "x86_64"

  version "8.2.1"
  sha256 arm:   "aa61c811f3f2f136b82f208c2e4292ab658b98242b7f528b2f8a7df8a820b177",
         intel: "cd3c642d1f165cb78ba3d458524638a0996fbd7e433d317b75c42cf0c00ab4f2"

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
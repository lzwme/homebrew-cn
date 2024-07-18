cask "onlyoffice" do
  arch arm: "arm", intel: "x86_64"

  version "8.1.1"
  sha256 arm:   "0c7203de5e4cce8f6f920bfd696663f59e50b8c0b70deec57c6d99e9378a58f7",
         intel: "0ca53ebbf4b0c624d2b830056f26ac2f4638240c17ee46a8882bc35ad586bec1"

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
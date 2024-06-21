cask "onlyoffice" do
  arch arm: "arm", intel: "x86_64"

  version "8.1.0"
  sha256 arm:   "f0fd55399141f9e6a0878888d16170645cb6343fdd11660981d428c18618efef",
         intel: "8f0816eba4dfeda12ba492ffc0de0308db6f38b51a8e105bc178da9a630ac2a8"

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
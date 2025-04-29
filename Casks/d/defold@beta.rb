cask "defold@beta" do
  arch arm: "arm64", intel: "x86_64"

  version "1.10.1"
  sha256 :no_check # required as upstream package is updated in-place

  url "https:github.comdefolddefoldreleasesdownload#{version}-betaDefold-#{arch}-macos.dmg",
      verified: "github.comdefolddefold"
  name "Defold"
  desc "Game engine for development of desktop, mobile and web games"
  homepage "https:defold.com"

  livecheck do
    url "http:d.defold.combetainfo.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  conflicts_with cask: [
    "defold",
    "defold@alpha",
  ]

  app "Defold.app"

  zap trash: [
    "~LibraryApplication SupportDefold",
    "~LibraryCachescom.defold.editor",
    "~LibraryPreferencescom.defold.editor.plist",
    "~LibrarySaved Application Statecom.defold.editor.savedState",
  ]
end
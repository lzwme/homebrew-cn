cask "defold@alpha" do
  arch arm: "arm64", intel: "x86_64"

  version "1.9.8"
  sha256 :no_check # required as upstream package is updated in-place

  url "https:github.comdefolddefoldreleasesdownload#{version}-alphaDefold-#{arch}-macos.dmg",
      verified: "github.comdefolddefold"
  name "Defold"
  desc "Game engine for development of desktop, mobile and web games"
  homepage "https:defold.com"

  livecheck do
    url "http:d.defold.comalphainfo.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  conflicts_with cask: [
    "defold",
    "defold@beta",
  ]

  app "Defold.app"

  zap trash: [
    "~LibraryApplication SupportDefold",
    "~LibraryCachescom.defold.editor",
    "~LibraryPreferencescom.defold.editor.plist",
    "~LibrarySaved Application Statecom.defold.editor.savedState",
  ]
end
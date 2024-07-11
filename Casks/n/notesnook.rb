cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.10"
  sha256 arm:   "ccf90ee2b0c42185f36130b042326b654d6a5d90cffa4c4e8f67be7b56fd1d08",
         intel: "3f06eb1e1ad29a938abeae44b7e11fad7d9b263d2d03e876d28b0d168b80cad8"

  url "https:github.comstreetwritersnotesnookreleasesdownloadv#{version}notesnook_mac_#{arch}.dmg",
      verified: "github.comstreetwritersnotesnook"
  name "Notesnook"
  desc "Privacy-focused note taking app"
  homepage "https:notesnook.com"

  livecheck do
    url "https:notesnook.comapiv1releasesdarwinlatestlatest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true

  app "Notesnook.app"

  zap trash: [
    "~LibraryApplication SupportNotesnook",
    "~LibraryLogsNotesnook",
    "~LibraryPreferencescom.streetwriters.notesnook.plist",
  ]
end
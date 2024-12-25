cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.23"
  sha256 arm:   "276654c4730159c0e9f4bf223edadab73eca32790e9ab1d9e4d978d8d112ffad",
         intel: "fd0f8e3decd56add350784468710296a8eca24ab061bdf8f371393e450042a36"

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
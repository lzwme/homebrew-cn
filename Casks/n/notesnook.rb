cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.12"
  sha256 arm:   "68ccf8dd5551b1e5b2324b1faa2748ad71cc5857aab87d959b2c280c261a37b4",
         intel: "b7b6b712717c7fcb08eef10bb8d654722caf0aa78329da587bd89d2964b51117"

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
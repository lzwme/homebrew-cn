cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "2.6.14"
  sha256 arm:   "79c96328dee7085d148aeb5e51cc0cfc39ed5bcd044b2aeb14f03e8221d96388",
         intel: "07ea2fee4913b539895894533f665fdbfb469e93a470211dc7cf84927fc41868"

  url "https:github.comstreetwritersnotesnookreleasesdownloadv#{version}notesnook_mac_#{arch}.dmg",
      verified: "github.comstreetwritersnotesnook"
  name "Notesnook"
  desc "Privacy-focused note taking app"
  homepage "https:notesnook.com"

  livecheck do
    url "https:notesnook.comreleasesdarwinlatest-mac.yml"
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
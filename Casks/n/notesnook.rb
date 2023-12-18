cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "2.6.12"
  sha256 arm:   "1b86e6740f000011f1be9bd852cdd08fc21d03af3505ab8e925ccf294074ea59",
         intel: "55561486a0143b9b3b3d496d0dd638beb2db43aba8f9569ba9a6bb00b3fe8308"

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
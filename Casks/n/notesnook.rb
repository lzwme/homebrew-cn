cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.27"
  sha256 arm:   "12503a4174e276ad6992b650f984d45e2b8cef8d5642231f3bfa8ffcef8c3ace",
         intel: "8de2180b2c1a36e4d2856bd0fbc8f430c662509e74bc1d67ff3e8f8a517179ec"

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
  depends_on macos: ">= :sierra"

  app "Notesnook.app"

  zap trash: [
    "~LibraryApplication SupportNotesnook",
    "~LibraryLogsNotesnook",
    "~LibraryPreferencescom.streetwriters.notesnook.plist",
  ]
end
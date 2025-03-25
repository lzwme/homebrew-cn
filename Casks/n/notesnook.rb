cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.31"
  sha256 arm:   "4078d3aceac7a31dc410d1a3f54336fef84cccae439569885840402ca12b993c",
         intel: "7a3f76062d8182f0801def24e273da3716758e496e1d439933e98e33b10bb663"

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
cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.25"
  sha256 arm:   "32c9d0966d308ba4ed1d05a18b6905a1ab28a4e5f4d64b35579c8e89d8e22eff",
         intel: "46354e6babd728eab788cfcd99370c9bf1684790bf5e6cdf5e42a2a5531e659f"

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
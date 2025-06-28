cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.2.3"
  sha256 arm:   "b2e10fe443fd60b0d7eed4932fe06cf85fd9f512f69c310f6d674d772fcf06b6",
         intel: "6cff73b312ae97c3da292b75f9c062b4fdbcf9487b6fbaf31ec3e2f77b6b3b21"

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
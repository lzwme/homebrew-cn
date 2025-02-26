cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.28"
  sha256 arm:   "bf7934aa32d7957f0b628c28c5bb21bef1546e8a901dfa551db5488c3748547d",
         intel: "1c9e74bacd13f776b504b13d08ffaf1cbfee4148e9ab87a582298c2a0a638233"

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
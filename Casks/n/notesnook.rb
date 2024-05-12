cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.4"
  sha256 arm:   "d742c633347ae9540826357a49ad6c21202b53665250a5ee9a7ed3f90010c3c6",
         intel: "89f28e1842e4714e2df1ae9233358321285b624568d93810a99547574198384b"

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
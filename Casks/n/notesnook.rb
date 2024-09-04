cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.17"
  sha256 arm:   "4b0770a9e1f154b9ceacec5a78823f813ac2f1f03246b4c05dd9e83b9663b586",
         intel: "fd152eff086057e97712530b4d8951c70f31b1db3a08ef099e73771d0d8ee8ff"

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
cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.0.24"
  sha256 arm:   "2ee056e1c5b0a02ae0053ce2ba99bcda49e692dc1f61c1c3bc1a8d9224ec474a",
         intel: "67d0e70b938217b14743bb2d9e0d063e9de06bf6ef0bb8d52901fd9a0a61d76b"

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
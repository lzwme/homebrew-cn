cask "crosspaste" do
  arch arm: "aarch64", intel: "amd64"

  version "1.0.12.1084"
  sha256 arm:   "478f7c07f6a7b843a6af874aa6c0e2ba3a1c9c89c88696bd991f2e7c6d08f7bb",
         intel: "d943674223b08aef976a427cb91adfcdb1225fb07a53a7571a2c03decbbd29ed"

  url "https:github.comCrossPastecrosspaste-desktopreleasesdownload#{version}crosspaste-#{version.major_minor_patch}-#{version.split(".").last}-mac-#{arch}.zip",
      verified: "github.comCrossPastecrosspaste-desktop"
  name "crosspaste"
  desc "Universal Pasteboard Across Devices"
  homepage "https:crosspaste.comen"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "CrossPaste.app"

  zap trash: [
    "~LibraryApplication SupportCrossPaste",
    "~LibraryHTTPStoragescom.crosspaste.mac",
    "~LibraryHTTPStoragescom.crosspaste.mac.binarycookies",
    "~LibraryLaunchAgentscom.crosspaste.mac.plist",
    "~LibraryPreferencescom.crosspaste.mac.plist",
  ]
end
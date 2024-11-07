cask "crosspaste" do
  arch arm: "aarch64", intel: "amd64"

  version "1.0.13.1121"
  sha256 arm:   "740d0d673fa08391252284b047d777ff24f3ef1ba389cee59744854df3ccded2",
         intel: "36d32abbb669bec140a95b01324e90f94b8f3b7f7ef223166a2347b6edc6e717"

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
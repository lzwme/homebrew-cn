cask "crosspaste" do
  arch arm: "aarch64", intel: "amd64"

  version "1.2.0.1444"
  sha256 arm:   "2a323b87a6bd52157d1501b80cd549ba4e4639ff7491243d7a9357d5fe26b05e",
         intel: "10f349c4172b6cb90929d571cc43087568834aaf73ff95e1805f2babaf7aaaee"

  url "https:github.comCrossPastecrosspaste-desktopreleasesdownload#{version}crosspaste-#{version.major_minor_patch}-#{version.split(".").last}-mac-#{arch}.zip",
      verified: "github.comCrossPastecrosspaste-desktop"
  name "CrossPaste"
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
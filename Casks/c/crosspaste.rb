cask "crosspaste" do
  arch arm: "aarch64", intel: "amd64"

  version "1.0.7.891"
  sha256 arm:   "8d9e1923ca2ae22ecca5ae41a8ee200b87364749f10b1aea4062df544694cf64",
         intel: "2233489dbba14c7ff6ffdc6f9b904b36b14bf66b43dfe5b54a7e1c0b9e42edb7"

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
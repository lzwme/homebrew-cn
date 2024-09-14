cask "crosspaste" do
  arch arm: "aarch64", intel: "amd64"

  version "1.0.9.974"
  sha256 arm:   "d6310ee849737f306e23170288b3fdf33e3505e4c513f692f70aa187b35ca56e",
         intel: "d9c893a944d3ce35c1aaddf0713f7d54a5806de818a3f1a9f01ab3472e10ef77"

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
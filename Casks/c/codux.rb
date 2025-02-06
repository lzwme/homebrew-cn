cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.42.0"
  sha256 arm:   "ddc8ca080956e8a27b82b85d6e3381447e3c975c9d22d0b04a1f004efe6a6909",
         intel: "15bf4ce82f2c0477abe7fe5c8172f0f684d7a7069e7f9461565893758f0ff092"

  url "https:github.comwixplosivescodux-versionsreleasesdownload#{version}Codux-#{version}.#{arch}.dmg",
      verified: "github.comwixplosivescodux-versions"
  name "Codux"
  desc "React IDE built to visually edit component styling and layouts"
  homepage "https:www.codux.com"

  livecheck do
    url "https:www.codux.comdownload"
    regex(href=.*?Codux[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}\.dmgi)
  end

  depends_on macos: ">= :big_sur"

  app "Codux.app"

  zap trash: [
    "~LibraryApplication SupportCodux",
    "~LibraryPreferencescom.wixc3.wcs.plist",
    "~LibrarySaved Application Statecom.wixc3.wcs.savedState",
  ]
end